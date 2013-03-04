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
 
class FoldSpring extends VerletConstrainedSpring {
  
  int ident; //To organize the springs into groups so they can be selected and modified more easily.
  float initLen; //initialLength is stored so that adjustments to the Rest Length can be made mid-simulation.
  //Currently, [0] is a catch-all for regular springs. [1],[2],[3] and [4] are the colored springs that fake folding.

  FoldSpring(VerletParticle a, VerletParticle b, float len, float str, int ident, float initLen) {
    
    super(a, b, len, str);
    this.limit = Float.MAX_VALUE;
    this.ident = ident;
    this.initLen = initLen;
    
  }

  FoldSpring(VerletParticle a, VerletParticle b, float len, float str, float limit, int ident, float initLen) {
    
    super(a, b, len, str, limit);
    this.ident = ident;
    this.initLen = initLen;
    
  }
  
}
