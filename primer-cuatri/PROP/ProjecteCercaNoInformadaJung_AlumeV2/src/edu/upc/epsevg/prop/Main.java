package edu.upc.epsevg.prop;

import edu.uci.ics.jung.algorithms.layout.Layout;
import edu.uci.ics.jung.algorithms.layout.TreeLayout;
import edu.uci.ics.jung.graph.DelegateTree;
import edu.uci.ics.jung.visualization.VisualizationViewer;
import edu.uci.ics.jung.visualization.decorators.ToStringLabeller;
import edu.uci.ics.jung.visualization.GraphZoomScrollPane;
import edu.uci.ics.jung.visualization.Layer;
import edu.uci.ics.jung.visualization.control.CrossoverScalingControl;
import edu.uci.ics.jung.visualization.control.ScalingControl;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import java.util.LinkedList;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;

/**
 *
 * @author Bernat
 */
public class Main {

    public static void main(String[] args) {
        
        // puzzle amb solució de 5 moviments
        NinePuzzle start = new NinePuzzle(new int[]{1, 2, 3,
                                                    4, 5, 0,
                                                    6, 7, 8});

        NinePuzzle goal = new NinePuzzle(new int[]{ 1, 3, 5,
                                                    4, 2, 8,
                                                    6, 7, 0});

        // puzzle amb solució de 31 moviments
        /*
        NinePuzzle start = new NinePuzzle(new int[]{    8, 6, 7, 
                                                        2, 5, 4, 
                                                        3, 0, 1}); 
        NinePuzzle goal = new NinePuzzle(new int[]{     1, 2, 3, 
                                                        4, 5, 6, 
                                                        7, 8, 0});
         */
        
        // Executem la cerca
        ResultatCerca rc = cercaNoInformadaBFS(start, goal, 32);
        // Mostra el resultat gràficament
        Visualizacio.showResultatCerca(rc);
    }

    /**
     * Implementació de BFS (Breadth-first Search) (@TODO: A implementar)
     * 
     * @param start node origen
     * @param goal node destí o solució
     * @param max_depth profunditat màxima permesa
     * @return el resultat de la cerca o null si no ha trobat resultat.
     */
    private static ResultatCerca cercaNoInformadaBFS(NinePuzzle start, NinePuzzle goal, int max_depth) {
        
        //----------------------------------- CODI D'EXEMPLE A ESBORRAR --------------------------------
        // Creació inicial del graf
        DelegateTree<NinePuzzle, Integer> g = new DelegateTree<>();
        // afegim el node arrel
        g.addVertex(start);

        // Simulem dos moviments a partir de l'inici
        NinePuzzle up = new NinePuzzle(start);
        up.move(Dir.UP);
        NinePuzzle down = new NinePuzzle(start);
        down.move(Dir.DOWN);
        // afegim els nodes (vertex) al graf. El primer nombre és l'identificador de l'aresta (edge), que ha de ser únic.
        g.addChild(1, start, up);
        g.addChild(2, start, down);

        // creem un segon nivell de moviment (a partir de down)
        NinePuzzle down_left = new NinePuzzle(down);
        down_left.move(Dir.LEFT);
        g.addChild(3, down, down_left);

       
        
        // retornem el graf construit, dient que down_left és la solució (MENTIDA!!!)
        return new ResultatCerca(g, down_left);
        
         //----------------------------------- FI CODI D'EXEMPLE A ESBORRAR --------------------------------
    }
    /**
     * Implementació de DFS (Depth-First Search) (@TODO: A implementar)
     * 
     * @param start node origen
     * @param goal node destí o solució
     * @param max_depth profunditat màxima permesa
     * @return el resultat de la cerca o null si no ha trobat resultat.
     */
    private static ResultatCerca cercaNoInformadaDFS(NinePuzzle start, NinePuzzle goal, int max_depth) {
        // @TODO: A implementar
        LinkedList<NinePuzzle> LNT = new LinkedList<>();
        LinkedList<NinePuzzle> LNO = new LinkedList<>();
        LinkedList<NinePuzzle> LF = new LinkedList<>();
        LNO.add(start);
        boolean solucio = false;
        
        while ( LNO.size() > 0 && !solucio ){
            NinePuzzle curr = LNO.getFirst();
            LNO.removeFirst();
            
            if ( !LNT.contains(curr) ){
                if ( curr == goal ) solucio=true;
                
                if ( !solucio ){
                    LNT.add(curr);
 
                }
                else{
                    solucio = true;
                }
            }
        }
        
        
        
        return null;
    }
    /**
     * Implementació de IDS (Iterative Deepening depth-first Search) (@TODO: A implementar)
     * 
     * @param start node origen
     * @param goal node destí o solució
     * @param max_depth profunditat màxima permesa
     * @return el resultat de la cerca o null si no ha trobat resultat.
     */
    private static ResultatCerca cercaNoInformadaIDS(NinePuzzle start, NinePuzzle goal, int max_depth) {
       // @TODO: A implementar
        return null;
    }
 

    
    

}
