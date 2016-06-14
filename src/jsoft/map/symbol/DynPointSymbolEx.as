package jsoft.map.symbol
{
	import flash.events.Event;
	
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.MultiPoint;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Record;
	import jsoft.map.util.DrawUtil;
	
	public class DynPointSymbolEx extends Symbol
	{
		private var color:int = 0;
		private var lightColor:int = 0;
		private var size:int = 5;
		private	var type:int = 0;
		
		private var outlineColor:int=0;
		private var lightOutlineColor:int=0;
		private var outlineWidth:int=0;
		// -1 代表不停闪烁，0代表不闪烁，>0代表闪烁次数
		private var flare:int = 0;
		private var flareCount:int = 0;
		private var flag:Boolean = true;
		private var maxCount:int=3;
		private var count:int=maxCount;
		
		public function DynPointSymbolEx() {
		}
		
		public override function clone():Symbol {
			var symbol:DynPointSymbolEx = new DynPointSymbolEx();
			copyTo(symbol);
			return symbol;
		}
		
		public override function copyTo(symbol:Symbol):void {
			super.copyTo(symbol);
			var pointEx:DynPointSymbolEx = symbol as DynPointSymbolEx;
			pointEx.color = color;
			pointEx.lightColor = lightColor;
			pointEx.size = size;
			pointEx.type=type;
			pointEx.flare=flare;
			pointEx.flareCount=flare;
			pointEx.outlineColor=outlineColor;
			pointEx.lightOutlineColor=lightOutlineColor;
			pointEx.outlineWidth = outlineWidth;
		}
		
		public override function getSymbolString():String {
			return "DynPointSymbolEx";
		}
		
		public function setColor(_color:int):void {
			color = _color;
		}
		public function getColor():int {
			return color;
		}
		public function getLightColor():int {
			return this.lightColor;
		}		
		public function setLightColor(inColor:int):void {
			this.lightColor = inColor;
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
		public function setFlare(_flare:int):void {
			flare = _flare;
			flareCount = flare;
		}
		public function getFlare():int {
	        return flare;
	    }
	    public function setOutlineColor(_color:int):void {
			this.outlineColor = _color;
		}
		public function getOutlineColor():int {
			return this.outlineColor;
		}
	    public function getLightOutlineColor():int {
			return this.lightOutlineColor;
		}		
		public function setLightOutlineColor(inColor:int):void {
			this.lightOutlineColor = inColor;
		}
	    public function setOutlineWidth(_width:int):void {
			this.outlineWidth = _width;
		}
		public function getOutlineWidth():int {
			return this.outlineWidth;
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
			AppContext.getAppUtil().alert("点符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
		}
		private function drawSinglePoint(geometry:Geometry):void {
			var point:FPoint = geometry as FPoint;
			var x:Number = point.getX();
			var y:Number = point.getY();
			var drawUtil:DrawUtil =  new DrawUtil(graphics);
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
				drawUtil.setLineColor(outlineColor);
				drawUtil.setLineWidth(outlineWidth);
				drawUtil.setFillColor(color);
				drawUtil.setFill(true);
			} else {
				drawUtil.setLineColor(lightOutlineColor);
				drawUtil.setLineWidth(outlineWidth);
				drawUtil.setFillColor(lightColor);
				drawUtil.setFill(true);
			}
			var left:int = 0;
			var top:int = 0;
			var cx:int = size + 2;
			var cy:int = size + 2;
			var width:int = size * 2 + 4;
			var height:int = size * 2 + 4;
			drawUtil.clear();
			// 绘制方框
			if(type == 0) {// 绘制圆
				drawUtil.drawCircle(cx,cy,size);
	        } else if(type == 1) { 
				drawUtil.drawRect(left,top,left+width,top+height);
	        } else {
	        	AppContext.getAppUtil().alert("点符号无法绘制图形，点符号类型("+type+")不对！");
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
			var point:FPoint = geometry as FPoint;
			var mx:Number = point.getX();
			var my:Number = point.getY();
			var vx:int= coord.mapToViewX(mx);
			var vy:int= coord.mapToViewY(my);
			
			x = vx - size - 2;
			y = vy - size - 2;
			width = size * 2 + 4;
			height = size * 2 + 4;
	    }

	}
}