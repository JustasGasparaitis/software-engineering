package com.company;

public class InvalidCSVFileException extends Exception {
    public InvalidCSVFileException(String errorMessage) {
        super(errorMessage);
    }
}
