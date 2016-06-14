package jsoft.map.feature.query
{
	import flash.external.ExternalInterface;
	
	import jsoft.map.feature.FeatureCallBack;
	import jsoft.map.feature.FeatureServer;
	
	public class PageQuery implements FeatureCallBack
	{
		private var param:String;
		private var featureServer:FeatureServer;
		
		public function PageQuery() {
		}
		public function query(recordsetIndex:int,pageIndex:int,maxPageRecord:int):void {
			if(maxPageRecord==0) {
				maxPageRecord = 10;
			}
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addIntParam("recordsetIndex",recordsetIndex);
			featureServer.addIntParam("pageIndex",pageIndex);
			featureServer.addIntParam("maxPageRecord",maxPageRecord);
			featureServer.processMapEvent("getPageRecord");
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