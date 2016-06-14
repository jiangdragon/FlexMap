package jsoft.map.symbol.server
{
	public class ServerPolySymbol extends ServerBaseSymbol
	{
		private var width:int;
		private var color:String;
		private var fillColor:String;
		private var opacity:Number;
		private var flare:Number=0;
		
		public function ServerPolySymbol()
		{
		}
		
		public override function getSymbolName():String {
			return "ServerPolySymbol";
		}
		
		public function getWidth():int {
			return width;
		}
		
		public function setWidth(width:int):void {
			this.width = width;
		}
		
		public function getColor():String {
			return color;
		}
		
		public function setColor(color:String):void {
			this.color = color;
		}
		
		public function getFillColor():String {
			return fillColor;
		}
		
		public function setFillColor(fillColor:String):void {
			this.fillColor = fillColor;
		}
		
		public function getOpacity():Number {
			return opacity;
		}
		
		public function setOpacity(opacity:Number):void {
			this.opacity = opacity;
		}
		
		public function getFlare():Number {
			return flare;
		}
		
		public function setFlare(flare:Number):void {
			this.flare = flare;
		}

	}
}