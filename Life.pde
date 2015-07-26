public class Life extends Routine {  
   // We have to do this here because we cannot make a static in
   // Critter because it's inner and we cannot access Critter from
   // World because its static.
   public void spawn(boolean spawnZombie) {
    int pos = int(random(World.population.length));
    Critter c;
    
    for (int i=0; i<10; i++) {
      c = World.get(pos+i);
      if (c == null) {
          if (spawnZombie)
            c = new Zombie(pos+i, (int)(64+random(128)), null);
          else
            c = new Critter(pos+i, (int)(64+random(128)), null, null);
          
          
        World.add(c);
        return;
      }
    }
    
    println("Couldn't find a home for spawn");
  }
  
  public void spawn(int n) {
    for (int i=0; i<n; i++) {
      spawn(false);
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
    spawn(300);    
  }
  
  public void entropy() {
      World.entropy();
  }
  
  public void draw() {
    draw.background(0);
    World.act();
    
    if (World.alive < 300) {
      World.matingDivisor = World.matingDivisor * 1.01;
      println("Mating divisor changed to " + World.matingDivisor);
      spawn(300-World.alive);
    }
    else if (World.alive > 1000) {
      World.matingDivisor = World.matingDivisor * 0.99;
      println("Mating divisor changed to " + World.matingDivisor);
      despawn(World.alive-1000);
    }
    
    if (1.0 * World.zombies / World.alive > 0.5) {
      World.zombieBrains = World.zombieBrains * 0.99;
      println("Zombie brains changed to " + World.zombieBrains);
    }
    else if (1.0 * World.zombies / World.alive < 0.1 && World.zombieBrains < 200) {
      World.zombieBrains = World.zombieBrains * 1.01;
      println("Zombie brains changed to " + World.zombieBrains);
    }
    
    if (random(1) < World.spawnChance) {
      spawn(random(1) < World.zombieChance);     
    }
      
    World.draw();
    
    if (World.turn % 1000 == 0) entropy();
  }
}
