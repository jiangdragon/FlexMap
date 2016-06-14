package jsoft.map.animate
{
	import jsoft.map.content.MapContent;
	
	public class SpeedCoolDown implements Animate
	{
		private var offsetX:int;
		private var offsetY:int;
		private var speedX:Number;
		private var speedY:Number;
		private var count:int = 0;
		
		public function SpeedCoolDown(offsetX:int,offsetY:int,speedX:Number,speedY:Number) {
			this.offsetX = getValue(offsetX,50);
			this.offsetY = getValue(offsetY,50);
			this.speedX = getValue(speedX,0.5);
			this.speedY = getValue(speedY,0.5);
		}
		
		private function getValue(value:Number,range:Number):Number {
			var ret:Number = value;
			if(ret < -range) {
				ret = - range;
			}
			if(ret > range) {
				ret = range;
			}
			return ret;
		}
		
		// 执行动画
		public function onFrame(content:MapContent):void {
			var xoff:int = offsetX * Math.abs(speedX);
			var yoff:int = offsetY * Math.abs(speedY);
			
			//trace("offsetX="+offsetX+", speedX="+speedX+",offsetY="+offsetY+", speedY="+speedY+",xoff="+xoff+", yoff="+yoff);
			content.moveTo(xoff,yoff);
			content.showMap();
			content.refresh();
			var speed:Number = 0.01;
			if(speedX >= -speed && speedX <= speed) {
				speedX = 0;
			} else {
				if(speedX < -speed) {
					speedX += speed;
				} else {
					speedX -= speed;
				}
			}
			if(speedY >= -speed && speedY <= speed) {
				speedY = 0;
			} else {
				if(speedY < -speed) {
					speedY += speed;
				} else {
					speedY -= speed;
				}
			}
			count++;
			if((speedX == 0 && speedY == 0) || count > 20) {
				content.clearAnimate();
			}
		}
	}
}