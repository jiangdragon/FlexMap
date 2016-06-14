package jsoft.map.animate
{
	import jsoft.map.content.MapContent;
	import jsoft.map.util.DrawUtil;
	
	import mx.core.UIComponent;
	
	public class ShowZoom extends UIComponent implements Animate
	{
		private var cx:int;
		private var cy:int;
		private var len:int = 10;
		private var step:int = 0;
		private var maxStep:int = 20;
		private var color:int = 0;
		
		public function ShowZoom(cx:int,cy:int) {
			this.cx = cx;
			this.cy = cy;
			color = new DrawUtil().getRed();
		}
		
		// 执行动画
		public function onFrame(content:MapContent):void {
			if(!content.contains(this)) {
				content.addChild(this);
			}
			graphics.clear();
			if(step >= maxStep) {
				content.clearAnimate();
				if(content.contains(this)) {
					content.removeChild(this);
				}
				return;
			}
			
			var x1:int = cx - step;
			var x2:int = cx + step;
			var y1:int = cy - step;
			var y2:int = cy + step;
			step+=2;
			graphics.lineStyle(1,this.color);
			
			graphics.moveTo(x1-len,y1);
			graphics.lineTo(x1,y1);
			graphics.lineTo(x1,y1-len);
			
			graphics.moveTo(x2+len,y1);
			graphics.lineTo(x2,y1);
			graphics.lineTo(x2,y1-len);
			
			graphics.moveTo(x1-len,y2);
			graphics.lineTo(x1,y2);
			graphics.lineTo(x1,y2+len);
			
			graphics.moveTo(x2+len,y2);
			graphics.lineTo(x2,y2);
			graphics.lineTo(x2,y2+len);
		}

	}
}