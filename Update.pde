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
