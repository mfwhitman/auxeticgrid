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
 
void updateGUI() {
  
  currCameraMatrix = new PMatrix3D(g3.camera);
  camera();
  controlP5.draw();
  g3.camera = currCameraMatrix;

}

void updateLines() {

  for (Iterator i=physics.springs.iterator(); i.hasNext();) {
    
    FoldSpring s = (FoldSpring)i.next();
    
    switch(s.ident) {
      
      case 0:
        if (outlined) stroke(color(palette[s.ident])); else noStroke();
        break;
      case 1:
      case 2:
      case 3:
      case 4:
        if (foldSprings) stroke(color(palette[s.ident])); else noStroke();
        break;
        
    }
    
    line(s.a.x,s.a.y,s.a.z,s.b.x,s.b.y,s.b.z);

  }
}


void updateMesh() {
  
  mesh=new TriangleMesh();
  
  for(int y=0, idx=1; y<yDIM-1; y++) {
    
    for(int x=0; x<xDIM-1; x++) {
      
      int i=y*xDIM+x;
      VerletParticle a=physics.particles.get(i);
      VerletParticle b=physics.particles.get(i+1);
      VerletParticle c=physics.particles.get(i+1+xDIM);
      VerletParticle d=physics.particles.get(i+xDIM);
      if (idx%2==1) {
        
        mesh.addFace(a,d,c);
        mesh.addFace(a,c,b);
        
      }
      else {
        
        mesh.addFace(a,d,b);
        mesh.addFace(b,d,c);
        
      }
      idx++;
    }
    if ((y%2==0)) {
      
      idx++;
      
    }
  }
}
