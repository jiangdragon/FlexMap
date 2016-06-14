package jsoft.map.geometry
{
	public class Circle implements Geometry
	{
		private var cx:Number;
		private var cy:Number;
		private var radius:Number;
		
		public function Circle()
		{
		}
		public function setCenter(centerPoint:FPoint):void {
			cx = centerPoint.getX();
			cy = centerPoint.getY();
		}
		
		public function getCenterX():Number
		{
			return cx;
		}
		
		public function setCenterX(cx:Number):void
		{
			this.cx = cx;
		}
		
		public function getCenterY():Number
		{
			return cy;
		}
		
		public function setCenterY(cy:Number):void
		{
			this.cy = cy;
		}
		
		public function getRadius():Number
		{
			return radius;
		}
		
		public function setRadius(radius:Number):void
		{
			this.radius = radius;
		}

		public function getGeometryName():String
		{
			return "Circle";
		}
		
		public function clone():Geometry
		{
			var circle:Circle = new Circle();
			circle.cx = cx;
			circle.cy = cy;
			circle.radius = radius;
			return circle;
		}
		
		public function getBounds():Envelope
		{
			var env:Envelope = new Envelope();
			env.setEnvelope(cx-radius,cy-radius,cx+radius,cy+radius);
			env.normalizeEnvelope();
			return env;
		}
		
		public function getCenter() : FPoint
		{
			var point:FPoint = new FPoint();
			point.setX(cx);
			point.setY(cy);
			return point;
		}
		
		public function getGeometryString():String
		{
			return "Circle:"+cx+","+cy+","+radius;
		}
		
		public function setGeometryString(geometryString:String):void
		{
			var str:String = AppContext.getAppUtil().parseString(geometryString,"Circle");
			var ary:Array = AppContext.getAppUtil().getStringArray(str,",");
			cx = AppContext.getAppUtil().getStringNumber(ary,0);
			cy = AppContext.getAppUtil().getStringNumber(ary,1);
			radius = AppContext.getAppUtil().getStringNumber(ary,2);
		}
		
		public function toString():String
		{
			return "Circle:cx="+cx+",cy="+cy+",radius="+radius;
		}
		
	}
}