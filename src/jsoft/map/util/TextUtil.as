package jsoft.map.util
{
	import mx.controls.Button;
	import mx.core.UIComponent;
	
	public class TextUtil
	{
		private var x:int=0;
		private var y:int=0;
		// 字体的名称
		private var fontName:String;
		// 字体的大小
		private var fontSize:int = 12;
		// 字体的颜色
		private var fontColor:int = DrawUtil.getRed();
		// 是否现实字体的背景颜色
		private var showBackground:Boolean = false;
		// 字体的背景颜色
		private var backgroundColor:int = DrawUtil.getYellow();
		// 字体背景的边框颜色
		private var backgroundOutlineColor:int = DrawUtil.getBlue();
		// 字体背景的边框是否是圆角
		private var backgroundRound:Boolean = false;
		// 是否显示字体背景的阴影
		private var showShadow:Boolean = false;
		// 字体背景的阴影颜色
		private var shadowColor:int = DrawUtil.getBlack();
		// 是否现实字体到原始位置的箭头
		private var showArrow:Boolean = false;
		// 箭头的颜色
		private var arrowColor:int = DrawUtil.getWhite();
		
		// 显示的内容，按行进行分割
		private var textString:Array=new Array();
		// 显示的按钮，每行显示一个
		private var textButton:Array=new Array();
		// 按钮的响应事件
		private var textButtonLink:Array=new Array();
		
		private var component:UIComponent=null;
		private var button:Array=new Array();
		
		public function TextUtil() {
		}
		
		public function showText(component:UIComponent) {
			this.component=component;
		}
		
		public function clear() {
			if(component!=null&&button!=null) {
				for(var i:int=0;i<button.length;i++) {
					var b:Button=button[i];
					component.removeChild(b);
				}
			}
		}
		
		public function getX():int {
			return x;
		}
		public function setX(x:int):void {
			this.x=x;
		}
		
		public function getY():int {
			return y;
		}
		public function setY(y:int):void {
			this.y=y;
		}
		
		public function getFontSize():String {
			return fontName;
		}
		public function setFontSize(fontName:String):void {
			this.fontName=fontName;
		}
		
		public function getFontSize():int {
			return fontSize;
		}
		public function setFontSize(fontSize:int):void {
			this.fontSize=fontSize;
		}
		
		public function getFontColor():int {
			return fontColor;
		}
		public function setFontColor(fontColor:int):void {
			this.fontColor=fontColor;
		}
		
		public function getShowBackground():Boolean {
			return showBackground;
		}
		public function setShowBackground(showBackground:Boolean):void {
			this.showBackground=showBackground;
		}
		
		public function getBackgroundColor():int {
			return backgroundColor;
		}
		public function setBackgroundColor(backgroundColor:int):void {
			this.backgroundColor=backgroundColor;
		}
		
		public function getBackgroundOutlineColor():int {
			return backgroundOutlineColor;
		}
		public function setBackgroundOutlineColor(backgroundOutlineColor:int):void {
			this.backgroundOutlineColor=backgroundOutlineColor;
		}
		
		public function getBackgroundRound():Boolean {
			return backgroundRound;
		}
		public function setBackgroundRound(backgroundRound:Boolean):void {
			this.backgroundRound=backgroundRound;
		}
		
		public function getShowShadow():Boolean {
			return showShadow;
		}
		public function setShowShadow(showShadow:Boolean):void {
			this.showShadow=showShadow;
		}
		
		public function getShadowColor():int {
			return shadowColor;
		}
		public function setShadowColor(shadowColor:int):void {
			this.shadowColor=shadowColor;
		}
		
		public function getShowArrow():Boolean {
			return showArrow;
		}
		public function setShowArrow(showArrow:Boolean):void {
			this.showArrow=showArrow;
		}
		
		public function getArrowColor():int {
			return arrowColor;
		}
		public function setArrowColor(arrowColor:int):void {
			this.arrowColor=arrowColor;
		}
		
		public function addTextString(str:String):void {
			textString[textString.length]=str;
		}
		public function getTextString(pos:int):String {
			return textString[pos];
		}
		public function getTextStringAry():Array {
			return textString;
		}
		public function getTextStringLength():int {
			return textString.length;
		}
		public function setTextString(array:Array):void {
			textString=array;
		}
		
		public function addTextButton(button:String):void {
			textButton[textButton.length]=button;
		}
		public function getTextButton(pos:int):String {
			return textButton[pos];
		}
		public function getTextButtonAry():Array {
			return textButton;
		}
		public function getTextButtonLength():int {
			return textButton.length;
		}
		public function setTextButton(array:Array):void {
			textButton=array;
		}
		
		public function addTextButtonLink(link:String):void {
			textButtonLink[textButtonLink.length]=link;
		}
		public function getTextButtonLink(pos:int):String {
			return textButtonLink[pos];
		}
		public function getTextButtonLinkAry():Array {
			return textButtonLink;
		}
		public function getTextButtonLinkLength():int {
			return textButtonLink.length;
		}
		public function setTextButtonLink(linkArray:Array):void {
			textButtonLink=linkArray;
		}
		
		

	}
}