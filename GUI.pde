void controlEvent (ControlEvent theEvent) {
  
  if (match(theEvent.controller().name(),"folderStrength") != null) {
    
    int active = Integer.parseInt(String.valueOf((theEvent.controller().name().charAt(theEvent.controller().name().length()-1))));
    println(active);
    
    for (Iterator i=physics.springs.iterator(); i.hasNext();) {
      
      FoldSpring s=(FoldSpring)i.next();
      if (s.ident == active) {
        
        s.setStrength(theEvent.controller().value());
        //println("Spring Strength has been changed to " + s.getStrength());
        
      }
    }
  }
  
  if (match(theEvent.controller().name(),"folderRestLength") != null) {
    
    int active = Integer.parseInt(String.valueOf((theEvent.controller().name().charAt(theEvent.controller().name().length()-1))));
    println(active);
    
    for (Iterator i=physics.springs.iterator(); i.hasNext();) {
      
      FoldSpring s=(FoldSpring)i.next();
      if (s.ident == active) {
        
        s.setRestLength(s.initLen*theEvent.controller().value());
        //println("Spring Length has been changed to " + s.getRestLength());
        
      }
    }
  }
}

// This keyPressed will soon be superceded by the ControlP5 interface.
void keyPressed() {
  if (key == 'w' || key == 'W') { //Toggles display of the mesh.
    flatShaded = !flatShaded;
  }
  if (key == 'o' || key == 'O') { //Toggles wireframe.
    outlined = !outlined;
  }
  if (key == 'l' || key == 'L') { //Locks the centre particle.
    head=physics.particles.get(physics.particles.size()/2);
    head.lock();
  }
  if (key == 'v' || key == 'V') { //Removes all velocity from the particles. Doesn't work for long, though.
    for (Iterator i=physics.particles.iterator(); i.hasNext();) {
      VerletParticle p = (VerletParticle)i.next();
      p.clearVelocity();
    }
  }
  /*if (key == 'b' || key == 'B') { //Removes the Box Constraint from particular particles. Generates a NullPointerException.
    BoxConstraint c = (BoxConstraint) grounds.get(0);
    //VerletPhysics.removeConstraintFromAll(c,physics.particles);
    for (Iterator i=physics.particles.iterator(); i.hasNext();) {
      VerletParticle p = (VerletParticle)i.next();
      p.removeConstraint(c);
    }
  }*/
  if (key == 's' || key == 'S') { //Begins the simulation.
    runSimulation = !runSimulation;
  }
  if (key == 'r' || key == 'R') { //Hides the extra springs.
    foldSprings = !foldSprings;
  }
  if (key == 'x' || key == 'X') { //Restarts the application.
    runSimulation = false;
    setup();
  }  
}
