package user_info;

import java.util.ArrayList;
import java.util.Date;
import java.util.Scanner;

public class Card {

    private Person cardHolder;
    private String type;
    private String cardNumber;
    private String expDate;
    private int pin;

    //---------------------------------------------------------------
    private double creditLimit;
    private double outstandingBalance;
    //----------------------------------------------------------------
    private double availableBalance;
    private double originalBalance;
    private double originalSavingsBalance;
    private double availableSavingsBalance;
    //-----------------------------------------------------------------

    ArrayList<Date> atmTimeStamps1;


    //------------------------------------------------------------------


    public Card(Person cardHolder, String type, String cardNumber, String expDate, double creditLimit, double outstandingBalance) {
        this.cardHolder = cardHolder;
        this.type = type;
        this.cardNumber = cardNumber;
        this.expDate = expDate;

        this.creditLimit = creditLimit;
        this.outstandingBalance = outstandingBalance;

        atmTimeStamps1 = new ArrayList<>();

    }

    public Card(Person cardHolder, String type, String cardNumber, String expDate, double availableBalance, double originalBalance, double availableSavingsBalance, double originalSavingsBalance ,int pin) {
        this.cardHolder = cardHolder;
        this.type = type;
        this.cardNumber = cardNumber;
        this.expDate = expDate;
        this.pin = pin;
        this.originalBalance = originalBalance;
        this.originalSavingsBalance = originalSavingsBalance;

        this.availableBalance = availableBalance;
        this.availableSavingsBalance = availableSavingsBalance;

        atmTimeStamps1 = new ArrayList<>();
    }

    public double getOriginalSavingsBalance() {
        return originalSavingsBalance;
    }

    public void setOriginalSavingsBalance(double originalSavingsBalance) {
        this.originalSavingsBalance = originalSavingsBalance;
    }

    public double getOriginalBalance() {
        return originalBalance;
    }

    public void setOriginalBalance(double originalBalance) {
        this.originalBalance = originalBalance;
    }

    public Person getCardHolder() {
        return cardHolder;
    }

    public void setCardHolder(Person cardHolder) {
        this.cardHolder = cardHolder;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public String getExpDate() {
        return expDate;
    }

    public void setExpDate(String expDate) {
        this.expDate = expDate;
    }

    public int getPin() {
        return pin;
    }

    public void setPin(int pin) {
        this.pin = pin;
    }

    public double getCreditLimit() {
        return creditLimit;
    }

    public void setCreditLimit(double creditLimit) {
        this.creditLimit = creditLimit;
    }

    public double getOutstandingBalance() {
        return outstandingBalance;
    }

    public void setOutstandingBalance(double outstandingBalance) {
        this.outstandingBalance = outstandingBalance;
    }

    public double getAvailableBalance() {
        return availableBalance;
    }

    public void setAvailableBalance(double availableBalance) {
        this.availableBalance = availableBalance;
    }

    public double getAvailableSavingsBalance() {
        return availableSavingsBalance;
    }

    public void setAvailableSavingsBalance(double availableSavingsBalance) {
        this.availableSavingsBalance = availableSavingsBalance;
    }

    public void depositCheckings(double amount){


        this.availableBalance += amount;

    }

    public void withdrawalCheckings(double amount){

        this.availableBalance -= amount;


    }

    public void depositSavings(double amount){


        this.availableSavingsBalance += amount;

    }

    public void withdrawalSavings(double amount){

        this.availableSavingsBalance -= amount;


    }
}
