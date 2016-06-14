package jsoft.map.event.vector
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsoft.map.content.MapContent;
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.event.MapEvent;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.GeometryFactory;
	import jsoft.map.geometry.Line;
	import jsoft.map.util.ArrowHelper;
	import jsoft.map.vector.BaseVector;
	import jsoft.map.vector.IVector;
	import jsoft.map.vector.line.ArrowVector;
	
	public class CreateMultiArrowVector implements MapEvent
	{
		private var vector:BaseVector = null;
		private var mouseDown:Boolean = false;
		private var mouseMove:Boolean = false;
		private var mouseDownX:int = 0;
		private var mouseDownY:int = 0;
		private var mouseMoveX:int = -1;
		private var mouseMoveY:int = -1;
		private var startFlag:Boolean = false;
		private var lastClickTime:Number = 0;
		private var endX:int = 0;
		private var endY:int = 0;
		private var xAry:Array;
		private var yAry:Array;
		private var arrow:ArrowHelper;
		private var arrowEx:ArrowHelper;
		private var mapContent:MapContent = AppContext.getMapContext().getMapContent();
		
		public function CreateMultiArrowVector(vector:IVector) {
			this.vector = vector as BaseVector;
			MapCursorManager.clearCursor();
			var arrowVector:ArrowVector = vector as ArrowVector;
			arrow = new ArrowHelper(AppContext.getMapContext().getMapDynInputLayer().graphics,arrowVector.getColor(),1);
			arrowEx = new ArrowHelper(AppContext.getMapContext().getMapInputLayer().graphics,arrowVector.getColor(),1);
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
				mouseMoveX = event.stageX;
				mouseMoveY = event.stageY;
				var offsetX:int = mouseMoveX - mouseDownX;
				var offsetY:int = mouseMoveY - mouseDownY;
				if(offsetX > 3 || offsetY > 3) {
					mouseMove = true;
				}
//				trace("offsetX="+offsetX+", offsetY="+offsetY);
				mapContent.setShowOffset(offsetX,offsetY);
				mapContent.refresh();
				//AppContext.getMapContext().getMapInputLayer().x = offsetX;
				//AppContext.getMapContext().getMapInputLayer().y = offsetY;
				var arr:ArrowHelper = arrowEx.createHelper();
				arr.clear();
				arr.addPointsEx(xAry,yAry,offsetX,offsetY);
				arr.draw();
				//AppContext.getMapContext().getMapInputLayer().drawLineAry(xAry,yAry);
				if(startFlag) {
					endX=event.stageX;
					endY=event.stageY;
					//AppContext.getMapContext().getMapDynInputLayer().drawLine(mx,my,endX,endY);
					drawArrow(endX,endY,offsetX,offsetY);
				}
				return true;
			}
			if(!startFlag) {
				return true;
			}
			endX=event.stageX;
			endY=event.stageY;
			//AppContext.getMapContext().getMapDynInputLayer().drawLine(x,y,endX,endY);
			drawArrow(endX,endY,offsetX,offsetY);
			return true;
		}
		
		private function drawArrow(endX:Number,endY:Number,offsetX:Number,offsetY:Number) : void {
			var mx:Number = xAry[0];
			var my:Number = yAry[0];
			mx += offsetX;
			my += offsetY;
			var arr:ArrowHelper = arrow.createHelper();
			arr.addPointEx(mx,my,endX,endY);
			arr.draw();
		}
		
		// 鼠标放开
		public function onMouseUp(event:MouseEvent):Boolean {
			//AppContext.getAppUtil().alert("xAry="+xAry);
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
				AppContext.getMapContext().getMapInputLayer().resetPositon();
				AppContext.getMapContext().getMapDynInputLayer().resetPositon();
				//AppContext.getMapContext().getMapInputLayer().drawLineAry(xAry,yAry);
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
			//onMouseDblClick();
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
			//AppContext.getAppUtil().alert("onMouseDblClick,x="+x+",y="+y+",startFlag="+startFlag);
			if(startFlag) {
				addLinePoint(x,y);
				startFlag = false;
				if(xAry == null) {
					return true;
				}
				//AppUtil.releaseCapture();
				var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
				var xArray:Array = new Array();
				var yArray:Array = new Array();
				for(var i:int=0;xAry!=null&&i<xAry.length;i++) {
					xArray[i] = coord.mapFromViewX(xAry[i]);
					yArray[i] = coord.mapFromViewY(yAry[i]);
				}
				//AppContext.getAppUtil().alert("xAry.length="+xAry.length);
				//xArray[0] = xArray[1];
				//yArray[0] = yArray[1];
				xAry = new Array();
				yAry = new Array();
				var line:Line = new GeometryFactory().createLine(xArray,yArray);
				//AppContext.getAppUtil().alert("line="+line);
				AppContext.getMapContext().clearInputLayer();
				vector = vector.clone() as BaseVector;
				vector.setRecord(null);
				vector.setGeometry(line);
				AppContext.getMapContext().getMapContent().getVectorLayer().clearSelectStatus();
				AppContext.getMapContext().getMapContent().getVectorLayer().addVector(vector);
				AppContext.getMapContext().getMapContent().getVectorLayer().setSelectEvent();
				vector.setStatus(false);
				vector.showVector(coord);
				vector.updateVector()
				return true;
			}
			return false;
		}
		
		private function addLinePoint(x:Number,y:Number) : Boolean {
			if(xAry.length > 0 && yAry.length > 0) {
				var lastX:int = xAry[xAry.length-1];
				var lastY:int = yAry[yAry.length-1];
				if(lastX != x || lastY != y) {
					xAry[xAry.length] = x;
					yAry[yAry.length] = y;
					//AppContext.getMapContext().getMapInputLayer().drawLineAry(xAry,yAry);
					var arr:ArrowHelper = arrowEx.createHelper();
					arr.clear();
					arr.addPoints(xAry,yAry);
					arr.draw();
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