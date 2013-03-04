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
