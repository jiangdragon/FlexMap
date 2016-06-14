package jsoft.map.content
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import jsoft.map.config.MapLevel;
	
	import mx.core.UIComponent;
	
	public class MapTilePool
	{
		private var maxSize:int = 100;
		private var maxTimeOut:Number = 100 * 1000;
		private var tilePool:Array = new Array();
		private var content:UIComponent;
		private var timeOutId:Number=-1;
		private var clearFlag:Boolean = false;
		
		public function MapTilePool() {
		}
		
		public function getMaxSize():int {
			return maxSize;
		}
		
		public function setMaxSize(maxSize:int):void {
			this.maxSize = maxSize;
		}
		
		public function getMaxTimeOut():Number {
			return maxTimeOut;
		}
		
		public function setMaxTimeOut(maxTimeOut:Number):void {
			this.maxTimeOut = maxTimeOut;
		}
		
		public function addTile(level:MapLevel,x:int,y:int):MapTile {
			var index:int = level.getIndex();
			var key:String = "" + index + "_" + y + "_" + x;
			var tile:MapTile = tilePool[key];
			if(tile == null) {
				tile = level.getTile(x,y);
				tile.setMapPool(this);
				tilePool[key] = tile;
			} else {
				tile.updateLastTime();
			}
			return tile;
		}
		
		public function addEmptyTile(level:MapLevel,x:int,y:int):MapTile {
			var index:int = level.getIndex();
			var key:String = "" + index + "_" + y + "_" + x;
			var tile:MapTile = tilePool[key];
			if(tile == null) {
				tile = level.getEmptyTile(x,y);
				tilePool[key] = tile;
			} else {
				tile.updateLastTime();
			}
			tile.setMapPool(this);
			return tile;
		}
		
		public function getTile(level:MapLevel,x:int,y:int):MapTile {
			var index:int = level.getIndex();
			var key:String = "" + index + "_" + y + "_" + x;
			var tile:MapTile = tilePool[key];
			if(tile != null) {
				tile.updateLastTime();
				tile.setMapPool(this);
			} else {
				//AppContext.getAppUtil().alert("无法加载图片：" + key);
				tile = level.getTile(x,y);
				tile.setMapPool(this);
				tilePool[key] = tile;
			}
			return tile;
		}
		
		public function hideTile(content:UIComponent):void {
			var item:MapTile;
			for each(item in tilePool) {
				if(content.contains(item)) {
					content.removeChild(item);
				}
			}
		}
		
		public function resetTile():void {
			var item:MapTile;
			for each(item in tilePool) {
				item.clearActive();
			}
		}
		
		public function clearTile(content:UIComponent):void {
			if(content == null && !clearFlag) {
				return;
			}
			clearFlag = true;
			if(content != null) {
				this.content = content;
			}
			if(timeOutId != -1) {
				clearTimeout(timeOutId);
				timeOutId = -1;
			}
			timeOutId = setTimeout(clearTilePool,1000);
			if(!isAllLoad()) {
				return;
			}
			if(tilePool.length < maxSize) {
				//return;
			}
			clearTilePool();
		}
		
		private function clearTilePool():void {
			if(timeOutId != -1) {
				clearTimeout(timeOutId);
				timeOutId = -1;
			}
			if(!clearFlag) {
				return;
			}
			clearFlag = false;
			var item:MapTile;
			var time:Number = new Date().getTime();
			var newPool:Array = new Array();
			for each(item in tilePool) {
				if(!item.isActive()) {
					if(content.contains(item)) {
						content.removeChild(item);
					}
				} else {
				//if(item.isActive() || time - item.getLastTime() < maxTimeOut) {
					var key:String = "" + item.getLevel() + "_" + item.getTileY() + "_" + item.getTileX();
					newPool[key] = item;
				}
				//item.clearActive();
			}
			tilePool = newPool;
		}
		
		private function isAllLoad():Boolean {
			var item:MapTile;
			for each(item in tilePool) {
				if(item.getLevel() ==  AppContext.getMapContext().getMapContent().getLevelIndex()) {
					if(!item.isLoad()) {
						return false;
					}
				}
			}
			return true;
		}
		
		public function removeAllTile(content:UIComponent):void {
			var item:MapTile;
			for each(item in tilePool) {
				if(content.contains(item)) {
					content.removeChild(item);
				}
			}
			tilePool = new Array();
		}

	}
}