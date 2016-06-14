package jsoft.map.feature
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Circle;
	import jsoft.map.geometry.Envelope;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.MultiLine;
	import jsoft.map.geometry.MultiPoint;
	import jsoft.map.geometry.MultiPolygon;
	import jsoft.map.geometry.Polygon;
	
	import mx.graphics.codec.JPEGEncoder;
	
	public class FeatureServer {
		
		private var featureServerURL:String = "";
		
		private var queryMode:int=0;
		
		private var requestParam:Array = new Array();
		
		private var xml:XML;
		
		private var loading:Boolean;
		
		private var received:Boolean;
		
		private var timeOutId:int;
		
		private var server:String;
		
		private var imageData:ByteArray;
		
		private var featureCallBack:FeatureCallBack;
		
		public function FeatureServer(queryMode:int=0)	{
			this.queryMode=queryMode;
			loading = false;
			received = false;
			timeOutId = -1;
			featureServerURL = AppContext.getMapContext().getMapConfigManager().getFeatureServer();
		}
		
		public function setQueryMode(queryMode:String):void {
			if(queryMode==null||queryMode.length==0) {
				this.queryMode = 0;
			} else {
				this.queryMode = AppContext.getAppUtil().getInt(queryMode);
			}
		}
		
		public function addParam(param:RequestParam):void {
			requestParam.push(param);
		}
		
		public function addStringParam(name:String,value:String):void {
			var param:RequestParam = new RequestParam(name,value);
			requestParam.push(param);
		}
		
		public function addStrParam(name:String,value:String):void {
			var param:RequestParam = new RequestParam(name,value);
			requestParam.push(param);
		}
		
		public function addIntParam(name:String,value:int):void {
			var param:RequestParam = new RequestParam(name,value+"");
			requestParam.push(param);
		}
		
		public function addNumParam(name:String,value:Number):void {
			var param:RequestParam = new RequestParam(name,value+"");
			requestParam.push(param);
		}
		
		public function addGeoParam(geometry:Geometry):void {
			var param:RequestParam;
			if(geometry == null) {
				return;
			}
			if(geometry is Box) {
				var box:Box = geometry as Box;
				param = new RequestParam("x1",box.getMinx()+"");
				requestParam.push(param);
				param = new RequestParam("y1",box.getMiny()+"");
				requestParam.push(param);
				param = new RequestParam("x2",box.getMaxx()+"");
				requestParam.push(param);
				param = new RequestParam("y2",box.getMaxy()+"");
				requestParam.push(param);
				return;
			}
			if(geometry is Envelope) {
				var env:Envelope = geometry as Envelope;
				param = new RequestParam("x1",env.getMinx()+"");
				requestParam.push(param);
				param = new RequestParam("y1",env.getMiny()+"");
				requestParam.push(param);
				param = new RequestParam("x2",env.getMaxx()+"");
				requestParam.push(param);
				param = new RequestParam("y2",env.getMaxy()+"");
				requestParam.push(param);
				return;
			}
			if(geometry is FPoint) {
				var point:FPoint = geometry as FPoint;
				param = new RequestParam("x",point.getX()+"");
				requestParam.push(param);
				param = new RequestParam("y",point.getY()+"");
				requestParam.push(param);
				return;
			}
			if(geometry is MultiPoint) {
				var mpoint:MultiPoint = geometry as MultiPoint;
				param = new RequestParam("x",mpoint.getXArray());
				requestParam.push(param);
				param = new RequestParam("y",mpoint.getYArray());
				requestParam.push(param);
				return;
			}
			if(geometry is Line) {
				var line:Line = geometry as Line;
				param = new RequestParam("x",AppContext.getAppUtil().getArrayString(line.getXArray()));
				requestParam.push(param);
				param = new RequestParam("y",AppContext.getAppUtil().getArrayString(line.getYArray()));
				requestParam.push(param);
				return;
			}
			if(geometry is MultiLine) {
				var ml:MultiLine = geometry as MultiLine;
				param = new RequestParam("x",ml.getXArrayString());
				requestParam.push(param);
				param = new RequestParam("y",ml.getYArrayString());
				requestParam.push(param);
				return;
			}
			if(geometry is Polygon) {
				var polygon:Polygon = geometry as Polygon;
				param = new RequestParam("x",AppContext.getAppUtil().getArrayString(polygon.getXArray()));
				requestParam.push(param);
				param = new RequestParam("y",AppContext.getAppUtil().getArrayString(polygon.getYArray()));
				requestParam.push(param);
				return;
			}
			if(geometry is MultiPolygon) {
				var mp:MultiPolygon = geometry as MultiPolygon;
				param = new RequestParam("x",mp.getXArrayString());
				requestParam.push(param);
				param = new RequestParam("y",mp.getYArrayString());
				requestParam.push(param);
				return;
			}
			if(geometry is Circle) {
				var circle:Circle = geometry as Circle;
				param = new RequestParam("x",circle.getCenterX()+"");
				requestParam.push(param);
				param = new RequestParam("y",circle.getCenterY()+"");
				requestParam.push(param);
				param = new RequestParam("r",circle.getRadius()+"");
				requestParam.push(param);
				return;
			}
		}
		
		public function addAryParam(name:String,value:Array):void {
			var param:RequestParam = new RequestParam(name);
			param.setAryValue(value);
			requestParam.push(param);
		}
		
		public function getParam():Array {
			return requestParam;
		}
		
		public function setParam(requestParam:Array):void {
			this.requestParam = requestParam;
		}
		
		public function getFeatureCallBack() : FeatureCallBack {
			return featureCallBack;
		}
		
		public function setFeatureCallBack(featureCallBack:FeatureCallBack) : void {
			this.featureCallBack = featureCallBack;
		}
		
		public function setImage(image:BitmapData):void {
			var encoder:JPEGEncoder = new JPEGEncoder(80);
			imageData = encoder.encode(image);
		}
		
		public function processImageEvent():void {
			server = featureServerURL + "/event/map/uploadImage";
			//AppContext.getAppUtil().alert(server);
			var request:URLRequest = new URLRequest(server);
			request.method=URLRequestMethod.POST;
			request.contentType = "application/octet-stream";
			request.data = imageData;
			var loader:URLLoader = new URLLoader();
			loader.dataFormat=URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE,onCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,OnErrorHandler);
			timeOutId = setTimeout(this.onTimeout,150000);
			loading = true;
			received = false;
			loader.load(request);
		}
		
		public function processMapPostEvent(eventName:String,param:String=""):void {
			processPostEvent("map",eventName,param);
		}
		
		public function processPostEvent(moduleName:String,eventName:String,param:String=""):void {
			if(param != null && param.length > 0) {
				server = featureServerURL + "/event/" + moduleName + "/" + eventName + "?" + param;
			} else {
				server = featureServerURL + "/event/" + moduleName + "/" + eventName;
			}
			processPostURL(server);
		}
		
		public function processPostURL(url:String):void {
			var index:int=url.indexOf("?");
			if(queryMode == 1) {
				if(index >= 0) {
					url = url + "&mode=" + queryMode;
				} else {
					url = url + "?mode=" + queryMode;
					index = 1;
				}
			}
			var theParam:String = "";
			for(var i:int=0;requestParam!=null&&i<requestParam.length;i++) {
				var param:RequestParam = requestParam[i];
				if(i>0) {
					theParam += "&" + param.getParam();
				} else {
					theParam = param.getParam();
				}
			}
			//AppContext.getAppUtil().alert(url);
			server = url;
			var request:URLRequest = new URLRequest(server);
			request.method=URLRequestMethod.POST;
			var loader:URLLoader = new URLLoader();
			loader.dataFormat=URLLoaderDataFormat.VARIABLES;
			loader.addEventListener(Event.COMPLETE,onCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,OnErrorHandler);
			var varible:URLVariables = new URLVariables(theParam);
			loader.data = varible;
			timeOutId = setTimeout(onTimeout,150000);
			loading = true;
			received = false;
			loader.load(request);
		}
		
		public function processMapEvent(eventName:String,param:String=""):void {
			processEvent("map",eventName,param);
		}
		
		public function processEvent(moduleName:String,eventName:String,param:String=""):void {
			if(param != null && param.length > 0) {
				server = featureServerURL + "/event/" + moduleName + "/" + eventName + "?" + param;
			} else {
				server = featureServerURL + "/event/" + moduleName + "/" + eventName;
			}
			processURL(server);
		}
		
		public function processURL(url:String):void {
			var index:int=url.indexOf("?");
			if(queryMode == 1) {
				if(index >= 0) {
					url = url + "&mode=" + queryMode;
				} else {
					url = url + "?mode=" + queryMode;
					index = 1;
				}
			}
			for(var i:int=0;requestParam!=null&&i<requestParam.length;i++) {
				var param:RequestParam = requestParam[i];
				if(index >= 0) {
					url = url + "&" + param.getParam();
				} else {
					url = url + "?" + param.getParam();
					index = 1;
				}
			}
			//AppContext.getAppUtil().alert(url);
			server = url;
			var request:URLRequest = new URLRequest(server);
			request.method=URLRequestMethod.GET;
			var loader:URLLoader = new URLLoader();
			loader.dataFormat=URLLoaderDataFormat.TEXT;
			loader.addEventListener(Event.COMPLETE,onCompleteHandler);
			loader.addEventListener(IOErrorEvent.IO_ERROR,OnErrorHandler);
			timeOutId = setTimeout(this.onTimeout,150000);
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
			if(queryMode == 1) {
	            if(featureCallBack != null) {
	            	featureCallBack.onResultStr(xmlStr);
	            } else {
	            	AppContext.getAppUtil().alert("Query server(" + server + ") result:" + xmlStr);
	            }
	            return;
			} else {
				//AppContext.getAppUtil().alert(xmlStr);
				var xml:XML = new XML(xmlStr);
	            if(featureCallBack != null) {
	            	featureCallBack.onResult(xml);
	            } else {
	            	AppContext.getAppUtil().alert("Query server(" + server + ") result:" + xml);
	            }
  			}
		}
		
		private function OnErrorHandler(event:Event) : void	{
			if(timeOutId != -1) {
				clearTimeout(timeOutId);
				timeOutId = -1;
			}
            loading = false;
            if(featureCallBack != null) {
            	featureCallBack.onError();
            } else {
				AppContext.getAppUtil().alert("无法发送地图数据请求" + server + "，请求的资源无效！");
            }
		}
		
		private function onTimeout() : void {
			if(timeOutId != -1) {
				clearTimeout(timeOutId);
				timeOutId = -1;
			}
            loading = false;
            if(featureCallBack != null) {
            	featureCallBack.onError();
            } else {
				AppContext.getAppUtil().alert("无法发送地图数据请求" + server + "，连接超时！");
            }
		}
		
		public function isLoading() : Boolean {
			return loading;
		}
		
		public function isReceive() : Boolean {
			return received;
		}
		
		public function getServer() : String {
			return server;
		}
		
		public function getFeatureServerURL() : String {
			return featureServerURL;
		}
		
		public function setFeatureServerURL(featureServerURL:String) : void {
			this.featureServerURL = featureServerURL;
		}

	}
}