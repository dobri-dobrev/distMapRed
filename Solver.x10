import x10.util.Timer;
import x10.util.ArrayList;
import x10.array.Array_2;
import x10.lang.Runtime;

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

        var n : Long;
    	public def solve(webGraph: Rail[WebNode], dampingFactor: Double, epsilon:Double) : Rail[Double] {
    		Console.OUT.println("called");
            n = webGraph.size;
    		var solutions:Rail[Double] = new Rail[Double](webGraph.size, (i:Long)=>1.0/webGraph.size);
            // for(var i : Long = 0; i < webGraph.size; i++)
            //     Console.OUT.println(webGraph(i));
            val matrix = readInMatrix(webGraph, dampingFactor);
            var v1: VectorWithSum = new VectorWithSum(matrix.size);
            v1.defaultVals();
            //v1.print();
            //Console.OUT.println();
            //matrix.print();
            //Console.OUT.println();
            var v2: VectorWithSum = multiply(matrix, v1);
            //v2.print();
            
            var count:Long = 0;
            while(difference(v1,v2)>epsilon){
            //while(count<10){
                count+=1;
                v1 = v2;
                v2 = multiply(matrix, v1);
            }
            
            //Console.OUT.println("number of iterations "+count);
            //v2.print();
            //matrix.print();
        	//v2.print();
            return v2.v;
            //return new Rail[Double](3);
    	}

        public def readInMatrix(webGraph: Rail[WebNode], dampingFactor: Double) : SparseMatrix {
            val x = (1.0 - dampingFactor)/webGraph.size;
            val y = dampingFactor/webGraph.size;
            //Console.OUT.println("X IS "+x);
            var temp : SparseMatrix = new SparseMatrix(n, x);
            //Console.OUT.println("Start read");           
           finish {
            
                for(i in 0..(webGraph.size - 1)) async{
                     
                        if(webGraph(i).links.size()==0){
                            for(var j: Long = 0; j<webGraph.size; j++){
                                temp.put(i, j, y);
                                //Console.OUT.println(y);
                            }
                        }
                        else{
                            for(var j : Long = 0; j < webGraph(i).links.size(); j++) {                        
                               temp.put(i, webGraph(i).links(j).id - 1, dampingFactor / webGraph(i).links.size() );
                               //Console.OUT.println(dampingFactor / webGraph(i).links.size());
                            }    
                        }
                }
           
            } 
            //Console.OUT.println("End read");
            return temp;
        }

        public def multiply(matrix: SparseMatrix, vector: VectorWithSum) : VectorWithSum {
                var result: VectorWithSum = new VectorWithSum(matrix.size);
                val piece = matrix.size/x10.lang.Runtime.NTHREADS + 1;
                val pieceSizeForLast = matrix.size- (x10.lang.Runtime.NTHREADS-1) * piece ;
                finish{
                    for(i in 0..(x10.lang.Runtime.NTHREADS-1)) async{
                        //atomic{
                        //Console.OUT.println("piece is "+piece+" matrix size is "+ matrix.size+" start is "+piece*i+ " end is "+ (piece*i+ piece));
                        if(i == x10.lang.Runtime.NTHREADS-1) {
                            var resPiece: Rail[Double] = multiplyPiece(piece*i, pieceSizeForLast, matrix, vector);
                            var count: Long = 0;
                            for(var j:Long = piece*i; j<(piece*i+pieceSizeForLast); j++){
                                result.add(j, resPiece(count));
                                count+=1;
                            }
                        }
                        else {
                            var resPiece: Rail[Double] = multiplyPiece(piece*i, piece, matrix, vector);
                            var count: Long = 0;
                            for(var j:Long = piece*i; j<(piece*i+piece); j++){
                                result.add(j, resPiece(count));
                                count+=1;
                            }
                        }
                        //}
                        
                    }
                }
                //Console.OUT.println("End multiply");
                //Console.OUT.println("Start normalize");
                finish{
                    for(i in 0..(result.v.size-1))  {
                        atomic result.v(i) = result.get(i)/result.sum;
                    }
                }
                //Console.OUT.println("end normalize");
                result.sum = 1;

                return result;
        }
        public def multiplyPiece(start: Long, pieceSize: Long, matrix: SparseMatrix, vector: VectorWithSum ): Rail[Double]{
            var out: Rail[Double] = new Rail[Double](pieceSize);
            for(var i:Long = 0; i< pieceSize; i++){
                out(i) = multiplyRow(matrix, i+start, vector, matrix.cons);
            }
            return out;
        }

        public def multiplyRow(matrix: SparseMatrix, p:Long, vector: VectorWithSum, cons: Double):Double{
            //Console.OUT.println("Start get");
           
           finish{
                val row = matrix.getRow(p);
                //Console.OUT.println("end get");
                var result:Double = 0;
                for(var i: Long = 0; i< row.size(); i++){
                    val tup = row.get(i);
                    result += tup.value * vector.get(tup.x);
                }
                result += cons * vector.sum;
                return result;
          } 
            
        }
        public def difference(v1:VectorWithSum, v2:VectorWithSum):Double{
            var deltaSquared:Double = 0;
            for(var i:Int = 0n; i<v1.v.size; i++) {
                deltaSquared += Math.abs(v1.get(i)-v2.get(i));
            }
            //v1.print();
            //v2.print();
            
            //Console.OUT.println("difference is "+deltaSquared);
            return(deltaSquared);
        }

}
