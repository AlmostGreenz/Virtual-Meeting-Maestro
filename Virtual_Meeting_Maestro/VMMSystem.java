import java.time.temporal.TemporalAdjusters;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * An abstract controller class that when extended manages the program's execution.
 */
public abstract class VMMSystem {
    static final String FILEPATH = "data.csv";

    final MeetingManager meetingManager = new MeetingManager();
    
    final UserInput userInput = new UserInput();
    
    /**
     * Facilitates the addition of a new Meeting to the schedule.
     */
    public void addMeeting() {
        String name;
        String description;
        LocalDateTime time;
        String url;

        try {
            name = userInput.getMeetingName();
            description = userInput.getDescription();
            time = userInput.getTime();
            url = userInput.getUrl();
        } catch (UserCancelledInputException e) {
            return;
        }

        meetingManager.createMeeting(name, description, time, url);
        saveToFile();
    }
    
    /**
     * Remove the Meeting specified by meetingId from the schedule.
     * @param meetingId the id of a Meeting instance
     */
    public void removeMeeting(String meetingId) {
        meetingManager.removeMeeting(meetingId);
    }
    
    /**
     * Get a sorted ArrayList of HashMaps containing the specified Meetings' data.
     * @param status the types of meetings to return - 'u' for upcoming meetings, 'p' for past meetings, 'a' for all meetings
     * @return ArrayList containing HashMaps with the data of all specified Meeting instances stored within, sorted from earliest to latest scheduled time and date
     */
    public ArrayList<HashMap<String, String>> getSortedMeetingData(char status) {
        return meetingManager.getSortedMeetingInfo(status);
    }
    
     /**
     * Get the HashMap representation of the Meeting instance represented by meetingId.
     * @param meetingId the id representing a Meeting
     * @return the HashMap representation of the Meeting specified
     */
    public HashMap<String, String> getMeetingData(String meetingId) {
        try {
            return meetingManager.getMeetingData(meetingId);
        }
        catch (MeetingDoesNotExistException e) {
            return null;
        }
    }
    
    /**
     * Repeat the scheduling of the Meeting specified exactly one week after it occurs.
     * @param meetingId the id of the Meeting to be repeated
     */
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
    
    /**
     * Save the Meeting instances' data to file.
     */
    abstract void saveToFile();
}
