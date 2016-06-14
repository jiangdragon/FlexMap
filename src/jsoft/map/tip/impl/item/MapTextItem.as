package jsoft.map.tip.impl.item
{
	import flash.display.DisplayObject;
	
	public class MapTextItem extends BaseMapListTipItem implements MapListTipItem
	{
		private var value:String="";
		
		public function MapTextItem() {
		}
		
		// 判断提示信息是否一致
		public override function isEqual(mapListTipItem:MapListTipItem) : Boolean {
			try {
				if(mapListTipItem != null && mapListTipItem is MapTextItem) {
					var tip:MapTextItem = mapListTipItem as MapTextItem;
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
			return getTextLabel(value,width);
		}
		
		public function getValue() : String {
			return value;
		}
		
		public function setValue(value:String) : void {
			this.value = value;
		}

	}
}