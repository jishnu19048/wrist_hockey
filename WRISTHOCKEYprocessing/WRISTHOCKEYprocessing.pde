import processing.sound.*;
import processing.serial.*;
SoundFile gg;
SoundFile lose;
Serial arduinoPort;
String val;

PImage bg;
int y=100;

float[] data={};
final int BALL_RADIUS=8;
final int BALL_DIAMETER=BALL_RADIUS*2;
final int MAX_VELOCITY=16;
final int MARGIN=10;
final int PADDLE_WIDTH=200;
final int PADDLE_HEIGHT=20;

final int HEIGHT=300;
final int LINE_FEED=10;

int px, py;
int vx, vy;
int xpos=300;
int xpos1=300;
float arduino;
int songcount=0;
int losecount=0;
int COUNT=0;
int buzz=0;

int maxHealth = 100;
float health = 100;
float healthDecrease = 50;
int healthBarWidth = 60;
int maxHealth1 = 100;
float health1 = 100;
float healthDecrease1 = 50;
int healthBarWidth1 = 60;


boolean buttonPressed=false;
boolean paused=true;
boolean done=false;

void setup(){
  gg=new SoundFile(this,"run.mp3");
  lose=new SoundFile(this,"lose.mp3");
  size(600,600);
  //bg = loadImage("finalback.jpg");
  textFont(loadFont("Georgia-BoldItalic-90.vlw"));
  initGame();
  printArray(Serial.list());
  
  arduinoPort=new Serial(this, "/dev/cu.usbmodem14201", 9600);
  arduinoPort.bufferUntil(10);
}

void initGame(){
  
  initBall();
  drawPaddle();
  drawHealthBar();
  drawHealthBar1();
  
  
}
void initBall(){
  px=width/2;
  py=height/2;
  vx=int(random(-MAX_VELOCITY, MAX_VELOCITY));
  vy=2;
}

void draw(){

  background(0);
  fill(255,0,0);
  stroke(0,0,255);
  //line(0,y,width,y);
  //y++;
  //if (y>height) {
   // y=0;
  
  //}
  strokeWeight(60);
  
  while(songcount==0)
  {
  gg.play();
  gg.amp(0.6);
  songcount++;
  }
  
  
  if((health!=0)&((health1!=0)))
  {
  drawBall();
  drawPaddle();
  drawPaddle1();
  drawHealthBar();
  drawHealthBar1();
  arduinoPort.write('0');
  }
  else if (health==0)
  {
  background(0);
  fill(225);
  textSize(36);
  textAlign(CENTER);
  text("GAME OVER PLAYER 2 WINS", width/2, height*2/3);
  gg.stop();
  while (buzz==0)
  {
    arduinoPort.write('1');
    println("1");
    buzz++;
  }
  while(losecount==0)
  {
  lose.play();
  losecount++;
  }
  if(buttonPressed)
  {
    health1=100;
    health=100;
    songcount=0;
    losecount=0;
    buzz=0;
    y=200;
    done=false;
  }
  }
  
    
  else if (health1==0)
  {
  background(0);
  fill(225);
  textSize(36);
  textAlign(CENTER);
  text("GAME OVER PLAYER 1 WINS", width/2, height*2/3);
  gg.stop();
  while (buzz==0)
  {
    arduinoPort.write('1');
    println("1");
    buzz++;
  }
  while(losecount==0)
  {
  lose.play();
  losecount++;
  }
  if(buttonPressed)
  {
    health1=100;
    health=100;
    songcount=0;
    losecount=0;
    buzz=0;
    y=200;
    done=false;
  }
  }
  if(paused)
    printPauseMessage();
  else
    updateGame();
    
  if(done==true)
    {
     fill(255,0,0);
     rect(0,0,600,y);
     y++;
     if (y==500){
       y=100;
     }
    }
    
     //if(py+vy <=height/2 )
       
       
       
    //}
       
      
    
  

}

void keyPressed() 
{ if(keyCode==SHIFT)
  {
  if (done == false)
  {
    done = true;
  } else 
  {
    done = false;
  }
  }
}
  

void drawBall(){
  strokeWeight(0);
  fill(255,0, 0);
  ellipse(px, py, BALL_DIAMETER,  BALL_DIAMETER);
}

void drawPaddle(){
  if((xpos- PADDLE_WIDTH/2)<=0)
  {  
  xpos=PADDLE_WIDTH/2;
  int y=height - 25;
  fill(0,0,255);
  rect(0, y, 200, 20);
  }
  if((xpos- PADDLE_WIDTH/2)!=0)
  {
  int x=xpos- PADDLE_WIDTH/2;
  int y=height - 25;
  
  
  fill(0,0,255);
  rect(x, y, 200, 20);
  }
  if ((xpos-PADDLE_WIDTH/2)>=600-PADDLE_WIDTH)
  {
  xpos=600-PADDLE_WIDTH/2;
  int y=height - 25;
  fill(0,0,225);
  rect(600-PADDLE_WIDTH, y, 200, 20);
  }
}

void drawPaddle1(){
  
  if((xpos1- PADDLE_WIDTH/2)<=0)
  {  
  xpos1=PADDLE_WIDTH/2;
  int y=height - 590;
  fill(0,0,255);
  rect(0, y, 200, 20);
  }
  if((xpos1- PADDLE_WIDTH/2)!=0)
  {
  int x=xpos1- PADDLE_WIDTH/2;
  int y=height - 590;
  
  
  fill(0,0,255);
  rect(x, y, 200, 20);
  }
  if ((xpos1-PADDLE_WIDTH/2)>=600-PADDLE_WIDTH)
  {
  xpos1=600-PADDLE_WIDTH/2;
  int y=height - 590;
  fill(0,0,225);
  rect(600-PADDLE_WIDTH, y, 200, 20);
  }
}

void drawHealthBar() {
  noStroke();
  fill(236, 240, 241);
  rectMode(CORNER);
  if((xpos- PADDLE_WIDTH/2)<=0)
  rect (0, height- 35, healthBarWidth, 5);
  else if((xpos- PADDLE_WIDTH/2)>=600-PADDLE_WIDTH)
  rect (600-PADDLE_WIDTH, height- 35, healthBarWidth, 5);
  else
  rect (xpos- PADDLE_WIDTH/2, height- 35, healthBarWidth, 5);
  if (health > 60) {
    fill(46, 204, 113);
  } else if (health > 30) {
    fill(230, 126, 34);
  } else {
    fill(231, 76, 60);
  }
  rectMode(CORNER);
  if((xpos- PADDLE_WIDTH/2)<=0)
  rect(0, height- 35 , healthBarWidth*(health/maxHealth), 5);
  else  if((xpos- PADDLE_WIDTH/2)>=600-PADDLE_WIDTH)
  rect(600-PADDLE_WIDTH, height- 35 , healthBarWidth*(health/maxHealth), 5);
  else
  rect(xpos- PADDLE_WIDTH/2, height- 35 , healthBarWidth*(health/maxHealth), 5);
  }

void decreaseHealth() {
  health-= healthDecrease;
}  




void drawHealthBar1() {
  noStroke();
  fill(236, 240, 241);
  rectMode(CORNER);
  if((xpos1- PADDLE_WIDTH/2)<=0)
  rect (0, height- 565, healthBarWidth1, 5);
  else if((xpos1- PADDLE_WIDTH/2)>=600-PADDLE_WIDTH)
  rect (600-PADDLE_WIDTH, height- 565, healthBarWidth1, 5);
  else
  rect (xpos1- PADDLE_WIDTH/2, height- 565, healthBarWidth1, 5);
  if (health1 > 60) {
    fill(46, 204, 113);
  } else if (health1 > 30) {
    fill(230, 126, 34);
  } else {
    fill(231, 76, 60);
  }
  rectMode(CORNER);
  if((xpos1- PADDLE_WIDTH/2)<=0)
  rect(0, height- 565 , healthBarWidth1*(health1/maxHealth1), 5);
  else  if((xpos1- PADDLE_WIDTH/2)>=600-PADDLE_WIDTH)
  rect(600-PADDLE_WIDTH, height- 565 , healthBarWidth1*(health1/maxHealth1), 5);
  else
  rect(xpos1- PADDLE_WIDTH/2, height- 565 , healthBarWidth1*(health1/maxHealth1), 5);
  }
void decreaseHealth1() {
  health1-= healthDecrease1;
}  
    
void printPauseMessage(){
  fill(234,34,123);
  textSize(48);
  textAlign(CENTER);
  text("TOUCH TO START", width/2, height*5/6);
  fill(234,34,123);
  textSize(24);
  textAlign(CENTER);
  if((health==100)&(health1==100))
  text("PRESS SHIFT TO PLAY SINGLEPLAYER", width/2, height*1/3);
} 


  
  

void updateGame(){
  if (ballDroppedDOWN()&(health!=0)&(health1!=0)){
    initBall();
    paused=true;
    decreaseHealth();
  }else if (ballDroppedUP()&(health!=0)&(health1!=0)){
    initBall();
    paused=true;
    decreaseHealth1();
    
 
    
    
    
  } else{
   
    checkWallCollision();
    checkPaddleCollision();
    checkPaddle1Collision();
    px+=vx;
    py+=vy;
  }
  
}

boolean ballDroppedDOWN(){
  return py+vy> height - BALL_RADIUS;
        
         
}

boolean ballDroppedUP(){
  return py+vy< 0;
}




void checkWallCollision(){
  if(px+vx < BALL_RADIUS || px+vx > width - BALL_RADIUS)
  vx=-vx;
  
  if(done)
  {
    if (py+vy < y-BALL_RADIUS+13)
      vy=-vy;
  }
  
 
}

void checkPaddleCollision(){
  final int cx=xpos;
  if(py+vy >=height - (PADDLE_HEIGHT + MARGIN )&&
    px >= cx - PADDLE_WIDTH/2 &&
    px <= cx + PADDLE_WIDTH/2)
    {
      vy=-vy;
      vx=int(
        map(
          px - cx,
          -(PADDLE_WIDTH/2), PADDLE_WIDTH/2,
          -MAX_VELOCITY,
          MAX_VELOCITY
        )
      );
    }
}
void checkPaddle1Collision(){
  final int cx=xpos1;
  if (py+vy<=height- 590+ MARGIN + 15 && px>=cx-PADDLE_WIDTH/2 && px<=cx+PADDLE_WIDTH/2)
  {
      vy=-vy;
      vx=int(
          map(
              px-cx,
              -(PADDLE_WIDTH/2),PADDLE_WIDTH/2,
              -MAX_VELOCITY,
              MAX_VELOCITY
            )
           );
  }
}

void serialEvent(Serial Port){
 
  String arduinoData=Port.readStringUntil('\n');
  println(arduinoData);
  float[] data=float(split(trim(arduinoData), ' '));
  println(data);
 if(data.length==3)
   {
     buttonPressed=(int(data[2])==1);
  if(buttonPressed){
        paused= !paused;}
      if(!paused)
      xpos=int(map(data[0]*700, 252, 443, 0, 300));
      xpos1=int(map(data[1]*700, 252, 443, 0, 300));
   }
}
