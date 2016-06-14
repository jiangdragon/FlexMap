package jsoft.map.event
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsoft.map.content.MapContent;
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.geometry.Coordinate;
	
	public class MapZoomOut implements MapEvent
	{
		private var mouseDown:Boolean = false;
		private var mouseDownX:int = 0;
		private var mouseDownY:int = 0;
		private var mouseMoveX:int = -1;
		private var mouseMoveY:int = -1;
		private var mapContent:MapContent = AppContext.getMapContext().getMapContent();
		
		public function MapZoomOut() {
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
			var x1:int = mouseDownX;
			var y1:int = mouseDownY;
			var x2:int = mouseMoveX;
			var y2:int = mouseMoveY;
			if(x1 > x2) {
				var mouseX:int = x1;
				x1 = x2;
				x2 = mouseX;
			}
			if(y1 > y2) {
				var mouseY:int = y1;
				y1 = y2;
				y2 = mouseY;
			}
			var coord:Coordinate = mapContent.getCoordinate();
			var scale:int = (mapContent.getScreenWidth() / (x2-x1) + mapContent.getScreenHeight() / (y2-y1)) / 2;
			if(scale < 0) {
				scale = 1;
			} else if(scale > 3) {
				scale = 3;
			}
			var curIndex:int = mapContent.getLevelIndex();
			var level:int = curIndex - scale;
			var mapViewX:int = (x1+x2)/2;
			var mapViewY:int = (y1+y2)/2;
			var mapX:Number=coord.mapFromViewX(mapViewX);
			var mapY:Number=coord.mapFromViewY(mapViewY);
			level = mapContent.getLevelIndex();
			mapContent.zoomAndMoveMapToLevel(level,mapX,mapY);
			var newLevel:int = mapContent.getLevelIndex();
			if(newLevel == level) {
				mapContent.zoomMapToLevel(newLevel-1);
			}
		}

	}
}