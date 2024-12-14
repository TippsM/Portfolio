package app;
import bank.Transactions;
import user_info.Card;
import user_info.Person;

import java.util.Scanner;

public class ATMSystem {
    public void ATM() throws InterruptedException {

        //--------------------------------------------------------------------------------

        Person person = new Person("John", "Smith");
        Card debitCard = new Card(person, "debit", "9874 5611 1233 9898", "08/99", 20526.59, 20526.59, 10562.89, 10562.89,1234);
        Card creditCard = new Card(person, "credit", "1234 4566 7899 7899", "09/99", 2500.00, 526.36);

        person.getCards().add(debitCard);
        person.getCards().add(creditCard);


        Scanner sc = new Scanner(System.in);
        int cardType = sc.nextInt();

        //--------------------------------------------------------------------------------
        //Beginning of which card -if (Debit) and pin method

        if (cardType == 1) {
            for (int i = 1; i < 4; i++) {

                Thread.sleep(600);

                System.out.println("Processing...");
                System.out.println();
            }

            int cardPin;

            System.out.println("Please Enter Your 4 Digit Pin");

            cardPin = sc.nextInt();
            int passwordAttempts = 0;

            if (cardPin != debitCard.getPin()) {

                do {
                    System.out.println("Invalid Pin!");
                    System.out.println("Please Try Again!");
                    cardPin = sc.nextInt();
                    passwordAttempts++;

                    if (passwordAttempts == 3){

                        cardPin = 1234;
                        System.out.println("You Have Too Many Tried Attempts!");
                        System.out.println("Your Account Is Now Locked!");
                        System.exit(0);

                    }

                } while (cardPin != debitCard.getPin());
            }

            for (int i = 1; i < 3; i++) {

                Thread.sleep(600);

                System.out.println("Processing...");
                System.out.println();
            }

            //-------------------------------------------------------------------------------
            //End of pin method

            System.out.println("Hello " + person.getFullName() + "!" + "\n");
            System.out.println("Which Account Would you like to access today?");
            System.out.println("Enter 1 for Checkings \t\t\t\t\t\t" + "Enter 2 for Savings");
            int accountOption = sc.nextInt();

            for (int i = 0; i < 3; i++){
                Thread.sleep(500);
                System.out.println("Processing...");
                System.out.println();
            }

            //--------------------------------------------------------------------------------
            //Beginning of -if Debit (Checkings) and option -if

            if (accountOption == 1) {
                System.out.println("Enter 1 to check Balance \t\t\t\t\t\t" + "Enter 2 to make a transfer");
                System.out.println("Enter 3 to make a deposit \t\t\t\t\t\t" + "Enter 4 to make a withdrawal");

                //------------------------------------------------------------------------------
                //Balance checker option

                int optionNumber = sc.nextInt();

                if (optionNumber == 1) {

                    for (int i = 0; i < 3; i++){

                        Thread.sleep(500);
                        System.out.println("Processing...");
                        System.out.println();
                    }

                    System.out.println("Your Receipt Will Be Printed Shortly!");
                    System.out.println();
                    Transactions transactions = new Transactions(debitCard.getCardNumber(), person.getFullName(), "Checkings", debitCard.getAvailableBalance());
                    transactions.balanceReceipt("Americas");

                    //------------------------------------------------------------------------------
                    //Still need to code......

                } else if (optionNumber == 2) {

                    for (int i = 0; i < 3; i++){

                        Thread.sleep(500);
                        System.out.println("Processing...");
                        System.out.println();
                    }
                    System.out.println("Which account would you like to make a transfer to?");
                    System.out.println("Enter 1 to for Checking \t\t\t\t\t\t" + "Enter 2 for Savings");
                    System.out.println("Enter 3 for OutstandingBalance");
                    int transferOption = sc.nextInt();


                    if (transferOption > 2 || transferOption == 0){

                        do {

                            System.out.println("Please Enter a valid option!");
                            transferOption = sc.nextInt();

                        }while (transferOption > 2 || transferOption == 0);
                    }

                    for (int i = 0; i < 3; i++){
                        Thread.sleep(600);
                        System.out.println("Processing...");
                        System.out.println();
                    }

                    if (transferOption == 1){
                        System.out.println("How much would you like transfer from your savings?");
                        double transferAmount = sc.nextDouble();

                        for (int i = 0; i < 3; i++){
                            Thread.sleep(600);
                            System.out.println("Processing...");
                            System.out.println();
                        }

                        System.out.println("Your Receipt Will Be Printed Shortly!");
                        System.out.println();

                        double savingsValue = debitCard.getAvailableSavingsBalance() - transferAmount;
                        double checkingsValue = debitCard.getAvailableBalance() + transferAmount;

                        Transactions transactions = new Transactions(debitCard.getCardNumber(), person.getFullName(), "Transfer", "Checkings", transferAmount, debitCard.getOriginalBalance(), checkingsValue, debitCard.getOriginalSavingsBalance(), savingsValue);
                        transactions.savingsAndCheckingsReceipt("Americas");

                    } else if (transferOption == 2) {

                        System.out.println("How much would you like transfer from your checkings?");
                        double transferAmount = sc.nextDouble();

                        for (int i = 0; i < 3; i++){
                            Thread.sleep(600);
                            System.out.println("Processing...");
                            System.out.println();
                        }

                        System.out.println("Your Receipt Will Be Printed Shortly!");
                        System.out.println();

                        double savingsValue = debitCard.getAvailableSavingsBalance() + transferAmount;
                        double checkingsValue = debitCard.getAvailableBalance() - transferAmount;

                        Transactions transactions = new Transactions(debitCard.getCardNumber(), person.getFullName(), "Transfer", "Savings", transferAmount, debitCard.getOriginalBalance(), checkingsValue, debitCard.getOriginalSavingsBalance(), savingsValue);
                        transactions.savingsAndCheckingsReceipt("Americas");



                    }


                    //------------------------------------------------------------------------------
                    //Deposit option

                } else if (optionNumber == 3) {
                    System.out.println("Please Insert Bills:");
                    double depositAmount = sc.nextDouble();
                    debitCard.depositCheckings(depositAmount);

                    for (int i = 1; i < 3; i++) {

                        Thread.sleep(600);

                        System.out.println("Processing...");
                        System.out.println();
                    }

                    System.out.println("Your Receipt Will Be Printed Shortly!");
                    System.out.println();

                    Transactions transactions = new Transactions(debitCard.getCardNumber(), person.getFullName(), "Deposit", "Checkings", debitCard.getAvailableBalance(), debitCard.getOriginalBalance(),depositAmount);
                    transactions.receipt("Americas");

                    //------------------------------------------------------------------------------
                    //Withdrawal option

                } else if (optionNumber == 4) {
                    System.out.println("How much would you like to withdrawal?");
                    double withdrawalAmount = sc.nextDouble();

                    if (withdrawalAmount > debitCard.getAvailableBalance()) {
                        System.out.println("Insufficient funds!");
                    } else {

                        debitCard.withdrawalCheckings(withdrawalAmount);
                        for (int i = 1; i < 3; i++) {

                            Thread.sleep(600);

                            System.out.println("Processing...");
                            System.out.println();
                        }

                        System.out.println("Your Receipt Will Be Printed Shortly!");
                        System.out.println();

                        Transactions transactions = new Transactions(debitCard.getCardNumber(), person.getFullName(), "Withdrawal", "Checkings", debitCard.getAvailableBalance(), debitCard.getOriginalBalance(),withdrawalAmount);
                        transactions.receipt("Americas");
                    }
                }

                //End of -if Debit (Checkings)
                //--------------------------------------------------------------------------------
                //Beginning of -if Debit (Savings)
                //--------------------------------------------------------------------------------

            } else if (accountOption == 2) {

                System.out.println("Enter 1 to check Balance \t\t\t\t\t\t" + "Enter 2 to make a Transfer");
                System.out.println("Enter 3 to make a Deposit \t\t\t\t\t\t" + "Enter 4 to make a Withdrawal");

                int optionNumber = sc.nextInt();
                if (optionNumber == 1) {

                    System.out.println("Your Receipt Will Be Printed Shortly!");
                    System.out.println();
                    Transactions transactions = new Transactions(debitCard.getCardNumber(), person.getFullName(), "Savings", debitCard.getAvailableSavingsBalance());
                    transactions.balanceReceipt("Americas");

                } else if (optionNumber == 2) {

                    System.out.printf("Your Current Balance is $%.2f", debitCard.getAvailableSavingsBalance());

                } else if (optionNumber == 3) {
                    System.out.println("How much would you like to deposit?");
                    double depositAmount = sc.nextDouble();
                    debitCard.depositSavings(depositAmount);

                    for (int i = 1; i < 3; i++) {

                        Thread.sleep(600);

                        System.out.println("Processing...");
                        System.out.println();
                    }

                    System.out.println("Your Receipt Will Be Printed Shortly!");
                    System.out.println();

                    Transactions transactions = new Transactions(debitCard.getCardNumber(), person.getFullName(), "Deposit", "Savings", debitCard.getAvailableSavingsBalance(), debitCard.getOriginalSavingsBalance(),depositAmount);
                    transactions.receipt("Americas");

                } else if (optionNumber == 4) {
                    System.out.println("How much would you like to withdrawal?");
                    double withdrawalAmount = sc.nextDouble();

                    if (withdrawalAmount > debitCard.getAvailableBalance()) {
                        System.out.println("Insufficient funds!");
                    } else {

                        debitCard.withdrawalSavings(withdrawalAmount);
                        for (int i = 1; i < 3; i++) {

                            Thread.sleep(600);

                            System.out.println("Processing...");
                            System.out.println();
                        }

                        System.out.println("Your Receipt Will Be Printed Shortly!");
                        System.out.println();

                        Transactions transactions = new Transactions(debitCard.getCardNumber(), person.getFullName(), "Withdrawal", "Savings", debitCard.getAvailableSavingsBalance(),debitCard.getOriginalSavingsBalance(), withdrawalAmount);
                        transactions.receipt("Americas");

                    }
                }
            }

        }else if (cardType == 2) {

            for (int i = 1; i < 4; i++) {

                Thread.sleep(600);

                System.out.println("Processing...");
                System.out.println();
            }

            System.out.printf("Your Current Outstanding Balance is $%.2f", creditCard.getOutstandingBalance());
            System.out.println("\nWould You like to make a payment?");
            System.out.println("Enter 1 for Yes \t\t\t\t\t\t\t Enter 2 for No");
            int paymentChoice = sc.nextInt();

            if (paymentChoice > 2 || paymentChoice == 0){

                do {

                    System.out.println("Please Enter a valid choice");
                    paymentChoice = sc.nextInt();



                }while (paymentChoice > 2 || paymentChoice == 0);
            }
            if (paymentChoice == 1){
                System.out.println("How would you like to make a payment?");
                System.out.println("---------------------------------------------");
                System.out.println("Which account would you like to make a payment from?");
                System.out.println("Enter 1 for Checkings \t\t\t\t Enter 2 for Savings");


                int choicePayment = sc.nextInt();

                for (int i = 1; i < 3; i++) {

                    Thread.sleep(600);

                    System.out.println("Processing...");
                    System.out.println();
                }

                if (choicePayment == 1){
                    System.out.println("How much would like to transfer from your checkings?");

                    double paymentAmount = sc.nextDouble();

                    for (int i = 1; i < 4; i++) {

                        Thread.sleep(600);

                        System.out.println("Processing...");
                        System.out.println();
                    }

                    System.out.println("Your receipt will be printed shortly...");


                    double checkingBalance = debitCard.getAvailableBalance() - paymentAmount;
                    double outstandingBalance = creditCard.getOutstandingBalance() - paymentAmount;
                    Transactions transactions = new Transactions(creditCard.getCardNumber(), person.getFullName(), "Credit", "Checkings", paymentAmount, debitCard.getOriginalBalance(), checkingBalance, creditCard.getOutstandingBalance(), outstandingBalance);
                    transactions.receiptCredit("Americas");


                } else if (choicePayment == 2) {

                    System.out.println("How much would like to transfer from your savings?");

                    double paymentAmount = sc.nextDouble();

                    for (int i = 1; i < 4; i++) {

                        Thread.sleep(600);

                        System.out.println("Processing...");
                        System.out.println();
                    }

                    System.out.println("Your receipt will be printed shortly...");


                    double savingsBalance = debitCard.getAvailableSavingsBalance() - paymentAmount;
                    double outstandingBalance = creditCard.getOutstandingBalance() - paymentAmount;
                    Transactions transactions = new Transactions(creditCard.getCardNumber(), person.getFullName(), "Credit", "Savings", paymentAmount, debitCard.getOriginalSavingsBalance(), savingsBalance, creditCard.getOutstandingBalance(), outstandingBalance);
                    transactions.receiptCredit("Americas");


                }


            } else if (paymentChoice == 2) {
                System.out.printf("Your Current Outstanding Balance is $%.2f", creditCard.getOutstandingBalance());
                System.exit(0);

            }


        } else {
            System.out.println("You Insert Invalid Card!");
            System.out.println("Goodbye");
        }
    }
}
