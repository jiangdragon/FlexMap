package jsoft.map.event.vector
{
	import jsoft.map.acete.VectorAcete;
	import jsoft.map.vector.IVector;
	
	public class RemoveSelectVector
	{
		public function RemoveSelectVector()
		{
		}
		
		public function execute() : void {
			var vectors:Array=getVectorInstance().getVectors();
			var newvectors:Array=new Array();
			for(var i:int=0;i<vectors.length;i++) {
				var vector:IVector=vectors[i];
				if(vector.getStatus()) {
					vector.clear();
				} else {
					newvectors[newvectors.length]=vector;
				}
			}
			getVectorInstance().setVectors(newvectors);
			getVectorInstance().redraw();
		}
		
		private function getVectorInstance():VectorAcete {
			return AppContext.getMapContext().getMapContent().getVectorLayer();
		}

	}
}