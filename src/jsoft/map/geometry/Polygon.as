package jsoft.map.geometry
{
	public class Polygon implements Geometry
	{
		private var x:Array = new Array();
		private var y:Array = new Array();
		
		public function Polygon()
		{
		}
		
		public function getXArrayString():String {
			return AppContext.getAppUtil().getArrayString(x);
		}
		
		public function getYArrayString():String {
			return AppContext.getAppUtil().getArrayString(y);
		}
		
		public function setCenter(centerPoint:FPoint):void {
			var oldCenter:FPoint = getCenter();
			var width:Number = centerPoint.getX()-oldCenter.getX();
			var height:Number = centerPoint.getY()-oldCenter.getY();
			for(var i:int=0;i<x.length;i++) {
				x[i] += width;
				y[i] += height;
			}
		}
		
		public function addPoint(x:Number,y:Number):void {
			this.x[this.x.length] = x;
			this.y[this.y.length] = y;
		}
		
		public function addPointEx(point:FPoint):void {
			this.x[this.x.length] = point.getX();
			this.y[this.y.length] = point.getY();
		}
		
		public function insertPoint(pos:int,x:Number,y:Number):void {
			if(this.x.length<=pos) {
				addPoint(x,y);
				return;
			}
			var tx:Number=x;
			var ty:Number=y;
			for(var i:int=pos;i<this.x.length;i++) {
				tx=this.x[i];
				ty=this.y[i];
				this.x[i]=x;
				this.y[i]=y;
				x=tx;
				y=ty;
			}
			this.x[this.x.length] = x;
			this.y[this.y.length] = y;
		}
		
		public function setPoint(pos:int,x:Number,y:Number):void {
			if(this.x.length<=pos) {
				addPoint(x,y);
			} else {
				this.x[pos] = x;
				this.y[pos] = y;
			}
		}
		
		public function setPointX(pos:int,x:Number):void {
			if(this.x.length>pos) {
				this.x[pos] = x;
			}
		}
		
		public function setPointY(pos:int,y:Number):void {
			if(this.x.length>pos) {
				this.y[pos] = y;
			}
		}
		
		public function getPoint(pos:int):FPoint{
			var point:FPoint = new FPoint();
			point.setX(x[pos]);
			point.setY(y[pos]);
			return point;
		}
		
		public function removePoint(pos:int):void {
			if(x.length<=4) {
				return;
			}
			var nx:Array=new Array();
			var ny:Array=new Array();
			for(var i:int=0;i<x.length;i++) {
				if(i!=pos) {
					nx[nx.length]=x[i];
					ny[ny.length]=y[i];
				}
			}
			x=nx;
			y=ny;
		}
		
		public function getXArray():Array {
			return x;
		}
		
		public function setXArray(_x:Array):void {
			x = _x;
		}
		
		public function getYArray():Array {
			return y;
		}
		
		public function setYArray(_y:Array):void {
			y = _y;
		}
		
		public function getPointLength():int {
			return x.length;
		}

		public function getGeometryName():String
		{
			return "Polygon";
		}
		
		public function clone():Geometry
		{
			var polygon:Polygon = new Polygon();
			for(var i:int=0;i<x.length;i++) {
				polygon.x[i] = x[i];
				polygon.y[i] = y[i];
			}
			return polygon;
		}
		
		public function getBounds():Envelope
		{
			if(x.length == 0) {
				return null;
			}
			var env:Envelope = new Envelope();
			env.setEnvelope(x[0],y[0],x[0],y[0]);
			for(var i:int=1;i<x.length;i++) {
				env.expandToInclude(x[i],y[i]);
			}
			return env;
		}
		
		public function getCenter() : FPoint
		{
			var bounds:Envelope = getBounds();
			if(bounds != null) {
				return bounds.getCenter();
			}
			return null;
		}
		
		public function getGeometryString():String
		{
			var str:String = "Polygon:";
			for(var i:int=0;i<x.length;i++) {
				if(i>0) {
					str += ",";
				}
				str += x[i]+","+y[i];
			}
			return str;
		}
		
		public function setGeometryString(geometryString:String):void
		{
			var str:String = AppContext.getAppUtil().parseString(geometryString,"Polygon");
			var ary:Array = AppContext.getAppUtil().getStringArray(str,",");
			x = new Array();
			y = new Array();
			for(var i:int=0;i+1<ary.length;i+=2) {
				x[x.length]=AppContext.getAppUtil().getStringNumber(ary,i);
				y[y.length]=AppContext.getAppUtil().getStringNumber(ary,i+1);
			}
		}
		
		public function toString():String
		{
			var str:String = "Polygon:";
			for(var i:int=0;i<x.length;i++) {
				if(i>0) {
					str += ",";
				}
				str += "x["+i+"]="+x[i]+",y["+i+"]="+y[i];
			}
			return str;
		}
		
	}
}