package jsoft.map.symbol
{
	import flash.events.Event;
	
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.MultiLine;
	import jsoft.map.geometry.Record;
	import jsoft.map.util.SymbolUtil;
	
	public class LineDynSymbol extends Symbol
	{
		private var color:int=0x000000;
		private var lightColor:int=AppContext.getDrawUtil().getRed();
		private var weight:int=1;	
		private var startArrow:String  = LineStyle.ARROW_NO; //线起始点形状 无箭头
		private var endArrow:String  = LineStyle.ARROW_NO;           //线结束点形状 无箭头
		private var dashStyle:String  = LineStyle.DASHSTYLE_SOLID ;  //线形状 实线
		// -1 代表不停闪烁，0代表不闪烁，>0代表闪烁次数
		private var flare:int = 0;
		private var flareCount:int = 0;
		private var flag:Boolean = true;
		private var maxCount:int=3;
		private var count:int=maxCount;
		
		public function LineDynSymbol() {
		}
		
		public override function clone():Symbol {
			var symbol:LineDynSymbol = new LineDynSymbol();
			copyTo(symbol);
			return symbol;
		}
		
		public override function copyTo(symbol:Symbol):void {
			super.copyTo(symbol);
			var point:LineDynSymbol = symbol as LineDynSymbol;
			point.color = color;
			point.lightColor = lightColor;
			point.weight = weight;
			point.startArrow=startArrow;
			point.endArrow=endArrow;
			point.dashStyle=dashStyle;
			point.flare=flare;
			point.flareCount=flare;
		}
		
		public override function getSymbolString():String {
			return "LineDynSymbol";
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
		private function drawSingleLine(geometry:Geometry):void {
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
			var c:int = color;
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
				c = color;
			} else {
				c = lightColor;
			}
			
			var tArrow:LineArrow=new LineArrow();
            tArrow.setDrawUtil(drawUtil);
            tArrow.setLineColor(c);
            tArrow.setLinewidth(weight);
            tArrow.drawLineArrow(startArrow,endArrow,xAry,yAry);
            
			graphics.lineStyle(weight,c);
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