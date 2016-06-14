package jsoft.map.image
{
	import flash.display.BitmapData;
	
	public interface ImageReceiver
	{
		function onRecv(imageData:BitmapData):void;
	}
}