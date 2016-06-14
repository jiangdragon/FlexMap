package jsoft.map.symbol.server
{
	public class ServerSymbolGroup
	{
		private var id:int;
		private var name:String;
		private var type:String;
		
		public function ServerSymbolGroup()
		{
		}
			
		public function getId():int {
			return id;
		}
		
		public function setId(id:int):void {
			this.id = id;
		}
			
		public function getName():String {
			return name;
		}
		
		public function setName(name:String):void {
			this.name = name;
		}
			
		public function getType():String {
			return type;
		}
		
		public function setType(type:String):void {
			this.type = type;
		}
	}
}