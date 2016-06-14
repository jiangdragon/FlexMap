package jsoft.map.tip.impl
{
	import jsoft.map.tip.MapImageTip;
	import jsoft.map.tip.MapTip;
	
	import mx.controls.Image;

	public class MapImageTipImpl extends BaseMapTip implements MapImageTip
	{
		private var url:String = null;
		private var width:int = -1;
		private var height:int = -1;
		
		public function MapImageTipImpl() {
			super();
		}
		
		// 判断提示信息是否一致
		public override function isEqual(mapTip:MapTip) : Boolean {
			try {
				if(mapTip != null && mapTip is MapImageTipImpl) {
					var tip:MapImageTipImpl = mapTip as MapImageTipImpl;
					if(tip.url == url) {
						width = tip.width;
						height = tip.height;
						return true;
					}
				}
			} catch(errObject:Error) {
			}
			return false;
		}
		
		// 获取提示的图片链接
		public function getImageUrl() : String {
			return url;
		}
		
		// 设置提示的图片链接
		public function setImageUrl(url:String) : void {
			this.url = url;
		}
		
		// 获取图片的宽度
		public function getImageWidth() : int {
			return width;
		}
		
		// 设置图片的宽度
		public function setImageWidth(width:int) : void {
			this.width = width;
		}
		
		// 获取图片的高度
		public function getImageHeight() : int {
			return height;
		}
		
		// 设置图片的高度
		public function setImageHeight(height:int) : void {
			this.height = height;
		}
		
		public override function showTip(x:int, y:int):void {
			addWindow(initImage(x,y));
			startTimer();
		}
		
		public override function showTipEx(x:int, y:int, timeOut:int):void {
			addWindow(initImage(x,y));
			startTimerEx(timeOut);
		}
		
		private function initImage(x:int, y:int) : Image {
			var image:Image = window as Image;
			//AppContext.getAppUtil().alert("MapImageTip.initImage.image="+image+"\nurl="+url);
			if(image == null) {
				image = new Image();
				image.source=url;
				image.load();
			}
			image.x = x;
			image.y = y;
			//AppContext.getAppUtil().alert("MapImageTip.initImage.width="+width+",height="+height);
			if(width != -1) {
				image.width = width;
			}
			if(height != -1) {
				image.height = height;
			}
			return image;
		}
	}
}