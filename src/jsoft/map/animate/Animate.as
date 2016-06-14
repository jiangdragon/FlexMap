package jsoft.map.animate
{
	import jsoft.map.content.MapContent;
	
	public interface Animate
	{
		// 执行动画
		function onFrame(content:MapContent):void;
	}
}