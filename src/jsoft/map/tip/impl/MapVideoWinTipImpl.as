package jsoft.map.tip.impl
{
	import jsoft.map.image.URLVideo;
	import jsoft.map.tip.MapTip;
	import jsoft.map.tip.MapVideoTip;
	
	import mx.containers.Panel;
	import mx.containers.TitleWindow;
	import mx.events.CloseEvent;

	public class MapVideoWinTipImpl extends BaseMapTip implements MapVideoTip {
		private var url:String = null;
		private var width:int = -1;
		private var height:int = -1;
		
		public function MapVideoWinTipImpl() {
			super();
		}
		
		// 判断提示信息是否一致
		public override function isEqual(mapTip:MapTip) : Boolean {
			try {
				if(mapTip != null && mapTip is MapVideoWinTipImpl) {
					var tip:MapVideoWinTipImpl = mapTip as MapVideoWinTipImpl;
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
			initVideo(x,y);
			//startTimerEx(395000);
		}
		
		public override function showTipEx(x:int, y:int, timeOut:int):void {
			initVideo(x,y);
			startTimerEx(timeOut);
		}
		
		public override function hideTip() : void {
		}
		
		// 清除提示信息
		public override function destory() : void {
			var videoWin:Panel = window as Panel;
			if(videoWin != null) {
				var video:URLVideo = videoWin.getChildAt(0) as URLVideo;
				video.close();
			}
			destoryWindow();
		}
		
		private function titleWindow_close(evt:CloseEvent):void {
			var videoWin:Panel = window as Panel;
			if(videoWin != null) {
				var video:URLVideo = videoWin.getChildAt(0) as URLVideo;
				video.close();
			}
			AppContext.getMapContext().getMapContent().setTipWinCloseFlag(true);
			//AppContext.getAppUtil().alert("set close");
			destoryWindow();
        }
		
		private function initVideo(x:int, y:int) :TitleWindow {
			var videoWin:TitleWindow = window as TitleWindow;
			var video:URLVideo;
			if(videoWin == null) {
				video = new URLVideo();
				video.setAutoPlay(true);
				video.setAutoReplay(true);
				video.connect(url);
				videoWin = new TitleWindow();
				videoWin.title=title;
				videoWin.isPopUp=true;
				videoWin.showCloseButton = true;
				videoWin.addEventListener(CloseEvent.CLOSE,titleWindow_close);
				videoWin.addChild(video);
				videoWin.opaqueBackground=0xFFFFFF;
				addWindow(videoWin);
			} else {
				video = videoWin.getChildAt(0) as URLVideo;
			}
			videoWin.x = x;
			videoWin.y = y;
			videoWin.width = width + videoWin.viewMetrics.left + videoWin.viewMetrics.right;
			videoWin.height = height + videoWin.viewMetrics.top + videoWin.viewMetrics.bottom;
			videoWin.layout = "absolute";
			videoWin.autoLayout = true;
			//AppContext.getAppUtil().alert("MapVideoWinTip.initVideo.video="+video+"\nurl="+url);
			video.x = 0;
			video.y = 0;
			//AppContext.getAppUtil().alert("MapVideoWinTip.initVideo.width="+width+",height="+height);
			video.setWidth(width);
			video.setHeight(height);
			return videoWin;
		}
		
	}
}