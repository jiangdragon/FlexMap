package jsoft.map.animate
{
	import jsoft.map.content.MapContent;
	
	public class ScrollMove implements Animate
	{
		private var speed:Number = 0.05;
		private var cx:Number;
		private var cy:Number;
		
		public function ScrollMove(cx:Number,cy:Number) {
			this.cx = cx;
			this.cy = cy;
		}
		
		// 执行动画
		public function onFrame(content:MapContent):void {
			var ncx:Number = content.getCenterX();
			var ncy:Number = content.getCenterY();
			if(content.getCenterX() != cx) {
				if(content.getCenterY() != cy) {
					ncy = moveTo(content.getCenterY(),cy);
				}
				ncx = moveTo(content.getCenterX(),cx);
				content.setCenter(ncx,ncy);
				content.showMap();
				content.refresh();
				return;
			}
			if(content.getCenterY() != cy) {
				ncy = moveTo(content.getCenterY(),cy);
				content.setCenter(ncx,ncy);
				content.showMap();
				content.refresh();
				return;
			}
			content.clearAnimate();
		}
		
		private function moveTo(x:Number,cx:Number):Number {
			if(cx > x) {
				var nx:Number = x + speed;
				return nx > cx ? cx : nx;
			} else if(cx < x) {
				nx = x - speed;
				return nx < cx ? cx : nx;
			}
			return cx;
		}
	}
}