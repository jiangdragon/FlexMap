package jsoft.map.tip
{
	public interface MapTextTip extends MapTip {
		
		// 获取提示的文本信息
		function getText() : String;
		
		// 设置提示的文本信息
		function setText(text:String) : void;
		
		// 获取字体，支持的字体：宋体、华文楷体、华文细黑、华文仿宋、华文中宋
		function getFontName() :  String;
		
		// 设置字体
		function setFontName(fontName:String) : void;
		
		// 获取字体大小
		function getFontSize() : int;
		
		// 设置字体大小
		function setFontSize(fontSize:int) : void;
		
		// 获取字体颜色
		function getFontColor() : int;
		
		// 设置字体颜色
		function setFontColor(color:int) : void;
		
		// 获取背景颜色
		function getBackColor() : int;
		
		// 设置背景颜色
		function setBackColor(color:int) : void;
		
		// 获取是否显示背景颜色
		function getShowBack() : Boolean;
		
		// 设置是否显示背景颜色
		function setShowBack(show:Boolean) : void;
		
		// 获取背景边框颜色
		function getBackOutlineColor() : int;
		
		// 设置背景边框颜色
		function setBackOutlineColor(color:int) : void;
		
		// 获取是否显示背景边框颜色
		function getShowBackOutline() : Boolean;
		
		// 设置是否显示背景边框颜色
		function setShowBackOutline(show:Boolean) : void;
		
		// 获取背景阴影颜色
		function getShadowColor() : int;
		
		// 设置背景阴影颜色
		function setShadowColor(color:int) : void;
		
		// 获取是否显示阴影颜色
		function getShowShadow() : Boolean;
		
		// 设置是否显示阴影颜色
		function setShowShadow(show:Boolean) : void;
	}
}