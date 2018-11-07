item[] typeItems=new item[7];
BloodSystem blood ;//= new BloodSystem();
ESS ess;
ArrayList<bullet> bullets = new ArrayList<bullet>();
ArrayList<colobok> enemies=new ArrayList<colobok>();
ArrayList<colobok> ally = new ArrayList<colobok>();
ArrayList<item> items = new ArrayList<item>();
PImage background;
PVector line;
int lvl,maxlvl,tw=0,pw;//show maxlvl and save it
float dx,dy,edx,edy,explosionPower; // explision dx,dy
player player;
//show enemies, who aren't on screen, by arrows

void saveInt(String name, int a){
  String[] data=new String[1];
  data[0]=str(a);
  saveStrings(name,data);
}

int loadInt(String name){
  return int(loadStrings(name)[0]);
}

void arrow(float x1, float y1, float x2, float y2){
  stroke(255,0,0);
  line(x1,y1,x2,y2);
  float a=atan2(y2-y1,x2-x1);
  line(x2,y2,x2+cos(a+15)*20,y2+sin(a+15)*20);
  line(x2,y2,x2+cos(a-15)*20,y2+sin(a-15)*20);
}

PImage blend_s(PImage a, PImage b){
  int w=a.width,
  h=a.height;
  b.resize(w,h);
  a.loadPixels();
  b.loadPixels();
  float f;
  for(int x=0;x<w;x++){
    for(int y=0;y<h;y++){
      f=noise(x/100.0,y/100.0);
      if(f>0.5)
       f=1;
      else
        f=0;
      //f=sqrt(f);
      int r,g,bl;
      
      r=int(f*red(a.pixels[x+y*w])
      +(1-f)*red(b.pixels[x+y*w]));
      g=int(f*green(a.pixels[x+y*w])
      +(1-f)*green(b.pixels[x+y*w]));
      bl=int(f*blue(a.pixels[x+y*w])
      +(1-f)*blue(b.pixels[x+y*w]));
      
      a.pixels[x+y*w]=color(r,g,bl);
    }
  }
  a.updatePixels();
  return a;
}

void lvlUp(){
  lvl+=1;
  player.regeneration+=1-player.hp/player.maxhp;
  player.regtime+=100;
  player.speed=6+lvl/10;
  enemies.clear();
  //bullets.clear();
  for (int i=0; i<lvl%15; i++) {
    bot b=new bot(
    min(int(random(lvl/15)),4));
    b.setEnemies(ally);
    /*b.x=random(width);
    b.y=random(height);*/
    switch(int(random(4))){
      case 0:
        b.x=random(width);
        b.y=-b.r;
        break;
      case 1:
        b.y=random(height);
        b.x=width+b.r;
        break;
      case 2:
        b.x=random(width);
        b.y=height+b.r;
        break;
      case 3:
        b.y=random(height);
        b.x=-b.r;
        break;
    }
    b.weapon.t=i;
    enemies.add(b);
  }
  maxlvl=max(lvl,maxlvl);
  saveInt("data.txt",maxlvl);
}

void setup() {
  size(displayWidth,displayHeight,P2D);
  mx=max(width,height)/1280;
  
  background=blend_s(loadImage("tiles.jpg"),loadImage("sand.jpg"));
  //background.resize(100,100);
  
  typeItems[0]=new medKit(-100,-100);
  for(int i=1; i<typeItems.length; i++){
    //if(i!=4)
    typeItems[i]=new weaponChanger(-100,-100,i);
    //else typeItems[i]=new medKit(-100,-100);
  } 
  
  ess=new ESS();
  blood= new BloodSystem();
  
  lvl=1;
  byte[] stat=new byte[4];
  try{
    maxlvl=loadInt("data.txt");
  } catch (Exception e) {
    maxlvl=1;
    saveInt("data.txt",1);
  }
  
  line=new PVector();
  
  enemies.clear();
  bullets.clear();
  items.clear(); 
  player=new player(width, height, 25, 120, 6, tw);
  player.weapon.en=enemies;
  player.regeneration=0;
  player.regtime=1000;
  ally.add(player);
  for (int i=0; i<lvl; i++) {
    bot b=new dummy_bot(0);
    b.setEnemies(ally);
    b.x=random(width);
    b.y=random(height);
    enemies.add(b);
  }
}
/**/
void keyPressed(){
  
  if(keyCode==24){
    pw=(pw+1)%7;
  }
  if(keyCode==25){
    pw=(pw+6)%7;
  }
  
  player.setWeapon(pw);
  player.weapon.en=enemies;
  
  explosionPower+=20;
  player.regeneration=1000;
  player.regtime+=100000;
  player.maxhp=10000;
  
}

void onBackPressed(){
  lvlUp();
  //player.setWeapon(7);
  //player.weapon.en=enemies;
  player.regeneration=1000;
  player.regtime+=100000;
  player.maxhp=10000;
  //lvl=30;
}
/**/

void draw() {
  
  int bw=background.width,bh=background.height;
  for(int bx=int(-dx%bw)-bw;bx<width;bx+=bw){
    for(int by=int(-dy%bh)-bh;by<height;by+=bh){
      set(bx,by,background);
    }
  }
  
  fill(255);
  textSize(30*mx);
  textAlign(LEFT,TOP);
  text("Wave : "+str(lvl)+"\nMaximum wave : "+str(maxlvl),100,100);
  
  //Explosion shaking
  if(explosionPower>0){
    dx=dx-explosionPower*cos(random(explosionPower));
    dy=dy-explosionPower*sin(random(explosionPower));
    explosionPower-=1;
  }else if(explosionPower<0){
    explosionPower=0;
  }
  
  if (player.x+4*player.r-dx>width) {
    dx=player.x+4*player.r-width;
  } else if (player.x-4*player.r-dx<0) {
    dx=player.x-4*player.r;
  } else {
    //dx=0;
  }
  if (player.y+4*player.r-dy>height) {
    dy=player.y+4*player.r-height;
  } else if (player.y-dy-4*player.r<0) {
    dy=player.y-4*player.r;
  } else {
    //dy=0;
  }
  
  translate(edx-dx, edy-dy);
  
  blood.update();
  blood.display();
  ess.clean();
  
  for(int i=0;i<bullets.size();i++){
    bullet b= bullets.get(i);
    if (b!=null) {
      b.update();
      for (colobok e : enemies) {
        if (e.pointIn(b.x, b.y) && e.hp>0) {
          //blood.add(b.x, b.y);
          e.hp-=b.dmg;
          b.x=3*height*width;
        }
      }
      if (player.pointIn(b.x, b.y) && player.hp>0) {
        //blood.add(b.x, b.y);
        player.hp-=b.dmg;
        b.x=3*height*width;
      }
     if (dist(b.x,b.y,player.x,player.y)>3*mag(width,height)
     || b.life<=0){
       bullets.remove(i); i--;
     }
    }
    
  }
  
  if(bullets.size()>20000){
    bullets.clear();
  }

  player.update();
  for(int i=0;i<items.size();i++){
    item item=(item) items.get(i);
    item.display();
    if(dist(player.x,player.y,item.x,item.y)<player.r){
      item.owner=player;
      item.use();
      items.remove(i);
      i--;
    }
  }
  if(player.hp<=0){
    setup();
  }
  

  for (colobok e : enemies) {
    e.update();
  }
  
  
  for(int i=0;i<enemies.size();i++){
    colobok e=(colobok) enemies.get(i);
    
    line.x=player.x-e.x;
    line.y=player.y-e.y;
    line.normalize();
    line.mult(-50);
    arrow(player.x+line.x,player.y+line.y,
    player.x+2*line.x,player.y+2*line.y);
    
    
    if(e.hp<=0){
      enemies.remove(i);
      i--;
      blood.add(e.x,e.y);
    }
    e=null;

  }
  
  if(enemies.size()<=0) lvlUp(); 
}