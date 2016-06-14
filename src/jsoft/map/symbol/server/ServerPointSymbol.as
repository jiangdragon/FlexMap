package jsoft.map.symbol.server
{
	public class ServerPointSymbol extends ServerBaseSymbol
	{
		private var width:int=0;
		private var outlineWidth:int=0;
		private var height:int=0;
		private var type:int=0;
		private var color:String="";
		private var outlineColor:String="";
		private var image:String="";
		private var flare:Number=0;
		
		public function ServerPointSymbol() {
		}
		
		public override function getSymbolName():String {
			return "ServerPointSymbol";
		}
		
		public function getWidth():int {
			return width;
		}
		
		public function setWidth(width:int):void {
			this.width = width;
		}
		
		public function getOutlineWidth():int {
			return outlineWidth;
		}
		
		public function setOutlineWidth(width:int):void {
			this.outlineWidth = width;
		}
		
		public function getHeight():int {
			return height;
		}
		
		public function setHeight(height:int):void {
			this.height = height;
		}
		
		public function getType():int {
			return type;
		}
		
		public function setType(type:int):void {
			this.type = type;
		}
		
		public function getColor():String {
			return color;
		}
		
		public function setColor(color:String):void {
			this.color = color;
		}
		
		public function getOutlineColor():String {
			return outlineColor;
		}
		
		public function setOutlineColor(color:String):void {
			this.outlineColor = color;
		}
		
		public function getImage():String {
			return image;
		}
		
		public function setImage(image:String):void {
			this.image = image;
		}
		
		public function getFlare():Number {
			return flare;
		}
		
		public function setFlare(flare:Number):void {
			this.flare = flare;
		}

	}
}