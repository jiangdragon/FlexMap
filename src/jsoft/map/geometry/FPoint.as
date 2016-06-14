package jsoft.map.geometry
{
	public class FPoint implements Geometry
	{
		private var _x:Number;
		private var _y:Number;
		
		public function FPoint()
		{
		}
		public function setCenter(centerPoint:FPoint):void {
			_x = centerPoint.getX();
			_y = centerPoint.getY();
		}
		
		public function get x():Number {
			return _x;
		}
		
		public function set x(x:Number):void {
			this._x = x;
		}
		
		public function get y():Number {
			return _y;
		}
		
		public function set y(y:Number):void {
			this._y = y;
		}
		
		public function getX():Number
		{
			return _x;
		}
		
		public function setX(x:Number):void
		{
			this._x = x;
		}
		
		public function getY():Number
		{
			return _y;
		}
		
		public function setY(y:Number):void
		{
			this._y = y;
		}
		
		public function setXY(x:Number,y:Number):void
		{
			this._x = x;
			this._y = y;
		}

		public function getGeometryName():String
		{
			return "Point";
		}
		
		public function clone() : Geometry
		{
			var point:FPoint = new FPoint();
			point._x = x;
			point._y = y;
			return point;
		}
		
		public function getBounds():Envelope
		{
			var env:Envelope = new Envelope();
			env.setEnvelope(_x,_y,_x,_y);
			return env;
		}
		
		public function getCenter() : FPoint
		{
			var point:FPoint = new FPoint();
			point._x = x;
			point._y = y;
			return point;
		}
		
		public function getGeometryString():String
		{
			return "Point:"+_x+","+_y;
		}
		
		public function setGeometryString(geometryString:String):void
		{
			var str:String = AppContext.getAppUtil().parseString(geometryString,"Point");
			var ary:Array = AppContext.getAppUtil().getStringArray(str,",");
			_x = AppContext.getAppUtil().getStringNumber(ary,0);
			_y = AppContext.getAppUtil().getStringNumber(ary,1);
		}
		
		public function toString():String
		{
			return "Point:x="+_x+",y="+_y;
		}
		
	}
}