package jsoft.map.geometry
{
	public interface Geometry
	{
		// 获取空间对象的类型
		function getGeometryName() : String;
		// 复制一份新的空间对象
		function clone() : Geometry;
		// 获取空间对象的边界
		function getBounds() : Envelope;
		// 获取空间对象的中心点
		function getCenter() : FPoint;
		// 设置空间对象的中心点
		function setCenter(centerPoint:FPoint) : void;
		// 将空间对象转换为字符串
		function getGeometryString() : String;
		// 将字符串转换为空间对象
		function setGeometryString(geometryString:String):void;
		// 打印空间对象
		function toString() : String;
	}
}