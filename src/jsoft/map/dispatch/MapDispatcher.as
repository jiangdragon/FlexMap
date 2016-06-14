package jsoft.map.dispatch
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.external.ExternalInterface;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	import jsoft.map.MapContext;
	import jsoft.map.config.MapConfig;
	import jsoft.map.content.MapContent;
	import jsoft.map.event.MapMeasure;
	import jsoft.map.event.MapMeasureArea;
	import jsoft.map.event.MapPan;
	import jsoft.map.event.MapZoomIn;
	import jsoft.map.event.MapZoomOut;
	import jsoft.map.feature.FeatureCallBack;
	import jsoft.map.feature.FeatureServer;
	import jsoft.map.geometry.Coordinate;
	
	import mx.graphics.ImageSnapshot;
	
	public class MapDispatcher implements Dispatcher,FeatureCallBack
	{
		private static var initFlag:Boolean = true;
		
		public function MapDispatcher() {
		}
		
		public function sendMessage(param:DispatchParam):void {
			if("addFMap" == param.Type) {
				addMapConfig(param.Param1,param.Param2);
				return;
			}
			if("enableMap" == param.Type) {
				enableMap(param.Param1);
				return;
			}
			if("disableMap" == param.Type) {
				disableMap(param.Param1);
				return;
			}
			if("showMap" == param.Type) {
				showMapConfig(param.Param1);
				return;
			}
			if("setFServer" == param.Type) {
				setFeatureServer(param.Param1);
				return;
			}
			if("resizeMap" == param.Type) {
				resizeMap(param.IntParam1,param.IntParam2);
				return;
			}
			if("pan" == param.Type) {
				setMapPan();
				return;
			}
			if("zoomIn" == param.Type) {
				setMapZoomIn();
				return;
			}
			if("zoomOut" == param.Type) {
				setMapZoomOut();
				return;
			}
			if("refresh" == param.Type) {
				refresh();
				return;
			}
			if("mesure" == param.Type) {
				setMesure();
				return;
			}
			if("mesureArea" == param.Type) {
				setMesureArea();
				return;
			}
			if("clearAll" == param.Type) {
				clearAll();
				return;
			}
			if("clearInput" == param.Type) {
				clearInput();
				return;
			}
			if("setMapLevel" == param.Type) {
				setMapLevel(param.IntParam1);
				return;
			}
			if("zoomMapToLevel" == param.Type) {
				zoomMapToLevel(param.IntParam1,param.NumParam2,param.NumParam3);
				return;
			}
			if("zoomMapToRange" == param.Type) {
				zoomMapToRange(param.NumParam1,param.NumParam2,param.NumParam3,param.NumParam4);
				return;
			}
			if("moveMapByViewDistance" == param.Type) {
				moveMapByViewDistance(param.NumParam1,param.NumParam2);
				return;
			}
			if("centerAtByView" == param.Type) {
				centerAtByView(param.NumParam1,param.NumParam2);
				return;
			}
			if("centerAt" == param.Type) {
				centerAt(param.NumParam1,param.NumParam2);
				return;
			}
			if("captureMap" == param.Type) {
				captureMap();
				return;
			}
			if("captureMapBox" == param.Type) {
				captureMapBox(param.vnum,param.vnum,param.vnum,param.vnum);
				return;
			}
			if("captureMapViewBox" == param.Type) {
				//readEagle(param);
				captureMapViewBox(param.vnum,param.vnum,param.vnum,param.vnum);
				return;
			}
			if("showLevel" == param.Type) {
				AppContext.getMapContext().showLevel(param.vbool);
				return;
			}
			if("showScale" == param.Type) {
				AppContext.getMapContext().showScale(param.vbool);
				return;
			}
			if("showEagle" == param.Type) {
				AppContext.getMapContext().showEagle(param.vbool);
				return;
			}
			if("crossdomain" == param.Type){
				loadCrossdomain(param.vstr);
			}
		}
	
		public function getMessage(param:DispatchParam):String {
			if("getMap" == param.Type) {
				var mapConfigs:Array = getMapConfig();
				return AppContext.getAppUtil().getArrayString(mapConfigs);
			}
			if("isMapEnable" == param.Type) {
				var enable:Boolean = isMapConfigEnable(param.Param1);
				return enable ? "1" : "0";
			}
			if("getFServer" == param.Type) {
				return getFeatureServer();
			}
			if("getMapLevel" == param.Type) {
				return getMapLevel()+"";
			}
			if("getMapMinx" == param.Type) {
				return getMapMinx()+"";
			}
			if("getMapMiny" == param.Type) {
				return getMapMiny()+"";
			}
			if("getMapMaxx" == param.Type) {
				return getMapMaxx()+"";
			}
			if("getMapMaxy" == param.Type) {
				return getMapMaxy()+"";
			}
			if("getMapCenterx" == param.Type) {
				return getMapCenterx()+"";
			}
			if("getMapCentery" == param.Type) {
				return getMapCentery()+"";
			}
			return "";
		}
		
		public static function addMapConfig(name:String,url:String):void {
			var mapContext:MapContext = AppContext.getMapContext();
			mapContext.getMapConfigManager().addMapConfig(name,url);
		}
		
		public static function addMapConfigEx(name:String,config:String,url:String):void {
			var mapContext:MapContext = AppContext.getMapContext();
			mapContext.getMapConfigManager().addMapConfigEx(name,config,url);
		}
		
		public static function getMapConfig():Array {
			var mapContext:MapContext = AppContext.getMapContext();
			return mapContext.getMapConfigManager().getMapConfigs();
		}
		
		public static function isMapConfigEnable(name:String):Boolean {
			var mapContext:MapContext = AppContext.getMapContext();
			return mapContext.getMapConfigManager().isMapConfigEnable(name);
		}
		
		public static function enableMap(name:String):void {
			var mapContext:MapContext = AppContext.getMapContext();
			mapContext.getMapConfigManager().enableMapConfig(name);
		}
		
		public static function disableMap(name:String):void {
			var mapContext:MapContext = AppContext.getMapContext();
			mapContext.getMapConfigManager().disableMapConfig(name);
		}
		
		public static function showMapConfig(name:String):void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			var config:MapConfig = mapContext.getMapConfigManager().getMapConfigByName(name);
			if(config == null || !config.isReceive()) {
				//AppContext.getAppUtil().alert("无法显示地图：" + name + "，地图配置不存在！");
				// 如果地图没加载进来，则设置到变量中，等待地图加载
				mapContext.getMapConfigManager().setDefaultShowMap(name);
				return;
			}
			mapContent.setMapConfig(config);
			mapContent.showMap();
			mapContent.refresh();
			mapContext.getMapConfigManager().refreshMapButton();
			if(initFlag) {
				//处理瓦片截图跨域 begin
	        	var crossdomainStr:String = config.getMapURL();
	        	crossdomainStr = crossdomainStr.replace("http://","");
	        	var crossdomainInt:int = crossdomainStr.indexOf("/");
	        	crossdomainStr = crossdomainStr.substr(0,crossdomainInt);
	        	Security.loadPolicyFile("http://" + crossdomainStr + "/crossdomain.xml");
	        	//end
				ExternalInterface.call("onMapLoadFinish");
				initFlag = false;
			}
		}
		
		public static function getFeatureServer():String {
			var mapContext:MapContext = AppContext.getMapContext();
			return mapContext.getMapConfigManager().getFeatureServer();
		}
		
		public static function setFeatureServer(featureServer:String):void {
			var mapContext:MapContext = AppContext.getMapContext();
			return mapContext.getMapConfigManager().setFeatureServer(featureServer);
		}
		
		public static function resizeMap(width:int,height:int):void {
			var mapContext:MapContext = AppContext.getMapContext();
			var sFlag:Boolean = mapContext.getScale() == null ? false : true;
			var cFlag:Boolean = mapContext.getCopyRight() == null ? false : true;
			AppContext.getApplication().width = width;
			AppContext.getApplication().height = height;
			mapContext.getMapContent().width = width;
			mapContext.getMapContent().height = height;
			mapContext.getMapContent().resizeMap(width,height);
			mapContext.getMapContent().refresh();
			if(sFlag) {
				mapContext.getScale().show(width,height);
			}
			if(cFlag) {
				mapContext.getCopyRight().show(width,height);
			}
		}
		
		public static function setMapPan():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			var mapEvent:MapPan = new MapPan();
			mapContent.setMapEvent(mapEvent);
		}
		
		public static function setMapZoomIn():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			var mapEvent:MapZoomIn = new MapZoomIn();
			mapContent.setMapEvent(mapEvent);
		}
		
		public static function setMapZoomOut():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			var mapEvent:MapZoomOut = new MapZoomOut();
			mapContent.setMapEvent(mapEvent);
		}
		
		public static function refresh():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			mapContent.refresh();
		}
		
		public static function setMesure():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			var mapEvent:MapMeasure = new MapMeasure();
			mapContent.setMapEvent(mapEvent);
		}
		
		public static function setMesureArea():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			var mapEvent:MapMeasureArea = new MapMeasureArea();
			mapContent.setMapEvent(mapEvent);
		}
		
		public static function clearAll():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			mapContent.clearMap();
		}
		
		public static function clearInput():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			mapContent.clearInput();
		}
		
		public static function setMapLevel(newLevel:int):void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			mapContent.zoomMapToLevel(newLevel);
		}
		
		public static function getMapLevel():int {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			return mapContent.getLevelIndex();
		}
		
		public static function zoomMapToLevel(newLevel:int,mapCenterX:Number,mapCenterY:Number):void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			mapContent.zoomAndMoveMapToLevel(newLevel,mapCenterX,mapCenterY);
		}
		
		public static function zoomMapToRange(minx:Number,miny:Number,maxx:Number,maxy:Number):void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			mapContent.zoomMapToRange(minx,miny,maxx,maxy);
		}
		
		public static function moveMapByViewDistance(distanceX:Number,distanceY:Number):void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			mapContent.moveMapByViewDistance(distanceX,distanceY);
		}
		
		public static function centerAtByView(viewX:Number,viewY:Number):void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			mapContent.centerMapAtByView(viewX,viewY);
		}
		
		public static function centerAt(mapX:Number,mapY:Number):void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			mapContent.centerMapAt(mapX,mapY);
		}
		
		public static function getMapMinx():Number {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			return mapContent.getCoordinate().getMap().getMinx()
		}
		
		public static function getMapMiny():Number {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			return mapContent.getCoordinate().getMap().getMiny()
		}
		
		public static function getMapMaxx():Number {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			return mapContent.getCoordinate().getMap().getMaxx()
		}
		
		public static function getMapMaxy():Number {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			return mapContent.getCoordinate().getMap().getMaxy()
		}
		
		public static function getMapCenterx():Number {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			return mapContent.getCenterX();
		}
		
		public static function getMapCentery():Number {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			return mapContent.getCenterY();
		}
		
		public static function captureMap():void {
			var rect:Rectangle = new Rectangle(0,0,AppContext.getApplication().width,AppContext.getApplication().height);
			var image:BitmapData = ImageSnapshot.captureBitmapData(AppContext.getApplication(),null,null,null,rect);
			var server:FeatureServer = new FeatureServer(1);
			server.setFeatureCallBack(new MapDispatcher());
			server.setImage(image);
			server.processImageEvent();
		}
		
		public static function captureMapBox(minx:Number,miny:Number,maxx:Number,maxy:Number):void {
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			var x1:Number = coord.mapToViewX(minx);
			var y1:Number = coord.mapToViewY(maxy);
			var x2:Number = coord.mapToViewX(maxx);
			var y2:Number = coord.mapToViewY(miny);
			var rect:Rectangle = new Rectangle();
			rect.x = Math.min(x1,x2);
			rect.y = Math.min(y1,y2);
			rect.width = Math.abs(x1-x2);
			rect.height = Math.abs(y1-y2);
			var image:BitmapData = ImageSnapshot.captureBitmapData(AppContext.getApplication(),null,null,null,rect);
			var newImage:BitmapData = new BitmapData(rect.width,rect.height);
			newImage.copyPixels(image,rect,new Point(0,0));
			/*
			var image111:Image = new Image();
			image111.source = new Bitmap(newImage);
			AppContext.getApplication().addChild(image111);
			*/
			var server:FeatureServer = new FeatureServer(1);
			server.setFeatureCallBack(new MapDispatcher());
			server.setImage(newImage);
			server.processImageEvent();
		}
		
		public static function captureMapViewBox(x1:Number,y1:Number,x2:Number,y2:Number):void {
			var rect:Rectangle = new Rectangle();
			rect.x = Math.min(x1,x2);
			rect.y = Math.min(y1,y2);
			rect.width = Math.abs(x1-x2);
			rect.height = Math.abs(y1-y2);
			var image:BitmapData = ImageSnapshot.captureBitmapData(AppContext.getApplication(),null,null,null,rect);
			var newImage:BitmapData = new BitmapData(rect.width,rect.height);
			newImage.copyPixels(image,rect,new Point(0,0));
			var server:FeatureServer = new FeatureServer(1);
			server.setFeatureCallBack(new MapDispatcher());
			server.setImage(newImage);
			server.processImageEvent();
		}
		//for print
		private function readEagle(param:DispatchParam):void{
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			var config:MapConfig = mapContent.getMapConfig();
			var url:String = config.getMapURL() + "blank." + config.getImageType();
			var loader:Loader = new Loader(); 
			var lc:LoaderContext = new LoaderContext(true);
			lc.checkPolicyFile = true;
			loader.load(new URLRequest(url),lc); 
		}
		//加载跨域文件 http://+ip+端口
		private function loadCrossdomain(url:String):void{
			if(url.indexOf("http://") == -1){
				return;
			}
			Security.loadPolicyFile(url + "/crossdomain.xml");
		}
		
		// 返回请求结果
		public function onResult(xml:XML):void {
		}
		
		// 返回请求结果
		public function onResultStr(result:String):void {
			ExternalInterface.call("fMap.captureMapBack",result);
		}
		
		// 请求错误
		public function onError():void {
			AppContext.getAppUtil().alert("截取地图失败！");
		}
	}
}