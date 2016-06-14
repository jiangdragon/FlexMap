package jsoft.map.tip
{
	public interface MapTip {
		
		// 判断提示信息是否一致
		function isEqual(mapTip:MapTip) : Boolean;
		
		// 获取提示的标题信息
		function getTitle() : String;
		
		// 设置提示的标题信息
		function setTitle(title:String) : void;
		
		// 在指定位置显示提示信息
		function showTip(x:int,y:int) : void;
		
		// 在指定位置显示信息提示框，并在鼠标移开后指定的空闲时间后关闭提示信息
		function showTipEx(x:int,y:int,timeOut:int) : void;
		
		// 关闭屏幕上的信息提示
		function hideTip() : void;
		
		// 清除提示信息
		function destory() : void;
	}
}