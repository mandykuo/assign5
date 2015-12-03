final int GAME_READY = 0;
final int GAME_START = 1;
final int GAME_RUN = 2;
final int GAME_WIN = 3;
final int GAME_OVER = 4;

final int ENEMY_RUN1 = 1;
final int ENEMY_RUN2 = 2;
final int ENEMY_RUN3 = 3;

final int numFlame=5;

float fighterW = 50;
float fighterH = 50;
float speed = 5;
float spacingenemyX = 60;
float spacingenemyY= 40;
float enemyW = 60;
float enemyH = 60;


float treasureW = 40;
float treasureH = 40;

boolean upPressed = false;
boolean downPressed = false;
boolean leftPressed = false;
boolean rightPressed = false;

int gameState;
int enemyRun=ENEMY_RUN1;
int blood=0;
int treasureX=floor(random(640));
int treasureY=floor(random(480));
int backgroundX;
int fighterX = 590;
int fighterY = 240;
int enemyX;
int enemyY;


int[]R1EnemyX =new int[5];
int[]R1EnemyY =new int[5];
int[]R1EnemyYFlame =new int[5];
int[]R2EnemyX =new int[5];
int[]R2EnemyY =new int[5];
int[]R2EnemyYFlame =new int[5];
int[]R3EnemyX =new int[5];
int[]R3EnemyY1 =new int[5];
int[]R3EnemyY1Flame =new int[5];
int[]R3EnemyY2 =new int[5];
int[]R3EnemyY2Flame =new int[5];
int[]R3EnemyY3 =new int[5];
int[]R3EnemyY3Flame =new int[5];

float[]bulletX = new float[5];
float[]bulletY = new float[5];
boolean bulletOpen = false;
boolean[]bulletShow = new boolean[6];
int bulletCounter = 0;
int score = 0;



PImage enemy, fighter, treasure, hp_bar, bg1, bg2, 
  start_light, start_dark, end_light, end_dark, bullet;

int numFrames = 5;
int curFlame;
PImage []flame=new PImage [numFrames];

void setup () {

  size(640, 480);

  //load images
  enemy=loadImage("img/enemy.png");
  fighter=loadImage("img/fighter.png");
  treasure=loadImage("img/treasure.png");
  hp_bar=loadImage("img/hp.png");
  bg1=loadImage("img/bg1.png");
  bg2=loadImage("img/bg2.png");
  start_light=loadImage("img/start1.png");
  start_dark=loadImage("img/start2.png");
  end_light=loadImage("img/end1.png");
  end_dark=loadImage("img/end2.png");
  bullet = loadImage("img/shoot.png");

  curFlame=0;
  for (int i=0; i<5; i++) {
    flame[i] = loadImage("img/flame"+(i+1)+".png");
  }
  frameRate(60);

  for (int i = 0; i<5; i++) {
    bulletShow[i] = false;
    bulletX[i] = 0;
    bulletY[i] = 0;
  }

  gameState = GAME_START;

  textSize(30);
}

void draw() {

  //press button effect fighter movement
  if (upPressed) {
    fighterY -= speed;
  }
  if (downPressed) {
    fighterY += speed;
  }
  if (leftPressed) {
    fighterX -= speed;
  }
  if (rightPressed) {
    fighterX += speed;
  }

  //fighter boundary detection
  if (fighterX>width-50) {
    fighterX=width-50;
  }
  if (fighterX<0) {
    fighterX=0;
  }
  if (fighterY>height-50) {
    fighterY=height-50;
  }
  if (fighterY<0) {
    fighterY=0;
  }


  //treasure boundary detection
  if (treasureX>width-50) {
    treasureX=width-50;
  }
  if (treasureX<0) {
    treasureX=0;
  }
  if (treasureY>height-50) {
    treasureY=height-50;
  }
  if (treasureY<0) {
    treasureY=0;
  }


  //background setup  
  background(0);
  image(start_dark, 0, 0);
  // println("blood: "+blood);
  //gameState setting
  switch (gameState) {

  case GAME_START:
    // mouse action
    if (mouseX >210 && mouseX < 450 && mouseY > 380 && mouseY < 430) {
      if (mousePressed) {
        // click
        gameState = GAME_RUN;
      } else {
        // hover
        image(start_light, 0, 0);
      }
    }
    break; 

  case GAME_READY: //replace HP and fighter
    image(bg2, 0, 0);
    blood=0;
    fighterX=590;
    fighterY=240;
    gameState=GAME_RUN;


  case GAME_RUN:
    //background
    image(bg1, backgroundX, 0);
    image(bg2, backgroundX-640, 0);
    image(bg1, backgroundX-1280, 0);
    backgroundX++;
    backgroundX%=1280;
    text("score:"+score, 50, 450);
    //enemy
    switch(enemyRun) {

    case ENEMY_RUN1:
      bulletFunction();
      if (enemyY>height-50) {
        enemyY=height-50;
      }
      if (enemyY<50) {
        enemyY=50;
      }

      for (int i=0; i<5; i++) {
        R1EnemyX[i]=enemyX-i*65;

        if (R1EnemyY[i]!=1000) {
          R1EnemyY[i]=enemyY;
          image(enemy, R1EnemyX[i], R1EnemyY[i]);
          if (fighterX < R1EnemyX[i]+enemyW &&
            R1EnemyX[i] < fighterX+fighterW &&
            fighterY < R1EnemyY[i]+enemyH &&
            R1EnemyY[i] < fighterY + fighterH) {
            println("1");
            blood-=40;
            R1EnemyY[i]=1000;
          }
          for (int j = 0; j<5; j++)
          {
            if (bulletX[j] > R1EnemyX[i]-35 &&
              bulletX[j] < R1EnemyX[i]+35 &&
              bulletY[j] > R1EnemyY[i]-35 &&
              bulletY[j] < R1EnemyY[i]+35) 
            {
              bulletY[j] = -100;
              R1EnemyY[i]=1000;
              text("score:"+score, 50, 450);
              score+=20;
            }
          }
        } else {
          println("hello");
          if (R1EnemyYFlame[i] != 5) {
            image(flame[R1EnemyYFlame[i]], R1EnemyX[i], enemyY);
          }
          if (frameCount % 10 ==0) {
            // println("frameCount: "+frameCount);
            if (R1EnemyYFlame[i] != 5) {
              R1EnemyYFlame[i]++;
            }
            // println("curFlame: "+curFlame);
            // curFlame = curFlame % numFlame;
          }
        }
      }
      if (enemyX >= 900) {
        enemyRun=ENEMY_RUN2;
        enemyX=0;
        enemyY=floor(random(50, 200));
        for (int i=0; i<5; i++) {
          R2EnemyX[i]=0;
          R2EnemyY[i]=floor(random(420));
          R2EnemyYFlame[i] = 0;
        }
      }


      break;

    case ENEMY_RUN2:
      bulletFunction();
      if (enemyY>height-280) {
        enemyY=height-280;
      }
      if (enemyY<100) {
        enemyY=100;
      }

      for (int i=0; i<5; i++) {
        R2EnemyX[i]=enemyX-i*65;
        if (R2EnemyY[i]!=1000) {
          R2EnemyY[i]=enemyY+i*40;
          image(enemy, R2EnemyX[i], R2EnemyY[i]);
          if (fighterX < R2EnemyX[i]+enemyW &&
            R2EnemyX[i] < fighterX+fighterW &&
            fighterY < R2EnemyY[i]+enemyH &&
            R2EnemyY[i] < fighterY + fighterH) {
            println("2");
            blood-=40;
            R2EnemyY[i]=1000;
          }

          for (int j = 0; j<5; j++)
          {
            if (bulletX[j] > R2EnemyX[i]-35 &&
              bulletX[j] < R2EnemyX[i]+35 &&
              bulletY[j] > R2EnemyY[i]-35 &&
              bulletY[j] < R2EnemyY[i]+35) 
            {
              bulletY[j] = -100;
              R2EnemyY[i]=1000;
              text("score:"+score, 50, 450);
              score+=20;
            }
          }
        } else
        {
          // println("curFlame: "+curFlame);
          if (R2EnemyYFlame[i] != 5) {
            image(flame[R2EnemyYFlame[i]], R2EnemyX[i], enemyY+i*40);
          }
          if (frameCount % 10 ==0) {
            // println("frameCount: "+frameCount);
            if (R2EnemyYFlame[i] != 5) {
              R2EnemyYFlame[i]++;
            }
            // println("curFlame: "+curFlame);
            // curFlame = curFlame % numFlame;
          }
        }
      }

      if (enemyX>=900) {
        enemyRun=ENEMY_RUN3;
        enemyX=0;
        enemyY=floor(random(100, 300));


        for (int i=0; i<5; i++) {
          R3EnemyX[i]=enemyX-i*60;
          R3EnemyY1Flame[i] = 0;
          R3EnemyY2Flame[i] = 0;
          R3EnemyY3Flame[i] = 0;
          if (i == 0 || i == 4) {
            R3EnemyY1[i]=enemyY;
          } else if (i == 1 || i == 3) {
            R3EnemyY2[i]=enemyY+1*40;
            R3EnemyY2[i+1]=enemyY-1*40;
          } else {
            R3EnemyY3[i]=enemyY+2*40;
            R3EnemyY3[i+1]=enemyY-2*40;
          }
        }
      }

      break;


    case ENEMY_RUN3:
      bulletFunction();
      if (enemyY>height-100) {
        enemyY=height-100;
      }
      if (enemyY<100) {
        enemyY=100;
      }

      for (int i=0; i<5; i++) {
        R3EnemyX[i]=enemyX-i*60;

        if (i == 0 || i == 4) {
          image(enemy, R3EnemyX[i], R3EnemyY1[i]); 
          if (R3EnemyY1[i] != 1000) {
            R3EnemyY1[i]=enemyY;
            if (fighterX < R3EnemyX[i]+enemyW &&
              R3EnemyX[i] < fighterX+fighterW &&
              fighterY < R3EnemyY1[i]+enemyH &&
              R3EnemyY1[i] < fighterY + fighterH) {
              println("3");


              blood-=40;
              R3EnemyY1[i]=1000;
              // }
            }

            for (int j = 0; j<5; j++)
            {
              if (bulletX[j] > R3EnemyX[i]-35 &&
                bulletX[j] < R3EnemyX[i]+35 &&
                bulletY[j] > R3EnemyY1[i]-35 &&
                bulletY[j] < R3EnemyY1[i]+35) 
              {
                bulletY[j] = -100;
                R3EnemyY1[i]=1000;
                text("score:"+score, 50, 450);
                score+=20;
              }
            }
          } else {
            // println("curFlame: "+curFlame);
            if (R3EnemyY1Flame[i] != 5) {
              image(flame[R3EnemyY1Flame[i]], R3EnemyX[i], enemyY);
            }
            if (frameCount % 10 ==0) {
              // println("frameCount: "+frameCount);
              if (R3EnemyY1Flame[i] != 5) {
                R3EnemyY1Flame[i]++;
              }
              // println("curFlame: "+curFlame);
              // curFlame = curFlame % numFlame;
            }
          }
        } else if (i == 1 || i == 3) {
          image(enemy, R3EnemyX[i], R3EnemyY2[i]);
          image(enemy, R3EnemyX[i], R3EnemyY2[i+1]);
          if (R3EnemyY2[i] != 1000) {
            R3EnemyY2[i]=enemyY+1*40;
            if (fighterX < R3EnemyX[i]+enemyW &&
              R3EnemyX[i] < fighterX+fighterW &&
              fighterY < R3EnemyY2[i]+enemyH &&
              R3EnemyY2[i] < fighterY + fighterH) {
              println("4");

              // image(flame[curFlame], R3EnemyX[i], R3EnemyY2[i]);
              // if (frameCount % (60/10)==0) {

              //   curFlame = (curFlame ++)% numFlame; 
              //   if (curFlame>4) {
              //     curFlame=0;
              //   }

              blood-=40;
              R3EnemyY2[i]=1000;
              // }
            }

            for (int j = 0; j<5; j++)
            {
              if (bulletX[j] > R3EnemyX[i]-35 &&
                bulletX[j] < R3EnemyX[i]+35 &&
                bulletY[j] > R3EnemyY2[i]-35 &&
                bulletY[j] < R3EnemyY2[i]+35) 
              {
                bulletY[j] = -100;
                R3EnemyY2[i]=1000;
                text("score:"+score, 50, 450);
                score+=20;
              }
            }
          } else {
            // println("curFlame: "+curFlame);
            if (R3EnemyY2Flame[i] != 5) {
              image(flame[R3EnemyY2Flame[i]], R3EnemyX[i], enemyY+1*40);
            }
            if (frameCount % 10 ==0) {
              // println("frameCount: "+frameCount);
              if (R3EnemyY2Flame[i] != 5) {
                R3EnemyY2Flame[i]++;
              }
              // println("curFlame: "+curFlame);
              // curFlame = curFlame % numFlame;
            }
          }
          if (R3EnemyY2[i+1] != 1000) {
            R3EnemyY2[i+1]=enemyY-1*40;
            if (fighterX < R3EnemyX[i]+enemyW &&
              R3EnemyX[i] < fighterX+fighterW &&
              fighterY < R3EnemyY2[i+1]+enemyH &&
              R3EnemyY2[i+1] < fighterY + fighterH) {
              println("4");

              image(flame[curFlame], R3EnemyX[i], R3EnemyY2[i+1]);
              if (frameCount % (60/10)==0) {

                curFlame = (curFlame ++)% numFlame; 
                if (curFlame>4) {
                  curFlame=0;
                }

                blood-=40;
                R3EnemyY2[i+1]=1000;
              }
            }

            for (int j = 0; j<5; j++)
            {
              if (bulletX[j] > R3EnemyX[i]-35 &&
                bulletX[j] < R3EnemyX[i]+35 &&
                bulletY[j] > R3EnemyY2[i+1]-35 &&
                bulletY[j] < R3EnemyY2[i+1]+35) 
              {
                bulletY[j] = -100;
                R3EnemyY2[i+1]=1000;
                text("score:"+score, 50, 450);
                score+=20;
              }
            }
          } else {
            // println("curFlame: "+curFlame);
            if (R3EnemyY2Flame[i] != 5) {
              image(flame[R3EnemyY2Flame[i]], R3EnemyX[i], enemyY-1*40);
            }
            if (frameCount % 10 ==0) {
              // println("frameCount: "+frameCount);
              if (R3EnemyY2Flame[i] != 5) {
                R3EnemyY2Flame[i]++;
              }
              // println("curFlame: "+curFlame);
              // curFlame = curFlame % numFlame;
            }
          }


          // image(enemy, R3EnemyX[i], R3EnemyY3[i]);
        } else {
          // image(enemy, R3EnemyX[i], R3EnemyY2[i]);
          image(enemy, R3EnemyX[i], R3EnemyY3[i]);
          image(enemy, R3EnemyX[i], R3EnemyY3[i+1]);
          if (R3EnemyY3[i] != 1000) {
            R3EnemyY3[i]=enemyY+2*40;

            if (fighterX < R3EnemyX[i]+enemyW &&
              R3EnemyX[i] < fighterX+fighterW &&
              fighterY < R3EnemyY3[i]+enemyH &&
              R3EnemyY3[i] < fighterY + fighterH) {
              println("5");

              // image(flame[curFlame], R3EnemyX[i], R3EnemyY3[i]);
              // if (frameCount % (60/10)==0) {

              //   curFlame = (curFlame ++)% numFlame; 
              //   if (curFlame>4) {
              //     curFlame=0;
              //   }

              blood-=40;
              R3EnemyY3[i]=1000;
              // }
            }

            for (int j = 0; j<5; j++)
            {
              if (bulletX[j] > R3EnemyX[i]-35 &&
                bulletX[j] < R3EnemyX[i]+35 &&
                bulletY[j] > R3EnemyY3[i]-35 &&
                bulletY[j] < R3EnemyY3[i]+35) 
              {
                bulletY[j] = -100;
                R3EnemyY3[i]=1000;
                text("score:"+score, 50, 450);
                score+=20;
              }
            }
          } else {
            // println("curFlame: "+curFlame);
            if (R3EnemyY3Flame[i] != 5) {
              image(flame[R3EnemyY3Flame[i]], R3EnemyX[i], enemyY+2*40);
            }
            if (frameCount % 10 ==0) {
              // println("frameCount: "+frameCount);
              if (R3EnemyY3Flame[i] != 5) {
                R3EnemyY3Flame[i]++;
              }
              // println("curFlame: "+curFlame);
              // curFlame = curFlame % numFlame;
            }
          }
          if (R3EnemyY3[i+1] != 1000) {
            R3EnemyY3[i+1]=enemyY-2*40; 
            if (fighterX < R3EnemyX[i]+enemyW &&
              R3EnemyX[i] < fighterX+fighterW &&
              fighterY < R3EnemyY3[i+1]+enemyH &&
              R3EnemyY3[i+1] < fighterY + fighterH) {
              println("5");

              // image(flame[curFlame], R3EnemyX[i], R3EnemyY3[i+1]);
              // if (frameCount % (60/10)==0) {

              //   curFlame = (curFlame ++)% numFlame; 
              //   if (curFlame>4) {
              //     curFlame=0;
              //   }

              blood-=40;
              R3EnemyY3[i+1]=1000;
              // }
            }
            for (int j = 0; j<5; j++)
            {
              if (bulletX[j] > R3EnemyX[i]-35 &&
                bulletX[j] < R3EnemyX[i]+35 &&
                bulletY[j] > R3EnemyY3[i+1]-35 &&
                bulletY[j] < R3EnemyY3[i+1]+35) 
              {
                bulletY[j] = -100;
                R3EnemyY3[i+1]=1000;
                text("score:"+score, 50, 450);
                score+=20;
              }
            }
          } else {
            // println("curFlame: "+curFlame);
            if (R3EnemyY3Flame[i] != 5) {
              image(flame[R3EnemyY3Flame[i]], R3EnemyX[i], enemyY-2*40);
            }
            if (frameCount % 10 ==0) {
              // println("frameCount: "+frameCount);
              if (R3EnemyY3Flame[i] != 5) {
                R3EnemyY3Flame[i]++;
              }
              // println("curFlame: "+curFlame);
              // curFlame = curFlame % numFlame;
            }
          }
        }



        if (enemyX>=900) {
          enemyRun=ENEMY_RUN1;
          enemyX=0;
          enemyY=floor(random(240, 360));
          for (int j=0; j<5; j++) {
            R1EnemyX[j]=0;
            R1EnemyY[j]=floor(random(420));
            R1EnemyYFlame[j] = 0;
          }
        }
      }

      break;
    }

    enemyX%=900;
    enemyX+=2;

    //fighter
    image(fighter, fighterX, fighterY);

    //treasure
    image(treasure, treasureX, treasureY);


    //blood
    rect(15, 10, 40+blood, 30);
    fill(255, 0, 0);

    //blood length boundary
    if (blood>=160) {
      blood=160;
    }


    if (fighterX < treasureX+treasureW &&
      treasureX < fighterX+fighterW &&
      fighterY < treasureY+treasureH &&
      treasureY < fighterY + fighterH) {
      blood+=20;
      treasureX=floor(random(600));
      treasureY=floor(random(450));
    }


    //game over condition
    if (40+blood<=0) {
      gameState = GAME_OVER;
    }

    //treasure reappear condition

    if (fighterX < treasureX+treasureW &&
      treasureX < fighterX+fighterW &&
      fighterY < treasureY+treasureH &&
      treasureY < fighterY + fighterH) {

      treasureX=floor(random(640));
      treasureY=floor(random(480));
    }


    //hp bar
    image(hp_bar, 10, 10);

    break;  

    /*
case GAME_WIN:
     break; 
     */

  case GAME_OVER:
    image(end_dark, 0, 0);
    // mouse action
    if (mouseX >210 && mouseX < 420 && mouseY > 300 && mouseY < 350) {
      if (mousePressed) {
        // click

        for (int i=0; i<5; i++) {
          R1EnemyX[i]=0;
          R1EnemyY[i]=floor(random(420));
          R1EnemyYFlame[i] = 0;
        }

        for (int i=0; i<5; i++) {
          R2EnemyX[i]=0;
          R2EnemyY[i]=floor(random(420));
          R2EnemyYFlame[i] = 0;
        }

        for (int i=0; i<5; i++) {
          R3EnemyX[i]=0;
          R3EnemyY1[i]=floor(random(420));
          R3EnemyY1Flame[i] = 0;
          R3EnemyY2Flame[i] = 0;
          R3EnemyY3Flame[i] = 0;
        }

        gameState = GAME_READY;
        enemyRun=ENEMY_RUN1;
        enemyX=0;
        blood=0;
      } else {
        // hover
        image(end_light, 0, 0);
      }
    }
    break;
  }
}



void keyPressed() {
  if (key == CODED) {  
    switch (keyCode) {
    case UP:
      upPressed = true;
      break;
    case DOWN:
      downPressed = true;
      break;
    case LEFT:
      leftPressed = true;
      break;
    case RIGHT:
      rightPressed = true;
      break;
    }
  }

  if (key ==' ') {
    bulletOpen = true;
    bulletShow[bulletCounter] = true;
  }
}

void keyReleased() {

  if (key == CODED) {
    switch (keyCode) {
    case UP:
      upPressed = false;
      break;
    case DOWN:
      downPressed = false;
      break;
    case LEFT:
      leftPressed = false;
      break;
    case RIGHT:
      rightPressed = false;
      break;
    }
  }
}

void bulletFunction() {
  if (bulletOpen == true) {
    bulletX[bulletCounter] = fighterX;
    bulletY[bulletCounter] = fighterY;
    bulletOpen = false;
    bulletCounter++;

    if (bulletCounter == 5) {
      bulletCounter = 0;
    }
  }

  for (int i =0; i<5; i++) {
    if (bulletShow[i] ==true) {
      image(bullet, bulletX[i], bulletY[i]);
      bulletX[i]-=3;
    }

    println(bulletX[0], bulletY[0]);
  }
  /*
  for(int j = 0;j<5;j++){
   for(int i = 0; i<5;i++){
   if (bulletX[j] > R1EnemyX[i]-35 &&
   bulletX[j] < R1EnemyX[i]+35 &&
   bulletY[j] > R1EnemyY[i]-35 &&
   bulletY[j] < R1EnemyY[i]+35) 
   {
   bulletY[j] = -100;
   R1EnemyY[i]=1000;
   }
   }
   }
   */
}
