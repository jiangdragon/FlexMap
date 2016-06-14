package jsoft.map.feature.query
{
	import flash.external.ExternalInterface;
	
	import jsoft.map.feature.FeatureCallBack;
	import jsoft.map.feature.FeatureServer;

	
	public class RectIdentityQuery implements FeatureCallBack
	{
		private var param:String;
		private var featureServer:FeatureServer;
		public function RectIdentityQuery()
		{
		}
		public function query(source:String,layerGroup:String,queryValue:String,minx:Number,miny:Number,maxx:Number,maxy:Number,around:Number,queryFlag:int,maxRecord:int):void {
			if(maxRecord==0) {
				maxRecord = 10;
			}
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addStrParam("source",source);
			featureServer.addStrParam("layerGroup",layerGroup);
			featureServer.addStrParam("queryValue",queryValue);
			featureServer.addNumParam("minx",minx);
			featureServer.addNumParam("miny",miny);
			featureServer.addNumParam("maxx",maxx);
			featureServer.addNumParam("maxy",maxy);
			featureServer.addNumParam("around",around);
			featureServer.addIntParam("queryFlag",queryFlag);
			featureServer.addIntParam("maxPageRecord",maxRecord);
			featureServer.processMapEvent("rectIdentityQuery");
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