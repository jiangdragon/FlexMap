package jsoft.map.feature
{
	public interface FeatureCallBack {
		
		// 返回请求结果
		function onResult(xml:XML):void;
		
		// 返回请求结果
		function onResultStr(result:String):void;
		
		// 请求错误
		function onError():void;
	}
}