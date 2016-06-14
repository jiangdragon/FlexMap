package jsoft.map.config
{
	import jsoft.map.content.MapTile;
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Envelope;

	public class MapLevel
	{
		private var index:int;
		private var endX:int;
		private var endY:int;
		private var width:int;
		private var height:int;
		private var envelope:Envelope;
		private var config:MapConfig;
		private var coordinate:Coordinate;
		private var blankTile:MapTile;
		
		public function MapLevel(config:MapConfig) {
			this.config = config;
		}
		
		public function getIndex() : int {
			return index;
		}
		
		public function setIndex(index:int) : void {
			this.index = index;
		}
		
		public function getEndX() : int {
			return endX;
		}
		
		public function setEndX(endX:int) : void {
			this.endX = endX;
			coordinate = null;
		}
		
		public function getEndY() : int {
			return endY;
		}
		
		public function setEndY(endY:int) : void {
			this.endY = endY;
			coordinate = null;
		}
		
		public function getWidth() : int {
			return width;
		}
		
		public function setWidth(width:int) : void {
			this.width = width;
			coordinate = null;
		}
		
		public function getHeight() : int {
			return height;
		}
		
		public function setHeight(height:int) : void {
			this.height = height;
			coordinate = null;
		}
		
		public function getMap() : Envelope {
			return envelope;
		}
		
		public function setMap(envelope:Envelope) : void {
			this.envelope = envelope;
			coordinate = null;
		}
		// 获取等级的坐标映射关系
		public function getCoordinate() : Coordinate {
			if(coordinate == null) {
				coordinate = new Coordinate();
				coordinate.setScreenWidth(endX * width);
				coordinate.setScreenHeight(endY * height);
				var box:Box = envelope.toBox();
				coordinate.setMap(box);
			}
			return coordinate;
		}
		// 根据屏幕创建坐标映射关系
		public function createCoordinate(screenWidth:Number,screenHeight:Number) : Coordinate {
			var coordinate:Coordinate = new Coordinate();
			coordinate.setScreenWidth(screenWidth);
			coordinate.setScreenHeight(screenHeight);
			var unitX:Number = envelope.getWidth() / (endX * width);
			var unitY:Number = envelope.getHeight() / (endY * height);
			var mapWidth:Number = unitX * screenWidth;
			var mapHeight:Number = unitY * screenHeight;
			var box:Box = envelope.toBox();
			box.setMaxx(box.getMinx() + mapWidth);
			box.setMaxy(box.getMiny() + mapHeight);
			coordinate.setMap(box);
			return coordinate;
		}
		
		public function getTile(x:int,y:int):MapTile {
			if(x < 0 || y < 0 || x >= endX || y >= endY) {
				return getBlankTile(x,y);
			} else {
				var url:String = config.getMapURL();
				url += "lv" + index + "/lv" + index + "_" + y + "_" + x + "." + config.getImageType();
				if(blankTile == null) {
					getBlankTile(x,y);
				}
				var tile:MapTile = new MapTile(index,x,y,getLevelImageURL(x,y),width,height,null,blankTile);
				return tile;
			}
		}
		
		public function getEmptyTile(x:int,y:int):MapTile {
			var url:String = config.getMapURL();
			url += "blank." + config.getImageType();
			var newBlankTile:MapTile = new MapTile(index,x,y,url,width,height);
			return newBlankTile;
		}
		
		public function getBlankTile(x:int,y:int):MapTile {
			var url:String = config.getMapURL();
			url += "blank." + config.getImageType();
			if(blankTile != null && blankTile.getImage() != null) {
				var newBlankTile:MapTile = new MapTile(index,x,y,url,width,height,blankTile.getImage());
				return newBlankTile;
			} else if(config.getBlankTile() != null) {
				blankTile = config.getBlankTile();
				var parentBlankTile:MapTile = new MapTile(index,x,y,url,width,height,blankTile.getImage());
				return parentBlankTile;
			} else {
				blankTile = new MapTile(index,x,y,url,width,height);
				config.setBlankTile(blankTile);
				return blankTile;
			}
			
		}
		
		public function getLevelImageURL(x:int,y:int):String {
			var url:String = config.getCompatibleMapURL(index,x,y);
			if(x < 0 || y < 0 || x >= endX || y >= endY) {
				url += "blank." + config.getImageType();
			} else {
				url += "lv" + index + "/lv" + index + "_" + y + "_" + x + "." + config.getImageType();
			}
			return url;
		}
		
		public function toString() : String {
			return "MapLevel:index="+index+",endX="+endX+",endY="+endY+",width="+width+",height="+height+envelope.toString();
		}

	}
}