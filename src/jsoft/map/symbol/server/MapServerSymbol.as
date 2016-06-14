package jsoft.map.symbol.server
{
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.symbol.Symbol;

	public class MapServerSymbol extends Symbol
	{
		private var symbol:Symbol = null;
		
		public function MapServerSymbol() {
			super();
		}
		public function getSymbol():Symbol {
			return symbol;
		}
		public function setSymbol(sym:Symbol):void {
			this.symbol = sym;
			showSymbol(AppContext.getMapContext().getMapContent().getCoordinate());
			updateSymbol();
		}
		public override function showSymbol(coord:Coordinate):void {
			super.showSymbol(coord);
			if(symbol != null) {
				symbol.showSymbol(coord);
			}
		}
		public override function updateSymbol():void {
			super.updateSymbol();
			if(symbol != null) {
				symbol.updateSymbol();
				x = symbol.x;
				y = symbol.y;
				width = symbol.width;
				height = symbol.height;
				symbol.x = 0;
				symbol.y = 0;
				if(!this.contains(symbol)) {
					this.addChild(symbol);
				}
			} else {
				x = -100;
				y = -100;
				width = 0;
				height = 0;
			}
		}
		public override function clone():Symbol {
			var symbol:MapServerSymbol = new MapServerSymbol();
			copyTo(symbol);
			return symbol;
		}
		public override function copyTo(newSymbol:Symbol):void {
			super.copyTo(newSymbol);
			var sym:MapServerSymbol = newSymbol as MapServerSymbol;
			sym.symbol = this.symbol;
		}
		public override function getSymbolString():String {
			if(symbol != null) {
				return symbol.getSymbolString();
			}
			return "MapServerSymbol";
		}
		
	}
}