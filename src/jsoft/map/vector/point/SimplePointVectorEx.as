package jsoft.map.vector.point
{
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.GeometryFactory;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Record;
	import jsoft.map.util.DrawUtil;
	import jsoft.map.vector.BaseVector;
	import jsoft.map.vector.IVector;

	public class SimplePointVectorEx extends BaseVector implements IVector
	{
		private var color:int = 0;
		private var size:int = 5;
		private	var type:int = 0;
		
		private var outlineColor:int=0;
		private var outlineWidth:int=0;
		
		public function SimplePointVectorEx() {
		}
		public override function getVectorName():String {
			return "SimplePointVectorEx";
		}
		public override function clone():IVector {
			var newVector:SimplePointVectorEx = new SimplePointVectorEx();
			copyTo(newVector);
			newVector.color = color;
			newVector.size = size;
			newVector.type = type;
			newVector.outlineColor = outlineColor;
			newVector.outlineWidth = outlineWidth;
			return newVector;
		}
		public override function getVectorString():String {
			var theString:String = super.getVectorString();
			var split:String=getSplitString();
			theString+=split+color+split+size+split+type+split+outlineColor+split+outlineWidth+split+getGeometry().getGeometryString();
			return theString;
		}
		public override function setVectorString(symbolString:String):void {
			var symbolAry:Array=symbolString.split(getSplitString());
			super.setVectorString(symbolAry[0]);
			this.setColor(symbolAry[1]);
			this.setSize(symbolAry[2]);
			this.setType(symbolAry[3]);
			this.setOutlineColor(symbolAry[4]);
			this.setOutlineWidth(symbolAry[5]);
			var geometryFactory:GeometryFactory=new GeometryFactory();
			this.setGeometry(geometryFactory.setGeometryString(symbolAry[6]));
		}
		public override function toString():String {
			return getVectorString();
		}
		// 获取空间对象
		public override function getGeometry():Geometry {
			var cp:FPoint = bounds.getCenter();
			return cp;
		}
		// 设置空间对象
		public override function setGeometry(geometry:Geometry):void {
			if(geometry!=null) {
				var cp:FPoint = geometry.getCenter();
				setMapRange(cp.getX(),cp.getY(),cp.getX(),cp.getY());
			}
		}
		// 获取记录对象
		public override function getRecord():Record {
			var cp:FPoint = bounds.getCenter();
			record.setGeometry(cp);
			return record;
		}
		// 设置记录对象
		public override function setRecord(record:Record):void {
			this.record = record;
			if(record.getGeometry()!=null) {
				var cp:FPoint = record.getGeometry().getCenter();
				setMapRange(cp.getX(),cp.getY(),cp.getX(),cp.getY());
			}
		}
		public override function setMapRangeBox(bounds:Box):void {
			this.bounds = new Box();
			this.bounds.setBox(bounds.getCenterX(),bounds.getCenterY(),bounds.getCenterX(),bounds.getCenterY());
		}
		public function setColor(_color:int):void {
			color = _color;
		}
		public function getColor():int {
			return color;
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
	    public function setOutlineColor(_color:int):void {
			this.outlineColor = _color;
		}
		public function getOutlineColor():int {
			return this.outlineColor;
		}
	    public function setOutlineWidth(_width:int):void {
			this.outlineWidth = _width;
		}
		public function getOutlineWidth():int {
			return this.outlineWidth;
		}
		// 绘制符号
		public override function showVector(coord:Coordinate) : void {
			super.showVector(coord);
			drawUtil.clear();
			if(status) {
				//drawUtil = highDrawUtil;
			}
			if(status) {
				drawUtil.setLineColor(AppContext.getDrawUtil().getReverseColor(outlineColor));//????边线颜色 
				drawUtil.setLineWidth(outlineWidth);//????边线宽度
				drawUtil.setFillColor(AppContext.getDrawUtil().getReverseColor(color));
				drawUtil.setFill(true);
			} else {
				drawUtil.setLineColor(outlineColor);//????边线颜色 
				drawUtil.setLineWidth(outlineWidth);//????边线宽度
				drawUtil.setFillColor(color);
				drawUtil.setFill(true);
			}
			var cx:Number = size + 2;
			var cy:Number = size + 2;
	        //AppContext.getAppUtil().alert("showVector cx="+cx+",cy="+cy);
			// 绘制圆
			if(type == 0) {
				drawUtil.drawCircle(cx,cy,size);//AppContext.getAppUtil().alert("111 cx="+cx+",cy="+cy+",size="+size);
	        } else if(type == 1) { // 绘制方框
				drawUtil.drawRect(cx-size-2,cy-size-2,cx+size+2,cy+size+2);
	        } else {
	        	AppContext.getAppUtil().alert("矢量点符号无法绘制图形，点符号类型("+type+")不对！");
	        }
		}
		// 绘制符号
		public override function updateVector() : void {
			if(bounds == null) {
				if(record != null && record.getGeometry() != null) {
					bounds = record.getGeometry().getBounds().toBox();
				} else {
					bounds = geometry.getBounds().toBox();
				}
			}
			var cx:Number = coord.mapToViewX(bounds.getCenterX());
			var cy:Number = coord.mapToViewY(bounds.getCenterY());
	        //AppContext.getAppUtil().alert("updateVector cx="+cx+",cy="+cy);
			cx += offsetx;
			cy += offsety;
			this.x = cx - size - 2;
			this.y = cy - size - 2;
			this.width = size * 2 + 4;
			this.height = size * 2 + 4;
		}
		public override function clear() : void {
			graphics.clear();
		}
		
		public override function hitTest(x:Number, y:Number):int {
			var span:Number = size<5?5:size;
			var bounds:Box = new Box();
			bounds.setBox(x-span,y-span,x+span,y+span);
			var coord:Coordinate = getCoordinate();
			var cx:Number = coord.mapToViewX(this.bounds.getCenterX());
			var cy:Number = coord.mapToViewY(this.bounds.getCenterY());
			if(bounds.isContain(cx,cy)) {
				return 0;
			}
			return -1;
		}
		
		public override function hitRectTest(minx:Number, miny:Number, maxx:Number, maxy:Number):Boolean {
			var span:Number = size<5?5:size;
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
		
		public override function moveControlPoint(hotPoint:int, offsetx:int, offsety:int):void {
			if(hotPoint>=0) {
				this.offsetx = offsetx;
				this.offsety = offsety;
			}
		}

		// 将某个控制点偏移量更新到实际的对象中
		public override function updateControlPoint(update:Boolean):void {
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
	}
}