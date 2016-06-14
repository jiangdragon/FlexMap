package jsoft.map.event.vector
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsoft.map.content.MapContent;
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.event.MapEvent;
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.vector.BaseVector;
	import jsoft.map.vector.IVector;

	public class CreateVectorEvent implements MapEvent
	{
		private var vector:BaseVector = null;
		private var mouseDown:Boolean = false;
		private var startX:int;
		private var startY:int;
		private var endX:int;
		private var endY:int;
		
		public function CreateVectorEvent(vector:IVector) {
			this.vector = vector as BaseVector;
			MapCursorManager.clearCursor();
		}
		
		
		// 刷新屏幕
		public function onEnterFrame(event:Event):Boolean {
			return true;
		}
		
		// 鼠标按下
		public function onMouseDown(event:MouseEvent):Boolean {
			mouseDown = true;
			startX = event.stageX;
			startY = event.stageY;
			endX = event.stageX;
			endY = event.stageY;
			vector = vector.clone() as BaseVector;
			AppContext.getMapContext().getMapContent().getVectorLayer().addVector(vector);
			drawVector(startX,startY,endX,endY);
			return true;
		}
		
		// 鼠标移动
		public function onMouseMove(event:MouseEvent):Boolean {
			if(mouseDown) {
				endX = event.stageX;
				endY = event.stageY;
				drawVector(startX,startY,endX,endY);
				return true;
			}
			return true;
		}
		
		// 鼠标放开
		public function onMouseUp(event:MouseEvent):Boolean {
			if(mouseDown) {
				mouseDown = false;
				//AppContext.getAppUtil().releaseCapture();
				var mapContent:MapContent = AppContext.getMapContext().getMapContent();
				var coord:Coordinate = mapContent.getCoordinate();
				var minx:Number = coord.mapFromViewX(startX);
				var miny:Number = coord.mapFromViewY(startY);
				var maxx:Number = coord.mapFromViewX(endX);
				var maxy:Number = coord.mapFromViewY(endY);
				var mapBounds:Box = new Box();
				mapBounds.setBox(minx,miny,maxx,maxy);
				vector.setMapRangeBox(mapBounds);
				vector.setStatus(false);
				vector.showVector(coord);
				vector.updateVector();
				AppContext.getMapContext().getMapContent().getVectorLayer().setSelectEvent();
				return true;
			}
			return false;
		}
		
		// 鼠标离开
		public function onMouseLeave(event:Event):Boolean {
			onMouseUp(null);
			return true;
		}
		
		private function drawVector(x1:int,y1:int,x2:int,y2:int):void {
			//AppContext.getAppUtil().alert("CreatePointVectorEvent.drawVector ");
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			var coord:Coordinate = mapContent.getCoordinate();
			var minx:Number = coord.mapFromViewX(startX);
			var miny:Number = coord.mapFromViewY(startY);
			var maxx:Number = coord.mapFromViewX(endX);
			var maxy:Number = coord.mapFromViewY(endY);
			var mapBounds:Box = new Box();
			mapBounds.setBox(minx,miny,maxx,maxy);
			vector.setMapRangeBox(mapBounds);
			vector.setStatus(true);
			vector.showVector(coord);
			vector.updateVector()
		}
	}
}