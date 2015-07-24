public class Life extends Routine {
   public Critter spawn() {
    int pos = int(random(World.population.length));
    Critter c;
    
    for (int i=0; i<10; i++) {
      c = World.get(pos+i);
      if (c == null) {
        c = new Critter(pos+i, (int)(64+random(128)), null, null);
        World.add(c);
        return c;
      }
    }
    
    println("Couldn't find a home for spawn");
    return null;
  }
  
  public Life() {
    World.setup();
    
    for (int i=0; i<300; i++) {
      spawn();
    }
  }

  public void draw() {
    draw.background(0);
    World.act();
    
    if (World.alive < 300) 
      for (int i=World.alive; i<300; i++) spawn();
    else if (World.alive > 1000) 
      for (int i=1000; i<World.alive; i++) World.despawn();
      
    World.draw();
  }
}
