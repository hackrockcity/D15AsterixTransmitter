public class Spark {
  int number;
  int maxpos;
  int pos;
  float life;
  boolean isDead;
  Spark mom;
  Spark dad;
  
  public Spark(int pos, int life, Spark mom, Spark dad) {
    this.number = World.makeNumber();
    this.pos = pos;
    this.life = life;
    this.maxpos = Config.WIDTH * Config.HEIGHT;
    this.mom = mom;
    this.dad = dad;
    this.isDead = false;
  }
  
  public boolean actOn(Spark c) {
    if (canMate(c)) return mate(c);
    else if (canEat(c,false)) return eat(c);
    return false;
  }
  
  public boolean actOnTrapped(Spark c, Spark c2, int dir) {
    if (canEat(c,true)) return eat(c);
    else if (canEat(c2,true)) return eat(c2);
    else if (World.canJump && canMove(dir*2)) return move(dir*2);
    else if (World.canJump && canMove(dir*-2)) return move(dir*-2);
    else if (World.dieOnTrapped) return die();
    else return dlife((int)(-life/World.trappedDivisor));
  }
  
  public boolean moveOn(Spark c, int delta) {
    if ((canEat(c,true) || canMate(c)) && canMove(delta)) return move(delta);
    else if (c.canEat(this,true) && canMove(-delta) && life > 32) return move(-delta);
    else if (life < 32) return dlife(-1);
    return false;
  }
  
  public boolean act() {
    if (this.isDead) {
      println(this.number + " should be dead.");
      return false;
    }
    
    int dir = number % 2 == 0 ? 1 : -1;
    Spark c; 
    Spark c2;
    
    // Try to act on first adjacent
    c = look(dir);
    if (c != null && actOn(c)) return true;
    
    // Try to act on second adjacent
    c2 = look(-dir);
    if (c2 != null && actOn(c2)) return true;

    // If trapped, act on being trapped
    if (c != null && c2 != null && actOnTrapped(c,c2,dir)) return true;
    
    // If no first adjacent, look further and plan
    if (c == null) {
      c = look(16*dir);
      
      if (c != null && moveOn(c,dir)) 
        return true;
    }
  
    // If no second adjacent, look further and plan
    if (c2 == null) {  
      c2 = look(-16*dir);
    
      if (c2 != null && moveOn(c2,-dir)) 
        return true;
    }
    
    // Otherwise just move
    return defaultAct(dir);
  }

  public boolean defaultAct(int dir) {
    if (canMove(dir)) return move(dir);
    else return move(-dir);
  }
  
  public boolean canEat(Spark victim, boolean trapped) {
    if (this == victim) {
      println(this.number + " is trying to eat itself");
      return false;
    }
    
    if (victim instanceof Dragon) return false;
    
    // Can eat if stronger, not family, or trapped/dying and not child.
    return  
      life >= victim.life && ( 
        !this.isFamily(victim) ||
        ((trapped || life < 32) && this.isParent(victim))
      );
  }
  
  public boolean canMate(Spark mate) {
    
    // Some safety checks, can remove
    if (this == mate) {
      println(this.number + " is trying to mate with itself");
      return false;
    }
    else if (this.pos == mate.pos) {
      println(this.number + " and " + mate.number + " occupy the same space!");
      return false;
    }
    
    if (mate instanceof Zombie) return false;
    if (this instanceof Zombie) return false;
    if (mate instanceof Dragon) return false;
    if (this instanceof Dragon) return false;

    // Figure out which direction would need to move
    int delta = this.pos-mate.pos/abs(this.pos-mate.pos);
    
    // If we're both healthy and can make room for baby
    return this.life >= 128 && mate.life >= 128 && 
      canMove(delta);
  }
  
  public boolean isChild(Spark c) {
    return c.dad == this || c.mom == this;
  }
  
  public boolean isParent(Spark c) {
    return dad == c || mom == c;
  }
  
  public boolean isFamily(Spark c) {
    return this.isParent(c) || this.isChild(c);
  }
  
  public boolean die() {
    World.kill(this);
    return true;
  }
  
  public boolean eat(Spark victim) {
    if (!(victim instanceof Zombie)) this.dlife(victim.life);
    World.kill(victim);
    return true;    
  }
  
  public boolean mate(Spark dad) {
    int delta = this.pos-dad.pos/abs(this.pos-dad.pos);
    int babypos = this.pos;
    
    // Mom moves out of the way
    move(delta);
    
    // Add baby in moms old position
    Spark baby = new Spark(babypos,(int)((dad.life+this.life)/World.offspringDivisor),this,dad);
    
    // Making babies takes work
    this.dlife((int)(-this.life/World.matingDivisor));
    dad.dlife((int)(-dad.life/World.matingDivisor));
    
    // Add the baby into the world
    World.add(baby);
    
    return true;
  }
  
  public Spark look(int delta) {
    int sign = delta/abs(delta);
    Spark c;
    
    for (int i=1; i<=abs(delta); i++) {
      c = World.get(pos+i*sign);
      if (c != null) return c; 
    }
    
    return null;
  }
  
  public boolean dlife(float delta) {
    life += delta;
    if (life<1)
      this.die();
    else if (life>255)
      life=255;
      
    return true;
  }
  
  public boolean canMove(int delta) {
    return World.get(pos+delta) == null;
  }
  
  public boolean move(int delta) {
    int newpos = World.move(this,delta);
    
    if (newpos >= 0) {
      pos = newpos;
      this.dlife(-abs(delta));
      return true;
    }
    
    return false;
  }
  
  public void draw() {
    int x = pos / Config.HEIGHT;
    int y = pos % Config.HEIGHT;
    
    draw.stroke(life);
    draw.point(x,y);    
  }
}

