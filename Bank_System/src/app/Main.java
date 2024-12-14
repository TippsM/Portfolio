package app;

import bank.Transactions;

public class Main {
    public static void main(String[] args) {
        ATMSystem BankATM = new ATMSystem();

        try {
            Transactions.greetingsMessage("Americas");
            BankATM.ATM();

        } catch (InterruptedException e) {
            System.out.println(e.getMessage());
        }

    }


}
