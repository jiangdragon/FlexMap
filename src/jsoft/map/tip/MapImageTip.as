package jsoft.map.tip
{
	public interface MapImageTip extends MapTip {
		
		// 获取提示的图片链接
		function getImageUrl() : String;
		
		// 设置提示的图片链接
		function setImageUrl(url:String) : void;
		
		// 获取图片的宽度
		function getImageWidth() : int;
		
		// 设置图片的宽度
		function setImageWidth(width:int) : void;
		
		// 获取图片的高度
		function getImageHeight() : int;
		
		// 设置图片的高度
		function setImageHeight(height:int) : void;
	}
}