package jsoft.map.geometry
{
	public class Box implements Geometry
	{
		private var minx:Number;
		private var miny:Number;
		private var maxx:Number;
		private var maxy:Number;
		
		public function Box()	{
		}
		public function setCenter(centerPoint:FPoint):void {
			var width:Number = (maxx - minx) / 2;
			var height:Number = (maxy - miny) / 2;
			minx = centerPoint.getX() - width;
			maxx = centerPoint.getX() + width;
			miny = centerPoint.getY() - height;
			maxy = centerPoint.getY() + height;
		}
		public function centerAt(cx:Number,cy:Number):void {
			var width:Number = (maxx - minx) / 2;
			var height:Number = (maxy - miny) / 2;
			minx = cx - width;
			maxx = cx + width;
			miny = cy - height;
			maxy = cy + height;
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
		public function toEnvelope() : Envelope {
			var env:Envelope = new Envelope();
			env.setEnvelope(minx,miny,maxx,maxy);
			return env;
		}
		public function getBox() : Box {
			var box:Box = new Box();
			box.minx = minx;
			box.miny = miny;
			box.maxx = maxx;
			box.maxy = maxy;
			return box;
		}
		public function setBox(minx:Number,miny:Number,maxx:Number,maxy:Number) : void {
			this.minx = minx;
			this.miny = miny;
			this.maxx = maxx;
			this.maxy = maxy;
		}
		public function normalizeBox() : void {
			if(minx > maxx) {
				var x:Number = minx;
				minx = maxx;
				maxx = x;
			}
			if(miny > maxy) {
				var y:Number = miny;
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
		public function isEqual(box:Box) : Boolean {
			if(box.minx==minx&&box.maxx==maxx) {
				if(box.miny==miny&&box.maxy==maxy) {
					return true;
				}
			}
			return false;
		}
		public function isXLink(box:Box) : Boolean {
			if(box.minx==maxx||box.maxx==minx) {
				return true;
			}
			return false;
		}
		public function isYLink(box:Box) : Boolean {
			if(box.miny==maxy||box.maxy==miny) {
				return true;
			}
			return false;
		}
		public function getXGap(box:Box) : Number {
			var gap1:Number=Math.abs(maxx-box.maxx);
			var gap2:Number=Math.abs(minx-box.minx);
			return gap1>gap2?gap1:gap2;
		}
		public function getYGap(box:Box) : Number {
			var gap1:Number=Math.abs(maxy-box.maxy);
			var gap2:Number=Math.abs(miny-box.miny);
			return gap1>gap2?gap1:gap2;
		}
		public function isOverlap(box:Box) : Boolean {
			if(minx <= box.maxx && box.minx <= maxx) {
				if(miny <= box.maxy && box.miny <= maxy) {
					return true;
				}
			}
			return false;
		}
		public function isOverlapBox(x1:Number,y1:Number,x2:Number,y2:Number) : Boolean {
			var box:Box=new Box();
			box.setBox(x1,y1,x2,y2);
			box.normalizeBox();
			return isOverlap(box);
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
		public function buffer(size:Number):void {
			minx-=size;
			miny-=size;
			maxx+=size;
			maxy+=size;
		}
		public function expandToIncludeBox(box:Box):void {
			expandToInclude(box.getMinx(),box.getMiny());
			expandToInclude(box.getMaxx(),box.getMaxy());
		}
		public function expandToIncludeEnv(env:Envelope):void {
			expandToInclude(env.getMinx(),env.getMiny());
			expandToInclude(env.getMaxx(),env.getMaxy());
		}
		public function zoomBox(zoomFactorX:Number,zoomFactorY:Number):Box {
			var newBounds:Box = new Box();
			newBounds.setBox(minx*zoomFactorX,miny*zoomFactorX,maxx*zoomFactorX,maxy*zoomFactorY);
			return newBounds;
		}
		public function getGeometryName() : String {
			return "Box";
		}
		public function  clone() : Geometry {
			return getBox();
		}
		public function getBounds() : Envelope {
			return toEnvelope();
		}
		public function getCenter() : FPoint {
			var point:FPoint = new FPoint();
			point.setX(getCenterX());
			point.setY(getCenterY());
			return point;
		}
		public function getGeometryString() : String {
			return "Box:"+minx+","+miny+","+maxx+","+maxy;
		}
		public function setGeometryString(geometryString:String) : void {
			var str:String = AppContext.getAppUtil().parseString(geometryString,"Box");
			var ary:Array = AppContext.getAppUtil().getStringArray(str,",");
			minx = AppContext.getAppUtil().getStringNumber(ary,0);
			miny = AppContext.getAppUtil().getStringNumber(ary,1);
			maxx = AppContext.getAppUtil().getStringNumber(ary,2);
			maxy = AppContext.getAppUtil().getStringNumber(ary,3);
		}
		public function toString() : String {
			return "Box:minx="+minx+",miny="+miny+",maxx="+maxx+",maxy="+maxy+",cx="+getCenterX()+",cy="+getCenterY();
		}
	}
}