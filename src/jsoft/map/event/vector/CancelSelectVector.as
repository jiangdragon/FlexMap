package jsoft.map.event.vector
{
	import jsoft.map.acete.VectorAcete;
	import jsoft.map.vector.IVector;
	
	public class CancelSelectVector
	{
		public function CancelSelectVector()
		{
		}
		
		public function execute() : void {
			var vectors:Array=getVectorInstance().getVectors();
			for(var i:int=0;i<vectors.length;i++) {
				var vector:IVector=vectors[i];
				vector.setStatus(false);
				vector.refresh();
			}
		}
		
		private function getVectorInstance():VectorAcete {
			return AppContext.getMapContext().getMapContent().getVectorLayer();
		}

	}
}