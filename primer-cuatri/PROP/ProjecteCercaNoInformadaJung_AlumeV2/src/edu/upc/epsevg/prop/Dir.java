package edu.upc.epsevg.prop;

/**
 * Aquesta enumeració representa les possibles direccions de moviment de nine-puzzle
 * @author Usuari
 */
public enum Dir {
    UP(-1,0), DOWN(1,0), RIGHT(0,1), LEFT(0,-1);
    public int df,dc;
    /**
     * el constructor admet el desplaçament que implica el moviment en files i columnes
     * @param f offset de files
     * @param c  offset de columnes
     */
    Dir(int f, int c ) {
        this.df = f;
        this.dc = c;
    }
}
