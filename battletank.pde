int score = 0; 
int health = 50;

int ball_x, ball_y, ball_radius; 
int ball_x_velocity, ball_y_velocity;
int brick_x, brick_y;
int brick_x_velocity, brick_y_velocity;
int paddle_x, paddle_y, paddle_width, paddle_height; 
int paddle_x_velocity, paddle_y_velocity;
int canon_width, canon_height;
int brick_width, brick_height, brick_interval;
boolean[] isDestroyed; 
boolean isGameover = false;
boolean pause = false;
int screen_width=500;
int screen_height=500;

  //temp values for pause
  int a,b,c,d,e,f;

PFont myFont;

void setup() {

  size(screen_width, screen_height, P2D);
  
  ellipseMode(CORNER); 
  ball_radius = 5;
  ball_x_velocity = 5;
  ball_y_velocity = 5;
  
  paddle_x = 200;
  paddle_y = 350;
  paddle_width = 40;
  paddle_height = 40;
  canon_width = 10;
  canon_height = 30;
  paddle_x_velocity = 10;
  paddle_y_velocity = 10;
  
  brick_width = 50;
  brick_height = 50;
  brick_interval = 20;
  brick_x = 10;
  brick_y = 100;
  brick_x_velocity = 2;
  brick_y_velocity = 2;
  
  myFont = loadFont("CenturyGothic-48.vlw");

}

void draw() {
  
  background(125, 125, 125);
  
  fill(0);
  textFont(myFont,40);
  text("BattleTank",10,50);
  
  if(!isGameover)
  {
  //display the score
  textFont(myFont, 20);
  text("Score: "+score, 220, 50);
  
  textFont(myFont, 20);
  text("Health: ", 360, 50);
  stroke(139,195,74);
  fill(139,195,74);
  if(health<25)
  {
    fill(244,67,54);
    stroke(244,67,54);
  }
  rect(440, 35, health, 15);
  //=====
  //draw the bricks, using a for-loop to save us some work, behaves like an old typewriter
  fill(0);
  stroke(0);
  rect(brick_x, brick_y, brick_width, brick_height);
  /*
  for(int i=0; i<2; i++) { //draw 2 bricks
      //draw a rectangle to the screen, 
      //using a system function by providing x,y-coordinates, and the width and height
      //if(isDestroyed[i] == false) {//draw only if it's not destroyed yet
        fill(0);
        stroke(0);
        rect(drawXPosition, drawYPosition, brick_width, brick_height);
        
      
      //update the x-coordinate so the next brick can be drawn to the right of this one
      drawXPosition = drawXPosition + brick_width + brick_interval;
    }
    */
    
    //move brick horizontally back and forth
    
    if(brick_x + brick_x_velocity < 0 || brick_x + brick_x_velocity + brick_width > screen_width) {
    brick_x_velocity = -1 * brick_x_velocity; //reverse the polarity
    }
    if(brick_y + brick_y_velocity < 0 || brick_y + brick_y_velocity + brick_height > screen_height) {
    brick_y_velocity = -1 * brick_y_velocity; //reverse the polarity
    }
  brick_x += brick_x_velocity;
  brick_y += brick_y_velocity;
  
  rect(brick_x, brick_y, brick_width, brick_height);
  //=====
  
  //=====
  //draw the tank
  //println(paddle_x);
  fill(255,8,37);
  stroke(255,8,37);
  ellipse(paddle_x, paddle_y, paddle_width, paddle_height);
  fill(0);
  stroke(0);
  rect(paddle_x + 15, paddle_y - 10, canon_width, canon_height);
  //=====

  //=====
  //check and see if the ball hits any of the bricks, we do that by calling a function
  //also increase the score by 1
  boolean hasAHit = checkIfHitABrick(ball_x, ball_y);
  if(hasAHit == true) { //the ball bounces off vertically if it hits a brick
    ball_y_velocity = -1 * ball_y_velocity;
    ball_x_velocity = -1 * ball_x_velocity;
    score += 1;
  }
  //=====
  boolean collision = checkIfpaddleHitBrick(paddle_x, paddle_y,brick_x,brick_y);
  if(collision == true) { //the ball bounces off vertically if it hits a brick
      if(health > 0){
        health -= 5;
      }else{
        isGameover = true;
      }
  }
  //=====
  //check and see if the ball hits the paddle, if so bounce it back up by reversing the vertical velocity,
  //then check and see if the ball goes below the padde, if so it's game over
  int ball_centre_x = ball_x+ball_radius, ball_centre_y = ball_y+ball_radius;
  if(ball_centre_x>paddle_x && ball_centre_x<paddle_x+paddle_width 
    && ball_centre_y>paddle_y && ball_centre_y<paddle_y+paddle_height) {
      ball_y_velocity = -1 * ball_y_velocity;
      stroke(191,54,12);
      fill(191,54,12);
      ellipse(paddle_x, paddle_y - 5, 40, 40);
      if(health > 0){
        health -= 2;
      }else{
        isGameover = true;
      }
  }
  //=====

  //=====
  //handle user input.
  if(keyPressed) {

    if(key == 'a') {
      if(paddle_x > 10){
      paddle_x -= paddle_x_velocity;
      }
    }
    if(key == 'd') {
      if(paddle_x < (screen_width - (paddle_width +10))){
      paddle_x += paddle_x_velocity;
      }
    }
    if(key == 'w') {
      if(paddle_y > 10){
      paddle_y -= paddle_y_velocity;
      }
    }
    if(key == 's') {
      if(paddle_y < (screen_height - (paddle_height +10))){
      paddle_y += paddle_y_velocity;
      }
    }
    if(key == 'l') {
      //shoot ball
      shootball(paddle_x,paddle_y);
      ball_y = paddle_y - 10;
      ball_x = paddle_x + 15;  
    }
    if(key == 'p') {

      if(!pause){
        stop();
        pause= true;
      }else if(pause){
        start();
        pause= false;
      }        
      }//key p
    }//keys pressed
  
  ball_y -= ball_y_velocity;
  ellipse(ball_x, ball_y, ball_radius*2, ball_radius*2);
  
    if(pause){
        fill(0);
        stroke(0);
        textFont(myFont,60);
        text("Paused",100,200);
    }
  }
  // when game is over
  else{
        fill(0);
        textFont(myFont,60);
        text("Game Over",50,200);
        textFont(myFont,40);
        text("High Score: "+ score,50,300);
        textFont(myFont,30);
        text("Click [r] to Restart",50,400);
        if(keyPressed) {
        //the keyboard button being pressed will then be available through the system variable "key"
        if(key == 'r') {
          score= 0;
          health= 50;
          brick_x = 10;
          brick_y = 100;
          paddle_x = 200;
          paddle_y = 350;
          isGameover= false;
        }
        }
  }

}

//Here we define a function helping us to check if the ball hits any of the bricks, by letting it know where the ball is.
//If so, we leave a mark to the corresponding cell in the isDestroyed array to signify that.
//To check, we simply see if the centre of the ball are within the boundary of each brick we draw.
//This function also does something extra: it returns a flag indicating a brick is destroyed in the process.

boolean checkIfpaddleHitBrick( int paddle_x_pos, int paddle_y_pos, int brick_x_pos, int brick_y_pos){
  int paddle_centre_x = paddle_x_pos + paddle_width/2;
  int paddle_centre_y = paddle_y_pos + paddle_height/2;
  if(paddle_centre_x>brick_x && paddle_centre_x<brick_x+brick_width 
    && paddle_centre_y>brick_y && paddle_centre_y<brick_y+brick_height) {
      return true;
}
  return false;
}

boolean checkIfHitABrick(int bx, int by) {

  int ball_centre_x = bx+ball_radius, ball_centre_y = by+ball_radius;
  if(ball_centre_x>brick_x && ball_centre_x<brick_x+brick_width 
    && ball_centre_y>brick_y && ball_centre_y<brick_y+brick_height) {
          return true; //return a flag indicating a hit has occured
          }
  /*
  //int drawXPosition = brick_interval, drawYPosition = brick_interval*4;
  for(int i=0; i<3; i++) { //draw 3 bricks
      //check if the x,y-coordinates of the ball's center fall within the boundary of the rectangle.
      if(ball_centre_x>drawXPosition && ball_centre_x<drawXPosition+brick_width
          && ball_centre_y>drawYPosition && ball_centre_y<drawYPosition+brick_height) {
            //if we reach here, it means the ball has hit this brick.
            //However, we still need to check if it has already been destroyed earlier.
            if(isDestroyed[i] == false) {
              isDestroyed[i] = true; //leave a mark indicating this brick is hit
              score ++;
              return true; //return a flag indicating a hit has occured
            }
      }
 
  }*/
  
  return false; //if we reach this point, it means nothing is hit, so just return "false".
}

void shootball( int postion_x, int position_y){
  stroke(250,125,0);
  fill(255,234,0);
  ellipse(paddle_x + 15, paddle_y - 15, 10, 10);
}

void stop(){
        a =brick_y_velocity;
        b =brick_x_velocity;
        c =ball_x_velocity;
        d =ball_y_velocity;
        e =paddle_x_velocity;
        f =paddle_y_velocity;
        brick_y_velocity= 0;
        brick_x_velocity= 0;
        ball_x_velocity= 0;
        ball_y_velocity= 0;
        paddle_x_velocity= 0;
        paddle_y_velocity= 0;
}

void start(){
        brick_y_velocity= a;
        brick_x_velocity= b;
        ball_x_velocity= c;
        ball_y_velocity= d;
        paddle_x_velocity= e;
        paddle_y_velocity= f;
}



