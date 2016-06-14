package jsoft.map.symbol
{
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.MultiPoint;
	import jsoft.map.geometry.Record;
	import jsoft.map.util.DrawUtil;
	
	public class SimplePointSymbol extends Symbol
	{
		private var color:int = 0;
		private var size:int = 5;
		private	var type:int = 0;
		
		public function SimplePointSymbol()
		{
		}
		
		public override function clone():Symbol{
			var symbol:SimplePointSymbol = new SimplePointSymbol();
			copyTo(symbol);
			return symbol;
		}
		
		public override function copyTo(symbol:Symbol):void{
			super.copyTo(symbol);
			var point:SimplePointSymbol = symbol as SimplePointSymbol;
			point.color = color;
			point.size = size;
			point.type=type;
		}
		
		public override function getSymbolString():String{
			return "SimplePointSymbol";
		}
		
		public override function showSymbol(coord:Coordinate):void{
			super.showSymbol(coord);
			show();
		}
		
		public override function updateSymbol():void{
			if(record){
				updatePoint(record.getGeometry());
			}
			if(geometry){
				updatePoint(geometry);
			}
		}
		
		private function show():void{
			if(record){
				drawRecord(record);
			}
			if(geometry){
				drawGeometry(geometry);
			}
		}
		/* 绘制record */
		private function drawRecord(record:Record):void{
			setRecord(record);
			var geometry:Geometry = record.getGeometry();
			drawGeometry(geometry);
		}
		/* 绘制geometry */
		private function drawGeometry(geometry:Geometry):void{
			setGeometry(geometry);
			return drawPoint(geometry);
		}
		/* 绘点 */
		private function drawPoint(geometry:Geometry):void{
			if(geometry.getGeometryName() == "Point"){
				drawSinglePoint(geometry);
				return;
			}
			if(geometry.getGeometryName() == "MultiPoint"){
				var mpoint:MultiPoint = geometry as MultiPoint;
				for(var i:int=0;i<mpoint.getPointLength();i++){
					drawSinglePoint(mpoint.getPoint(i));
				}
				return;
			}
			AppContext.getAppUtil().alert("点符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
		}
		
		private function drawSinglePoint(geometry:Geometry):void{
			var point:FPoint = geometry as FPoint;
			var x:Number = point.getX();
			var y:Number = point.getY();
			var drawUtil:DrawUtil = new DrawUtil(graphics);
			drawUtil.setLineColor(color);
			drawUtil.setLineWidth(1);
			drawUtil.setFillColor(color);
			drawUtil.setFill(true);
			var left:int = 0;
			var top:int = 0;
			var cx:int = size + 2;
			var cy:int = size + 2;
			var width:int = size * 2 + 4;
			var height:int = size * 2 + 4;
			//AppContext.getAppUtil().alert("drawSinglePoint cx="+cx+",cy="+cy+",width="+width+",height="+height);
			drawUtil.clear();
			if(type == 0){//绘制圆
				drawUtil.drawCircle(cx,cy,size);
			}else if(type == 1){//绘制方
				drawUtil.drawRect(left,top,left+width,top+height);
			}else{
				AppContext.getAppUtil().alert("点符号无法绘制图形，点符号类型号("+type+")不对！");
			}
		}
		
		private function updatePoint(geometry:Geometry):void{
			if(geometry.getGeometryName() == "Point"){
				updateSinglePoint(geometry);
				return;
			}
			if(geometry.getGeometryName() == "MultiPoint"){
				var mpoint:MultiPoint = geometry as MultiPoint;
				for(var i:int=0;i<mpoint.getPointLength();i++){
					updateSinglePoint(mpoint.getPoint(i));
				}
				return;
			}
			AppContext.getAppUtil().alert("点符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
		}
		
		private function updateSinglePoint(geometry:Geometry):void{
			//AppContext.getAppUtil().alert("updateSinglePoint");
			var point:FPoint = geometry as FPoint;
			var mx:Number = point.getX();
			var my:Number = point.getY();
			var vx:int= coord.mapToViewX(mx);
			var vy:int= coord.mapToViewY(my);
			//AppContext.getAppUtil().alert("updateSinglePoint vx="+vx+",vy="+vy);
			x = vx - size - 2;
			y = vy - size - 2;
			width = size * 2 + 4;
			height = size * 2 + 4;
		}
		/**
		 * get and set method
		 */
		public function setColor(_color:int):void{
			color = _color;
		}
		public function getColor():int{
			return color;
		}
		public function setSize(_size:int):void{
			size = _size;
		}
		public function getSize():int{
	        return size;
	    }
		public function setType(_type:int):void{
			type = _type;
		}
		public function getType():int{
	        return type;
	    }
		
	}
}