int sizeX = 350;//350
int sizeY = 650;//650

//BIRD 
float birdWidth = 40;
float birdHeight = birdWidth*0.9;
float birdX = 0.25*sizeX;
float birdY = 0;
float fallSpeed = 6.5;
float jumpSpeed = fallSpeed *1.5;

//PIPE
float pipeX = sizeX*2;
float pipeLength = sizeY/3;
float pipeWidth = 50;
float ornWidth= pipeWidth+pipeWidth/10;
float ornHeight = pipeLength/12;
float pipeChange = random(sizeY/3);

//GAME & GENERAL
boolean highscoreReached = false;
int highscore = 0;
float pipeSpeed = 2;
int score = 0;
boolean collision = false;
boolean gameOver = false;
int f = 0;

//RESET GAME AFTER REPLAY
void gameReset(){
  birdY = 0;
  pipeX = sizeX*2;
  gameOver = false;
  f = 0;
  score = 0;
  highscoreReached = false;
  collision = false;
  fallSpeed = 8;
}

void setup(){
  size(350,650); //350,650
  stroke(0);
}

void draw(){
  clear();
  background(137, 205, 245);
  fill(255);
  f+=1;
  rectMode(CENTER);
  drawBackground();
  drawPipe(pipeX);
  drawBird(new PVector(birdX,birdY));
  drawForeground();
  scoreBoard();
  
  //IF GAME IS NOT OVER
  if(!gameOver){
    
    //BIRD MOVEMENT
      if(!collision && keyPressed && keyCode == UP)birdY -= jumpSpeed;
      else birdY += fallSpeed;
      
    //IF BIRD COLLIDES WITH PIPE OR GROUND
    if(collision()){
      collision = true;
      fallSpeed += 1;
      //gameOver=true;
    }
    //IF BIRD DOES NOT COLLIDE
    else{
      pipeX -= pipeSpeed;
      
      //PIPE MOVEMENT + SCORE
      if(pipeX < -pipeWidth){
        score +=1;
        pipeChange = random(10)*15;
        if(score%2 ==0)pipeChange *= -1;
        pipeX = sizeX+pipeWidth;
        
        //IF HIGHSCORE IS BEAT
        if(score > highscore){
          highscore = score;
          highscoreReached = true;
        } 
      }
    }
    
    //GAME OVER
    if(birdY > sizeY-birdHeight/2){
      gameOver = true;
    }
  }//if game is not over 
  
  //IF GAME IS OVER
  else{
    gameOverMessage();
    if(keyPressed && key == TAB)gameReset();
  }
 
 }
 
void drawPipe(float pipeX){
  fill(45, 150, 66);
  
  
  
  //TOP PIPE
  rect(pipeX,0+pipeChange,pipeWidth,pipeLength*2);
  rect(pipeX,pipeLength-ornHeight/2+pipeChange,ornWidth,ornHeight);//ornament
  
  //BOTTOM PIPE
  rect(pipeX,sizeY+pipeChange,pipeWidth,pipeLength*2);
  rect(pipeX,sizeY-pipeLength+ornHeight/2+pipeChange,ornWidth,ornHeight); //ornament
  
  fill(255);
}
 
void drawBird(PVector pos){
  //BIRD BODY
  fill(255, 243, 20);
  ellipse(pos.x,pos.y,birdWidth,birdHeight);
  //BIRDS WING
  fill(255);
  ellipse(pos.x-birdWidth*0.35,pos.y+(sin(f)*5),0.5*birdWidth,0.4*birdHeight);
  //BIRDS EYE
  ellipse(pos.x+birdWidth*0.3,pos.y-birdWidth*0.2,0.4*birdWidth,0.5*birdHeight);
  fill(0);
  ellipse(pos.x+birdWidth*0.4,pos.y-birdWidth*0.25,0.05*birdWidth,0.2*birdHeight);
  //BIRD BEAK 
  fill(250, 123, 5);
  ellipse(pos.x+birdWidth*0.45,pos.y+birdHeight*0.08,0.4*birdWidth,0.15*birdHeight);//top lip
  ellipse(pos.x+birdWidth*0.43,pos.y+birdHeight*0.2,0.3*birdWidth,0.15*birdHeight); // bottom lip
  
  fill(255);
}

void drawBackground(){
  fill(255);
  drawCloud(0.1*sizeX,50,0.1*sizeX);
  drawCloud(0.4*sizeX,100,0.15*sizeX);
  drawCloud(0.6*sizeX,200,0.09*sizeX);
  drawCloud(0.9*sizeX,80,0.15*sizeX);
}

void drawForeground(){
    drawCloud(0.2*sizeX,sizeY,0.27*sizeX);
    drawCloud(0.3*sizeX,sizeY,0.1*sizeX);
    drawCloud(0.7*sizeX,sizeY,0.15*sizeX);
    drawCloud(0.9*sizeX,sizeY,0.2*sizeX);
}

void drawCloud(float cloudX,float cloudY,float size){
  noStroke();
  //CENTER BIG
  ellipse(cloudX,cloudY,size,size);
  //LEFT RIGHT MEDIUM
  ellipse(cloudX+0.5*size,cloudY+0.1*size,0.8*size,0.8*size);
  ellipse(cloudX-0.5*size,cloudY+0.1*size,0.8*size,0.8*size);
  //LEFT RIGHT SMALL
  ellipse(cloudX+0.9*size,cloudY+0.15*size,0.5*size,0.5*size);
  ellipse(cloudX-0.9*size,cloudY+0.15*size,0.5*size,0.5*size);
  stroke(0);
}

boolean collision(){
  
  float frontOfBird = birdX+birdWidth/2;
  float backOfBird = birdX-birdWidth/2;
  float topOfBird = birdY - birdHeight/2;
  float bottomOfBird = birdY + birdHeight/2;
  float frontOfPipes = pipeX-pipeWidth/2;
  float backOfPipes = pipeX + pipeWidth/2;
  float bottomOfTopPipe = pipeLength+pipeChange;
  float topOfBottomPipe = sizeY-pipeLength+pipeChange;
  
  if(frontOfBird >= frontOfPipes &&  backOfBird <= backOfPipes){
    if(!(topOfBird > bottomOfTopPipe && bottomOfBird < topOfBottomPipe)){
      collision =true;
    }
  }
 
  //NEEDS TO BE EDITTED
  return collision;
}

void gameOverMessage(){
  stroke(0);
  rectMode(CENTER);
  rect(sizeX/2,sizeY/2,sizeX/2,sizeY/4);
  rectMode(CORNER);
  fill(0);
  textAlign(CENTER);
  textSize(20);
  text("GAME OVER",sizeX/2,sizeY/2);
  textSize(14);
  text("Press TAB to replay",sizeX/2,sizeY/2+30);
  fill(255);
}

void scoreBoard(){
  rectMode(CENTER);
  if(highscoreReached){
    fill(255, 243, 20);
    //if(pipeX%10 == 0)fill(random(1)*255,random(1)*255,random(1)*255);
    
  }
  stroke(0);
  rect(sizeX-sizeX*0.11,20,72,20);
  fill(0);
  textSize(10);
  text("Highscore: "+highscore,sizeX-sizeX*0.11,25);
  rectMode(CORNER);
  textAlign(CENTER);
  textSize(36);
  text(score,sizeX/2,50);
  fill(255);
  
}
