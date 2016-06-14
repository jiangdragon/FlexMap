package jsoft.map.symbol.server
{
	public class ServerBaseSymbol implements ServerSymbol
	{
		private var id:int;
		private var groupId:int;
		private var name:String;
		
		public function ServerBaseSymbol() {
		}
		
		public function getSymbolName():String {
			return "ServerBaseSymbol";
		}
			
		public function getId():int {
			return id;
		}
		
		public function setId(id:int):void {
			this.id = id;
		}
			
		public function getGroupId():int {
			return groupId;
		}
		
		public function setGroupId(groupId:int):void {
			this.groupId = groupId;
		}
			
		public function getName():String {
			return name;
		}
		
		public function setName(name:String):void {
			this.name = name;
		}

	}
}