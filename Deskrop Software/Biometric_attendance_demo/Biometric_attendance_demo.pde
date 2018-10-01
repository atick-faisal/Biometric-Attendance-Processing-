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
String attendance = "";
char att[];



void setup() {
  size(900, 600);
  background(0);
  font = loadFont("Ubuntu-24.vlw");
  textFont(font, 24);
  fill(200);
  text(prompt, width/2 - prompt.length()*12, height/2 - 24);
  
  client = new MQTTClient(this);
  client.connect("tcp://192.168.0.104", "processing");
  client.subscribe("roll");
  
  ///////////////////////////////
  attendance = attendance + String.format("%02d", day()) + "/" + String.format("%02d", month()) + "/" + String.format("%04d", year()) + ","; 
  for(int i=1; i<=5; i++) {
    if(i == 5) {
      attendance += "0\n";
    } else {
      attendance += "0,";
    }
  }
  att = attendance.toCharArray();
  drawMatch(1);
}

void draw() {
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
  roll = Integer.parseInt(new String(payload));
  drawMatch(roll);
}

void drawMatch(int roll) {
  background(255);
  noStroke();
  fill(63, 81, 181);
  rect(0,0,width,82);
  fill(255);
  text(title, 100, 50);
  fill(220);
  rect(0,82,200,height-82);
  font = loadFont("Ubuntu-Bold-24.vlw");
  textFont(font, 24);
  fill(56, 142, 60);
  text(m, 230, 120);
  fill(70);
  font = loadFont("Ubuntu-Bold-24.vlw");
  textFont(font, 16);
  text("Name", 30, 170);
  text("Roll", 30, 200);
  text("Year", 30, 230);
  text("Total Present", 30, 260);
  text("Total Absent", 30, 290);
  text("Attendance", 30, 320);
  String ImageName = Integer.toString(roll) + ".jpg";
  img = loadImage(ImageName);
  image(img, width - 250, 30, 200, 200);
  img = loadImage("dna.png");
  fill(240);
  noStroke();
  ellipse(55,40,50, 50);
  image(img, 35, 20, 40, 40);
  noFill();
  stroke(255);
  strokeWeight(100);
  ellipse(width - 150, 130, 300, 300);
  String name = parseFile();
  fill(156, 39, 176);
  text(name, 230, 170);
  fill(70);
  text("SH-073-002", 230, 200);
  text("3rd Year, 2nd Semester", 230, 230); 
  fill(76, 175, 80);
  text(present, 230, 260);
  fill(255, 87, 34);
  text(absent, 230, 290);
  fill(63, 81, 181);
  text("80%", 230, 320);
  //////////////////////////////////////////////
  int index = (roll-1) * 2 + 11;
  att[index] = '1';
  //////////////////////////////////////////////
  total_days = present + absent;
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
}

String parseFile() {
  BufferedReader reader = createReader("name_roll.csv");
  String line = null;
  try {
    while ((line = reader.readLine()) != null) {
      String[] pieces = split(line, ",");
      int x = int(pieces[0]);
      String y = pieces[1];
      if(x == roll) {
        return y;
      }
    }
    reader.close();
  } catch (IOException e) {
    e.printStackTrace();
  }
  return "";
}

void keyPressed() {
  try {
    File file =new File("/home/andromeda/Desktop/attendance.csv");
 
    if (!file.exists()) {
      file.createNewFile();
    }
 
    FileWriter fw = new FileWriter(file, true);
    BufferedWriter bw = new BufferedWriter(fw);
    PrintWriter pw = new PrintWriter(bw);
 
    String s = new String(att);
    pw.write(s);
 
    pw.close();
  }
  catch(IOException ioe) {
    System.out.println("Exception ");
    ioe.printStackTrace();
  }
}
