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

void setup() {
  size(600, 800);
  noStroke();
  
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
  
  logo = loadImage("logo.png");
  imageMode(CENTER);
  
  booster = new UiBooster();
  
  vmmSystem = new VMMSystemAdapter();
}

void draw() {
  background(10);
  textAlign(CENTER, CENTER);
  
  image(logo, width/2, 145);
}

public void viewall(int value){
  // activated by the button
  displayMeetings('a');
}

public void viewPast(int value){
  // activated by the button
  displayMeetings('p');
}

public void viewUpcoming(int value){
  // activated by the button
  displayMeetings('u');
}

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
    
    new UiBooster().showTableImmutable(
        meetingsFormatted,
        Arrays.asList("ID", "Name", "Description", "Date & Time", "URL"),
        title);
  }
}

private String getIdFromUser(String title, String prompt) {
  ArrayList<String> meetingsFormatted = new ArrayList<String>();
    
  ArrayList<HashMap<String, String>> meetingData = vmmSystem.getSortedMeetingData('a');
  
  int count = 1;
  
  for (HashMap<String, String> scheduled : meetingData) {
    meetingsFormatted.add(String.valueOf(count) + " | " + scheduled.get("name") + " - " + scheduled.get("time"));
    count++;
  }
  
  String selection;
  
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
  
  int index = Integer.parseInt(selection.substring(0, selection.indexOf(" | "))) - 1;
  
  return meetingData.get(index).get("id");
}

public void viewMeeting(int value) {
  // activated by the button
  if (millis() > 500) {
    String meetingId = getIdFromUser("Select Meeting", "Select which meeting to view:");
    
    if (meetingId == null) {
      return;
    }
    
    HashMap<String, String> meetingData = vmmSystem.getMeetingData(meetingId);
    
    if (meetingData == null) {
      return;
    }
    
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
      vmmSystem.repeatMeeting(meetingId);
    }
    else if (input != null) {
      link(meetingData.get("url"));
    }
  }
}


public void add(int value){
  // activated by the button
  if (millis() > 500) {
    vmmSystem.addMeeting();
  }
}

public void remove(int value){
  // activated by the button
  if (millis() > 500) {
    String meetingId = getIdFromUser("Remove Meeting?", "Select which meeting to remove:");
    
    if (meetingId == null) {
      return;
    }
    
    vmmSystem.removeMeeting(meetingId);
  }
}
