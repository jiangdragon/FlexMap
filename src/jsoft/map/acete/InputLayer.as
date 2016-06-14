package jsoft.map.acete
{
	import flash.events.Event;
	
	import jsoft.map.util.DrawUtil;
	
	import mx.core.UIComponent;
	
	public class InputLayer extends UIComponent
	{
		public function InputLayer() {
		}
		
		public function initLayer():void {
			addEventListener(Event.RESIZE, onResize);
			onResize(null);
		}
		
		public function resetPositon():void {
			x = 0;
			y = 0;
			width = AppContext.getApplication().width;
			height = AppContext.getApplication().height;
		}
		
		private function onResize(event:Event):void {
			x = 0;
			y = 0;
			width = AppContext.getApplication().width;
			height = AppContext.getApplication().height;
		}
		
		public function clear():void {
			graphics.clear();
		}
		
		public function drawCircle(cx:Number,cy:Number,radius:Number):void {
			graphics.clear();
			var color:int = AppContext.getDrawUtil().getRed();
			graphics.lineStyle(3,color);
			graphics.beginFill(color,0.1);
			graphics.drawCircle(cx,cy,radius);
			graphics.endFill();
		}
		
		public function drawEllipse(minx:Number,miny:Number,maxx:Number,maxy:Number):void {
			graphics.clear();
			var color:int = AppContext.getDrawUtil().getRed();
			graphics.lineStyle(3,color);
			graphics.beginFill(color,0.1);
			graphics.drawEllipse(Math.min(minx,maxx),Math.min(miny,maxy),Math.abs(maxx-minx),Math.abs(maxy-miny));
			graphics.endFill();
		}
		
		public function drawBox(minx:Number,miny:Number,maxx:Number,maxy:Number):void {
			//AppContext.getAppUtil().showStatus("minx="+minx+",miny="+miny+",maxx="+maxx+",maxy="+maxy);
			graphics.clear();
			var color:int = AppContext.getDrawUtil().getRed();
			graphics.lineStyle(3,color);
			graphics.beginFill(color,0.1);
			graphics.drawRect(Math.min(minx,maxx),Math.min(miny,maxy),Math.abs(maxx-minx),Math.abs(maxy-miny));
			graphics.endFill();
		}
		
		public function drawLine(minx:Number,miny:Number,maxx:Number,maxy:Number):void {
			graphics.clear();
			var color:int = AppContext.getDrawUtil().getRed();
			graphics.lineStyle(3,color);
			graphics.moveTo(minx,miny);
			graphics.lineTo(maxx,maxy);
		}
		
		public function drawTriangle(x1:Number,y1:Number,x2:Number,y2:Number,x3:Number,y3:Number):void {
			var xAry:Array = new Array();
			var yAry:Array = new Array();
			xAry.push(x1);
			yAry.push(y1);
			xAry.push(x2);
			yAry.push(y2);
			xAry.push(x3);
			yAry.push(y3);
			xAry.push(x1);
			yAry.push(y1);
			drawPolyAry(xAry,yAry);
		}
		
		public function drawLineAry(xAry:Array,yAry:Array):void {
			graphics.clear();
			if(xAry == null || xAry.length <= 1) {
				return;
			}
			var color:int = AppContext.getDrawUtil().getRed();
			graphics.lineStyle(3,color);
			graphics.moveTo(xAry[0],yAry[0]);
			//AppContext.getAppUtil().alert("xAry.length="+xAry.length);
			for(var i:int=1;i<xAry.length;i++) {
				graphics.lineTo(xAry[i],yAry[i]);
			}
		}
		
		public function drawPolyAry(xAry:Array,yAry:Array):void {
			graphics.clear();
			if(xAry == null || xAry.length <= 1) {
				return;
			}
			var color:int = AppContext.getDrawUtil().getRed();
			graphics.lineStyle(3,color);
			graphics.beginFill(color,0.1);
			graphics.moveTo(xAry[0],yAry[0]);
			//AppContext.getAppUtil().alert("xAry.length="+xAry.length);
			for(var i:int=1;i<xAry.length;i++) {
				graphics.lineTo(xAry[i],yAry[i]);
			}
			graphics.endFill();
		}
		
		public function drawPolyAryEx(xAry:Array,yAry:Array,endx:Number,endy:Number):void {
			graphics.clear();
			if(xAry == null || xAry.length <= 1) {
				return;
			}
			var color:int = AppContext.getDrawUtil().getRed();
			graphics.lineStyle(3,color);
			graphics.beginFill(color,0.1);
			graphics.moveTo(xAry[0],yAry[0]);
			//AppContext.getAppUtil().alert("xAry.length="+xAry.length);
			for(var i:int=1;i<xAry.length;i++) {
				graphics.lineTo(xAry[i],yAry[i]);
			}
			graphics.lineTo(endx,endy);
			graphics.endFill();
		}
		
		public function drawTextEx(xAry:Array,yAry:Array,text:String):void {
			if(xAry == null || yAry == null) {
				return;
			}
			var x:Number = 0;
			var y:Number = 0;
			for(var i:int = 0;i<xAry.length;i++) {
				x+=xAry[i];
				y+=yAry[i];
			}
			x = x / xAry.length;
			y = y / yAry.length;
			drawText(x,y,text);
		}
		
		public function drawText(x:Number,y:Number,text:String):void {
			var draw:DrawUtil = new DrawUtil(graphics);
			draw.drawText(x,y,text,"宋体",12,draw.getBlue(),draw.getWhite(),draw.getBlack());
		}
	}
}