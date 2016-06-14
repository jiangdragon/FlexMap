package jsoft.map.tip.impl.item
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import mx.controls.Button;
	
	public class MapJSLinkItem extends BaseMapListTipItem implements MapListTipItem
	{
		private var js:String="";
		
		public function MapJSLinkItem() {
		}
		
		// 判断提示信息是否一致
		public override function isEqual(mapListTipItem:MapListTipItem) : Boolean {
			try {
				if(mapListTipItem != null && mapListTipItem is MapJSLinkItem) {
					var tip:MapJSLinkItem = mapListTipItem as MapJSLinkItem;
					if(tip.name == name && tip.js == js) {
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
			var button:Button = new Button();
			button.label = name;
			button.toolTip = name;
			button.addEventListener(MouseEvent.CLICK,onClick);
			return button;
		}
		
		private function onClick(event:MouseEvent) : void {
			//AppContext.getAppUtil().alert("click button");
			ExternalInterface.call("fMap.callback",js);
			//ExternalInterface.call("alert('123')");
		}
		
		public function getJS() : String {
			return js;
		}
		
		public function setJS(js:String) : void {
			this.js = js;
		}

	}
}