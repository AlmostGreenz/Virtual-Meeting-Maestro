
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Set;
import java.util.UUID;

public class MeetingManager {
    HashMap<String, Meeting> meetings = new HashMap<>();

    private static String generateMeetingId() {
        return UUID.randomUUID().toString();
    }

    public void createMeeting(String id, String name, String description, LocalDateTime time, String url) {
        Meeting newMeeting = new Meeting(id, name, description, time, url);

        meetings.put(id, newMeeting);
    }

    public void createMeeting(String name, String description, LocalDateTime time, String url) {
        createMeeting(generateMeetingId(), name, description, time, url);
    }

    public Set<String> getMeetingIds() {
        return meetings.keySet();
    }

    private Meeting getMeeting(String meetingId) throws MeetingDoesNotExistException {
        Meeting requestedMeeting = meetings.get(meetingId);

        if (requestedMeeting == null) {
            throw new MeetingDoesNotExistException();
        }

        return requestedMeeting;
    }

    public String getMeetingCSVRep(String meetingId) throws MeetingDoesNotExistException {
        Meeting requestedMeeting = getMeeting(meetingId);

        // Build and return CSV format for meeting

        return String.format("%s,%s,%s,%s,%s", requestedMeeting.getId(),
                requestedMeeting.getName(), requestedMeeting.getDescription(),
                requestedMeeting.getTime().toString(), requestedMeeting.getUrl());
    }

    /**
     * @param status 'u' for upcoming meetings, 'p' for past meetings, 'a' for all meetings
     * @return
     * @throws MeetingDoesNotExistException
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

    private HashMap<String, String> meetingToHashMap(Meeting meeting) {
        HashMap<String, String> meetingData = new HashMap<>();

        meetingData.put("id", meeting.getId());
        meetingData.put("name", meeting.getName());
        meetingData.put("description", meeting.getDescription());
        meetingData.put("time", meeting.getTime().toString().replace('T', ' '));
        meetingData.put("url", meeting.getUrl());

        return meetingData;
    }
    
    public HashMap<String, String> getMeetingData(String meetingId) throws MeetingDoesNotExistException {
        Meeting requestedMeeting = getMeeting(meetingId);
        
        return meetingToHashMap(requestedMeeting);
    }
    
    public LocalDateTime getMeetingTime(String meetingId) throws MeetingDoesNotExistException {
      Meeting requestedMeeting = getMeeting(meetingId);
      
      return requestedMeeting.getTime();
    }

    public boolean removeMeeting(String meetingId) {
        return meetings.remove(meetingId) != null;
    }
}
