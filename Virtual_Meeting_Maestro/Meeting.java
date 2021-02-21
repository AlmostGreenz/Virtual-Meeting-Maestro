import java.time.LocalDateTime;

public class Meeting implements Comparable<Meeting> {
    private final String id;
    private final String name;
    private final String description;
    private final LocalDateTime time;
    private final String url;

    public Meeting(String id, String name, String description, LocalDateTime time, String url) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.time = time;
        this.url = url;
    }

    /**
     * Get id
     *
     * @return value of id
     */
    public String getId() {
        return this.id;
    }

    /**
     * Get name
     *
     * @return value of name
     */
    public String getName() {
        return this.name;
    }

    /**
     * Get description
     *
     * @return value of description
     */
    public String getDescription() {
        return this.description;
    }

    /**
     * Get time
     *
     * @return value of time
     */
    public LocalDateTime getTime() {
        return this.time;
    }

    /**
     * Get url
     *
     * @return value of url
     */
    public String getUrl() {
        return this.url;
    }

    @Override
    public int compareTo(Meeting otherMeeting) {
        return this.time.compareTo(otherMeeting.getTime());
    }
}
