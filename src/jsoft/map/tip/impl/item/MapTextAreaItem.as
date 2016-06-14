package jsoft.map.tip.impl.item
{
	import flash.display.DisplayObject;
	
	import mx.controls.TextArea;
	
	public class MapTextAreaItem extends BaseMapListTipItem implements MapListTipItem
	{
		private var value:String="";
		
		public function MapTextAreaItem()
		{
		}
		// 判断提示信息是否一致
		public override function isEqual(mapListTipItem:MapListTipItem) : Boolean {
			try {
				if(mapListTipItem != null && mapListTipItem is MapTextAreaItem) {
					var tip:MapTextAreaItem = mapListTipItem as MapTextAreaItem;
					if(tip.name == name && tip.value == value) {
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
		// 将item添加到主窗口
		public override function getValueField(width:int) : DisplayObject {
			if(value == null || value.length == 0) {
				return null;
			}
			var height:int=18*value.split("\n").length;
			var textArea:TextArea = new TextArea();
			textArea.setStyle("fontSize",12);
			textArea.text = value;
			if(width != -1) {
				textArea.width = width;
			}
			textArea.height=height;
			return textArea;
		}
		
		public function getValue() : String {
			return value;
		}
		
		public function setValue(value:String) : void {
			this.value = value;
		}
	}
}