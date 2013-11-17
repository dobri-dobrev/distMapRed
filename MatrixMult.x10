import x10.util.Timer;
import x10.util.ArrayList;
import x10.array.Array_2;

/**
 * This is the class that provides the solve() method.
 *
 * The assignment is to replace the contents of the solve() method
 * below with code that actually works :-)
 */
public class MatrixMult
{
	public static def main(args: Rail[String]) {
		var matrix : SparseMatrix = new SparseMatrix(3, 0.05);
		var vector : VectorWithSum = new VectorWithSum(3);
		matrix.put(0, 0, 0.283333333333333);
		//matrix.put(1, 0, 0.05);
		//matrix.put(2, 0, 0.05);

		matrix.put(0, 1, 0.283333333333333);
		//matrix.put(1, 1, 0.05);
		matrix.put(2, 1, 0.85);

		matrix.put(0, 2, 0.283333333333333);
		matrix.put(1, 2, 0.85);
		//matrix.put(2, 2, 0.05);

		vector.add(0, 0.33);
		vector.add(1, 0.33);
		vector.add(2, 0.33);
		matrix.print();
		Console.OUT.println();
		val v2 = multiply(matrix, vector);

		v2.print();
	}

	public static def multiply(matrix: SparseMatrix, vector: VectorWithSum) : VectorWithSum {
	    var result: VectorWithSum = new VectorWithSum(matrix.size);
	    finish {
	        for(i in 0..(matrix.size-1)) async {
	            result.add(i, multiplyRow(matrix.getRow(i), vector, matrix.cons));
	        }
	    }
	    finish{
	        for(i in 0..(result.v.size-1)) async{
	            result.v(i) = result.get(i)/result.sum;
	        }
	    }
	    result.sum = 1;

	    return result;
	}
	public static def multiplyRow(row: ArrayList[Tuple], vector: VectorWithSum, cons: Double):Double{
	    var result:Double = 0;
	    for(var i: Long = 0; i< row.size(); i++){
	        val tup = row.get(i);
	        result+= tup.value*vector.get(tup.x);
	    }
	    result+= cons*vector.sum;
	    return result;
	}
}