import java.io.PrintWriter;
import java.io.IOException;
import java.util.Set;

public class WriterGateway {
    String filepath;

    public WriterGateway(String filepath) {
        this.filepath = "data/" + filepath;
    }

    public void writeToFile() {
      String[] toSave = new String[]{};
      saveStrings(this.filepath, toSave);

    }

    public void writeToFile(MeetingManager meetingManager) { //<>//
      Set<String> meetings = meetingManager.getMeetingIds();
      
      String[] toSave = new String[meetings.size()];
      int count = 0;
      for (String id : meetings) {
          try {
              toSave[count] = meetingManager.getMeetingCSVRep(id);
              count++;
          } catch (MeetingDoesNotExistException e) {
              e.printStackTrace();
          }
      }
      
      saveStrings(this.filepath, toSave);
    }
}
