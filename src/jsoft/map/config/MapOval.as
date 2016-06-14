package jsoft.map.config
{
	import jsoft.map.geometry.Envelope;
	
	public class MapOval
	{
		private var width:int;
		private var height:int;
		private var envelope:Envelope;
		
		public function MapOval() {
		}
		
		public function getWidth() : int {
			return width;
		}
		
		public function setWidth(width:int) : void {
			this.width = width;
		}
		
		public function getHeight() : int {
			return height;
		}
		
		public function setHeight(height:int) : void {
			this.height = height;
		}
		
		public function getMap() : Envelope {
			return envelope;
		}
		
		public function setMap(envelope:Envelope) : void {
			this.envelope = envelope;
		}
		
		public function toString() : String {
			return "MapOval:width="+width+",height="+height+envelope.toString();
		}

	}
}