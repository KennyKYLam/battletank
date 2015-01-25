int score = 0; 
int health = 50;

int enemy_balls_x, enemy_balls_y; 

int ball_x, ball_y, ball_radius; 
int ball_x_velocity, ball_y_velocity;

int enemy_tank_width, enemy_tank_height;
int enemy_tank_x, enemy_tank_y;
int enemy_tanks_x[], enemy_tanks_y[];
int num_enemy_tanks = 3;
int enemy_tank_x_velocity, enemy_tank_y_velocity;

int paddle_x, paddle_y, paddle_width, paddle_height; 
int paddle_x_velocity, paddle_y_velocity;
int canon_width, canon_height;

boolean[] isDestroyed; 
boolean isGameover = false;
boolean pause = false;
int screen_width=700;
int screen_height=500;

char userclick;

  //temp values for pause
  int a,b,c,d,e,f;

PFont myFont;

void setup() {
  
  enemy_tanks_x = new int[3];
  enemy_tanks_y = new int[3];
  
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
  
  enemy_tank_width = 40;
  enemy_tank_height = 40;
  enemy_tank_x = int(random(screen_width))%(screen_width-100)+50;
  enemy_tank_y = int(random(300))+50;
  enemy_tank_x_velocity = 2;
  enemy_tank_y_velocity = 2;
  
  for(int i = 0; i< num_enemy_tanks; i++){
  enemy_tanks_x[i] = 20 + int(random(20)) + 60 *i;
  enemy_tanks_y[i] = 80 + 100 *i;
  }
  
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
  
  // health bar
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
  
  //draw leader enemy tank
  fill(93,86,86);
  stroke(93,86,86);
  rect(enemy_tank_x, enemy_tank_y, enemy_tank_width, enemy_tank_height);
  fill(0);
  stroke(0);
  rect(enemy_tank_x + 15, enemy_tank_y + 20, canon_width, canon_height);
  
  //move leader tank diagonally while checking for screen boundary
  if(enemy_tank_x + enemy_tank_x_velocity < 0 || enemy_tank_x + enemy_tank_x_velocity + enemy_tank_width > screen_width) {
  enemy_tank_x_velocity = -1 * enemy_tank_x_velocity; //reverse the polarity
  }
  if(enemy_tank_y + enemy_tank_y_velocity < 0 || enemy_tank_y + enemy_tank_y_velocity + enemy_tank_height > screen_height) {
  enemy_tank_y_velocity = -1 * enemy_tank_y_velocity; //reverse the polarity
  }
  enemy_tank_x += enemy_tank_x_velocity;
  enemy_tank_y += enemy_tank_y_velocity;
  
    //3 enemy_tank tanks
    for(int i = 0; i< num_enemy_tanks; i++){
    fill(255);
    stroke(255);
    rect(enemy_tanks_x[i], enemy_tanks_y[i], enemy_tank_width, enemy_tank_height);
    fill(0);
    stroke(0);
    rect(enemy_tanks_x[i] + 15, enemy_tanks_y[i] + 20, canon_width, canon_height);
    if(enemy_tanks_x[i] + 5 < 0 || enemy_tanks_x[i] + enemy_tank_x_velocity + enemy_tank_width > screen_width) {
    enemy_tank_x_velocity = -1 * enemy_tank_x_velocity; //reverse the polarity
    }
    enemy_tanks_x[i] += enemy_tank_x_velocity;
    }

  //draw user tank

  fill(255,8,37);
  stroke(255,8,37);
  ellipse(paddle_x, paddle_y, paddle_width, paddle_height);
  fill(0);
  stroke(0);
  rect(paddle_x + 15, paddle_y - 10, canon_width, canon_height);
  //=====

  //=====
  //check and see if the ball hits any of the enemy_tanks, we do that by calling a function
  //also increase the score by 1
  boolean hasAHit = checkIfHitAenemy_tank(ball_x, ball_y);
  if(hasAHit == true) { //the ball bounces off vertically if it hits a enemy_tank
    ball_y_velocity = -1 * ball_y_velocity;
    ball_x_velocity = -1 * ball_x_velocity;
    score += 5;
  }
  boolean hasHits = checkIfHitenemy_tanks(ball_x, ball_y);
  if(hasHits == true) { //the ball bounces off vertically if it hits a enemy_tank
    ball_y_velocity *= -1;
    ball_x_velocity *= -1;
    score += 1;
  }
  //===== collision with enemy leader tank
  boolean collision = checkIfpaddleHitenemy_leader_tank(paddle_x, paddle_y,enemy_tank_x,enemy_tank_y);
  if(collision == true) { //the ball bounces off vertically if it hits a enemy_tank
      if(health > 0){
        health -= 5;
      }else{
        isGameover = true;
      }
  }
  
  //===== collision with other enemy tanks
  boolean tankcollision = checkIfpaddleHitenemy_tank( paddle_x, paddle_y);
  if(tankcollision == true) { //the ball bounces off vertically if it hits a enemy_tank
      if(health > 0){
        health -= 2;
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
        health -= 5;
      }else{
        isGameover = true;
      }
  }


  //handle user input.
  checkuserinput();

  
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
          for(int i = 0; i< num_enemy_tanks; i++){
              enemy_tanks_x[i] = 100 + int(random(60) + 60) * i;
              enemy_tanks_y[i] = 80 + 100 * i;
          }
          enemy_tank_x = int(random(screen_width))%(screen_width-50)+50;
          enemy_tank_y = int(random(300))+50;
          score= 0;
          health= 50;
          paddle_x = 200;
          paddle_y = 350;
          isGameover= false;
        }
        }
  }

}

//Here we define a function helping us to check if the ball hits any of the enemy_tanks, by letting it know where the ball is.
//If so, we leave a mark to the corresponding cell in the isDestroyed array to signify that.
//To check, we simply see if the centre of the ball are within the boundary of each enemy_tank we draw.
//This function also does something extra: it returns a flag indicating a enemy_tank is destroyed in the process.

boolean checkIfpaddleHitenemy_leader_tank( int paddle_x_pos, int paddle_y_pos, int enemy_tank_x_pos, int enemy_tank_y_pos){
  int paddle_centre_x = paddle_x_pos + paddle_width/2;
  int paddle_centre_y = paddle_y_pos + paddle_height/2;
  if(paddle_centre_x>enemy_tank_x && paddle_centre_x<enemy_tank_x+enemy_tank_width 
    && paddle_centre_y>enemy_tank_y && paddle_centre_y<enemy_tank_y+enemy_tank_height) {
      return true;
}
  return false;
}

boolean checkIfpaddleHitenemy_tank( int paddle_x_pos, int paddle_y_pos){
  int paddle_centre_x = paddle_x_pos + paddle_width/2;
  int paddle_centre_y = paddle_y_pos + paddle_height/2;
  for(int i=0; i< num_enemy_tanks; i++){
  if(paddle_centre_x>enemy_tanks_x[i] && paddle_centre_x<enemy_tanks_x[i]+enemy_tank_width 
    && paddle_centre_y>enemy_tanks_y[i] && paddle_centre_y<enemy_tanks_y[i]+enemy_tank_height) {
      return true;
    }
  }
  return false;
}

boolean checkIfHitenemy_tanks(int bx, int by){
  for(int i=0; i< num_enemy_tanks; i++){
  int ball_centre_x = bx+ball_radius, ball_centre_y = by+ball_radius;
  if(ball_centre_x>enemy_tanks_x[i] && ball_centre_x<enemy_tanks_x[i]+enemy_tank_width 
    && ball_centre_y>enemy_tanks_y[i] && ball_centre_y<enemy_tanks_y[i]+enemy_tank_height) {
          return true; //return a flag indicating a hit has occured
          }
  }
  return false;
}

boolean checkIfHitAenemy_tank(int bx, int by) {

  int ball_centre_x = bx+ball_radius, ball_centre_y = by+ball_radius;
  if(ball_centre_x>enemy_tank_x && ball_centre_x<enemy_tank_x+enemy_tank_width 
    && ball_centre_y>enemy_tank_y && ball_centre_y<enemy_tank_y+enemy_tank_height) {
          return true; //return a flag indicating a hit has occured
          }
  return false;
}

void shootball( int postion_x, int position_y){
  stroke(250,125,0);
  fill(255,234,0);
  ellipse(paddle_x + 15, paddle_y - 15, 10, 10);
  
}

void stop(){
        a =enemy_tank_y_velocity;
        b =enemy_tank_x_velocity;
        c =ball_x_velocity;
        d =ball_y_velocity;
        e =paddle_x_velocity;
        f =paddle_y_velocity;
        enemy_tank_y_velocity= 0;
        enemy_tank_x_velocity= 0;
        ball_x_velocity= 0;
        ball_y_velocity= 0;
        paddle_x_velocity= 0;
        paddle_y_velocity= 0;
}

void start(){
        enemy_tank_y_velocity= a;
        enemy_tank_x_velocity= b;
        ball_x_velocity= c;
        ball_y_velocity= d;
        paddle_x_velocity= e;
        paddle_y_velocity= f;
}

void updateKeybutton(){
        userclick = keybutton.charAt(0);
        println(keybutton);
        println("in updatekeybutton()"+ userclick);
}

/*
void touchscreenmove(){

     if( userclick == 'w') {
            println("its in"+ userclick);
          if(paddle_y > 20){
              paddle_y -= paddle_y_velocity;
          }
    }
}
*/
void checkuserinput(){
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
      if(paddle_y > 20){
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
      //println('l');
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
    else{
    if( userclick == 'a') {
      if(paddle_x > 10){
      paddle_x -= paddle_x_velocity;
      }
    }
    }
}
