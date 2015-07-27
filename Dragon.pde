public class Dragon extends Spark {
  int dir;
  int fireTimer = 0;
  int turnaroundTimer = 0;
  ArrayList<Float> fire = new ArrayList<Float>();
  
  public Dragon(int pos, int life) {
    super(pos,life,null,null);
    
    dir = number % 2 == 0 ? 1 : -1;
    turnaroundTimer = 10 + (int)random(10);
    for (int i=0; i<10; i++) {
      fire.add(0.0);
    }    
  }
  
  public boolean canEat(Spark victim, boolean trapped) { return true; }
  public boolean canMate(Spark mate) { return false; }

  public boolean act() {
    Spark c = look(dir*10);
    Spark c2 = look(-dir*10);
    
    if (c != null) {
      fireTimer = 10;
    }
    else if (c2 != null) {
      dir = -dir;
      fireTimer = 10;
    }
    else if (fireTimer > 0) {
      fireTimer--;
    }
    
    if (fireTimer > 0) {
      burn();
      dlife(-life/World.fireDivisor);
    }
    else dlife(life/World.healDivisor);
    
    move(dir);
    
    if (turnaroundTimer-- < 1) {
      turnaroundTimer = 50 + (int)random(50);
      dir = -dir;
    }
    
    return true;
  }
  
  public boolean burn() {
    for (int i=0; i<10; i++) {
      if (fire.get(i) > 0) {
        Spark s = World.get(pos+(i+1)*dir);
        if (s != null) s.die();
      }
    }
    
    return true;
  }
  
  public boolean move(int delta) {
    Spark c = World.get(pos+delta);
    
    if (c == null) {
      int newpos = World.move(this,delta);
    
      if (newpos >= 0) {
        pos = newpos;
        return true;
      }
    }
    
    return false;
  }
  
  public void draw() {    
    int p;
    int x;
    int y;
    float l;
    
    if (fireTimer > 0) {
      fire.add(0, random(255));
      fire.remove(fire.size()-1);
    }
    else if (fire.get(fire.size()-1) > 0) {
      fire.add(0,0.0);
      fire.remove(fire.size()-1);
    }
    
    for (int i=0; i<10; i++) {      
      p = World.bound(pos-(i*dir));
      x = p / Config.HEIGHT;
      y = p % Config.HEIGHT;
      l = max(life,127)/(i/2+1.0);

      draw.stroke((int)l,(int)(l/255*23),(int)(l/255*218));
      draw.point(x,y);
      
      if (fireTimer > 0 || fire.get(fire.size()-1) > 0) {
        p = World.bound(pos+(i*dir));
        x = p / Config.HEIGHT;
        y = p % Config.HEIGHT;

        draw.stroke(fire.get(i).intValue(),(int)(fire.get(i)/255*23),(int)(fire.get(i)/255*218));        
        draw.point(x,y);
      }
    }
  }  
}

