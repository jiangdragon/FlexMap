package jsoft.map.symbol
{
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.MultiPoint;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Record;
	
	import mx.charts.ChartItem;
	import mx.charts.PieChart;
	import mx.charts.series.PieSeries;
	import mx.collections.ArrayCollection;
	import mx.graphics.IFill;
	import mx.graphics.SolidColor;
	import mx.utils.URLUtil;
	
	public class PieSymbol extends Symbol
	{
		private var nameAry:Array = new Array();
		private var value:Array = new Array();
		private var color:Array = new Array();
		private var size:int = 5;
		private var opacity:Number = 1;
		private var chart:PieChart;
		
		public function PieSymbol() {
		}
		
		public override function clone():Symbol {
			var symbol:PieSymbol = new PieSymbol();
			copyTo(symbol);
			return symbol;
		}
		
		public override function copyTo(symbol:Symbol):void {
			super.copyTo(symbol);
			var point:PieSymbol = symbol as PieSymbol;
			for(var i:int=0;i<nameAry.length;i++) {
				point.nameAry.push(nameAry[i]);
				point.value.push(value[i]);
				point.color.push(color[i]);
			}
			point.opacity=opacity;
			point.size = size;
		}
		
		public override function getSymbolString():String {
			return "PieSymbol";
		}
		
		public function setNameAry(_nameAry:Array):void {
			nameAry = _nameAry;
		}
		public function getNameAry():Array {
	        return nameAry;
	    }
		public function setValue(_value:Array):void {
			value = _value;
		}
		public function getValue():Array {
	        return value;
	    }
		public function setColor(_color:Array):void {
			color = _color;
		}
		public function getColor():Array {
	        return color;
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
			//AppContext.getAppUtil().alert("drawSinglePoint geometry="+geometry);
			var point:FPoint = geometry as FPoint;
			var x:Number = point.getX();
			var y:Number = point.getY();
			
			if(this.numChildren > 0) {
				chart = this.getChildAt(0) as PieChart;
				return;//by--小江修改
			} else {
				chart = new PieChart();
			}
			
			chart.x = 0;
			chart.y = 0;
			chart.percentWidth = 100;
			chart.percentHeight = 100;
			chart.showDataTips = true;
			chart.dataProvider = getDataProvider();
			
            var series:PieSeries = new PieSeries();
            series.nameField = "name";
            series.field = "value";
            /* Remove default dropshadow filter. */
            series.filters = [];
            series.fillFunction = getFillColor;
	
			chart.series = [series];
			
			addChild(chart);
	    }
	    private function getField() : String {
	    	var ret:String = "";
	    	for(var i:int=0;i<nameAry.length;i++) {
	    		if(i>0) {
	    			ret += ",";
	    		}
	    		ret += nameAry[i];
	    	}
	    	return ret;
	    }
	    private function getFillColor(item:ChartItem,index:Number):IFill {
	    	var ci:int = index;
	    	ci = ci % color.length;
	    	var c:int = color[ci];
	    	var fill:SolidColor = new SolidColor(c);
	    	fill.alpha = opacity;
	    	return fill;
	    }
	    private function getObject():Object {
	    	var s:String = "name=" + "";
	    	for(var i:int=0;i<nameAry.length;i++) {
	    		s += ";" + nameAry[i] + "=" + this.value[i];
	    	}
	    	var obj:Object = URLUtil.stringToObject(s);
	    	return obj;
	    }
	    private function getDataProvider():ArrayCollection {
			var dataProvider:ArrayCollection = new ArrayCollection();
	    	for(var i:int=0;i<nameAry.length;i++) {
	    		dataProvider.addItem(getObjectByIndex(i));
	    	}
	    	return dataProvider;
	    }
	    private function getObjectByIndex(index:int):Object {
	    	var s:String = "name=" + nameAry[index] + ";value=" + value[index];
	    	var obj:Object = URLUtil.stringToObject(s);
	    	return obj;
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
			if(chart != null) {
				chart.x = 0;
				chart.y = 0;
				chart.width = size * 2;
				chart.height = size * 2;
			}
	    }

	}
}