package jsoft.map.dispatch
{
	import flash.external.ExternalInterface;
	
	public class DispatchManager
	{
		public function DispatchManager() {
		}
		
		public static function initDispatch():void {
			ExternalInterface.addCallback("sendMessage",sendMessage);
			ExternalInterface.addCallback("getMessage",getMessage);
		}
		
		public static function sendMessage(command:String,type:String,param1:String,param2:String,param3:String,param4:String,param5:String,param6:String,param7:String,param8:String,param9:String,param10:String,param11:String,param12:String,param13:String,param14:String,param15:String):void {
			var dispatcher:Dispatcher = getDispatcher(command);
			var param:DispatchParam = new DispatchParam(type,param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15);
			dispatcher.sendMessage(param);
		}
		
		public static function getMessage(command:String,type:String,param1:String,param2:String,param3:String,param4:String,param5:String,param6:String,param7:String,param8:String,param9:String,param10:String,param11:String,param12:String,param13:String,param14:String,param15:String):String {
			var dispatcher:Dispatcher = getDispatcher(command);
			var param:DispatchParam = new DispatchParam(type,param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15);
			var ret:String = dispatcher.getMessage(param);
			return ret;
		}
		
		private static function getDispatcher(command:String):Dispatcher {
			if("map" == command) {
				return new MapDispatcher();
			}
			if("input" == command) {
				return new InputDispatcher();
			}
			if("query" == command) {
				return new QueryDispatcher();
			}
			if("draw" == command) {
				return new DrawDispatch();
			}
			if("hot" == command) {
				return new HotEventDispatcher();
			}
			if("sym" == command) {
				return new SymbolDispatcher();
			}
			if("vector" == command) {
				return new VectorDispatcher();
			}
			if("thematic" == command) {
				return new ThematicDispatch();
			}
			if("routeQuery" == command) {
				return new RouteQueryDispatch();
			}
			if("wealthQuery" == command){
				return new WealthDispatch();
			}
			return null;
		}
	}
}