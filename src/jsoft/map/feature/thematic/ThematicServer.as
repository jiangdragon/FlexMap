package jsoft.map.feature.thematic
{
	import flash.external.ExternalInterface;
	
	import jsoft.map.feature.FeatureCallBack;
	import jsoft.map.feature.FeatureServer;
	import jsoft.map.feature.query.XMLUtil;
	import jsoft.map.geometry.Geometry;
	
	public class ThematicServer implements FeatureCallBack
	{
		private var server:FeatureServer = new FeatureServer(1);
		private var type:String="";
		private var layerName:String="";
		private var layerField:String="";
		private var geometry:Geometry=null;
		private var targetLayerName:String="";
		private var targetLayerField:String="";
		
		public function ThematicServer() {
		}
		
		public function getLayerName():String {
			return layerName;
		}
		
		public function setLayerName(layerName:String):void {
			this.layerName = layerName;
		}
		
		public function getType():String {
			return type;
		}
		
		public function setType(type:String):void {
			this.type = type;
		}
		
		public function getLayerField():String {
			return layerField;
		}
		
		public function setLayerField(layerField:String):void {
			this.layerField = layerField;
		}
		
		public function getGeometry():Geometry {
			return geometry;
		}
		
		public function setGeometry(geometry:Geometry):void {
			this.geometry = geometry;
		}
		
		public function getTargetLayerName():String {
			return targetLayerName;
		}
		
		public function setTargetLayerName(targetLayerName:String):void {
			this.targetLayerName = targetLayerName;
		}
		
		public function getTargetLayerField():String {
			return targetLayerField;
		}
		
		public function setTargetLayerField(targetLayerField:String):void {
			this.targetLayerField = targetLayerField;
		}
		
		public function sendThematicQuery():void {
			server.setFeatureCallBack(this);
			server.addStringParam("type",type);
			server.addStringParam("layerName",layerName);
			server.addStringParam("layerField",layerField);
			server.addGeoParam(geometry);
			server.addStringParam("targetLayerName",targetLayerName);
			server.addStringParam("targetLayerField",targetLayerField);
			server.processMapEvent("thematicQuery");
		}
		
		// 返回请求结果
		public function onResult(xml:XML):void {
			var js:String = new XMLUtil(xml).toJS();
			ExternalInterface.call("fMap.getFThematic().thematicBack",js);
		}
		
		// 返回请求结果
		public function onResultStr(result:String):void {
			// 处理统计结果
			ExternalInterface.call("fMap.getFThematic().thematicBack",result);
		}
		
		// 请求错误
		public function onError():void {
			AppContext.getAppUtil().alert("Cannot execute thematic("+server.getServer()+")");
		}

	}
}