package jsoft.map.event
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsoft.map.animate.ScrollMove;
	import jsoft.map.animate.ShowZoom;
	import jsoft.map.animate.SpeedCoolDown;
	import jsoft.map.content.MapContent;
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.geometry.Coordinate;
	
	public class MapPan implements MapEvent
	{
		private var mouseDown:Boolean = false;
		private var mouseMove:Boolean = false;
		private var mouseDownX:int = 0;
		private var mouseDownY:int = 0;
		private var mouseDownTime:Number = 0;
		private var mouseMoveX:int = -1;
		private var mouseMoveY:int = -1;
		private var mouseMoveTime:Number = 0;
		private var mapContent:MapContent = AppContext.getMapContext().getMapContent();
		private var scrollSpan:int = 20;
		
		private var lastClickTime:Number = 0;
		private var lastClickMoveX:int = 0;
		private var lastClickMoveY:int = 0;

		public function MapPan() {
			updateCursor();
		}
		
		public function onEnterFrame(event:Event):Boolean {
			return true;
		}

		// 鼠标按下
		public function onMouseDown(event:MouseEvent):Boolean {
			AppContext.getMapContext().getMapTipFactory().destory();
			if(AppContext.getMapContext().getLevelUI().isMouseDown()) {
				return true;
			}
			
			mouseDownX = event.stageX;
			mouseDownY = event.stageY;
			mouseDownTime = new Date().getTime();
			mouseMoveX = event.stageX;
			mouseMoveY = event.stageY;
			mouseMoveTime = new Date().getTime();
			mouseDown = true;
			mouseMove = false;
			mapContent.clearAnimate();
			
			var time:Number = AppContext.getAppUtil().getTime();
			//AppContext.getAppUtil().alert("111 time="+time+", lastClickTime="+lastClickTime);
			if(time - lastClickTime < 500 && lastClickMoveX == mouseDownX && lastClickMoveY == mouseDownY) {
				lastClickTime = 0;
				lastClickMoveX = 0;
				lastClickMoveY = 0;
				mouseDown = false;
				zoomMap();
				return true;
			} else {
				lastClickTime = time;
				lastClickMoveX = mouseDownX;
				lastClickMoveY = mouseDownY;
			}
			AppContext.getMapContext().clearInputLayer();
			return true;
		}
		
		// 鼠标移动
		public function onMouseMove(event:MouseEvent):Boolean {
			mouseMoveX = event.stageX;
			mouseMoveY = event.stageY;
			if(!mouseDown) {
				var cursorType:String = MapCursorManager.getCursorType();
				if(!("start" == cursorType || "end" == cursorType)){
					updateCursor();
				}
				return true;
			}
			mouseMove = true;
			mouseMoveX = event.stageX;
			mouseMoveY = event.stageY;
			mouseMoveTime = new Date().getTime();
			var offsetX:int = mouseMoveX - mouseDownX;
			var offsetY:int = mouseMoveY - mouseDownY;
			//trace("offsetX="+offsetX+", offsetY="+offsetY);
			mapContent.setShowOffset(offsetX,offsetY);
			mapContent.refresh();
			return true;
		}
		
		public function endMouse():void {
			if(!mouseDown) {
				return;
			}
			mouseDown = false;
			if(!mouseMove) {
				if(!checkRange(this.mouseDownX,mapContent.x,mapContent.x + mapContent.width) && !checkRange(this.mouseDownY,mapContent.y,mapContent.y + mapContent.height)) {
					return;
				}
				var cx:Number = mapContent.getCoordinate().mapFromViewX(this.mouseDownX);
				var cy:Number = mapContent.getCoordinate().mapFromViewY(this.mouseDownY);
				var scrollMove:ScrollMove = new ScrollMove(cx,cy);
				mapContent.setAnimate(scrollMove);
				return;
			}
			mouseMove = false;
			mapContent.setShowOffset(0,0);
			var offsetX:int = mouseMoveX - mouseDownX;
			var offsetY:int = mouseMoveY - mouseDownY;
			mapContent.moveTo(offsetX,offsetY);
			mapContent.showMap();
			mapContent.refresh();
			var endTime:Number = new Date().getTime();
//			trace("endTime="+endTime+", mouseMoveTime="+mouseMoveTime);
			if((endTime - mouseMoveTime) < 100) {
				var speedX:Number = offsetX / (endTime - mouseDownTime) * 0.5;
				var speedY:Number = offsetY / (endTime - mouseDownTime) * 0.5;
				//trace("speedX="+speedX+", speedY="+speedY);
				var speedCoolDown:SpeedCoolDown = new SpeedCoolDown(offsetX,offsetY,speedX,speedY);
				mapContent.setAnimate(speedCoolDown);
			}
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
		
		private function checkRange(val:int,min:int,max:int):Boolean {
//			if(Math.abs(val - min) < scrollSpan || Math.abs(val - max) < scrollSpan) {
//				return true;
//			}
			return false;
		}
		
		// 鼠标放开
		public function onMouseUp(event:MouseEvent):Boolean {
			if(!AppContext.getMapContext().getMapContent().getTipWinCloseFlag()) {
				endMouse();
			}
			//AppContext.getAppUtil().alert("up flag="+AppContext.getMapContext().getMapContent().getTipWinCloseFlag());
			return true;
		}
		
		// 鼠标离开
		public function onMouseLeave(event:Event):Boolean {
			endMouse();
			//AppContext.getAppUtil().alert("leave");
			return true;
		}
		
		public function updateCursor():void {
			if(mouseMoveX >= 0 && mouseMoveY >= 0) {
//				if(Math.abs(mouseMoveX) < scrollSpan && Math.abs(mouseMoveY) < scrollSpan) {
//					MapCursorManager.setSize2();
//					return;
//				}
//				if(Math.abs(mapContent.x + mapContent.width - mouseMoveX) < scrollSpan && Math.abs(mouseMoveY) < scrollSpan) {
//					MapCursorManager.setSize1();
//					return;
//				}
//				if(Math.abs(mapContent.x + mapContent.width - mouseMoveX) < scrollSpan && Math.abs(mapContent.y + mapContent.height - mouseMoveY) < scrollSpan) {
//					MapCursorManager.setSize2();
//					return;
//				}
//				if(Math.abs(mouseMoveX) < scrollSpan && Math.abs(mapContent.y + mapContent.height - mouseMoveY) < scrollSpan) {
//					MapCursorManager.setSize1();
//					return;
//				}
//				if(Math.abs(mouseMoveX) < scrollSpan) {
//					MapCursorManager.setSize3();
//					return;
//				}
//				if(Math.abs(mapContent.x + mapContent.width - mouseMoveX) < scrollSpan) {
//					MapCursorManager.setSize3();
//					return;
//				}
//				if(Math.abs(mouseMoveY) < scrollSpan) {
//					MapCursorManager.setSize4();
//					return;
//				}
//				if(Math.abs(mapContent.y + mapContent.height - mouseMoveY) < scrollSpan) {
//					MapCursorManager.setSize4();
//					return;
//				}
			}
			MapCursorManager.setHand();
		}
	}
}