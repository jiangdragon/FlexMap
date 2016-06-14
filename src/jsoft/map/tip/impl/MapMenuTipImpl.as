package jsoft.map.tip.impl
{
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import jsoft.map.acete.MapHotAcete;
	import jsoft.map.tip.MapTip;
	
	import mx.controls.Menu;
	import mx.events.MenuEvent;

	public class MapMenuTipImpl implements MapTip
	{
		private var menu:Menu = null;
		private var xml:XML;
		public function MapMenuTipImpl()
		{
		}

		public function isEqual(mapTip:MapTip):Boolean
		{
			if(menu!=null){
				menu.hide();
				menu = null;
			}
			return false;
		}
		
		public function getTitle():String
		{
			return null;
		}
		
		public function setTitle(title:String):void
		{
		}
		public function getMenu():Menu{
			return menu;
		}
		public function getXml():XML{
			return xml;
		}
		public function setXml(xml:XML):void{
			this.xml = xml;
		}
		public function showTip(x:int, y:int):void
		{
			if(xml == null){
				return;
			}
			var hot:MapHotAcete = AppContext.getMapContext().getHotContainer();
			menu = Menu.createMenu(null,xml,false);
			menu.labelField = "@label";
			menu.show(x,y);
			menu.addEventListener(MenuEvent.CHANGE,menuHandler);
			menu.addEventListener(MouseEvent.MOUSE_DOWN,mouseEvent);
			menu.addEventListener(MouseEvent.MOUSE_UP,mouseEvent);
		}
		private function menuHandler(event:MenuEvent):void{
			if(event.item.@callBack){
				var callBack:String = event.item.@callBack;
				ExternalInterface.call(callBack);
			}
		}
		private function mouseEvent(evt:MouseEvent):void {
        	AppContext.getMapContext().getMapContent().setTipWinCloseFlag(true);
        }
		public function showTipEx(x:int, y:int, timeOut:int):void
		{
			//不处理
		}
		
		public function hideTip():void
		{
			//不做任何处理
		}
		
		public function destory():void
		{
			//不做任何处理
		}
		
	}
}