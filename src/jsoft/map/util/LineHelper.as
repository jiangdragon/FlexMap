package jsoft.map.util
{
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.FPoint;
	
	public class LineHelper
	{
		private var _p1:FPoint = new FPoint();
		private var _p2:FPoint = new FPoint();
		
		public function LineHelper(p1:FPoint=null,p2:FPoint=null) {
			this._p1 = p1;
			this._p2 = p2;
		}
		
		public function get p1():FPoint {
			return _p1;
		}
		
		public function set p1(p1:FPoint):void {
			this._p1 = p1;
		}
		
		public function get p2():FPoint {
			return _p2;
		}
		
		public function set p2(p2:FPoint):void {
			this._p2 = p2;
		}
		
		public function getDistance():Number {
			var dis:Number = Math.sqrt((_p2.y-_p1.y)*(_p2.y-_p1.y)+(_p2.x-_p1.x)*(_p2.x-_p1.x));
			return dis;
		}
		
		// 获取线上距离起始点distance的点
		public function getPointByDistance(distance:Number):FPoint {
			var p:FPoint = new FPoint();
			if(p1.x == p2.x) {
				p.x = p1.x;
				if(p1.y > p2.y) {
					p.y = p1.y - distance;
				} else {
					p.y = p1.y + distance;
				}
				return p;
			}
			if(p1.y == p2.y) {
				p.y = p1.y;
				if(p1.x > p2.x) {
					p.x = p1.x - distance;
				} else {
					p.x = p1.x + distance;
				}
				return p;
			}
			var k:Number = (p2.y-p1.y)/(p2.x-p1.x);
			var b:Number = p1.y - k * p1.x;
			var m:Number = Math.sqrt(distance*distance/(k*k+1));
			var x1:Number = p1.x + m;
			var x2:Number = p1.x - m;
			var y1:Number = k * x1 + b;
			var y2:Number = k * x2 + b;
			if(contain(x1,y1)) {
				p.x = x1;
				p.y = y1;
			} else {
				p.x = x2;
				p.y = y2;
			}
			return p;
		}
		
		private function contain(x:Number,y:Number):Boolean {
			var box:Box = new Box();
			box.setBox(p1.x,p1.y,p2.x,p2.y);
			box.normalizeBox();
			var ret:Boolean = box.isContain(x,y);
			return ret;
		}
		
		public function showLine():void {
			AppContext.getAppUtil().alert(toString());
		}
		
		public function toString():String {
			return "line p1="+p1+", p2="+p2+", distance="+getDistance();
		}

	}
}