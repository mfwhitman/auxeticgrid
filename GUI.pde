/**
 * Copyright (c) 2011 Michael Whitman
 *
 *  This file is part of Auxeticgrid.
 *
 *  Auxeticgrid is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  Auxeticgrid is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with Auxeticgrid.  If not, see <http://www.gnu.org/licenses/>.
 *      
 *  This contains modified code from the SoftBodySquare demo distributed
 *  with the toxiclibs library.
 *  These modifications were made between 03 Mar 2011 and 22 Mar 2011. The
 *  original copyright notice is below:    
 */

/* 
 * Copyright (c) 2008-2009 Karsten Schmidt
 * 
 * This demo & library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 * 
 * http://creativecommons.org/licenses/LGPL/2.1/
 * 
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
 
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
  /*
  if (key == 'v' || key == 'V') { //Removes all velocity from the particles. Doesn't work for long, though.
    for (Iterator i=physics.particles.iterator(); i.hasNext();) {
      VerletParticle p = (VerletParticle)i.next();
      p.clearVelocity();
    }
  }
  if (key == 'b' || key == 'B') { //Removes the Box Constraint from particular particles. Generates a NullPointerException.
    BoxConstraint c = (BoxConstraint) grounds.get(0);
    //VerletPhysics.removeConstraintFromAll(c,physics.particles);
    for (Iterator i=physics.particles.iterator(); i.hasNext();) {
      VerletParticle p = (VerletParticle)i.next();
      p.removeConstraint(c);
    }
  }
  */
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
