import java.io.PrintWriter;
import java.io.IOException;
import java.util.Set;

/**
 * A gateway class that allows for data to be written to the storage csv file.
 */
public class WriterGateway {
    String filepath;
    
    /**
     * Constructs an instance of WriterGateway with the specified filepath.
     * @param filepath the path to the file which is to be written to
     */
    public WriterGateway(String filepath) {
        this.filepath = "data/" + filepath;
    }
    
    /**
     * Create a new storage file at the location of filepath.
     */
    public void writeToFile() {
      String[] toSave = new String[]{};
      saveStrings(this.filepath, toSave);

    }
    
    /**
     * Write to the file specified by filepath with the data from Meeting instances in meetingManager.
     * @param meetingManager a MeetingManager instance that stores the Meeting instances
     */
    public void writeToFile(MeetingManager meetingManager) { //<>//
      Set<String> meetings = meetingManager.getMeetingIds();
      
      String[] toSave = new String[meetings.size()];
      int count = 0;
      
      // assemble the list of Strings that will be written to the file
      for (String id : meetings) {
          try {
              toSave[count] = meetingManager.getMeetingCSVRep(id);
              count++;
          } catch (MeetingDoesNotExistException e) {
              e.printStackTrace();
          }
      }
      
      saveStrings(this.filepath, toSave); // write the strings to the file
    }
}
