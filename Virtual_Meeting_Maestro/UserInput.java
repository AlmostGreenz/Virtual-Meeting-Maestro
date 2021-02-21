import javax.swing.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public class UserInput {

    public String getName() throws UserCancelledInputException {
        return getUserInput("Meeting Name");
    }

    public String getDescription() throws UserCancelledInputException {
        return getUserInput("Meeting Description");
    }

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

    public String getUrl() throws UserCancelledInputException {
        return getUserInput("Meeting Link (NOTE: you must include the http:// at the beginning)");
    }

    private String getUserInput(String prompt) throws UserCancelledInputException {
        boolean validInput = false;
        boolean loopRan = false;
        String input = null;

        while (!validInput) {

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

            validInput = !input.contains(",");

            if (!loopRan) {
                prompt += "\nInvalid Input. Try again. Note: commas are not allowed.";
                loopRan = true;
            }
        }

        return input;
    }
}
