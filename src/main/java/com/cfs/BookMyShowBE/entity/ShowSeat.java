package com.cfs.BookMyShowBE.entity;

import jakarta.persistence.*;

@Entity
@Table(name="show_seats",uniqueConstraints = @UniqueConstraint(name="uk_show_seat",columnNames={"show_id","seatLabel"}))
public class ShowSeat {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    public Long getId() {
        return id;
    }

    @ManyToOne(fetch = FetchType.LAZY,optional = false)
    private Show show;

    private String seatlabel;

    @Column(name = "reserved")
    private boolean reserved;

    public ShowSeat(){
    }

    public ShowSeat(Show show, String seatlabel) {
        this.show = show;
        this.seatlabel = seatlabel;
        this.reserved = false;
    }

    //design is fix that's why we don't make setter

    public String getSeatlabel(){
        return seatlabel;
    }

    public boolean isReserved(){
        return reserved;
    }

    public void reserve(){
        reserved=true;
    }

    public void reverse(){
        reserved=true;
    }

    public void release(){
        reserved=false;
    }
}
