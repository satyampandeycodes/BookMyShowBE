package com.cfs.BookMyShowBE.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import jakarta.validation.constraints.Size;

public record CreateProfileRequest(
        @NotBlank @Size(max=100) String name,
        @NotBlank @Size(max=100) String email,
        @NotBlank @Pattern(regexp = "^[0-9+()\\- ]{10,20}$", message = "Enter a valid phone number") String phone) {

}
