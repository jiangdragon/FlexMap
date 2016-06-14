package jsoft.map.vector.point
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.GeometryFactory;
	import jsoft.map.vector.BaseVector;
	import jsoft.map.vector.IVector;
	
	import mx.graphics.ImageSnapshot;

	public class PointStringVector extends BaseVector implements IVector
	{
		private var fontColor:int = 0;//字体色
		private var backColor:int = 0;//背景色
		private var borderColor:int = 0;//边框色
		private var bold:Boolean = false;//加粗
		private var italic:Boolean = false;//倾斜
		private var underLine:Boolean = false;//下划线
		private var sBordColor:Boolean = false;//有无边框
		private var sBackColor:Boolean = false;//有无背景
		private var fontSize:int = 15;
		private var txt:String = "";
		private var fontName:String = "宋体";
		private var fontWidth:Number = 0;
		private var fontHeight:Number = 0;
		
		public function PointStringVector(){
			
		}
		
		public override function getVectorName():String{
			return "PointStringVector";
		}
		//复制vector
		public override function clone():IVector{
			var newVector:PointStringVector = new PointStringVector();
			copyTo(newVector);
			newVector.txt = txt;
			newVector.fontName = fontName;
			newVector.fontSize = fontSize;
			newVector.fontColor = fontColor;
			newVector.backColor = backColor;
			newVector.borderColor = borderColor;
			newVector.bold = bold;
			newVector.italic = italic;
			newVector.underLine = underLine;
			newVector.sBackColor = sBackColor;
			newVector.sBordColor = sBordColor;
			newVector.fontWidth = fontWidth;
			newVector.fontHeight = fontHeight;
			return newVector;
		}
		public override function getVectorString():String {
			var theString:String = super.getVectorString();
			var geometry:Geometry = getGeometry();
			//var geometry:Geometry = getGeometryEx();
			//AppContext.getAppUtil().alert(theString+geometry);
			var split:String=getSplitString();
			theString+=split+txt
				+split+fontName
				+split+fontSize
				+split+fontColor
				+split+backColor
				+split+borderColor
				+split+bold
				+split+italic
				+split+underLine
				+split+sBackColor
				+split+sBordColor
				+split+fontWidth
				+split+fontHeight
				+split+geometry.getGeometryString();
			//AppContext.getAppUtil().alert(theString);
			return theString;
		}
		public override function setVectorString(symbolString:String):void {
			var symbolAry:Array=symbolString.split(getSplitString());
			super.setVectorString(symbolAry[0]);
			var pos:int = 1;
			txt=symbolAry[pos++];
			fontName=symbolAry[pos++];
			fontSize=symbolAry[pos++];
			fontColor=symbolAry[pos++];
			backColor=symbolAry[pos++];
			borderColor=symbolAry[pos++];
			bold=AppContext.getAppUtil().getBoolean(symbolAry[pos++]);
			italic=AppContext.getAppUtil().getBoolean(symbolAry[pos++]);
			underLine=AppContext.getAppUtil().getBoolean(symbolAry[pos++]);
			sBackColor=AppContext.getAppUtil().getBoolean(symbolAry[pos++]);
			sBordColor=AppContext.getAppUtil().getBoolean(symbolAry[pos++]);
			fontWidth=symbolAry[pos++];
			fontHeight=symbolAry[pos++];
			var geometryFactory:GeometryFactory=new GeometryFactory();
			var geo:Geometry = geometryFactory.setGeometryString(symbolAry[pos++]);
			this.setGeometry(geo);
			clear();
		}
		public override function toString():String {
			return getVectorString();
		}
		//绘制符号
		public override function showVector(coord:Coordinate):void{
			super.showVector(coord);
			drawUtil.clear();
			var uit:TextField = new TextField();
			uit.text = txt;
			var color1:int,color2:int,color3:int;
			if(status){
				color1 = AppContext.getDrawUtil().getReverseColor(fontColor);
				color2 = AppContext.getDrawUtil().getReverseColor(backColor);
				color3 = AppContext.getDrawUtil().getReverseColor(borderColor);
			}else{
				color1 = fontColor;
				color2 = backColor;
				color3 = borderColor;
			}
			uit.setTextFormat(setTxtFamat(color1));
			if(sBackColor){
				uit.background = true;
				uit.backgroundColor = color2;
			}
			uit.autoSize = TextFieldAutoSize.LEFT;
			fontWidth = uit.width;
			fontHeight = uit.height;
			var textBitmapData:BitmapData = ImageSnapshot.captureBitmapData(uit);
			var g:Graphics = drawUtil.getGraphics();
			g.lineStyle(0,0,0);
			g.beginBitmapFill(textBitmapData,null,false);
			g.drawRect(0,0,fontWidth,fontHeight);
			g.endFill();
			//边框线
			if(sBordColor){
				g.lineStyle(1,color3,1);
				g.drawRect(0,0,fontWidth,fontHeight);
			}
		}
		// 绘制符号
		public override function updateVector() : void {
			if(bounds == null) {
				if(record != null && record.getGeometry() != null) {
					bounds = record.getGeometry().getBounds().toBox();
				} else if(geometry != null) {
					bounds = geometry.getBounds().toBox();
				}
			}
			//AppContext.getAppUtil().alert("coord="+coord);
			var cx:Number = coord.mapToViewX(bounds.getCenterX());
			var cy:Number = coord.mapToViewY(bounds.getCenterY());
	        //AppContext.getAppUtil().alert("updateVector cx="+cx+",cy="+cy);
			cx += offsetx;
			cy += offsety;
			this.x = cx - fontWidth / 2;
			this.y = cy - fontHeight / 2;
			this.width = fontWidth;
			this.height = fontHeight;
		}
		// 获取空间对象
		public override function getGeometry():Geometry {
			var cp:FPoint = bounds.getCenter();
			return cp;
		}
		//矩形盒
		public override function setMapRangeBox(bounds:Box):void{
			this.bounds = new Box();
			this.bounds.setBox(bounds.getCenterX(),bounds.getCenterY(),bounds.getCenterX(),bounds.getCenterY());
		}
		//是否选中
		public override function hitTest(x:Number, y:Number):int{
			var span1:Number = fontWidth / 2;
			var span2:Number = fontHeight / 2;
			var bounds:Box = new Box();
			bounds.setBox(x-span1,y-span2,x+span1,y+span2);
			var coord:Coordinate = getCoordinate();
			var cx:Number = coord.mapToViewX(this.bounds.getCenterX());
			var cy:Number = coord.mapToViewY(this.bounds.getCenterY());
			if(bounds.isContain(cx,cy)) {
				return 0;
			}
			return -1;
		}
		
		public override function hitRectTest(minx:Number, miny:Number, maxx:Number, maxy:Number):Boolean {
			var span:Number = 5;
			var bounds:Box = new Box();
			bounds.setBox(minx,miny,maxx,maxy);
			var coord:Coordinate = getCoordinate();
			var cx:Number = coord.mapToViewX(this.bounds.getCenterX());
			var cy:Number = coord.mapToViewY(this.bounds.getCenterY());
			var box:Box = new Box();
			box.setBox(cx-span,cy-span,cx+span,cy+span);
			if(bounds.isOverlap(box)) {
				return true;
			}
			return false;
		}
		//设置偏移量
		public override function moveControlPoint(hotPoint:int, offsetx:int, offsety:int):void{
			if(hotPoint>=0) {
				this.offsetx = offsetx;
				this.offsety = offsety;
			}
		}
		public override function updateControlPoint(update:Boolean):void{
			if(update) {
				var coord:Coordinate = getCoordinate();
				var cx:Number = coord.mapToViewX(bounds.getCenterX());
				var cy:Number = coord.mapToViewY(bounds.getCenterY());
				cx += offsetx;
				cy += offsety;
				offsetx = 0;
				offsety = 0;
				setViewRange(cx,cy,cx,cy);
			}
		}
		//清除绘制
		public override function clear() : void {
			graphics.clear();
		}
		/**以下是设置文字的属性*********************************************************/
		public function getFontColor():int{
			return fontColor;
		}
		public function setFontColor(fontColor:int):void{
			this.fontColor = fontColor;
		}
		public function getBackColor():int{
			return backColor;
		}
		public function setBackColor(backColor:String):void{
			if(backColor != ""){
				sBackColor = true;
				this.backColor = AppContext.getAppUtil().getColor(backColor);
			}
		}
		public function getFontSize():int{
			return fontSize;
		}
		public function setFontSize(fontSize:int):void{
			if(fontSize > 9){
				this.fontSize = fontSize;
			}
		}
		public function getTxt():String{
			return txt;
		}
		public function setTxt(txt:String):void{
			this.txt = txt;
		}
		public function getFontName():String{
			return fontName;
		}
		public function setFontName(fontName:String):void{
			if(fontName != ""){
				this.fontName = fontName;
			}
		}
		public function getBorderColor():int{
			return borderColor;
		}
		public function setBorderColor(borderColor:String):void{
			if(borderColor != ""){
				sBordColor = true;
				this.borderColor = AppContext.getAppUtil().getColor(borderColor)
			}
		}
		public function getBold():Boolean{
			return bold;
		}
		public function setBold(bold:Boolean):void{
			this.bold = bold;
		}
		public function getItalic():Boolean{
			return italic;
		}
		public function setItalic(italic:Boolean):void{
			this.italic = italic;
		}
		public function getUnderLine():Boolean{
			return underLine;
		}
		public function setUnderLine(underLine:Boolean):void{
			this.underLine = underLine;
		}
		//设置字体格式
		private function setTxtFamat(fontColor:int):TextFormat{
			var t:TextFormat = new TextFormat();
			t.font = fontName;
			t.size = fontSize;
			t.color = fontColor;
			t.bold = bold;
			t.italic = italic;
			t.underline = underLine;
			return t;
		}
	}
}