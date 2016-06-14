package jsoft.map.ui
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import mx.containers.Box;
	import mx.controls.Button;
	import mx.controls.Label;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;

	public class TipWindow extends UIComponent
	{
		public function TipWindow()
		{
			super();
		}
		/**子元素*/
		[Embed(source="../cursor/close.png")]
		private static const closeIco:Class;//定义关闭图标
		private var closeBt:Button;//定义关闭按钮
		private var border:Box;//定义身体
		private var title:Label;//定义标题
		private var title_txt:String = "提示信息";//定义标题内容
		override protected function createChildren():void{
			if(!closeBt){
				closeBt = new Button();
				closeBt.toolTip = "关闭";
				closeBt.focusEnabled = false;
				closeBt.setStyle("icon",closeIco);
				closeBt.addEventListener(MouseEvent.CLICK, doClose);
				super.addChild(closeBt);
			}
			if(!border){
				border = new Box();
				border.direction = "vertical";
				border.setStyle("paddingTop",5);
				border.setStyle("paddingLeft",5);
				border.setStyle("borderStyle","solid");
				border.setStyle("backgroundColor",0xFFFFFF);
				border.setStyle("backgroundAlpha",0.3);
				super.addChild(border);
			}
			if(!title){
				title = new Label();
				title.text = title_txt;
				title.setStyle("fontSize",12);
				title.setStyle("textAlign","center");
				super.addChild(title);
			}
		}
		public function setTitle(str:String):void{
			title_txt = str;
		}
		public override function addChild(child:DisplayObject):DisplayObject{
			if(!border){
				createChildren();
			}
			return border.addChild(child);
		}
		override protected function measure():void{
			measuredWidth = 200;
			measuredHeight = 150;
			measuredMinWidth = 200;
			measuredMinHeight = 150;
		}
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void{
			layoutChrome(unscaledWidth,unscaledHeight);
			//布居
			title.width = unscaledWidth - 30;
			title.height = 20;
			title.move(10,0);
			closeBt.width = 15;
			closeBt.height = 15;
			closeBt.move(unscaledWidth - 20,5);
			border.move(10,20);
			border.width = unscaledWidth-20;
			border.height = unscaledHeight - 25; 
		}
		protected function layoutChrome(unscaledWidth:Number, unscaledHeight:Number):void{
			graphics.clear();
			graphics.beginFill(0xDFDFDF,0.8);
			graphics.drawRoundRectComplex(0,0,unscaledWidth,unscaledHeight,10,10,10,10);
			graphics.endFill();
			//graphics.lineStyle(1,0x000000,1);
			//graphics.moveTo(0,20);
			//graphics.lineTo(unscaledWidth,20);
		}
		private function doClose(evt:MouseEvent):void{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
	}
}