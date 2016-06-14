package jsoft.map.symbol
{
	import flash.events.Event;
	
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.MultiPolygon;
	import jsoft.map.geometry.Polygon;
	import jsoft.map.geometry.Record;
	import jsoft.map.util.SymbolUtil;
	
	public class PolygonDynSymbol extends Symbol
	{
		private var color:int=0x000000;//"black";
		private var lightColor:int=0x000000;//"black";
		private var fillColor:int =0x000000;//"black"
		private var lightFillColor:int =0x000000;//"black"
		private var weight:int = 1;
		private var opacity:Number=0.5;//透明度0-100
		// -1 代表不停闪烁，0代表不闪烁，>0代表闪烁次数
		private var flare:int = 0;
		private var flareCount:int = 0;
		private var flag:Boolean = true;
		private var maxCount:int=3;
		private var count:int=maxCount;
		
		public function PolygonDynSymbol() {
		}
		
		public override function clone():Symbol {
			var symbol:PolygonDynSymbol = new PolygonDynSymbol();
			copyTo(symbol);
			return symbol;
		}
		
		public override function copyTo(symbol:Symbol):void {
			super.copyTo(symbol);
			var point:PolygonDynSymbol = symbol as PolygonDynSymbol;
			point.color = color;
			point.lightColor = lightColor;
			point.fillColor = fillColor;
			point.lightFillColor = lightFillColor;
			point.weight = weight;
			point.opacity=opacity;
			point.flare=flare;
			point.flareCount=flare;
		}
		
		public override function getSymbolString():String {
			return "PolygonDynSymbol";
		}
		
		public function setColor(_color:int):void {
			color = _color;
		}
		public function getColor():int {
			return color;
		}
		public function setLightColor(_lightColor:int):void {
			lightColor = _lightColor;
		}
		public function getLightColor():int {
			return lightColor;
		}
		public function setFillColor(_fillColor:int):void {
			fillColor = _fillColor;
		}
		public function getFillColor():int {
			return fillColor;
		}
		public function setLightFillColor(_lightFillColor:int):void {
			lightFillColor = _lightFillColor;
		}
		public function getLightFillColor():int {
			return lightFillColor;
		}
		public function setWeight(_weight:int):void {
			weight = _weight;
		}
		public function getWeight():int {
	        return weight;
	    }
		public function setOpacity(_opacity:Number):void {
			opacity = _opacity;
		}
		public function getOpacity():Number {
	        return opacity;
	    }
		public function setFlare(_flare:int):void {
			flare = _flare;
			flareCount = flare;
		}
		public function getFlare():int {
	        return flare;
	    }
		// 绘制符号
		public override function showSymbol(coord:Coordinate):void {
			super.showSymbol(coord);
			show();
		}
		protected override function onEnterFrame(event:Event):void {
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
			if(geometry.getGeometryName() == "Polygon"){
				drawSinglePolygon(geometry);
				return;
			}
			if(geometry.getGeometryName() == "MultiPolygon"){
				var mpolygon:MultiPolygon = geometry as MultiPolygon;
				for(var i:int=0;i<mpolygon.getPolyLength();i++) {
					drawSinglePolygon(mpolygon.getPoly(i));
				}
				return;
			}
			AppContext.getAppUtil().alert("面符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
		}
		private function drawSinglePolygon(geometry:Geometry):void {
			//AppContext.getAppUtil().alert("drawSinglePolygon geometry="+geometry+",color="+color+",\nflareCount="+flareCount+",flare="+flare);
			var poly:Polygon = geometry as Polygon;
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
			var xAry:Array = symbolUtil.getPolyViewX(poly);
			var yAry:Array = symbolUtil.getPolyViewY(poly);
			var minx:Number = symbolUtil.getMin(xAry);
			var miny:Number = symbolUtil.getMin(yAry);
			//AppContext.getAppUtil().alert("drawSinglePoint cx="+cx+",cy="+cy+",width="+width+",height="+height);
			drawUtil.clear();
			if(xAry.length<=0&&yAry.length<=0) {
				return;
			}
			if(flareCount > 0 || flare == -1) {
				if(count <= 0) {
					count = maxCount;
					flag = !flag;
					flareCount--;
				} else {
					count--;
				}
			} else {
				flag = true;
				disableFrame();
			}
			if(flag) {
				graphics.lineStyle(weight,color);
				graphics.beginFill(fillColor,opacity);
			} else {
				graphics.lineStyle(weight,lightColor);
				graphics.beginFill(lightFillColor,opacity);
			}
			symbolUtil.drawPolyArray(graphics,xAry,yAry,minx,miny);
			graphics.endFill();
	    }
		public override function updateSymbol():void {
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
			if(record) {
				symbolUtil.updatePolygon(record.getGeometry(),this);
			}
			if(geometry) {
				symbolUtil.updatePolygon(geometry,this);
			}
		}

	}
}