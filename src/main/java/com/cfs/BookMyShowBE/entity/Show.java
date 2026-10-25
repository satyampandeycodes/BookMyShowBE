package com.cfs.BookMyShowBE.entity;

import jakarta.persistence.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Entity
@Table(name="shows")
public class Show {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY,optional = false) //when user ask to load movie data then only it load movie data
    private Movie movie;

    @ManyToOne(fetch = FetchType.LAZY,optional = false)
    private Theatre theatre;

    private LocalDateTime startsAt;

    private LocalDateTime endAt;

    private BigDecimal ticketPrice;

    private int totalSeats;
    private int availableSeats;

    private boolean active=true;

    @Version
    public long version;

    public Show(){

    }

    public Show(Movie movie, Theatre theatre, LocalDateTime startsAt, LocalDateTime endAt, BigDecimal ticketPrice, int totalSeats) {
        this.movie = movie;
        this.theatre = theatre;
        this.startsAt = startsAt;
        this.endAt = endAt;
        this.totalSeats = totalSeats;
        this.ticketPrice=ticketPrice;
    }

    public Long getId() {
        return id;
    }

    public Movie getMovie() {
        return movie;
    }

    public Theatre getTheatre() {
        return theatre;
    }

    public LocalDateTime getStartAt() {
        return startsAt;
    }

    public LocalDateTime getEndAt() {
        return endAt;
    }

    public int getTotalSeats() {
        return totalSeats;
    }

    public int getAvailableSeats() {
        return availableSeats;
    }

    public boolean isActive() {
        return active;
    }

    public long getVersion() {
        return version;
    }

    public BigDecimal getTicketPrice() {
        return ticketPrice;
    }

    public void setTicketPrice(BigDecimal ticketPrice) {
        this.ticketPrice = ticketPrice;
    }

    public void reserve(int seats){
        if(seats<=0 || seats> availableSeats){
            throw  new IllegalArgumentException("Not enough Seat Available");
        }
        else availableSeats=availableSeats-seats;
    }

    public void release(int seats){
        availableSeats=availableSeats+seats;
    }
}


