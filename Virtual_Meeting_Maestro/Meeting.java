import java.time.LocalDateTime;

/**
  * An entity representing and storing the information for a meeting.
  **/
public class Meeting implements Comparable<Meeting> {
    private final String id;
    private final String name;
    private final String description;
    private final LocalDateTime time;
    private final String url;
  
    /**
      * Construct an instance of Meeting with the provided information.
      * @param id           the id of this meeting
      * @param name         the name of this meeting
      * @param description  the description of this meeting
      * @param time         the date and time that this meeting will take place at
      * @param url          the URL of the virtual meeting where this meeting will take place
      **/
    public Meeting(String id, String name, String description, LocalDateTime time, String url) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.time = time;
        this.url = url;
    }

    /**
     * Get id.
     *
     * @return value of id
     */
    public String getId() {
        return this.id;
    }

    /**
     * Get name.
     *
     * @return value of name
     */
    public String getName() {
        return this.name;
    }

    /**
     * Get description.
     *
     * @return value of description
     */
    public String getDescription() {
        return this.description;
    }

    /**
     * Get time.
     *
     * @return value of time
     */
    public LocalDateTime getTime() {
        return this.time;
    }

    /**
     * Get url.
     *
     * @return value of url
     */
    public String getUrl() {
        return this.url;
    }

    @Override
    /**
      * Compares this Meeting to the other Meeting instance specified
      * @param otherMeeting another Meeting that can be compared to
      **/
    public int compareTo(Meeting otherMeeting) {
        return this.time.compareTo(otherMeeting.getTime());
    }
}
