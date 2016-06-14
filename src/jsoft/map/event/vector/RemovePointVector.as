package jsoft.map.event.vector
{
	import flash.events.MouseEvent;
	
	import jsoft.map.event.MapEvent;
	import jsoft.map.vector.IVector;
	
	public class RemovePointVector extends SelectVectorEvent implements MapEvent
	{
		
		public function RemovePointVector() {
			super();
		}
		
		public override function onMouseDown(event:MouseEvent):Boolean {
			return super.onMouseDown(event);
		}
		
		public override function onMouseMove(event:MouseEvent):Boolean {
			return super.onMouseMove(event);
		}
		
		public override function onMouseUp(event:MouseEvent):Boolean {
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
					vector.setStatus(true);
					vector.removePoint(ret);
					//AppContext.getMapContext().getVectorInstance().refresh(); 
					break;
				}
				if(ret==0) {
					vector.setStatus(true);
					//AppContext.getMapContext().getVectorInstance().refresh();
					break;
				}
			}
			return super.onMouseUp(event);
		}

	}
}