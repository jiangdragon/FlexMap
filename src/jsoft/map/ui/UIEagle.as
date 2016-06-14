package jsoft.map.ui
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsoft.map.config.MapConfig;
	import jsoft.map.content.MapContent;
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.image.ImageReader;
	import jsoft.map.image.ImageReceiver;
	
	import mx.core.UIComponent;
	
	public class UIEagle extends UIComponent implements ImageReceiver
	{
		private var animate:int=0;
		private var mapColor:int = rgbToInt(0,0,255);
		private var color:int = rgbToInt(0,0,0);
		private var fillColor:int = rgbToInt(255,255,255);
		private var bordeColor:int = rgbToInt(240,240,240);
		private var bordeColorline:int = rgbToInt(114,114,114);
		
		private var showStatus:Boolean = false;
		private var mapConfig:MapConfig = null;
		private var mouseDown:Boolean = false;
		private var arrowWidth:int = 15;
		private var bitmap:BitmapData = null;
		private var coord:Coordinate = null;
		private var curX:int;
		private var curY:int;
		
		public function UIEagle() {
		}
		
		public function isShowEagle():Boolean {
			return showStatus;
		}
		
		public function setShowEagle(show:Boolean=true):void {
			showStatus = show;
			AppContext.getMapContext().getMapContent().refresh();
		}
		
		public function initEvent():void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
		}
		
		private function onMouseDown(event:MouseEvent):void {
			// 鼠标按下
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			curX = event.stageX - this.x;
			curY = event.stageY - this.y;
			if(!showStatus) {
				if(curX >= 0 && curX < arrowWidth && curY >= 0 && curY < arrowWidth) {
					showStatus = true;
					//updateEagle();
					showAnimate();
				}
				return;
			}
			if(curX >= width-arrowWidth && curX < width && curY >= height-arrowWidth && curY < height) {
				showStatus = false;
				//updateEagle();
				showAnimate();
				return;
			}
			if(coord != null && curX >= 0 && curX < width && curY >= 0 && curY < height) {
				mouseDown = true;
				var cx:Number = coord.mapFromViewX(curX);
				var cy:Number = coord.mapFromViewY(curY);
				mapContent.centerMapAt(cx,cy);
				updateEagle();
			}
		}
		
		private function onMouseMove(event:MouseEvent):void {
			// 鼠标移动
			if(!mouseDown) {
				return;
			}
			curX = event.stageX - this.x;
			curY = event.stageY - this.y;
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			if(coord != null && curX >= 0 && curX < width && curY >= 0 && curY < height) {
				var cx:Number = coord.mapFromViewX(curX);
				var cy:Number = coord.mapFromViewY(curY);
				showEagle(cx,cy);
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			// 鼠标放开
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			if(!mouseDown) {
				return;
			}
			mouseDown = false;
			curX = event.stageX - this.x;
			curY = event.stageY - this.y;
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			if(coord != null && curX >= 0 && curX < width && curY >= 0 && curY < height) {
				var cx:Number = coord.mapFromViewX(curX);
				var cy:Number = coord.mapFromViewY(curY);
				mapContent.centerMapAt(cx,cy);
				updateEagle();
			}
		}
		
		private function onStageMouseLeave(event:Event):void {
			// 鼠标离开
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			if(!mouseDown) {
				return;
			}
			mouseDown = false;
		}
		
		private function showAnimate():void {
			animate = 10;
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		private function onEnterFrame(event:Event):void {
			if(animate <= 0) {
				this.updateEagle();
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				return;
			}
			graphics.clear();
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			var scrWidth:int = mapContent.getScreenWidth();
			var scrHeight:int = mapContent.getScreenHeight();
			var span:int = 5;
			if(showStatus) {
				var percent1:Number = (10-animate) * 1.0 / 10;
				var w:int = bitmap == null ? 100 : bitmap.width;
				var h:int = bitmap == null ? 100 : bitmap.height;
				x=scrWidth-(w-1)*percent1;
				y=scrHeight-(h-1)*percent1;
				drawFillRect(0,0,(w-1)*percent1,(h-1)*percent1);
				//drawArrow(width+span-arrowWidth,height+span-arrowWidth,width-span,height-span,span);
			} else {
				var percent2:Number = animate * 1.0 / 10;
				x=scrWidth-(width-1)*percent2;
				y=scrHeight-(height-1)*percent2;
				drawFillRect(0,0,(width-1)*percent2,(height-1)*percent2);
				//drawArrow((width-1)*percent2-span,(height-1)*percent2-span,span,span,span);
			}
			animate-=2;
		}
		
		private function onMouseClick(event:MouseEvent):void {
		}
		
		private function updateEagle():void {
			AppContext.getMapContext().getLevelUI().setMouseDown();
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			mapContent.refresh();
		}
		
		public function refresh():void {
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			var config:MapConfig = mapContent.getMapConfig();
			if(config == null) {
				x = 0;
				y = 0;
				width = 0;
				height = 0;
				return;
			}
			drawEagle(bitmap);
			if(!showStatus) {
				return;
			}
			if(bitmap == null) {
				var url:String = config.getMapURL() + "Oval." + config.getImageType();
				var image:ImageReader = new ImageReader(url);
				image.addDataRecv(this);
			}
		}
		
		public function onRecv(imageData:BitmapData):void {
			bitmap = imageData;
			if(bitmap == null) {
				return;
			}
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			var config:MapConfig = mapContent.getMapConfig();
			coord = new Coordinate();
			coord.setScreen(bitmap.width,bitmap.height);
			coord.setMap(config.getMapOval().getMap().toBox());
			if(showStatus) {
				drawEagle(bitmap);
			}
		}
		
		private function showEagle(cx:Number,cy:Number):void {
			graphics.clear();
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			var scrWidth:int = mapContent.getScreenWidth();
			var scrHeight:int = mapContent.getScreenHeight();
			var span:int = 5;
			if(!showStatus) {
				width = arrowWidth;
				height = arrowWidth;
				x = scrWidth - width;
				y = scrHeight - height;
				drawFillRect(0,0,width-1,height-1);
				drawArrow(width-span,height-span,span,span,span);
				return;
			}
			width = bitmap == null ? 100 : bitmap.width;
			height = bitmap == null ? 100 : bitmap.height;
			x = scrWidth - width;
			y = scrHeight - height;
			if(bitmap == null) {
				drawFillRect(0,0,width-1,height-1);
			} else {
				drawImageFillRect(bitmap,0,0,width-1,height-1);
			}
			if(coord != null) {
				var mapBox:Box = mapContent.getCoordinate().getMap().getBox();
				mapBox.centerAt(cx,cy);
				var x1:int = coord.mapToViewX(mapBox.getMinx());
				var x2:int = coord.mapToViewX(mapBox.getMaxx());
				if(Math.abs(x2-x1) < 8) {
					var ccx:int = (x2 + x1) / 2;
					x1 = ccx - 4;
					x2 = ccx + 4;
				}
				var y1:int = coord.mapToViewY(mapBox.getMiny());
				var y2:int = coord.mapToViewY(mapBox.getMaxy());
				if(Math.abs(y2-y1) < 8) {
					var ccy:int = (y2 + y1) / 2;
					y1 = ccy - 4;
					y2 = ccy + 4;
				}
				drawMapRect(x1,y1,x2,y2);
			}
			drawBorder(4,4,width,height);
			drawBorderline(0,0,width+10,height+10);
			drawBorderline(7,7,width,height);
			drawFillRect(width,height,width-arrowWidth,height-arrowWidth);
			//drawFillRect(0,0,arrowWidth,arrowWidth);
			//drawArrow(span,span,arrowWidth-span,arrowWidth-span,span);
			drawArrow(width+span-arrowWidth,height+span-arrowWidth,width-span,height-span,span);
		}
		
		private function drawEagle(bitmap:BitmapData=null):void {
			graphics.clear();
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			var scrWidth:int = mapContent.getScreenWidth();
			var scrHeight:int = mapContent.getScreenHeight();
			var span:int = 5;
			if(!showStatus) {
				width = arrowWidth;
				height = arrowWidth;
				x = scrWidth - width;
				y = scrHeight - height;
				drawFillRect(0,0,width-1,height-1);
				drawArrow(width-span,height-span,span,span,span);
				return;
			}
			width = bitmap == null ? 150 : bitmap.width;
			height = bitmap == null ? 150 : bitmap.height;
			x = scrWidth - width;
			y = scrHeight - height;
			if(bitmap == null) {
				drawFillRect(0,0,width-1,height-1);
			} else {
				drawImageFillRect(bitmap,0,0,width-1,height-1);
			}
			if(coord != null) {
				var mapBox:Box = mapContent.getCoordinate().getMap();
				var x1:int = coord.mapToViewX(mapBox.getMinx());
				var x2:int = coord.mapToViewX(mapBox.getMaxx());
				if(Math.abs(x2-x1) < 8) {
					var ccx:int = (x2 + x1) / 2;
					x1 = ccx - 4;
					x2 = ccx + 4;
				}
				var y1:int = coord.mapToViewY(mapBox.getMiny());
				var y2:int = coord.mapToViewY(mapBox.getMaxy());
				if(Math.abs(y2-y1) < 8) {
					var ccy:int = (y2 + y1) / 2;
					y1 = ccy - 4;
					y2 = ccy + 4;
				}
				drawMapRect(x1,y1,x2,y2);
			}
			drawBorder(4,4,width,height);
			drawBorderline(0,0,width+10,height+10);
			drawBorderline(7,7,width,height);
			drawFillRect(width,height,width-arrowWidth,height-arrowWidth);
			//drawArrow(span,span,arrowWidth-span,arrowWidth-span,span);
			drawArrow(width+span-arrowWidth,height+span-arrowWidth,width-span,height-span,span);
		}
		
		private function drawMapRect(x1:int,y1:int,x2:int,y2:int):void {
			var x:int = x1 > x2 ? x2 : x1;
			var y:int = y1 > y2 ? y2 : y1;
			var width:int = x1 > x2 ? x1 - x2 : x2 - x1;
			var height:int = y1 > y2 ? y1 - y2 : y2 - y1;
			if(x + width <= 0 || y + height <= 0) {
				return;
			}
			graphics.lineStyle(2,mapColor);
			graphics.beginFill(mapColor,0.1);
			if(x < 0) {
				width += x;
				x = 1;
			}
			if(y < 0) {
				height += y;
				y = 1;
			}
			graphics.drawRect(x,y,width,height);
			graphics.endFill();
		}
		
		private function drawFillRect(x1:int,y1:int,x2:int,y2:int):void {
			var x:int = x1 > x2 ? x2 : x1;
			var y:int = y1 > y2 ? y2 : y1;
			var width:int = x1 > x2 ? x1 - x2 : x2 - x1;
			var height:int = y1 > y2 ? y1 - y2 : y2 - y1;
			graphics.lineStyle(0,color);
			graphics.beginFill(fillColor);
			graphics.drawRect(x,y,width,height);
			graphics.endFill();
		}
		
		private function drawImageFillRect(bitmap:BitmapData,x1:int,y1:int,x2:int,y2:int):void {
			var x:int = x1 > x2 ? x2 : x1;
			var y:int = y1 > y2 ? y2 : y1;
			var width:int = x1 > x2 ? x1 - x2 : x2 - x1;
			var height:int = y1 > y2 ? y1 - y2 : y2 - y1;
			graphics.lineStyle(0,color);
			graphics.beginBitmapFill(bitmap);
			graphics.drawRect(x,y,width,height);
			graphics.endFill();
		}
		
		private function drawArrow(startX:int,startY:int,endX:int,endY:int,arrowLen:int):void {
			graphics.lineStyle(1,color);
			graphics.moveTo(startX,startY);
			graphics.lineTo(endX,endY);
			arrowLen = startX > endX ? arrowLen : -arrowLen;
			graphics.moveTo(endX,endY);
			graphics.lineTo(endX + arrowLen,endY);
			graphics.moveTo(endX,endY);
			graphics.lineTo(endX,endY + arrowLen);
		}
		
		private function rgbToInt(r:int, g:int, b:int):int {
			return r << 16 | g << 8 | b << 0;
		}
		
		private function drawBorder(x:int,y:int,w:int,h:int):void{
			var array:Array = new Array();
			array[array.length] = x;
			array[array.length] = y;
			array[array.length] = w;
			array[array.length] = h;
			drawFillBorderEx(array);
		}
		private function drawFillBorderEx(rect:Array):void{
			drawFillBorder(rect[0],rect[1],rect[2],rect[3]);
		}
		private function drawFillBorder(x:int,y:int,z:int,s:int):void {
			var x1:int = x;
			var y1:int = y;
			var w:int = z;
			var h:int = s;
	
			graphics.lineStyle(8,bordeColor);
//			graphics.beginFill(fillCircleAllColor);
	
			graphics.drawRect(x1,y1,w,h);
			graphics.endFill();
			
		}
		private function drawBorderline(x:int,y:int,w:int,h:int):void{
			var array:Array = new Array();
			array[array.length] = x;
			array[array.length] = y;
			array[array.length] = w;
			array[array.length] = h;
			drawFillBorderExline(array);
		}
		private function drawFillBorderExline(rect:Array):void{
			drawFillBorderline(rect[0],rect[1],rect[2],rect[3]);
		}
		private function drawFillBorderline(x:int,y:int,w:int,h:int,border:int=1):void {
			graphics.lineStyle(border,bordeColorline);
			graphics.drawRect(x,y,w,h);
		}
	}
}