package jsoft.map.ui
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	
	import jsoft.map.geometry.Coordinate;
	
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.graphics.ImageSnapshot;
	/**
	 * http://xylffxyfpp.javaeye.com/blog/248950
	 * 对地图的分辨率进行显示
	 */
	public class UIScale extends UIComponent
	{
		private var currentwidth:int = -1;
		private var currentheight:int = -1;
		private var currentName:String = "";
		private var currentLevel:int = -1;
//		构造方法
		public function UIScale() {
		}
		
		public function show(width:int=0,height:int=0): void {
			this.graphics.clear();
			if(width == 0) {
				width = AppContext.getApplication().width;
			}
			if(height == 0) {
				height = AppContext.getApplication().height;
			}
			x = 30;
			y = height - 50;
			this.width = width;
			this.height = height;
			if(currentwidth == width && currentheight == height) {
				if(currentName == AppContext.getMapContext().getMapContent().getMapConfig().getName()) {
					if(currentLevel == AppContext.getMapContext().getMapContent().getLevelIndex()) {
						return ;
					}
				}
			}
			if(AppContext.getMapContext().getMapContent().getMapConfig() == null) {
				return;
			}
			currentName = AppContext.getMapContext().getMapContent().getMapConfig().getName();
			currentLevel = AppContext.getMapContext().getMapContent().getLevelIndex();
			if(drawCompatibleScale(1000,50,50)) {
				return;
			}
			if(drawCompatibleScale(50,5,5)) {
				return;
			}
			if(drawCompatibleScale(5,1,1)) {
				return;
			}
			if(drawCompatibleScaleMeter(1000,50,50)) {
				return;
			}
			if(drawCompatibleScaleMeter(50,5,5)) {
				return;
			}
			if(drawCompatibleScaleMeter(5,1,1)) {
				return;
			}
			var text:Number = 0.01;
			var distance:Number = 10;
			var viewX:int = getWidth(distance);
			var loopCount:int = 0;
			while(loopCount < 100 && viewX < 50) {
				distance += 10;
				text += 0.01;
				viewX = getWidth(distance);
				loopCount++;
			}
			drawScale(viewX,text);
		}
		public static var a:Number;//现在的分辨率
		public static var b:Number;  //最大数值
		private function drawCompatibleScale(maxDistance:Number,minDistance:Number,step:Number):Boolean {
//			trace(step+"11111");
//			
			for(var distance:Number = maxDistance;distance>=minDistance;distance-=step) {
				var viewX:int = getWidth(distance * 1000);
				if(viewX < 120) {
					var a:Number=distance;
//	     trace("1:"+a);
					drawScale(viewX,distance);
//					trace(distance*1000);
//                 
					return true;
				}
			}
			return false;
		}
//	     trace("2:"+a);
		
		private function drawCompatibleScaleMeter(maxDistance:Number,minDistance:Number,step:Number):Boolean {
//			  trace(step+"22222");
			var b:Number=step;
			for(var distance:Number = maxDistance;distance>=minDistance;distance-=step) {
                var a:Number=distance;
				var viewX:int = getWidth(distance);
				if(viewX < 150) {
					drawScale(viewX,distance / 1000);
//					trace(distance);
					return true;
				}
			}
			return false;
		}
//		画显示分辨率显示的横线，
		private function drawScale(viewWidth:int,text:Number):void {
			drawFillRect(0,15,viewWidth,18); //画显示分辨率的横线
			drawFillRect(0,12,2,18);          //画显示分辨率的横线左面的点
			drawFillRect(viewWidth-2,12,viewWidth,18);  //画显示分辨率的横线右面的点
			drawText(viewWidth,text);
		}
		
		private function getWidth(distance:Number):int {
			var coordinate:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			if(coordinate.checkCoord()) {
				distance = distance * 360 / (2 * Math.PI * 6378137.0);
			}
			var mapX:Number = coordinate.getMap().getMinx();
			var viewStartX:int = coordinate.mapToViewX(mapX);
			var viewEndX:int = coordinate.mapToViewX(mapX + distance);
			var viewX:int = viewEndX - viewStartX;
			return viewX;
		}
		
		private	function drawFillRect(x1:int,y1:int,x2:int,y2:int):void {
			var x:int = x1 > x2 ? x2 : x1;
			var y:int = y1 > y2 ? y2 : y1;
			var width:int = x1 > x2 ? x1 - x2 : x2 - x1;
			var height:int = y1 > y2 ? y1 - y2 : y2 - y1;
			var color:int = rgbToInt(0,0,0);
			var fillColor:int = rgbToInt(0,0,0);
			this.graphics.lineStyle(1,color);
			this.graphics.beginFill(fillColor);
			this.graphics.drawRect(x,y,width,height);
			this.graphics.endFill();
		}
	
		//显示分辨率的数值的方法
		private function drawText(lenx:int,text:Number):void {
			text=Math.round(text*100)/100;
			var textStr:String="";
			a=text;
			if(text > 1) {
				textStr = text + "公里";
			} else {
				text = text * 1000;
				textStr = text + "米";
			}
			var left:int = (lenx - textStr.length * 12) / 2 + 8;
			var color:int = rgbToInt(0,0,0);
			this.graphics.lineStyle(1,color);
			var fromX:int = left;
			var fromY:int = 0;
			var toX:int = textStr.length * 8 + left;
			var toY:int = 8;
			//this.graphics.moveTo(fromX,fromY);
			//this.graphics.lineTo(toX,toY);
			var uit:UITextField = new UITextField();
			uit.text = textStr;
			uit.autoSize =   TextFieldAutoSize.LEFT;
			var textBitmapData:BitmapData = ImageSnapshot.captureBitmapData(uit);
			var sizeMatrix:Matrix = new Matrix();
			var coef:Number = Math.min(uit.measuredWidth/textBitmapData.width,uit.measuredHeight/textBitmapData.height);
			sizeMatrix.a = coef;
			sizeMatrix.d = coef;
			textBitmapData = ImageSnapshot.captureBitmapData(uit,sizeMatrix);
			this.graphics.lineStyle(0,0,0);
			var sm:Matrix = new Matrix();
			sm.tx = left;
			sm.ty = 0;
			this.graphics.beginBitmapFill(textBitmapData,sm,false);
			this.graphics.drawRect(left,0,uit.measuredWidth,uit.measuredHeight);
			this.graphics.endFill();
		}
//		把rgb颜色的数值转化成int型
		private function rgbToInt(r:int, g:int, b:int):int {
			return r << 16 | g << 8 | b << 0;
		}
	}
}