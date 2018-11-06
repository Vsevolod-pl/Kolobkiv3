
boolean clearThings=true;
int rec=0;
float mx=1;

class colobok {
  float x, y, r, hp, speed, regeneration=0, 
    regtime, maxhp;
  PVector velocity=new PVector();
  weapon weapon;
  AudioPlayerMy audio;

  colobok(int weapType) {
    this(0, 0, 30, 51, 2, weapType);
  }

  colobok(float ix, float iy, float ir, float ihp, float iv, int weapType) {
    x=ix;
    y=iy;
    r=ir*mx;
    hp=ihp;
    maxhp=ihp;
    speed=iv;
    audio = new AudioPlayerMy();
    setWeapon(weapType);
    //velocity
  }

  void setAudioFile(String name) {
    /*audio.reset();
     if(!audio.loadFile(name)){*/
    audio.release();
    audio = new AudioPlayerMy();
    audio.loadFile(name);
    //setAudioFile(name);
    //}
  }

  boolean audioIsPlaying() {
    try {
      //return audio.getCurrentPosition()>=audio.getDuration();
      // ||
      return audio.isPlaying();
    }
    catch (Exception e) {
      e.printStackTrace();
      return true;
    }
  }

  void audioStart() {
    //if(dist(x,y,player.x,player.y)<10);
    audio.seekTo(0);
    audio.start();
  }

  void setWeapon(int type) {
    switch(type) {
    case 0:
      weapon=new weapon(this, 20, 20, 1000*mx);
      break;
    case 1:
      weapon=new weapon(this, 2, 4, 1000*mx, "machine_gun.mp3");
      break;
    case 2:
      weapon=new fWeapon(this, 90, 15, 1000*mx);//sWeapon(this, 10, 10);
      break;
    case 3:
      weapon=new shotgun(this, 90, 10, 1000*mx);
      break;
    case 4:
      weapon=new rLauncher(this, 50, 100);
      break;
    case 5:
      weapon=new tMaker(this, 60, 10, 1000*mx);
      break;
    case 6:
      weapon=new laser(this, 0, 1, 1000*mx);
      break;
    case 7:
      weapon=new rLauncher(this, 0, 100);
    }
  }

  boolean pointIn(float px, float py) {
    if (dist(px, py, x, y)<r) return true;
    else return false;
  }

  void move() {
    x+=velocity.x;
    y+=velocity.y;
  }

  void moveTo(float px, float py) {
    velocity.x=px-x;
    velocity.y=py-y;
    velocity.limit(speed);
  }
  void display() {
    noStroke();
    fill(175);
    ellipse(x, y, 2*r, 2*r);
    fill(256*(1-hp/maxhp), 256*hp/maxhp, 0);
    rect(x-r, y-r-10, 2*r*hp/maxhp, 10*mx);
  }

  void update() {
    if (regtime>0 && hp<maxhp) {
      hp+=regeneration;
      regtime-=1;
    }
    move();
    //if (hp<maxhp) blood.add(int(x), int(y));
    display();
    weapon.update();
    if (hp<=0) {
      onDeath();
    }
  }

  void onDeath() {
    if (items.size()<10 || clearThings)
      items.add(typeItems[int(random(typeItems.length))].get(int(x), int(y)));
    if (items.size()>10 && clearThings)
      items.remove(0);
    audio.release();
  }
}

class player extends colobok {
  player(float ix, float iy, float r, float ihp, float iv, int wt) {
    super(ix, iy, r, ihp, iv, wt);
  }
  void update() {
    moveTo(mouseX+dx, mouseY+dy);
    super.update();
  }
  
  void audioStart(){
    //TODO make it more quiet
  }
  
  /*void setAudioFile(String name) {
   
   }
  /*boolean audioIsPlaying() {
   }
   void audioStart() {
   
   }*/
}

class bot extends colobok {
  ArrayList<colobok> en;
  bot(int wtype) {
    super(wtype);
  }

  bot(float ix, float iy, float r, float ihp, float iv, int wt) {
    super(ix, iy, r, ihp, iv, wt);
    //weapon.
  }

  void setEnemies(ArrayList<colobok> e) {
    en=e;
    weapon.en=en;
  }

  void foundNearEnemy() {
    colobok ne=null;

    for (colobok e : en) {
      if (ne!=null) {
        if (e.hp>0 && e!=this) {
          if (ne.hp<=0) {
            ne=e;
          } else if (dist(x, y, e.x, e.y)<dist(x, y, ne.x, ne.y)) {
            ne=e;
          }
        }
      } else if (e!=this) {
        ne=e;
      }
    }

    if (ne!=null) moveTo(ne.x, ne.y);
  }

  void update() {
    foundNearEnemy();
    super.update();
  }
}

class dummy_bot extends bot{
  dummy_bot(int wtype) {
    super(wtype);
  }

  dummy_bot(float ix, float iy, float r, float ihp, float iv, int wt) {
    super(ix, iy, r, ihp, iv, wt);
    //weapon.
  }
  
  void update(){
    hp=maxhp;
    weapon.t=weapon.cd;
    super.update();
    //display();
  }
}



/*class rocket extends item{
 rocket(int ix, int iy, String name){
 super(ix,iy,name);
 }
 }*/


class joystick {
  int x, y;
  float a, r;

  joystick(int ix, int iy, float ir) {
    x=ix;
    y=iy;
    r=ir;
  }

  boolean upd() {
    if ((dist(mouseX, mouseY, x, y)<r)&&(mousePressed)) {
      a=HALF_PI-atan2(mouseX-x, mouseY-y);
      strokeWeight(5);
      stroke(255);
      line(x, y, mouseX, mouseY);
      ellipse(mouseX, mouseY, 10, 10);
      strokeWeight(1);
      return true;
    } else {
      return false;
    }
  }
}
class spot {
  PImage img;
  float x, y, life;
  spot(float ix, float iy, PImage nimg) {
    img=nimg;
    life=255;
    x=ix;
    y=iy;
  }

  void update() {
    life-=6;
    display();
  }

  void display() {
    imageMode(CENTER);
    tint(255, life);
    image(img, x, y, 80, 80);
    tint(255,255);
  }
}

/*class BloodSystem {
 PGraphics a;
 PImage[] spotImgs;
 float dx, dy;
 BloodSystem() {
 spotImgs=new PImage[2];
 for (int i=0; i<spotImgs.length; i++) {
 spotImgs[i]=loadImage((i+1)+".png");
 }
 a = createGraphics(width, height, JAVA2D);
 a.noStroke();
 a.fill(0, 10);
 }
 
 void add(float x, float y) {
 //dx=random(40)-20;
 //dy=random(40)-20;
 //println("added");
 a.beginDraw();
 a.image(spotImgs[int(random(spotImgs.length))], x+dx-40, y+dy-40, 80, 80);
 a.endDraw();
 //blood_spots.add(new spot(x+dx, y+dy, spotImgs[int(random(spotImgs.length))] ));
 }
 
 void display() {
 image(a, 0, 0);
/*for (spot s : blood_spots) {
 s.display();
 }/
 }
 
 void update() {
 a.beginDraw();
 a.noStroke();
 a.fill(0, 10);
 a.rect(0, 0, width, height);
 a.endDraw();
 display();
 }
 }*/

class BloodSystem {
  ArrayList<spot> blood_spots = new ArrayList<spot>();
  PImage[] spotImgs;
  int dx, dy;
  BloodSystem() {
    spotImgs=new PImage[2];
    for (int i=0; i<spotImgs.length; i++) {
      spotImgs[i]=loadImage((i+1)+".png");
    }
  }

  void add(float x, float y) {
    dx=int(random(40)-20);
    dy=int(random(40)-20);
    blood_spots.add(new spot(x+dx, y+dy, spotImgs[int(random(spotImgs.length))]));
  }

  void display() {
    for (spot s : blood_spots) {
      s.display();
    }
  }

  void update() {
    for (int i=0; i<blood_spots.size (); i++) {
      spot s=(spot) blood_spots.get(i);
      s.update();
      if (s.life<0) {
        blood_spots.remove(i--);
      }
    }
  }
}

//TODO Change name
//Explosion Sound System
class ESS{
  ArrayList<AudioPlayerMy> exs;
  ESS(){
    exs=new ArrayList<AudioPlayerMy>();
  }
  
  void add(){
    AudioPlayerMy a=new AudioPlayerMy();
    a.loadFile("explosion.mp3");
    a.start();
    exs.add(a);
  }
  
  void clean(){
    for(int i=0;i<exs.size();i++){
      AudioPlayerMy a = (AudioPlayerMy) exs.get(i);
      if(!a.isPlaying()){
        a.release();
        exs.remove(i--);
      }
      
    }
  }
}
