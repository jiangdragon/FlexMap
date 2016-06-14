package jsoft.map.symbol
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Record;
	
	import mx.core.UITextField;
	import mx.graphics.ImageSnapshot;
	
	public class LableSymbol extends Symbol
	{
		private var fieldValue:String;
		private var showBackground:Boolean = false;
		private var backColor:int ;
		private var showBackgroundOutline:Boolean = false;
		private var backOutlineColor:int;
		private var showShadow:Boolean = false;
		private var shadowColor:int ;
		private var fontSize:int = 12;
		private var color:int=0xff0000;
		private var fontName:String="宋体";

		private var textBitmapData:BitmapData;
		private var textLeft:int;
		private var textTop:int;
		private var textWidth:int=0;
		private var textHeight:int=0;
		private var flare:int = 0;
		
		private var fxLbl:UITextField=null;
		
		public function LableSymbol() {
		}
		
		public override function clone():Symbol {
			var symbol:LableSymbol = new LableSymbol();
			copyTo(symbol);
			return symbol;
		}
		
		public override function copyTo(symbol:Symbol):void {
			super.copyTo(symbol);
			var point:LableSymbol = symbol as LableSymbol;
			point.fieldValue = fieldValue;
			point.showBackground = showBackground;
			point.backColor=backColor;
			point.showBackgroundOutline=showBackgroundOutline;
			point.backOutlineColor=backOutlineColor;
			point.showShadow=showShadow;
			point.shadowColor=shadowColor;
			point.fontSize=fontSize;
			point.color=color;
			point.fontName=fontName;
		}
		
		public override function getSymbolString():String {
			return "LableSymbol";
		}
		
		public function getFieldValue():String {
			return fieldValue;
		}
		//设置属性值
		public function setFieldValue (_fieldValue:String):void{
			fieldValue = _fieldValue;
		}
		public function setFontSize (_fontSize:int):void{
			fontSize = _fontSize;
		}
		public function getFontSize ():int{
			return fontSize;
		}
		public function setColor (_color:int):void{
			color = _color;
		}
		public function getColor ():int {
			return color;
		}
		public function setFontName (_fontName:String):void{
			fontName=_fontName
		}
		public function getFontName ():String {
			return fontName;
		}
		public function setBackOutlineColor (_backOutlineColor:int):void{
			backOutlineColor = _backOutlineColor;
			showBackgroundOutline = true;
		}
		public function getBackOutlineColor ():int{
			return backOutlineColor;
		}
		public function setBackColor (_backColor:int ):void{
			backColor = _backColor;
			showBackground = true;
		}
		public function getBackColor ():int{
			return backColor;
		}
		public function setShadowColor (_shadowColor:int ):void{
			shadowColor = _shadowColor;
			showShadow = true;
		}
		public function getShadowColor ():int {
			return shadowColor;
		}
		// 绘制符号
		public override function showSymbol(coord:Coordinate):void {
			super.showSymbol(coord);
			show();
		}
		private function show():void {
			if(record) {
				drawRecord(record);
			}
			if(geometry) {
				drawGeometry(geometry);
			}
		}
		// 绘制指定记录
		private function drawRecord (record:Record):void {
			setRecord(record);
			var geometry:Geometry = record.getGeometry();
			drawGeometry(geometry);
		}
		// 绘制指定空间对象
		private function drawGeometry (geometry:Geometry):void {
			setGeometry(geometry);
			return drawPoint(geometry);
		}
		private function drawPoint (geometry:Geometry):void {
			var point:FPoint = geometry.getCenter();
			drawSinglePoint(point);
		}
		private function drawSinglePoint(point:FPoint):void {
			var x:Number = point.getX();
			var y:Number = point.getY();
			textLeft = coord.mapToViewX(x);
			textTop = coord.mapToViewY(y);
			if(textWidth == 0) {
		     	var textStr:String = this.fieldValue;
		     	textWidth = textStr.length * 12;
		     	textHeight = 12;
				drawUtil.getGraphics().lineStyle(1,color);
				var fromX:int = 0;
				var fromY:int = 0;
				var toX:int = textStr.length * 12;
				var toY:int = 12;
				//this.graphics.moveTo(fromX,fromY);
				//this.graphics.lineTo(toX,toY);
				var uit:UITextField = new UITextField();
				uit.text = textStr;
				uit.autoSize = TextFieldAutoSize.LEFT;
				textBitmapData = ImageSnapshot.captureBitmapData(uit);
				var sizeMatrix:Matrix = new Matrix();
				var coef:Number = Math.min(uit.measuredWidth/textBitmapData.width,uit.measuredHeight/textBitmapData.height);
				sizeMatrix.a = coef;
				sizeMatrix.d = coef;
				textBitmapData = ImageSnapshot.captureBitmapData(uit,sizeMatrix);
				textWidth = uit.measuredWidth;
				textHeight = uit.measuredHeight;
			}
			drawShadow();
			drawBackround();
			drawTxt();
	    }
		//text
		private function drawTxt():void{
			drawUtil.getGraphics().lineStyle(0,color,0);
			var sm:Matrix = new Matrix();
			sm.tx = 0;
			sm.ty = 0;
			drawUtil.getGraphics().beginBitmapFill(textBitmapData,sm,false);
			drawUtil.getGraphics().drawRect(0,0,textWidth,textHeight);
			drawUtil.getGraphics().endFill();
	    }
		//backround
		private function drawBackround():void{
	     	if(showBackground) {
	     		drawUtil.setFill(true);
	     		drawUtil.setFillColor(backColor);
	     		drawUtil.setLineColor(backOutlineColor);
	     		drawUtil.setLineWidth(1);
	     		drawUtil.drawRect(0,0,textWidth,textHeight);
	     	}
	    }
		//阴影
		private function drawShadow():void{
	     	if(showShadow) {
	     		drawUtil.setFill(true);
	     		drawUtil.setFillColor(shadowColor);
	     		drawUtil.setLineColor(shadowColor);
	     		drawUtil.setLineWidth(1);
	     		drawUtil.drawRect(10,10,textWidth+10,textHeight+10);
	     	}
	    }
		public override function updateSymbol():void {
			if(record) {
				updatePoint(record.getGeometry());
			}
			if(geometry) {
				updatePoint(geometry);
			}
		}
		private function updatePoint(geometry:Geometry):void {
			var point:FPoint = geometry.getCenter();
			updateSinglePoint(point);
		}
		private function updateSinglePoint(point:FPoint):void {
			var mx:Number = point.getX();
			var my:Number = point.getY();
			var vx:int= coord.mapToViewX(mx);
			var vy:int= coord.mapToViewY(my);
			//AppContext.getAppUtil().alert("updateSinglePoint vx="+vx+",vy="+vy);
			
			x = vx;
			y = vy;
			width = textWidth;
			height = textHeight;
	    }

	}
}