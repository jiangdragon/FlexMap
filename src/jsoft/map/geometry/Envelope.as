package jsoft.map.geometry
{
	public class Envelope implements Geometry
	{
		private var minx:Number;
		private var miny:Number;
		private var maxx:Number;
		private var maxy:Number;
		
		public function Envelope()	{
		}
		public function setCenter(centerPoint:FPoint):void {
			var width:Number = (maxx - minx) / 2;
			var height:Number = (maxy - miny) / 2;
			minx = centerPoint.getX() - width;
			maxx = centerPoint.getX() + width;
			miny = centerPoint.getY() - height;
			maxy = centerPoint.getY() + height;
		}
		public function getMinx() : Number {
			return minx;
		}
		public function setMinx(minx:Number) : void {
			this.minx = minx;
		}
		public function getMiny() : Number {
			return miny;
		}
		public function setMiny(miny:Number) : void {
			this.miny = miny;
		}
		public function getMaxx() : Number {
			return maxx;
		}
		public function setMaxx(maxx:Number) : void {
			this.maxx = maxx;
		}
		public function getMaxy() : Number {
			return maxy;
		}
		public function setMaxy(maxy:Number) : void {
			this.maxy = maxy;
		}
		public function getWidth() : Number {
			return maxx - minx;
		}
		public function getHeight() : Number {
			return maxy - miny;
		}
		public function getCenterX() : Number {
			return (minx+maxx) / 2;
		}
		public function getCenterY() : Number {
			return (miny+maxy) / 2;
		}
		public function toBox() : Box {
			var box:Box = new Box();
			box.setBox(minx,miny,maxx,maxy);
			return box;
		}
		public function getEnvelope() : Envelope {
			var env:Envelope = new Envelope();
			env.minx = minx;
			env.miny = miny;
			env.maxx = maxx;
			env.maxy = maxy;
			return env;
		}
		public function setEnvelope(minx:Number,miny:Number,maxx:Number,maxy:Number) : void {
			this.minx = minx;
			this.miny = miny;
			this.maxx = maxx;
			this.maxy = maxy;
		}
		public function normalizeEnvelope() : void {
			if(minx > maxx) {
				var x:Number = minx;
				minx = maxx;
				maxx = x;
			}
			if(miny > maxy) {
				var y:Number = maxy;
				miny = maxy;
				maxy = y;
			}
		}
		public function isContain(x:Number,y:Number) : Boolean {
			if(minx <= x && x <= maxx) {
				if(miny <= y && y <= maxy) {
					return true;
				}
			}
			return false;
		}
		public function isOverlap(env:Envelope) : Boolean {
			if(minx <= env.maxx && env.minx <= maxx) {
				if(miny <= env.maxy && env.miny <= maxy) {
					return true;
				}
			}
			return false;
		}
		public function expandToInclude(x:Number,y:Number):void {
			if(x < minx) {
				minx = x;
			} else if(x > maxx) {
				maxx = x;
			}
			if(y < miny) {
				miny = y;
			} else if(y > maxy) {
				maxy = y;
			}
		}
		public function expandToIncludeBox(box:Box):void {
			expandToInclude(box.getMinx(),box.getMiny());
			expandToInclude(box.getMaxx(),box.getMaxy());
		}
		public function expandToIncludeEnv(env:Envelope):void {
			expandToInclude(env.getMinx(),env.getMiny());
			expandToInclude(env.getMaxx(),env.getMaxy());
		}
		public function getGeometryName() : String {
			return "Envelope";
		}
		public function  clone() : Geometry {
			return getEnvelope();
		}
		public function getBounds() : Envelope {
			return this;
		}
		public function getCenter() : FPoint {
			var point:FPoint = new FPoint();
			point.setX(getCenterX());
			point.setY(getCenterY());
			return point;
		}
		public function getGeometryString() : String {
			return "Envelope:"+minx+","+miny+","+maxx+","+maxy;
		}
		public function setGeometryString(geometryString:String) : void {
			var str:String = AppContext.getAppUtil().parseString(geometryString,"Envelope");
			var ary:Array = AppContext.getAppUtil().getStringArray(str,",");
			minx = AppContext.getAppUtil().getStringNumber(ary,0);
			miny = AppContext.getAppUtil().getStringNumber(ary,1);
			maxx = AppContext.getAppUtil().getStringNumber(ary,2);
			maxy = AppContext.getAppUtil().getStringNumber(ary,3);
		}
		public function setString(geometryString:String) : void {
			var ary:Array = AppContext.getAppUtil().getStringArray(geometryString,",");
			minx = AppContext.getAppUtil().getStringNumber(ary,0);
			miny = AppContext.getAppUtil().getStringNumber(ary,1);
			maxx = AppContext.getAppUtil().getStringNumber(ary,2);
			maxy = AppContext.getAppUtil().getStringNumber(ary,3);
		}
		public function toString() : String {
			return "Envelope:minx="+minx+",miny="+miny+",maxx="+maxx+",maxy="+maxy;
		}
	}
}