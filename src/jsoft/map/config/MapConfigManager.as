package jsoft.map.config
{
	import flash.events.MouseEvent;
	import flash.system.Security;
	
	import jsoft.map.dispatch.MapDispatcher;
	import jsoft.map.feature.FeatureCallBack;
	import jsoft.map.feature.FeatureServer;
	
	import mx.containers.Canvas;
	import mx.controls.Button;
	
	public class MapConfigManager implements FeatureCallBack
	{
		private var featureServer:String;
		private var mapConfigArray:Array;
		private var defaultShowMap:String;
		private var mapButtonArray:Array;

		public function MapConfigManager() {
			mapConfigArray = new Array();
		}
		public function addMapConfig(name:String,url:String) : void {
			var mapConfig:MapConfig = new MapConfig();
			mapConfig.setName(name);
			mapConfig.loadConfig(url);
			mapConfigArray[mapConfigArray.length]=mapConfig;
		}
		public function addMapConfigEx(name:String,config:String,url:String) : void {
			var mapConfig:MapConfig = new MapConfig();
			mapConfig.setName(name);
			mapConfig.loadConfigEx(config,url);
			mapConfigArray[mapConfigArray.length]=mapConfig;
		}
		public function getMapConfigs() : Array {
			var ret:Array = new Array();
			for(var i:int=0;i<mapConfigArray.length;i++) {
				var mapConfig:MapConfig=mapConfigArray[i];
				ret[ret.length]=mapConfig.getName();
			}
			return ret;
		}
		public function isMapConfigEnable(name:String) : Boolean {
			var mapConfig:MapConfig = getMapConfigByName(name);
			if(mapConfig != null) {
				return mapConfig.isEnable();
			}
			return false;
		}
		public function enableMapConfig(name:String) : void {
			var mapConfig:MapConfig = getMapConfigByName(name);
			if(mapConfig != null) {
				mapConfig.setEnable(true);
			}
		}
		public function disableMapConfig(name:String) : void {
			var mapConfig:MapConfig = getMapConfigByName(name);
			if(mapConfig != null) {
				mapConfig.setEnable(false);
			}
		}
		public function getMapConfigByName(name:String) : MapConfig {
			var item:Object;
            for each(item in mapConfigArray) {
            	var mapConfig:MapConfig = item as MapConfig;
            	if(mapConfig.getName() == name) {
            		return mapConfig;
            	}
            }
            return null;
		}
		public function getDefaultShowMap():String {
			return defaultShowMap;
		}
		public function setDefaultShowMap(defaultShowMap:String):void {
			this.defaultShowMap = defaultShowMap;
		}
		public function setDefaultFeatureServer():void {
			featureServer = AppContext.getApplication().url;
			var str:String = "/module/map/standard";
			var index:int = featureServer.indexOf(str);
			if(index >= 0) {
				featureServer = featureServer.substring(0,index);
			}
			//AppContext.getAppUtil().alert(featureServer);
		}
		public function getFeatureServer():String {
			return featureServer;
		}
		public function getMapEventUrl(eventName:String,param:String):String {
			var url:String = "";
			var moduleName:String = "map";
			if(param != null && param.length > 0) {
				url = featureServer + "/event/" + moduleName + "/" + eventName + "?" + param;
			} else {
				url = featureServer + "/event/" + moduleName + "/" + eventName;
			}
			return url;
		}
		public function setFeatureServer(featureServer:String):void {
			if(featureServer == null || featureServer.length == 0) {
				setDefaultFeatureServer();
			} else {
				this.featureServer = featureServer;
			}
		}
		
		public function loadMapConfig():void {
			var featureServer:FeatureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			//AppContext.getAppUtil().alert("load map config");
			featureServer.processMapEvent("getMap");
		}
		// 返回请求结果
		public function onResult(xml:XML):void {
			var item:XML;
			var mapNode:XMLList = xml.elements("map");
			var app:String = AppContext.getApplication().url;
			var pos:int = app.indexOf("/",8);
			if(pos >= 0) {
				app = app.substr(0,pos);
			}
            for each(item in mapNode) {
				var name:String = item.attribute("name");
				var host:String = item.attribute("host");
				var configUrl:String = item.attribute("config");
				var url:String = item.attribute("url");
				//AppContext.getAppUtil().alert("map name="+name+",host="+host+",configUrl="+configUrl+",url="+url+",app="+app);
				//if(app != host) {
					configUrl = host + configUrl;
				//}
				//AppContext.getAppUtil().alert("map name="+name+",host="+host+",configUrl="+configUrl+",url="+url+",app="+app);
				if(configUrl == null || configUrl == "") {
					addMapConfig(name,url);
				} else {
					addMapConfigEx(name,configUrl,url);
				}
            }
            if(mapConfigArray.length>0) {
            	var config:MapConfig = mapConfigArray[0];
            	MapDispatcher.showMapConfig(config.getName());
            	MapDispatcher.setMapPan();
            }
		}
		// 返回请求结果
		public function onResultStr(result:String):void {
		}
		// 请求错误
		public function onError():void {
			AppContext.getAppUtil().alert("加载地图失败，无法连接到服务器！");
		}
		
		public function refreshMapButton() : void {
            var i:int = 0; 
            var buttonContainer:Canvas = AppContext.getMapContext().getButtonContainer();
			for(i=0;mapButtonArray!=null&&i<mapButtonArray.length;i++) {
            	buttonContainer.removeChild(mapButtonArray[i]);
			}
			mapButtonArray = new Array();
			if(mapConfigArray.length <= 1) {
				return;
			}
			var item:Object;
            var rightSpan:int = 50;
            var hspan:int = 80;
            var topSpan:int = 50;
            var mapConfig:MapConfig = null;
            var leftSpan:int = buttonContainer.width - rightSpan - getNameSize();//hspan * count;
            //AppContext.getAppUtil().alert("leftSpan="+leftSpan);
			var currentMapConfig:MapConfig = AppContext.getMapContext().getMapContent().getMapConfig();
            //AppContext.getAppUtil().alert("mapConfigArray.length="+mapConfigArray.length);
            buttonContainer.graphics.drawRect(10,10,200,200);
            var leftStart:int = leftSpan;
			for(i=0;i<mapConfigArray.length;i++) {
            	mapConfig = mapConfigArray[i];
            	if(!mapConfig.isEnable()) {
            		continue;
            	}
            	var mapButton:Button = new Button();
            	mapButton.label = mapConfig.getName()
            	mapButton.x = leftStart;
            	leftStart += getConfigSize(mapConfig);
            	mapButton.y = topSpan;
            	if(mapConfig == currentMapConfig) {
            		mapButton.setStyle("fillColors",["red","red"]);
            	}
            	mapButton.addEventListener(MouseEvent.CLICK,onClickMapSourceButton); 
            	buttonContainer.addChild(mapButton);
            	mapButtonArray[mapButtonArray.length] = mapButton;
			}
			if(currentMapConfig != null) {
				AppContext.getMapContext().getLevelUI().refresh();
			}
			AppContext.getMapContext().getCopyRight().show();
            //AppContext.getAppUtil().alert("refreshMapButton");
		}
		
		private function getNameSize():int {
			var ret:int = 0;
            var hspan:int = 60;
            for(var i:int=0;i<mapConfigArray.length;i++) {
            	var mapConfig:MapConfig = mapConfigArray[i];
            	if(mapConfig.isEnable()) {
            		ret += getConfigSize(mapConfig);
            	}
            }
			return ret;
		}
		
		private function getConfigSize(mapConfig:MapConfig):int {
            if(mapConfig.getName().length <4) {
            	return 60;
            } else {
            	return 80;
            }
		}
		
		private function updateMapButton() : void {
			var currentMapConfig:MapConfig = AppContext.getMapContext().getMapContent().getMapConfig();
			if(currentMapConfig != null && !currentMapConfig.isEnable()) {
				for(var i:int=0;i<mapConfigArray.length;i++) {
		            var mapConfig:MapConfig = mapConfigArray[i];
		            if(mapConfig.isEnable()) {
		            	MapDispatcher.showMapConfig(mapConfig.getName());
		            	return;
		            }
		        }
			}
			refreshMapButton();
		}
		
		public function onClickMapSourceButton(event:MouseEvent) : void {
			var name:String = event.target.label;
			//AppUtil.alert(name);
			AppContext.getMapContext().getLevelUI().setMouseDown();
            MapDispatcher.showMapConfig(name);
		}
	}
}