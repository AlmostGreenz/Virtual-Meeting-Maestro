import uibooster.*;
import uibooster.model.*;
import java.util.*;
import controlP5.*;
import javax.swing.*;

ControlP5 cp5;

UiBooster booster;
ListElement selectedElement;

VMMSystemAdapter vmmSystem;

PImage logo;

/**
  *  Sets up the canvas and the objects that the program depends on to run.
  **/
void setup() {
  size(600, 800);
  noStroke();
  frameRate(30); // limit framerate to 30 frames per second to reduce impact on system
  
  // Button configuration
  cp5 = new ControlP5(this);
  
  cp5.addButton("remove")
     .activateBy(ControlP5.RELEASE)
     .setValue(0)
     .setPosition(425,650)
     .setSize(100,100)
     .setColorForeground(color(255, 0, 0))
     .setColorBackground(color(175, 0, 0))
     .setColorActive(color(215, 0, 0));
   
   cp5.addButton("add")
      .activateBy(ControlP5.RELEASE)
      .setValue(0)
      .setPosition(75,650)
      .setSize(100,100)
      .setColorForeground(color(0, 215, 0))
      .setColorBackground(color(0, 145, 0))
      .setColorActive(color(0, 185, 0));
      
  cp5.addButton("viewall")
      .setCaptionLabel("VIEW ALL MEETINGS")
      .activateBy(ControlP5.RELEASE)
      .setValue(0)
      .setPosition(250,475)
      .setSize(100,100)
      .setColorForeground(color(0, 0, 215))
      .setColorBackground(color(0, 0, 145))
      .setColorActive(color(0, 0, 185));
      
  cp5.addButton("viewMeeting")
      .setCaptionLabel("Get Meeting Info")
      .activateBy(ControlP5.RELEASE)
      .setValue(0)
      .setPosition(250,300)
      .setSize(100,100)
      .setColorForeground(color(215, 0, 215))
      .setColorBackground(color(145, 0, 145))
      .setColorActive(color(185, 0, 185));
      
  cp5.addButton("viewPast")
      .setCaptionLabel("View Past Meetings")
      .activateBy(ControlP5.RELEASE)
      .setValue(0)
      .setPosition(75,475)
      .setSize(100,100)
      .setColorForeground(color(215, 215, 0))
      .setColorBackground(color(145, 145, 0))
      .setColorActive(color(185, 185, 0));
      
  cp5.addButton("viewUpcoming")
      .setCaptionLabel("View Upcoming Meetings")
      .activateBy(ControlP5.RELEASE)
      .setValue(0)
      .setPosition(425,475)
      .setSize(100,100)
      .setColorForeground(color(0, 215, 215))
      .setColorBackground(color(0, 145, 145))
      .setColorActive(color(0, 185, 185));
  
  // Loads in logo to be drawn on menu
  logo = loadImage("logo.png");
  imageMode(CENTER);
  
  // Instantiate an instance of UiBooster which assists with window design
  booster = new UiBooster();
  
  // Instantiate an instance of VMMSystemAdapter, a class that adapts the VMMSystem class to work with Processing
  vmmSystem = new VMMSystemAdapter();
}

/**
  * Draws the frames to the screen.
  **/
void draw() {
  background(10);
  textAlign(CENTER, CENTER);
  
  image(logo, width/2, 145);
}

/**
  * Display all scheduled meetings in a window.
  * @param value integer representing the state of the button (handled by the library)
  **/
public void viewall(int value){
  // activated by the button
  displayMeetings('a');
}

/**
  * Display scheduled meetings that have passed (occured prior to today) in a window.
  * @param value integer representing the state of the button (handled by the library)
  **/
public void viewPast(int value){
  // activated by the button
  displayMeetings('p');
}

/**
  * Display all upcoming (happening today or in the future) scheduled meetings in a window.
  * @param value integer representing the state of the button (handled by the library)
  **/
public void viewUpcoming(int value){
  // activated by the button
  displayMeetings('u');
}

/**
  * Display to the user the meetings specified by status.
  * @param status a character representing which meetings to display, with 'a' being all, 'u' being upcoming, and 'p' being previous
  **/
private void displayMeetings(char status) {
  if (millis() > 500) {
    String title;
    
    switch (status) {
      case 'a':
        title = "All Scheduled Meetings";
        break;
      case 'u':
        title = "Upcoming Meetings";
        break;
      case 'p':
        title = "Past Meetings";
        break;
      default:
        return;
    }
    
    ArrayList<HashMap<String, String>> meetingData = vmmSystem.getSortedMeetingData(status);
     
    String[][] meetingsFormatted = new String[meetingData.size()][5];

    int count = 0;

    for (HashMap<String, String> scheduled : meetingData) {
        meetingsFormatted[count][0] = String.valueOf(count);
        meetingsFormatted[count][1] = scheduled.get("name");
        meetingsFormatted[count][2] = scheduled.get("description");
        meetingsFormatted[count][3] = scheduled.get("time");
        meetingsFormatted[count][4] = scheduled.get("url");

        count++;
    }
    
    // Display the meetings
    new UiBooster().showTableImmutable(
        meetingsFormatted,
        Arrays.asList("ID", "Name", "Description", "Date & Time", "URL"),
        title);
  }
}

/**
  * Get the ID of the meeting specified by the user.
  * @param title the title of the prompt to the user
  * @param prompt the text of the prompt to the user
  **/
private String getIdFromUser(String title, String prompt) {
  ArrayList<String> meetingsFormatted = new ArrayList<String>();
    
  ArrayList<HashMap<String, String>> meetingData = vmmSystem.getSortedMeetingData('a');
  
  int count = 1;
  
  for (HashMap<String, String> scheduled : meetingData) {
    meetingsFormatted.add(String.valueOf(count) + " | " + scheduled.get("name") + " - " + scheduled.get("time"));
    count++;
  }
  
  String selection;
  
  // Display the meeting options to the user
  if (meetingsFormatted.size() > 0) {
    selection = new UiBooster().showSelectionDialog(
          prompt,
          title,
          meetingsFormatted);
  }
  else {
    new UiBooster().showInfoDialog("You have no events scheduled.");
    
    selection = null;
  }
        
  if (selection == null) {
    return null;
  }
  
  int index = Integer.parseInt(selection.substring(0, selection.indexOf(" | "))) - 1; // find the index of the meeting in meetingData
  
  return meetingData.get(index).get("id");
}

/**
  * Display all meetings, allow the user to select one, then let them view its information and either go back to the menu,
  *        repeat the meeting, or go to the URL associated with the meeting.
  * @param value integer representing the state of the button (handled by the library)
  **/
public void viewMeeting(int value) {
  // activated by the button
  if (millis() > 500) {
    // Display all meetings as ask for a selection of which one to view
    String meetingId = getIdFromUser("Select Meeting", "Select which meeting to view:");
    
    if (meetingId == null) {
      return;
    }
    
    HashMap<String, String> meetingData = vmmSystem.getMeetingData(meetingId);
    
    if (meetingData == null) {
      return;
    }
    
    // Display selected meeting's information
    String input = (String) JOptionPane.showInputDialog(
                    null,
                    String.format("Description: %s\nDate/Time %s", meetingData.get("description"), meetingData.get("time"))
                    + "\n\nPress 'Okay' to go to your meeting\nOR\ncopy the link below and paste it in your favourite browser."
                    + "\nAlternatively, enter 'repeat' below (without quotes) to repeat this meeting one week after it occured.",
                    meetingData.get("name"),
                    JOptionPane.PLAIN_MESSAGE,
                    null,
                    null,
                    meetingData.get("url"));
                    
    if (input != null && "repeat".equals(input)) {
      vmmSystem.repeatMeeting(meetingId); // repeat meeting's scheduling if requested
    }
    else if (input != null) {
      link(meetingData.get("url")); // redirect user to meeting's URL if requested
    }
  }
}

/**
  * Initiate the process to add an event.
  * @param value integer representing the state of the button (handled by the library)
  **/
public void add(int value){
  // activated by the button
  if (millis() > 500) {
    vmmSystem.addMeeting();
  }
}

/**
  * Remove an event from the schedule (if user decides so).
  * @param value integer representing the state of the button (handled by the library)
  **/
public void remove(int value){
  // activated by the button
  if (millis() > 500) {
    String meetingId = getIdFromUser("Remove Meeting?", "Select which meeting to remove:"); // request selection of meeting from user
    
    if (meetingId == null) {
      return;
    }
    
    vmmSystem.removeMeeting(meetingId); // remove meeting specified
  }
}
