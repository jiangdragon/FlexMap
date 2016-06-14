package jsoft.map.geometry
{
	public class MultiPolygon implements Geometry
	{
		private var polyArray:Array = new Array();
		
		public function MultiPolygon() {
		}
		
		public function getXArrayString():String {
			var line:Array = new Array();
			for(var i:int=0;i<polyArray.length;i++) {
				var l:Polygon=polyArray[i];
				line.push(l.getXArrayString());
			}
			return AppContext.getAppUtil().getArrayString(line,";");
		}
		
		public function getYArrayString():String {
			var line:Array = new Array();
			for(var i:int=0;i<polyArray.length;i++) {
				var l:Polygon=polyArray[i];
				line.push(l.getYArrayString());
			}
			return AppContext.getAppUtil().getArrayString(line,";");
		}
		
		public function setCenter(centerPoint:FPoint):void {
			var oldCenter:FPoint = getCenter();
			var width:Number = centerPoint.getX()-oldCenter.getX();
			var height:Number = centerPoint.getY()-oldCenter.getY();
			for(var i:int=0;i<polyArray.length;i++) {
				var poly:Polygon = polyArray[i];
				var pc:FPoint = poly.getCenter();
				pc.setXY(pc.getX()+width,pc.getY()+height);
				poly.setCenter(pc);
			}
		}
		
		public function addPoly(poly:Polygon):void {
			polyArray[polyArray.length] = poly;
		}
		
		public function getPoly(pos:int):Polygon{
			return polyArray[pos];
		}
		
		public function getPolyLength():int {
			return polyArray.length;
		}

		public function getGeometryName():String
		{
			return "MultiPolygon";
		}
		
		public function clone():Geometry
		{
			var multiPolygon:MultiPolygon = new MultiPolygon();
			for(var i:int=0;i<polyArray.length;i++) {
				multiPolygon.polyArray[i] = polyArray[i].clone();
			}
			return multiPolygon;
		}
		
		public function getBounds():Envelope
		{
			if(polyArray.length == 0) {
				return null;
			}
			var env:Envelope = null;
			for(var i:int=0;i<polyArray.length;i++) {
				var e:Envelope = polyArray[i].getBounds();
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
			var str:String = "MultiPolygon:";
			for(var i:int=0;i<polyArray.length;i++) {
				var s:String = polyArray[i].getGeometryString();
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
			var str:String = AppContext.getAppUtil().parseString(geometryString,"MultiPolygon");
			var ary:Array = AppContext.getAppUtil().getStringArray(str,";");
			polyArray = new Array();
			for(var i:int=0;i<ary.length;i++) {
				var poly:Polygon = new Polygon();
				poly.setGeometryString(ary[i]);
				polyArray[i] = poly;
			}
		}
		
		public function toString():String
		{
			var str:String = "MultiPolygon:";
			for(var i:int=0;i<polyArray.length;i++) {
				var s:String = polyArray[i].toString();
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