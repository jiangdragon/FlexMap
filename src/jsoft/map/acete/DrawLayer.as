package jsoft.map.acete
{
	import flash.events.Event;
	
	import jsoft.map.config.MapLevel;
	import jsoft.map.content.MapContent;
	import jsoft.map.content.MapLayer;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Line;
	import jsoft.map.symbol.ImageWinPointSymbol;
	import jsoft.map.symbol.Symbol;
	import jsoft.map.util.Map;
	
	import mx.core.UIComponent;
	
	public class DrawLayer extends UIComponent implements MapLayer
	{
		private var content:MapContent;
		private var centerX:Number;
		private var centerY:Number;
		private var symbols:Array = new Array();
		private var wins:Map = new Map();
		public function DrawLayer(content:MapContent) {
			this.content = content;
		}
		
		public function initLayer(layer:MapLayer):void {
			addEventListener(Event.RESIZE, onResize);
			onResize(null);
		}
		
		private function onResize(event:Event):void {
			refresh();
		}
		public function clearTiles():void {
		}
		//删除图层
		public function removeLayer():void {
			if(content.contains(this)) {
				content.removeChild(this);
			}
		}
		//获取窗体mapping(key-value)
		public function getHashMap():Map{
			return wins;
		}
		public function addSymbol(symbol:Symbol):void {
			symbols.push(symbol);
			this.addChild(symbol);
			var coord:Coordinate = content.getCoordinate();
			symbol.showSymbol(coord);
			//带输入窗口的image 2012/03/28
			if(symbol is ImageWinPointSymbol){
				wins.put(symbol.getSymbolId(),symbol.getSymbolId()+"hot");
			}
			//AppContext.getAppUtil().alert("addSymbol symbols.length="+symbols.length);
		}
		public function removeSymbol(symbol:Symbol):void {
			//AppContext.getAppUtil().alert("removeSymbolById symbols.length="+symbols.length);
			var newSym:Array = new Array();
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				if(sym == symbol) {
					if(this.contains(sym)) {
						this.removeChild(sym);
					}
				} else {
					newSym.push(sym);
				}
			}
			symbols = newSym;
		}
		public function removeSymbolById(id:String):void {
			//AppContext.getAppUtil().alert("removeSymbolById symbols.length="+symbols.length+",id="+id);
			//AppContext.getAppUtil().alert("sym=");
			var newSym:Array = new Array();
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				if(sym.getSymbolId() == id) {
					if(this.contains(sym)) {
						this.removeChild(sym);
					}
				} else {
					newSym.push(sym);
				}
			}
			symbols = newSym;
		}
		public function removeSymbolByGroup(group:String):void {
			//AppContext.getAppUtil().alert("removeSymbolByGroup symbols.length="+symbols.length);
			var newSym:Array = new Array();
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				if(sym.getGroup() == group) {
					if(this.contains(sym)) {
						this.removeChild(sym);
					}
				} else {
					newSym.push(sym);
				}
			}
			symbols = newSym;
		}
		public function getSymbolIds():String {
			var str:String = "";
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				if(sym.getSymbolId()!=null&&sym.getSymbolId()!="") {
					if(str == "") {
						str = sym.getSymbolId();
					} else {
						str += "," + sym.getSymbolId();
					}
				}
			}
			return str;
		}
		public function getSymbolGroups():String {
			var str:String = "";
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				if(sym.getGroup()!=null&&sym.getGroup()!="") {
					if(str == "") {
						str = sym.getGroup();
					} else {
						str += "," + sym.getGroup();
					}
				}
			}
			return str;
		}
		public function setSymbolIdVisible(id:String,visible:Boolean):void{
			var coord:Coordinate = content.getCoordinate();
			for(var i:int=0;i<symbols.length;i++){
				var sym:Symbol = symbols[i];
				if(sym.getSymbolId()==id){
					if(visible){
						sym.showSymbol(coord);
					}else{
						sym.clear();
						//清图片
						while(sym.numChildren > 0){
							sym.removeChildAt(0);
						}
					}
					sym.visible = visible;
				}
			}
		}
		public function setSymbolGroupVisible(group:String,visible:Boolean):void{
			var coord:Coordinate = content.getCoordinate();
			for(var i:int=0;i<symbols.length;i++){
				var sym:Symbol = symbols[i];
				if(sym.getGroup() == group){
					if(visible){
						sym.showSymbol(coord);
					}else{
						sym.clear();
						//清图片
						while(sym.numChildren > 0){
							sym.removeChildAt(0);
						}
					}
					sym.visible = visible;
				}
			}
		}
		public function getLocationById(id:String):String {
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				if(sym.getSymbolId()==id) {
					var str:String = "";
					str = sym.getCenterX() + "," + sym.getCenterY();
					return str;
				}
			}
			return str;
		}
		public function getLocationByGroup(group:String):String {
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				if(sym.getGroup()==group) {
					var str:String = "";
					str = sym.getCenterX() + "," + sym.getCenterY();
					return str;
				}
			}
			return str;
		}
		public function moveToById(id:String,x:Number,y:Number):void {
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				if(sym.getSymbolId()==id) {
					sym.setCenter(x,y);
				}
			}
		}
		public function moveToByGroup(group:String,x:Number,y:Number):void {
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				if(sym.getGroup()==group) {
					sym.setCenter(x,y);
				}
			}
		}
		public function moveById(id:String,speed:Number,line:Line,viewFlag:Boolean):void {
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				if(sym.getSymbolId()==id) {
					sym.moveAnimate(speed,line,viewFlag);
				}
			}
		}
		public function moveByGroup(group:String,speed:Number,line:Line,viewFlag:Boolean):void {
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				if(sym.getGroup()==group) {
					sym.moveAnimate(speed,line,viewFlag);
				}
			}
		}
		public function pauseAnimate():void {
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				sym.pauseAnimate();
			}
		}
		public function resumeAnimate():void {
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				sym.resumeAnimate();
			}
		}
		public function stopAnimate():void {
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				sym.stopAnimate();
			}
		}
		public function clear():void {
			//AppContext.getAppUtil().alert("clear symbols.length="+symbols.length);
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				if(this.contains(sym)) {
					this.removeChild(sym);
				}
			}
			symbols = new Array();
		}
		//  杞藉叆鍥剧墖
		public function loadTiles(x:Number,y:Number):void {
			centerX = x;
			centerY = y;
		}

		//  鏄剧ず鍥剧墖
		public function showMap(x:Number,y:Number):void {
			//AppContext.getAppUtil().alert("showMap");
			centerX = x;
			centerY = y;
			var coord:Coordinate = content.getCoordinate();
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				sym.showSymbol(coord);
			}
		}
		
		public function showZoomMap(zoomLevelIndex:int):void {
			var level:MapLevel = content.getMapConfig().getMapLevel(zoomLevelIndex);
			var coord:Coordinate = level.createCoordinate(width,height);
			coord.setCenter(centerX,centerY);
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				sym.showSymbol(coord);
				sym.updateSymbol();
			}
		}
		
		private function toInt(val:Number):int {
			var ret:int = val;
			if(ret < val) {
				ret++;
			}
			return ret;
		}
		
		// 鍒锋柊鍦板浘
		public function refresh():void {
			//AppContext.getAppUtil().alert("refresh symbols.length="+symbols.length);
			x = 0;
			y = 0;
			this.width = content.width;
			this.height = content.height;
			if(!content.contains(this)) {
				content.addChild(this);
			}
			for(var i:int=0;i<symbols.length;i++) {
				var sym:Symbol = symbols[i];
				sym.updateSymbol();
				sym.x += content.getShowOffsetX();
				sym.y += content.getShowOffsetY();
			}
		}
		// 鑾峰彇涓績鐐瑰潗鏍?
		public function getCenterX():Number {
			return centerX;
		}
		
		// 鑾峰彇涓績鐐瑰潗鏍?
		public function getCenterY():Number {
			return centerY;
		}

	}
}