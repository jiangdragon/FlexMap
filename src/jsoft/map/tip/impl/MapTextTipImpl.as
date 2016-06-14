package jsoft.map.tip.impl
{
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import jsoft.map.tip.MapTextTip;
	import jsoft.map.tip.MapTip;

	public class MapTextTipImpl extends BaseMapTip implements MapTextTip
	{
		private var text:String = "";
		private var fontName:String = "宋体";
		private var fontSize:int = 26;
		private var fontColor:int = 255;
		private var backColor:int = 0;
		private var showBack:Boolean=false;
		private var backOutlineColor:int = 0;
		private var showBackOutline:Boolean=false;
		private var shadowColor:int = 0;
		private var showShadow:Boolean=false;
		
		public function MapTextTipImpl() {
			super();
		}
		
		// 判断提示信息是否一致
		public override function isEqual(mapTip:MapTip) : Boolean {
			return false;
		}
		
		// 获取提示的文本信息
		public function getText() : String {
			return text;
		}
		
		// 设置提示的文本信息
		public function setText(text:String) : void {
			this.text = text;
		}
		
		// 获取字体，支持的字体：宋体、华文楷体、华文细黑、华文仿宋、华文中宋
		public function getFontName() :  String {
			return fontName;
		}
		
		// 设置字体
		public function setFontName(fontName:String) : void {
			this.fontName = fontName;
		}
		
		// 获取字体大小
		public function getFontSize() : int {
			return fontSize;
		}
		
		// 设置字体大小
		public function setFontSize(fontSize:int) : void {
			this.fontSize = fontSize;
		}
		
		// 获取字体颜色
		public function getFontColor() : int {
			return fontColor;
		}
		
		// 设置字体颜色
		public function setFontColor(color:int) : void {
			fontColor = color;
		}
		
		// 获取背景颜色
		public function getBackColor() : int {
			return backColor;
		}
		
		// 设置背景颜色
		public function setBackColor(color:int) : void {
			backColor = color;
		}
		
		// 获取是否显示背景颜色
		public function getShowBack() : Boolean {
			return showBack;
		}
		
		// 设置是否显示背景颜色
		public function setShowBack(show:Boolean) : void {
			showBack = show;
		}
		
		// 获取背景边框颜色
		public function getBackOutlineColor() : int {
			return backOutlineColor;
		}
		
		// 设置背景边框颜色
		public function setBackOutlineColor(color:int) : void {
			backOutlineColor = color;
		}
		
		// 获取是否显示背景边框颜色
		public function getShowBackOutline() : Boolean {
			return showBackOutline;
		}
		
		// 设置是否显示背景边框颜色
		public function setShowBackOutline(show:Boolean) : void {
			showBackOutline = show;
		}
		
		// 获取背景阴影颜色
		public function getShadowColor() : int {
			return shadowColor;
		}
		
		// 设置背景阴影颜色
		public function setShadowColor(color:int) : void {
			shadowColor = color;
		}
		
		// 获取是否显示阴影颜色
		public function getShowShadow() : Boolean {
			return showShadow;
		}
		
		// 设置是否显示阴影颜色
		public function setShowShadow(show:Boolean) : void {
			showShadow = show;
		}
		
		public override function showTip(x:int, y:int):void {
			addWindow(initText(x,y));
			startTimer();
		}
		
		public override function showTipEx(x:int, y:int, timeOut:int):void {
			addWindow(initText(x,y));
			startTimerEx(timeOut);
		}
		
		private function initText(x:int, y:int) : TextField {
			var textField:TextField = new TextField();
			textField.text = text;
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = fontName;
			textFormat.size = fontSize;
			textFormat.color = fontColor;
			textField.setTextFormat(textFormat);
			textField.background = showBack;
			if(showBack) {
				textField.backgroundColor = backColor;
			}
			textField.border = showBackOutline;
			if(showBackOutline) {
				textField.borderColor = backOutlineColor;
			}
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.x = x;
			textField.y = y;
			return textField;
		}
		
	}
}