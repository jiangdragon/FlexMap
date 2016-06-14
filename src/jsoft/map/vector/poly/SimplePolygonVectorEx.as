package jsoft.map.vector.poly
{
	import flash.events.Event;
	
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.GeometryFactory;
	import jsoft.map.geometry.MultiPolygon;
	import jsoft.map.geometry.Polygon;
	import jsoft.map.util.DrawUtil;
	import jsoft.map.util.SymbolUtil;
	import jsoft.map.vector.BaseVector;
	import jsoft.map.vector.IVector;
	
	import mx.controls.Image;

	public class SimplePolygonVectorEx extends BaseVector implements IVector
	{
		private var _pointGap:int =5; //线中两点间最短忽略距离，小于此距离则认为是一个点
		private var _color:int=0x000000;//"black";
		private var _fillColor:int =0x000000;//"black"
		private var _weight:int = 1;
		private var _opacity:Number=0.5;//透明度0-100
		private var numPoints:int=3;
		private var _imageUrl:String;
		
		public function SimplePolygonVectorEx() {
			super();
		}
		
		public override function getVectorName():String {
			return "SimplePolygonVectorEx";
		}
		
		public function getNumPoints() : int {
			return numPoints;
		}
		
		public function setNumPoints(numPoints:int) : void {
			this.numPoints=numPoints;
		}
		
		public override function clone():IVector {
			var newVector:SimplePolygonVectorEx = new SimplePolygonVectorEx();
			copyTo(newVector);
			newVector._pointGap = _pointGap;
			newVector._color = _color;
			newVector._fillColor = _fillColor;
			newVector._weight = _weight;
			newVector._opacity = _opacity;
			newVector._imageUrl = _imageUrl;
			return newVector;
		}
		//  符号的形状是否固定
		public override function isFix() : Boolean {
			return true;
		}
		// 为符号添加点,并更新
		public override function addPoint(x:int,y:int) : void {
			var mplg:MultiPolygon;
			if(geometry.getGeometryName() == "Polygon"){
				addPointToPolygon(geometry as Polygon,x,y);
			} else if(geometry.getGeometryName() == "MultiPolygon"){
				mplg = geometry as MultiPolygon;
				for(var i:int=0;i<mplg.getPolyLength();i++) {
					addPointToPolygon(mplg.getPoly(i),x,y);
				}
			} else {
				AppContext.getAppUtil().alert("点符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
			}
			buildHotArea();
//			while(this.numChildren > 0) {
//				this.removeChildAt(0);
//			}
		}
		private function addPointToPolygon(polygon:Polygon,x:int,y:int) : void {
			var coordinate:Coordinate = getCoordinate();
			for(var i:int=1;i<polygon.getPointLength();i++) {
				var x1:int=coordinate.mapToViewX(polygon.getXArray()[i-1]);
				var y1:int=coordinate.mapToViewY(polygon.getYArray()[i-1]);
				var x2:int=coordinate.mapToViewX(polygon.getXArray()[i]);
				var y2:int=coordinate.mapToViewY(polygon.getYArray()[i]);
				if(AppContext.getGeomUtil().isInLine(x1,y1,x2,y2,x,y,5)) {
					var mx:Number=coordinate.mapFromViewX(x);
					var my:Number=coordinate.mapFromViewY(y);
					polygon.insertPoint(i,mx,my);
					return;
				}
			}
		}
		// 删除符号点,并更新
		public override function removePoint(index:int) : void {
			var mplg:MultiPolygon;
			var pointCount:int=0;
			if(geometry.getGeometryName() == "Polygon"){
				removePolygonPoint(geometry as Polygon,index,pointCount);
			} else if(geometry.getGeometryName() == "MultiPolygon"){
				mplg = geometry as MultiPolygon;
				for(var i:int=0;i<mplg.getPolyLength();i++) {
					pointCount+=removePolygonPoint(mplg.getPoly(i),index,pointCount);
				}
			} else {
				AppContext.getAppUtil().alert("点符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
			}
			buildHotArea();
//			while(this.numChildren > 0) {
//				this.removeChildAt(0);
//			}
		}
		private function removePolygonPoint(polygon:Polygon,index:int,pointCount:int) : int {
			if(polygon.getPointLength()<index-pointCount-1) {
				return polygon.getPointLength();
			}
			polygon.removePoint(index-pointCount-1);
			return polygon.getPointLength();
		}
		
		public override function getVectorString():String {
			var theString:String = super.getVectorString();
			var split:String=getSplitString();
			theString+=split+_pointGap+split+_color+split+_fillColor+split+_weight+split+_opacity+split+numPoints+split+getGeometry().getGeometryString();
			return theString;
		}
		public override function setVectorString(symbolString:String):void {
			var symbolAry:Array=symbolString.split(getSplitString());
			super.setVectorString(symbolAry[0]);
			this.setPointGap(symbolAry[1]);
			this.setColor(symbolAry[2]);
			this.setFillColor(symbolAry[3]);
			this.setWeight(symbolAry[4]);
			this.setOpacity(symbolAry[5]);
			this.setNumPoints(symbolAry[6]);
			var geometryFactory:GeometryFactory=new GeometryFactory();
			this.setGeometry(geometryFactory.setGeometryString(symbolAry[7]));
		}
		public override function toString():String {
			return getVectorString();
		}
		
		public function draw():void {
			buildHotArea();
			var coordinate:Coordinate = getCoordinate();
			var i:int=0;
			var mplg:MultiPolygon;
			var pointCount:int=0;
			if(geometry.getGeometryName() == "Polygon"){
				pointCount=drawSinglePolygon(geometry,coordinate,pointCount);
			} else if(geometry.getGeometryName() == "MultiPolygon"){
				mplg = geometry as MultiPolygon;
				for(i=0;i<mplg.getPolyLength();i++) {
					 pointCount=drawSinglePolygon(mplg.getPoly(i),coordinate,pointCount);
				}
			} else {
				AppContext.getAppUtil().alert("面符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
			}
			if(status) {
				pointCount=0;
				if(geometry.getGeometryName() == "Polygon"){
					pointCount=drawHotPoint(geometry,pointCount);
				} else if(geometry.getGeometryName() == "MultiPolygon"){
					mplg = geometry as MultiPolygon;
					for(i=0;i<mplg.getPolyLength();i++) {
						 pointCount=drawHotPoint(mplg.getPoly(i),pointCount);
					}
				} else {
					AppContext.getAppUtil().alert("面符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
				}
			}
		}
		// 绘制符号
		public override function showVector(coord:Coordinate) : void {
			super.showVector(coord);
			var i:int=0;
			var mplg:MultiPolygon;
			var pointCount:int=0;
			if(geometry.getGeometryName() == "Polygon"){
				pointCount=drawSinglePolygon(geometry,coord,pointCount);
			} else if(geometry.getGeometryName() == "MultiPolygon"){
				mplg = geometry as MultiPolygon;
				for(i=0;i<mplg.getPolyLength();i++) {
					 pointCount=drawSinglePolygon(mplg.getPoly(i),coord,pointCount);
				}
			} else {
				AppContext.getAppUtil().alert("面符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
			}
			if(status) {
				pointCount=0;
				if(geometry.getGeometryName() == "Polygon"){
					pointCount=drawHotPoint(geometry,pointCount);
				} else if(geometry.getGeometryName() == "MultiPolygon"){
					mplg = geometry as MultiPolygon;
					for(i=0;i<mplg.getPolyLength();i++) {
						 pointCount=drawHotPoint(mplg.getPoly(i),pointCount);
					}
				} else {
					AppContext.getAppUtil().alert("面符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
				}
			}
		}
		// 绘制符号
		public override function updateVector() : void {
			buildHotArea();
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
			if(record!=null&&record.getGeometry()!=null) {
				symbolUtil.updatePolygon(record.getGeometry(),this);
			}
			if(geometry) {
				symbolUtil.updatePolygon(geometry,this);
			}
		}
		
		private function drawHotPoint(geometry:Geometry,pointCount:int):int {
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
			return symbolUtil.drawPolyHotPoint(graphics,hotRet,offsetx,offsety,geometry,pointCount);
		}
		private function drawSinglePolygon(geometry:Geometry,coordinate:Coordinate,pointCount:int):int {
		  	var pl:Polygon=geometry as Polygon;
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
		  	var tPoint:jsoft.map.geometry.FPoint;
			var cPoint:jsoft.map.geometry.FPoint=pl.getCenter() as jsoft.map.geometry.FPoint;
			var x_arr:Array=new Array();
			var y_arr:Array=new Array();
			var x_tmp:int=0;
			var y_tmp:int=0;
			var i:int=0;
			var flag:Boolean =false;//有任何一点在当前视野中的标志,//判定线是否有点在当前视图范围内
			//取得点坐标数组
			var retPointCount:int = pointCount;
			for (i=0;i< pl.getPointLength();i++ )
			{
				tPoint=pl..getPoint(i);
				pointCount++;
				x_tmp=coordinate.mapToViewX(tPoint.getX());
				y_tmp=coordinate.mapToViewY(tPoint.getY());
//				if(hotRet>0) {
//					if(pointCount==hotRet) {
//						x_tmp+=offsetx;
//						y_tmp+=offsety;
//						if(pl.getPointLength()==i+1) {
//							x_arr[0]=x_tmp;
//							y_arr[0]=y_tmp;
//						}
//					}
//				} else if(hotRet==0) {
//					x_tmp+=offsetx;
//					y_tmp+=offsety;
//					if(pl.getPointLength()==i+1) {
//						x_arr[0]=x_tmp;
//						y_arr[0]=y_tmp;
//					}
//				}
				x_arr.push(x_tmp);
				y_arr.push(y_tmp);
				if(coordinate.isInView(x_tmp,y_tmp)==true){
					flag=true;//有一点在当前视野中
				}
			}
			if(!flag){
				return pointCount;//没有任何一点在当前视野中
			}
			var minx:Number = symbolUtil.getMin(x_arr);
			var miny:Number = symbolUtil.getMin(y_arr);
			x_arr = symbolUtil.getArrayEx(x_arr,minx);
			y_arr = symbolUtil.getArrayEx(y_arr,miny);
			//AppContext.getAppUtil().alert("x_arr="+x_arr.length+",y_arr="+y_arr.length);
			for (i=0;i<x_arr.length;i++) {
				retPointCount++;
				if(hotRet>0) {
					if(retPointCount==hotRet) {
						x_arr[i]+=offsetx;
						y_arr[i]+=offsety;
						if(i == x_arr.length - 1) {
							x_arr[0]+=offsetx;
							y_arr[0]+=offsety;
						}
					}
				} else if(hotRet==0) {
					x_arr[i]+=offsetx;
					y_arr[i]+=offsety;
				}
			}
			var drawUtil:DrawUtil = this.drawUtil;
			x_arr[x_arr.length]=x_arr[0];
			y_arr[y_arr.length]=y_arr[0];
			if(status) {
				drawUtil.setLineColor(AppContext.getDrawUtil().getReverseColor(_color));
				drawUtil.setFillColor(AppContext.getDrawUtil().getReverseColor(_fillColor));
			} else {
				drawUtil.setLineColor(_color);
				drawUtil.setFillColor(_fillColor);
			}
			drawUtil.setLineWidth(_weight);
			drawUtil.setFillAlpha(_opacity );	
			drawUtil.drawPolygon(x_arr,y_arr);
			while(this.numChildren > 0) {
				this.removeChildAt(0);
			}
			//加放绘图片
			if(this.numChildren == 0){
				drawImage(x_arr,y_arr);
			}
			return pointCount;
		}
		private function drawImage(xAry:Array,yAry:Array):void{
			for(var i:int=1;i<xAry.length&&i<yAry.length;i++) {
				var image:Image = new Image();
				image.load(_imageUrl);
				image.x = xAry[i] - 16;
				image.y = yAry[i] - 16;
				image.width = 32;
				image.height = 32;
				//image.addEventListener(Event.COMPLETE,onComplete);
				this.addChild(image);
			}
		}
		public override function getMapRange():Box {
			return geometry.getBounds().toBox();
		}
		
		public override function setMapRangeBox(bounds:Box):void {
			var startx:Number = bounds.getMinx();
			var starty:Number = bounds.getMiny();
			var endx:Number = bounds.getMaxx();
			var endy:Number = bounds.getMaxy();
			if(geometry == null) {
				var polygon:Polygon = new Polygon();
				polygon.addPoint(startx,starty);
				polygon.addPoint(endx,starty);
				polygon.addPoint(endx,endy);
				if(this.numPoints==4) {
					polygon.addPoint(startx,endy);
				}
				polygon.addPoint(startx,starty);
				geometry = polygon;
			} else {
				if(geometry.getGeometryName() == "Polygon"){
					setPoly(startx,starty,endx,endy,geometry as Polygon);
					return;
				}
				if(geometry.getGeometryName() == "MultiPolygon"){
					var mppoly:MultiPolygon = geometry as MultiPolygon;
					for(var i:int=0;i<mppoly.getPolyLength();i++) {
						setPoly(startx,starty,endx,endy,mppoly.getPoly(i));
					}
					return;
				}
			}
		}
		
		private function setPoly(startx:Number,starty:Number,endx:Number,endy:Number,poly:Polygon):void {
			poly.setPoint(0,startx,starty);
			if(status) {
				poly.setPoint(1,endx,starty);
			}
			poly.setPoint(poly.getPointLength()-2,endx,endy);
			poly.setPoint(poly.getPointLength()-1,startx,starty);
		}
		
		public override function hitTest(x:Number, y:Number):int {
			if(status) {
				var hotpoint:int = AppContext.getGeomUtil().hitTest(hotPointArea,x,y);
				if(hotpoint>0) {
					//AppContext.getAppUtil().alert("hotpoint="+hotpoint);
					if(hotpoint==1) {
						hotpoint=hotPointArea.length+1;
					}
					return hotpoint;
				}
			}
			if(AppContext.getGeomUtil().hitTest(hotArea,x,y)>0) {
				//AppContext.getAppUtil().alert("hotpoint="+0);
				return 0;
			}
			//AppContext.getAppUtil().alert("SimpleLineVector\nx="+x+",y="+y+"\nhotArea="+AppContext.getGeomUtil().printHotArea(hotArea)+"\n");
			return -1;
		}
		
		public override function hitRectTest(minx:Number, miny:Number, maxx:Number, maxy:Number):Boolean {
			if(AppContext.getGeomUtil().hitRectTest(hotArea,minx,miny,maxx,maxy)) {
				//AppContext.getAppUtil().alert("hotpoint="+0);
				return true;
			}
			//AppContext.getAppUtil().alert("SimpleLineVector\nminx="+minx+",maxx="+maxx+",miny="+miny+",maxy="+maxy+"\nhotArea="+AppContext.getGeomUtil().printHotArea(hotArea)+"\n");
			return false;
		}
		
		public override function moveControlPoint(hotPoint:int, offsetx:int, offsety:int):void {
			this.hotRet = hotPoint;
			this.offsetx = offsetx;
			this.offsety = offsety;
		}
		/* 移动控点时更新 */
		public override function updateControlPoint(update:Boolean):void {
			if(update) {
				var coordinate:Coordinate = getCoordinate();
				var pointCount:int=0;
				if(geometry.getGeometryName() == "Polygon"){
					pointCount=moveSinglePoly(geometry,coordinate,pointCount);
				}
				if(geometry.getGeometryName() == "MultiPolygon"){
					var mpoly:MultiPolygon = geometry as MultiPolygon;
					for(var i:int=0;i<mpoly.getPolyLength();i++) {
						pointCount=moveSinglePoly(mpoly.getPoly(i),coordinate,pointCount);
					}
				}
				//清图片
//				while(this.numChildren > 0) {
//					this.removeChildAt(0);
//				}
			}
			hotRet=-1;
			offsetx=0;
			offsety=0;
		}
		
		//获取线的两点间最短忽略距离
		public function getPointGap():int {
			return this._pointGap;
		}
		public function setPointGap (inpointGap:int):void {
			if(inpointGap>0){
				this._pointGap = inpointGap;
			}
		}
		public function setColor (incolor:int):void {
			this._color=incolor;
		}
		public function getColor():int {
			return this._color;
		}
		public function setFillColor (incolor:int):void {
			this._fillColor=incolor;
		}
		public function getFillColor():int {
			return this._fillColor;
		}		
		public function setWeight (inweight:int):void {
			this._weight=inweight;
		}
		public function getWeight():int {
			return this._weight;
		}
		public function setOpacity (in_opacity:Number):void {
			this._opacity=in_opacity;
		}
		public function getOpacity():Number {
			return this._opacity;
		}
		public function setImageUrl(imageUrl:String):void{
			this._imageUrl = imageUrl;
		}
		public function getImageUrl():String{
			return this._imageUrl;
		}
	}
}