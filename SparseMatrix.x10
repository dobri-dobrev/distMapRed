
import x10.util.ArrayList;

public class SparseMatrix
{
	public var matrix: Rail[ArrayList[Tuple]];
	public var cons: Double;
	public var size: Long;

	public def this(s: Long, constant: Double){
		matrix = new Rail[ArrayList[Tuple]](s);
		cons = constant;
		size = s;
		for(var i: Long = 0; i<matrix.size; i++){
			matrix(i) = new ArrayList[Tuple]();
		}
	}

	public atomic def getRow(x:Long): ArrayList[Tuple]{
		return matrix(x);
	}

	public atomic def put(x: Long, y: Long, value: Double){
		matrix(y).add(new Tuple(x, value));
	} 

	public def print(){
		for(var i:Long = 0; i<size; i++){
			var strTemp: String = "";
			for(var j:Long = 0; j<size; j++){
				val t = find(j,i);
				if(t == -1.0){
					Console.OUT.printf("%.3f\t", cons);
				}
				else{
					Console.OUT.printf("%.3f\t", t+cons);
				}
			}
			Console.OUT.println();
		}
	}
	public def find(x: Long, y:Long):Double{
		var out: Double = -1;
		val t = getRow(y);
		for(var i:Long = 0; i<t.size(); i++){
			if(t.get(i).x== x)
				out = t.get(i).value;
		}
		return out;
	}
}