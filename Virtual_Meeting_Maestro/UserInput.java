import javax.swing.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

/**
 * A class that facilitates user input.
 */
public class UserInput {
    
    /**
     * Prompts the user for the name of a new meeting being scheduled and returns the result.
     * @return a String representing the name of the new meeting
     * @throws UserCancelledInputException when the user exits out of the field instead of entering their response
     */
    public String getMeetingName() throws UserCancelledInputException {
        return getUserInput("Meeting Name");
    }
    
    /**
     * Prompts the user for the description of a new meeting being scheduled and returns the result.
     * @return a String representing the description of the new meeting
     * @throws UserCancelledInputException when the user exits out of the field instead of entering their response
     */
    public String getDescription() throws UserCancelledInputException {
        return getUserInput("Meeting Description");
    }
    
    /**
     * Prompts the user for the date and time of a new meeting being scheduled and returns the result.
     * @return a LocalDateTime representing the date and time of the new meeting
     * @throws UserCancelledInputException when the user exits out of the field instead of entering their response
     */
    public LocalDateTime getTime() throws UserCancelledInputException {
        String timeStr = getUserInput("Date and Time of Meeting (Format: YYYY-MM-dd HH:mm)");

        DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");

        LocalDateTime time;

        try {
            time = LocalDateTime.parse(timeStr, dateTimeFormatter);
        } catch (DateTimeParseException e) {
            return getTime();
        }

        return time;
    }
    
    /**
     * Prompts the user for the URL of a new meeting being scheduled and returns the result.
     * @return a String representing the URL of the new meeting
     * @throws UserCancelledInputException when the user exits out of the field instead of entering their response
     */
    public String getUrl() throws UserCancelledInputException {
        return getUserInput("Meeting Link (NOTE: you must include the http:// at the beginning)");
    }
    
    /**
     * Prompts the user for the entry of information as specified by prompt.
     * @param prompt the String prompt for the user to know what to enter
     * @throws UserCancelledInputException when the user exits out of the field instead of entering their response
     */
    private String getUserInput(String prompt) throws UserCancelledInputException {
        boolean validInput = false;
        boolean loopRan = false;
        String input = null;

        while (!validInput) {
            // prompt the user and get their input
            input = (String) JOptionPane.showInputDialog(
                    null,
                    "Enter Information:\n" + prompt,
                    "New Meeting",
                    JOptionPane.PLAIN_MESSAGE,
                    null,
                    null,
                    null);

            if (input == null) {
                throw new UserCancelledInputException();
            }

            validInput = !input.contains(","); // checks for illegal commas

            if (!loopRan) {
                prompt += "\nInvalid Input. Try again. Note: commas are not allowed."; // modify prompt if commas in response
                loopRan = true;
            }
        }

        return input;
    }
}
