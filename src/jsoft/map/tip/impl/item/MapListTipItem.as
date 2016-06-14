package jsoft.map.tip.impl.item
{
	import flash.display.DisplayObject;
	
	public interface MapListTipItem {
		
		// 判断提示信息是否一致
		function isEqual(mapListTipItem:MapListTipItem) : Boolean;
		
		// 清除提示信息
		function destory() : void;
		
		// 获取名称
		function getNameField(width:int) : DisplayObject;
		
		// 将item添加到主窗口
		function getValueField(width:int) : DisplayObject;
	}
}