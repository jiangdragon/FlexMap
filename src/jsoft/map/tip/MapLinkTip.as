package jsoft.map.tip
{
	//点击执行url链接
	public interface MapLinkTip extends MapTip
	{
		// 获取提示的标题信息
		function getLink() : String;
		// 设置提示的标题信息
		function setLink(link:String) : void;
		// 获取提示窗口显示参数
		function getLinkWinParam() : String;
		// 设置提示窗口显示参数
		function setLinkWinParam(linkWinParam:String) : void;
		//获取类型
		function getType():int;
		//设置类型
		function setType(type:int):void;
	}
}