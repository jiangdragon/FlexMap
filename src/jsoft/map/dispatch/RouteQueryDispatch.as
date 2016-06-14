package jsoft.map.dispatch
{
	import jsoft.map.feature.routeQuery.RouteQueryServer;
	
	public class RouteQueryDispatch implements Dispatcher
	{
		public function RouteQueryDispatch()
		{
		}

		public function sendMessage(param:DispatchParam):void
		{
			if("query" == param.Type) {
				routeQuery(param.vnum,param.vnum,param.vnum,param.vnum);
				return;
			}
			if("createRoute" == param.Type) {
				createRoute(param.vstr,param.vstr);
				return;
			}
		}
		
		public function getMessage(param:DispatchParam):String
		{
			return "";
		}
		
		private function routeQuery(sx:Number,sy:Number,ex:Number,ey:Number):void{
			var server:RouteQueryServer = new RouteQueryServer();
			server.setSX(sx);
			server.setSY(sy);
			server.setEX(ex);
			server.setEY(ey);
			server.sendRouteQuery();
		}
		
		private function createRoute(layerName:String,fieldName:String):void{
			var server:RouteQueryServer = new RouteQueryServer();
			server.setLayerName(layerName);
			server.setFieldName(fieldName);
			server.sendCreateRoute();
		}
	}
}