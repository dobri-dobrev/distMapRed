import x10.util.Timer;
import x10.util.ArrayList;
import x10.array.Array_2;

/**
 * This is the class that provides the solve() method.
 *
 * The assignment is to replace the contents of the solve() method
 * below with code that actually works :-)
 */
public class Solver
{
    	/**
	* solve(webGraph: Rail[WebNode], dampingFactor: double,epsilon:Double)
	* 
     	* Returns an approximation of the page rank of the given web graph
     	*/

        var matrix : Array_2[Double];
        var n : Long;
    	public def solve(webGraph: Rail[WebNode], dampingFactor: Double, epsilon:Double) : Rail[Double] {
    		n = webGraph.size;
    		var solutions:Rail[Double] = new Rail[Double](webGraph.size, (i:Long)=>1.0/webGraph.size);
            for(var i : Long = 0; i < webGraph.size; i++)
                Console.OUT.println(webGraph(i));
            matrix = readInMatrix(webGraph, dampingFactor);
            printMatrix();
            
        	return solutions;
    	}

        public def readInMatrix(webGraph: Rail[WebNode], dampingFactor: Double) : Array_2[Double] {
            val x = (1.0 - dampingFactor)/webGraph.size;
            var temp : Array_2[Double] = new Array_2[Double](webGraph.size, webGraph.size);
            for(var i : Long = 0; i < webGraph.size; i++) {
                for(var j : Long = 0; j < webGraph(i).links.size(); j++) {
                    temp(webGraph(i).links(j).id - 1, i) += dampingFactor / webGraph(i).links.size() + x;
                }
            }
            return temp;
        }

        public def printMatrix() {
            for(var i : Long = 0; i < n; i++) {
                for(var j : Long = 0; j < n; j++) {
                    Console.OUT.printf("%.3f\t", matrix(i, j));
                }
                Console.OUT.println();
            }
        }
}