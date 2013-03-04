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
 
/*
 * Built with Processing (processing.org)
 *
 * To make this Processing sketch work, it requires Processing 2.0 Beta 8
 * and the following libraries:
 *   toxiclibs (available under GNU Lesser General Public License 2.1),
 *   controlP5 (available under GNU Lesser General Public License 2.1), and
 *   peasycam (https://github.com/jeffg2k/peasycam, available under the Apache License, v2.0).
 *
 *
 * <p>This sketch generates a tessellating origami pattern known as miura-ori
 * using verlet particles from the toxiclibs libraries.
 * </p>
 *
 * <p>Usage:</p>
 * <p>Press X to restart the application. </p>
 * <p>Press W to toggle wireframe mode. </p>
 * <p>Press S to start and stop the simulation. </p>
 * <p>Press R to hide the springs that simulate folding.</p>
 * <p>Press O to outline the edges of the mesh.</p>
 * <p>Press L to lock the centre particle in place.</p> 
 * <p>Press V to remove all the particle velocity from the simulation.</p> 
 */


import processing.opengl.*;

import java.awt.*;
import java.util.Iterator;

import toxi.geom.*;
import toxi.geom.mesh.*;
import toxi.math.*;
import toxi.physics.*;
import toxi.physics.behaviors.*;
import toxi.physics.constraints.*;
import toxi.processing.*;

import controlP5.*;
import peasy.*;

ControlP5 controlP5;

PeasyCam cam;
PMatrix3D currCameraMatrix;
PGraphics3D g3;

ToxiclibsSupport gfx;
TriangleMesh mesh;

int yDIM = 13; 
int xDIM = 17;              //Currently this has to be odd. It generates some scrappy edges though.
int REST_LENGTH = 10;       //Initial RestLength of the grid.
int initLength = 10;        //Initial RestLength of the grid.

float STRENGTH = 0.5;       //The VerletSpring strength of the regular springs.
float foldStrength = 0.95;  //The initial VerletSpring strength of the springs that facilitate folding.
float hypotenuse = sqrt(2); //Calculates the hypotenuse of one row and column.
float ljump = sqrt(5);      //Calculates the hypotenuse of two rows and one column.
boolean runSimulation = false;
boolean flatShaded = true;
boolean foldSprings = false;
boolean outlined = false;

int[] palette = { color(22,22,22) , color(100,233,23) , color(23,100,233) , color(233,23,100) , color(100,23,233) };
float[] initRestLengthVals = { 1 , 0.9 , 0.9 , 0.75 , 0.875 };
float[] initStrengthVals = { 0.5 , 0.95 , 0.95 , 0.95 , 0.95 };

VerletPhysics physics;
VerletParticle head,tail;

ArrayList grounds=new ArrayList();

//Vec3D.Axis a = Vec3D.Axis.X;
//Vec3D.Axis b = Vec3D.Axis.Y;
//PlaneConstraint plane = new PlaneConstraint(a, b, new Vec3D(0,0,-1));



void setup() {
  
  size(1024,576,OPENGL);
  gfx=new ToxiclibsSupport(this);
  smooth();

  physics = new VerletPhysics();
  //physics.setTimeStep(0.1);
  physics.setDrag(0.2);
  physics.addBehavior(new GravityBehavior(Vec3D.Z_AXIS.scale(-0.05)));
  physics.setWorldBounds(new AABB(new Vec3D(0,0,0),new Vec3D(200,200,10)));
  
  gridInitialize();

  println("Total Springs:    " + physics.springs.size());
  println("Total Particles:  " + physics.particles.size());

  /*  // Lock the corners of the sheet. It's not necessary to do it anymore and it just deforms the folding process.
   head=physics.particles.get(0);
   head.lock();
   head=physics.particles.get(DIM-1);
   head.lock();
   head=physics.particles.get(physics.particles.size()-1);
   head.lock();
   head=physics.particles.get(physics.particles.size()-DIM);
   head.lock(); 
   head=physics.particles.get(physics.particles.size()/2);
   head.lock();
   */

  g3 = (PGraphics3D)g;
  cam = new PeasyCam(this,physics.particles.get((physics.particles.size())/2).x,physics.particles.get((physics.particles.size())/2).y,physics.particles.get((physics.particles.size())/2).z,150);
  controlP5 = new ControlP5(this);
  controlP5.addTextlabel("label1","Strength",50,290);
  controlP5.addTextlabel("label2","Rest Length",50,412);  
  controlP5.addToggle("runSimulation",false,50,50,60,20).setId(1);
  controlP5.addToggle("foldSprings",false,50,100,60,20).setId(2);
  controlP5.addToggle("flatShaded",true,50,150,60,20).setId(3);
  controlP5.addToggle("outlined",false,50,200,60,20).setId(4);


  
  for (int i = 0; i < 5; i++) {
    
    controlP5.addSlider("folderStrength"+str(i),0,1, initStrengthVals[i], 50+i*25, 300, 20, 50);
    controlP5.controller("folderStrength"+str(i)).setLabelVisible(false);
    controlP5.controller("folderStrength"+str(i)).setColorBackground(blendColor(color(palette[i]),#333333,HARD_LIGHT));
    controlP5.controller("folderStrength"+str(i)).setColorForeground(blendColor(color(palette[i]),#555555,DODGE));
    controlP5.controller("folderStrength"+str(i)).setColorActive(blendColor(color(palette[i]),#555555,ADD));
    
    
    controlP5.addSlider("folderRestLength"+str(i),0.5,1.5, initRestLengthVals[i], 50+i*25, 360, 20, 50);
    controlP5.controller("folderRestLength"+str(i)).setLabelVisible(false);
    controlP5.controller("folderRestLength"+str(i)).setColorBackground(blendColor(color(palette[i]),#333333,HARD_LIGHT));
    controlP5.controller("folderRestLength"+str(i)).setColorForeground(blendColor(color(palette[i]),#555555,DODGE));
    controlP5.controller("folderRestLength"+str(i)).setColorActive(blendColor(color(palette[i]),#555555,ADD));

  }

  controlP5.setAutoDraw(false);   
  cam.lookAt(physics.particles.get((physics.particles.size())/2).x,physics.particles.get((physics.particles.size())/2).y,physics.particles.get((physics.particles.size())/2).z);
}

void draw() {
  background(#001E36);
  hint(ENABLE_DEPTH_TEST);  
  lights();
  specular(255);  
  directionalLight(255,255,255,1000,200,250);
  shininess(32);
  strokeWeight(2);

  if (runSimulation == true) {
    physics.update();
  }
  if (flatShaded == true) { //Does flatshading on the mesh.
    fill(#C0DDEA);
    updateMesh();  
    gfx.mesh(mesh);
  }

  updateLines();

  hint(DISABLE_DEPTH_TEST);
  updateGUI();
}

void gridInitialize() {
  
  grounds.add(new BoxConstraint(new Vec3D(-100,-100,-2),new Vec3D(200,200,-1)));
  
  for(int y=0,idx=0,celldx=0; y<yDIM; y++) {
    
    for(int x=0; x<xDIM; x++) {
      
      VerletParticle p = new VerletParticle(((xDIM-x)*initLength),((yDIM-y)*initLength),0);
      physics.addParticle(p);
      
      //creates a spring between the current particle and the previous one in the row.
      if ((x>0)) {
        
        FoldSpring s = new FoldSpring(p,physics.particles.get(idx-1),REST_LENGTH,STRENGTH,0,REST_LENGTH); 
        physics.addSpring(s);
        
      }
      
      //creates a spring between the current particle and the same particle on the previous row.
      if ((y>0)) {
        
        FoldSpring s=new FoldSpring(p,physics.particles.get(idx-xDIM),REST_LENGTH,STRENGTH,0,REST_LENGTH);
        physics.addSpring(s);
        
      }
      
      //creates a diagonal spring down and back one.
      if ((x>0) && (y>0) && (celldx%2==0)) {
        
        FoldSpring s = new FoldSpring(p,physics.particles.get(idx-xDIM-1),REST_LENGTH*hypotenuse,STRENGTH,0,REST_LENGTH*hypotenuse);
        physics.addSpring(s);
        
      }
      
      //creates a diagonal spring down and forward one.
      if ((xDIM-x>1) && (y>0) && (celldx%2==0)) {
        
        FoldSpring s = new FoldSpring(p,physics.particles.get(idx-xDIM+1),REST_LENGTH*hypotenuse,STRENGTH,0,REST_LENGTH*hypotenuse);
        physics.addSpring(s);
        
      }
      
      //creates a spring down two and forward one. This simulates folding.
      if ((y%2==1) && (y>1) && (celldx%2==0) && (xDIM-x>1)) {
        
        FoldSpring s = new FoldSpring(p,physics.particles.get(idx-2*xDIM+1),REST_LENGTH*ljump*initRestLengthVals[1],foldStrength,ljump,1,REST_LENGTH*ljump);
        physics.addSpring(s);
        
      }
      
      //creates a spring down two and back one. This simulates folding.
      if ((y%2==1) && (y>1) && (celldx%2==0) && (x>0)) {
        
        FoldSpring s = new FoldSpring(p,physics.particles.get(idx-2*xDIM-1),REST_LENGTH*ljump*initRestLengthVals[2],foldStrength,ljump,2,REST_LENGTH*ljump);
        physics.addSpring(s);
        
      }
      
      //creates a double vertical atttractor down two. This simulates folding.
      if ((y%2==0) && (y>0) && (celldx%2==1)) {
        
        FoldSpring s = new FoldSpring(p,physics.particles.get(idx-2*xDIM),REST_LENGTH*2*initRestLengthVals[3],foldStrength,REST_LENGTH*2,3,REST_LENGTH*2);
        physics.addSpring(s);
        
      }
      
      //creates a double horizontal atttractor back two. This simulates folding.
      if ((((celldx+x)%2==0) || (celldx+x)%2==1) && (x>1)) {
        
        FoldSpring s = new FoldSpring(p,physics.particles.get(idx-2),REST_LENGTH*2*initRestLengthVals[4],foldStrength,REST_LENGTH*2,4,REST_LENGTH*2);
        physics.addSpring(s);
        
      }
      
      //this particle is meant to move in the opposite direction to the rest. try constraining it to a plane.      
      if ((y%2==1) && (x>0)) { // Additional criteria: (y>1) && (celldx%2==0)
      
        BoxConstraint c = (BoxConstraint) grounds.get(0);
        p.addConstraint(c);
        
      }
      
      idx++;
      celldx++;
      
    }
    
    if ((y%2==0) && (y!=0)) {
      
      celldx++;
      
    }
    
  }
  
}


