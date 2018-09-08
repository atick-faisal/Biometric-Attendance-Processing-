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
int roll;
String attendance = "";
char att[];



void setup() {
  fullScreen();
  background(236);
  font = loadFont("Ubuntu-Light-48.vlw");
  textFont(font, 48);
  fill(72);
  text(prompt, width/2 - prompt.length()*12, height/2 - 24);
  
  client = new MQTTClient(this);
  client.connect("tcp://192.168.0.120", "processing");
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
}

void draw() {
}

void messageReceived(String topic, byte[] payload) {
  println("new message: " + topic + " - " + new String(payload));
  roll = Integer.parseInt(new String(payload));
  drawMatch(roll);
}

void drawMatch(int roll) {
  background(236);
  text(m, width/2 - m.length()*12, 100);
  String ImageName = Integer.toString(roll) + ".png";
  img = loadImage(ImageName);
  image(img, width/2 - 72, height/2 - 200, 144, 180);
  String name = parseFile();
  text(name, width/2 - name.length()*10, 500);
  //////////////////////////////////////////////
  int index = (roll-1) * 2 + 11;
  att[index] = '1';
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
