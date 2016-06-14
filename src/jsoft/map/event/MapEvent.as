package jsoft.map.event
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public interface MapEvent
	{
		// 刷新屏幕
		function onEnterFrame(event:Event):Boolean;
		
		// 鼠标按下
		function onMouseDown(event:MouseEvent):Boolean;
		
		// 鼠标移动
		function onMouseMove(event:MouseEvent):Boolean;
		
		// 鼠标放开
		function onMouseUp(event:MouseEvent):Boolean;
		
		// 鼠标离开
		function onMouseLeave(event:Event):Boolean;
	}
}