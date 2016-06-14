package jsoft.map.dispatch
{
	import flash.external.ExternalInterface;
	
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Polygon;
	import jsoft.map.symbol.server.MapServer;
	import jsoft.map.symbol.server.ServerBaseSymbol;
	import jsoft.map.symbol.server.ServerGroupCallBack;
	import jsoft.map.symbol.server.ServerSymbolGroup;
	import jsoft.map.symbol.server.ServerSymbolListCallBack;
	import jsoft.map.symbol.server.ServerSymbolManager;
	
	public class SymbolDispatcher implements Dispatcher,ServerGroupCallBack,ServerSymbolListCallBack
	{
		private var symbolManager:ServerSymbolManager = new ServerSymbolManager();
		private var mapServer:MapServer = new MapServer();
		
		public function SymbolDispatcher() {
		}

		public function sendMessage(param:DispatchParam):void {
			if(param.Type == "getSymbolGroupList") {
				getSymbolGroupList();
				return;
			}
			if(param.Type == "getSymbolList") {
				getSymbolList(param.vint);
				return;
			}
			if(param.Type == "drawPoint") {
				drawPoint(param.vpoint,param.vint,param.vint);
				return;
			}
			if(param.Type == "drawLine") {
				drawLine(param.vline,param.vint,param.vint);
				return;
			}
			if(param.Type == "drawPoly") {
				drawPoly(param.vpoly,param.vint,param.vint);
				return;
			}
			if(param.Type == "drawText") {
				drawText(param.vpoint,param.vstr,param.vint,param.vint);
				return;
			}
		}
		
		public function drawPoint(point:FPoint,groupId:int,symbolId:int):void {
			if(mapServer != null && mapServer.isEqual(groupId,symbolId)) {
				mapServer.addGeometry(point);
			} else {
				mapServer = new MapServer();
				mapServer.draw(point,"",groupId,symbolId);
			}
		}
		
		public function drawLine(line:Line,groupId:int,symbolId:int):void {
			if(mapServer != null && mapServer.isEqual(groupId,symbolId)) {
				mapServer.addGeometry(line);
			} else {
				mapServer = new MapServer();
				mapServer.draw(line,"",groupId,symbolId);
			}
		}
		
		public function drawPoly(poly:Polygon,groupId:int,symbolId:int):void {
			if(mapServer != null && mapServer.isEqual(groupId,symbolId)) {
				mapServer.addGeometry(poly);
			} else {
				mapServer = new MapServer();
				mapServer.draw(poly,"",groupId,symbolId);
			}
		}
		
		public function drawText(point:FPoint,text:String,groupId:int,symbolId:int):void {
			//AppContext.getAppUtil().alert("groupId="+groupId);
			if(mapServer != null && mapServer.isEqual(groupId,symbolId)) {
				mapServer.addGeometry(point,text);
			} else {
				mapServer = new MapServer();
				mapServer.draw(point,text,groupId,symbolId);
			}
		}
		
		public function getMessage(param:DispatchParam):String {
			if(param.Type == "getSymbolImage") {
				var p:String = "g="+param.vstr+"&s="+param.vstr+"&w="+param.vstr+"&h="+param.vstr+"&a="+param.vstr;
				var url:String = symbolManager.getSymbolEvent("getSymbolImage",p);
				return url;
			}
			return null;
		}
		
		private function getSymbolGroupList() : void {
			symbolManager.getSymbolGroupList(this);
		}
		
		private function getSymbolList(groupId:int) : void {
			symbolManager.getSymbolList(groupId,this);
		}
		
		public function onServerGroupRecv(symbolGroupList:Array):void {
			var idList:String = null;
			var nameList:String = null;
			var typeList:String = null;
			//AppContext.getAppUtil().alert("symbolGroupList="+symbolGroupList.length);
			for(var i:int=0;symbolGroupList!=null&&i<symbolGroupList.length;i++) {
				var symbolGroup:ServerSymbolGroup = symbolGroupList[i];
				idList=addList(idList,symbolGroup.getId()+"");
				nameList=addList(nameList,symbolGroup.getName());
				typeList=addList(typeList,symbolGroup.getType());
			}
			ExternalInterface.call("fMap.getFSymbol().getSymbolGroupListBack",idList,nameList,typeList);
		}
		
		public function onServerSymbolRecv(symbolList:Array):void {
			var idList:String = null;
			var nameList:String = null;
			for(var i:int=0;symbolList!=null&&i<symbolList.length;i++) {
				var symbol:ServerBaseSymbol = symbolList[i];
				idList=addList(idList,symbol.getId()+"");
				nameList=addList(nameList,symbol.getName());
			}
			ExternalInterface.call("fMap.getFSymbol().getSymbolListBack",idList,nameList);
		}
		
		private function addList(list:String,value:String) : String {
			if(list==null) {
				return value;
			} else {
				return list + "," + value;
			}
		}
	}
}