package jsoft.map.tip.impl
{
	import jsoft.map.image.URLVideo;
	import jsoft.map.tip.MapTip;
	import jsoft.map.tip.MapVideoTip;

	public class MapVideoTipImpl extends BaseMapTip implements MapVideoTip
	{
		private var url:String = null;
		private var width:int = -1;
		private var height:int = -1;
		
		public function MapVideoTipImpl() {
			super();
		}
		
		// 判断提示信息是否一致
		public override function isEqual(mapTip:MapTip) : Boolean {
			try {
				if(mapTip != null && mapTip is MapVideoTipImpl) {
					var tip:MapVideoTipImpl = mapTip as MapVideoTipImpl;
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
		public function getVideoUrl() : String {
			return url;
		}
		
		// 设置提示的图片链接
		public function setVideoUrl(url:String) : void {
			this.url = url;
		}
		
		// 获取图片的宽度
		public function getVideoWidth() : int {
			return width;
		}
		
		// 设置图片的宽度
		public function setVideoWidth(width:int) : void {
			this.width = width;
		}
		
		// 获取图片的高度
		public function getVideoHeight() : int {
			return height;
		}
		
		// 设置图片的高度
		public function setVideoHeight(height:int) : void {
			this.height = height;
		}
		
		public override function showTip(x:int, y:int):void {
			addWindow(initVideo(x,y));
			//clearTimer();
			
			// 默认设置为视频的长度
			var video:URLVideo = window as URLVideo;
			if(video.getTotalTime() > 0) {
				startTimerEx(video.getTotalTime());
			}
		}
		
		public override function showTipEx(x:int, y:int, timeOut:int):void {
			addWindow(initVideo(x,y));
			//clearTimer();
			startTimerEx(timeOut);
		}
		
		public override function hideTip() : void {
			destory();
		}
		
		// 清除提示信息
		public override function destory() : void {
			var video:URLVideo = window as URLVideo;
			if(video != null) {
				video.close();
			}
			destoryWindow();
		}
		
		private function initVideo(x:int, y:int) : URLVideo {
			var video:URLVideo = window as URLVideo;
			//AppContext.getAppUtil().alert("MapVideoTip.initVideo.video="+video+"\nurl="+url);
			if(video == null) {
				video = new URLVideo();
				video.setAutoPlay(true);
				video.connect(url);
			}
			video.x = x;
			video.y = y;
			//AppContext.getAppUtil().alert("MapVideoTip.initVideo.width="+width+",height="+height);
			video.setWidth(width);
			video.setHeight(height);
			return video;
		}
		
	}
}