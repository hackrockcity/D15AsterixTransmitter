public class Zombie extends Spark {
  int brains;
  Zombie lastswap;
  
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
  
  public boolean canEat(Spark victim, boolean trapped) {
    return life >= victim.life && !(victim instanceof Zombie) && !(victim instanceof Dragon);
  }
    
  public boolean eat(Spark victim) {
    int oldpos = victim.pos;
    
    dlife((int)(victim.life/World.zombifyDivisor));
    World.kill(victim);
    
    Zombie zombie = new Zombie(oldpos,(int)(life/World.zombifiedDivisor),this);
    World.add(zombie);
    
    brains = (int)World.zombieBrains;
    
    return true;
  }
  
  public boolean canMove(int delta) {
    Spark c = World.get(pos+delta);
    
    return (c == null || (c instanceof Zombie && c != lastswap));
  }
  
  public boolean move(int delta) {
    Spark c = World.get(pos+delta);
    
    if (c == null) {
      int newpos = World.move(this,delta);
    
      if (newpos >= 0) {
        pos = newpos;
        return true;
      }
    
      return false;
    }
    else {
      lastswap = c;
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
    draw.stroke(life,(int)(life/255.0*178),(int)(life/255.0*63));
    draw.point(x,y);    
  }
}

