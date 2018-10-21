////////////////////////////////////////////////////////////////////////////////////////////////
//-------------------------------------Atick Faisal, 2018-------------------------------------//
////////////////////////////////////////////////////////////////////////////////////////////////

import mqtt.*;
import java.io.FileWriter;
import java.io.*;

MQTTClient client;
FileWriter fw;
BufferedWriter bw;
PrintWriter input;

PFont font;
PImage img;
String prompt = "Finding Match...";
String m = "Match Found";
String title = "Biometric Attendance";
int roll = 1;
int present = 15, absent = 5, total_days;
float prcnt = 0;
String attendance = "";
char att[];



void setup() {
  size(900, 600);
  drawInitialPrompt();
  _init_attendance_();
  connect();
  //matchFound(1);
}

void draw() {
  //----------nothing here------------//
}

//////////////////////////////////////////////////////////////////////////////////////////////////////
void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
  roll = Integer.parseInt(new String(payload));
  matchFound(roll);
}
//////////////////////////////////////////////////////////////////////////////////////////////////////
void matchFound(int roll) {
  //------------blue border---------------//
  background(255);
  noStroke();
  fill(63, 81, 181);
  rect(0,0,width,82);
  //-------------title-------------//
  fill(255);
  font = loadFont("Ubuntu-24.vlw");
  textFont(font, 24);
  text(title, 100, 50);
  //--------------side bar---------------//
  fill(220);
  rect(0,82,200,height-82);
  fill(90);
  font = loadFont("Ubuntu-Bold-16.vlw");
  textFont(font, 16);
  text("Name", 30, 170);
  text("Roll", 30, 195);
  text("Year", 30, 220);
  text("Total Present", 30, 245);
  text("Total Absent", 30, 270);
  text("Attendance", 30, 295);
  fill(63, 81, 181);
  rect(10, height - 70, 180, 50);
  fill(255);
  font = loadFont("Ubuntu-Bold-16.vlw");
  textFont(font, 16);
  text("Save and Exit", 42, height - 40);
  //--------------match found---------------//
  font = loadFont("Ubuntu-Bold-24.vlw");
  textFont(font, 24);
  fill(56, 142, 60);
  text(m, 230, 120); 
  //---------------image---------------//
  String ImageName = Integer.toString(roll) + ".jpg";
  img = loadImage(ImageName);
  image(img, width - 250, 30, 200, 200);
  noFill();
  stroke(255);
  strokeWeight(100);
  ellipse(width - 150, 130, 300, 300);
  //---------------icon---------------//
  img = loadImage("dna.png");
  fill(240);
  noStroke();
  ellipse(55,40,50, 50);
  image(img, 35, 20, 40, 40);
  //-------------student info--------------//
  font = loadFont("Ubuntu-Bold-16.vlw");
  textFont(font, 16);
  String name = getStudentName(roll);
  String fullRoll = getStudentRoll(roll);
  String year = getStudentYear(roll);
  fill(156, 39, 176);
  text(name, 230, 170);
  fill(70);
  text(fullRoll, 230, 195);
  text(year, 230, 220); 
  fill(76, 175, 80);
  present = getPresent(roll);
  text(present, 230, 245);
  fill(255, 87, 34);
  absent = getTotal() - present;
  text(absent, 230, 270);
  fill(63, 81, 181);
  total_days = present + absent;
  prcnt = (present*100) / total_days;
  text(prcnt + "%", 230, 295);
  //-----------------chart---------------//
  int p_bar = (present*200)/total_days;
  float a_bar = (absent*200)/total_days;
  fill(76, 175, 80);
  noStroke();
  rect(370, height - p_bar - 50, 100, p_bar);
  fill(255, 152, 0);
  rect(500, height - a_bar - 50, 100, a_bar);
  fill(120);
  font = loadFont("Ubuntu-Bold-24.vlw");
  textFont(font, 12);
  text("Present", 400, height - 30);
  text("Absent", 530, height - 30);
  //////////////////////////////////////////////
  int index = (roll-1) * 2 + 11;
  att[index] = '1';
  ////////////////////////////////////////////// 
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////
String getStudentName(int r) {
  BufferedReader reader = createReader("name_roll.csv");
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, ",");
      int x = int(pieces[0]);
      String y = pieces[2];
      if(x == r) {
        return y;
      }
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  return "";
}
////////////////////////////////////////////////////////////////////////////////////////////////
String getStudentRoll(int r) {
  BufferedReader reader = createReader("name_roll.csv");
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, ",");
      int x = int(pieces[0]);
      String y = pieces[1];
      if(x == r) {
        return y;
      }
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  return "";
}
////////////////////////////////////////////////////////////////////////////////////////////////
String getStudentYear(int r) {
  BufferedReader reader = createReader("name_roll.csv");
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, ",");
      int x = int(pieces[0]);
      String y = pieces[3];
      if(x == r) {
        return y;
      }
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  return "";
}
/////////////////////////////////////////////////////////////////////////////////////////////////
int getPresent(int r) {
  BufferedReader reader = createReader("attendance.csv");
  int present = 0;
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, ",");
      int x = int(pieces[r]);
      present += x;
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  return present;
}
//////////////////////////////////////////////////////////////////////////////////////////////////
int getTotal() {
  BufferedReader reader = createReader("attendance.csv");
  int counter = 0;
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      counter++;
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  return counter;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
void mouseClicked() {
  try {
    File file =new File(sketchPath() + "/data/attendance.csv");
 
    if (!file.exists()) {
      file.createNewFile();
    }
 
    FileWriter fw = new FileWriter(file, true);
    BufferedWriter bw = new BufferedWriter(fw);
    PrintWriter pw = new PrintWriter(bw);
 
    String s = new String(att);
    pw.write(s);
 
    pw.close();
    exit();
  }
  catch(IOException ioe) {
    System.out.println("Exception ");
    ioe.printStackTrace();
  }
}

//////////////////////////////////////////////////////////////////////////////////////////////////
void _init_attendance_() {
  attendance = attendance + String.format("%02d", day()) + "/" + String.format("%02d", month()) + "/" + String.format("%04d", year()) + ","; 
  for(int i=1; i<=5; i++) {
    if(i == 5) {
      attendance += "0\n";
    } else {
      attendance += "0,";
    }
  }
  att = attendance.toCharArray();
}
///////////////////////////////////////////////////////////////////////////////////////////////////
void connect() {
  BufferedReader reader = createReader("ip.txt");
  String line = null;
  try {
    line = reader.readLine();
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  //////////////////////////////////////////////
  client = new MQTTClient(this);
  client.connect("tcp://" + line, "processing");
  client.subscribe("roll");
}
///////////////////////////////////////////////////////////////////////////////////////////////////
void drawInitialPrompt() {
  background(255);
  img = loadImage("report.png");
  image(img, 318, 120);
  font = loadFont("Ubuntu-24.vlw");
  textFont(font, 24);
  fill(120);
  text(prompt, width/2 - prompt.length()*6, height/2 + 150);
}
