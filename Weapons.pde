class weapon {
  int dmg, blife=1000;
  float cd, t, speed=10, angle, shootDist;
  colobok owner, ne;
  ArrayList<colobok> en;
  weapon(colobok o, float icd, int idmg, float shd) {
    //audio.loadFile("shot.mp3");
    this(o, icd, idmg, shd, "shot.mp3");
  }

  weapon(colobok o, float icd, int idmg, float shd, String filename) {
    t=0;
    owner=o;
    cd=icd;
    dmg=idmg;
    shootDist=shd;
    owner.setAudioFile(filename);
    t=int(random(cd));
    /*if(icd<1){
     owner.audio.setLooping(true);
     println("loop");
     }*/
  }

  void foundNearEnemy() {
    if (en!=null)
      for (colobok e : en) {
        if (ne!=null) {
          if (e.hp>0 && e!=owner) {
            if (ne.hp<=0) {
              ne=e;
            } else if (dist(owner.x, owner.y, e.x, e.y)<dist(owner.x, owner.y, ne.x, ne.y)) {
              ne=e;
            }
          }
        } else if (e!=owner) {
          ne=e;
        }
      }
  }

  void playShotSound() {
    float volume=100*mx/dist(owner.x,owner.y,player.x,player.y);
    volume=min(1,volume);
    owner.audio.setVolume(volume,volume);
    if (!owner.audioIsPlaying()) {
      owner.audioStart();
    }
  }

  void shoot() {
    if (ne!=null) {
      angle=atan2(ne.y-owner.y, ne.x-owner.x);
      if ((t<=0 /*|| !owner.audioIsPlaying()*/) && dist(ne.x, ne.y, owner.x, owner.y)<=shootDist) {
        //if (atan2(ne.y-y, ne.x-x)>angle-dAngle && atan2(ne.y-y, ne.x-x)<angle+dAngle) {
        /*float shootX, shootY;
         shootX=ne.x+random(-ne.r, ne.r);
         shootY=ne.y+random(-ne.r, ne.r);*/
        playShotSound();
        bullets.add(new bullet(owner.x+(1+owner.r)*cos(angle), owner.y+(1+owner.r)*sin(angle), dmg, blife, new PVector(speed*cos(angle), speed*sin(angle))));
        t=cd;
        //line(x+size*cos(angle), y+size*sin(angle), shootX, shootY);
        //}
      } else {
        //audio.pause();
      }
    }
  }

  void display() {
    strokeWeight(10*mx);
    stroke(50);
    line(owner.x, owner.y, owner.x+owner.r*cos(angle), owner.y+owner.r*sin(angle));
  }

  void update() {
    t--;
    foundNearEnemy();
    shoot();
    display();
  }
}

class shotgun extends weapon {
  shotgun(colobok o, float icd, int idmg, float shd) {
    super(o, icd, idmg, shd, "shotgun.mp3");
  }

  void shoot() {
    if (ne!=null) {
      angle=atan2(ne.y-owner.y, ne.x-owner.x);
      if (t<=0 && dist(ne.x, ne.y, owner.x, owner.y)<=shootDist) {
        playShotSound();
        for (int i=0; i<10; i++) {
          float da=(random(1)-0.5)*QUARTER_PI*0.3;
          bullets.add(new bullet(owner.x+(1+owner.r)*cos(angle+da), 
            owner.y+(1+owner.r)*sin(angle+da), dmg, blife, 
            new PVector(speed*cos(angle+da), speed*sin(angle+da))));
        }
        t=cd;
      }
    }
  }
}

class sWeapon extends weapon {
  sWeapon(colobok o, float icd, int idmg) {
    super(o, icd, idmg, 0);
  }

  void shoot() {
    if (t<=0) {
      playShotSound();
      for (angle=0; angle<TWO_PI; angle+=PI/20) {
        bullets.add(new bullet(owner.x+(1+owner.r)*cos(angle), owner.y+(1+owner.r)*sin(angle), dmg, blife, new PVector(speed*cos(angle), speed*sin(angle))));
        display();
      }
      t=cd;
    }
  }
  void update() {
    t--;
    shoot();
  }
}

class fWeapon extends weapon {
  fWeapon(colobok o, float icd, int idmg, float shd) {
    super(o, icd, idmg, shd, "shotgun.mp3");
  }

  void shoot() {
    if (en!=null && t<=0) {
      playShotSound();
      for (colobok e : en) {
        if (e!=null) {
          if (e.hp>0 && e!=owner) {
            angle=atan2(e.y-owner.y, e.x-owner.x);
            if (dist(e.x, e.y, owner.x, owner.y)<=shootDist) {
              display();
              bullets.add(new bullet(owner.x+(1+owner.r)*cos(angle), owner.y+(1+owner.r)*sin(angle), dmg, blife, new PVector(speed*cos(angle), speed*sin(angle))));
            }
          }
        }
      }
      t=cd;
    }
  }
  void update() {
    t--;
    shoot();
    display();
  }
}

class rLauncher extends weapon {
  rLauncher(colobok o, float icd, int idmg) {
    super(o, icd, idmg, 1000*mx);
  }
  void shoot() {
    if (ne!=null) {
      angle=atan2(ne.y-owner.y, ne.x-owner.x);
      if (t<=0 && dist(ne.x, ne.y, owner.x, owner.y)<=shootDist) {
        playShotSound();
        bullets.add(new rocket(owner.x+(10+owner.r)*cos(angle), owner.y+(10+owner.r)*sin(angle), dmg, new PVector(speed*cos(angle), speed*sin(angle)), en, owner));
        t=cd;
      }
    }
  }
}

class tMaker extends weapon {
  tMaker(colobok o, float icd, int idmg, float shd) {
    super(o, icd, idmg, shd);
    speed=2;
  }
  void shoot() {
    if (ne!=null) {
      angle=atan2(ne.y-owner.y, ne.x-owner.x);
      if (t<=0 && dist(ne.x, ne.y, owner.x, owner.y)<=shootDist) {
        bullets.add(new turret(owner, en, 10, shootDist, owner.x+(10+owner.r)*cos(angle), owner.y+(10+owner.r)*sin(angle), dmg, new PVector(speed*cos(angle), speed*sin(angle))));
        t=cd;
        playShotSound();
      }
    }
  }
}

class laser extends weapon {
  laser(colobok o, float icd, int dmg, float shd) {
    super(o, icd, dmg, shd);
  }

  void shoot() {
    if (ne!=null) {
      angle=atan2(ne.y-owner.y, ne.x-owner.x);
      if (t<=0 && dist(ne.x, ne.y, owner.x, owner.y)<=shootDist) {
        //if (atan2(ne.y-y, ne.x-x)>angle-dAngle && atan2(ne.y-y, ne.x-x)<angle+dAngle) {
        float shootX, shootY;
        shootX=ne.x;//+random(-ne.r, ne.r);
        shootY=ne.y;//+random(-ne.r, ne.r);
        for (int i=0; i<10; i++) {
          strokeWeight(10-i);
          stroke(255, 255*i/10, 255*i/10, 255*(10-i)/10);
          line(owner.x, owner.y, shootX, shootY);
        }
        if (dist(ne.x, ne.y, shootX, shootY)<ne.r) {
          ne.hp-=dmg;
        }
        //bullets.add(new bullet(owner.x+(1+owner.r)*cos(angle), owner.y+(1+owner.r)*sin(angle), dmg, blife, new PVector(speed*cos(angle), speed*sin(angle))));
        t=cd;
        playShotSound();
        //line(x+size*cos(angle), y+size*sin(angle), shootX, shootY);
        //}
      }
    }
  }
}
