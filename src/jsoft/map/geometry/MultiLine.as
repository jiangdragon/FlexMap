package jsoft.map.geometry
{
	public class MultiLine implements Geometry
	{
		private var lineArray:Array = new Array();
		
		public function MultiLine() {
		}
		
		public function getXArrayString():String {
			var line:Array = new Array();
			for(var i:int=0;i<lineArray.length;i++) {
				var l:Line=lineArray[i];
				line.push(l.getXArrayString());
			}
			return AppContext.getAppUtil().getArrayString(line,";");
		}
		
		public function getYArrayString():String {
			var line:Array = new Array();
			for(var i:int=0;i<lineArray.length;i++) {
				var l:Line=lineArray[i];
				line.push(l.getYArrayString());
			}
			return AppContext.getAppUtil().getArrayString(line,";");
		}
		
		public function setCenter(centerPoint:FPoint):void {
			var oldCenter:FPoint = getCenter();
			var width:Number = centerPoint.getX()-oldCenter.getX();
			var height:Number = centerPoint.getY()-oldCenter.getY();
			for(var i:int=0;i<lineArray.length;i++) {
				var line:Line = lineArray[i];
				var pc:FPoint = line.getCenter();
				pc.setXY(pc.getX()+width,pc.getY()+height);
				line.setCenter(pc);
			}
		}
		
		public function addLine(line:Line):void {
			lineArray[lineArray.length] = line;
		}
		
		public function getLine(pos:int):Line{
			return lineArray[pos];
		}
		
		public function getLineLength():int {
			return lineArray.length;
		}

		public function getGeometryName():String
		{
			return "MultiLine";
		}
		
		public function clone():Geometry
		{
			var multiLine:MultiLine = new MultiLine();
			for(var i:int=0;i<lineArray.length;i++) {
				multiLine.lineArray[i] = lineArray[i].clone();
			}
			return multiLine;
		}
		
		public function getBounds():Envelope
		{
			if(lineArray.length == 0) {
				return null;
			}
			var env:Envelope = null;
			for(var i:int=0;i<lineArray.length;i++) {
				var e:Envelope = lineArray[i].getBounds();
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
			var str:String = "MultiLine:";
			for(var i:int=0;i<lineArray.length;i++) {
				var s:String = lineArray[i].getGeometryString();
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
			var str:String = AppContext.getAppUtil().parseString(geometryString,"MultiLine");
			var ary:Array = AppContext.getAppUtil().getStringArray(str,";");
			lineArray = new Array();
			for(var i:int=0;i<ary.length;i++) {
				var line:Line = new Line();
				line.setGeometryString(ary[i]);
				lineArray[i] = line;
			}
		}
		
		public function toString():String
		{
			var str:String = "MultiLine:";
			for(var i:int=0;i<lineArray.length;i++) {
				var s:String = lineArray[i].toString();
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