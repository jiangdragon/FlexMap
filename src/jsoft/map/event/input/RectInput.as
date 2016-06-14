package jsoft.map.event.input
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import jsoft.map.content.MapContent;
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.event.MapEvent;
	import jsoft.map.geometry.Coordinate;

	public class RectInput implements MapEvent
	{
		private var mouseDown:Boolean = false;
		private var mouseDownX:int = 0;
		private var mouseDownY:int = 0;
		private var mouseMoveX:int = -1;
		private var mouseMoveY:int = -1;
		private var mapContent:MapContent = AppContext.getMapContext().getMapContent();
		
		public function RectInput() {
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
			AppContext.getMapContext().getMapContent().setMapPanEvent();
			//AppContext.getMapContext().getMapInputLayer().clear();
			if ((Math.abs(this.mouseDownX-this.mouseMoveX )>1)  && (Math.abs(this.mouseDownY-this.mouseMoveY ))>1){
				var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
				var minx:Number = coord.mapFromViewX(mouseDownX);
				var maxx:Number = coord.mapFromViewX(mouseMoveX);
				var miny:Number = coord.mapFromViewY(mouseDownY);
				var maxy:Number = coord.mapFromViewY(mouseMoveY);
				var minX:Number=Math.min(minx,maxx);
				var minY:Number=Math.min(miny,maxy);
				var maxX:Number=Math.max(minx,maxx);
				var maxY:Number=Math.max(miny,maxy);
				ExternalInterface.call("fMap.getFInput().inputRectBack",minX,minY,maxX,maxY);
			}
		}
		
	}
}