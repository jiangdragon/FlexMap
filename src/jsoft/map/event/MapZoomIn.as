package jsoft.map.event
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsoft.map.animate.ShowZoom;
	import jsoft.map.content.MapContent;
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	
	public class MapZoomIn implements MapEvent
	{
		private var mouseDown:Boolean = false;
		private var mouseDownX:int = 0;
		private var mouseDownY:int = 0;
		private var mouseMoveX:int = -1;
		private var mouseMoveY:int = -1;
		private var mapContent:MapContent = AppContext.getMapContext().getMapContent();
		
		public function MapZoomIn() {
			MapCursorManager.clearCursor();
		}
		
		public function onEnterFrame(event:Event):Boolean {
			return true;
		}

		// 鼠标按下
		public function onMouseDown(event:MouseEvent):Boolean {
			if(AppContext.getMapContext().getLevelUI().isMouseDown()) {
				return true;
			}
			mouseDownX = event.stageX;
			mouseDownY = event.stageY;
			mouseMoveX = event.stageX;
			mouseMoveY = event.stageY;
			mouseDown = true;
			mapContent.clearAnimate();
			AppContext.getMapContext().clearInputLayer();
			return true;
		}
		
		// 鼠标移动
		public function onMouseMove(event:MouseEvent):Boolean {
			if(!mouseDown) {
				return true;
			}
			mouseMoveX = event.stageX;
			mouseMoveY = event.stageY;
			AppContext.getMapContext().getMapInputLayer().drawBox(mouseDownX,mouseDownY,mouseMoveX,mouseMoveY);
			return true;
		}
		
		// 鼠标放开
		public function onMouseUp(event:MouseEvent):Boolean {
			endMouse();
			return true;
		}
		
		// 鼠标离开
		public function onMouseLeave(event:Event):Boolean {
			endMouse();
			return true;
		}
		
		public function endMouse():void {
			if(!mouseDown) {
				return;
			}
			mouseDown = false;
			AppContext.getMapContext().getMapInputLayer().clear();
			if(mouseDownX == mouseMoveX || mouseDownY == mouseMoveY) {
				//var nextLevel:int = mapContent.getLevelIndex() + 1;
				//mapContent.zoomMapToLevel(nextLevel);
				zoomMap();
				return;
			}
			var coord:Coordinate = mapContent.getCoordinate();
			var minx:Number = coord.mapFromViewX(mouseDownX);
			var miny:Number = coord.mapFromViewY(mouseDownY);
			var maxx:Number = coord.mapFromViewX(mouseMoveX);
			var maxy:Number = coord.mapFromViewY(mouseMoveY);
			var mapBounds:Box = new Box();
			mapBounds.setBox(minx,miny,maxx,maxy);
			mapBounds.normalizeBox();
			var level:int = mapContent.getLevelIndex();
			mapContent.zoomMapToRangeBox(mapBounds);
			var newLevel:int = mapContent.getLevelIndex();
			if(newLevel == level) {
				mapContent.setLevelIndex(level+1);
				mapContent.refresh();
			}
			//mapContent.showMap();
			//mapContent.refresh();
		}
		
		private function zoomMap():void {
			//trace(mapContent.getCoordinate());
			var cx:Number = mapContent.getCoordinate().mapFromViewX(this.mouseDownX);
			var cy:Number = mapContent.getCoordinate().mapFromViewY(this.mouseDownY);
			//trace("mouseDownX="+mouseDownX+", mouseDownY=" + mouseDownY);
			//trace("cx="+cx+", cy=" + cy);
			var level:int = mapContent.getLevelIndex();
			if(level < 0 || level + 1 >= mapContent.getMapConfig().getMapLevelLength()) {
				return;
			}
			// 计算移动点到中心点的偏移
			var viewCX:int = mapContent.getCoordinate().getScreenWidth() / 2;
			var viewCY:int = mapContent.getCoordinate().getScreenHeight() / 2;
			//trace("viewCX="+viewCX+", viewCY=" + viewCY);
			var viewOffsetX:int = viewCX - this.mouseDownX;
			var viewOffsetY:int = viewCY - this.mouseDownY;
			//trace("viewOffsetX="+viewOffsetX+", viewOffsetY=" + viewOffsetY);
			//trace("cx="+cx+", cy=" + cy);
			// 计算新坐标系下虚拟屏幕的坐标
			var coord:Coordinate = mapContent.getMapConfig().getMapLevel(level + 1).getCoordinate();
			//trace("level="+level+", coord=" + coord);
			var newLevelX:int = coord.mapToViewX(cx);
			var newLevelY:int = coord.mapToViewY(cy);
			//trace("newLevelX="+newLevelX+", newLevelY=" + newLevelY);
			// 根据偏移量，计算新坐标系下虚拟屏幕中心点坐标
			var newLevelCenterX:int = viewOffsetX + newLevelX;
			var newLevelCenterY:int = viewOffsetY + newLevelY;
			//trace("newLevelCenterX="+newLevelCenterX+", newLevelCenterY=" + newLevelCenterY);
			var newCenterX:Number = coord.mapFromViewX(newLevelCenterX);
			var newCenterY:Number = coord.mapFromViewY(newLevelCenterY);
			//trace("newCenterX="+newCenterX+", newCenterY=" + newCenterY);
			
			var showZoom:ShowZoom = new ShowZoom(this.mouseDownX,this.mouseDownY);
			mapContent.setAnimate(showZoom);
			mapContent.setCenter(newCenterX,newCenterY);
			mapContent.setLevelIndex(level+1);
			mapContent.showMap();
			mapContent.refresh();
			var ncx:Number = mapContent.getCoordinate().mapFromViewX(this.mouseDownX);
			var ncy:Number = mapContent.getCoordinate().mapFromViewY(this.mouseDownY);
			//trace("ncx="+cx+", ncy=" + cy);
		}

	}
}