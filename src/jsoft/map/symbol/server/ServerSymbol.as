package jsoft.map.symbol.server
{
	public interface ServerSymbol
	{
		function getSymbolName():String;
			
		function getId():int;
		
		function setId(id:int):void;
			
		function getGroupId():int;
		
		function setGroupId(groupId:int):void;
			
		function getName():String;
		
		function setName(name:String):void;
	}
}