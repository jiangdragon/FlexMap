package jsoft.map.symbol
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.TextFieldAutoSize;
	
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.MultiPoint;
	import jsoft.map.geometry.Record;
	
	import mx.core.UITextField;
	import mx.graphics.ImageSnapshot;
	
	public class LegendSymbol extends Symbol
	{
		private var rowHeight:int = 25;
		private var rowWidth:int = 100;
		private var rowNum:int = 1;
		private var markerWidth:int = 20;
		private var markerHeight:int = 20;
		private var direction:String = "vertical";
		private var borderColor:String;
		private var bgColor:String;
		private var typeAry:Array = new Array();
		private var col_urlAry:Array = new Array();
		private var lableAry:Array = new Array();
		
		public function LegendSymbol()
		{
			super();
		}
		public override function clone():Symbol {
			var symbol:LegendSymbol = new LegendSymbol();
			copyTo(symbol);
			return symbol;
		}
		public override function copyTo(symbol:Symbol):void{
			super.copyTo(symbol);
			var point:LegendSymbol = symbol as LegendSymbol;
			point.borderColor = borderColor;
			point.col_urlAry = col_urlAry;
			point.direction = direction;
			point.rowNum = rowNum;
			point.bgColor = bgColor;
			point.typeAry = typeAry;
			point.col_urlAry = col_urlAry;
			point.lableAry = lableAry;
		}
		public override function getSymbolString():String{
			return "LegendSymbol";
		}
		
		public override function showSymbol(coord:Coordinate):void{
			super.showSymbol(coord);
			show();
		}
		private function show():void{
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
			if(geometry.getGeometryName() == "Point"){
				drawSinglePoint(geometry);
				return;
			}
			if(geometry.getGeometryName() == "MultiPoint"){
				var mpoint:MultiPoint = geometry as MultiPoint;
				for(var i:int=0;i<mpoint.getPointLength();i++) {
					drawSinglePoint(mpoint.getPoint(i));
				}
				return;
			}
			AppContext.getAppUtil().alert("圆符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
		}
		private function drawSinglePoint(geometry:Geometry):void {
			var point:FPoint = geometry as FPoint;
			var x:Number = point.getX();
			var y:Number = point.getY();
			x = coord.mapToViewX(x);
			y = coord.mapToViewY(y);
			var j:int = -1;
			if(direction == "vertical" || direction == ""){
				rowNum = 1;
			}
			graphics.clear();
			for(var i:int=0;i<typeAry.length;i++){
				if(i % rowNum == 0){
					j++;
				}
				var colNum:int = i % rowNum;
				var marker_x:Number = x + colNum * rowWidth;
				var marker_y:Number = y + rowHeight * j + (rowHeight - markerHeight) * 0.5;
				var txt_x:Number = x + markerWidth + 3 + colNum * rowWidth;
				var txt_y:Number = y + rowHeight * j;
				
				if(typeAry[i] == "line"){
					
				}else if(typeAry[i] == "rect"){
					drawRect(marker_x,marker_y,AppContext.getAppUtil().getColor(col_urlAry[i]));
					drawLable(txt_x,txt_y,lableAry[i]);//要修改
				}else if(typeAry[i] == "circle"){
					drawCirle(marker_x,marker_y,AppContext.getAppUtil().getColor(col_urlAry[i]));
					drawLable(txt_x,txt_y,lableAry[i]);//要修改
				}else if(typeAry[i] == "ellipse"){
					drawEllipse(marker_x,marker_y,AppContext.getAppUtil().getColor(col_urlAry[i]));
					drawLable(txt_x,txt_y,lableAry[i]);//要修改
				}else if(typeAry[i] == "image"){
					drawImage(marker_x, marker_y,col_urlAry[i]);
					drawLable(txt_x,txt_y,lableAry[i]);//要修改
				}
			}
			drawBorder(x,y,rowNum*rowWidth,rowHeight*(j+1));
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
//			var mx:Number = point.getX();
//			var my:Number = point.getY();
//			var vx:int= coord.mapToViewX(mx);
//			var vy:int= coord.mapToViewY(my);
			//AppContext.getAppUtil().alert("updateSinglePoint vx="+vx+",vy="+vy);
			x = 0;
			y = 0;
			//width = textWidth;
			//height = textHeight;
	    }
		/*************************绘制方法****************************/
		private function drawBorder(x:Number,y:Number,width:Number,height:Number):void{
			if(borderColor == ""){
				graphics.lineStyle(1,0);
			}else{
				graphics.lineStyle(1,AppContext.getAppUtil().getColor(borderColor));
			}
			graphics.drawRect(x-2,y-1,width+2,height+1);
		}
		private function drawEllipse(x:Number,y:Number,color:int):void{
			graphics.beginFill(color);
			graphics.drawEllipse(x,y + markerHeight * 0.25,markerWidth,markerHeight * 0.5);
			graphics.endFill();
		}
		private function drawRect(x:Number,y:Number,color:int):void{
			graphics.beginFill(color);
			graphics.drawRect(x,y,markerWidth,markerHeight);
			graphics.endFill();
		}
		private function drawCirle(x:Number,y:Number,color:int):void{
			var r:Number = markerWidth * 0.5;
			if(markerWidth > markerHeight){
				r = markerHeight * 0.5;
			}
			x = (x + x + markerWidth) * 0.5;
			y = (y + y + markerHeight) * 0.5;
			graphics.beginFill(color);
			graphics.drawCircle(x,y,r);
			graphics.endFill();
		}
		private function drawImage(x:int,y:int,url:String):void{
			var loader:Loader = new Loader();
			loader.x = x;
			loader.y = y;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,OnErrorHandler);
			var loaderContext:LoaderContext = new LoaderContext(true);
			loader.load(new URLRequest(url),loaderContext);
		}
		private function onComplete(event:Event):void{
			var loader:Loader = LoaderInfo(event.target).loader;
			var bitmap:Bitmap = Bitmap(loader.content);
			
			var bitmapData:BitmapData = bitmap.bitmapData;
			var sizeMatrix:Matrix = new Matrix();
			var coef:Number = Math.min(markerWidth/bitmapData.width,markerHeight/bitmapData.height);
			sizeMatrix.a = coef;
			sizeMatrix.d = coef;
			sizeMatrix.tx = loader.x;
			sizeMatrix.ty = loader.y;
			graphics.beginBitmapFill(bitmapData,sizeMatrix,false);
			graphics.drawRect(loader.x,loader.y,markerWidth,markerHeight);
			graphics.endFill();
		}
		private function OnErrorHandler(event:Event):void{
			var io_error:IOErrorEvent = IOErrorEvent(event);
			var url:String = io_error.text;
			AppContext.getAppUtil().alert(url);
		}
		private function drawLable(x:int,y:int,txt:String):void{
			var uit:UITextField = new UITextField();
			uit.text = txt;
			//y = y - 2;
//			uit.setStyle("fontFamily","宋体");
//			uit.setStyle("fontSize",18);
//			var t:TextFormat = new TextFormat();
//			t.size = 15;
//			uit.setTextFormat(t);
			uit.autoSize = TextFieldAutoSize.LEFT;
			
			var textBitmapData:BitmapData = ImageSnapshot.captureBitmapData(uit);
			//var coef:Number = Math.min(rowWidth/textBitmapData.width,rowHeight/textBitmapData.height);
			var sizeMatrix:Matrix = new Matrix();
			//sizeMatrix.a = coef;
			//sizeMatrix.d = coef;
			sizeMatrix.tx = x;
			sizeMatrix.ty = y;
			graphics.beginBitmapFill(textBitmapData,sizeMatrix,false);
			graphics.drawRect(x,y,rowWidth,rowHeight);
			graphics.endFill();
		}
		/**********************get set方法***********************/
		public function getTypeAry():Array{
			return typeAry;
		}
		public function setTypeAry(_typeAry:Array):void{
			typeAry = _typeAry;
		}
		public function getCol_Url():Array{
			return col_urlAry;
		}
		public function setCol_Url(_col_urlAry:Array):void{
			col_urlAry = _col_urlAry;
		}
		public function getLableAry():Array{
			return lableAry;
		}
		public function setLableAry(_lableAry:Array):void{
			lableAry = _lableAry;
		}
		public function getDirection():String{
			return direction;
		}
		public function setDirection(_direction:String):void{
			direction = _direction;
		}
		public function getBorderColor():String{
			return borderColor;
		}
		public function setBorderColor(_borderColor:String):void{
			borderColor = _borderColor;
		}
		public function getRowNum():int{
			return rowNum;
		}
		public function setRowNum(_rowNum:int):void{
			if(_rowNum == 0){
				_rowNum = 1;
			}
			rowNum = _rowNum;
		}
		public function getBgColor():String{
			return bgColor;
		}
		public function setBgColor(_bgColor:String):void{
			bgColor = _bgColor;
		}
		
	}
}