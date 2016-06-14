package jsoft.map.event.vector
{
	import flash.events.MouseEvent;
	
	import jsoft.map.event.MapEvent;
	import jsoft.map.vector.IVector;
	
	public class AddPointVector extends SelectVectorEvent implements MapEvent
	{
		
		public function AddPointVector() {
			super();
		}
		
		public override function onMouseDown(event:MouseEvent):Boolean {
			var vectors:Array = getVectorInstance().getVectors();
			var i:int=0;
			var x:int=event.stageX;
			var y:int=event.stageY;
			for(i=0;i<vectors.length;i++) {
				var vector:IVector = vectors[i];
				if(!vector.isFix()) {
					continue;
				}
				var ret:int = vector.hitTest(x,y); 
				if(ret>0) {
					//vector.setStatus(true); 
					//AppContext.getMapContext().getVectorInstance().refresh();
					break;
				}
				if(ret==0) {
					getVectorInstance().clearSelectStatus();
					vector.setStatus(true);
					vector.addPoint(x,y);
					//AppContext.getAppUtil().alert("AddPointVector.onMouseDown.addPoint x="+x+",y="+y);
					//AppContext.getMapContext().getVectorInstance().refresh();
					break;
				}
			}
			return super.onMouseDown(event);
		}
		
		public override function onMouseMove(event:MouseEvent):Boolean {
			return super.onMouseMove(event);
		}
		
		public override function onMouseUp(event:MouseEvent):Boolean {
			return super.onMouseUp(event);
		}

	}
}