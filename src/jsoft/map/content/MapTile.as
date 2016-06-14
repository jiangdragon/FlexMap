package jsoft.map.content
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	
	import jsoft.map.image.ImageReceiver;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.events.ResizeEvent;

	public class MapTile extends UIComponent implements ImageReceiver
	{
		private var level:int;
		private var tileX:int;
		private var tileY:int;
		private var tileURL:String;
		private var image:Image;
		private var bitmap:BitmapData;
		private var errorImage:MapTile;
		private var lastTime:Number = new Date().getTime();
		private var loadFlag:Boolean = false;
		private var mapTilePool:MapTilePool;
		private var activeFlag:Boolean = false;
		
		public function MapTile(level:int,tileX:int,tileY:int,tileURL:String,width:int,height:int,bitmap:BitmapData=null,errorImage:MapTile=null) {
			super();
			this.level = level;
			this.tileX = tileX;
			this.tileY = tileY;
			this.tileURL = tileURL;
			this.width = width;
			this.height = height;
			image = new Image();
			image.load(tileURL);
			image.x = 0;
			image.y = 0;
			image.width = this.width;
			image.height = this.height;
			this.addChild(image);
			this.addEventListener(ResizeEvent.RESIZE,onResize);
		}
		
		public function onResize(event:ResizeEvent):void {
			image.x = 0;
			image.y = 0;
			image.width = this.width;
			image.height = this.height;
		}
		
		public function setMapPool(mapTilePool:MapTilePool):void {
			this.mapTilePool = mapTilePool;
		}
		
		public function isLoad():Boolean {
			return loadFlag;
		}
		
		private function onRender(event:Event):void {
			show();
		}
		
		public function onRecv(imageData:BitmapData):void {
			if(imageData != null) {
				this.bitmap = imageData;
			} else if(errorImage != null) {
				this.bitmap = errorImage.getImage();
			}
			if(mapTilePool!=null) {
				mapTilePool.clearTile(null);
			}
			loadFlag = true;
			show();
		}
		
		public function show():void {
			graphics.clear();
			if(bitmap != null) {
				var sx:Number = width / bitmap.width;
				var sy:Number = height / bitmap.height;
				var matrix:Matrix = new Matrix(sx,0,0,sy,0,0);
				graphics.beginBitmapFill(bitmap,matrix,false,true);
				graphics.drawRect(0,0,width,height);
				graphics.endFill();
			}
		}
		
		public function drawOutline():void {
			graphics.clear();
			graphics.lineStyle(2,255);
			graphics.drawRect(0,0,width,height);
		}
		
		public function getLevel():int {
			return level;
		}
		
		public function getTileX():int {
			return tileX;
		}
		
		public function getTileY():int {
			return tileY;
		}
		
		public function getTileURL():String {
			return tileURL;
		}
		
		public function getImage():BitmapData {
			return bitmap;
		}
		
		public function getLastTime():Number {
			return lastTime;
		}
		
		public function updateLastTime():void {
			lastTime = new Date().getTime();
		}
		
		public function isActive():Boolean {
			return activeFlag;
		}
		
		public function clearActive():void {
			activeFlag = false;
		}
		
		public function setActive(activeFlag:Boolean=true):void {
			this.activeFlag = activeFlag;
		}
	}
}