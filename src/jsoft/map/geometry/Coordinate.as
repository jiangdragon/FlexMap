package jsoft.map.geometry
{
	public class Coordinate
	{
		private var screenWidth:int=0;
		private var screenHeight:int=0;
		private var box:Box;
		// x轴每度所占象素大小
		private var unitX:Number = -1;
		private var unitY:Number = -1;
		
		public function Coordinate() {
		}
		
		public function getUnitX():Number {
			if(unitX == -1) {
				unitX = screenWidth / box.getWidth();
			}
			return unitX;
		}
		
		public function getUnitY():Number {
			if(unitY == -1) {
				unitY = screenHeight / box.getHeight();
			}
			return unitY;
		}
		
		public function cloneCoord():Coordinate {
			var coord:Coordinate = new Coordinate();
			coord.screenWidth = screenWidth;
			coord.screenHeight = screenHeight;
			coord.box = box.getBox();
			return coord;
		}
		public function getScreenWidth() : int {
			return screenWidth;
		}
		public function setScreenWidth(width:int) : void {
			this.screenWidth = width;
			unitX = unitY = -1;
		}
		public function getScreenHeight() : int {
			return screenHeight;
		}
		public function setScreenHeight(height:int) : void {
			this.screenHeight = height;
			unitX = unitY = -1;
		}
		public function setScreen(width:int,height:int):void {
			this.screenWidth = width;
			this.screenHeight = height;
			unitX = unitY = -1;
		}
		public function getCenterX() : Number {
			return box.getCenterX();
		}
		public function getCenterY() : Number {
			return box.getCenterY();
		}
		public function setCenter(x:Number,y:Number) : void {
			var cx:Number = box.getCenterX();
			var cy:Number = box.getCenterY();
			var dx:Number = x - cx;
			var dy:Number = y - cy;
			var minx:Number = box.getMinx() + dx;
			var miny:Number = box.getMiny() + dy;
			var maxx:Number = box.getMaxx() + dx;
			var maxy:Number = box.getMaxy() + dy;
			box = new Box();
			box.setBox(minx,miny,maxx,maxy);
		}
		public function getMap() : Box {
			return box;
		}
		public function setMap(box:Box) : void {
			this.box = box;
			box.normalizeBox();
			unitX = unitY = -1;
		}
		public function setMapBound(minx:Number,miny:Number,maxx:Number,maxy:Number):void {
			box = new Box();
			box.setBox(minx,miny,maxx,maxy);
			box.normalizeBox();
			unitX = unitY = -1;
		}
		//屏幕坐标转换为地图坐标
		//参数 viewX为需要转换的x屏幕坐标 int
		//返回值：x地图坐标 double
		public function mapFromViewX(viewX:int):Number{
			var mapX:Number = viewX * 1.0 / screenWidth * box.getWidth() + box.getMinx();
			//AppContext.getAppUtil().alert(",mapFromViewX viewX=" + viewX + ",mapX="+mapX+ ",showDistanceX="+showDistanceX);
			return mapX;
		}
		//屏幕坐标转换为地图坐标
		//参数 viewY为需要转换的y屏幕坐标 int
		//返回值：y地图坐标 double
		public function mapFromViewY(viewY:int):Number{
			var mapY:Number = box.getMaxy() - viewY / screenHeight * box.getHeight();
			return mapY;
		}
		//屏幕坐标转换为地图坐标
		//参数 viewX为需要转换的x屏幕坐标 int
		//返回值：x地图坐标 double
		public function mapFromViewXAry(viewX:Array):Array{
			var ret:Array = new Array();
			for(var i:int=0;viewX!=null&&i<viewX.length;i++) {
				ret.push(mapFromViewX(viewX[i]));
			}
			return ret;
		}
		//屏幕坐标转换为地图坐标
		//参数 viewY为需要转换的y屏幕坐标 int
		//返回值：y地图坐标 double
		public function mapFromViewYAry(viewY:Array):Array{
			var ret:Array = new Array();
			for(var i:int=0;viewY!=null&&i<viewY.length;i++) {
				ret.push(mapFromViewY(viewY[i]));
			}
			return ret;
		}
		public function mapFromViewDX(distance:Number):Number{
			var mapMinx:Number = mapFromViewX(0);
			var mapMaxx:Number = mapFromViewX(distance);
			return mapMaxx - mapMinx;
		}
		public function mapFromViewDY(distance:Number):Number{
			var mapMiny:Number = mapFromViewY(distance);
			var mapMaxy:Number = mapFromViewY(0);
			return mapMaxy - mapMiny;
		}
		public function formatCoord(coord:Number) : Number {
//			var flag:Boolean = true;
//			var c:Number = coord;
//			if(coord < 0) {
//				flag = false;
//				c = -coord;
//			}
//			var newCoord:int = c * 1000000;
//			var ret:Number = newCoord * 1.0 / 1000000;
//			if(!flag) {
//				ret = -ret;
//			}
			var str:String = coord + "";
			if(str.length > 8) {
				str = str.substr(0,8);
			}
			var ret:Number = AppContext.getAppUtil().getNumber(str);
			return ret;
		}
		//地图坐标转换为屏幕坐标
		//参数 mapX为需要转换的x地图坐标 double
		//返回值：x屏幕坐标 int
		public function mapToViewX(mapX:Number):int{
			var viewX:int = (mapX - box.getMinx()) / box.getWidth() * screenWidth;
			return viewX;
		}
		//地图坐标转换为屏幕坐标
		//参数 mapY为需要转换的y地图坐标 double
		//返回值：y屏幕坐标 int
		public function mapToViewY(mapY:Number):int{
			var viewY:int = (box.getMaxy() - mapY) / box.getHeight() * screenHeight;
			return viewY;
		}
		//地图坐标转换为屏幕坐标
		//参数 mapX为需要转换的x地图坐标 double
		//返回值：x屏幕坐标 int
		public function mapToViewXAry(mapX:Array):Array{
			var ret:Array = new Array();
			for(var i:int=0;mapX!=null&&i<mapX.length;i++) {
				ret.push(mapToViewX(mapX[i]));
			}
			return ret;
		}
		//地图坐标转换为屏幕坐标
		//参数 mapY为需要转换的y地图坐标 double
		//返回值：y屏幕坐标 int
		public function mapToViewYAry(mapY:Array):Array{
			var ret:Array = new Array();
			for(var i:int=0;mapY!=null&&i<mapY.length;i++) {
				ret.push(mapToViewY(mapY[i]));
			}
			return ret;
		}
		//屏幕x坐标是否在屏幕内
		public function isInViewX(viewX:int):Boolean{
			return viewX>0&&viewX<screenWidth;
		}
		//屏幕x坐标是否在屏幕左边
		public function isInViewLeft(viewX:int):Boolean{
			return viewX<0;
		}
		//屏幕x坐标是否在屏幕右边
		public function isInViewRight(viewX:int):Boolean{
			return viewX>screenWidth;
		}
		//屏幕y坐标是否在屏幕内
		public function isInViewY(viewY:int):Boolean{
			return viewY>0&&viewY<screenHeight;
		}
		//屏幕y坐标是否在屏幕上边
		public function isInViewTop(viewY:int):Boolean{
			return viewY<0;
		}
		//屏幕y坐标是否在屏幕下边
		public function isInViewButtom(viewY:int):Boolean{
			return viewY>screenHeight;
		}
		//屏幕点是否在屏幕内
		public function isInView(viewX:int,viewY:int):Boolean{
			return isInViewX(viewX)&&isInViewY(viewY);
		}
		//两点距离是否大于指定值 在此认为当两点间的距离小于给定误差范围时是一个点.
		public function isInDistance(x1:Number,y1:Number,x2:Number,y2:Number,distance:Number):Boolean{
			var offsetX:Number = Math.abs(x1-x2);
			var offsetY:Number = Math.abs(y1-y2);
			var dis:Number = Math.sqrt(offsetX*offsetX+offsetY*offsetY);
			if(distance<=0){
				distance = 1;
			}
			return dis<distance;
		}
		public function getViewDistance(mapDistance:Number):Number {
			var distance:Number= mapDistance * 360 / (2 * Math.PI * 6378137.0);
			var mx1:Number = this.box.getMinx();
			var mx2:Number = mx1 + distance;
			var vx1:Number = this.mapToViewX(mx1);
			var vx2:Number = this.mapToViewX(mx2);
			//AppContext.getAppUtil().alert("mapDistance="+mapDistance+", distance="+distance+", vx1="+vx1+", vx2="+vx2);
			return Math.sqrt((vx1-vx2)*(vx1-vx2));
		}
		public function getTotalDistanceFromView(xArray:Array,yArray:Array):Number {
			if(xArray.length > 1) {
				var distance:Number=0.00;
				for(var i:int=1;i<xArray.length;i++) {
					var x1:int = xArray[i-1];
					var y1:int = yArray[i-1];
		      		var x2:int = xArray[i];
		      		var y2:int = yArray[i];
					distance += getDistanceFromView(x1,y1,x2,y2);
				}
				return distance;
			}
			return 0;
		}
		public function getTotalDistance(xArray:Array,yArray:Array):Number {
			if(xArray.length > 1) {
				var distance:Number=0.00;
				for(var i:int=1;i<xArray.length;i++) {
					var x1:Number = xArray[i-1];
					var y1:Number = yArray[i-1];
		      		var x2:Number = xArray[i];
		      		var y2:Number = yArray[i];
					distance += getDistance(x1,y1,x2,y2);
				}
				return distance;
			}
			return 0;
		}
		public function getDistanceFromView(x1:int,y1:int,x2:int,y2:int):Number {
			var mx1:Number = mapFromViewX(x1);
			var my1:Number = mapFromViewY(y1);
			var mx2:Number = mapFromViewX(x2);
			var my2:Number = mapFromViewY(y2);
			var mapOffsetX:Number = Math.abs(x1-x2);
			var mapOffsetY:Number = Math.abs(y1-y2);
			var distance:Number = Math.sqrt(mapOffsetX*mapOffsetX + mapOffsetY*mapOffsetY);
			if(checkCoord()) {
				distance = distance * 2 * Math.PI * 6378137.0 / 360;
			}
			return distance;
		}
		public function distanceToMapUnit(distance:Number):Number {
			if(checkCoord()) {
				distance = distance * 360 / (2 * Math.PI * 6378137.0);
			}
			return distance;
		}
		public function getDistance(x1:Number,y1:Number,x2:Number,y2:Number):Number {
			var mapOffsetX:Number = Math.abs(x1-x2);
			var mapOffsetY:Number = Math.abs(y1-y2);
			var distance:Number = Math.sqrt(mapOffsetX*mapOffsetX + mapOffsetY*mapOffsetY);
			if(checkCoord()) {
				distance = distance * 2 * Math.PI * 6378137.0 / 360;
			}
			return distance;
		}
		public function getDistanceEx(x:Number,y:Number,r:Number):Number {
			var rr:Number=r * 360 / (2 * Math.PI * 6378137.0);
			var x1:int=mapToViewX(x);
			var y1:int=mapToViewY(y);
			var x2:int=mapToViewX(x+rr);
			var y2:int=y1;
			var mapOffsetX:Number = Math.abs(x1-x2);
			var mapOffsetY:Number = Math.abs(y1-y2);
			var distance:Number = Math.sqrt(mapOffsetX*mapOffsetX + mapOffsetY*mapOffsetY);
			
			return distance;
		}
		public function checkAndGetDistance(distance:Number):Number {
			if(checkCoord()) {
				distance = distance * 2 * Math.PI * 6378137.0 / 360;
			}
			return distance;
		}
		public function checkAndGetDistanceCoord(distance:Number):Number {
			if(checkCoord()) {
				distance = distance * 360 / (2 * Math.PI * 6378137.0);
			}
			return distance;
		}
		public function formatDistance(distance:Number):String {
			if(distance >= 1000) {
				distance=Math.round(distance/10)/100;
				return distance +"公里";
			} else {
				distance=Math.round(distance*100)/100;
				return distance +"米";
			}
		}
		public function formatArea(distance:Number):String {
			if(distance >= 1000000) {
				distance=Math.round(distance/10000)/100;
				return distance +"平方公里";
			} else {
				distance=Math.round(distance*100)/100;
				return distance +"平方米";
			}
		}
		public function checkCoord():Boolean {
			if (checkCoordX(box.getMinx()) && checkCoordX(box.getMaxx()) && checkCoordY(box.getMiny()) && checkCoordY(box.getMaxy())) {
				return true;
			}
			return false;
		}
		public function checkCoordX(value:Number):Boolean {
			if(value > 73 && value < 136) {
				return true;
			}
			return false;
		}
		public function checkCoordY(value:Number):Boolean {
			if(value > 3 && value < 54) {
				return true;
			}
			return false;
		}
		public function toString():String{
			return "Coordinate:width="+screenWidth+",height="+screenHeight+",map="+box.toString();
		}
	}
}