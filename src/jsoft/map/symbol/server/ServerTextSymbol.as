package jsoft.map.symbol.server
{
	public class ServerTextSymbol extends ServerBaseSymbol
	{
		private var fontName:String;
		private var fontSize:int;
		private var fontColor:String;
		private var fontBackColor:String;
		private var fontBackOutlineColor:String;
		private var fontShadowColor:String;
		private var flare:Number=0;
		
		public function ServerTextSymbol()
		{
		}
		
		public override function getSymbolName():String {
			return "ServerTextSymbol";
		}
		
		public function getFontName():String {
			return fontName;
		}
		
		public function setFontName(fontName:String):void {
			this.fontName = fontName;
		}
		
		public function getFontSize():int {
			return fontSize;
		}
		
		public function setFontSize(fontSize:int):void {
			this.fontSize = fontSize;
		}
		
		public function getFontColor():String {
			return fontColor;
		}
		
		public function setFontColor(fontColor:String):void {
			this.fontColor = fontColor;
		}
		
		public function getFontBackColor():String {
			return fontBackColor;
		}
		
		public function setFontBackColor(fontBackColor:String):void {
			this.fontBackColor = fontBackColor;
		}
		
		public function getFontBackOutlineColor():String {
			return fontBackOutlineColor;
		}
		
		public function setFontBackOutlineColor(fontBackOutlineColor:String):void {
			this.fontBackOutlineColor = fontBackOutlineColor;
		}
		
		public function getFontShadowColor():String {
			return fontShadowColor;
		}
		
		public function setFontShadowColor(fontShadowColor:String):void {
			this.fontShadowColor = fontShadowColor;
		}
		
		public function getFlare():Number {
			return flare;
		}
		
		public function setFlare(flare:Number):void {
			this.flare = flare;
		}
	}
}