
package edu.upc.epsevg.prop;

import edu.uci.ics.jung.graph.DelegateTree;

/**
 * El resultat del la cerca és el node que ha conduit a la solució
 * així com el graf que ens ha de permetre reconstruir els passos
 * fins a l'inici.
 * @author Usuari
 */
public class ResultatCerca {

    private DelegateTree<NinePuzzle, Integer> graph;
    private NinePuzzle solucio;

    /**
     * Construir un resultat de cerca a partir del graf i el node solució
     * @param graph arbre d'exploració que ha trobat la sol·lució
     * @param solucio és el node sol·lució dins del graf anterior
     */
    public ResultatCerca(DelegateTree<NinePuzzle, Integer> graph, NinePuzzle solucio) {
        this.graph = graph;
        this.solucio = solucio;
    }

    public DelegateTree<NinePuzzle, Integer> getGraph() {
        return graph;
    }

    public NinePuzzle getSolucio() {
        return solucio;
    }
    
}
