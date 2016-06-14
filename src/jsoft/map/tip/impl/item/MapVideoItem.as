package jsoft.map.tip.impl.item
{
	import flash.display.DisplayObject;
	
	import jsoft.map.image.URLVideo;
	
	public class MapVideoItem extends BaseMapListTipItem implements MapListTipItem
	{
		private var url:String="";
		private var video:URLVideo = null;
		
		public function MapVideoItem() {
		}
		
		// 判断提示信息是否一致
		public override function isEqual(mapListTipItem:MapListTipItem) : Boolean {
			try {
				if(mapListTipItem != null && mapListTipItem is MapVideoItem) {
					var tip:MapVideoItem = mapListTipItem as MapVideoItem;
					if(tip.name == name && tip.url == url) {
						return true;
					}
				}
			} catch(errObject:Error) {
			}
			return false;
		}
		// 清除提示信息
		public override function destory() : void {
			if(video != null) {
				video.close();
				video = null;
			}
		}
		// 将item添加到主窗口
		public override function getValueField(width:int) : DisplayObject {
			var imageWidth:int = calWidth(width);
			if(video == null) {
				video = new URLVideo();
				video.setAutoPlay(true);
				video.setAutoReplay(true);
				video.connect(url);
			}
			video.setWidth(imageWidth);
			video.setHeight(imageWidth);
			return video;
		}
		
		public function getURL() : String {
			return url;
		}
		
		public function setURL(url:String) : void {
			this.url = url;
		}

	}
}