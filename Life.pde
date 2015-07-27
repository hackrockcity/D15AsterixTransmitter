public class Life extends Routine {  
   // We have to do this here because we cannot make a static in
   // Spark because it's inner and we cannot access Spark from
   // World because its static.
   public void spawn(int type) {
    int pos = int(random(World.population.length));
    Spark c;
    
    for (int i=0; i<10; i++) {
      c = World.get(pos+i);
      if (c == null) {
          if (type == 0)
            c = new Spark(pos+i, (int)(64+random(128)), null, null);
          else if (type == 1)
            c = new Zombie(pos+i, (int)(64+random(128)), null);
          else
            c = new Dragon(pos+i, 255);
            
        World.add(c);
        return;
      }
    }
    
    println("Couldn't find a home for spawn");
  }
  
  public void spawn(int n, int type) {
    for (int i=0; i<n; i++) {
      spawn(type);
    }
  }
  
  public void despawn() {
    World.despawn();
  }
  
  public void despawn(int n) {
    for (int i=0; i<n; i++) {
      despawn();
    }
  }
  
  public Life() {
    World.setup();
    spawn(300,0);
    spawn(30,1);
    spawn(3,2); 
  }
  
  public void draw() {
    draw.background(0);
    World.act();
    
    if (World.alive < 300) {
      World.matingDivisor = World.matingDivisor * 1.01;
      println("Mating divisor changed to " + World.matingDivisor);
      spawn(300-World.alive,0);
    }
    else if (World.alive > 1000) {
      World.matingDivisor = World.matingDivisor * 0.99;
      println("Mating divisor changed to " + World.matingDivisor);
      despawn(World.alive-1000);
    }
    
    if (1.0 * World.zombies / World.alive > 0.35) {
      World.zombieBrains = World.zombieBrains * 0.999;
      println("Zombie brains changed to " + World.zombieBrains);
    }
    else if (1.0 * World.zombies / World.alive < 0.10 && World.zombieBrains < 300) {
      World.zombieBrains = World.zombieBrains * 1.001;
      println("Zombie brains changed to " + World.zombieBrains);
    }
    
    if (random(1) < World.spawnChance) {
      if (World.dragons < 10 && random(1) < World.dragonChance) {
        spawn(2);
      }
      else if (random(1) < World.zombieChance)
        spawn(1);
      else
        spawn(0);
    }
    
    World.draw();
    
    if (World.turn % 100000 == 0) World.reset();
    else if (World.turn % 1000 == 0) World.entropy();
  }
}
