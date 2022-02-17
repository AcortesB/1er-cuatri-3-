package edu.upc.epsevg.prop;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * Classe per a representar l'estat d'un problema NinePuzzle, internament emmagatzemat per una matriu 3x3 de sencers. 
 * El valor buit s'emmagatzema com a EMPTY (0)
 * 
 * @author Bernat
 */
public class NinePuzzle {
    
    private static int nextId = 0;
    //--------------------------------------
    private int id;
    private int depth = 0;
    private static final int N = 3;    
    private int emptyF, emptyC;
    private int[][] puzzle;
    /**
     * Useu aquesta funció per resetejar la generació automàtica d'identificadors.
     * És útil quan voleu que els identificadors dels NinePuzzle creats comencin de nou a partir de 2.
     */
    public static void resetIds() {
        nextId = 2;
    }

    /**
     * Valor de la casella buida
     */
    public static final int EMPTY = 0;
    private boolean esSolucio =false;
    
    /**
     * @return Retorna l'identificador del puzzle (autogenerat)
     */
    public int getId() {
        return id;
    }

    /**
     * @return la profunditat del puzzle a l'arbre d'exploració.
     */
    public int getDepth() {
        return depth;
    }

    /**
     * Inicialitza el nine puzzle a partir d'un array d'enters. 
     *
     * @param positions un array de 9 posicions que ha de contenir xifres de 1 al 8. El zero (EMPTY) es pren com a posició en blanc.
     */
    public NinePuzzle(int[] positions) {
        this.id = ++nextId;
        puzzle = new int[N][N];
        if (positions.length != N * N) {
            throw new RuntimeException("Mida de puzzle incorrecta");
        }
        for (int i = 0; i < positions.length; i++) {
            puzzle[i / N][i % N] = positions[i];           
            if(positions[i]==EMPTY) {
                emptyF = i / N;
                emptyC = i % N;
            } else if (positions[i] < 1 || positions[i] > 8) {
                throw new RuntimeException("Número no admés");    
            }
        }
    }

    /**
     * Constructor còpia: clona un ninepuzzle ja existent (amb un identificador
     * nou!). Duplica tota la matriu d'estat i AUGMENTA la profunditat 1 nivell.
     *
     * @param other és el puzzle a copiar
     */
    public NinePuzzle(NinePuzzle other) {
        this.id = ++nextId;
        puzzle = new int[N][N];
        emptyF = other.emptyF;
        emptyC = other.emptyC;
        depth = other.depth + 1;
        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {
                puzzle[i][j] = other.puzzle[i][j];
            }
        }
    }

    /**
     * Retorna la llista de direccions en les que es pot moure la posició en blanc.
     * @return 
     */
    public List<Dir> validMoves() {
        ArrayList<Dir> moves = new ArrayList<>();
        for (Dir d : Dir.values()) {
            if (checkPos(emptyF + d.df, emptyC + d.dc)) {
                moves.add(d);
            }
        }
        return moves;
    }

    /**
     * Verifica si el nostre estat de tauler és igual que el que ens passen per paràmetre
     * @param unaAltraConfiguracio és l'altre estat amb el que ens compararem
     * @return cert si el puzzle actual és igual a la solució
     */
    public boolean comparaEstat(NinePuzzle unaAltraConfiguracio) {

        for (int i = 0; i < N; i++) {
            for (int j = 0; j < N; j++) {   
                if (puzzle[i][j] != unaAltraConfiguracio.puzzle[i][j]) {
                    return false;
                }
            }
        }
        return true;
    }    
    
    
    /**
     * Moure la posició en blanc del nine-puzzle en una direcció concreta.
     * @param d la direcció de moviment
     * @throws llança una RuntimeException si es demana un moviment no admés.
     */
    public void move(Dir d) {
        move(emptyF, emptyC, d);
    }

    private void move(int f, int c, Dir d) {
        if (!checkPos(f + d.df, c + d.dc)) {
            throw new RuntimeException("Posició incorrecta" + (f + d.df) + "," + (c + d.dc));
        }
        swap(f, c, f + d.df, c + d.dc);
        emptyF = f + d.df;
        emptyC = c + d.dc;
    }

    private void swap(int f1, int c1, int f2, int c2) {
        int tmp = puzzle[f1][c1];
        puzzle[f1][c1] = puzzle[f2][c2];
        puzzle[f2][c2] = tmp;
    }

    private boolean checkPos(int f, int c) {
        return (f >= 0 && c >= 0 && f < N && c < N);
    }



    @Override
    public String toString() {
               
        String s = "<html> \n";
        s += "id=" + id + "<br/>\n";
        s += "<table border=\"1\" cellspacing=\"0\" "+ (!esSolucio?"":" bgcolor=\"#77ffff\"")+ ">\n";
       
        for (int i = 0; i < N; i++) {
            s +="<tr height=\"4\">";
            for (int j = 0; j < N; j++) {
                s += "<td>"+ (puzzle[i][j]>0?puzzle[i][j]:" ") + "</td>";
            }
            s += "</tr><br/>\n";
        }
        s += "</table></html>";
        return s;
    }

    @Override
    public int hashCode() {
        int hash = 7;
        hash = 89 * hash + this.id;
        return hash;
    }

    /**
     * La comparació dels puzzles es fa estrictament per identificador
     * @param obj
     * @return 
     */
    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        final NinePuzzle other = (NinePuzzle) obj;
        if (this.id != other.id) {
            return false;
        }
        return true;
    }

    public NinePuzzle clone() {
        return new NinePuzzle(this);
    }

    void marcaComASolucio() {
        esSolucio = true;
    }
}
