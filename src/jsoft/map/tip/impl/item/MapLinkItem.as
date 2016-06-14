package jsoft.map.tip.impl.item
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import mx.controls.Button;
	
	public class MapLinkItem extends BaseMapListTipItem implements MapListTipItem
	{
		private var url:String="";
		private var linkWinParam:String="";
		
		public function MapLinkItem() {
		}
		
		// 判断提示信息是否一致
		public override function isEqual(mapListTipItem:MapListTipItem) : Boolean {
			try {
				if(mapListTipItem != null && mapListTipItem is MapLinkItem) {
					var tip:MapLinkItem = mapListTipItem as MapLinkItem;
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
		}
		
		// 获取名称
		public override function getNameField(width:int) : DisplayObject {
			return null;
		}
		// 将item添加到主窗口
		public override function getValueField(width:int) :DisplayObject {
			var imageWidth:int = calWidth(width);
			var button:Button = new Button();
			button.label = name;
			button.toolTip = name;
			button.addEventListener(MouseEvent.CLICK,onClick);
			//button.width = imageWidth;
			return button;
		}
		
		private function onClick(event:MouseEvent) : void {
			//AppContext.getAppUtil().alert("click button");
			//ExternalInterface.call("fMap.openWindow",name,url,linkWinParam);
			ExternalInterface.call("window.open('"+url+"')");
		}
		
		public function getURL() : String {
			return url;
		}
		
		public function setURL(url:String) : void {
			this.url = url;
		}
		// 获取提示窗口显示参数
		public function getLinkWinParam() : String{
			return linkWinParam;
		}
		
		// 设置提示窗口显示参数
		public function setLinkWinParam(linkWinParam:String) : void{
			this.linkWinParam=linkWinParam;
		}

	}
}