package jsoft.map.dispatch
{
	public interface Dispatcher
	{
		/**
		 * 只接收消息，不返回结果
		 **/
		function sendMessage(param:DispatchParam):void;
	
		/**
		 * 接收消息，并返回结果
		 **/		
		function getMessage(param:DispatchParam):String;	
	}
}