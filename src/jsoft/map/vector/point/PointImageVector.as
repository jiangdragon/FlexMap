package jsoft.map.vector.point
{
	import flash.events.Event;
	
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.GeometryFactory;
	import jsoft.map.geometry.Record;
	import jsoft.map.vector.BaseVector;
	import jsoft.map.vector.IVector;
	
	import mx.controls.Image;

	public class PointImageVector extends BaseVector implements IVector
	{
		private var imageUrl:String;
		private var imgWidth:int = 32;
		private var imgHeight:int  = 32;
		private var fxImg:Image=null;
		private var bordeColor:int = rgbToInt(240,240,240);
		private var bordeColorline:int = rgbToInt(114,114,114);
		
		public function PointImageVector() {
		}
		public override function getVectorName():String {
			return "PointImageVector";
		}
		public override function clone():IVector {
			var newVector:PointImageVector = new PointImageVector();
			copyTo(newVector);
			newVector.imageUrl = imageUrl;
			newVector.imgWidth = imgWidth;
			newVector.imgHeight = imgHeight;
			return newVector;
		}
		public override function getVectorString():String {
			var theString:String = super.getVectorString();
			var split:String=getSplitString();
			theString+=split+imageUrl+split+width+split+height+split+getGeometry().getGeometryString();
			return theString;
		}
		public override function setVectorString(symbolString:String):void {
			var symbolAry:Array=symbolString.split(getSplitString());
			super.setVectorString(symbolAry[0]);
			this.setImageUrl(symbolAry[1]);
			this.setWidth(symbolAry[2]);
			this.setHeight(symbolAry[3]);
			var geometryFactory:GeometryFactory=new GeometryFactory();
			var geo:Geometry = geometryFactory.setGeometryString(symbolAry[4]);
			this.setGeometry(geo);
			clear();
		}
		public override function toString():String {
			return getVectorString();
		}
		// 获取空间对象
		public override function getGeometry():Geometry {
			var cp:FPoint = bounds.getCenter();
			return cp;
		}
		// 设置空间对象
		public override function setGeometry(geometry:Geometry):void {
			if(geometry!=null) {
				var cp:FPoint = geometry.getCenter();
				setMapRange(cp.getX(),cp.getY(),cp.getX(),cp.getY());
			}
		}
		// 获取记录对象
		public override function getRecord():Record {
			var cp:FPoint = bounds.getCenter();
			record.setGeometry(cp);
			return record;
		}
		// 设置记录对象
		public override function setRecord(record:Record):void {
			this.record = record;
			if(record.getGeometry()!=null) {
				var cp:FPoint = record.getGeometry().getCenter();
				setMapRange(cp.getX(),cp.getY(),cp.getX(),cp.getY());
			}
		}
		public override function setMapRangeBox(bounds:Box):void {
			this.bounds = new Box();
			this.bounds.setBox(bounds.getCenterX(),bounds.getCenterY(),bounds.getCenterX(),bounds.getCenterY());
		}
		public function setImageUrl(_imageUrl:String):void{
			imageUrl = _imageUrl;
			fxImg = null;
		}	
		public function getImageUrl ():String{
			return imageUrl ;
		}
		public function setWidth (_width:int):void{
			if(_width <= 0) {
				_width = 32;
			}
			imgWidth = _width;
			fxImg = null;
		}
		public function getWidth ():int {
			return imgWidth;
		}
		public function setHeight (_height:int):void{
			if(_height <= 0) {
				_height = 32;
			}
			imgHeight = _height;
			fxImg = null;
		}
		public function getHeight ():int{
			return imgHeight;
		}
		public function initImage():void{
	     	if(fxImg == null) {
	     		fxImg = new Image();
	            fxImg.scaleContent=true;
	            fxImg.addEventListener(Event.COMPLETE,onComplete);
	            fxImg.width = imgWidth;
	            fxImg.height = imgHeight;
	            fxImg.source = imageUrl;
	            fxImg.load();
	            addChild(fxImg);
	     	}
	    }
	    private function onComplete(event:Event):void {
	    	updateVector();
	    }
		// 绘制符号
		public override function showVector(coord:Coordinate) : void {
			super.showVector(coord);
			initImage();
		}
		// 绘制符号
		public override function updateVector() : void {
			if(bounds == null) {
				if(record != null && record.getGeometry() != null) {
					bounds = record.getGeometry().getBounds().toBox();
				} else {
					bounds = geometry.getBounds().toBox();
				}
			}
			var cx:Number = coord.mapToViewX(bounds.getCenterX());
			var cy:Number = coord.mapToViewY(bounds.getCenterY());
			cx += offsetx;
			cy += offsety;
			var left:int = cx - imgWidth/2;
			var top:int = cy - imgHeight/2;
			this.x = left;
			this.y = top;
	        this.width = imgWidth;
	        this.height = imgHeight;
	        //AppContext.getAppUtil().alert("showVector left="+left+",top="+top+",width="+width+",height="+height);
	        //graphics.lineStyle(1,255);
	        //graphics.drawCircle(imgWidth/2,imgHeight/2,10);
			if(fxImg != null) {
				fxImg.width = imgWidth;
				fxImg.height = imgHeight;
				fxImg.x = 0;
				fxImg.y = 0;
				fxImg.invalidateDisplayList();
			}
			if(status) {
				graphics.clear();
				drawBorderline(0,0,imgWidth,imgHeight,bordeColorline,2);
				//drawBorderline(1,1,imgWidth-2,imgHeight-2,bordeColor,1);
			}
		}
		public function draw():void {
			var coord:Coordinate = getCoordinate();
			var cx:Number = coord.mapToViewX(bounds.getCenterX());
			var cy:Number = coord.mapToViewY(bounds.getCenterY());
			cx += offsetx;
			cy += offsety;
			var left:int = cx - width/2;
			var top:int = cy - height/2;
			initImage();
			if(fxImg != null) {
				x = left;
				y = top;
	            width = imgWidth;
	            height = imgHeight;
				fxImg.x = 0;
				fxImg.y = 0;
	            fxImg.width=imgWidth;
	            fxImg.height=imgHeight;
			}
		}
		public override function clear() : void {
			if(fxImg != null) {
				removeChild(fxImg);
				fxImg = null;
			}
		}
		
		public override function hitTest(x:Number, y:Number):int {
			var spanx:Number = width<5?5:width*1.0/2;
			var spany:Number = height<5?5:height*1.0/2;
			var bounds:Box = new Box();
			bounds.setBox(x-spanx,y-spany,x+spanx,y+spany);
			var coord:Coordinate = getCoordinate();
			var cx:Number = coord.mapToViewX(this.bounds.getCenterX());
			var cy:Number = coord.mapToViewY(this.bounds.getCenterY());
			//AppContext.getAppUtil().alert("x="+x+",y="+y+"\ncx="+cx+",cy="+cy+"\nbounds="+bounds);
			if(bounds.isContain(cx,cy)) {
				return 0;
			}
			return -1;
		}
		
		public override function hitRectTest(minx:Number, miny:Number, maxx:Number, maxy:Number):Boolean {
			var spanx:Number = width<5?5:width*1.0/2;
			var spany:Number = height<5?5:height*1.0/2;
			if(fxImg != null) {
				spanx = fxImg.contentWidth<5?5:fxImg.contentWidth/8;
				spany = fxImg.contentHeight<5?5:fxImg.contentHeight/8;
			}
			var hitBounds:Box = new Box();
			hitBounds.setBox(minx,miny,maxx,maxy);
			var coord:Coordinate = getCoordinate();
			var cx:Number = coord.mapToViewX(this.bounds.getCenterX());
			var cy:Number = coord.mapToViewY(this.bounds.getCenterY());
			var box:Box = new Box();
			box.setBox(cx-spanx,cy-spany,cx+spanx,cy+spany);
			if(hitBounds.isOverlap(box)) {
				return true;
			}
			return false;
		}
		
		public override function moveControlPoint(hotPoint:int, offsetx:int, offsety:int):void {
			if(hotPoint>=0) {
				this.offsetx = offsetx;
				this.offsety = offsety;
			}
		}
		
		// 将某个控制点偏移量更新到实际的对象中
		public override function updateControlPoint(update:Boolean):void {
			if(update) {
				var coord:Coordinate = getCoordinate();
				var cx:Number = coord.mapToViewX(bounds.getCenterX());
				var cy:Number = coord.mapToViewY(bounds.getCenterY());
				cx += offsetx;
				cy += offsety;
				offsetx = 0;
				offsety = 0;
				setViewRange(cx,cy,cx,cy);
			}
		}
		private function drawBorderline(x:int,y:int,w:int,h:int,color:int,border:int=1):void {
			graphics.lineStyle(border,color);
			graphics.drawRect(x,y,w,h);
		}
	}
}