/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package edu.upc.epsevg.prop;

import edu.uci.ics.jung.algorithms.layout.Layout;
import edu.uci.ics.jung.algorithms.layout.TreeLayout;
import edu.uci.ics.jung.graph.DelegateTree;
import edu.uci.ics.jung.visualization.GraphZoomScrollPane;
import edu.uci.ics.jung.visualization.Layer;
import edu.uci.ics.jung.visualization.VisualizationViewer;
import edu.uci.ics.jung.visualization.control.CrossoverScalingControl;
import edu.uci.ics.jung.visualization.control.ScalingControl;
import edu.uci.ics.jung.visualization.decorators.ToStringLabeller;
import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.ArrayList;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JPanel;

/**
 *
 * @author bernat
 */
public class Visualizacio {
    
    private static void showGraph(DelegateTree<NinePuzzle, Integer> g) {

        Layout<Integer, String> layout = new TreeLayout(g, 70, 120);
        // layout.setSize(new Dimension(300,300)); // sets the initial size of the space     // The BasicVisualizationServer<V,E> is parameterized by the edge types     
        VisualizationViewer<Integer, String> vv = new VisualizationViewer<Integer, String>(layout, new Dimension(500, 400));
        //vv.setPreferredSize(); //Sets the viewing area size    
        vv.getRenderContext().setEdgeLabelTransformer(new ToStringLabeller());
        vv.getRenderContext().setVertexLabelTransformer(new ToStringLabeller());

        JFrame frame = new JFrame("Simple Graph View");
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        final GraphZoomScrollPane scrollPane = new GraphZoomScrollPane(vv);
        //JScrollPane scrollPane = new JScrollPane(vv);
        frame.getContentPane().add(scrollPane);

        final ScalingControl scaler = new CrossoverScalingControl();

        JButton plus = new JButton("+");
        plus.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                scaler.scale(vv, 1.1f, vv.getCenter());
            }
        });
        JButton minus = new JButton("-");
        minus.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                scaler.scale(vv, 1 / 1.1f, vv.getCenter());
            }
        });

        JButton reset = new JButton("reset");
        reset.addActionListener(new ActionListener() {

            public void actionPerformed(ActionEvent e) {
                vv.getRenderContext().getMultiLayerTransformer().getTransformer(Layer.LAYOUT).setToIdentity();
                vv.getRenderContext().getMultiLayerTransformer().getTransformer(Layer.VIEW).setToIdentity();
            }
        });

        JPanel controls = new JPanel();
        controls.add(plus);
        controls.add(minus);
        controls.add(reset);
        frame.getContentPane().add(controls, BorderLayout.SOUTH);

        frame.pack();
        frame.setVisible(true);
    }
    
    
    
    public static void showResultatCerca(ResultatCerca rc) {
        if (rc == null) {
            System.out.println("Sense solució.");
        } else {

            // Fem un recorregut de la fulla solució fins l'arrel de l'arbre, i anem desant els nodes a una pila.
            // La solució surt de desenpilar els nodes.
            System.out.println("====================");
            System.out.println("  Solution");
            System.out.println("====================");
            NinePuzzle v = rc.getSolucio();
            ArrayList<NinePuzzle> nodesSolucio = new ArrayList<>();

            while (v != null) {
                nodesSolucio.add(0, v);
                v.marcaComASolucio();
                v = rc.getGraph().getParent(v);
            }
            System.out.println("Mida: " + nodesSolucio.size());
            int i = 0;
            for (NinePuzzle np : nodesSolucio) {
                System.out.println("(" + (i++) + ")" + np.getId());
            }

            // Dibuixem el graf
            showGraph(rc.getGraph());
        }
    }
}
