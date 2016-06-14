package jsoft.map.tip.impl.item
{
	import flash.display.DisplayObject;
	
	import mx.controls.Image;
	
	public class MapImageItem extends BaseMapListTipItem implements MapListTipItem
	{
		private var url:String="";
		private var image:Image = null;
		
		public function MapImageItem() {
		}
		
		// 判断提示信息是否一致
		public override function isEqual(mapListTipItem:MapListTipItem) : Boolean {
			try {
				if(mapListTipItem != null && mapListTipItem is MapImageItem) {
					var tip:MapImageItem = mapListTipItem as MapImageItem;
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
			image = null;
		}
		// 将item添加到主窗口
		public override function getValueField(width:int) : DisplayObject {
			var imageWidth:int = calWidth(width);
			if(image == null) {
				image = new Image();
				image.source=url;
				image.load();
			}
			image.width = imageWidth;
			image.height = imageWidth;
			return image;
		}
		
		public function getURL() : String {
			return url;
		}
		
		public function setURL(url:String) : void {
			this.url = url;
		}

	}
}