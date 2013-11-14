import x10.lang.Rail;

public class VectorWithSum{
	public var v:Rail[Double];
	public var sum: Double;

	public def this(s: Long){
		v = new Rail[Double](s);
		sum = 0;
	}

	public def defaultVals(){
		v.fill(1/v.size);
		sum = 1;
	}

	public def add(x:Long, value: Double){
		v(x) = value;
		sum+= value;
	}
	public def get(x:Long):Double{
		return v(x);
	}
}