package jsoft.map.feature.query
{
	import flash.external.ExternalInterface;	
	import jsoft.map.feature.FeatureCallBack;
	import jsoft.map.feature.FeatureServer;
	
	public class IdentityQuery implements FeatureCallBack
	{
		private var param:String;
		private var featureServer:FeatureServer;
		public function IdentityQuery()
		{
		}
		public function query(source:String,layerGroup:String,queryValue:String,maxRecord:int):void {
			var around:Number = 0;
			var queryFlag:int = 1;
			if(maxRecord==0) {
				maxRecord = 10;
			}
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addStrParam("source",source);
			featureServer.addStrParam("layerGroup",layerGroup);
			featureServer.addStrParam("queryValue",queryValue);
			featureServer.addNumParam("around",around);
			featureServer.addIntParam("queryFlag",queryFlag);
			featureServer.addIntParam("maxPageRecord",maxRecord);
			featureServer.processMapEvent("identityQuery");
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