package jsoft.map.event.vector
{
	import jsoft.map.acete.VectorAcete;
	import jsoft.map.vector.IVector;
	
	public class ReverseSelectVector
	{
		public function ReverseSelectVector()
		{
		}
		
		public function execute() : void {
			var vectors:Array=getVectorInstance().getVectors();
			for(var i:int=0;i<vectors.length;i++) {
				var vector:IVector=vectors[i];
				if(vector.isVisible() && vector.isEnable()) {
					vector.setStatus(!vector.getStatus());
				} else {
					vector.setStatus(false);
				}
			}
			getVectorInstance().redraw();
		}
		
		private function getVectorInstance():VectorAcete {
			return AppContext.getMapContext().getMapContent().getVectorLayer();
		}

	}
}