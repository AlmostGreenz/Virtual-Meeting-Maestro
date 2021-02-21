import java.io.File;
import java.io.FileNotFoundException;
import java.time.LocalDateTime;
import java.util.Scanner;

public class ReaderGateway {
    String filepath;

    public ReaderGateway(String filepath) {
        this.filepath = filepath;
    }

    public boolean readFromFile(MeetingManager meetingManager) throws InvalidFileFormatException {
        try {
            
            String[] data;
            LocalDateTime time;

            String[] lines = loadStrings(this.filepath);
            
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
