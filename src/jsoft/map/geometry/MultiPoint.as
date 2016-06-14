package jsoft.map.geometry
{
	public class MultiPoint implements Geometry
	{
		private var pointArray:Array = new Array();
		
		public function MultiPoint() {
		}
		public function setCenter(centerPoint:FPoint):void {
			var oldCenter:FPoint = getCenter();
			var width:Number = centerPoint.getX()-oldCenter.getX();
			var height:Number = centerPoint.getY()-oldCenter.getY();
			for(var i:int=0;i<pointArray.length;i++) {
				var point:FPoint = pointArray[i];
				point.setXY(point.getX()+width,point.getY()+height);
			}
		}
		
		public function getXArray():String {
			var ret:String = "";
			for(var i:int=0;i<pointArray.length;i++) {
				var point:FPoint = pointArray[i];
				if(i > 0) {
					ret += "," + point.getX();
				} else {
					ret += point.getX();
				}
			}
			return ret;
		}
		
		public function getYArray():String {
			var ret:String = "";
			for(var i:int=0;i<pointArray.length;i++) {
				var point:FPoint = pointArray[i];
				if(i > 0) {
					ret += "," + point.getY();
				} else {
					ret += point.getY();
				}
			}
			return ret;
		}
		
		public function addPoint(x:Number,y:Number):void {
			var point:FPoint = new FPoint();
			point.setX(x);
			point.setY(y);
			pointArray[pointArray.length] = point;
		}
		
		public function addPointEx(point:FPoint):void {
			pointArray[pointArray.length] = point;
		}
		
		public function getPoint(pos:int):FPoint{
			return pointArray[pos];
		}
		
		public function getPointLength():int {
			return pointArray.length;
		}

		public function getGeometryName():String
		{
			return "MultiPoint";
		}
		
		public function clone():Geometry
		{
			var multiPoint:MultiPoint = new MultiPoint();
			for(var i:int=0;i<pointArray.length;i++) {
				multiPoint.pointArray[i] = pointArray[i];
			}
			return multiPoint;
		}
		
		public function getBounds():Envelope
		{
			if(pointArray.length == 0) {
				return null;
			}
			var env:Envelope = null;
			for(var i:int=0;i<pointArray.length;i++) {
				var e:Envelope = pointArray[i].getBounds();
				if(env == null) {
					env = e;
				} else if(e != null) {
					env.expandToIncludeEnv(e);
				}
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
			var str:String = "MultiPoint:";
			for(var i:int=0;i<pointArray.length;i++) {
				var s:String = pointArray[i].getGeometryString();
				if(i>0) {
					str += ";" + s;
				} else {
					str += s;
				}
			}
			return str;
		}
		
		public function setGeometryString(geometryString:String):void
		{
			var str:String = AppContext.getAppUtil().parseString(geometryString,"MultiPoint");
			var ary:Array = AppContext.getAppUtil().getStringArray(str,";");
			pointArray = new Array();
			for(var i:int=0;i<ary.length;i++) {
				var point:FPoint = new FPoint();
				point.setGeometryString(ary[i]);
				pointArray[i] = point;
			}
		}
		
		public function toString():String
		{
			var str:String = "MultiPoint:";
			for(var i:int=0;i<pointArray.length;i++) {
				var s:String = pointArray[i].toString();
				if(i>0) {
					str += ";" + s;
				} else {
					str += s;
				}
			}
			return str;
		}
		
	}
}