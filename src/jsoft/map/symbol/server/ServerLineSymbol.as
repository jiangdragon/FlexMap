package jsoft.map.symbol.server
{
	public class ServerLineSymbol extends ServerBaseSymbol
	{
		private var width:int;
		private var color:String;
		private var flare:Number=0;
		
		public function ServerLineSymbol()
		{
		}
		
		public override function getSymbolName():String {
			return "ServerLineSymbol";
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
		
		public function getFlare():Number {
			return flare;
		}
		
		public function setFlare(flare:Number):void {
			this.flare = flare;
		}

	}
}