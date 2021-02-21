import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Set;
import java.util.UUID;

/**
 * A manager class to manage Meeting instances.
 */
public class MeetingManager {
    HashMap<String, Meeting> meetings = new HashMap<>();
    
    /**
     * Generate a UUID that can represent a Meeting instance.
     * @return new UUID in the form of a String
     */
    private static String generateMeetingId() {
        return UUID.randomUUID().toString();
    }
    
    /**
     * Create a new instance of Meeting and store it in the meetings HashMap.
     * @param id           the id of the new meeting
     * @param name         the name of the new meeting
     * @param description  the description of the new meeting
     * @param time         the date and time that the new meeting will take place at
     * @param url          the URL of the virtual meeting where the new meeting will take place
     */
    public void createMeeting(String id, String name, String description, LocalDateTime time, String url) {
        Meeting newMeeting = new Meeting(id, name, description, time, url);

        meetings.put(id, newMeeting);
    }
    
    /**
     * Create a new instance of Meeting as well as generate an ID for it and store the Meeting in the meetings HashMap.
     * @param name         the name of the new meeting
     * @param description  the description of the new meeting
     * @param time         the date and time that the new meeting will take place at
     * @param url          the URL of the virtual meeting where the new meeting will take place
     */
    public void createMeeting(String name, String description, LocalDateTime time, String url) {
        createMeeting(generateMeetingId(), name, description, time, url);
    }

    /**
     * Get a set containing the ids of all Meeting instances in meetings.
     * @return Set containing the String keys of the meetings HashMap
     */
    public Set<String> getMeetingIds() {
        return meetings.keySet();
    }
    
    /**
     * Get the Meeting instance represented by meetingId.
     * @param meetingId the id representing a Meeting
     * @return the instance of Meeting specified
     * @throws MeetingDoesNotExistException when there is no Meeting corresponding to meetingId
     */
    private Meeting getMeeting(String meetingId) throws MeetingDoesNotExistException {
        Meeting requestedMeeting = meetings.get(meetingId);

        if (requestedMeeting == null) {
            throw new MeetingDoesNotExistException();
        }

        return requestedMeeting;
    }

    /**
     * Get the csv representation of the Meeting instance represented by meetingId.
     * @param meetingId the id representing a Meeting
     * @return the csv representation of the Meeting specified
     * @throws MeetingDoesNotExistException when there is no Meeting corresponding to meetingId
     */
    public String getMeetingCSVRep(String meetingId) throws MeetingDoesNotExistException {
        Meeting requestedMeeting = getMeeting(meetingId);

        // Build and return CSV format for meeting

        return String.format("%s,%s,%s,%s,%s", requestedMeeting.getId(),
                requestedMeeting.getName(), requestedMeeting.getDescription(),
                requestedMeeting.getTime().toString(), requestedMeeting.getUrl());
    }

    /**
     * Get a sorted ArrayList of HashMaps containing the specified Meetings' data.
     * @param status the types of meetings to return - 'u' for upcoming meetings, 'p' for past meetings, 'a' for all meetings
     * @return ArrayList containing HashMaps with the data of all specified Meeting instances stored within, sorted from earliest to latest scheduled time and date
     */
    public ArrayList<HashMap<String, String>> getSortedMeetingInfo(char status) {
        ArrayList<HashMap<String, String>> meetingInfo = new ArrayList<>(); //<>//

        ArrayList<Meeting> meetingsArray = new ArrayList<>(this.meetings.values());

        meetingsArray.sort(null);

        if (status == 'p' || status == 'a') {
            for (Meeting vm : meetingsArray) {
                if (vm.getTime().compareTo(LocalDate.now().atStartOfDay()) < 0) {
                    meetingInfo.add(meetingToHashMap(vm));
                } else {
                    break;
                }
            }
        }

        if (status == 'u' || status == 'a') {
            for (Meeting vm : meetingsArray) {
                if (vm.getTime().compareTo(LocalDate.now().atStartOfDay()) >= 0) {
                    meetingInfo.add(meetingToHashMap(vm));
                }
            }
        }

        return meetingInfo;
    }
    
    /**
     * Get a HashMap representation of a Meeting instance.
     * @param the Meeting instance to be converted to a HashMap
     * @return the HashMap representation of the specified Meeting
     */
    private HashMap<String, String> meetingToHashMap(Meeting meeting) {
        HashMap<String, String> meetingData = new HashMap<>();

        meetingData.put("id", meeting.getId());
        meetingData.put("name", meeting.getName());
        meetingData.put("description", meeting.getDescription());
        meetingData.put("time", meeting.getTime().toString().replace('T', ' '));
        meetingData.put("url", meeting.getUrl());

        return meetingData;
    }
    
    /**
     * Get the HashMap representation of the Meeting instance represented by meetingId.
     * @param meetingId the id representing a Meeting
     * @return the HashMap representation of the Meeting specified
     * @throws MeetingDoesNotExistException when there is no Meeting corresponding to meetingId
     */
    public HashMap<String, String> getMeetingData(String meetingId) throws MeetingDoesNotExistException {
        Meeting requestedMeeting = getMeeting(meetingId);
        
        return meetingToHashMap(requestedMeeting);
    }
    
    /**
     * Get the LocalDateTime corresponding to the meetingId specified.
     * @param meetingId the id representing a Meeting
     * @throws MeetingDoesNotExistException when there is no Meeting corresponding to meetingId
     */
    public LocalDateTime getMeetingTime(String meetingId) throws MeetingDoesNotExistException {
      Meeting requestedMeeting = getMeeting(meetingId);
      
      return requestedMeeting.getTime();
    }
    
    /**
     * Delete the Meeting corresponding to meetingId from the meetings HashMap.
     * @param meetingId the id of the Meeting instance to be deleted
     */
    public void removeMeeting(String meetingId) {
        meetings.remove(meetingId);
    }
}
