package jsoft.map.feature.query
{
	import flash.external.ExternalInterface;
	
	import jsoft.map.feature.FeatureCallBack;
	import jsoft.map.feature.FeatureServer;

	public class RectQuery implements FeatureCallBack
	{
		private var param:String;
		private var featureServer:FeatureServer;
		
		public function RectQuery() {
		}
		public function query(source:String,layerName:String,minx:Number,miny:Number,maxx:Number,maxy:Number,around:Number,_where:String,queryFlag:int,maxRecord:int):void {
			var where:String = _where == null?"":_where;
			where=encodeURI(where);
			if(maxRecord==0) {
				maxRecord = 10;
			}
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addStrParam("source",source);
			featureServer.addStrParam("layer",layerName);
			featureServer.addNumParam("minx",minx);
			featureServer.addNumParam("miny",miny);
			featureServer.addNumParam("maxx",maxx);
			featureServer.addNumParam("maxy",maxy);
			featureServer.addNumParam("around",around);
			featureServer.addStrParam("where",where);
			featureServer.addIntParam("queryFlag",queryFlag);
			featureServer.addIntParam("maxPageRecord",maxRecord);
			featureServer.processMapEvent("rectQuery");
		}
		public function onResult(xml:XML) : void {
			var js:String = new XMLUtil(xml).toJS();
			ExternalInterface.call("fMap.getFQuery().queryBack",js);
		}
		// 返回请求结果
		public function onResultStr(result:String):void {
			ExternalInterface.call("fMap.getFQuery().queryBack",result);
		}
		public function onError() : void {
			AppContext.getAppUtil().alert("Cannot execute query("+featureServer.getServer()+"),param="+param);
		}

	}
}