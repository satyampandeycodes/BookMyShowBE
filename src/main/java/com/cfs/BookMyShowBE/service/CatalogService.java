package com.cfs.BookMyShowBE.service;

import com.cfs.BookMyShowBE.dto.MovieResponse;
import com.cfs.BookMyShowBE.dto.ShowResponse;
import com.cfs.BookMyShowBE.dto.TheatreResponse;
import com.cfs.BookMyShowBE.entity.ShowSeat;
import com.cfs.BookMyShowBE.repository.MovieRepository;
import com.cfs.BookMyShowBE.repository.ShowRepository;
import com.cfs.BookMyShowBE.repository.ShowSeatRepository;
import com.cfs.BookMyShowBE.repository.ThreatreRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
public class CatalogService {
    public final MovieRepository movieRepository;
    public final ThreatreRepository threatreRepository;
    public final ShowRepository showRepository;
    public final ShowSeatRepository showSeatRepository;

    public CatalogService(MovieRepository movieRepository, ShowRepository showRepository, ShowSeatRepository showSeatRepository, ThreatreRepository threatreRepository) {
        this.movieRepository = movieRepository;
        this.showRepository = showRepository;
        this.showSeatRepository = showSeatRepository;
        this.threatreRepository = threatreRepository;
    }

    public List<MovieResponse> movies(){
        return movieRepository.findByActiveTrueOrderByTitle().stream().map(MovieResponse::from).toList();
    }

    public List<TheatreResponse> theatres(String city){
        return threatreRepository.findByCityIgnoreCaseOrderByName(city).stream().map(TheatreResponse::from).toList();
    }

    @Transactional
    public List<ShowResponse> shows(String city, LocalDate date){
        LocalDateTime from=date.atStartOfDay();
        return showRepository.findActiveShows(city,from,from.plusDays(1)).stream()
                .map(show -> {
                    List<String> labels = showSeatRepository.findAvailableLabels(show.getId());
                    if (labels.isEmpty()) {
                        int total = show.getTotalSeats() > 0 ? show.getTotalSeats() : 80;
                        List<ShowSeat> newSeats = new ArrayList<>();
                        for (int i = 0; i < total; i++) {
                            char row = (char) ('A' + (i / 10));
                            int num = (i % 10) + 1;
                            newSeats.add(new ShowSeat(show, "" + row + num));
                        }
                        showSeatRepository.saveAll(newSeats);
                        labels = showSeatRepository.findAvailableLabels(show.getId());
                    }
                    return ShowResponse.from(show, labels);
                }).toList();
    }
}
