package jsoft.map.event
{
	import jsoft.map.acete.InputLayer;
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.event.input.LineInput;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.symbol.LableSymbol;
	import jsoft.map.symbol.LineSymbolEx;
	import jsoft.map.util.SymbolUtil;
	
	public class MapMeasure extends LineInput implements MapEvent
	{		
		public function MapMeasure() {
			MapCursorManager.clearCursor();
		}
		
		protected override function drawLineAry(xAry:Array,yAry:Array):void {
			var layer:InputLayer = AppContext.getMapContext().getMapInputLayer();
			layer.drawLineAry(xAry,yAry);
			for(var i:int=1;xAry!=null&&i<xAry.length;i++) {
				drawDistance(layer,xAry[i-1],yAry[i-1],xAry[i],yAry[i]);
			}
		}
		
		protected override function drawDynLine(x1:Number,y1:Number,x2:Number,y2:Number):void {
			var layer:InputLayer = AppContext.getMapContext().getMapDynInputLayer();
			layer.drawLine(x1,y1,x2,y2);
			drawDistance(layer,x1,y1,x2,y2);
			var text2:String = getTotalViewDistance(xAry,yAry,x2,y2);
			text2 = "总长：" + text2;
			layer.drawText(x2 + 16,y2 + 16,text2);
		}
		
		protected override function onInputResult(xArray:Array,yArray:Array):void {
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			var distance:Number = coord.getTotalDistance(xArray,yArray);
			var text:String = coord.formatDistance(distance);
			AppContext.getAppUtil().alert("长度为：" + text);
			//保存线
			AppContext.getMapContext().clearInputLayer();
			drawMeasure();
			//保存文字
			drawLables();
		}
		
		//绘line 经纬度
		private function drawMeasure():void{
			if(xAry == null || yAry == null) {
				return;
			}
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			var xArray:Array = coord.mapFromViewXAry(xAry);
			var yArray:Array = coord.mapFromViewYAry(yAry);

			var symbol:LineSymbolEx = new LineSymbolEx();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createLine(xArray,yArray);
			symbol.setGeometry(geo);
			symbol.setColor(0xFF00000);
			symbol.setWidth(3);
			
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
			symbolUtil.updateSingleLine(geo,symbol);
		}
		
		private function drawLables():void{
			if(xAry == null || yAry == null) {
				return;
			}
			var x:Number;
			var y:Number;
			var text:String;
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			for(var i:int=1;i<xAry.length;i++){//各段文字
				text= getViewDistanceEx(xAry[i-1],yAry[i-1],xAry[i],yAry[i]);
				var _x1:Number = coord.mapFromViewX(xAry[i-1]);
				var _x2:Number = coord.mapFromViewX(xAry[i]);
				var _y1:Number = coord.mapFromViewY(yAry[i-1]);
				var _y2:Number = coord.mapFromViewY(yAry[i]);
				x = (_x1 + _x2) * 0.5;
				y = (_y1 + _y2) * 0.5;
				drawLable(x,y,text);
			}
			//总长lable
			x = coord.mapFromViewX(xAry[xAry.length-1] + 16);
			y = coord.mapFromViewY(yAry[yAry.length-1] + 16);
			text = "总长：" + getViewDistance(xAry,yAry);
			drawLable(x,y,text);
		}
		
		private function drawLable(x:Number,y:Number,txt:String):void{
			var symbol:LableSymbol = new LableSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			
			symbol.setGeometry(geo);
			symbol.setColor(0);
			symbol.setBackColor(0xFFFFFF);
			symbol.setFieldValue(txt);
			symbol.setBackOutlineColor(0);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
			symbol.updateSymbol();
		}
		
		private function drawDistance(layer:InputLayer,x1:Number,y1:Number,x2:Number,y2:Number):void {
			var x:Number = (x1 + x2) / 2;
			var y:Number = (y1 + y2) / 2;
			var text:String = getViewDistanceEx(x1,y1,x2,y2);
			layer.drawText(x,y,text);
		}
		
		private function getTotalViewDistance(xAry:Array,yAry:Array,x:Number,y:Number):String {
			var xAry1:Array = new Array();
			var yAry1:Array = new Array();
			for(var i:int=0;i<xAry.length;i++) {
				xAry1.push(xAry[i]);
				yAry1.push(yAry[i]);
			}
			xAry1.push(x);
			yAry1.push(y);
			return getViewDistance(xAry1,yAry1);
		}
		
		private function getViewDistance(xAry:Array,yAry:Array):String {
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			var distance:Number = coord.getTotalDistance(coord.mapFromViewXAry(xAry),coord.mapFromViewYAry(yAry));
			var text:String = coord.formatDistance(distance);
			return text;
		}
		
		private function getViewDistanceEx(x1:Number,y1:Number,x2:Number,y2:Number):String {
			var xAry:Array = new Array();
			var yAry:Array = new Array();
			xAry.push(x1);
			yAry.push(y1);
			xAry.push(x2);
			yAry.push(y2);
			return getViewDistance(xAry,yAry);
		}
	}
}