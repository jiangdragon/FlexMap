package jsoft.map.vector
{
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.Record;

	public interface IVector
	{
		// 获取id
		function getVectorId() : String;
		// 设置id
		function setVectorId(id:String) : void;
		// 获取分组
		function getGroup() : String;
		// 设置分组
		function setGroup(group:String) : void;
		// 获取是否可见
		function isVisible() : Boolean;
		function set_Visible(visible:Boolean):void;
		// 获取是否有效
		function isEnable() : Boolean;
		// 设置是否有效
		function setEnable(enable:Boolean) : void;
		// 获取延迟
		function getDelay() : Number;
		// 设置延迟
		function setDelay(delay:Number) : void;
		// 获取速度
		function getSpeed() : Number;
		// 设置速度
		function setSpeed(speed:Number) : void;
		// 获取道路
		function getLine() : Line;
		// 设置道路
		function setLine(line:Line) : void;
		// 获取是否可见
		function isViewFlag() : Boolean;
		// 设置是否可见
		function setViewFlag(viewFlag:Boolean) : void;
		// 获取符号对象的类型
		function getVectorName() : String;
		// 复制一份新的符号对象
		function clone() : IVector;
		// 将符号对象转换为字符串
		function getVectorString() : String;
		// 将字符串转换为符号对象
		function setVectorString(symbolString:String):void;
		// 获取空间对象
		function getGeometry():Geometry;
		// 设置空间对象
		function setGeometry(geometry:Geometry):void;
		// 获取记录对象
		function getRecord():Record;
		// 设置记录对象
		function setRecord(record:Record):void;
		// 打印符号对象
		function toString() : String;
		// 绘制符号
		function showVector(coord:Coordinate) : void;
		// 绘制符号
		function updateVector() : void;
		// 刷新符号
		function refresh():void;
		// 删除符号
		function clear() : void;
		//  符号的形状是否固定
		function isFix() : Boolean;
		// 为符号添加点
		function addPoint(x:int,y:int) : void;
		// 删除符号点
		function removePoint(index:int) : void;
		// 判断符号是否被选中
		function getStatus() : Boolean;
		// 设置符号是否被选中
		function setStatus(status:Boolean):void;
		// 获取符号的最大地理范围
		function getMapRange():Box;
		// 设置符号的最大地理范围
		function setMapRange(minx:Number,miny:Number,maxx:Number,maxy:Number):void; 
		// 设置符号的最大地理范围
		function setMapRangeBox(bounds:Box):void;
		// 设置符号的最大视图范围，自动将视图范围转换为地理范围
		function setViewRange(minx:Number,miny:Number,maxx:Number,maxy:Number):void;
		// 设置符号的最大视图范围，自动将视图范围转换为地理范围
		function setViewRangeBox(bounds:Box):void;
		// 判断是否点中空间对象,-1代表未选中,0代表选中对象,1..n代表选中某个控制点
		function hitTest(x:Number,y:Number):int;
		// 判断是否点中空间对象
		function hitRectTest(minx:Number,miny:Number,maxx:Number,maxy:Number): Boolean;
		// 将某个控制点移动到某个偏移量，但该偏移量不保存到实际的对象中
		function moveControlPoint(hotPoint:int,offsetx:int,offsety:int):void;
		// 将某个控制点偏移量更新到实际的对象中
		function updateControlPoint(update:Boolean):void;
		// 获取中心点坐标
		function getCenterX():Number;
		// 获取中心点坐标
		function getCenterY():Number;
		// 移动到指定位置
		function setCenter(cx:Number,cy:Number):void;
		// 设置移动参数
		function setMoveAnimate(speed:Number,line:Line,viewFlag:Boolean):void;
		// 设置移动参数
		function setMoveAnimateDelay(delay:Number,speed:Number,line:Line,viewFlag:Boolean):void;
		// 开始移动
		function startMove():void;
		// 开始移动
		function moveAnimate(speed:Number,line:Line,viewFlag:Boolean):void;
		// 开始移动
		function moveAnimateDelay(delay:Number,speed:Number,line:Line,viewFlag:Boolean):void;
		// 暂停移动
		function pauseAnimate():void;
		// 恢复移动
		function resumeAnimate():void;
		// 停止移动
		function stopAnimate():void;
	}
}