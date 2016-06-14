package jsoft.map.tip
{
	import jsoft.map.tip.impl.item.MapListTipItem;
	
	public interface MapListTip extends MapTip {
		
		// 初始化
		function initMapLitTip() : void;
		
		// 获取宽度
		function getWidth() : int;
		
		// 设置宽度
		function setWidth(width:int) : void;
		
		// 获取高度
		function getHeight() : int;
		
		// 设置高度
		function setHeight(height:int) : void;
		
		// 添加文本信息
		function addText(name:String,value:String) : void;
		
		// 添加文本域信息
		function addTextArea(name:String,value:String) : void;
		
		// 添加图片信息
		function addImage(name:String,url:String) : void;
		
		// 添加视频信息
		function addVideo(name:String,url:String) : void;
		
		// 添加js响应函数
		function addLinkJS(name:String,jsFuncName:String) : void;
		// 添加关闭
		function addClose(name:String,closed:Boolean):void;
		// 添加链接的地址
		function addLinkURL(name:String,url:String,linkWinParam:String) : void;
		
		// 获取已经添加的列表
		function getListItem(pos:int) : MapListTipItem;
		
		// 获取已经添加的数量
		function getListItemCount() : int;
		
		// 添加
		function addListItem(item:MapListTipItem) : void;
		
		// 插入
		function insertListItem(pos:int,item:MapListTipItem) : void;
		
		// 删除
		function removeListItem(pos:int) : MapListTipItem;
		
		// 清空
		function clearListItem() : void;
	}
}