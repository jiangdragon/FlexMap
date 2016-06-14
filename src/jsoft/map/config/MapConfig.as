package jsoft.map.config
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import jsoft.map.content.MapTile;
	import jsoft.map.dispatch.MapDispatcher;
	import jsoft.map.geometry.Envelope;
	import jsoft.map.util.AppUtil;
	
	public class MapConfig
	{
		private var configName:String;
		
		private var configUrl:String;
		
		private var loading:Boolean;
		
		private var received:Boolean;
		
		private var enable:Boolean;
		
		private var timeOutId:int;
		
		private var imageType:String;
		
		private var mapOval:MapOval;
		
		private var mapLevelArray:Array;
		
		private var blankTile:MapTile;
		
		private var mapServerArray:Array;
		
		public function MapConfig()	{
			loading = false;
			received = false;
			enable = true;
			timeOutId = -1;
			imageType = "jpg";
			mapLevelArray = new Array();
			mapServerArray = new Array();
		}
		
		public function isEnable():Boolean {
			return enable;
		}
		
		public function setEnable(enable:Boolean):void {
			this.enable = enable;
		}
		
		public function loadConfig(configUrl:String):void {
			 var index:int = configUrl.indexOf("image.xml");
			 if(index>=0) {
			 	this.configUrl = configUrl.substr(0,index);
			 } else {
			 	if(configUrl.charAt(configUrl.length-1)!="/") {
			 		configUrl += "/";
			 	}
			 	this.configUrl = configUrl;
			 	configUrl += "image.xml";
			 }
			 //AppContext.getAppUtil().alert("configUrl="+configUrl);
			 var request:URLRequest = new URLRequest(configUrl);
			 request.method=URLRequestMethod.GET;
			 var loader:URLLoader = new URLLoader();
			 loader.dataFormat=URLLoaderDataFormat.TEXT;
			 loader.addEventListener(Event.COMPLETE,onCompleteHandler);
			 loader.addEventListener(IOErrorEvent.IO_ERROR,OnErrorHandler);
			 timeOutId = setTimeout(this.onTimeout,15000);
			 loading = true;
			 received = false;
			 loader.load(request);
		}
		
		public function loadConfigEx(configUrl:String,serviceUrl:String):void {
			 var index:int = serviceUrl.indexOf("image.xml");
			 if(index>=0) {
			 	this.configUrl = serviceUrl.substr(0,index);
			 } else {
			 	if(serviceUrl.charAt(serviceUrl.length-1)!="/") {
			 		serviceUrl += "/";
			 	}
			 	this.configUrl = serviceUrl;
			 }
			 //AppContext.getAppUtil().alert("configUrl="+configUrl+",serviceUrl="+serviceUrl);
			 var request:URLRequest = new URLRequest(configUrl);
			 request.method=URLRequestMethod.GET;
			 var loader:URLLoader = new URLLoader();
			 loader.dataFormat=URLLoaderDataFormat.TEXT;
			 loader.addEventListener(Event.COMPLETE,onCompleteHandler);
			 loader.addEventListener(IOErrorEvent.IO_ERROR,OnErrorHandler);
			 timeOutId = setTimeout(this.onTimeout,15000);
			 loading = true;
			 received = false;
			 loader.load(request);
		}
		
		private function onCompleteHandler(event:Event):void {
			if(timeOutId != -1) {
				clearTimeout(timeOutId);
				timeOutId = -1;
			}
			var loader:URLLoader=(event.target as URLLoader);
			var xmlStr:String = loader.data;
			var xml:XML = new XML(xmlStr);
			var item:XML;
            for each(item in xml) {
            	parseServer(item);
            	parseImageType(item);
            	parseOval(item);
            	parseLevel(item);
            }
			received = true;
            loading = false;
            
            if(AppContext.getMapContext().getMapConfigManager().getDefaultShowMap()==configName) {
            	jsoft.map.dispatch.MapDispatcher.showMapConfig(configName);
            }
		}
		
		private function parseServer(root:XML) : void {
			var serverNode:XMLList = root.elements("server");
			var item:XML;
			var levelIndex:int = 0;
			var helper:AppUtil = new AppUtil();
            for each(item in serverNode) {
				var url:String = item.attribute("url");
				var level:String = item.attribute("level");
				var startx:String = item.attribute("startx");
				var starty:String = item.attribute("starty");
				var endx:String = item.attribute("endx");
				var endy:String = item.attribute("endy");
				var config:MapServer = new MapServer();
				config.setServer(url);
				config.setLevel(helper.getIntEx(level,-1));
				config.setStartX(helper.getIntEx(startx,-1));
				config.setStartY(helper.getIntEx(starty,-1));
				config.setEndX(helper.getIntEx(endx,-1));
				config.setEndY(helper.getIntEx(endy,-1));
				mapServerArray.push(config);
			}
			//AppContext.getAppUtil().alert("parseImageType:imageType="+imageType);
		}
		
		private function parseImageType(root:XML) : void {
			var imageTypeNode:XMLList = root.elements("imageType");
			if(imageTypeNode != null) {
				var imageType:String = imageTypeNode.attribute("value");
				if(imageType != null && imageType != "") {
					this.imageType = imageType;
				} else {
					this.imageType = "jpg";
				}
			}
			//AppContext.getAppUtil().alert("parseImageType:imageType="+imageType);
		}
		
		private function parseOval(root:XML) : void {
			var ovalNode:XMLList = root.elements("oval");
			var width:int = ovalNode.attribute("width");
			var height:int = ovalNode.attribute("height");
			var env:Envelope = parseEnvelopeList(ovalNode);
			mapOval = new MapOval();
			mapOval.setWidth(width);
			mapOval.setHeight(height);
			mapOval.setMap(env);
			//AppContext.getAppUtil().alert("parseOval:mapOval="+mapOval);
			//AppUtil.alert(mapOval.toString());
		}
		
		private function parseLevel(root:XML) : void {
			var levelNode:XMLList = root.elements("level");
			var item:XML;
			var levelIndex:int = 0;
            for each(item in levelNode) {
				//var index:int = item.attribute("index");
				var index:int = levelIndex++;
				var endX:int = item.attribute("endX");
				var endY:int = item.attribute("endY");
				var width:int = item.attribute("width");
				var height:int = item.attribute("height");
				var env:Envelope = parseEnvelope(item);
				var mapLevel:MapLevel = new MapLevel(this);
				mapLevel.setIndex(index);
				mapLevel.setEndX(endX);
				mapLevel.setEndY(endY);
				mapLevel.setWidth(width);
				mapLevel.setHeight(height);
				mapLevel.setMap(env);
				mapLevelArray[mapLevelArray.length]=mapLevel;
				//AppContext.getAppUtil().alert("parseLevel:mapLevel="+mapLevel);
				//AppUtil.alert(mapLevel.toString());
            }
		}
		
		private function parseEnvelopeList(root:XMLList) : Envelope {
			var mapNode:XMLList = root.elements("map");
			var minx:Number = mapNode.attribute("minx");
			var miny:Number = mapNode.attribute("miny");
			var maxx:Number = mapNode.attribute("maxx");
			var maxy:Number = mapNode.attribute("maxy");
			var env:Envelope = new Envelope();
			env.setEnvelope(minx,miny,maxx,maxy);
			//AppContext.getAppUtil().alert("parseEnvelopeList:env="+env);
			return env;
		}
		
		private function parseEnvelope(root:XML) : Envelope {
			var mapNode:XMLList = root.elements("map");
			var minx:Number = mapNode.attribute("minx");
			var miny:Number = mapNode.attribute("miny");
			var maxx:Number = mapNode.attribute("maxx");
			var maxy:Number = mapNode.attribute("maxy");
			var env:Envelope = new Envelope();
			env.setEnvelope(minx,miny,maxx,maxy);
			return env;
		}
		
		private function OnErrorHandler(event:Event) : void	{
			if(timeOutId != -1) {
				clearTimeout(timeOutId);
				timeOutId = -1;
			}
            loading = false;
			AppContext.getAppUtil().alert("无法加载地图配置文件:" + configUrl + "，请求的资源无效！");
		}
		
		private function onTimeout() : void {
			if(timeOutId != -1) {
				clearTimeout(timeOutId);
				timeOutId = -1;
			}
            loading = false;
			AppContext.getAppUtil().alert("无法加载地图配置文件:" + configUrl + "，连接超时！");
		}
		
		public function isLoading() : Boolean {
			return loading;
		}
		
		public function isReceive() : Boolean {
			return received;
		}
		
		public function getName() : String {
			return configName;
		}
		
		public function setName(name:String) : void {
			configName = name;
		}
		
		public function getMapURL() : String {
			return configUrl;
		}
		
		public function getCompatibleMapURL(level:int,x:int,y:int) : String {
			for(var i:int=0;i<mapServerArray.length;i++) {
				var config:MapServer=mapServerArray[i];
				if(config.getLevel()==level) {
					if(config.getStartX()<=x&&config.getStartY()<=y&&config.getEndX()>=x&&config.getEndY()>=y) {
						//trace(config.getServer());
						return config.getServer();
					}
				}
			}
			return configUrl;
		}
		
		public function setMapUrl(url:String) : void {
			configUrl = url;
		}
		
		public function getImageType() : String {
			return imageType;
		}
		
		public function getMapOval() : MapOval {
			return mapOval;
		}
		
		public function getMapLevelLength() : int {
			return mapLevelArray.length;
		}
		public function checkMapLevel(level:int):int {
			if(level < 0) {
				level = 0;
			} 
			if(level >= mapLevelArray.length) {
				level = mapLevelArray.length - 1;
			}
			return level;
		}
		public function getMapLevel(position:int) : MapLevel {
			var mapLevel:MapLevel = mapLevelArray[position];
			return mapLevel;
		}
		
		public function getBlankTile():MapTile {
			return this.blankTile;
		}
		
		public function setBlankTile(tile:MapTile):void {
			this.blankTile = tile;
		}
	}
}