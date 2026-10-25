package com.cfs.BookMyShowBE.controller;

import com.cfs.BookMyShowBE.dto.BookingResponse;
import com.cfs.BookMyShowBE.dto.CreateBookingRequest;
import com.cfs.BookMyShowBE.service.BookingService;
import org.springframework.data.repository.query.Param;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/bookings")
public class BookingController {

    private final BookingService bookingService;

    public BookingController(BookingService bookingService) {
        this.bookingService = bookingService;
    }

    @PostMapping("/shows/{showId}")
    @ResponseStatus(HttpStatus.CREATED)
    public BookingResponse book(@PathVariable("showId") Long showId, @RequestBody CreateBookingRequest request){
        return bookingService.book(showId,request);
    }

    @PostMapping("/{bookingId}/cancel")
    @ResponseStatus(HttpStatus.CREATED)
    public BookingResponse cancel(@PathVariable("bookingId") Long bookingId, @RequestBody Long profileId){
        return bookingService.cancel(bookingId,profileId);
    }

    @GetMapping("/{bookingId}")
    public BookingResponse find(@PathVariable("bookingId") Long bookingId){
        return bookingService.find(bookingId);
    }
}
