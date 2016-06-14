package jsoft.map.content
{
	public interface MapLayer
	{
		//  初始化图层
		function initLayer(layer:MapLayer):void;
		//  删除图层
		function removeLayer():void;
		//  载入图片
		function loadTiles(x:Number,y:Number):void;
		//  清除图片
		function clearTiles():void;
		//  显示图片
		function showMap(x:Number,y:Number):void;
		//  按照指定等级显示缩放后的地图
		function showZoomMap(zoomLevel:int):void;
		// 刷新地图
		function refresh():void;
	}
}