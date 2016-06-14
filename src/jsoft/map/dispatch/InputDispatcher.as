package jsoft.map.dispatch
{
	import jsoft.map.MapContext;
	import jsoft.map.content.MapContent;
	import jsoft.map.event.MapEvent;
	import jsoft.map.event.input.CircleInput;
	import jsoft.map.event.input.LineInput;
	import jsoft.map.event.input.PointInput;
	import jsoft.map.event.input.PolyInput;
	import jsoft.map.event.input.RectInput;
	
	public class InputDispatcher implements Dispatcher
	{
		public function InputDispatcher() {
		}
		
		public function sendMessage(param:DispatchParam):void {
			if("point" == param.Type) {
				inputPoint();
				return;
			}
			if("line" == param.Type) {
				inputLine();
				return;
			}
			if("poly" == param.Type) {
				inputPoly();
				return;
			}
			if("circle" == param.Type) {
				inputCircle();
				return;
			}
			if("rect" == param.Type) {
				inputRect();
				return;
			}
		}
	
		public function getMessage(param:DispatchParam):String {
			return "";
		}
		
		public static function inputPoint():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			var mapEvent:MapEvent = new PointInput();
			mapContent.setMapEvent(mapEvent);
		}
		
		public static function inputLine():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			var mapEvent:MapEvent = new LineInput();
			mapContent.setMapEvent(mapEvent);
		}
		
		public static function inputPoly():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			var mapEvent:MapEvent = new PolyInput();
			mapContent.setMapEvent(mapEvent);
		}
		
		public static function inputCircle():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			var mapEvent:MapEvent = new CircleInput();
			mapContent.setMapEvent(mapEvent);
		}
		
		public static function inputRect():void {
			var mapContext:MapContext = AppContext.getMapContext();
			var mapContent:MapContent = mapContext.getMapContent();
			var mapEvent:MapEvent = new RectInput();
			mapContent.setMapEvent(mapEvent);
		}

	}
}