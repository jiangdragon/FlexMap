package jsoft.map.feature
{
	import flash.external.ExternalInterface;
	public class VectorSave implements FeatureCallBack
	{
		private var name:String;
		private var type:String;
		private var catalog:String;
		private var content:String;
		private var count:int = 0;
		
		public function VectorSave(name:String,type:String,catalog:String,content:String) {
			this.name = name;
			this.type = type;
			this.catalog = catalog;
			this.content = content;
		}
		
		public function sendServer(ret:String):void {
			var length:int = content.length;
			var maxLen:int = 1000;
			var parts:int = length / maxLen;
			if(length > maxLen * parts) {
				parts++;
			}
			if(content.length <= maxLen) {
				ExternalInterface.call("fMap.getFVector().onSchemaBack",ret);
				return;
			}
			for(var i:int=maxLen;i<content.length;i+=maxLen) {
				var len:int=content.length-i;
				if(len>maxLen) {
					len=maxLen;
				}
				var server:FeatureServer = new FeatureServer(1);
				server.setFeatureCallBack(this);
				var str:String=content.substr(i,len);
				server.addStringParam("name",name);
				server.addStringParam("type",type);
				server.addStringParam("catalog",catalog);
				server.addStringParam("index",i+"");
				server.addStringParam("len",len+"");
				server.addStringParam("max",parts+"");
				server.addStringParam("content",str);
				server.processMapEvent("addVectorData");
				count++;
			}
		}
		
		// 返回请求结果
		public function onResult(xml:XML):void {
		}
		
		// 返回请求结果
		public function onResultStr(result:String):void {
			var ret:String;
			ret = AppContext.getAppUtil().parseString(result,"save");
			if(ret != null) {
				sendServer(ret);
				return;
			}
			ret = AppContext.getAppUtil().parseString(result,"add");
			if(ret != null) {
				count--;
				if(count<=0) {
					ExternalInterface.call("fMap.getFVector().onSchemaBack",ret);
				}
				return;
			}
		}
		
		// 请求错误
		public function onError():void {
		}

	}
}