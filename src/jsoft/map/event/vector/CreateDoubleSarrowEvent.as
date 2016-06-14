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
	import jsoft.map.vector.line.DoubleSarrowVector;

	public class CreateDoubleSarrowEvent implements MapEvent
	{
		private var vector:BaseVector = null;
		private var mouseDown:Boolean = false;
		private var mouseMove:Boolean = false;
		private var mouseDownX:int = 0;
		private var mouseDownY:int = 0;
		private var endX:int = 0;
		private var endY:int = 0;
		private var mouseMoveX:int = -1;
		private var mouseMoveY:int = -1;
		private var startFlag:Boolean = false;
		private var xAry:Array;
		private var yAry:Array;
		private var clickNumber:int = 0;
		private var doubleSarrowVector:DoubleSarrowVector;
		private var mapContent:MapContent = AppContext.getMapContext().getMapContent();
		
		public function CreateDoubleSarrowEvent(vector:IVector)
		{
			this.vector = vector as BaseVector;
			MapCursorManager.clearCursor();
			doubleSarrowVector = new DoubleSarrowVector();
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
					var t_ring:Array = doubleSarrowVector.createGeometryPoints(t_ps);
					doubleSarrowVector.drawSarrow(t_g,t_ring);
				}
				
				return true;
			}
			//非拖动处理
			if(!startFlag) {
				return true;
			}
			endX = event.stageX;
			endY = event.stageY;
			var ps:Array = new Array();
			for(var i:int=0;xAry!=null&&i<xAry.length;i++){
				ps.push(new Point(xAry[i],yAry[i]));
			}
			ps.push(new Point(endX,endY));
			//临时绘制
			var g:Graphics = AppContext.getMapContext().getMapDynInputLayer().graphics;
			var ring:Array = doubleSarrowVector.createGeometryPoints(ps);
			doubleSarrowVector.drawSarrow(g,ring);
			return true;
		}
		
		public function onMouseUp(event:MouseEvent):Boolean
		{
			if(mouseDown && mouseMove) {
				//处理拖动
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
			//非拖动处理
			mouseDown = false;
			mouseMove = false;
			onMouseClick();
			return true;
		}
		
		public function onMouseClick():void{
			var x:int = endX;
			var y:int = endY;
			if(startFlag){
				xAry[xAry.length] = endX;
				yAry[yAry.length] = endY;
				if(clickNumber == 2){
					onMouseDblClick();
				}else{
					clickNumber++;
				}
			}else{
				startFlag = true;
				xAry = new Array();
				yAry = new Array();
				xAry[xAry.length] = endX;
				yAry[yAry.length] = endY;
				clickNumber++;
			}
		}
		
		public function onMouseDblClick():void{
			if(!startFlag){
				return;
			}
			startFlag = false;
			if(xAry == null){
				return;
			}
			clickNumber = 0;//专为DoubleSarrowVector用
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			var xArray:Array = new Array();
			var yArray:Array = new Array();
			for(var i:int=0;xAry!=null&&i<xAry.length;i++){
				xArray[i] = coord.mapFromViewX(xAry[i]);
				yArray[i] = coord.mapFromViewY(yAry[i]);
			}
			xAry = new Array();
			yAry = new Array();
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
		
		public function onMouseLeave(event:Event):Boolean
		{
			return true;
		}
		
	}
}