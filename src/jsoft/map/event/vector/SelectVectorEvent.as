package jsoft.map.event.vector
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsoft.map.acete.VectorAcete;
	import jsoft.map.event.MapEvent;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.vector.IVector;

	public class SelectVectorEvent implements MapEvent
	{
		// 0 代表空状态
		// 1 代表选中物体热点
		// 2 代表点下选中物体，该物体已经被选中过，直接移动所有选中的物体
		// 3 代表点下选中物体，该物体未被选中过，清除其它选中的物体，直接移动选中的物体
		// 4 代表点下未选中物体，需要拉框选择物体
		// 5 代表点下未选中物体，但已有选择的物体，则清除选中的物体，重新拉框选择物体
		private var status:int = 0;
		private var selectedVectors:Array = null;
		private var newSelectedVector:IVector = null;
		private var selectHotVector:IVector;
		private var selectHotVectorRet:int=0;
		private var startX:int;
		private var startY:int;
		private var endX:int;
		private var endY:int;
		private var mouseDown:Boolean=false;
		
		public function SelectVectorEvent() {
			super();
		}
		
		
		// 刷新屏幕
		public function onEnterFrame(event:Event):Boolean {
			return true;
		}
		
		// 鼠标按下
		public function onMouseDown(event:MouseEvent):Boolean {
			mouseDown=true;
			startX=event.stageX;
			startY=event.stageY;
			endX=event.stageX;
			endY=event.stageY;
			selectedVectors = new Array();
			newSelectedVector = null;
			selectHotVector = null;
			status=0;
			var ret:int=0;
			var coord:Coordinate=AppContext.getMapContext().getMapContent().getCoordinate();
			var mapx:Number=coord.mapFromViewX(startX);
			var mapy:Number=coord.mapFromViewY(startY);
			var vectors:Array = getVectorInstance().getVectors();
			var i:int=0;
			for(i=0;i<vectors.length;i++) {
				var vector:IVector = vectors[i];
				if(!(vector.isViewFlag() && vector.isEnable())) {
					vector.setStatus(false);
					continue;
				}
				if(vector.getStatus()) {
					selectedVectors[selectedVectors.length]=vector;
				}
				ret = vector.hitTest(startX,startY); 
				if(ret>0) {
					selectHotVector = vector;
					selectHotVectorRet = ret; 
					continue;
				}
				if(ret==0) {
					newSelectedVector=vector;
				}
			}
			//AppContext.getAppUtil().alert("SelectVectorEvent.onMouseDown selectHotVector="+selectHotVector);
			if(selectHotVector != null) {
				// 选中物体热点
				status = 1;
			} else if(newSelectedVector==null) {
				// 点下未选中物体
				if(selectedVectors.length>0) {
					// 原来已经有选中的物体
					for(i=0;i<selectedVectors.length;i++) {
						selectedVectors[i].setStatus(false);
					}
					status = 5;
				} else {
					// 原来没有选中的物体
					status = 4;
				}
			} else {
				// 点下选中物体
				if(newSelectedVector.getStatus()) {
					status = 2;
				} else {
					for(i=0;i<selectedVectors.length;i++) {
						selectedVectors[i].setStatus(false);
					}
					newSelectedVector.setStatus(true);
					status = 3;
				}
			}
			//AppContext.getAppUtil().showStatus("status="+status);
			getVectorInstance().refresh();
			return true;
		}
		
		// 鼠标移动
		public function onMouseMove(event:MouseEvent):Boolean {
			if(mouseDown) {
				endX=event.stageX;
				endY=event.stageY;
				var offsetx:int=endX-startX;
				var offsety:int=endY-startY;
				var vectors:Array = getVectorInstance().getVectors();
				var i:int=0;
				var vector:IVector;
				switch(status) {
					case 1:
						//AppContext.getAppUtil().alert("selectHotVectorRet="+selectHotVectorRet);
						selectHotVector.moveControlPoint(selectHotVectorRet,offsetx,offsety);
						selectHotVector.refresh();
						break;
					case 2:
						for(i=0;i<vectors.length;i++) {
							vector = vectors[i];
							if(vector.getStatus()) {
								vector.moveControlPoint(0,offsetx,offsety);
								vector.refresh();
							}
						}
						break;
					case 3:
						newSelectedVector.moveControlPoint(0,offsetx,offsety);
						newSelectedVector.refresh();
						break;
					case 4:
					case 5:
						drawRect();
						break;
					default:
						break;
				}
				//AppContext.getAppUtil().showStatus("status="+status+",offsetx="+offsetx+",offsety="+offsety);
				return true;
			}
			return false;
		}
		
		// 鼠标放开
		public function onMouseUp(event:MouseEvent):Boolean {
			if(mouseDown) {
				mouseDown=false;
				var offsetx:int=endX-startX;
				var offsety:int=endY-startY;
				var vectors:Array = getVectorInstance().getVectors();
				var i:int=0;
				var vector:IVector;
				switch(status) {
					case 1:
						selectHotVector.moveControlPoint(selectHotVectorRet,offsetx,offsety);
						selectHotVector.updateControlPoint(true);
						break;
					case 2:
						for(i=0;i<vectors.length;i++) {
							vector = vectors[i];
							if(vector.getStatus()) {
								vector.moveControlPoint(0,offsetx,offsety);
								vector.updateControlPoint(true);
							}
						}
						break;
					case 3:
						newSelectedVector.moveControlPoint(0,offsetx,offsety);
						newSelectedVector.updateControlPoint(true);
						break;
					case 4:
					case 5:
						AppContext.getMapContext().getMapInputLayer().clear();
						if(startX>endX) {
							var tx:int=startX;
							startX=endX;
							endX=tx;
						}
						if(startY>endY) {
							var ty:int=startY;
							startY=endY;
							endY=ty;
						}
						for(i=0;i<vectors.length;i++) {
							vector = vectors[i];
							if(vector.hitRectTest(startX,startY,endX,endY)) {
								vector.setStatus(true);
							}
						}
						break;
					default:
						break;
				}
				getVectorInstance().redraw();
				//AppContext.getAppUtil().alert("status="+status+",offsetx="+offsetx+",offsety="+offsety);
				//AppContext.getAppUtil().showStatus("status="+status+",offsetx="+offsetx+",offsety="+offsety);
				return true;
			}
			return false;
		}
		
		// 鼠标离开
		public function onMouseLeave(event:Event):Boolean {
			onMouseUp(null);
			return true;
		}
		
		private function drawRect() : void {
			AppContext.getMapContext().getMapInputLayer().clear();
			AppContext.getMapContext().getMapInputLayer().drawBox(startX,startY,endX,endY);
		}
		
		public function getVectorInstance():VectorAcete {
			return AppContext.getMapContext().getMapContent().getVectorLayer();
		}
	}
}