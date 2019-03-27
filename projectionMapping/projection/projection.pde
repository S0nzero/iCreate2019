import processing.video.*;
import gab.opencv.*;
import java.awt.Rectangle;


//Initialize variables
PImage visitor;
OpenCV opencvNom;
OpenCV opencvVille;
OpenCV opencvDispute;
Rectangle[] faces;
Movie discours; 
Movie nom;
Movie ville;
Movie dispute;
Capture video;

boolean nomPlayed = false;
boolean villePlayed = false;
boolean disputePlayed = false;
boolean colorDetect = false;
color trackColor; 
color c;
float rc ;      
float gc ;      
float bc ;  

void setup() {
  size(1440, 1080);
  
  video = new Capture(this, 640, 480,"Logitech HD Webcam C270");
  
  // Start off tracking for red
  trackColor = color(255, 0, 0);
  visitor = loadImage("visitor.tif");
  // Initialize Movie object.
  discours = new Movie(this, "discours.mp4");  
  nom = new Movie(this, "nom.mp4");
  ville = new Movie(this, "ville.mp4");
  dispute = new Movie(this, "dispute.mp4");
  
  video.start();
}

void captureEvent(Capture video) {
  // Read image from the camera
  video.read();
}

// Read new frames from the movie.
void movieEvent(Movie movie) {  
  movie.read();
}

void draw() {
  if(colorDetect) {
    image(discours, 0, 0,1440,1080);
    if(discours.time() >= 35.5 && discours.time() <=36) {
      playNom();
    } else if(discours.time() >= 70 && discours.time() <=70.5) {
      playVille();
    } else if(discours.time() >= 97.5 && discours.time() <=98) {
      playDispute();
    } else {
      image(visitor,650,650,150,150);
    }
    if(nomPlayed && nom.time()>=nom.duration()) {
      discours.play();
      discours.jump(38);
      nomPlayed=false;
    } else if(villePlayed && ville.time()>=ville.duration()) {
      discours.play();
      discours.jump(72);
      villePlayed=false;
    } else if(disputePlayed && dispute.time()>=dispute.duration()) {
      discours.play();
      discours.jump(102);
      disputePlayed=false;
    }
  }
  else {
    colorTracking();
  }
}

void playNom(){
  if(!nomPlayed){
    discours.pause();
    delay(2000);
    nom.play();
    nomPlayed=true;
    opencvNom = new OpenCV(this, nom.width, nom.height);
    opencvNom.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  }
  while (nom.height == 0 )  delay(10); 
  opencvNom.loadImage(nom);
  faces = opencvNom.detect();
  if (faces != null) {
    for (int i = 0; i < faces.length; i++) {
      //850x750
        image(nom, 650 ,650,150,150,(faces[i].x)+1,faces[i].y+1,(faces[i].width)+faces[i].x,(faces[+i].height)+faces[i].y); 
      }
  }
}

void playVille(){
  if(!villePlayed){
    discours.pause();
    ville.play();
    villePlayed=true;
    opencvVille = new OpenCV(this, ville.width, ville.height);
    opencvVille.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  }
  while (ville.height == 0 )  delay(10); 
  opencvVille.loadImage(ville);
  faces = opencvVille.detect();
  if (faces != null) {
    for (int i = 0; i < faces.length; i++) {
      //850x750
        image(ville, 650 ,650,150,150,(faces[i].x)+1,faces[i].y+1,(faces[i].width)+faces[i].x,(faces[+i].height)+faces[i].y); 
      }
  }
}

void playDispute(){
  if(!disputePlayed){
    discours.pause();
    delay(10);
    dispute.play();
    disputePlayed=true;
    opencvDispute = new OpenCV(this, dispute.width, dispute.height);
    opencvDispute.loadCascade(OpenCV.CASCADE_FRONTALFACE);
  }
  while (dispute.height == 0 )  delay(10); 
  opencvDispute.loadImage(dispute);
  faces = opencvDispute.detect();
  if (faces != null) {
    for (int i = 0; i < faces.length; i++) {
      //850x750
        image(dispute, 650 ,650,150,150,(faces[i].x)+1,faces[i].y+1,(faces[i].width)+faces[i].x,(faces[+i].height)+faces[i].y); 
      }
  }
}

void colorTracking() {
 video.loadPixels();
  image(video, 250, 250);

  for (int x = 0; x < video.width; x ++ ) {
    for (int y = 0; y < video.height; y ++ ) {
      int loc = x + y*video.width;
      color currentColor = video.pixels[loc];
      
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);
      float d = dist(r1, g1, b1, r2, g2, b2);
      
      //detecter si il y a la couleur
     if(r1>=170 && r1<=190 && b1>=65 && b1<=85 && g1>=95 && g1<=115) {
        delay(1000);
        video.stop();
        // Start playing movie.
        discours.play();
        colorDetect=true;
        discours.jump(30);
     }
    }
  }
}

void mousePressed() {
  // Save color where the mouse is clicked in trackColor variable
  int loc = (mouseX-250) + (mouseY-250)*video.width;
  trackColor = video.pixels[loc];
  //trouver coleur RGB
  rc = red  (video.pixels[loc]);      
  gc = green(video.pixels[loc]);      
  bc = blue (video.pixels[loc]);  
  rc = constrain(rc, 0, 255);      
  gc = constrain(gc, 0, 255);      
  bc = constrain(bc, 0, 255);      
  c = color(rc, gc, bc);
  println("R:"+rc+","+"G:"+gc+","+"B:"+bc);
}
