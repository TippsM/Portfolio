package bank;

import java.text.SimpleDateFormat;
import java.util.Date;
import user_info.Person;

public class Transactions {

    String cardNumber;
    private String person;
    private String transactionType;
    private String accountType;
    private double amount;
    private double originalBalance;
    private double availableBalance;
    private double originalOutStandingBalance;
    private double newOutStandingBalance;




    //-----------------------------------------------------------------


    public Transactions(String cardNumber, String person, String transactionType, String accountType, double availableBalance, double originalBalance, double amount) {
        this.cardNumber = cardNumber;
        this.person = person;
        this.transactionType = transactionType;
        this.accountType = accountType;
        this.availableBalance = availableBalance;
        this.originalBalance = originalBalance;
        this.amount = amount;
    }

    public Transactions(String cardNumber, String person, String transactionType, String accountType, double amount, double originalBalance, double availableBalance, double originalOutStandingBalance, double newOutStandingBalance) {
        this.cardNumber = cardNumber;
        this.person = person;
        this.transactionType = transactionType;
        this.accountType = accountType;
        this.amount = amount;
        this.originalBalance = originalBalance;
        this.availableBalance = availableBalance;
        this.originalOutStandingBalance = originalOutStandingBalance;
        this.newOutStandingBalance = newOutStandingBalance;
    }

    public Transactions(String cardNumber, String person, String accountType, double availableBalance) {
        this.cardNumber = cardNumber;
        this.person = person;
        this.accountType = accountType;
        this.availableBalance = availableBalance;
    }

    public String getCardNumber() {
        return cardNumber;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public double getOriginalBalance() {
        return originalBalance;
    }

    public void setOriginalBalance(double originalBalance) {
        this.originalBalance = originalBalance;
    }

    public void setCardNumber(String cardNumber) {
        this.cardNumber = cardNumber;
    }

    public String getPerson() {
        return person;
    }

    public void setPerson(String person) {
        this.person = person;
    }

    public String getTransactionType() {
        return transactionType;
    }

    public void setTransactionType(String transactionType) {
        this.transactionType = transactionType;
    }

    public String getAccountType() {
        return accountType;
    }

    public void setAccountType(String accountType) {
        this.accountType = accountType;
    }

    public double getAvailableBalance() {
        return availableBalance;
    }

    public void setAvailableBalance(double availableBalance) {
        this.availableBalance = availableBalance;
    }


    public void receipt(String bankName) throws InterruptedException {


        Date date = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm:ss");

        Thread.sleep(500);

        System.out.println("--------------------------------------------------");
        System.out.println("\t\t\t\tBank of " + bankName);
        System.out.println("--------------------------------------------------");
        System.out.print("Date: ");
        System.out.print(timeFormat.format(date) + " ");
        System.out.println(dateFormat.format(date));
        System.out.println();
        System.out.println("Card Number: XXXX XXXX XXXX " + cardNumber.substring(15));

        System.out.println();
        System.out.println("Customer Name: " + person);
        System.out.println();
        System.out.printf("%s: $%.2f ", transactionType, amount);
        System.out.println("\nFrom Account: " + accountType);
        System.out.printf("Original Balance: $%.2f", originalBalance);
        System.out.printf("\nCurrent Balance: $%.2f", availableBalance);


    }

    public void receiptCredit(String bankName) throws InterruptedException {


        Date date = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm:ss");


        Thread.sleep(500);

        System.out.println("--------------------------------------------------");
        System.out.println("\t\t\t\tBank of " + bankName);
        System.out.println("--------------------------------------------------");
        System.out.print("Date: ");
        System.out.print(timeFormat.format(date) + " ");
        System.out.println(dateFormat.format(date));
        System.out.println();
        System.out.println("Card Number: XXXX XXXX XXXX " + cardNumber.substring(15));

        System.out.println();
        System.out.println("Customer Name: " + person);
        System.out.println();
        System.out.printf("%s: $%.2f ", transactionType, amount);
        System.out.println("\nFrom Account: " + accountType);
        System.out.printf("Original Balance: $%.2f", originalBalance);
        System.out.printf("\nCurrent Balance: $%.2f", availableBalance);
        System.out.println();
        System.out.printf("\nOriginal OutstandingBalance: $%.2f", originalOutStandingBalance);
        System.out.printf("\nCurrent OutstandingBalance: $%.2f", newOutStandingBalance);

    }

    public void savingsAndCheckingsReceipt(String bankName) throws InterruptedException {


        Date date = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm:ss");

        Thread.sleep(500);

        System.out.println("--------------------------------------------------");
        System.out.println("\t\t\t\tBank of " + bankName);
        System.out.println("--------------------------------------------------");
        System.out.print("Date: ");
        System.out.print(timeFormat.format(date) + " ");
        System.out.println(dateFormat.format(date));
        System.out.println();
        System.out.println("Card Number: XXXX XXXX XXXX " + cardNumber.substring(15));

        System.out.println();
        System.out.println("Customer Name: " + person);
        System.out.println();
        System.out.printf("%s: $%.2f ", transactionType, amount);
        System.out.println("\nFrom Account: " + accountType);
        System.out.printf("Original Checkings Balance: $%.2f", originalBalance);
        System.out.printf("\nCurrent Checkings Balance: $%.2f", availableBalance);
        System.out.println();
        System.out.printf("\nOriginal SavingsBalance: $%.2f", originalOutStandingBalance);
        System.out.printf("\nCurrent SavingsBalance: $%.2f", newOutStandingBalance);

    }

    public void balanceReceipt(String bankName) throws InterruptedException {


        Date date = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("MM/dd/yyyy");
        SimpleDateFormat timeFormat = new SimpleDateFormat("hh:mm:ss");

        Thread.sleep(500);

        System.out.println("--------------------------------------------------");
        System.out.println("\t\t\t\tBank of " + bankName);
        System.out.println("--------------------------------------------------");
        System.out.print("Date: ");
        System.out.print(timeFormat.format(date) + " ");
        System.out.println(dateFormat.format(date));
        System.out.println();
        System.out.println("Card Number: XXXX XXXX XXXX " + cardNumber.substring(15));

        System.out.println();
        System.out.println("Customer Name: " + person);
        System.out.println();
        System.out.println("\nFrom Account: " + accountType);
        System.out.printf("Current Balance: $%.2f", availableBalance);


    }

    public static void greetingsMessage(String bankName){

        System.out.println("----------------------------------------------");
        System.out.println("Hello Thank you for Choosing Bank of " + bankName + "!|");
        System.out.println("----------------------------------------------");
        System.out.println("Please Insert your Debit or Credit Card      |");
        System.out.println("Enter 1 for Debit \t\t Enter 2 for Credit  |");
        System.out.println("----------------------------------------------");

    }

}
