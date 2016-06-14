package jsoft.map.symbol
{
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.util.SymbolUtil;
	
	public class LineSymbolEx extends LineSymbol
	{
		public function LineSymbolEx()
		{
			super();
		}
		public override function getSymbolString():String{
			return "LineSymbolEx";
		}
		protected override function drawSingleLine(geometry:Geometry):void{
			var line:Line = geometry as Line;
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
			var xAry:Array = symbolUtil.getLineViewX(line);
			var yAry:Array = symbolUtil.getLineViewY(line);
			var minx:Number = symbolUtil.getMin(xAry);
			var miny:Number = symbolUtil.getMin(yAry);
			xAry = symbolUtil.getArrayEx(xAry,minx);
			yAry = symbolUtil.getArrayEx(yAry,miny);
			drawUtil.clear();
			if(xAry.length<=0&&yAry.length<=0) {
				return;
			}
			var tArrow:LineArrow=new LineArrow();
            tArrow.setDrawUtil(drawUtil);
            tArrow.setLineColor(getColor());
            tArrow.setLinewidth(getWidth());
            tArrow.drawLineArrow(getStartArrow(),getEndArrow(),xAry,yAry);
            
			graphics.lineStyle(getWidth(),getColor());
			symbolUtil.drawLineArray(graphics,xAry,yAry,0,0);
		}
	}
}