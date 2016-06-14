package jsoft.map.content
{
	import flash.events.MouseEvent;
	
	import jsoft.map.config.MapLevel;
	
	import mx.core.UIComponent;
	
	public class ContentLayer extends UIComponent implements MapLayer
	{
		private var content:MapContent;
		private var centerX:Number;
		private var centerY:Number;
		private var tileX:int;
		private var tileY:int;
		private var offsetX:Number;
		private var offsetY:Number;
		private var tilePool:MapTilePool = new MapTilePool();
		private var loadPics:int = 5;
		
		public function ContentLayer(content:MapContent) {
			this.content = content;
		}
		public function initLayer(layer:MapLayer):void {
			if(layer is ContentLayer) {
				var contentLayer:ContentLayer = layer as ContentLayer;
				centerX = contentLayer.getCenterX();
				centerY = contentLayer.getCenterY();
				tilePool = contentLayer.getTilePool();
				loadPics = contentLayer.getLoadPics();
			}
		}
		//  清除图片
		public function clearTiles():void {
			tilePool.removeAllTile(this);
		}
		//  删除图层
		public function removeLayer():void {
			if(content.contains(this)) {
				content.removeChild(this);
			}
		}
		//  载入图片
		public function loadTiles(x:Number,y:Number):void {
			calTilePosition(x,y);
			var minx:int = tileX - loadPics;
			var miny:int = tileY - loadPics;
			var maxx:int = tileX + loadPics;
			var maxy:int = tileY + loadPics;
			var mapLevel:MapLevel = content.getLevel();
			for(var i:int=minx;i<maxx;i++) {
				for(var j:int=miny;j<maxy;j++) {
					tilePool.addTile(mapLevel,i,j);
				}
			}
		}

		//  显示图片
		public function showMap(x:Number,y:Number):void {
			centerX = x;
			centerY = y;
		}
		
		public function showZoomMap(zoomLevelIndex:int):void {
			if(zoomLevelIndex < content.getLevelIndex() - 1) {
				// 这里限制缩小的等级显示，否则地图无法充满屏幕，背景会出现空白的情况
				//zoomLevelIndex = content.getLevelIndex() - 1;
			}
			calTilePosition(this.centerX,this.centerY);
			var minx:int = tileX - loadPics;
			var miny:int = tileY - loadPics;
			var maxx:int = tileX + loadPics;
			var maxy:int = tileY + loadPics;
			var zoomLevel:MapLevel = content.getMapConfig().getMapLevel(zoomLevelIndex);
			var mapLevel:MapLevel = content.getLevel();
			
			var offsetMapX:Number = offsetX / mapLevel.getCoordinate().getUnitX();
			var offsetMapY:Number = offsetY / mapLevel.getCoordinate().getUnitY();
			var zoomOffsetX:Number = zoomLevel.getCoordinate().getUnitX() * offsetMapX;
			var zoomOffsetY:Number = zoomLevel.getCoordinate().getUnitY() * offsetMapY;
			var centerX:int = this.width / 2 - zoomOffsetX;
			var centerY:int = this.height / 2 - zoomOffsetY;
			
			var mapWidth:Number = mapLevel.getWidth() / mapLevel.getCoordinate().getUnitX();
			var mapHeight:Number = mapLevel.getHeight() / mapLevel.getCoordinate().getUnitY();
			var zoomWidth:Number = zoomLevel.getCoordinate().getUnitX() * mapWidth;
			var zoomHeight:Number = zoomLevel.getCoordinate().getUnitY() * mapHeight;
			var intWidth:int = toInt(zoomWidth);
			var intHeight:int = toInt(zoomHeight);
			
			var startX:int = centerX - loadPics * zoomWidth + content.getShowOffsetX();
			var startY:int = centerY - loadPics * zoomHeight + content.getShowOffsetY();
			
//			trace("startX="+startX+", startY="+startY);
			if(Math.abs(zoomLevelIndex - content.getLevelIndex()) != 1) {
				tilePool.hideTile(this);
			}
			for(var i:int=minx;i<maxx;i++) {
				for(var j:int=miny;j<maxy;j++) {
					var tile:MapTile = tilePool.getTile(mapLevel,i,j);
					//trace(tile.getTileURL());
					if(tile != null) {
						if(!this.contains(tile)) {
							this.addChild(tile);
						}
						tile.x = startX + (i - minx) * zoomWidth;
						tile.y = startY + (j - miny) * zoomHeight;
						tile.width = intWidth;
						tile.height = intHeight;
						//tile.drawOutline();
						//trace("x="+tile.x+", y="+tile.y+", width="+tile.width+", height="+tile.height);
					}
				}
			}
		}
		
		private function toInt(val:Number):int {
			var ret:int = val;
			if(ret < val) {
				ret++;
			}
			return ret;
		}
		
		// 刷新地图
		public function refresh():void {
			x = 0;
			y = 0;
			this.width = content.width;
			this.height = content.height;
			if(!content.contains(this)) {
				content.addChild(this);
			}
			var mapLevel:MapLevel = content.getLevel();
			if(mapLevel == null) {
				return;
			}
			calTilePosition(this.centerX,this.centerY);
			var minx:int = tileX - loadPics;
			var miny:int = tileY - loadPics;
			var maxx:int = tileX + loadPics;
			var maxy:int = tileY + loadPics;
			var centerX:int = this.width / 2 - offsetX;
			var centerY:int = this.height / 2 - offsetY;
			var startX:int = centerX - loadPics * mapLevel.getWidth() + content.getShowOffsetX();
			var startY:int = centerY - loadPics * mapLevel.getHeight() + content.getShowOffsetY();
//			trace("startX="+startX+", startY="+startY);
			//AppContext.getAppUtil().alert("coord="+content.getCoordinate());
			tilePool.resetTile();
			for(var i:int=minx;i<maxx;i++) {
				for(var j:int=miny;j<maxy;j++) {
					var tile:MapTile = tilePool.getTile(mapLevel,i,j);
					//trace(tile.getTileURL());
					if(tile != null) {
						if(this.contains(tile)) {
							//this.removeChild(tile);
							//this.addChild(tile);
						} else {
							this.addChild(tile);
						}
						tile.setActive();
						tile.x = startX + (i - minx) * mapLevel.getWidth();
						tile.y = startY + (j - miny) * mapLevel.getHeight();
						tile.width = mapLevel.getWidth();
						tile.height = mapLevel.getHeight();
						//trace("x="+tile.x+", y="+tile.y+", width="+tile.width+", height="+tile.height);
					} else {
					}
				}
			}
			tilePool.clearTile(this);
		}
		
		// 获取中心点坐标
		public function getCenterX():Number {
			return centerX;
		}
		
		// 获取中心点坐标
		public function getCenterY():Number {
			return centerY;
		}
		
		public function getTilePool():MapTilePool {
			return tilePool;
		}
		
		public function setTilePool(tilePool:MapTilePool):void {
			this.tilePool = tilePool;
		}
		
		public function getLoadPics():int {
			return loadPics;
		}
		
		public function setLoadPics(loadPics:int):void {
			this.loadPics = loadPics;
		}
		
		private function calTilePosition(x:Number,y:Number):void {
			var mapLevel:MapLevel = content.getLevel();
			if(mapLevel == null) {
				return;
			}
			var viewx:Number = mapLevel.getCoordinate().mapToViewX(x);
			var viewy:Number = mapLevel.getCoordinate().mapToViewY(y);
			tileX = viewx / mapLevel.getWidth();
			tileY = viewy / mapLevel.getHeight();
			offsetX = viewx - tileX * mapLevel.getWidth();
			offsetY = viewy - tileY * mapLevel.getHeight();
		}

	}
}