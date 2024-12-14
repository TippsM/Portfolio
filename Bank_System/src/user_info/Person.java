package user_info;
import java.util.ArrayList;


public class Person {

    private String firstName;
    private String lastName;
    private String fullName;
    private ArrayList<Card> cards;

    //----------------------------------------------------------------------


    public Person(String firstName, String lastName) {
        this.firstName = firstName;
        this.lastName = lastName;

        fullName = firstName + " " + lastName;
        cards = new ArrayList<>();
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public ArrayList<Card> getCards() {
        return cards;
    }

    public void setCards(ArrayList<Card> cards) {
        this.cards = cards;
    }

    public void displayInfo(){



    }
}
