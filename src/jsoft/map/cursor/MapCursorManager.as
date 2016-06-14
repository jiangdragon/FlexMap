package jsoft.map.cursor
{
	import mx.managers.CursorManager;

	//引用图片，在页面实现的图片效果，比如鼠标在接近上边界的时候鼠标的光标显示为一个向上下的一个图片
	//
	public class MapCursorManager
	{
		private static var cursorId:int = 0;
		private static var cursorType:String = "";
		//把图片设置为一个静态的类
		[Embed(source="loading.gif")]
		private static var LoadingCursor:Class;
		
		[Embed(source="arrows.gif")]
		private static var ArrowCursor:Class;
		
		[Embed(source="c_wait.gif")]
		private static var WaitCursor:Class;
		
		[Embed(source="c_hand.gif")]
		private static var HandCursor:Class;
		
		[Embed(source="c_help.gif")]
		private static var HelpCursor:Class;
		
		[Embed(source="c_size1.gif")]
		private static var Size1Cursor:Class;
		
		[Embed(source="c_size2.gif")]
		private static var Size2Cursor:Class;
		
		[Embed(source="c_size3.gif")]
		private static var Size3Cursor:Class;
		
		[Embed(source="c_size4.gif")]
		private static var Size4Cursor:Class;
		//开始图片
		[Embed(source="start.gif")]
		private static var startCursor:Class;
		//结束图片
		[Embed(source="end.gif")]
		private static var endCursor:Class;
		
//		[Embed(source="left.png")]
//		public static var leftCursor:Class;
//		trace(leftCursor);
		
		public function MapCursorManager() {
		}
		
		public static function clearCursor() : void {
			if(cursorId != 0) {
				CursorManager.removeCursor(cursorId);
				cursorId = 0;
			}
			AppContext.getMapContext().getMapContent().useHandCursor = false;
		}
		
		public static function setPan():void {
			if("pan" == cursorType) {
				return;
			}
			clearCursor();
			cursorType = "pan";
			cursorId = CursorManager.setCursor(HandCursor);
		}
		
		public static function setArrow():void {
			if("arrow" == cursorType) {
				return;
			}
			clearCursor();
			cursorType = "arrow";
			cursorId = CursorManager.setCursor(ArrowCursor);
		}
		
		public static function setHand():void {
			if("hand" == cursorType) {
				return;
			}
			clearCursor();
			cursorType = "hand";
			AppContext.getMapContext().getMapContent().useHandCursor = true;
			AppContext.getMapContext().getMapContent().buttonMode = true;
			AppContext.getMapContext().getMapContent().mouseChildren = false;
			//cursorId = CursorManager.setCursor(HandCursor);
		}
		
		public static function setHelp():void {
			if("help" == cursorType) {
				return;
			}
			clearCursor();
			cursorType = "help";
			cursorId = CursorManager.setCursor(HelpCursor);
		}
		
		public static function setWait():void {
			if("wait" == cursorType) {
				return;
			}
			clearCursor();
			cursorType = "wait";
			cursorId = CursorManager.setCursor(WaitCursor);
		}
		
		public static function setSize1():void {
			if("size1" == cursorType) {
				return;
			}
			clearCursor();
			cursorType = "size1";
			cursorId = CursorManager.setCursor(Size1Cursor);
		}
		
		public static function setSize2():void {
			if("size2" == cursorType) {
				return;
			}
			clearCursor();
			cursorType = "size2";
			cursorId = CursorManager.setCursor(Size2Cursor);
		}
		
		public static function setSize3():void {
			if("size3" == cursorType) {
				return;
			}
			clearCursor();
			cursorType = "size3";
			cursorId = CursorManager.setCursor(Size3Cursor);
		}
		
		
		
		public static function setSize4():void {
			if("size4" == cursorType) {
				return;
			}
			clearCursor();
			cursorType = "size4";
			cursorId = CursorManager.setCursor(Size4Cursor);
		}
//		public static function setLeft():void {
//			if("left" == cursorType) {
//				return;
//			}
//			clearCursor();
//			cursorType = "left";
//			cursorId = CursorManager.setCursor(leftCursor);
//		}
		public static function setLeft():void {
			if("left" == cursorType) {
				return;
			}
			clearCursor();
			cursorType = "left";
//		cursorId = CursorManager.setCursor(leftCursor);
		}
		
		public static function setStart():void {
			if("start" == cursorType) {
				return;
			}
			clearCursor();
			cursorType = "start";
			cursorId = CursorManager.setCursor(startCursor);
		}
		
		public static function setEnd():void {
			if("end" == cursorType) {
				return;
			}
			clearCursor();
			cursorType = "end";
			cursorId = CursorManager.setCursor(endCursor);
		}
		
		public static function getCursorType():String{
			return cursorType;
		}
	}
}