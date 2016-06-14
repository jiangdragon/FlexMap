package jsoft.map.event
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	public class MapHotEvent implements MapEvent
	{
		private var timeOutId:int = -1;
		
		public function MapHotEvent() {
		}
		
		public function onEnterFrame(event:Event):Boolean {
			return false;
		}

		// 鼠标按下 
		public function onMouseDown(event:MouseEvent):Boolean {
			var x:int = event.stageX;
			var y:int = event.stageY;
			if(AppContext.getMapContext().getHotInstance().showClickHot(x,y)){
				//startTimer();
				return true;
			}else{
				//clearTimeout(timeOutId);
				AppContext.getMapContext().getHotInstance().hideHot();
			}
			return false;
		}
		
		// 鼠标移动
		public function onMouseMove(event:MouseEvent):Boolean {
			var x:int = event.stageX;
			var y:int = event.stageY;
			if(AppContext.getMapContext().getHotInstance().showHot(x,y)) {
				//startTimer();
				//AppContext.getAppUtil().showStatus("show hot tip x="+x+",y="+y);
				return true;
			} else {
				//clearTimeout(timeOutId);
				AppContext.getMapContext().getHotInstance().hideHot();
			}
			return false;
		}
		
		// 鼠标放开
		public function onMouseUp(event:MouseEvent):Boolean {
			return false;
		}
		
		// 鼠标离开
		public function onMouseLeave(event:Event):Boolean {
			return true;
		}
		
		public function clearTimer() : void {
			if(timeOutId > 0) {
				clearTimeout(timeOutId);
				timeOutId = -1;
			}
		}
		
		public function startTimer() : void {
			clearTimer();
			timeOutId = setTimeout(closeHotTip,60*1000);
		}
		//要去掉注释
		public function closeHotTip() : void {
			timeOutId = -1;
//			AppContext.getMapContext().getHotInstance().clearHotTip();
		}

	}
}