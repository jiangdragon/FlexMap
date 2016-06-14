package jsoft.map.ui
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	
	import jsoft.map.config.MapConfig;
	import jsoft.map.content.MapContent;
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.event.MapEvent;
	import jsoft.map.event.MapZoomIn;
	import jsoft.map.event.MapZoomOut;
	import jsoft.map.util.DrawUtil;
	
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.graphics.ImageSnapshot;
	
	
	public class UILevel extends UIComponent
	{
		private var mapConfig:MapConfig;
		private var mapContent:MapContent;
        private var color:int = rgbToInt(128,130,130);
		private var colora:int = rgbToInt(154,153,153);
		private var fillColor:int = rgbToInt(0,0,0);
		private var bordeColor:int = rgbToInt(255,255,255);
        private var fillCircleAllColor:int = 0;
		private var fillCircleAllColorS:int = rgbToInt(255,255,255);
		private var imfillColor:int = rgbToInt(255,200,0);
		private var startX:int = 10;
		private var startY:int = 80;
		private var stepX:int = 0;
		private var stepY:int = 10;
		private var boxLen:int = 8;
		private var lineWidth:int = 1;
		private var mouseDown:Boolean = false;
		private var mouseFlag:Boolean = false;
		private var curX:int;
		private var curY:int;
		private var clickButton:int = 0;
		private var clickLevel:int = 0;
		private var wheelTimer:int = 0;
		private var map3D:Boolean = false;
		private var alphaimzoomin:Number=0;
		private var alphaimzoomout:Number=0;
		private var alphaimmoveall:Number=1;
		private var isOnObject:Boolean=false;//判断是否鼠标在当前组件上操作
		[Embed(source="jsoft/map/cursor/zoominbar.png")]
		public static var zoominbar:Class;
		
		[Embed(source="jsoft/map/cursor/levelbar.png")]
		public static var bar:Class;
		
		[Embed(source="jsoft/map/cursor/zoomoutbar.png")]
		public static var zoomoutbar:Class;
		
		[Embed(source="jsoft/map/cursor/closed.png")]
		public static var QuantuCur:Class;
		
		[Embed(source="jsoft/map/cursor/bar.png")]
		public static var zoombar:Class;
		
		[Embed(source="../cursor/button.png")]
		public static var DownCur:Class;
		
		[Embed(source="jsoft/map/cursor/overleft.png")]
		public static var overleft:Class;
		
		[Embed(source="jsoft/map/cursor/overright.png")]
		public static var overright:Class;
		
		[Embed(source="jsoft/map/cursor/overup.png")]
		public static var overup:Class;
		
		[Embed(source="jsoft/map/cursor/overdown.png")]
		public static var overdown:Class;
		
		[Embed(source="jsoft/map/cursor/allmap.png")]
		public static var allmap:Class;
		
		[Embed(source="jsoft/map/cursor/i_pan.png")]
		public static var ipan:Class;
		
		[Embed(source="jsoft/map/cursor/i_zoomin.png")]
		public static var izoomin:Class;
		
		[Embed(source="jsoft/map/cursor/i_zoomout.png")]
		public static var izoomout:Class;
		
		[Embed(source="jsoft/map/cursor/framepan.png")]
		public static var framepan:Class;
		
		[Embed(source="jsoft/map/cursor/framezoomin.png")]
		public static var framezoomin:Class;
		
		[Embed(source="jsoft/map/cursor/framezoomout.png")]
		public static var framezoomout:Class;
		
		private static var history:Array=new Array(10);
		private static var historyIndex:int=10;		
		public static var barx:Number;//当前游标的x值
		public static var bary:Number;  //当前游标的y值
		public static var cursorx:Number;//当前游标的x值
		public static var cursory:Number;  //当前游标的y值
		public static var _staticalpha:Number;
		public static var isAspect:Boolean=false;
		
		public function UILevel() {			

		}

		public function isMouseDown():Boolean {
			if(mouseFlag) {
				mouseFlag = false;
				return true;
			}
			return mouseDown || clickButton > 0;
		}

		public function setMouseDown(flag:Boolean=true):void {
			mouseFlag=flag;
		}
        //初始化控件监听器
		private function initEvent():void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			this.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
			this.buttonMode=true;		
			mapContent = AppContext.getMapContext().getMapContent();
		}
		//获得鼠标是否在当前组件上操作
		public function getIsOnObject():Boolean{
			return this.isOnObject;
		}
		//设置是否在当前组件上操作
		private function setIsOnObject(isOnObject:Boolean):Boolean{
			return this.isOnObject=isOnObject;
		}
        //鼠标滑过控件
		private function onMouseOver(event:MouseEvent):void{
			setIsOnObject(true);
			this.alpha=0.8;
		}
		//鼠标离开控件
		private function onMouseOut(event:MouseEvent):void{
			setIsOnObject(false);
			this.alpha=0.5;
		}
		private function onMouseDown(event:MouseEvent):void {			
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			curX = event.stageX - this.x;
			curY = event.stageY - this.y;
			var ret:Boolean = checkRectAry(getAllLevelMaxRect());
			clickButton = -1;

			if(ret) {
				clickLevel = checkClickLevel();
				show(clickLevel);
				var currentLevel:int=AppContext.getMapContext().getMapContent().getLevelIndex();
				drawblockbar(clickLevel);
				drawLevelText(clickLevel);
				mapContent.showZoomMap(clickLevel);
				mouseDown = true;
				historyWrite();
			}
			clickButton  = checkClickButton();
			if(clickButton == 1) {
						var maxLevel:int = mapConfig.getMapLevelLength();
					if(currentLevel<maxLevel-1)
						{
						    var t:Image =getChildByName("imdowncur") as Image;
 							t.move(t.x,t.y-10);        
					}
				zoomInOneLevel();
			    historyWrite();
				return ;
			}
			if(clickButton == 2) {
				var currentLevelzoomout:int=AppContext.getMapContext().getMapContent().getLevelIndex();
				if(currentLevelzoomout>0){
				    var zoomoutimage:Image =getChildByName("imdowncur") as Image;
					zoomoutimage.move(zoomoutimage.x,zoomoutimage.y+10);
				}
				zoomOutOneLevel();
				historyWrite();
				return ;
			}
		}

		private function onMouseMove(event:MouseEvent):void {		
			if(!mouseDown) {
				return;
			}
			curX = event.stageX - this.x;
			curY = event.stageY - this.y;
			clickLevel = checkClickLevel();
			var currentLevel:int=AppContext.getMapContext().getMapContent().getLevelIndex();				
			var t:Image =getChildByName("imdowncur") as Image;
			t.move(t.x,200-(clickLevel+1)*10);			
			show(clickLevel);
	        drawLevelText(clickLevel);
		    mapContent.showZoomMap(clickLevel);
		}

		private function onMouseUp(event:MouseEvent):void {			
			if(!mouseDown) {
				return;
			}
			mouseDown = false;
			clickLevel = checkClickLevel();
			mapContent.setLevelIndex(clickLevel);
			mapContent.showMap();
			mapContent.refresh();
		}

		private function onStageMouseLeave(event:Event):void {			
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			if(!mouseDown) {
				return;
			}
			mouseDown = false;
			clickLevel = checkClickLevel();
			mapContent.setLevelIndex(clickLevel);
			mapContent.showMap();
			mapContent.refresh();
		}

		private function onMouseClick(event:MouseEvent):void {
			
		}
		/**
		 * 记录操作日志
		 * **/
		public function historyWrite():void{
			if(historyIndex==0){
				//1、记录当前坐标和层级
				var x:Number = mapContent.getCenterX();
				var y:Number = mapContent.getCenterY();
				var level:Number = mapContent.getLevelIndex();
				history.unshift(new Array(level,x,y));
				history.pop();
			}else{//索引大于0，索引后的记录全部清除
				//1、记录当前坐标和层级				
				var x1:Number = mapContent.getCenterX();
				var y1:Number = mapContent.getCenterY();
				var level1:Number = mapContent.getLevelIndex();				
				historyIndex--;
				history[historyIndex][0]=level1;
				history[historyIndex][1]=x1;
				history[historyIndex][2]=y1;						
				//2、更新历史记录数组
				for(var m:int=historyIndex-1;m>=0;m--){
					history[m][0]=null;
				}
			}
		}
					
		//缩小倍数
		private function zoomInOneLevel():void {
			var level:int = mapContent.getLevelIndex();
			mapContent.setLevelIndex(level+1); 
			mapContent.showMap();
			mapContent.refresh();
		}
		//放大倍数
		private function zoomOutOneLevel():void {
			var level:int = mapContent.getLevelIndex();
			mapContent.setLevelIndex(level-1);
			mapContent.showMap();
			mapContent.refresh();
		}
		
		public function getMapConfig():MapConfig {
			return mapConfig;
		}

		public function setMapConfig(mapConfig:MapConfig):void {
			this.mapConfig = mapConfig;
			initLevelObject();
		}
 
		private function initLevelObject():void {
			var levelWidth:int = getLevelWidth();
			var levelHeight:int = getLevelHeight();
			this.width = levelWidth + 1;
			this.height = levelHeight + 1;
			initEvent();			
		}

		public function getMaxLevel() : int {
			var maxLevel:int = mapConfig.getMapLevelLength();
			return maxLevel;
		}

		public function refresh():void {
			var currentLevel:int=AppContext.getMapContext().getMapContent().getLevelIndex();
			show(currentLevel);
		}

		public function show(currentLevel:int):void {
			if(currentLevel < 0) {
				currentLevel = 0;
			}
			if(currentLevel >= getMaxLevel()) {
				currentLevel = getMaxLevel()-1;
			}
			_staticalpha=1;
			graphics.clear();
			if(!isAspect){			
				isAspect=true;	
				drawZoomBar();	
//				drawZoomIn();
//		    	drawZoomOut();		
//		    	drawLevel();
//		    	drawCenter();
//		    	drawBlock(currentLevel);
//              drawFillRect(111,111,300,300);
//		    	graphics.drawRect(0,0,100,100);	
				drawHistory();
				drawDirection();
//				drawZoomBarExt();
				this.alpha=0.5;
		}
     		drawblockbar(currentLevel);
			mapContent.refresh();			
			
		}
		/**
		 * 确定滚动球位置
		 * **/
		private function drawblockbar(level:int):void{
			var timeimage:Image =getChildByName("imdowncur") as Image;  
			var levelmax:int=mapConfig.getMapLevelLength();	
			timeimage.move(timeimage.x,100+levelmax*10-(level+1)*10);
		}
		//画缩放级别条
       private function drawZoomBar():void{
            var levelmax:int=mapConfig.getMapLevelLength();
			//级别条
			var im:Image = new Image();	
			im.alpha=0.5;
			im.name="zoominbar";
			im.x= -5;
			im.y = 104+levelmax*10;
			im.width = 23;	
			im.height = 24;
			im.source = zoominbar;
			im.buttonMode=true;
			im.addEventListener(MouseEvent.MOUSE_OVER,zoominbarMouseOver);
			im.addEventListener(MouseEvent.MOUSE_OUT,zoominbarMouseOut);
			addChild(im);
			
			
			for(var a:int=0;a<levelmax;a++){
			
			//级别条
			//var im:Image = new Image();	
			im = new Image();
			im.alpha=0.5;
			im.name="levelline";
			im.x= -5;
			im.y = 104+a*10;
			im.width = 23;	
			im.height =12;
			im.source = bar;
			im.buttonMode=true;
//			im.addEventListener(MouseEvent.MOUSE_OVER,onLevelLineMouseOver);
			im.addEventListener(MouseEvent.MOUSE_OUT,onLevelLineMouseOut);
			addChild(im);
			}
			//级别条
			//var im:Image = new Image();
			im = new Image();	
			im.alpha=0.5;
			im.name="zoomoutbar";
			im.x= -5;
			im.y = 80;
			im.width = 23;	
			im.height = 27;
			im.source = zoomoutbar;
			im.buttonMode=true;
			im.addEventListener(MouseEvent.MOUSE_OVER,zoomoutbarMouseOver);
			im.addEventListener(MouseEvent.MOUSE_OUT,zoomoutbarMouseOut);
			addChild(im);
			//滚动球
			var imbar:Image = new Image();	
			imbar.name="imdowncur";	
			imbar.alpha=0.5;	
			imbar.x= 0;
			imbar.y =0;
			imbar.width = 20;	
			imbar.height = 20;
			imbar.source = DownCur;
			imbar.buttonMode=true;
			imbar.addEventListener(MouseEvent.MOUSE_OVER,onLevelLineMouseOver);
			imbar.addEventListener(MouseEvent.MOUSE_OUT,onLevelLineMouseOut);
			addChild(imbar);
		}
		/**
		 * 鼠标经过级别条事件
		 * **/
		private function onLevelLineMouseOver(event:Event):void{
//			getChildByName("zoomoutbar").alpha=1;
			getChildByName("imdowncur").alpha=1;
		}
		private function zoomoutbarMouseOver(event:Event):void{
			getChildByName("zoomoutbar").alpha=1;
			getChildByName("imdowncur").alpha=1;
		}
		private function zoominbarMouseOver(event:Event):void{
			getChildByName("zoominbar").alpha=1;
			getChildByName("imdowncur").alpha=1;
		}
		private function zoominbarMouseOut(event:Event):void{
			getChildByName("zoominbar").alpha=0.5;
			getChildByName("imdowncur").alpha=0.5;
		}
		private function zoomoutbarMouseOut(event:Event):void{
			getChildByName("zoomoutbar").alpha=0.5;
			getChildByName("imdowncur").alpha=0.5;
		}
		
		/**
		 * 鼠标离开级别条事件
		 * **/
		private function onLevelLineMouseOut(event:Event):void{
			getChildByName("levelline").alpha=0.5;
			getChildByName("imdowncur").alpha=0.5;
		}
		/**
		 * 在地图中画历史操作图标并初始化历史记录数组
		 * **/
		public function drawHistory():void{
			//画历史按钮
//			drawHistoryImage();		
			//初始化历史按钮
			for(var m:int=0;m<history.length;m++){
				history[m]=new Array(3);
			}
			historyIndex--;				
			history[historyIndex][0]=mapContent.getLevelIndex();
			history[historyIndex][1]=mapContent.getCenterX();
			history[historyIndex][2]=mapContent.getCenterY();
		}	
		
		/**
		 * 上一步触发事件
		 * **/		
		private function onLastMouseClick(event:Event):void{
			if(historyIndex<history.length-1){
				historyIndex++;
			}else{
				Alert.show("can't last");
				return;
			}			
			var x:Number = history[historyIndex][1];
			var y:Number = history[historyIndex][2];
			var level:Number = history[historyIndex][0];
			var aa:Number=UIScale.a;
			var lon:Number = x;
			var lat:Number = y;
			mapContent.centerMapAt(lon,lat);
			mapContent.setLevelIndex(level);
			mapContent.refresh();
		}
		/**
		 * 下一步触发事件
		 * **/
		private function onNextMouseClick(event:Event):void{
			if(historyIndex>0&&history[historyIndex-1][0]!=null){
				historyIndex--;
			}else{
				Alert.show("can't next");
				return;
			}
			var x:Number = history[historyIndex][1];
			var y:Number = history[historyIndex][2];
			var level:Number = history[historyIndex][0];
			var aa:Number=UIScale.a;
			var lon:Number = x;
			var lat:Number =y;
			mapContent.centerMapAt(lon,lat);	
			mapContent.setLevelIndex(level);
			mapContent.refresh();
		}
		/**
		 * 画导航图
		 * **/
		private function drawDirection():void{
			//导航圆盘
			var imback:Image = new Image();
			imback.name="nav"
			imback.alpha=0.5;
			imback.x= -42;
			imback.y= -43;
			imback.width = 100;	
			imback.height = 100;
			imback.buttonMode=true;
			imback.source = QuantuCur;
			addChild(imback);
			//向上导航按钮
			var imoverup:Image = new Image();
			imoverup.name="imoverup"
			imoverup.alpha=0;
			imoverup.x= -14;
			imoverup.y= -25;
			imoverup.width = 45;	
			imoverup.height = 23;
			imoverup.buttonMode=true;
			imoverup.source = overup;
			imoverup.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverImipan);
			imoverup.addEventListener(MouseEvent.MOUSE_OUT,onLastLeaveImOverForImageExt);
			imoverup.addEventListener(MouseEvent.MOUSE_UP,upOneLevel);
			addChild(imoverup);
			//向下导航按钮
			var imoverdown:Image = new Image();
			imoverdown.alpha=0;
			imoverdown.name="imoverdown";
			imoverdown.x= -15;
			imoverdown.y= 16;
			imoverdown.width = 47;	
			imoverdown.height = 25;
			imoverdown.buttonMode=true;
			imoverdown.source = overdown;
			imoverdown.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverImipan);
			imoverdown.addEventListener(MouseEvent.MOUSE_OUT,onLastLeaveImOverForImageExt);
			imoverdown.addEventListener(MouseEvent.MOUSE_UP,downOneLevel);
			addChild(imoverdown);
			//向左导航按钮
			var imoverleft:Image = new Image();
			imoverleft.alpha=0;
			imoverleft.name="imoverleft";
			imoverleft.x= -25;
			imoverleft.y= -15;
			imoverleft.width = 22;	
			imoverleft.height = 48;
			imoverleft.buttonMode=true;
			imoverleft.source = overleft;
			imoverleft.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverImipan);
			imoverleft.addEventListener(MouseEvent.MOUSE_OUT,onLastLeaveImOverForImageExt);
			imoverleft.addEventListener(MouseEvent.MOUSE_UP,leftOneLevel);
			addChild(imoverleft);
			//向右导航按钮
			var imoverright:Image = new Image();
			imoverright.alpha=0;
			imoverright.name="imoverright";
			imoverright.x= 17;
			imoverright.y= -15;
			imoverright.width = 25;	
			imoverright.height =46;
			imoverright.buttonMode=true;
			imoverright.source = overright;
			imoverright.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverImipan);
			imoverright.addEventListener(MouseEvent.MOUSE_OUT,onLastLeaveImOverForImageExt);
			imoverright.addEventListener(MouseEvent.MOUSE_UP,rightOneLevel);
			addChild(imoverright);
			//全景图按钮
			var imallmap:Image = new Image();
			imallmap.alpha=0;
			imallmap.name="imallmap";
			imallmap.x= -12;
			imallmap.y= -12;
			imallmap.width = 40;	
			imallmap.height =40;
			imallmap.source = allmap;
			imallmap.buttonMode=true;
			imallmap.addEventListener(MouseEvent.MOUSE_OVER, onMouseOverImipan);
			imallmap.addEventListener(MouseEvent.MOUSE_OUT,onLastLeaveImOverForImageExt);
			imallmap.addEventListener(MouseEvent.MOUSE_UP,allMapOneLevel);
			addChild(imallmap);			
		}
		/**
		 * 鼠标离开事件隐藏图片
		 * 
		 * **/
		private function onLastLeaveImOverForImageExt(event:MouseEvent):void{
			((event.target) as UIComponent).alpha=0;
		}

//        //鼠标经过时增加ALPHA
		private function onMouseOverImipan(event:MouseEvent):void{
			((event.target) as UIComponent).alpha=1;
		}
//		//鼠标离开时降低ALPHA
		private function onLastLeaveImipan(event:MouseEvent):void{
			((event.target) as UIComponent).alpha=0.5;
		}

/*************end000000000000000000000000000000000000000000000000*******************************/

		//绘制方向键中外圈的圆
		 private function drawButtonAllMap():void{
			var array:Array = new Array();
			var x:int = 5;
			var y:int = 16;
			var z:int = 27;
			
			array[array.length] = x;
			array[array.length] = y;
			array[array.length] = z;
			drawFillCircleEx(array);
		}
//		绘制内圈的方法

 private function drawButtonSmall():void{
			var array:Array = new Array();
			var x:int = 5;
			var y:int = 16;
			var radius:int = 15;			
			graphics.lineStyle(1,color);
			graphics.beginFill(fillCircleAllColorS);
			graphics.drawCircle(x,y,radius);
			graphics.endFill();
		}
		// 向左
		private function drawLeft():void{
			var array:Array = getMoveLeft();
			var x1:int = -15;
			var y1:int = 9;
			var x2:int = 0;
			var y2:int = 24;
			array[array.length] = x1;
			array[array.length] = y1;
			array[array.length] = x2;
			array[array.length] = y2;
//			drawFillRectEx(array);
			drawLine((x2+x1)/2-12,(y1+y2)/2+1,x2-13,y1+3);
			drawLine((x2+x1)/2-12,(y1+y2)/2+1,x2-13,y2-3);
			mapContent.refresh();
		}
		// 向右
		private function drawRight():void {
			var array:Array = new Array();
			var x1:int = 11;
			var y1:int = 9;
			var x2:int = 24;
			var y2:int = 24;
			array[array.length] = x1;
			array[array.length] = y1;
			array[array.length] = x2;
			array[array.length] = y2;
			drawLine((x2+x1)/2+10,(y1+y2)/2+1,x1+8,y1+0);
			drawLine((x2+x1)/2+10,(y1+y2)/2+1,x1+8,y2-0);
		}
		// 向上
		private function drawUp():void {
			var array:Array = new Array();
			var x1:int = -3;
			var y1:int = -10;
			var x2:int = 13;
			var y2:int = 4;
			array[array.length] = x1;
			array[array.length] = y1;
			array[array.length] = x2;
			array[array.length] = y2;
			drawLine((x2+x1)/2,(y1+y2)/2-4,x1+3,y2-4);
			drawLine((x2+x1)/2,(y1+y2)/2-4,x2-3,y2-4);
		}
		// 向下
		private function drawDown():void {
			var array:Array = new Array();
			var x1:int = -3;
			var y1:int = 28;
			var x2:int = 13;
			var y2:int = 42;
			array[array.length] = x1;
			array[array.length] = y1;
			array[array.length] = x2;
			array[array.length] = y2;
			drawLine((x2+x1)/2,(y1+y2)/2+4,x2-3,y1+4);
			drawLine((x2+x1)/2,(y1+y2)/2+4,x1+3,y1+4);
		}
/*************************************************************************************************************************/
		private function drawBorder():void{
			var array:Array = new Array();
			var x:int = -46;
			var y:int = -45;
			var z:int = 1350;
			var s:int = 560;
			array[array.length] = x;
			array[array.length] = y;
			array[array.length] = z;
			array[array.length] = s;
			drawFillBorderEx(array);
		}
		private function drawFillBorderEx(rect:Array):void{
			drawFillBorder(rect[0],rect[1],rect[2],rect[3]);
		}
		private function drawFillBorder(x:int,y:int,z:int,s:int):void {
			var x1:int = x;
			var y1:int = y;
			var w:int = z;
			var h:int = s;
	       graphics.lineStyle(15,colora);
			graphics.drawRect(x1,y1,w,h);
			graphics.endFill();
			
		}
		//下面为地图移动的功能类
		// 使地图向左移动
		private function leftOneLevel(event:MouseEvent):void{
			var x:Number = mapContent.getCenterX();
			var y:Number = mapContent.getCenterY();
			var level:Number = mapContent.getLevelIndex();
		    var e:UIScale=new UIScale();		
	    	var aa:Number=UIScale.a;		 		
		  	var lon:Number = x+0.5*aa/50;
			var lat:Number = y;
		 	mapContent.centerMapAt(lon,lat);	
			mapContent.refresh();
			historyWrite();
		}
		//使地图向下移动
		private function downOneLevel(event:MouseEvent):void{
			var x:Number = mapContent.getCenterX();
			var y:Number = mapContent.getCenterY();
			var level:Number = mapContent.getLevelIndex();
			var aa:Number=UIScale.a;
			var lon:Number = x;
			var lat:Number = y+0.5*aa/50;
		 	mapContent.centerMapAt(lon,lat);	
			mapContent.refresh();
			historyWrite();
		}
		//使地图向右移动
		private function rightOneLevel(event:MouseEvent):void{
			var x:Number = mapContent.getCenterX();
			var y:Number = mapContent.getCenterY();
			var level:Number = mapContent.getLevelIndex();
			var aa:Number=UIScale.a;
		    var bb:Number=UIScale.b;
			var lon:Number = x-0.5*aa/50;
			var lat:Number = y;
		 	mapContent.centerMapAt(lon,lat);	
			mapContent.refresh();
			historyWrite();
		}
		//使地图向上移动
		private function upOneLevel(event:MouseEvent):void{
			var x:Number = mapContent.getCenterX();
			var y:Number = mapContent.getCenterY();
			var level:Number = mapContent.getLevelIndex();
			var aa:Number=UIScale.a;
			var lon:Number = x;
			var lat:Number = y-0.5*aa/50;
		 	mapContent.centerMapAt(lon,lat);	
			mapContent.refresh();
			historyWrite();	
		}
		// 功能:全图
		private function allMapOneLevel(event:MouseEvent):void {
			var lon:Number = 85.12042892578124;
			var lat:Number = 45.4533983265625;			
			mapContent.centerMapAt(lon,lat);
			mapContent.setLevelIndex(0);
			var levelmax:int=mapConfig.getMapLevelLength();	
//			timeimage.move(timeimage.x,100+levelmax*10-(level+1)*10);
			var t:Image =getChildByName("imdowncur") as Image;
			t.move(t.x,90+levelmax*10);
			mapContent.setMapPanEvent(); // 将地图设置为移动状态
			mapContent.refresh();
			historyWrite();
		}
		/***************************************************************/
		//确认地图点击的范围，以便调用对应的功能方法
		// 向左移动点击改变的范围
		public function getMoveLeft():Array {
			var array:Array = new Array();
			var x1:int = -22;
			var y1:int = 9;
			var x2:int = -7;
			var y2:int = 24;
			array[array.length] = x1;
			array[array.length] = y1;
			array[array.length] = x2;
			array[array.length] = y2;		
			return array;
		}
		// 向下移动
		public function getMoveDown():Array {
			var array:Array = new Array();
			var x1:int = -3;
			var y1:int = 28;
			var x2:int = 13;
			var y2:int = 42;
			array[array.length] = x1;
			array[array.length] = y1;
			array[array.length] = x2;
			array[array.length] = y2;
			return array;
		}
		// 向右移动
		public function getMoveRight():Array {
			var array:Array = new Array();
			var x1:int = 17;
			var y1:int = 9;
			var x2:int = 30;
			var y2:int = 24;
			array[array.length] = x1;
			array[array.length] = y1;
			array[array.length] = x2;
			array[array.length] = y2;
			return array;
		}
		// 向左移动
		public function getMoveUp():Array {
			var array:Array = new Array();
			var x1:int = -3;
			var y1:int = -10;
			var x2:int = 13;
			var y2:int = 4;
			array[array.length] = x1;
			array[array.length] = y1;
			array[array.length] = x2;
			array[array.length] = y2;
			return array;
		}
		// 全图
		public function getMoveAllMap():Array {
			var array:Array = new Array();
			var x1:int = -3;
			var y1:int = 9;
			var x2:int = 13;
			var y2:int = 24;
			array[array.length] = x1;
			array[array.length] = y1;
			array[array.length] = x2;
			array[array.length] = y2;
			return array;
		}
		//测试
		public function getMoveMap():Array {
			var array:Array = new Array();
			var x1:int = -3;
			var y1:int = 9;
			var x2:int = 130;
			var y2:int = 240;
			array[array.length] = x1;
			array[array.length] = y1;
			array[array.length] = x2;
			array[array.length] = y2;
			return array;
		}
		
		/*****************************************************************************************************/
//		画地图显示级别的滚动条
		private function drawBlock(level:int):void {
			var rect:Array = getLevelBlockRect(level);
			var lx:int = lineWidth * 2;
			var ly:int = lineWidth * 2;
			var cx:int = (rect[0] + rect[2]) / 2;
			var cy:int = (rect[1] + rect[3]) / 2;
			drawFillRect(rect[0] + lx,rect[1] + ly,rect[2] - lx,rect[3] - ly);
			drawLine(rect[0] + lx * 2,cy,rect[2] - lx * 2,cy);
			barx=rect[0] + lx * 2;
			bary=cy;
		}
		private function drawLevelText(level:int):void {
			var rect:Array = getLevelBlockRect(level);
			var lx:int = lineWidth * 2;
			var ly:int = lineWidth * 2;
			var cx:int = (rect[0] + rect[2]) / 2;
			var cy:int = (rect[1] + rect[3]) / 2;
			drawText(cx - 23,cy+10 ,""+(level+1));
		}
		private function drawCenter():void {
			var rect:Array = getLevelCenterRect();
			return drawFillRectEx(rect);
		}
	
		private function drawLevel():void {
			var maxLevel:int = mapConfig.getMapLevelLength();
			for(var i:int=0;i<maxLevel;i++) {
				var rect:Array = getLevelRect(i);
				drawFillRectEx(rect);
			}
		}
	
		private function checkZoomIn(curX:int,curY:int):Boolean {
			var rect:Array = getZoomInRect();
			return checkRect(curX,curY,rect);
		}
		
		private function drawZoomIn():void {
			var rect:Array = getZoomInRect();
			drawFillRectEx(rect);
			var len:int = lineWidth * 3;
			var cx:int = (rect[0] + rect[2]) / 2;
			var cy:int = (rect[1] + rect[3]) / 2;
			drawLine(cx,cy - len,cx,cy + len);
			drawLine(cx - len,cy,cx + len,cy);
		}
	
		private function checkZoomOut(curX:int,curY:int):Boolean {
			var rect:Array = getZoomOutRect();
			return checkRect(curX,curY,rect);
		}
		
		private function drawZoomOut():void {
			var rect:Array = getZoomOutRect();
			drawFillRectEx(rect);
			var len:int = lineWidth * 3;
			var cx:int = (rect[0] + rect[2]) / 2;
			var cy:int = (rect[1] + rect[3]) / 2;
			drawLine(cx - len,cy,cx + len,cy);
		}
		
		private function getLevelWidth():int {
			var maxLevel:int = mapConfig.getMapLevelLength();
			var levelWidth:int = stepX * (maxLevel - 1) + startX ;
			return levelWidth;
		}
		
		private function getLevelHeight():int {
			var maxLevel:int = mapConfig.getMapLevelLength();
			var levelHeight:int = stepY * (maxLevel - 1);
			return levelHeight;
		}
		
		public function getAllLevelMaxRect():Array {
			var levelWidth:int = getLevelWidth();
			var levelHeight:int = getLevelHeight();
			var lx:int = (startX + stepX * getMaxLevel()) / 2 + 3;
			var ret:Array = new Array();
			ret[ret.length] = levelWidth / 2 - lx;
			ret[ret.length] = startY - stepY / 2+30;
			ret[ret.length] = levelWidth / 2 + lx+20;
			ret[ret.length] = startY + levelHeight + stepY / 2+30;
			return ret;
		}
		
		public function getLevelMaxRect(level:int):Array {
			var levelWidth:int = getLevelWidth();
			var levelHeight:int = getLevelHeight();
			var lx:int = (startX + stepX * level) / 2;
			var ly:int = stepY * level;
			var ret:Array = new Array();
			ret[ret.length] = levelWidth / 2 - lx;
			ret[ret.length] = startY + levelHeight - ly - stepY / 2+30;
			ret[ret.length] = levelWidth / 2 + lx+20;
			ret[ret.length] = startY + levelHeight - ly + stepY / 2+30;
			return ret;
		}
		
		public function get3DButtonRect():Array {
			var levelWidth:int = getLevelWidth();
			var levelHeight:int = getLevelHeight();
			var cx:int = levelWidth / 2;
			var cy:int = startY - 45;
			var ret:Array = new Array();
			ret[ret.length] = cx - boxLen;
			ret[ret.length] = cy - boxLen;
			ret[ret.length] = cx + boxLen;
			ret[ret.length] = cy + boxLen;
			return ret;
		}
		//缩小的按钮功能，确认按钮点击的范围
		public function getZoomInRect():Array {
			var levelWidth:int = getLevelWidth();
			var levelHeight:int = getLevelHeight();
			var cx:int = levelWidth / 2;
			var cy:int = startY + 15;
			var ret:Array = new Array();
			ret[ret.length] = cx - boxLen;
			ret[ret.length] = cy - boxLen;
			ret[ret.length] = cx + boxLen;
			ret[ret.length] = cy + boxLen;
			return ret;
		}
		//点击后确定扩大的范围
		public function getZoomOutRect():Array {
			var levelWidth:int = getLevelWidth();
			var levelHeight:int = getLevelHeight();
			var cx:int = levelWidth / 2;
			var cy:int = startY + levelHeight + 45;
			var ret:Array = new Array();
			ret[ret.length] = cx - boxLen;
			ret[ret.length] = cy - boxLen;
			ret[ret.length] = cx + boxLen;
			ret[ret.length] = cy + boxLen;
			return ret;
		}
		
		private function getLevelCenterRect():Array {
			var levelWidth:int = getLevelWidth();
			var levelHeight:int = getLevelHeight();
			var ret:Array = new Array();
			ret[ret.length] = levelWidth / 2 - lineWidth;
			ret[ret.length] = startY - stepY / 2+30;
			ret[ret.length] = levelWidth / 2 + lineWidth+20;
			ret[ret.length] = startY + levelHeight + stepY / 2+30;
			return ret;
		}
	
		private function checkLevel(curX:int,curY:int):int {
			var maxLevel:int = mapConfig.getMapLevelLength();
			for(var i:int=0;i<maxLevel;i++) {
				var rect:Array = getLevelBlockRect(i);
				if(checkRect(curX,curY,rect)) {
					return i;
				}
			}
			if(curY <= startY) {
				return maxLevel - 1;
			}
			return 0;
		}
		
		private function getLevelRect(level:int):Array {
			var levelWidth:int = getLevelWidth();
			var levelHeight:int = getLevelHeight();
			var lx:int = (startX + stepX * level) / 2;
			var ly:int = stepY * level-30;
			var ret:Array = new Array();
			ret[ret.length] = levelWidth / 2 - lx;
			ret[ret.length] = startY + levelHeight - ly - lineWidth;
			ret[ret.length] = levelWidth / 2 + lx+20;
			ret[ret.length] = startY + levelHeight - ly + lineWidth;
			return ret;
		}
		
		private function getLevelBlockRect(level:int):Array {
			var levelWidth:int = getLevelWidth();
			var levelHeight:int = getLevelHeight();
			var lx:int = startX + stepX * level;
			var ly:int = stepY * level-30;
			var ret:Array = new Array();
			ret[ret.length] = levelWidth / 2 - lx;
			ret[ret.length] = startY + levelHeight - ly - stepY / 2;
			ret[ret.length] = levelWidth / 2 + lx+20;
			ret[ret.length] = startY + levelHeight - ly + stepY / 2;
			return ret;
		}
		//画直线的方法
		private function drawLine(x1:int,y1:int,x2:int,y2:int):void {
			this.graphics.lineStyle(2,color);
			this.graphics.moveTo(x1,y1);
			this.graphics.lineTo(x2,y2);
		}
		//画方块的方法
		private function drawRect(x1:int,y1:int,x2:int,y2:int):void {
			var x:int = x1 > x2 ? x2 : x1;
			var y:int = y1 > y2 ? y2 : y1;
			var width:int = x1 > x2 ? x1 - x2 : x2 - x1;
			var height:int = y1 > y2 ? y1 - y2 : y2 - y1;
			graphics.lineStyle(1,color);
			graphics.drawRect(x,y,width,height);
		}
		//画方块的方法
		private function drawFillRect(x1:int,y1:int,x2:int,y2:int):void {
			var x:int = x1 > x2 ? x2 : x1;
			var y:int = y1 > y2 ? y2 : y1;
			var width:int = x1 > x2 ? x1 - x2 : x2 - x1;
			var height:int = y1 > y2 ? y1 - y2 : y2 - y1;
			graphics.lineStyle(1,0,0.2);
			graphics.beginFill(fillColor,0.3);
			graphics.drawRoundRectComplex(x,y,width,height,3,3,3,3);
			graphics.endFill();			
		}
		/****************************************************************************/
		//画圆圈的方法
		private function drawFillCirclea(x:int,y:int,z:int):void {
			var x:int = x;
			var y:int = y;
			var radius:int =z;			
			graphics.lineStyle(1,color);
			graphics.drawCircle(x,y,radius);
			graphics.endFill();
			
		}	
		//画圆圈的方法
		private function drawFillCircle(x:int,y:int,z:int):void {
			var x:int = x;
			var y:int = y;
			var radius:int =z;
			graphics.lineStyle(1,color);
			graphics.beginFill(fillCircleAllColor);
			graphics.drawCircle(x,y,radius);
			graphics.endFill();
			
		}
		private function drawFillCircleS(x:int,y:int,z:int):void {
			var x:int = x;
			var y:int = y;
			var radius:int =z;			
			graphics.lineStyle(1,color);
			graphics.beginFill(fillCircleAllColorS);
			graphics.drawCircle(x,y,radius);
			graphics.endFill();			
		}
		//画圆圈的方法
		private function drawCircle(x:int,y:int,z:int):void {
			var x:int = x;
			var y:int = y;
			var z:int = z;		
			graphics.lineStyle(1,color);
			graphics.drawCircle(x,y,z);
		}
					
		//画圆的方法
		private function drawFillCircleExa(rect:Array):void{
			drawFillCirclea(rect[0],rect[1],rect[2]);
		}
		//调用画圆的方法
		private function drawFillCircleEx(rect:Array):void{
			drawFillCircle(rect[0],rect[1],rect[2]);
		}
		private function drawFillCircleExS(rect:Array):void{
			drawFillCircleS(rect[0],rect[1],rect[2]);
		}
		
		private function drawText(x:int,y:int,text:String):void {
			var drawUtil:DrawUtil = new DrawUtil(graphics);
			var fontName:String = "黑体";
			var fontSize:int = 12;
			var color:int = drawUtil.getYellow();
			var backColor:int = drawUtil.getWhite();
			var backOutlineColor:int = drawUtil.getBlack();
			var textLeft:int = x;
			var textTop:int = y;
	     	var textStr:String = text;
	     	var textWidth:int = textStr.length * 12;
	     	var textHeight:int = 12;
			graphics.lineStyle(1,color);
			var fromX:int = 0;
			var fromY:int = 0;
			var toX:int = textStr.length * 12;
			var toY:int = 12;
			var uit:UITextField = new UITextField();
			uit.setColor(color);
			uit.text = textStr;
			uit.autoSize = TextFieldAutoSize.LEFT;
			var textBitmapData:BitmapData = ImageSnapshot.captureBitmapData(uit);
			var sizeMatrix:Matrix = new Matrix();
			var coef:Number = Math.min(uit.measuredWidth/textBitmapData.width,uit.measuredHeight/textBitmapData.height);
			sizeMatrix.a = coef;
			sizeMatrix.d = coef;
			textBitmapData = ImageSnapshot.captureBitmapData(uit,sizeMatrix);
			textWidth = uit.measuredWidth;
			textHeight = uit.measuredHeight;			
			// draw background
	     	graphics.beginFill(backColor);
	     	graphics.lineStyle(1,backOutlineColor);
	     	graphics.drawRect(textLeft,textTop,textWidth,textHeight);
			graphics.endFill();
	     	// draw text
	     	graphics.lineStyle(0,color,0);
			var sm:Matrix = new Matrix();
			sm.tx = textLeft + 1;
			sm.ty = textTop;
			graphics.beginBitmapFill(textBitmapData,sm,false);
			graphics.drawRect(textLeft,textTop,textWidth,textHeight);
			graphics.endFill();
		}
		
		private function drawTextWithoutBack(x:int,y:int,text:String):void {
			var drawUtil:DrawUtil = new DrawUtil(graphics);
			var fontName:String = "黑体";
			var fontSize:int = 12;
			var color:int = drawUtil.getYellow();
			var textLeft:int = x;
			var textTop:int = y;
	     	var textStr:String = text;
	     	var textWidth:int = textStr.length * 12;
	     	var textHeight:int = 12;
			graphics.lineStyle(1,color);
			var fromX:int = 0;
			var fromY:int = 0;
			var toX:int = textStr.length * 12;
			var toY:int = 12;
			var uit:UITextField = new UITextField();
			uit.setColor(color);
			uit.text = textStr;
			uit.autoSize = TextFieldAutoSize.LEFT;
			var textBitmapData:BitmapData = ImageSnapshot.captureBitmapData(uit);
			var sizeMatrix:Matrix = new Matrix();
			var coef:Number = Math.min(uit.measuredWidth/textBitmapData.width,uit.measuredHeight/textBitmapData.height);
			sizeMatrix.a = coef;
			sizeMatrix.d = coef;
			textBitmapData = ImageSnapshot.captureBitmapData(uit,sizeMatrix);
			textWidth = uit.measuredWidth;
			textHeight = uit.measuredHeight;			
	     	// draw text
	     	graphics.lineStyle(0,color,0);
			var sm:Matrix = new Matrix();
			sm.tx = textLeft + 1;
			sm.ty = textTop;
			graphics.beginBitmapFill(textBitmapData,sm,false);
			graphics.drawRect(textLeft,textTop,textWidth,textHeight);
			graphics.endFill();
		}
		//传入画方块的四个参数
		private function drawFillRectEx(rect:Array):void{
			drawFillRect(rect[0],rect[1],rect[2],rect[3]);
		}
		
		private function checkRect(x:int,y:int,rect:Array):Boolean {
			if(rect[0] <= x && rect[2] >= x && rect[1] <= y && rect[3] >= y) {
				return true;
			}
			return false;
		}
		//确定按钮点击的范围，返回可以调用的方法
		private function checkClickButton() : int {
			var rect:Array;
			//在缩小的范围内
			rect = getZoomInRect();
			if(checkRectAry(rect)) {
				return 1;
			}
			//在扩大的范围内
			rect = getZoomOutRect();
			if(checkRectAry(rect)) {
				return 2;
			}
			//向左移动范围
			rect = getMoveLeft();
			if(checkRectAry(rect)){
				return 4;
			}
			//向下移动
			rect = getMoveDown();
			if(checkRectAry(rect)){
				return 5;
			}
			//向右移动
			rect = getMoveRight();
			if(checkRectAry(rect)){
				return 6;
			}
			//向上移动
			rect = getMoveUp();
			if(checkRectAry(rect)){
				return 7;
			}
			//全图范围内，
			rect = getMoveAllMap();
			if(checkRectAry(rect)){
				return 8;
			}
			rect = getMoveMap();
			if(checkRectAry(rect)){
				return 9;
			}
			return -1;
		}
		
		private function checkClickLevel() : int {
			for(var i:int=0;i<getMaxLevel();i++) {
				var ret:Boolean = checkRectAry(getLevelMaxRect(i));
				if(ret) {
					return i;
				}
			}
			var rect:Array = getAllLevelMaxRect();
			var d1:int = Math.abs(curY-rect[1]);
			var d2:int = Math.abs(curY-rect[3]);
			if(d1 <= d2) {
				return getMaxLevel() - 1;
			} else {
				return 0;
			}
		}
//		鼠标点击的范围，返回鼠标点击的位置是否在指定的区域内
		private function checkRectAry(rect:Array):Boolean {
			if(rect[0] <= curX && rect[2] >= curX && rect[1] <= curY && rect[3] >= curY) {
				return true;
			}
			return false;
		}
		// 只检查纵轴是否符合
		private function checkRectAryEx(rect:Array):Boolean {
			if(rect[1] <= curY && rect[3] >= curY) {
				return true;0
			}
			return false;
		}
//	 把rgb的颜色装换成Int型 ，返回Int型。
		private function rgbToInt(r:int, g:int, b:int):int {			
			return r << 16 | g << 8 | b << 0;			
		}
		
		private function drawCenterFill():void {
			var rect:Array = getLevelCenterRect();
			return drawFillRectExFill(rect);
		}
		
		private function drawFillRectExFill(rect:Array):void{
			drawFillRectFill(rect[0]-12,rect[1]-20,rect[2]+14,rect[3]+23);
		}
		//画方块的方法
		private function drawFillRectFill(x1:int,y1:int,x2:int,y2:int):void {
			var x:int = x1 > x2 ? x2 : x1;
			var y:int = y1 > y2 ? y2 : y1;
			var width:int = x1 > x2 ? x1 - x2 : x2 - x1;
			var height:int = y1 > y2 ? y1 - y2 : y2 - y1;
			graphics.lineStyle(1,color,_staticalpha);
			graphics.beginFill(0,alpha);
			graphics.drawRoundRectComplex(x,y,width,height,3,3,3,3);
			graphics.endFill();
			}
			
		private function drawLevelFill():void {
			var maxLevel:int = mapConfig.getMapLevelLength();
			for(var i:int=0;i<maxLevel;i++) {
				var rect:Array = getLevelRect(i);
				drawFillRectExFillMark(rect);
			}
	       }
	       
		private function drawFillRectExFillMark(rect:Array):void{
			drawFillRect(rect[0]-3,rect[1],rect[2]-7,rect[3]);
            }
            
        private function drawCenterEx():void {
			var rect:Array = getLevelCenterRect();
			return drawFillRectExFillEx(rect);
		}
		
		private function drawFillRectExFillEx(rect:Array):void{
			drawFillRect(rect[0]+7,rect[1],rect[2]+7,rect[3]);
		}
		
		private function drawCircleExFill(level:int):void {
			var rect:Array = getLevelBlockRect(level);
			var lx:int = lineWidth * 2;
			var ly:int = lineWidth * 2;
			var cx:int = (rect[0] + rect[2]) / 2;
			var cy:int = (rect[1] + rect[3]) / 2;
			drawCircleExFillMark(rect[0] + lx+16.5,rect[1] + ly+3,5);
			barx=rect[0] + lx * 2;
			bary=cy;
		}
		
		//画圆圈的方法
		private function drawCircleExFillMark(x:int,y:int,z:int):void {
			var x:int = x;
			var y:int = y;
			var z:int = z;
			cursorx=x;
			cursory=y;
			graphics.lineStyle(1,color,10);
			graphics.beginFill(fillColor,10);
			graphics.drawCircle(x,y,z);
		}
	}
}