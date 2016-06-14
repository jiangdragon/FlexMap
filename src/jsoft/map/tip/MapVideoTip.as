package jsoft.map.tip
{
	public interface MapVideoTip extends MapTip {
		
		// 获取提示的视频链接
		function getVideoUrl() : String;
		
		// 设置提示的视频链接
		function setVideoUrl(url:String) : void;
		
		// 获取图片的宽度
		function getVideoWidth() : int;
		
		// 设置图片的宽度
		function setVideoWidth(width:int) : void;
		
		// 获取图片的高度
		function getVideoHeight() : int;
		
		// 设置图片的高度
		function setVideoHeight(height:int) : void;
	}
}