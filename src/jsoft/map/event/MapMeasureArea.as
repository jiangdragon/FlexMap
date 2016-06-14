package jsoft.map.event
{
	import jsoft.map.acete.InputLayer;
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.event.input.PolyInput;
	import jsoft.map.feature.FeatureCallBack;
	import jsoft.map.feature.FeatureServer;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.symbol.LableSymbol;
	import jsoft.map.symbol.PolygonSymbol;
	import jsoft.map.util.SymbolUtil;
	
	public class MapMeasureArea extends PolyInput implements MapEvent,FeatureCallBack
	{
		
		public function MapMeasureArea() {
			MapCursorManager.clearCursor();
		}
				
		protected override function onInputResult(xArray:Array,yArray:Array):void {
			var server:FeatureServer = new FeatureServer();
			server.addAryParam("xAry",xArray);
			server.addAryParam("yAry",yArray);
			server.setFeatureCallBack(this);
			server.processMapEvent("getArea");
			drawMeasureArea(xArray,yArray);
		}
		//绘Polygon  地理坐标
		private function drawMeasureArea(xArray:Array,yArray:Array):void{
			if(xArray == null || yArray == null) {
				return;
			}
			var symbol:PolygonSymbol = new PolygonSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPolygon(xArray,yArray);
			var layer:InputLayer = AppContext.getMapContext().getMapInputLayer();
			layer.clear();
			
			symbol.setGeometry(geo);
			symbol.setColor(0xFF00000);
			symbol.setFillColor(0xFF0000);
			symbol.setWeight(3);
			symbol.setOpacity(0.1);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
			symbolUtil.updatePolygon(geo,symbol);
		}
		//写文字   像素坐标
		private function drawLable(xAry:Array,yAry:Array,text:String):void{
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
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			x = coord.mapFromViewX(x);
			y = coord.mapFromViewY(y);
			var symbol:LableSymbol = new LableSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			
			symbol.setGeometry(geo);
			symbol.setColor(0);
			symbol.setBackColor(0xFFFFFF);
			symbol.setFieldValue(text);
			symbol.setBackOutlineColor(0);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
			symbol.updateSymbol();
		}
		// 返回请求结果
		public function onResult(xml:XML):void {
			var layer:InputLayer = AppContext.getMapContext().getMapInputLayer();
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			var str:String = xml.attribute("area");
			var area:Number = AppContext.getAppUtil().getNumber(str);
			var text:String = coord.formatArea(area);
			text = "面积为：" + text;
			//layer.drawTextEx(xAry,yAry,text);//绘文字
			drawLable(xAry,yAry,text);
			AppContext.getAppUtil().alert(text);
		}
		// 返回请求结果
		public function onResultStr(result:String):void {
		}
		
		// 请求错误
		public function onError():void {
			AppContext.getAppUtil().alert("计算面积失败，无法连接到服务器！");
		}
	}
}