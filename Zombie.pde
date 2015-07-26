public class Zombie extends Critter {
  int brains;
  
  public Zombie(int pos, int life, Zombie zombifier) {
    super(pos,life,zombifier,null);

    brains = (int)World.zombieBrains;
  }

  public boolean act() {
    if (brains-- < 0) dlife(-1);
    if (this.isDead) return true;
    return super.act();
  }
  
  public boolean canMate() {
    return false;
  }
  
  public boolean canEat(Critter victim, boolean trapped) {
    return life >= victim.life && !(victim instanceof Zombie);
  }
    
  public boolean eat(Critter victim) {
    int oldpos = victim.pos;
    
    dlife((int)(victim.life/World.zombifyDivisor));
    World.kill(victim);
    
    Zombie zombie = new Zombie(oldpos,(int)(life/World.zombifiedDivisor),this);
    World.add(zombie);
    
    brains = (int)World.zombieBrains;
    
    return true;
  }
  
  public boolean canMove(int delta) {
    Critter c = World.get(pos+delta);
    
    return (c == null || c instanceof Zombie);
  }
  
  public boolean move(int delta) {
    Critter c = World.get(pos+delta);
    
    if (c == null) {
      int newpos = World.move(this,delta);
    
      if (newpos >= 0) {
        pos = newpos;
        return true;
      }
    
      return false;
    }
    else {
      World.swap(this.pos, c.pos);
      int tmp = this.pos;
      this.pos = c.pos;
      c.pos = tmp;
      return true;
    }
  }
  
  public void draw() {
    int x = pos / Config.HEIGHT;
    int y = pos % Config.HEIGHT;
    
    draw.stroke(life,life/2,life/2);
    draw.point(x,y);    
  }
}

