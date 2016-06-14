package jsoft.map.symbol
{
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.Record;
	import jsoft.map.util.DrawUtil;
	import jsoft.map.util.LineHelper;
	
	import mx.core.UIComponent;

	public class Symbol extends UIComponent
	{
		protected var drawUtil:DrawUtil = new DrawUtil(graphics);
		protected var symbolId:String = "";
		protected var symbolGroup:String = "";
		protected var enable:Boolean = true;
		protected var geometry:Geometry = null;
		protected var record:Record = null;//留后用
		protected var coord:Coordinate = null;
		protected var enableFrameFlag:Boolean = false;
		protected var animateFlag:Boolean = false;
		protected var animateFrameFlag:Boolean = false;
		protected var animateTime:Number = 0;
		protected var animateDistance:Number = 0;
		protected var speed:Number;
		protected var line:Line;
		protected var viewFlag:Boolean;
		
		public function Symbol()
		{
		}
		/* 可使用帧 */
		public function enableFrame():void{
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
			enableFrameFlag = true;
		}
		/* 不可使用帧 */
		public function disableFrame():void{
			removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			enableFrameFlag = false;
		}
		/* 进入帧 */
		protected function onEnterFrame(event:Event):void{
			if(animateFlag){
				var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
				var time:Number = new Date().getTime();
				var timeSpan:Number = (time - animateTime) / 1000;
				animateTime = time;
				var distance:Number = coord.distanceToMapUnit(timeSpan * speed);
				animateDistance += distance;
				distance = 0;
				var flag:Boolean = false;
				//以下是找到当前点
				for(var i:int=1;i<line.getPointLength();i++){
					var p1:FPoint = line.getPoint(i-1);
					var p2:FPoint = line.getPoint(i);
					var lineHelper:LineHelper = new LineHelper(p1,p2);
					var d:Number = lineHelper.getDistance();
					if(distance + d < animateDistance){
						distance += d;
						continue;
					}
					var p:FPoint = lineHelper.getPointByDistance(animateDistance-distance);
					updateSymbolView(p);
					flag = true;
					break;
				}
				if(!flag){
					updateSymbolView(line.getPoint(line.getPointLength()-1));
					stopAnimate();
					//需要处理结束点，回调2011-12-30
					var str:String = this.symbolId + ":" + this.symbolGroup;
					ExternalInterface.call("fMap.getFDraw().endMoveBack",str,true);
				}
			}
		}
		/* 停止动画 */
		public function stopAnimate():void{
			animateFlag = false;
			if(animateFrameFlag){
				disableFrame();
			}
		}
		/* 移动动画 */
		public function moveAnimate(speed:Number,line:Line,viewFlag:Boolean):void {
			this.speed = speed;
			this.line = line;
			this.viewFlag = viewFlag;
			animateFlag = true;
			animateTime = new Date().getTime();
			animateDistance = 0;
			if(enableFrameFlag) {
				animateFrameFlag = false;
			} else {
				enableFrame();
				animateFrameFlag = true;
			}
		}
		/* 暂停动画 */
		public function pauseAnimate():void {
			animateFlag = false;
		}
		/* 重置动画 */
		public function resumeAnimate():void {
			animateFlag = true;
			animateTime = new Date().getTime();
		}
		/* 更新symbol 可overwrite */
		public function updateSymbol():void{
		}
		/* 显示符号  可overwrite */
		public function showSymbol(coord:Coordinate):void{
			this.coord = coord;
		}
		/* 清除symbol内容  */
		public function clear():void{
			graphics.clear();
		}
		/* 克隆 */
		public function clone():Symbol{
			var symbol:Symbol = new Symbol();
			copyTo(symbol);
			return symbol;
		}
		public function copyTo(symbol:Symbol):void{
			symbol.geometry = geometry;
			symbol.record = record;
			symbol.visible = visible;
			symbol.enable = enable;
			symbol.symbolGroup = symbolGroup;
			symbol.symbolId = symbolId;
		}
		public function getSymbolString():String{
			return "Symbol";
		}
		/********************内部方法***********************/
		/* 更新当前视图符号 */
		private function updateSymbolView(p:FPoint):void{
			setCenter(p.x,p.y);
			if(viewFlag){
				var cx:Number = getCenterX();
				var cy:Number = getCenterY();
				var vx:Number = coord.mapToViewX(cx);
				var vy:Number = coord.mapToViewY(cy);
				if(!coord.isInView(vx,vy)) {
					AppContext.getMapContext().getMapContent().centerMapAt(cx,cy);
					AppContext.getMapContext().getMapContent().refresh();
				}
			}
			//showSymbol(coord);
			updateSymbol();
		}
		/* 获取geometry */
		private function findGeo():Geometry{
			if(record != null && record.getGeometry() != null){
				return record.getGeometry();
			}
			return geometry;
		}
		/* 没发现用处 */
		private function getTotal():Number{
			var dis:Number = 0;
			for(var i:int=1;i<line.getPointLength();i++) {
				var p1:FPoint= line.getPoint(i-1);
				var p2:FPoint = line.getPoint(i);
				dis += Math.sqrt((p2.getX()-p1.getX())*(p2.getX()-p1.getX())+(p2.getY()-p1.getY())*(p2.getY()-p1.getY()));
			}
			return dis;
		}
		/* 没发现用处 */
		private function getTotalX():Number{
			var dis:Number = 0;
			for(var i:int=1;i<line.getPointLength();i++){
				var p1:FPoint= line.getPoint(i-1);
				var p2:FPoint = line.getPoint(i);
				dis += Math.abs(p2.getX()-p1.getX());
			}
			return dis;
		}
		/* 没发现用处 */
		private function getTotalY():Number{
			var dis:Number = 0;
			for(var i:int=1;i<line.getPointLength();i++){
				var p1:FPoint= line.getPoint(i-1);
				var p2:FPoint = line.getPoint(i);
				dis += Math.abs(p2.getY()-p1.getY());
			}
			return dis;
		}
		/**
		 * get and set method
		 */
		public function getCenter():FPoint{
			return findGeo().getCenter();
		}
		public function setCenter(x:Number,y:Number):void{
			var point:FPoint = new FPoint();
			point.setX(x);
			point.setY(y);
			findGeo().setCenter(point);
		}
		public function getCenterX():Number{
			return findGeo().getCenter().getX();
		}
		public function getCenterY():Number{
			return findGeo().getCenter().getY();
		}
		//get and set id
		public function getSymbolId():String{
			return symbolId;
		}
		public function setSymbolId(id:String):void{
			symbolId = id;
		}
		//get and set group
		public function getGroup():String{
			return symbolGroup;
		}
		public function setGroup(symbolGroup:String):void{
			this.symbolGroup = symbolGroup;
		}
		//get UI可见
		public function isEnable():Boolean{
			return visible;
		}
		//set UI可用
		public function setEnable(enable:Boolean):void{
			this.enable = enable;
		}
		//get and set geometry
		public function getGeometry():Geometry{
			return geometry;
		}
		public function setGeometry(geometry:Geometry):void{
			this.geometry = geometry;
		}
		//get and set record
		public function getRecord():Record{
			return record;
		}
		public function setRecord(record:Record):void{
			this.record = record;
		}
	}
}