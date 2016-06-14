package jsoft.map.symbol.server
{
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.symbol.DynPointSymbol;
	import jsoft.map.symbol.DynPointSymbolEx;
	import jsoft.map.symbol.ImagePointSymbol;
	import jsoft.map.symbol.LableSymbol;
	import jsoft.map.symbol.LineDynSymbol;
	import jsoft.map.symbol.LineSymbol;
	import jsoft.map.symbol.PolygonDynSymbol;
	import jsoft.map.symbol.PolygonSymbol;
	import jsoft.map.symbol.SimplePointSymbol;
	import jsoft.map.symbol.SimplePointSymbolEx;
	import jsoft.map.symbol.Symbol;
	
	public class MapServer implements ServerSymbolCallBack
	{
		private var geometryAry:Array = new Array();
		private var textAry:Array = new Array();
		private var symbolAry:Array = new Array();
		private var serverBaseSymbol:ServerBaseSymbol=null;
		private var groupId:int=-1;
		private var symId:int=-1;
		private var id:String=null;
		
		public function MapServer() {
		}
		
		public function isEqual(groupId:int,symId:int):Boolean {
			if(this.groupId == groupId && this.symId == symId) {
				return true;
			}
			return false;
		}
		
		public function addGeometry(geometry:Geometry,text:String=""):void {
			if(serverBaseSymbol != null) {
				var symbol:Symbol = createServerSymbol(serverBaseSymbol,geometry,text);
				if(symbol == null) {
					return;
				}
				symbol.setSymbolId(id);
				AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
			} else {
				geometryAry[geometryAry.length] = geometry;
				textAry[textAry.length] = text;
				var mapServerSymbol:MapServerSymbol = new MapServerSymbol();
				mapServerSymbol.setSymbolId(id);
				symbolAry[symbolAry.length] = mapServerSymbol;
				AppContext.getMapContext().getMapDrawLayer().addSymbol(mapServerSymbol);
			}
		}
		
		public function draw(geometry:Geometry,text:String="",groupId:int=1,symId:int=1,id:String=""):void {
			addGeometry(geometry,text);
			this.groupId = groupId;
			this.symId = symId;
			this.id = id;
			var serverSymbolManager:ServerSymbolManager = new ServerSymbolManager();
			serverSymbolManager.getSymbol(groupId,symId,this);
		}
		
		public function onServerSymbolRecv(serverBaseSymbol:ServerBaseSymbol):void {
			this.serverBaseSymbol = serverBaseSymbol;
			for(var i:int=0;i<geometryAry.length;i++) {
				var symbol:Symbol = createServerSymbol(serverBaseSymbol,geometryAry[i],textAry[i]);
				if(symbol == null) {
					AppContext.getMapContext().getMapDrawLayer().removeSymbol(symbolAry[i]);
				} else {
					symbolAry[i].setSymbol(symbol);
				}
			}
			geometryAry = new Array();
			symbolAry = new Array();
		}
		
		public function createServerSymbol(serverSymbol:ServerSymbol,geometry:Geometry,text:String=""):Symbol {
			if(serverSymbol == null) {
				AppContext.getAppUtil().alert("无法识别的符号，符号不存在!\ngroup id="+groupId+",symbol id="+symId);
				return null;
			}
			var a:Array = new Array();
			a[0] = serverSymbol;
			//AppContext.getAppUtil().alert("serverSymbol="+serverSymbol);
			if(serverSymbol.getSymbolName()=="ServerPointSymbol") {
				var serverPointSymbol:ServerPointSymbol = a[0];
				if(serverPointSymbol.getType() == 4) {
					var pointImageSymbol:ImagePointSymbol = new ImagePointSymbol();
					var url:String = AppContext.getMapContext().getMapConfigManager().getFeatureServer() + serverPointSymbol.getImage();
					pointImageSymbol.setImgUrl(url);
					//AppContext.getAppUtil().alert("serverSymbol image="+url);
					pointImageSymbol.setImgWidth(serverPointSymbol.getWidth());
					pointImageSymbol.setImgHeight(serverPointSymbol.getHeight());
					pointImageSymbol.setGeometry(geometry);
					return pointImageSymbol;
				}
				if(serverPointSymbol.getType()==0||serverPointSymbol.getType()==1) {
					if(serverPointSymbol.getFlare() == -1 || serverPointSymbol.getFlare() > 0) {
						var dynPointSymbol:DynPointSymbol = new DynPointSymbol();
						dynPointSymbol.setColor(AppContext.getAppUtil().getColor(serverPointSymbol.getColor()));
						dynPointSymbol.setType(serverPointSymbol.getType());
						dynPointSymbol.setSize(serverPointSymbol.getWidth());
						dynPointSymbol.setGeometry(geometry);
						dynPointSymbol.setFlare(serverPointSymbol.getFlare());
						return dynPointSymbol;
					} else {
						var simplePointSymbol:SimplePointSymbol = new SimplePointSymbol();
						simplePointSymbol.setColor(AppContext.getAppUtil().getColor(serverPointSymbol.getColor()));
						simplePointSymbol.setType(serverPointSymbol.getType());
						simplePointSymbol.setSize(serverPointSymbol.getWidth());
						simplePointSymbol.setGeometry(geometry);
						return simplePointSymbol;
					}
				}
				if(serverPointSymbol.getFlare() == -1 || serverPointSymbol.getFlare() > 0) {
					var dynPointSymbolEx:DynPointSymbolEx = new DynPointSymbolEx();
					dynPointSymbolEx.setColor(AppContext.getAppUtil().getColor(serverPointSymbol.getColor()));
					dynPointSymbolEx.setType(serverPointSymbol.getType()-2);
					dynPointSymbolEx.setSize(serverPointSymbol.getWidth());
					dynPointSymbolEx.setOutlineWidth(serverPointSymbol.getOutlineWidth());
					dynPointSymbolEx.setOutlineColor(AppContext.getAppUtil().getColor(serverPointSymbol.getOutlineColor()));
					dynPointSymbolEx.setGeometry(geometry);
					dynPointSymbolEx.setFlare(serverPointSymbol.getFlare());
					return dynPointSymbolEx;
				} else {
					var simplePointSymbolEx:SimplePointSymbolEx = new SimplePointSymbolEx();
					simplePointSymbolEx.setColor(AppContext.getAppUtil().getColor(serverPointSymbol.getColor()));
					simplePointSymbolEx.setType(serverPointSymbol.getType()-2);
					simplePointSymbolEx.setSize(serverPointSymbol.getWidth());
					simplePointSymbolEx.setOutlineWidth(serverPointSymbol.getOutlineWidth());
					simplePointSymbolEx.setOutlineColor(AppContext.getAppUtil().getColor(serverPointSymbol.getOutlineColor()));
					simplePointSymbolEx.setGeometry(geometry);
					return simplePointSymbolEx;
				}
			}
			if(serverSymbol.getSymbolName()=="ServerLineSymbol") {
				var serverLineSymbol:ServerLineSymbol = a[0];
				if(serverLineSymbol.getFlare() == -1 || serverLineSymbol.getFlare() > 0) {
					var lineDynSymbol:LineDynSymbol = new LineDynSymbol();
					lineDynSymbol.setWidth(serverLineSymbol.getWidth());
					lineDynSymbol.setColor(AppContext.getAppUtil().getColor(serverLineSymbol.getColor()));
					lineDynSymbol.setGeometry(geometry);
					lineDynSymbol.setFlare(serverPolySymbol.getFlare());
					return lineDynSymbol;
				} else {
					var lineSymbol:LineSymbol = new LineSymbol();
					lineSymbol.setWidth(serverLineSymbol.getWidth());
					lineSymbol.setColor(AppContext.getAppUtil().getColor(serverLineSymbol.getColor()));
					lineSymbol.setGeometry(geometry);
					return lineSymbol;
				}
			}
			if(serverSymbol.getSymbolName()=="ServerPolySymbol") {
				var serverPolySymbol:ServerPolySymbol = a[0];
				if(serverPolySymbol.getFlare() == -1 || serverPolySymbol.getFlare() > 0) {
					var polygonDynSymbol:PolygonDynSymbol = new PolygonDynSymbol();
					polygonDynSymbol.setColor(AppContext.getAppUtil().getColor(serverPolySymbol.getColor()));
					polygonDynSymbol.setFillColor(AppContext.getAppUtil().getColor(serverPolySymbol.getFillColor()));
					polygonDynSymbol.setWeight(serverPolySymbol.getWidth());
					polygonDynSymbol.setOpacity(serverPolySymbol.getOpacity());
					polygonDynSymbol.setGeometry(geometry);
					polygonDynSymbol.setFlare(serverPolySymbol.getFlare());
					return polygonDynSymbol;
				} else {
					var polygonSymbol:PolygonSymbol = new PolygonSymbol();
					polygonSymbol.setColor(AppContext.getAppUtil().getColor(serverPolySymbol.getColor()));
					polygonSymbol.setFillColor(AppContext.getAppUtil().getColor(serverPolySymbol.getFillColor()));
					polygonSymbol.setWeight(serverPolySymbol.getWidth());
					polygonSymbol.setOpacity(serverPolySymbol.getOpacity());
					polygonSymbol.setGeometry(geometry);
					return polygonSymbol;
				}
			}
			if(serverSymbol.getSymbolName()=="ServerTextSymbol") {
				var serverTextSymbol:ServerTextSymbol = a[0];
				var symbol:LableSymbol = new LableSymbol();
				var p:FPoint = geometry as FPoint;
				symbol.setGeometry(p);
				symbol.setFieldValue(text);
				//AppContext.getAppUtil().alert("serverSymbol text="+text);
				symbol.setFontName(serverTextSymbol.getFontName());
				symbol.setColor(AppContext.getAppUtil().getColor(serverTextSymbol.getFontColor()));
				if(serverTextSymbol.getFontBackColor()!=null&&serverTextSymbol.getFontBackColor().length>0) {
					symbol.setBackColor(AppContext.getAppUtil().getColor(serverTextSymbol.getFontBackColor()));
				}
				if(serverTextSymbol.getFontBackOutlineColor()!=null&&serverTextSymbol.getFontBackOutlineColor().length>0) {
					symbol.setBackOutlineColor(AppContext.getAppUtil().getColor(serverTextSymbol.getFontBackOutlineColor()));
				}
				if(serverTextSymbol.getFontShadowColor()!=null&&serverTextSymbol.getFontShadowColor().length>0) {
					symbol.setShadowColor(AppContext.getAppUtil().getColor(serverTextSymbol.getFontShadowColor()));
				}
				return symbol;
			}
			AppContext.getAppUtil().alert("无法识别的符号类型:" + serverSymbol.getSymbolName());
			return null;
		}

	}
}