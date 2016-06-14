package jsoft.map.symbol.server
{
	import jsoft.map.feature.FeatureCallBack;
	import jsoft.map.feature.FeatureServer;
	
	public class ServerSymbolManager implements FeatureCallBack
	{
		private var serverGroupCallBack:ServerGroupCallBack;
		private var symbolGroupList:Array = null;
		
		private var serverSymbolListCallBack:ServerSymbolListCallBack;
		private var symbolList:Array = null;
		
		private var serverSymbolCallBack:ServerSymbolCallBack;
		private var serverBaseSymbol:ServerBaseSymbol = null;
		
		public function ServerSymbolManager() {
		}
		
		public function getSymbolGroupList(serverGroupCallBack:ServerGroupCallBack):void {
			this.serverGroupCallBack = serverGroupCallBack;
			this.serverSymbolCallBack = null;
			this.serverSymbolCallBack = null;
			
			var featureServer:FeatureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.processMapEvent("getSymbolGroupList",null);
			//AppContext.getAppUtil().alert("ServerSymbolManager.getSymbolGroupList symbolGroupList="+symbolGroupList);
		}
		
		public function getSymbolList(groupId:int,serverSymbolListCallBack:ServerSymbolListCallBack):void {
			this.serverGroupCallBack = null;
			this.serverSymbolCallBack = null;
			this.serverSymbolListCallBack = serverSymbolListCallBack;
			
			var featureServer:FeatureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.processMapEvent("getSymbolList","g="+groupId);
			//AppContext.getAppUtil().alert("ServerSymbolManager.getSymbolList symbolList="+symbolList);
		}
		
		public function getSymbol(groupId:int,symbolId:int,serverSymbolCallBack:ServerSymbolCallBack):void {
			if(serverBaseSymbol != null) {
				if(serverBaseSymbol.getGroupId()==groupId&&serverBaseSymbol.getId()==symbolId) {
					serverSymbolCallBack.onServerSymbolRecv(serverBaseSymbol);
					return;
				}
			}
			this.serverGroupCallBack = null;
			this.serverSymbolListCallBack = null;
			this.serverSymbolCallBack = serverSymbolCallBack;
			
			var featureServer:FeatureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.processMapEvent("getSymbol","g="+groupId+"&s="+symbolId);
		}
		
		public function getSymbolEvent(eventName:String,param:String) : String {
			var url:String = AppContext.getMapContext().getMapConfigManager().getMapEventUrl(eventName,param);
			return url;
		}
		// 返回请求结果
		public function onResultStr(result:String):void {
		}
		
		// 返回请求结果
		public function onResult(xml:XML):void {
			//AppContext.getAppUtil().alert("ServerSymbolManager.onResult xml="+xml);
			if(xml == null) {
				return;
			}
			symbolGroupList = new Array();
			symbolList = new Array();
			var item:XML;
            for each(item in xml) {
            	parseSymbolGroupList(item);
            	parsePointSymbolList(item);
            	parseLineSymbolList(item);
            	parsePolySymbolList(item);
            	parseTextSymbolList(item);
            }
            if(serverGroupCallBack!=null) {
            	serverGroupCallBack.onServerGroupRecv(symbolGroupList);
            }
            if(serverSymbolListCallBack!=null) {
            	serverSymbolListCallBack.onServerSymbolRecv(symbolList);
            }
            if(serverSymbolCallBack!=null) {
            	if(symbolList!=null&&symbolList.length>0) {
            		serverBaseSymbol = symbolList[0];
            		serverSymbolCallBack.onServerSymbolRecv(symbolList[0]);
            	} else {
            		serverSymbolCallBack.onServerSymbolRecv(null);
            	}
            }
		}
		
		private function parseSymbolGroupList(root:XML) : void {
			var item:XML;
			var groupNode:XMLList = root.elements("group");
            for each(item in groupNode) {
            	var group:ServerSymbolGroup = new ServerSymbolGroup();
            	var id:String = item.attribute("id");
				var name:String = item.attribute("name");
				var type:String = item.attribute("type");
				group.setId(AppContext.getAppUtil().getInt(id));
				group.setName(name);
				group.setType(type);//AppContext.getAppUtil().alert("ServerSymbolManager.onResult group="+group);
				symbolGroupList[symbolGroupList.length]=group;
            }
		}
		
		private function parsePointSymbolList(root:XML) : void {
			var item:XML;
			var pointNode:XMLList = root.elements("point");
            for each(item in pointNode) {
            	var point:ServerPointSymbol = new ServerPointSymbol();
            	var id:String = item.attribute("id");
            	var groupId:String = item.attribute("groupId");
				var name:String = item.attribute("name");
            	var width:String = item.attribute("width");
            	var outlineWidth:String = item.attribute("outlineWidth");
            	var height:String = item.attribute("height");
            	var type:String = item.attribute("type");
            	var color:String = item.attribute("color");
            	var outlineColor:String = item.attribute("outlineColor");
            	var image:String = item.attribute("image");
				var flare:String = item.attribute("flare");
				point.setId(AppContext.getAppUtil().getInt(id));
				point.setGroupId(AppContext.getAppUtil().getInt(groupId));
				point.setName(name);
				point.setWidth(AppContext.getAppUtil().getInt(width));
				point.setOutlineWidth(AppContext.getAppUtil().getInt(outlineWidth));
				point.setHeight(AppContext.getAppUtil().getInt(height));
				point.setType(AppContext.getAppUtil().getInt(type));
				point.setColor(color);
				point.setOutlineColor(outlineColor);
				point.setImage(image);
				point.setFlare(AppContext.getAppUtil().getInt(flare));
				symbolList[symbolList.length]=point;
            }
		}
		
		private function parseLineSymbolList(root:XML) : void {
			var item:XML;
			var lineNode:XMLList = root.elements("line");
            for each(item in lineNode) {
            	var line:ServerLineSymbol = new ServerLineSymbol();
            	var id:String = item.attribute("id");
            	var groupId:String = item.attribute("groupId");
				var name:String = item.attribute("name");
            	var width:String = item.attribute("width");
            	var color:String = item.attribute("color");
				var flare:String = item.attribute("flare");
				line.setId(AppContext.getAppUtil().getInt(id));
				line.setGroupId(AppContext.getAppUtil().getInt(groupId));
				line.setName(name);
				line.setWidth(AppContext.getAppUtil().getInt(width));
				line.setColor(color);
				line.setFlare(AppContext.getAppUtil().getInt(flare));
				symbolList[symbolList.length]=line;
            }
		}
		
		private function parsePolySymbolList(root:XML) : void {
			var item:XML;
			var polygonNode:XMLList = root.elements("polygon");
            for each(item in polygonNode) {
            	var polygon:ServerPolySymbol = new ServerPolySymbol();
            	var id:String = item.attribute("id");
            	var groupId:String = item.attribute("groupId");
				var name:String = item.attribute("name");
            	var width:String = item.attribute("width");
            	var color:String = item.attribute("color");
            	var fillColor:String = item.attribute("fillColor");
            	var opacity:String = item.attribute("opacity");
				var flare:String = item.attribute("flare");
				polygon.setId(AppContext.getAppUtil().getInt(id));
				polygon.setGroupId(AppContext.getAppUtil().getInt(groupId));
				polygon.setName(name);
				polygon.setWidth(AppContext.getAppUtil().getInt(width));
				polygon.setColor(color);
				polygon.setFillColor(fillColor);
				polygon.setOpacity(AppContext.getAppUtil().getNumber(opacity));
				polygon.setFlare(AppContext.getAppUtil().getInt(flare));
				symbolList[symbolList.length]=polygon;
            }
		}
		
		private function parseTextSymbolList(root:XML) : void {
			var item:XML;
			var polygonNode:XMLList = root.elements("text");
            for each(item in polygonNode) {
            	var text:ServerTextSymbol = new ServerTextSymbol();
            	var id:String = item.attribute("id");
            	var groupId:String = item.attribute("groupId");
				var name:String = item.attribute("name");
            	var fontName:String = item.attribute("font");
            	var fontSize:String = item.attribute("size");
            	var fontColor:String = item.attribute("color");
            	var fontBackColor:String = item.attribute("backColor");
            	var fontBackOutlineColor:String = item.attribute("backOutlineColor");
            	var fontShadowColor:String = item.attribute("shadowColor");
				var flare:String = item.attribute("flare");
            	
				text.setId(AppContext.getAppUtil().getInt(id));
				text.setGroupId(AppContext.getAppUtil().getInt(groupId));
				text.setName(name);
				text.setFontName(fontName);
				text.setFontSize(AppContext.getAppUtil().getInt(fontSize));
				text.setFontColor(fontColor);
				text.setFontBackColor(fontBackColor);
				text.setFontBackOutlineColor(fontBackOutlineColor);
				text.setFontShadowColor(fontShadowColor);
				text.setFlare(AppContext.getAppUtil().getInt(flare));
				symbolList[symbolList.length]=text;
            }
		}
		
		// 请求错误
		public function onError():void {
		}

	}
}