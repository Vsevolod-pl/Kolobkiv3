class bullet {
  float x, y;
  int dmg, life, l0;
  PVector velocity;

  bullet(float ix, float iy, int idmg, int lf, PVector v) {
    x=ix;
    y=iy;
    dmg=idmg;
    velocity=v;
    life=lf;
    l0=lf;
  }

  void display() {
    noStroke();
    fill(255, 255*life/l0);
    ellipse(x, y, 5, 5);
  }

  void move() {
    x+=velocity.x;
    y+=velocity.y;
  }

  void update() {
    life-=1;
    //if (life<=0) x=width+100;
    move();
    display();
  }
}

class rocket extends bullet {
  ArrayList<colobok> en;
  colobok owner, ne;
  PVector acc=new PVector();
  rocket(float ix, float iy, int idmg, PVector v, ArrayList<colobok> e, colobok o) {
    super(ix, iy, idmg, 100, v);//2*width*height
    en=e;
    owner=o;
    foundEnemy();
    velocity.mult(0);
  }
  void foundEnemy() {
    if (en.size()>=1) {
      ne=(colobok) en.get(int(random(en.size())));
    }
  }

  void display() {
    noStroke();
    fill(0, 255, 0);

    pushMatrix();
    translate(x, y);
    rotate(velocity.heading());
    rect(-5, -2, 30, 4);
    popMatrix();

    //ellipse(x, y, 10, 10);
  }

  void explode() {
    for (colobok e : en) {
      if ((dist(x, y,e.x,e.y)<250*mx &&
      dist(x,y,owner.x,owner.y)>270*mx) || life<=1) {
        Detonate();
        break;
      }
    }
  }

  void Detonate() {
    explosionPower+=20*mx;
    for (float angle=0; angle<TWO_PI; angle+=PI/40) {
      //bullets.add(new bullet(e.x/*+(1+e.r)*cos(angle)*/,e.y/*+(1+e.r)*sin(angle)*/, 20, new PVector(speed*cos(angle), speed*sin(angle))));
      for (float speed=3; speed>2.6; speed*=0.9) {
        bullets.add(new bullet(x, y, 20, int(10*mx), new PVector(speed*10*cos(angle), speed*10*sin(angle))));
      }
    }
    life=-1;
  }

  void move() {
    if (ne!=null) {
      acc.x=ne.x-x;
      acc.y=ne.y-y;
      acc.div(1000);
      //velocity.rotate((atan2(ne.y-y, ne.x-x)-velocity.heading())/2);
    } else
      foundEnemy();
    velocity.add(acc);
    velocity.limit(30);
    /*if (x+velocity.x<0) {
     x-=velocity.x;
     Detonate() ; //velocity.x*=-1;// x=0+abs(velocity.x);
     }
     if (x+velocity.x>width) {
     x-=velocity.x;
     Detonate(); //velocity.x*=-1;// x=width-abs(velocity.x);
     }
     if (y+velocity.y<0) {
     y-=velocity.y;
     Detonate() ; //velocity.y*=-1;// y=0+abs(velocity.y);
     }
     if (y+velocity.y>height) {
     y-=velocity.y;
     Detonate() ; //velocity.y*=-1;// y=height-abs(velocity.y);
     }*/
    super.move();
    while (owner.pointIn (x, y)) {
      super.move();
    }
    if (ne.hp<=0) ne=null;
    explode();
  }
}

class turret extends bullet{
  int dmg, blife=1000;
  float cd, t, speed=10, angle, shootDist;
  colobok owner, ne;
  ArrayList<colobok> en;
  turret(colobok o, ArrayList<colobok> e, float icd, float shd, float ix, float iy, int idmg, PVector v) {
    super(ix, iy, idmg, 100000, v);
    t=cd;
    owner=o;
    en=e;
    cd=icd;
    dmg=idmg;
    shootDist=shd;
  }

  void foundEnemy() {
    if (en.size()>=1) {
      ne=(colobok) en.get(int(random(en.size())));
    }
  }

  void shoot() {
    if (ne!=null) {
      float vx=ne.velocity.x,
      vy=ne.velocity.y;
  
      float time=dist(x,y,ne.x,ne.y)/speed;
      time=dist(x,y,ne.x+vx*t,ne.y+vy*t)/speed;
      float tx=ne.x+ne.velocity.x*time, 
      ty=ne.y+ne.velocity.y*time;
      angle=atan2(ty-y, tx-x);
      //angle=atan2(ne.y-y,ne.x-x);
      if (t<=0 && dist(ne.x, ne.y, owner.x, owner.y)<=shootDist) {
        if (bullets.size()<rec)
          bullets.add(new turret(owner, en, cd, shootDist, x, y, dmg, new PVector(speed*cos(angle), speed*sin(angle))));
        else if (bullets.size()<5000)
          bullets.add(new /*rocket*/bullet(x, y, dmg, blife, new PVector(speed*cos(angle), speed*sin(angle))/*, en, owner*/));

        t=cd; 
        //line(x+size*cos(angle), y+size*sin(angle), shootX, shootY);
        //
      }
    }
  }
  
  void Detonate() {
    explosionPower+=20*mx;
    for (float angle=0; angle<TWO_PI; angle+=PI/40) {
      //bullets.add(new bullet(e.x/*+(1+e.r)*cos(angle)*/,e.y/*+(1+e.r)*sin(angle)*/, 20, new PVector(speed*cos(angle), speed*sin(angle))));
      for (float speed=3; speed>2.6; speed*=0.9) {
        bullets.add(new bullet(x, y, 20, int(10*mx), new PVector(speed*10*cos(angle), speed*10*sin(angle))));
      }
    }
    life=-1;
  }
  
  void explode() {
    for (colobok e : en) {
      if ((dist(x, y,e.x,e.y)<250*mx &&
      dist(x,y,owner.x,owner.y)>270*mx) || life<=1) {
        Detonate();
        break;
      }
    }
  }

  void display() {
    noStroke();
    fill(255, 0, 0);
    rect(x-5, y-5, 10, 10);
  }

  void updateVel() {
    velocity.mult(0);
    velocity.x=owner.x-x;
    velocity.y=owner.y-y;
    velocity.limit(2);
  }

  void move() {
    updateVel();
    super.move();
    if(owner.pointIn(x,y))
      velocity.mult(-1);
    while (owner.pointIn (x, y)) {
      super.move();
    }
  }

  void update() {
    if (ne==null) foundEnemy();
    t--;
    move();
    shoot();
    display();
    explode();
    if (ne.hp<=0) ne=null;
  }
}

