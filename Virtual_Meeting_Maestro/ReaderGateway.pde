import java.io.File;
import java.io.FileNotFoundException;
import java.time.LocalDateTime;
import java.util.Scanner;

/**
 * A gateway class that allows for data to be read from the storage csv file.
 */
public class ReaderGateway {
    String filepath;
    
    /**
     * Constructs an instance of ReaderGateway with the specified filepath.
     * @param filepath the path to the file which is to be read from
     */
    public ReaderGateway(String filepath) {
        this.filepath = filepath;
    }
    
    /**
     * Read from the file specified by filepath and store the data in meetingManager.
     * @param meetingManager a MeetingManager instance that is to store the Meeting instances
     * @throws InvalidFileFormatException when the file specified by filepath is in an invalid format
     */
    public boolean readFromFile(MeetingManager meetingManager) throws InvalidFileFormatException {
        try {
            String[] data;
            LocalDateTime time;

            String[] lines = loadStrings(this.filepath); // read from the file
            
            // check for valid reading
            if (lines == null) {
              throw new FileNotFoundException();
            }

            for (int i = 0; i < lines.length; i++) {
                data = lines[i].split(",");
                time = LocalDateTime.parse(data[3]);
                meetingManager.createMeeting(data[0], data[1], data[2], time, data[4]);
            }

            return true;
        } catch (FileNotFoundException e) {
            return false;
        } catch (ArrayIndexOutOfBoundsException e) {
            throw new InvalidFileFormatException();
        }
    }
}
