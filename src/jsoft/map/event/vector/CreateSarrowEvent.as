package jsoft.map.event.vector
{
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import jsoft.map.content.MapContent;
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.event.MapEvent;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.GeometryFactory;
	import jsoft.map.geometry.Line;
	import jsoft.map.vector.BaseVector;
	import jsoft.map.vector.IVector;
	import jsoft.map.vector.line.EqualSarrowVector;
	import jsoft.map.vector.line.SarrowVector;
	import jsoft.map.vector.line.TailSarrowVector;
	import jsoft.map.vector.line.XSarrowVector;

	public class CreateSarrowEvent implements MapEvent
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
		private var sArrow:* = null;
		//private var equalSarrow:EqualSarrowVector;
		private var mapContent:MapContent = AppContext.getMapContext().getMapContent();
		
		public function CreateSarrowEvent(vector:IVector)
		{
			this.vector = vector as BaseVector;
			MapCursorManager.clearCursor();
			if("EqualSarrowVector" == vector.getVectorName()){
				sArrow = new EqualSarrowVector();
			}else if("TailSarrowVector" == vector.getVectorName()){
				sArrow = new TailSarrowVector();
			}else if("SarrowVector" == vector.getVectorName()){
				sArrow = new SarrowVector();
			}else if("XSarrowVector" == vector.getVectorName()){
				sArrow = new XSarrowVector();
			}
			//equalSarrow = new EqualSarrowVector();
		}

		public function onEnterFrame(event:Event):Boolean
		{
			return true;
		}
		
		public function onMouseDown(event:MouseEvent):Boolean
		{
			if(AppContext.getMapContext().getLevelUI().isMouseDown()) {
				return true;
			}
			mouseDown = true;
			mouseMove = false;
			
			mouseDownX = event.stageX;
			mouseDownY = event.stageY;
			endX = event.stageX;
			endY = event.stageY;
			//var c_point:Point = new Point(mouseDownX,mouseDownY);
			//points.push(c_point);
			return true;
		}
		
		public function onMouseMove(event:MouseEvent):Boolean
		{
			if(mouseDown){
				//处理拖动
				mouseMoveX = event.stageX;
				mouseMoveY = event.stageY;
				var offsetX:int = mouseMoveX - mouseDownX;
				var offsetY:int = mouseMoveY - mouseDownY;
				if(offsetX > 3 || offsetY > 3) {
					mouseMove = true;
				}
				mapContent.setShowOffset(offsetX,offsetY);
				mapContent.refresh();
				//加入偏移量临时绘制
				if(startFlag){
					var t_ps:Array = new Array();
					for(var t:int=0;xAry!=null&&t<xAry.length;t++){
						t_ps.push(new Point(xAry[t]+offsetX,yAry[t]+offsetY));
					}
					endX = event.stageX;
					endY = event.stageY;
					t_ps.push(new Point(endX,endY));
					var t_g:Graphics = AppContext.getMapContext().getMapDynInputLayer().graphics;
					var t_ring:Array = sArrow.createGeometryPoints(t_ps);
					sArrow.drawSarrow(t_g,t_ring);
				}
				
				return true;
			}
			if(!startFlag) {
				return true;
			}
			endX = event.stageX;
			endY = event.stageY;
			var ps:Array = new Array();
			for(var i:int=0;i<xAry.length;i++){
				ps.push(new Point(xAry[i],yAry[i]));
			}
			ps.push(new Point(endX,endY));
			//临时绘制
			var g:Graphics = AppContext.getMapContext().getMapDynInputLayer().graphics;
			//var ring:Array = equalSarrow.createGeometryPoints(ps);
			//equalSarrow.drawSarrow(g,ring);
			if(sArrow != null){
				var ring:Array = sArrow.createGeometryPoints(ps);
				sArrow.drawSarrow(g,ring);
			}
			return false;
		}
		
		public function onMouseUp(event:MouseEvent):Boolean
		{
			if(mouseDown && mouseMove) {
				//未处理拖动
				mouseDown = false;
				mouseMove = false;
				mapContent.setShowOffset(0,0);
				var offsetX:int = mouseMoveX - mouseDownX;
				var offsetY:int = mouseMoveY - mouseDownY;
				mapContent.moveTo(offsetX,offsetY);
				mapContent.showMap();
				mapContent.refresh();
				//加入偏移量临时绘制
				for(var i:int=0;xAry!=null&&i<xAry.length;i++){
					xAry[i] += offsetX;
					yAry[i] += offsetY;
				}
				AppContext.getMapContext().getMapInputLayer().resetPositon();
				AppContext.getMapContext().getMapDynInputLayer().resetPositon();
				return true;
			}
			mouseDown = false;
			mouseMove = false;
			onMouseClick();
			return true;
		}
		
		private function onMouseClick():void {
			var x:int = endX;
			var y:int = endY;
			
			if(startFlag){
				var time:Number = AppContext.getAppUtil().getTime();
				//处理双击事件
				if((time-lastClickTime<500) && (xAry[xAry.length-1]==endX) && (yAry[yAry.length-1]==endY)){
					onMouseDblClick();
				}else{
					lastClickTime = time;
					xAry[xAry.length] = endX;
					yAry[yAry.length] = endY;
				}
			}else{
				startFlag = true;
				xAry = new Array();
				yAry = new Array();
				xAry[xAry.length] = endX;
				yAry[yAry.length] = endY;
			}
			//AppContext.getMapContext().clearInputLayer();
		}
		
		public function onMouseLeave(event:Event):Boolean
		{
			return true;
		}
		
		public function onMouseDblClick():void{
			if(!startFlag){
				return;
			}
			startFlag = false;
			if(xAry == null){
				return;
			}
			
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			var xArray:Array = new Array();
			var yArray:Array = new Array();
			for(var i:int=0;i<xAry.length;i++){
				xArray[i] = coord.mapFromViewX(xAry[i]);
				yArray[i] = coord.mapFromViewY(yAry[i]);
			}
			xAry = new Array();
			yAry = new Array();
			if("XSarrowVector" == vector.getVectorName()){
				var n:int = xArray.length;
				if(n % 3 == 1){
					xArray.length = n - 1;
					yArray.length = n - 1;
				}
			}
			var line:Line = new GeometryFactory().createLine(xArray,yArray);
			AppContext.getMapContext().clearInputLayer();
			vector = vector.clone() as BaseVector;
			vector.setRecord(null);
			vector.setGeometry(line);
			AppContext.getMapContext().getMapContent().getVectorLayer().clearSelectStatus();
			AppContext.getMapContext().getMapContent().getVectorLayer().addVector(vector);
			AppContext.getMapContext().getMapContent().getVectorLayer().setSelectEvent();
			vector.setStatus(false);
			vector.showVector(coord);
			vector.updateVector();
		}
		
	}
}