package jsoft.map.config
{
	public class MapServer
	{
		private var server:String;
		private var level:int;
		private var startX:int;
		private var startY:int;
		private var endX:int;
		private var endY:int;
		
		public function MapServer() {
		}
		
		public function getServer() : String {
			return server;
		}
		
		public function setServer(server:String) : void {
			this.server = server;
		}
		
		public function getLevel() : int {
			return level;
		}
		
		public function setLevel(level:int) : void {
			this.level = level;
		}
		
		public function getStartX() : int {
			return startX;
		}
		
		public function setStartX(startX:int) : void {
			this.startX = startX;
		}
		
		public function getStartY() : int {
			return startY;
		}
		
		public function setStartY(startY:int) : void {
			this.startY = startY;
		}
		
		public function getEndX() : int {
			return endX;
		}
		
		public function setEndX(endX:int) : void {
			this.endX = endX;
		}
		
		public function getEndY() : int {
			return endY;
		}
		
		public function setEndY(endY:int) : void {
			this.endY = endY;
		}

	}
}