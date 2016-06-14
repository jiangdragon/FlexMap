package jsoft.map.image
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	public class ImageReader
	{
		private var imageURL:String = null;
		private var loader:Loader = new Loader();
		private var bitmap:Bitmap = null;
		private var bitmapData:BitmapData = null;
		private var imageRecv:Array = new Array();
		private var lastUpdateTime:Number = 0;
		
		public function ImageReader(imageURL:String) {
			this.imageURL = imageURL;
			var request:URLRequest = new URLRequest(imageURL);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
//			loader.addEventListener(Event.COMPLETE,onCompleteHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onCompleteHandler);

//			loader.addEventListener(IOErrorEvent.IO_ERROR,OnErrorHandler);
//			loader.addEventListener(IOErrorEvent.DISK_ERROR,OnErrorHandler);
//			loader.addEventListener(IOErrorEvent.VERIFY_ERROR,OnErrorHandler);
//			loader.addEventListener(IOErrorEvent.NETWORK_ERROR,OnErrorHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,OnErrorHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR,OnErrorHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR,OnErrorHandler);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR,OnErrorHandler);
			var loaderContext:LoaderContext = new LoaderContext(true);
			loader.load(request,loaderContext);
			lastUpdateTime = new Date().milliseconds;
		}
		
		private function onCompleteHandler(event:Event):void {
			bitmap = Bitmap(loader.content);
            bitmapData = bitmap.bitmapData;
            for(var i:int=0;i<imageRecv.length;i++) {
            	var recv:ImageReceiver = imageRecv[i];
            	recv.onRecv(bitmapData);
            }
            imageRecv = new Array();
		}
		
		private function OnErrorHandler(event:Event) : void	{
			AppContext.getAppUtil().showStatus("无法加载图片:" + imageURL + "，请求的资源无效！");
            for(var i:int=0;i<imageRecv.length;i++) {
            	var recv:ImageReceiver = imageRecv[i];
            	recv.onRecv(null);
            }
            imageRecv = new Array();
		}
		
		public function addDataRecv(recv:ImageReceiver):void {
			if(bitmapData != null) {
				recv.onRecv(bitmapData);
			} else {
				imageRecv.push(recv);
			}
			lastUpdateTime = new Date().milliseconds;
		}
		
		public function getImageURL():String {
			return imageURL;
		}
		
		public function getData():BitmapData {
			return bitmapData;
		}

	}
}