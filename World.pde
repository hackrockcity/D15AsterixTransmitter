import java.util.*;

public static class World {
  public static int turn = 0;
  public static int total = 0;
  public static int alive = 0;
  public static Critter[] population;
  public static ArrayList<Critter> living;

  public static void setup() {
    population = new Critter[Config.WIDTH*Config.HEIGHT];
    for (int i=0; i<population.length; i++) {
      population[i] = null;
    }
    living = new ArrayList<Critter>();
  }
  
  public static boolean add(Critter c) {
    if (population[c.pos] == null) {
      population[c.pos] = c;
      alive++;
      //println("Added " + c.number + " now " + alive + " alive");
      living.add(c);
      return true;
    }
    
    println("Couldn't add " + c.number + " because " + population[c.pos].number + " occupies that spot.");
    return false;
  }
  
  public static boolean kill(Critter c) {
    if (c == null) {
      println("Cannot kill null");
      return false;
    }
    
    if (c.isDead) {
//      println(c.number + " is already dead.");
//      throw new RuntimeException();
      return true;
    }
    
    if (population[c.pos] != c) {
      int pos = find(c);
      if (pos >= 0) {
        println("Corrected " + c.number + " from " + c.pos + " to " + c.pos + ", will kill.");
        c.pos = pos;
      }
      else { 
        println("Cannot kill " + c.number + " because is not where expected: " + c.pos + "=" + population[c.pos]);
        return false;
      }
    }
    
    c.dad = null;
    c.mom = null;
    population[c.pos] = null;
    living.remove(c);
    
    for (Critter child : population) {
      if (child != null) {
        if (child.dad == c) child.dad = null;
        if (child.mom == c) child.mom = null;
      }
    }
    
    c.isDead = true;
    alive--;
    //println("Killed " + c.number + " now " + alive + " alive");
    return true;
  }

  public static int find(Critter target) {
    for (int i=0; i<population.length; i++) {
      if (population[i] == target) return i;
    }
    return -1;
  }
      
  public static int bound(int i) {
    while(i>=population.length) i-= population.length;
    while(i<0) i+= population.length;
    return i;
  }  
  
  public static Critter get(int i) {
    return population[World.bound(i)];
  }
  
  public static int move(Critter c, int delta) {
    int newpos = bound(c.pos+delta);
    if (get(newpos) == null) {
      population[c.pos] = null;
      population[newpos] = c;
      return newpos;
    }
    
    throw new RuntimeException("Cannot move " + c.number + " to " + newpos + " because " + population[newpos].number + " is there");
  }
  
  public static void act() {
    Collections.shuffle(living,new Random(System.nanoTime()));

    for (int i=0; i<living.size(); i++) {
      Critter c = living.get(i);
      
      if (!c.isDead) c.act();
    }    

    turn++;
    
    if (turn % 100 == 0) 
      println("Turn #"+turn + " " + total+" born " + alive+" alive");

  }
  
  public static void draw() {
    for (Critter c : population) 
      if (c != null && !c.isDead) 
        c.draw();
        
  }

  public static int makeNumber() {
    return total++;
  }  
  
  public static void despawn() {
    Critter c = living.get(0);
    World.kill(c);
  }
}

