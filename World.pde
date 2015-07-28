import java.util.*;

public static class World {
  public static float matingDivisor;
  public static float offspringDivisor;
  public static boolean canJump;
  public static boolean dieOnTrapped;
  public static float trappedDivisor; 
  public static float zombifyDivisor;
  public static float zombifiedDivisor;
  public static float zombieBrains;
  public static float spawnChance;
  public static float zombieChance;
  public static float dragonChance;
  public static float fireDivisor;
  public static float healDivisor;
  
  public static int turn = 0;
  public static int total = 0;
  public static int alive = 0;
  public static int zombies = 0;
  public static int dragons = 0;
  
  public static Spark[] population;
  public static ArrayList<Spark> living;

  public static void reset() {
    matingDivisor = 4;
    offspringDivisor = 2;
    canJump = false;
    dieOnTrapped = true;
    trappedDivisor = 6; 
    zombifyDivisor = 1.2;
    zombifiedDivisor = 1.2;
    zombieBrains = 200;
    spawnChance = 0.2;
    zombieChance = 0.5;
    dragonChance = 0.05;
    fireDivisor = 15;
    healDivisor = 20;
    
    print("RESET! ");
    printWorldSettings();
  }
  
  public static void setup() {
    reset();
    population = new Spark[Config.WIDTH*Config.HEIGHT];
    for (int i=0; i<population.length; i++) {
      population[i] = null;
    }
    living = new ArrayList<Spark>();
  }
  
  public static boolean add(Spark c) {
    if (population[c.pos] == null) {
      population[c.pos] = c;
      alive++;
      if (c instanceof Zombie) zombies++;
      if (c instanceof Dragon) dragons++;
      living.add(c);
      return true;
    }
    
    throw new RuntimeException("Couldn't add " + c.number + " because " + population[c.pos].number + " occupies that spot.");
  }
  
  public static boolean kill(Spark c) {
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
    
    for (Spark child : population) {
      if (child != null) {
        if (child.dad == c) child.dad = null;
        if (child.mom == c) child.mom = null;
      }
    }
    
    c.isDead = true;
    alive--;
    if (c instanceof Zombie) zombies--;
    if (c instanceof Dragon) dragons--;
    //println("Killed " + c.number + " now " + alive + " alive");
    return true;
  }

  public static int find(Spark target) {
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
  
  public static Spark get(int i) {
    return population[World.bound(i)];
  }
  
  public static int move(Spark c, int delta) {
    int newpos = bound(c.pos+delta);
    if (get(newpos) == null) {
      population[c.pos] = null;
      population[newpos] = c;
      return newpos;
    }
    
    throw new RuntimeException("Cannot move " + c.number + " to " + newpos + " because " + population[newpos].number + " is there");
  }
  
  public static void swap(int l, int r) {
    Spark tmp = population[l];
    population[l] = population[r];
    population[r] = tmp;
  }
  
  public static void act() {
    Collections.shuffle(living,new Random(System.nanoTime()));

    for (int i=0; i<living.size(); i++) {
      Spark c = living.get(i);
      
      if (!c.isDead) c.act();
    }    

    turn++;
    
    if (turn % 100 == 0) 
      println("Turn #"+turn + " " + total+" born " + alive+" alive " + zombies + " zombies " + dragons + " dragons");

  }
  
  public static void draw() {
    for (Spark c : population) 
      if (c != null && !c.isDead) 
        c.draw();
        
  }

  public static int makeNumber() {
    return total++;
  }  
  
  public static void despawn() {
    Spark c = living.get(0);
    living.remove(0);
    World.kill(c);
  }
  
  public static float random(float n) {
    return (float)(Math.random() * n);
  }
  
  public static void entropy() {
    World.matingDivisor = World.matingDivisor * (0.9 + random(0.2));
    World.offspringDivisor = World.offspringDivisor * (0.9 + random(0.2));
    World.canJump = random(1) < 0.2 ? !World.canJump : World.canJump;
    World.dieOnTrapped = random(1) < 0.2 ? !World.dieOnTrapped : World.dieOnTrapped;
    World.trappedDivisor = World.trappedDivisor * (0.9 + random(0.2));
    World.zombifyDivisor = World.zombifyDivisor * (0.9 + random(0.2));
    World.zombifiedDivisor = World.zombifiedDivisor * (0.9 + random(0.2));
    World.zombieChance = World.zombieChance * (0.9 + random(0.2));
    World.zombieBrains = World.zombieBrains * (0.9 + random(0.2));
    World.dragonChance = World.dragonChance * (0.9 + random(0.2));
    World.fireDivisor = World.fireDivisor * (0.9 + random(0.2));
    World.healDivisor = World.healDivisor * (0.9 + random(0.2));
    World.fireDivisor = World.fireDivisor * (0.9 + random(0.2));
    
    print("Entropy! ");
    printWorldSettings();  
  }
  
  public static void printWorldSettings() {
        println("matingDivisor=" + World.matingDivisor + 
      " offSpringDivisor=" + World.offspringDivisor + 
      " canJump=" + World.canJump + 
      " dieOnTrapped=" + World.dieOnTrapped + 
      " trappedDivisor=" + World.trappedDivisor +
      " zombifyDivisor=" + World.zombifyDivisor + 
      " zombifiedDivisor=" + World.zombifiedDivisor +
      " zombieChance=" + World.zombieChance +
      " zombieBrains=" + World.zombieBrains +
      " dragonChance=" + World.dragonChance +
      " fireDivisor=" + World.fireDivisor + 
      " healDivisor=" + World.healDivisor
    ); 
  }
}

