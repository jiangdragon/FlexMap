package jsoft.map.tip.impl.item
{
	import flash.display.DisplayObject;
	
	import mx.controls.Label;

	public class BaseMapListTipItem implements MapListTipItem
	{
		protected var name:String = "";
		protected var leftWidth:int = 0;
		protected var rightWidth:int = 0;
		
		public function BaseMapListTipItem() {
		}
		
		// 判断提示信息是否一致
		public function isEqual(mapListTipItem:MapListTipItem) : Boolean {
			return false;
		}
		
		// 清除提示信息
		public function destory() : void {
		}
		
		// 获取名称
		public function getNameField(width:int) : DisplayObject {
			leftWidth = width;
			return getTextLabel(name,20*name.length);
		}
		
		// 将item添加到主窗口
		public function getValueField(width:int) : DisplayObject {
			rightWidth = width;
			return null;
		}
		
		public function getName() : String {
			return name;
		}
		
		public function setName(name:String) : void {
			this.name = name;
		}
		
		protected function calWidth(width:int) : int {
			var ret:int = width;
			if(name==null||name.length==0) {
				ret += leftWidth;
			}
			return ret;
		}
		
		protected function getTextLabel(text:String,width:int) : DisplayObject {
			if(text == null || text.length == 0) {
				return null;
			}
			var label:Label = new Label();
			label.text = text;
//			label.setStyle("fontSize","20");
			if(width != -1) {
				label.width = width;
			}
			return label;
			///var textField:TextField = new TextField();
			//textField.text = text;
			//var textFormat:TextFormat = new TextFormat();
			//textFormat.size = 12;
			//textFormat.color = DrawUtil.getBlue();
			//textField.setTextFormat(textFormat);
			//textField.autoSize = TextFieldAutoSize.LEFT;
			//textField.x=0;
			//textField.y=0;
			//textField.width = leftWidth;
			//textField.height = 30;
			//return textField;
		}
	}
}