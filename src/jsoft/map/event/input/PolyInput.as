package jsoft.map.event.input
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	
	import jsoft.map.content.MapContent;
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.event.MapEvent;
	import jsoft.map.geometry.Coordinate;

	public class PolyInput implements MapEvent
	{
		protected var mouseDown:Boolean = false;
		protected var mouseMove:Boolean = false;
		protected var mouseDownX:int = 0;
		protected var mouseDownY:int = 0;
		protected var mouseMoveX:int = -1;
		protected var mouseMoveY:int = -1;
		protected var startFlag:Boolean = false;
		protected var lastClickTime:Number = 0;
		protected var endX:int = 0;
		protected var endY:int = 0;
		protected var xAry:Array;
		protected var yAry:Array;
		protected var mapContent:MapContent = AppContext.getMapContext().getMapContent();
		
		public function PolyInput() {
			MapCursorManager.clearCursor();
		}
		
		public function onEnterFrame(event:Event):Boolean {
			return true;
		}

		// 鼠标按下
		public function onMouseDown(event:MouseEvent):Boolean {
			if(AppContext.getMapContext().getLevelUI().isMouseDown()) {
				return true;
			}
			mouseDown = true;
			mouseMove = false;
			mouseDownX=event.stageX;
			mouseDownY=event.stageY;

			endX=event.stageX;
			endY=event.stageY;
			//onMouseClick();
			return true;
		}
		
		// 鼠标移动
		public function onMouseMove(event:MouseEvent):Boolean {
			if(mouseDown) {
				mouseMove = true;
				mouseMoveX = event.stageX;
				mouseMoveY = event.stageY;
				var offsetX:int = mouseMoveX - mouseDownX;
				var offsetY:int = mouseMoveY - mouseDownY;
//				trace("offsetX="+offsetX+", offsetY="+offsetY);
				mapContent.setShowOffset(offsetX,offsetY);
				mapContent.refresh();
				AppContext.getMapContext().getMapInputLayer().x = offsetX;
				AppContext.getMapContext().getMapInputLayer().y = offsetY;
				//AppContext.getMapContext().getMapInputLayer().drawPolyAry(xAry,yAry);
				if(startFlag) {
					var sx:Number = xAry[0];
					var sy:Number = yAry[0];
					var mx:Number = xAry[xAry.length-1];
					var my:Number = yAry[yAry.length-1];
					sx += offsetX;
					sy += offsetY;
					mx += offsetX;
					my += offsetY;
					endX=event.stageX;
					endY=event.stageY;
					//AppContext.getMapContext().getMapDynInputLayer().drawLine(mx,my,endX,endY);
					AppContext.getMapContext().getMapDynInputLayer().drawTriangle(mx,my,endX,endY,sx,sy);
					//AppContext.getMapContext().getMapInputLayer().drawPolyAryEx(xAry,yAry,endX,endY);
				}
				return true;
			}
			if(!startFlag) {
				return true;
			}
			var sx1:Number = xAry[0];
			var sy1:Number = yAry[0];
			var mx1:Number = xAry[xAry.length-1];
			var my1:Number = yAry[yAry.length-1];
			endX=event.stageX;
			endY=event.stageY;
			//AppContext.getMapContext().getMapDynInputLayer().drawLine(x,y,endX,endY);
			//AppContext.getMapContext().getMapDynInputLayer().drawTriangle(x,y,endX,endY,xAry[0],yAry[0]);
			AppContext.getMapContext().getMapDynInputLayer().drawTriangle(sx1,sy1,endX,endY,mx1,my1);
			//AppContext.getMapContext().getMapDynInputLayer().drawPolyAryEx(xAry,yAry,endX,endY);
			return true;
		}
		
		// 鼠标放开
		public function onMouseUp(event:MouseEvent):Boolean {
			if(mouseDown && mouseMove) {
				mouseDown = false;
				mouseMove = false;
				mapContent.setShowOffset(0,0);
				var offsetX:int = mouseMoveX - mouseDownX;
				var offsetY:int = mouseMoveY - mouseDownY;
				mapContent.moveTo(offsetX,offsetY);
				mapContent.showMap();
				mapContent.refresh();
				for(var i:int=0;xAry!=null&&i<xAry.length;i++) {
					xAry[i] += offsetX;
					yAry[i] += offsetY;
				}
				AppContext.getMapContext().getMapInputLayer().x = 0;
				AppContext.getMapContext().getMapInputLayer().y = 0;
				AppContext.getMapContext().getMapInputLayer().drawPolyAry(xAry,yAry);
				return true;
			}
			mouseDown = false;
			mouseMove = false;
			onMouseClick();
			return true;
		}
		
		// 鼠标离开
		public function onMouseLeave(event:Event):Boolean {
			//AppContext.getAppUtil().alert("onMouseLeave");
			onMouseDblClick();
			return true;
		}
		
		public function onMouseClick():Boolean {
			var x:Number=endX;
			var y:Number=endY;
			if(startFlag) {
				var ret:Boolean = addLinePoint(x,y);
				//AppContext.getAppUtil().alert("add line point,x="+x+",y="+y+",ret="+ret+",startFlag="+startFlag);
				var time:Number = AppContext.getAppUtil().getTime();
				//AppUtil.showStatus("ret="+ret+",time="+time+",lastClickTime="+lastClickTime);
				if(!ret && time - lastClickTime < 500) {
					onMouseDblClick();
				} else {
					lastClickTime = time;
				}
			} else {
				startFlag = true;
				xAry = new Array();
				yAry = new Array();
				xAry[xAry.length] = x;
				yAry[yAry.length] = y;
				AppContext.getMapContext().clearInputLayer();
			}
			return true;
		}
		
		public function onMouseDblClick():Boolean {
			var x:Number=endX;
			var y:Number=endY;
			AppContext.getMapContext().getMapContent().setMapPanEvent();
			//AppContext.getAppUtil().alert("onMouseDblClick,x="+x+",y="+y+",startFlag="+startFlag);
			if(startFlag) {
				addLinePoint(x,y);
				startFlag = false;
				//AppUtil.releaseCapture();
				if(xAry.length < 3) {
					AppContext.getAppUtil().alert("输入点太少，无法形成多边形！");
					return true;
				}
				AppContext.getMapContext().getMapDynInputLayer().clear();
				var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
				var xArray:Array = new Array();
				var yArray:Array = new Array();
				for(var i:int=0;i<xAry.length;i++) {
					xArray[i] = coord.mapFromViewX(xAry[i]);
					yArray[i] = coord.mapFromViewY(yAry[i]);
				}
				onInputResult(xArray,yArray);
				return true;
			}
			return false;
		}
		
		protected function onInputResult(xArray:Array,yArray:Array):void {
			var xstr:String = AppContext.getAppUtil().getArrayString(xArray);
			var ystr:String = AppContext.getAppUtil().getArrayString(yArray);
			ExternalInterface.call("fMap.getFInput().inputPolyBack",xstr,ystr);
		}
		
		protected function addLinePoint(x:Number,y:Number) : Boolean {
			if(xAry.length > 0 && yAry.length > 0) {
				var lastX:int = xAry[xAry.length-1];
				var lastY:int = yAry[yAry.length-1];
				if(lastX != x || lastY != y) {
					xAry[xAry.length] = x;
					yAry[yAry.length] = y;
					AppContext.getMapContext().getMapInputLayer().drawPolyAry(xAry,yAry);
					return true;
				}
			} else {
				xAry[xAry.length] = x;
				yAry[yAry.length] = y;
				return true;
			}
			return false;
		}
		
	}
}