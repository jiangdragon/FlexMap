package jsoft.map.symbol
{
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.MultiPoint;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Record;
	import jsoft.map.util.DrawUtil;
	
	public class CircleSymbol extends Symbol
	{
		private var color:int = 0;
		private var fillColor:int = 0;
		private var weight:int=1;
		private var opacity:Number = 1;
		private var size:int = 5;
		private	var type:int = 0;
		
		public function CircleSymbol() {
		}
		
		public override function clone():Symbol {
			var symbol:CircleSymbol = new CircleSymbol();
			copyTo(symbol);
			return symbol;
		}
		
		public override function copyTo(symbol:Symbol):void {
			super.copyTo(symbol);
			var point:CircleSymbol = symbol as CircleSymbol;
			point.color = color;
			point.fillColor = fillColor;
			point.weight = weight;
			point.opacity=opacity;
			point.size = size;
			point.type=type;
		}
		
		public override function getSymbolString():String {
			return "CircleSymbol";
		}
		
		public function setColor(_color:int):void {
			color = _color;
		}
		public function getColor():int {
			return color;
		}
		public function setFillColor(_color:int):void {
			fillColor = _color;
		}
		public function getFillColor():int {
			return fillColor;
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
		public function setSize(_size:int):void {
			size = _size;
		}
		public function getSize():int {
	        return size;
	    }
		public function setType(_type:int):void {
			type = _type;
		}
		public function getType():int {
	        return type;
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
			//AppContext.getAppUtil().alert("drawSinglePoint geometry="+geometry+",type="+type+",color="+color);
			var point:FPoint = geometry as FPoint;
			var x:Number = point.getX();
			var y:Number = point.getY();
			
			graphics.clear();
			graphics.lineStyle(weight,color);
			graphics.beginFill(fillColor,opacity);
			graphics.drawCircle(size,size,size);
			graphics.endFill();
			
//			var drawUtil:DrawUtil =  new DrawUtil(graphics);
//			drawUtil.setLineColor(color);
//			drawUtil.setLineWidth(1);
//			drawUtil.setFillColor(fillColor);
//			drawUtil.setFillAlpha(opacity);
//			drawUtil.setFill(true);
//			var left:int = 0;
//			var top:int = 0;
//			var cx:int = size + 2;
//			var cy:int = size + 2;
//			var width:int = size * 2 + 4;
//			var height:int = size * 2 + 4;
//			//AppContext.getAppUtil().alert("drawSinglePoint cx="+cx+",cy="+cy+",width="+width+",height="+height);
//			drawUtil.clear();
//			// 绘制方框
//			if(type == 0) {// 绘制圆
//				drawUtil.drawCircle(cx,cy,size);
//	        } else if(type == 1) { 
//				drawUtil.drawRect(left,top,left+width,top+height);
//	        } else {
//	        	AppContext.getAppUtil().alert("圆符号无法绘制图形，点符号类型("+type+")不对！");
//	        }
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
			if(geometry.getGeometryName() == "Point"){
				updateSinglePoint(geometry);
				return;
			}
			if(geometry.getGeometryName() == "MultiPoint"){
				var mpoint:MultiPoint = geometry as MultiPoint;
				for(var i:int=0;i<mpoint.getPointLength();i++) {
					updateSinglePoint(mpoint.getPoint(i));
				}
				return;
			}
			AppContext.getAppUtil().alert("点符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
		}
		private function updateSinglePoint(geometry:Geometry):void {
			//AppContext.getAppUtil().alert("updateSinglePoint");
			var point:FPoint = geometry as FPoint;
			var mx:Number = point.getX();
			var my:Number = point.getY();
			var vx:int= coord.mapToViewX(mx);
			var vy:int= coord.mapToViewY(my);
			//AppContext.getAppUtil().alert("updateSinglePoint vx="+vx+",vy="+vy);
			
			x = vx - size;
			y = vy - size;
			width = size * 2;
			height = size * 2;
	    }

	}
}