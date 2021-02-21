import java.time.temporal.TemporalAdjusters;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;

public abstract class VMMSystem {
    static final String FILEPATH = "data.csv";

    final MeetingManager meetingManager = new MeetingManager();
    
    final UserInput userInput = new UserInput();

    public void addMeeting() {
        String name;
        String description;
        LocalDateTime time;
        String url;

        try {
            name = userInput.getName();
            description = userInput.getDescription();
            time = userInput.getTime();
            url = userInput.getUrl();
        } catch (UserCancelledInputException e) {
            return;
        }

        meetingManager.createMeeting(name, description, time, url);
        saveToFile();
    }

    public boolean removeMeeting(String meetingId) {
        return meetingManager.removeMeeting(meetingId);
    }

    public ArrayList<HashMap<String, String>> getSortedMeetingData(char status) {
        return meetingManager.getSortedMeetingInfo(status);
    }
    
    public HashMap<String, String> getMeetingData(String meetingId) {
        try {
            return meetingManager.getMeetingData(meetingId);
        }
        catch (MeetingDoesNotExistException e) {
            return null;
        }
    }
    
    public void repeatMeeting(String meetingId) {
      try {
            HashMap<String, String> oldMeeting = meetingManager.getMeetingData(meetingId);
            LocalDateTime time = meetingManager.getMeetingTime(meetingId);
            
            meetingManager.createMeeting(oldMeeting.get("name"), 
                                         oldMeeting.get("description"), 
                                         time.with(TemporalAdjusters.next(time.getDayOfWeek())),
                                         oldMeeting.get("url"));
            saveToFile();
        }
        catch (MeetingDoesNotExistException e) {
            return;
        }
    }
    
    abstract void saveToFile();
}
