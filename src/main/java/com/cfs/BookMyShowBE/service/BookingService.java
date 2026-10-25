package com.cfs.BookMyShowBE.service;

import com.cfs.BookMyShowBE.dto.BookingResponse;
import com.cfs.BookMyShowBE.dto.CreateBookingRequest;
import com.cfs.BookMyShowBE.entity.Booking;
import com.cfs.BookMyShowBE.entity.BookingStatus;
import com.cfs.BookMyShowBE.entity.Show;
import com.cfs.BookMyShowBE.entity.ShowSeat;
import com.cfs.BookMyShowBE.repository.BookingRepository;
import com.cfs.BookMyShowBE.repository.CustomerRepostitory;
import com.cfs.BookMyShowBE.repository.ShowRepository;
import com.cfs.BookMyShowBE.repository.ShowSeatRepository;
import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.List;

import java.awt.print.Book;
import java.util.Locale;

@Service
public class BookingService {

    private final ShowRepository showRepository;
    private final ShowSeatRepository showSeatRepository;
    private final BookingRepository bookingRepository;
    private final CustomerRepostitory customerRepostitory;

    public BookingService(ShowRepository showRepository, ShowSeatRepository showSeatRepository, BookingRepository bookingRepository, CustomerRepostitory customerRepostitory) {
        this.showRepository = showRepository;
        this.showSeatRepository = showSeatRepository;
        this.bookingRepository = bookingRepository;
        this.customerRepostitory = customerRepostitory;
    }

    @Transactional
    public BookingResponse book(Long showId, CreateBookingRequest request){
        Show show = showRepository.findById(showId).orElseThrow(()-> new ResourceNotFoundException("Show not found"));
        var customer= customerRepostitory.findById(request.getProfileId())
                .orElseThrow(()->new RuntimeException("Profile not found"));

        List<String> labels= request.getSeatLabel().stream()
                .map(lable-> lable.trim().toUpperCase(Locale.ROOT)).toList();

        if(labels.stream().distinct().count()!= labels.size()){
            throw new SeatUnavailableException("Duplicate seat labels are not allowed");
        }

        List<ShowSeat> seats= showSeatRepository.findForUpdate(showId,labels);
        if (seats.isEmpty() && showSeatRepository.findAvailableLabels(showId).isEmpty()) {
            int total = show.getTotalSeats() > 0 ? show.getTotalSeats() : 80;
            List<ShowSeat> newSeats = new java.util.ArrayList<>();
            for (int i = 0; i < total; i++) {
                char row = (char) ('A' + (i / 10));
                int num = (i % 10) + 1;
                newSeats.add(new ShowSeat(show, "" + row + num));
            }
            showSeatRepository.saveAll(newSeats);
            seats = showSeatRepository.findForUpdate(showId, labels);
        }
        if(seats.size()!= labels.size() || seats.stream().anyMatch(ShowSeat::isReserved)){
            throw  new SeatUnavailableException("One or more selected seats are unavailable");
        }
        seats.forEach(ShowSeat::reverse); //java 8
        show.reserve(labels.size());   //reserve show and also labels reverse

        BigDecimal total= show.getTicketPrice().multiply(BigDecimal.valueOf(labels.size()));
        Booking booking=bookingRepository.save(new Booking(show,customer,total,labels));
        return BookingResponse.from(booking);
    }

    @Transactional
    public BookingResponse find(Long bookingId){
        Booking booking=bookingRepository.findById(bookingId).orElseThrow(()->new ResourceNotFoundException("Booking not foung"));

         return BookingResponse.from(booking);
    }

    public List<BookingResponse> findByProfileId(Long profileId){
        if(!customerRepostitory.existsById(profileId)){
            throw new ResourceNotFoundException("Profile not found");
        }
        List<BookingResponse>list= bookingRepository.findByCustomerIdOrderByBookedAtDesc(profileId).stream().map(BookingResponse::from).toList();
        return list;
    }

    @Transactional
    public BookingResponse cancel(Long bookingId,Long profileId){
        Booking booking=bookingRepository.findByIdAndCustomerId(bookingId,profileId)
                .orElseThrow(()->new ResourceNotFoundException("Booking not found"));
        if(booking.getStatus()== BookingStatus.CONFIRMED){
            List<ShowSeat> seats=showSeatRepository.findForUpdate(booking.getShow().getId(), booking.getSeatLabel());
            seats.forEach(ShowSeat::release);
            booking.getShow().release(booking.getSeatLabel().size());
            booking.cancel();
        }
        return BookingResponse.from(booking);
    }
}
