package com.cfs.BookMyShowBE.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

import java.util.List;

public class CreateBookingRequest {

    @NotNull Long profileId;
    @NotEmpty @Size(max=8)
    List<@NotBlank String> seatLabel;

    public Long getProfileId() {
        return profileId;
    }

    public List<String> getSeatLabel() {
        return seatLabel;
    }
}
