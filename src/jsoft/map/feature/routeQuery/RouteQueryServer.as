package jsoft.map.feature.routeQuery
{
	import flash.external.ExternalInterface;
	
	import jsoft.map.feature.FeatureCallBack;
	import jsoft.map.feature.FeatureServer;
	import jsoft.map.feature.query.XMLUtil;

	public class RouteQueryServer implements FeatureCallBack
	{
		private var server:FeatureServer = new FeatureServer(1);
		private var layerName:String = "";
		private var fieldName:String = "";
		private var sx:Number = 0;
		private var sy:Number = 0;
		private var ex:Number = 0;
		private var ey:Number = 0;
		
		public function RouteQueryServer()
		{
		}
		
		public function setSX(_sx:Number):void{
			sx = _sx;
		}
		public function getSX():Number{
			return sx;
		}
		public function setSY(_sy:Number):void{
			sy = _sy;
		}
		public function getSY():Number{
			return sy;
		}
		public function setEX(_ex:Number):void{
			ex = _ex;
		}
		public function getEX():Number{
			return ex;
		}
		public function setEY(_ey:Number):void{
			ey = _ey;
		}
		public function getEY():Number{
			return ey;
		}
		public function setLayerName(_layerName:String):void{
			layerName = _layerName;
		}
		public function getLayerName():String{
			return layerName;
		}
		public function setFieldName(_fieldName:String):void{
			fieldName = _fieldName;
		}
		public function getFieldName():String{
			return fieldName;
		}
		
		public function sendRouteQuery():void{
			server.setFeatureCallBack(this);
			server.addNumParam("sx",sx);
			server.addNumParam("sy",sy);
			server.addNumParam("ex",ex);
			server.addNumParam("ey",ey);
			server.processMapEvent("routeQuery");
		}
		public function sendCreateRoute():void{
			server.setFeatureCallBack(this);
			server.addStringParam("layerName",layerName);
			server.addStringParam("fieldName",fieldName);
			server.processMapEvent("createRouteMoudle");
		}

		public function onResult(xml:XML):void
		{
			var js:String = new XMLUtil(xml).toJS();
			ExternalInterface.call("fMap.getFRouteQuery().routeQueryBack",js);
		}
		
		public function onResultStr(result:String):void
		{
			ExternalInterface.call("fMap.getFRouteQuery().routeQueryBack",result);
		}
		
		public function onError():void
		{
			AppContext.getAppUtil().alert("Cannot execute routeQuery("+server.getServer()+")");
		}
		
	}
}