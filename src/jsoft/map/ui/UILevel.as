package jsoft.map.ui
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	
	import jsoft.map.animate.SpeedCoolDown;
	import jsoft.map.config.MapConfig;
	import jsoft.map.content.MapContent;
	import jsoft.map.util.DrawUtil;
	
	import mx.controls.Image;
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.graphics.ImageSnapshot;
	

	public class UILevel extends UIComponent
	{
		private var mapConfig:MapConfig;
		private var mapContent:MapContent;
		private var startX:int = 10;
		private var startY:int = 84;
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

		public static var isAspect:Boolean=false;

		[Embed(source="../cursor/d_aspect.png")]
		public static var d_aspect:Class;//圆图片
		[Embed(source="../cursor/d_map.png")]
		public static var d_map:Class;//全图图片
		[Embed(source="../cursor/d_level.png")]
		public static var d_level:Class;//刻度图片
		[Embed(source="../cursor/d_block.png")]
		public static var d_block:Class;//刻度针图片
		[Embed(source="../cursor/d_down.png")]
		public static var d_down:Class;//向上图片
		[Embed(source="../cursor/d_up.png")]
		public static var d_up:Class;//向下图片
		[Embed(source="../cursor/d_left.png")]
		public static var d_left:Class;//向左图片
		[Embed(source="../cursor/d_right.png")]
		public static var d_right:Class;//向右图片
		[Embed(source="../cursor/d_min.png")]
		public static var d_min:Class;//缩小图片
		[Embed(source="../cursor/d_out.png")]
		public static var d_out:Class;//放大图片
	
		public function UILevel() {
		}
		//确定鼠标按下
		public function isMouseDown():Boolean {
			if(mouseFlag) {
				mouseFlag = false;
				return true;
			}
			if(clickButton > 0) {
				clickButton = -1;
				return true;
			}
			return mouseDown || clickButton > 0;
		}
		//设置鼠标状态
		public function setMouseDown(flag:Boolean=true):void {
			mouseFlag=flag;
		}
		//初始化事件
		private function initEvent():void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			//stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			mapContent = AppContext.getMapContext().getMapContent();
		}
		//鼠标按下事件
		private function onMouseDown(event:MouseEvent):void {
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
			curX = event.stageX - this.x;
			curY = event.stageY - this.y;
			var ret:Boolean = checkRectAry(getAllLevelMaxRect());
			clickButton = -1;

			if(ret) {
				clickLevel = checkClickLevel();
				show(clickLevel);
				//currentLevel=AppContext.getMapContext().getMapContent().getLevelIndex();
				//drawblockbar(clickLevel);
				drawLevelText(clickLevel);
				mapContent.showZoomMap(clickLevel);
				mouseDown = true;
			}
			clickButton  = checkClickButton();
			var currentLevel:int=0;
			var t:Image;
			switch(clickButton){
				case 1:
					currentLevel=AppContext.getMapContext().getMapContent().getLevelIndex();
					var maxLevel:int = getMaxLevel();
					if(currentLevel < maxLevel-1){
						t = getChildByName("d_block") as Image;
						t.move(t.x,t.y-10);
						zoomInOneLevel();
					}
					break;
				case 2:
					currentLevel=AppContext.getMapContext().getMapContent().getLevelIndex();
					if(currentLevel > 0){
						t = getChildByName("d_block") as Image;
						t.move(t.x,t.y+10);
						zoomOutOneLevel();
					}
					break;
				case 3://向左平移
					moveMap(10,0);
					break;
				case 4://向右平移
					moveMap(-10,0);
					break;
				case 5://向上平移
					moveMap(0,10);
					break;
				case 6://向下平移
					moveMap(0,-10);
					break;
				case 7://全图
					allMap();
					break;
			}
		}
		//移动事件
		private function onMouseMove(event:MouseEvent):void {
			if(!mouseDown) {
				return;
			}
			curX = event.stageX - this.x;
			curY = event.stageY - this.y;
			clickLevel = checkClickLevel();
				
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
		//鼠标离开舞台事件
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
		//获取配置文件
		public function getMapConfig():MapConfig {
			return mapConfig;
		}
		//设置配置文件
		public function setMapConfig(mapConfig:MapConfig):void {
			this.mapConfig = mapConfig;
			initLevelObject();
		}
 		//初始化所有对象
		private function initLevelObject():void {
			var levelWidth:int = getLevelWidth();
			var levelHeight:int = getLevelHeight();
			this.width = levelWidth + 1;
			this.height = levelHeight + 1;
			//以上好像没有用处s
			initEvent();
		}
		//获取最大级数
		public function getMaxLevel() : int {
			var maxLevel:int = mapConfig.getMapLevelLength();
			return maxLevel;
		}
		//刷新
		public function refresh():void {
			var currentLevel:int=AppContext.getMapContext().getMapContent().getLevelIndex();
			show(currentLevel);
		}
		//显示
		public function show(currentLevel:int):void {
			if(currentLevel < 0) {
				currentLevel = 0;
			}
			if(currentLevel >= getMaxLevel()) {
				currentLevel = getMaxLevel()-1;
			}
			graphics.clear();
			if(!isAspect){
				drawAspect();//绘制圆形
				drawLevelBar();//绘制刻度条
				isAspect=true;							
			}
			moveBlock(currentLevel);//移动刻度针
			mapContent.refresh();
			
		}
		/***************加入上、下、左、右、全图、放大、缩小各种图片****************/
		//绘制上、下、左、右、全图
		private function drawAspect():void {
			drawAspect_Image();//圆形背景
			drawUp_Image();//向上图片
			drawDown_Image();//向下图片
			drawLeft_Image();//向左图片
			drawRight_Image();//向右图片
			drawMap_Image();//全图图片
		}
		//绘制刻度条
		private function drawLevelBar():void{
			drawOut_Image();//放大图片
			drawLevels_Image();//刻度图片
			drawMin_Image();//缩小图片
			drawblock_Image();//刻度针图片
		}
		//圆形背景
		private function drawAspect_Image():void{
			var aspect_Image:Image = new Image();
			aspect_Image.name = "d_aspect";
			aspect_Image.x = startX - this.x;
			aspect_Image.y = startX - this.x;
			aspect_Image.alpha = 0.5;
			aspect_Image.width = 100;
			aspect_Image.height = 100;
			aspect_Image.source = d_aspect;
			aspect_Image.buttonMode = true;
			
			addChild(aspect_Image);
			//注册事件
		}
		//向上图片
		private function drawUp_Image():void{
			var up_Image:Image = new Image();
			up_Image.name = "d_up";
			up_Image.x = -13;
			up_Image.y = -22;
			up_Image.alpha = 0.5;
			up_Image.width = 45;
			up_Image.height = 23;
			up_Image.source = d_up;
			up_Image.buttonMode = true;
			
			addChild(up_Image);
			up_Image.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			up_Image.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		//向下图片
		private function drawDown_Image():void{
			var down_Image:Image = new Image();
			down_Image.name = "d_down";
			down_Image.x = -13;
			down_Image.y = 21;
			down_Image.alpha = 0.5;
			down_Image.width = 45;
			down_Image.height = 23;
			down_Image.source = d_down;
			down_Image.buttonMode = true;
			
			addChild(down_Image);
			down_Image.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			down_Image.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		//向左图片
		private function drawLeft_Image():void{
			var left_Image:Image = new Image();
			left_Image.name = "d_left";
			left_Image.x = -23;
			left_Image.y = -13;
			left_Image.alpha = 0.5;
			left_Image.width = 22;
			left_Image.height = 48;
			left_Image.source = d_left;
			left_Image.buttonMode = true;
			
			addChild(left_Image);
			left_Image.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			left_Image.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		//向右图片
		private function drawRight_Image():void{
			var right_Image:Image = new Image();
			right_Image.name = "d_right";
			right_Image.x = 19;
			right_Image.y = -13;
			right_Image.alpha = 0.5;
			right_Image.width = 22;
			right_Image.height = 48;
			right_Image.source = d_right;
			right_Image.buttonMode = true;
			
			addChild(right_Image);
			right_Image.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			right_Image.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		//全图图片
		private function drawMap_Image():void{
			var map_Image:Image = new Image();
			map_Image.name = "d_map";
			map_Image.x = -10;
			map_Image.y = -9;
			map_Image.alpha = 0.5;
			map_Image.width = 40;
			map_Image.height = 40;
			map_Image.source = d_map;
			map_Image.buttonMode = true;
			
			addChild(map_Image);
			map_Image.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			map_Image.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		//放大图片
		private function drawOut_Image():void{
			var out_Image:Image = new Image();
			out_Image.name = "d_out";
			//out_Image.x = -2 + stepX;
			out_Image.x = startX - 23 * 0.5;
			out_Image.y = startY - 24;//y=60
			out_Image.alpha = 0.5;
			out_Image.width = 23;
			out_Image.height = 24;
			out_Image.source = d_out;
			out_Image.buttonMode = true;
			
			addChild(out_Image);
			out_Image.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			out_Image.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);
		}
		//刻度图片
		private function drawLevels_Image():void{
			var maxLevel:int = getMaxLevel();
			for(var i:int=0;i<maxLevel;i++){
				var level_Image:Image = new Image();
				level_Image.name = "d_level";
				//level_Image.x = -2 + stepX;
				level_Image.x = startX - 23 * 0.5;
				level_Image.y = startY + i * stepY;//y=84
				level_Image.alpha = 0.5;
				level_Image.width = 23;
				level_Image.height = 10;
				level_Image.source = d_level;
				level_Image.buttonMode = true;
				
				addChild(level_Image);
				//注册事件
			}
		}
		//缩小图片
		private function drawMin_Image():void{
			var maxLevel:int = getMaxLevel();
			var min_Image:Image = new Image();
			min_Image.name = "d_min";
			//min_Image.x = -2 + stepX;
			min_Image.x = startX - 23 * 0.5;
			min_Image.y = startY + maxLevel * stepY;//startY=84
			min_Image.alpha = 0.5;
			min_Image.width = 23;
			min_Image.height = 24;
			min_Image.source = d_min;
			min_Image.buttonMode = true;
			
			addChild(min_Image);
			min_Image.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
			min_Image.addEventListener(MouseEvent.MOUSE_OUT,onMouseOut);	
		}
		//刻度针图片
		private function drawblock_Image():void{
			var maxLevel:int = getMaxLevel();
			var block_Image:Image = new Image();
			block_Image.name = "d_block";
			//block_Image.x = 3 + stepX;
			block_Image.x = startX - 20 * 0.5 + 4;
			block_Image.y = startY + (maxLevel-1) * stepY - 3;//startY=84
			block_Image.alpha = 0.5;
			block_Image.width = 20;
			block_Image.height = 20;
			block_Image.source = d_block;
			block_Image.buttonMode = true;
			
			addChild(block_Image);
			//注册事件	
		}
		//移动刻度针
		private function moveBlock(level:int):void{
			var maxLevel:int = getMaxLevel();
			var currentImage:Image =getChildByName("d_block") as Image;    	
			currentImage.move(currentImage.x,startY+(maxLevel-level-1)*stepY-3);
		}
		/******************获取各种范围区域*************************/
		//获取总刻度条的最大范围
		public function getAllLevelMaxRect():Array {
			var outImage:Image = getChildByName("d_out") as Image; 
			var levelWidth:int = outImage.width;
			var levelHeight:int = getMaxLevel() * stepY;
			var ret:Array = new Array();
			ret[ret.length] = startX - levelWidth * 0.5;
			ret[ret.length] = startY;
			ret[ret.length] = startX + levelWidth * 0.5;
			ret[ret.length] = startY + levelHeight;
			return ret;
		}
		//鼠标点击的范围，返回鼠标点击的位置是否在指定的区域内
		private function checkRectAry(rect:Array):Boolean {
			if(rect[0] <= curX && rect[2] >= curX && rect[1] <= curY && rect[3] >= curY) {
				return true;
			}
			return false;
		}
		//检查点击级别
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
		//获取单个级别条的最大范围
		public function getLevelMaxRect(level:int):Array {
			var outImage:Image = getChildByName("d_out") as Image; 
			var levelWidth:int = outImage.width;
			var levelHeight:int = getLevelHeight();
			var ret:Array = new Array();
			ret[ret.length] = startX - levelWidth * 0.5;
			ret[ret.length] = startY + levelHeight - level * stepY;
			ret[ret.length] = startX + levelWidth * 0.5;
			ret[ret.length] = startY + levelHeight - level * stepY + stepY;
			return ret;
		}
		//缩小的按钮功能，确认按钮点击的范围
		public function getZoomInRect():Array {
			var cx:int = startX;
			var cy:int = startY - 12;
			var ret:Array = new Array();
			ret[ret.length] = cx - boxLen;
			ret[ret.length] = cy - boxLen;
			ret[ret.length] = cx + boxLen;
			ret[ret.length] = cy + boxLen;
			return ret;
		}
		//点击后确定放大的范围
		public function getZoomOutRect():Array {
			var maxLevel:int = getMaxLevel();
			var cx:int = startX;
			var cy:int = startY + maxLevel * stepY + 12;
			var ret:Array = new Array();
			ret[ret.length] = cx - boxLen;
			ret[ret.length] = cy - boxLen;
			ret[ret.length] = cx + boxLen;
			ret[ret.length] = cy + boxLen;
			return ret;
		}
		// 向左移动范围
		public function getLeftRect():Array {
			var x1:int = -23;
			var y1:int = -13;
			var x2:int = -1;
			var y2:int = 35;
			var ret:Array = new Array();
			ret[ret.length] = x1;
			ret[ret.length] = y1;
			ret[ret.length] = x2;
			ret[ret.length] = y2;
			return ret;
		}
		// 向右移动范围
		public function getRightRect():Array {
			var x1:int = 19;
			var y1:int = -13;
			var x2:int = 41;
			var y2:int = 35;
			var ret:Array = new Array();
			ret[ret.length] = x1;
			ret[ret.length] = y1;
			ret[ret.length] = x2;
			ret[ret.length] = y2;
			return ret;
		}
		//向上移动范围
		public function getUpRect():Array{
			var x1:int = -13;
			var y1:int = -22;
			var x2:int = 32;
			var y2:int = 1;
			var ret:Array = new Array();
			ret[ret.length] = x1;
			ret[ret.length] = y1;
			ret[ret.length] = x2;
			ret[ret.length] = y2;
			return ret;
		}
		//向下称动范围
		public function getDownRect():Array{
			var x1:int = -13;
			var y1:int = 21;
			var x2:int = 32;
			var y2:int = 44;
			var ret:Array = new Array();
			ret[ret.length] = x1;
			ret[ret.length] = y1;
			ret[ret.length] = x2;
			ret[ret.length] = y2;
			return ret;
		}
		//全图
		public function getMapRect():Array{
			var x1:int = -10;
			var y1:int = -9;
			var x2:int = 30;
			var y2:int = 31;
			var ret:Array = new Array();
			ret[ret.length] = x1;
			ret[ret.length] = y1;
			ret[ret.length] = x2;
			ret[ret.length] = y2;
			return ret;
		}
		//绘制文字
		private function drawLevelText(level:int):void {
			var rect:Array = getLevelBlockRect(level);
			//var lx:int = lineWidth * 2;
			//var ly:int = lineWidth * 2;
			var cx:int = (rect[0] + rect[2]) / 2;
			var cy:int = (rect[1] + rect[3]) / 2;
			drawText(cx - 23,cy-10,""+(level+1));
		}
		//获取刻度针范围
		private function getLevelBlockRect(level:int):Array {
			var blockImage:Image = getChildByName("d_block") as Image; 
			var levelWidth:int = blockImage.width;
			var levelHeight:int = getLevelHeight();
			var ret:Array = new Array();
			ret[ret.length] = startX - levelWidth * 0.5;
			ret[ret.length] = startY + levelHeight - level * stepY;
			ret[ret.length] = startX + levelWidth * 0.5;
			ret[ret.length] = startY + levelHeight - level * stepY + stepY;
			return ret;
		}
		//写文字
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
			rect = getLeftRect();
			if(checkRectAry(rect)){
				return 3;
			}
			//向右移动
			rect = getRightRect();
			if(checkRectAry(rect)){
				return 4;
			}
			//向上移动
			rect = getUpRect();
			if(checkRectAry(rect)){
				return 5;
			}
			//向下移动
			rect = getDownRect();
			if(checkRectAry(rect)){
				return 6;
			}
			//全图
			rect = getMapRect();
			if(checkRectAry(rect)){
				return 7;
			}
			return -1;
		}
		/*******************放大、缩小、上、下、左、右、全图平移方法************************/
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
		//上、下、左、右平移方法
		private function moveMap(offsetX:Number,offsetY:Number):void {
			var speedX:Number = 0.5;
			var speedY:Number = 0.5;
			AppContext.getMapContext().getMapTipFactory().destory();//小江
			var speedCoolDown:SpeedCoolDown = new SpeedCoolDown(offsetX,offsetY,speedX,speedY);
			mapContent.setAnimate(speedCoolDown);
		}
		//全图
		private function allMap():void {
			var lon:Number = mapContent.getMapConfig().getMapLevel(0).getCoordinate().getCenterX();
			var lat:Number = mapContent.getMapConfig().getMapLevel(0).getCoordinate().getCenterY();
			mapContent.setCenter(lon,lat);
			mapContent.setLevelIndex(0);
			mapContent.showMap();
			mapContent.refresh();
			mapContent.setMapPanEvent();// 将地图设置为移动状态
		}
		
		//刻度条宽
		private function getLevelWidth():int {
			var maxLevel:int = mapConfig.getMapLevelLength();
			var levelWidth:int = stepX * (maxLevel - 1) + startX ;
			return levelWidth;
		}
		//刻度条高
		private function getLevelHeight():int {
			var maxLevel:int = mapConfig.getMapLevelLength();
			var levelHeight:int = stepY * (maxLevel - 1);
			return levelHeight;
		}
		//鼠标经过事件
		private function onMouseOver(event:MouseEvent):void{
			var ui:UIComponent = event.target as UIComponent;
			ui.alpha = 1;
		}
		//鼠标移出事件
		private function onMouseOut(event:MouseEvent):void{
			var ui:UIComponent = event.target as UIComponent;
			ui.alpha = 0.5;
		}
		
	}
}