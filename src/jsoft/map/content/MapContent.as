package jsoft.map.content
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import jsoft.map.acete.DrawLayer;
	import jsoft.map.acete.VectorAcete;
	import jsoft.map.animate.Animate;
	import jsoft.map.animate.ShowZoom;
	import jsoft.map.config.MapConfig;
	import jsoft.map.config.MapLevel;
	import jsoft.map.event.MapEvent;
	import jsoft.map.event.MapHotEvent;
	import jsoft.map.event.MapPan;
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	
	import mx.core.UIComponent;
	
	public class MapContent extends UIComponent
	{
		// 当前的地图配置
		private var currentMapConfig:MapConfig;
		// 当前的等级
		private var currentLevel:int=0;
		// 当前等级的地图映射
		private var currentCoord:Coordinate=null;
		private var showOffsetX:int = 0;
		private var showOffsetY:int = 0;
		private var defaultLayer:ContentLayer = null;
		private var drawLayer:DrawLayer = null;
		private var vectorLayer:VectorAcete = null;
		private var mapEvent:MapEvent;
		private var hotEvent:MapHotEvent = new MapHotEvent();
		private var initEventFlag:Boolean = true;
		private var animate:Animate = null;
		private var tipWinCloseFlag:Boolean = false;
		private var lastWheelTime:Number = 0;
		private var wheelTimer:Number = -1;
		private var wheelLevel:int = 0;
		
		public function MapContent() {
			defaultLayer = new ContentLayer(this);
			drawLayer = new DrawLayer(this);
			vectorLayer = new VectorAcete(this);
		}
		
		public function is2DShow():Boolean {
			return defaultLayer is ContentLayer;
		}
		
		public function getDefaultLayer():MapLayer {
			return defaultLayer;
		}
		
		public function getDrawLayer():DrawLayer {
			return drawLayer;
		}
		
		public function getVectorLayer():VectorAcete {
			return vectorLayer;
		}
		
		public function getMapConfig():MapConfig {
			return currentMapConfig;
		}
		
		public function setMapConfig(config:MapConfig):void {
			if(currentMapConfig == config) {
				return;
			}
			currentMapConfig = config;
			AppContext.getMapContext().getLevelUI().setMapConfig(currentMapConfig);
			AppContext.getMapContext().getEagle().initEvent();
			if(currentCoord != null) {
				var cx:Number = currentCoord.getCenterX();
				var cy:Number = currentCoord.getCenterY();
				//AppContext.getAppUtil().alert("cx="+cx+",cy="+cy+",currentCoord="+currentCoord);
				currentCoord = null;
				setLevelIndex(currentLevel);
				currentCoord.setCenter(cx,cy);
				//AppContext.getAppUtil().alert("cx="+cx+",cy="+cy+",currentCoord="+currentCoord);
			} else {
				setLevelIndex(currentLevel);
			}
			defaultLayer.clearTiles();
		}
		
		public function getLevelIndex():int {
			return currentLevel;
		}
		
		public function setLevelIndex(level:int):void {
			clearAnimate();
			var newLevel:int = currentMapConfig.checkMapLevel(level);
			if(newLevel < 0) {
				// 空地图
				return;
			}
			if(currentCoord == null) {
				// 初始化地图坐标，并将地图放置在地图中心点
				currentLevel = newLevel;
				currentCoord = getLevel().createCoordinate(width,height);
				var levelCoord:Coordinate = getLevel().getCoordinate();
				currentCoord.setCenter(levelCoord.getCenterX(),levelCoord.getCenterY());
			} else if(currentLevel != newLevel) {
				// 初始化新等级的地图坐标，并保持地图中心点不变
				AppContext.getMapContext().getMapTipFactory().destory();//小江
				showZoomMap(newLevel);
				currentLevel = newLevel;
				var coord:Coordinate = getLevel().createCoordinate(width,height);
				coord.setCenter(currentCoord.getCenterX(),currentCoord.getCenterY());
				currentCoord = coord;
			}
			AppContext.getMapContext().getLevelUI().show(currentLevel);
		}
		
		public function resizeMap(width:int,height:int):void {
			clearAnimate();
			// 初始化地图坐标，并将地图放置在地图中心点
			currentCoord = getLevel().createCoordinate(width,height);
			var levelCoord:Coordinate = getLevel().getCoordinate();
			currentCoord.setCenter(levelCoord.getCenterX(),levelCoord.getCenterY());
		}
		
		public function getLevel():MapLevel {
			return currentMapConfig.getMapLevel(currentLevel);
		}

		public function getCoordinate():Coordinate {
			return currentCoord;
		}

		public function getCenterX():Number {
			return currentCoord.getCenterX();
		}

		public function getCenterY():Number {
			return currentCoord.getCenterY();
		}
		
		public function setCenter(cx:Number,cy:Number):void {
			currentCoord.setCenter(cx,cy);
		}
		
		public function moveTo(offsetX:int,offsetY:int):void {
			var mapx:Number = -offsetX / currentCoord.getUnitX();
			var mapy:Number = offsetY / currentCoord.getUnitY();
			currentCoord.setCenter(currentCoord.getCenterX()+mapx,currentCoord.getCenterY()+mapy);
		}
		
		// 缩放地图到指定等级，并刷新地图
		public function zoomMapToLevel(newLevel:int) : Boolean {
			//AppContext.getAppUtil().alert("zoomMapToLevel");
			var mapConfig:MapConfig = getMapConfig();
			//AppContext.getAppUtil().alert("zoomMapToLevel mapConfig="+mapConfig);
			if(mapConfig == null) {
				return false;
			}
			//AppContext.getAppUtil().alert("org level="+getLevelIndex());
			newLevel = mapConfig.checkMapLevel(newLevel);
			//AppContext.getAppUtil().alert("dst level="+newLevel+",currentLevel="+currentLevel);
			clearMap();
			if(currentLevel != newLevel) {
				showZoomMap(newLevel);
				//AppContext.getAppUtil().alert("zoomMapToLevel dst1 level="+getLevelIndex()+",this.level="+newLevel);
				setLevelIndex(newLevel);
				showMap();
				refresh();
				//AppContext.getAppUtil().alert("zoomMapToLevel dst3 level="+level+",this.level="+this.level);
				return true;
			}
			return false;
		}
		// 缩放地图到指定等级，移动到新等级的中心点，并刷新地图
		public function zoomAndCenterMapToLevel(newLevel:int) : Boolean {
			var mapConfig:MapConfig = getMapConfig();
			if(mapConfig == null) {
				return false;
			}
			newLevel = mapConfig.checkMapLevel(newLevel);
			clearMap();
			if(currentLevel != newLevel) {
				showZoomMap(newLevel);
				setLevelIndex(newLevel);
				var newLevelObj:MapLevel = mapConfig.getMapLevel(newLevel);
				centerMapAt(newLevelObj.getMap().getCenterX(),newLevelObj.getMap().getCenterY());
				showMap();
				refresh();
				return true;
			}
			return false;
		}
		// 缩放地图到指定等级，指定新的中心点坐标，并刷新地图
		public function zoomAndMoveMapToLevel(newLevel:int,mapCenterX:Number,mapCenterY:Number) : Boolean {
			var mapConfig:MapConfig = getMapConfig();
			if(mapConfig == null) {
				return false;
			}//AppContext.getAppUtil().alert("newLevel="+newLevel+",level="+level);
			newLevel = mapConfig.checkMapLevel(newLevel);
			//clearMap();
			if(currentLevel != newLevel) {
				showZoomMap(newLevel);
				setLevelIndex(newLevel);
				centerMapAt(mapCenterX,mapCenterY);
				showMap();
				refresh();
				return true;
			}
			return false;
		}
		// 缩放地图到指定范围，并刷新地图
		public function zoomMapToRangeBox(mapBounds:Box):void {
			zoomMapToRange(mapBounds.getMinx(),mapBounds.getMiny(),mapBounds.getMaxx(),mapBounds.getMaxy());
		}
		// 缩放地图到指定范围，并刷新地图
		public function zoomMapToRange(minx:Number,miny:Number,maxx:Number,maxy:Number):void {
			//地图容器(div)的宽度和高度
			var mapDivWidth:int = getScreenWidth();
			var mapDivHeight:int = getScreenHeight();
			var mapWidth:Number = maxx - minx;
			var mapHeight:Number = maxy - miny;
			if(mapHeight < 0) {
				mapHeight = -mapHeight;
			}
			var mapCenterX:Number = (minx * 1.0 + maxx * 1.0) / 2;
			var mapCenterY:Number = (miny * 1.0 + maxy * 1.0) / 2;
			var selectLevel:int = 0;
			var mapConfig:MapConfig = getMapConfig();
			for(var i:int=0;i<mapConfig.getMapLevelLength();i++) {
				var mapLevel:MapLevel = mapConfig.getMapLevel(i);
				var coord:Coordinate = mapLevel.getCoordinate();
				var levelMapWidth:Number = coord.mapFromViewX(mapDivWidth) - coord.mapFromViewX(0);
				var levelMapHeight:Number = coord.mapFromViewY(mapDivHeight) - coord.mapFromViewY(0);
				if(levelMapHeight < 0) {
					levelMapHeight = -levelMapHeight;
				}//AppContext.getAppUtil().alert("mapWidth="+mapWidth+",mapHeight="+mapHeight+",levelMapWidth="+levelMapWidth+",levelMapHeight="+levelMapHeight);
				if(levelMapWidth >= mapWidth && levelMapHeight >= mapHeight) {
					selectLevel = i;
				} else {
					break;
				}
			}
			if(selectLevel == getLevelIndex()) {
				//selectLevel = getLevel() + 1;
			}
			zoomAndMoveMapToLevel(selectLevel,mapCenterX,mapCenterY);
		}
		// 移动地图中心点到指定的屏幕距离
		public function moveMapByViewDistance(distanceX:Number,distanceY:Number):void {
			var curCoord:Coordinate = getCoordinate();
			if(curCoord == null) {
				return;
			}
			var mapX:Number = curCoord.mapFromViewDX(distanceX);
			var mapY:Number = curCoord.mapFromViewDY(distanceY);
			var cx:Number = curCoord.getCenterX();
			var cy:Number = curCoord.getCenterY();
			cx -= mapX;
			cy += mapY;
			curCoord.setCenter(cx,cy);
		}
		// 将地图移动到指定的屏幕中心点
		public function centerMapAtByView(viewX:int,viewY:int):void {
			var curCoord:Coordinate = getCoordinate();
			var mapX:Number = curCoord.mapFromViewX(viewX);
			var mapY:Number = curCoord.mapFromViewY(viewY);
			centerMapAt(mapX,mapY);
		}
		// 将地图移动到指定的地图中心坐标
		public function centerMapAt(mapX:Number,mapY:Number):void {
			currentCoord.setCenter(mapX,mapY);
			showMap();
		}
		// 清除整个地图
		public function clearMap() : void {
			//AppContext.getAppUtil().alert("clearMap");
			AppContext.getMapContext().clearInputLayer();
			AppContext.getMapContext().getMapDrawLayer().clear();
			//AppContext.getMapContext().getVectorInstance().clearSelect();
			//AppContext.getMapContext().getMapTipFactory().destory();
			AppContext.getMapContext().getMapTipFactory().clear();
			AppContext.getMapContext().getHotInstance().clear();
			vectorLayer.clear();
		}
		// 清除输入
		public function clearInput() : void {
			//AppContext.getAppUtil().alert("clearInput");
			AppContext.getMapContext().clearInputLayer();
		}
		// 获取屏幕的宽度
		public function getScreenWidth() : int {
			var screenWidth:int = width;
			return screenWidth;
		}
		// 获取屏幕的高度
		public function getScreenHeight() : int {
			var screenHeight:int = height;
			return screenHeight;
		}
		
		public function getShowOffsetX():int {
			return showOffsetX;
		}
		
		public function getShowOffsetY():int {
			return showOffsetY;
		}
		
		public function setShowOffset(offsetX:int,offsetY:int):void {
			showOffsetX = offsetX;
			showOffsetY = offsetY;
		}

		public function showMap():void {
			if(currentCoord == null) {
				return;
			}
			if(initEventFlag && stage != null) {
				stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
				stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				stage.addEventListener(Event.RESIZE, onResize);
				stage.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
				
//				AppContext.getApplication().addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//				AppContext.getApplication().addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//				AppContext.getApplication().addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//				AppContext.getApplication().addEventListener(Event.RESIZE, onResize);
//				AppContext.getApplication().addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
				
				
				//defaultLayer.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
				//drawLayer.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
				//vectorLayer.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
//				this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
//				this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
//				this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
//				this.addEventListener(Event.RESIZE, onResize);
				initEventFlag = false;
			}
			var cx:Number = currentCoord.getCenterX();
			var cy:Number = currentCoord.getCenterY();
			defaultLayer.loadTiles(cx,cy);
			defaultLayer.showMap(cx,cy);
			drawLayer.loadTiles(cx,cy);
			drawLayer.showMap(cx,cy);
			vectorLayer.loadTiles(cx,cy);
			vectorLayer.showMap(cx,cy);
		}
		
		public function showZoomMap(zoomLevel:int):void {
			if(zoomLevel < 0) {
				zoomLevel = 0;
			} else if(zoomLevel >= getMapConfig().getMapLevelLength()) {
				zoomLevel = getMapConfig().getMapLevelLength()-1;
			}
			if(currentCoord == null) {
				return;
			}
			if(defaultLayer != null) {
				defaultLayer.showZoomMap(zoomLevel);
			}
			if(drawLayer != null) {
				drawLayer.showZoomMap(zoomLevel);
			}
			if(vectorLayer != null) {
				vectorLayer.showZoomMap(zoomLevel);
			}
		}
		
		public function refresh():void {
			defaultLayer.refresh();
			drawLayer.refresh();
			vectorLayer.refresh();
			AppContext.getMapContext().getHotInstance().refresh();
			AppContext.getMapContext().getScale().show();
			AppContext.getMapContext().getEagle().refresh();
			flash.external.ExternalInterface.call("fMap.callRefreshCallback");
		}
		
		public function getMapEvent():MapEvent {
			return mapEvent;
		}
		
		public function setMapEvent(mapEvent:MapEvent):void {
			this.mapEvent = mapEvent;
		}
		
		public function setMapPanEvent():void {
			this.mapEvent = new MapPan();
		}
		
		public function onMouseDown(event:MouseEvent):void {
			// 鼠标按下
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			AppContext.getMapContext().getHotContainer().hideHot();
			if(checkEvent()) {
				if(!hotEvent.onMouseDown(event)) {
					mapEvent.onMouseDown(event);
				}
			}
		}
		
		public function onMouseMove(event:MouseEvent):void {
			// 鼠标移动
			//AppContext.getAppUtil().showStatus("onMouseMove x="+event.localX+",y="+event.localY+",checkEvent="+checkEvent()+",isMouseDown="+AppContext.getMapContext().getLevelUI().isMouseDown());
			if(checkEvent()) {
				if(!hotEvent.onMouseMove(event)) {
					mapEvent.onMouseMove(event);
				}
			}
		}
		
		public function onMouseUp(event:MouseEvent):void {
			// 鼠标放开
			if(checkEvent()) {
				if(!hotEvent.onMouseUp(event)) {
					mapEvent.onMouseUp(event);
				}
			}
		}
		
		public function onMouseWheel(event:MouseEvent):void {
			// 鼠标滚动
			//AppContext.getAppUtil().alert("onMouseWheel event " + event.delta);
			var date:Date = new Date();
			var time:Number = date.getTime();
			//trace("onMouseWheel time= " + time + ", lastWheelTime= " + lastWheelTime);
			if(time-lastWheelTime<300) {
				//trace("onMouseWheel return time= " + time + ", lastWheelTime= " + lastWheelTime);
				return;
			}
			lastWheelTime=time;
			if(wheelTimer >= 0) {
				clearTimeout(wheelTimer);
				wheelTimer = -1;
			}
			if(event.delta > 0) {
				//zoomInMap();
				wheelLevel++;
			} else {
				//zoomOutMap();
				wheelLevel--;
			}
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			mapContent.showZoomMap(mapContent.getLevelIndex()+wheelLevel);
			wheelTimer = setTimeout(zoomMap,500);
		}
		
		private function zoomMap():void {
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			//var showZoom:ShowZoom = new ShowZoom(mapContent.getScreenWidth()/2,mapContent.getScreenHeight()/2);
			//mapContent.setAnimate(showZoom);
			mapContent.setLevelIndex(mapContent.getLevelIndex()+wheelLevel);
			mapContent.showMap();
			mapContent.refresh();
			wheelLevel = 0;
		}
		
		private function zoomInMap():void {
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			var showZoom:ShowZoom = new ShowZoom(mapContent.getScreenWidth()/2,mapContent.getScreenHeight()/2);
			mapContent.setAnimate(showZoom);
			mapContent.setLevelIndex(mapContent.getLevelIndex()+1);
			mapContent.showMap();
			mapContent.refresh();
			wheelLevel = 0;
		}
		
		private function zoomOutMap():void {
			var mapContent:MapContent = AppContext.getMapContext().getMapContent();
			var showZoom:ShowZoom = new ShowZoom(mapContent.getScreenWidth()/2,mapContent.getScreenHeight()/2);
			mapContent.setAnimate(showZoom);
			mapContent.setLevelIndex(mapContent.getLevelIndex()-1);
			mapContent.showMap();
			mapContent.refresh();
			wheelLevel = 0;
		}
		
		private function onStageMouseLeave(event:Event):void {
			// 鼠标离开
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			if(checkEvent()) {
				if(!hotEvent.onMouseLeave(event)) {
					mapEvent.onMouseLeave(event);
				}
			}
		}
		
		private function checkEvent():Boolean {
			if(tipWinCloseFlag) {
				tipWinCloseFlag = false;
				return false;
			}
			return checkLevelEvent() && mapEvent != null;
		}
		
		private function checkLevelEvent():Boolean {
			return !AppContext.getMapContext().getLevelUI().isMouseDown();
		}
		
		private function onResize(event:Event):void {
			if(defaultLayer != null) {
				defaultLayer.refresh();
			}
			if(drawLayer != null) {
				drawLayer.refresh();
			}
		}
		
		public function getAnimate():Animate {
			return animate;
		}
		
		public function setAnimate(animate:Animate):void {
			clearAnimate();
			this.animate = animate;
			if(animate != null) {
				this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
		
		public function clearAnimate():void {
			if(animate != null) {
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
				if(animate is UIComponent) {
					var comp:UIComponent = animate as UIComponent;
					if(this.contains(comp)) {
						this.removeChild(comp);
					}
				}
				animate = null;
			}
			graphics.clear();
		}
		
		private function onEnterFrame(event:Event):void {
			if(animate != null) {
				animate.onFrame(this);
			} else {
				this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			}
		}
		
		public function startLoop():void {
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		public function stopLoop():void {
			this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		
		public function getTipWinCloseFlag():Boolean {
			return tipWinCloseFlag;
		}
		
		public function setTipWinCloseFlag(tipWinCloseFlag:Boolean=true):void {
			//AppContext.getAppUtil().alert("setTipWinCloseFlag");
			this.tipWinCloseFlag = tipWinCloseFlag;
		}
	}
}