package jsoft.map.symbol
{
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.MultiLine;
	import jsoft.map.geometry.Record;
	import jsoft.map.util.SymbolUtil;
	
	public class LineSymbol extends Symbol
	{
		private var color:int=0x000000;
		private var weight:int=1;	
		private var startArrow:String  = LineStyle.ARROW_NO; //线起始点形状 无箭头
		private var endArrow:String  = LineStyle.ARROW_NO;           //线结束点形状 无箭头
		private var dashStyle:String  = LineStyle.DASHSTYLE_SOLID ;  //线形状 实线
		
		public function LineSymbol() {
		}
		
		public override function clone():Symbol {
			var symbol:LineSymbol = new LineSymbol();
			copyTo(symbol);
			return symbol;
		}
		
		public override function copyTo(symbol:Symbol):void {
			super.copyTo(symbol);
			var point:LineSymbol = symbol as LineSymbol;
			point.color = color;
			point.weight = weight;
			point.startArrow=startArrow;
			point.endArrow=endArrow;
			point.dashStyle=dashStyle;
		}
		
		public override function getSymbolString():String {
			return "LineSymbol";
		}
		
		public function setColor(_color:int):void {
			color = _color;
		}
		public function getColor():int {
			return color;
		}
		public function setWidth(inwidth:int):void{
			this.weight = inwidth;
		}
		public function getWidth():int{
			return weight;
		}
		
		public function setStartArrow (inArrow:String):void{
			startArrow = inArrow;
		}
		public function getStartArrow ():String{
			return startArrow;
		}
		
		public function setEndArrow(inArrow:String):void{
			endArrow = inArrow;
		}
		public function getEndArrow ():String{
			return endArrow;
		}
		
		public function setDashStyle (inStyle:String):void{
			dashStyle =inStyle;
		}
		public function getDashStyle ():String{
			return dashStyle;
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
			if(geometry.getGeometryName() == "Line"){
				drawSingleLine(geometry);
				return;
			}
			if(geometry.getGeometryName() == "MultiLine"){
				var mline:MultiLine = geometry as MultiLine;
				for(var i:int=0;i<mline.getLineLength();i++) {
					drawSingleLine(mline.getLine(i));
				}
				return;
			}
			AppContext.getAppUtil().alert("线符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
		}
		protected function drawSingleLine(geometry:Geometry):void {
			//AppContext.getAppUtil().alert("drawSinglePoint geometry="+geometry+",type="+type+",color="+color);
			var line:Line = geometry as Line;
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
			var xAry:Array = symbolUtil.getLineViewX(line);
			var yAry:Array = symbolUtil.getLineViewY(line);
			var minx:Number = symbolUtil.getMin(xAry);
			var miny:Number = symbolUtil.getMin(yAry);
			xAry = symbolUtil.getArray(xAry,minx);
			yAry = symbolUtil.getArray(yAry,miny);
			//AppContext.getAppUtil().alert("drawSinglePoint cx="+cx+",cy="+cy+",width="+width+",height="+height);
			drawUtil.clear();
			if(xAry.length<=0&&yAry.length<=0) {
				return;
			}
			var tArrow:LineArrow=new LineArrow();
            tArrow.setDrawUtil(drawUtil);
            tArrow.setLineColor(color);
            tArrow.setLinewidth(weight);
            tArrow.drawLineArrow(startArrow,endArrow,xAry,yAry);
            
			graphics.lineStyle(weight,color);
			symbolUtil.drawLineArray(graphics,xAry,yAry,0,0);
	    }
		public override function updateSymbol():void {
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
			if(record) {
				symbolUtil.updateLine(record.getGeometry(),this);
			}
			if(geometry) {
				symbolUtil.updateLine(geometry,this);
			}
		}

	}
}