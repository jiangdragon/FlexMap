package jsoft.map.event.input
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import jsoft.map.content.MapContent;
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.event.MapEvent;
	import jsoft.map.geometry.Coordinate;

	public class PointInput implements MapEvent
	{
		private var xpos:int;
		private var ypos:int;
		private var radius:Number = 5;
		private var mapContent:MapContent = AppContext.getMapContext().getMapContent();
		
		public function PointInput() {
			MapCursorManager.clearCursor();
		}

		public function onEnterFrame(event:Event):Boolean {
			return true;
		}
		
		public function onMouseDown(event:MouseEvent):Boolean {
			xpos=event.stageX;
			ypos=event.stageY;
			AppContext.getMapContext().getMapContent().setMapPanEvent();
			AppContext.getMapContext().getMapDynInputLayer().drawCircle(xpos,ypos,radius);
			var coord:Coordinate = mapContent.getCoordinate();
			var mapX:Number = coord.mapFromViewX(xpos);
			var mapY:Number = coord.mapFromViewY(ypos);
			ExternalInterface.call("fMap.getFInput().inputPointBack",mapX,mapY);
			return true;
		}
		
		public function onMouseMove(event:MouseEvent):Boolean {
			return true;
		}
		
		public function onMouseUp(event:MouseEvent):Boolean {
			return true;
		}
		
		public function onMouseLeave(event:Event):Boolean {
			return true;
		}
		
	}
}