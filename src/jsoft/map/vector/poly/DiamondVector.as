package jsoft.map.vector.poly
{
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

	public class DiamondVector extends BaseVector implements IVector
	{
		private var _pointGap:int =5; //线中两点间最短忽略距离，小于此距离则认为是一个点
		private var _color:int=0x000000;//"black";
		private var _fillColor:int =0x000000;//"black"
		private var _weight:int = 1;
		private var _opacity:Number=0.5;//透明度0-100
		
		public function DiamondVector() {
			super();
		}
		
		public override function getVectorName():String {
			return "DiamondVector";
		}
		
		public override function clone():IVector {
			var newVector:DiamondVector = new DiamondVector();
			copyTo(newVector);
			newVector._pointGap = _pointGap;
			newVector._color = _color;
			newVector._fillColor = _fillColor;
			newVector._weight = _weight;
			newVector._opacity = _opacity;
			return newVector;
		}
		
		public override function getVectorString():String {
			var theString:String = super.getVectorString();
			var split:String="Ω";
			theString+=split+_pointGap+split+_color+split+_fillColor+split+_weight+split+_opacity+split+getGeometry().getGeometryString();
			return theString;
		}
		public override function setVectorString(symbolString:String):void {
			var symbolAry:Array=symbolString.split("Ω");
			super.setVectorString(symbolAry[0]);
			this.setPointGap(symbolAry[1]);
			this.setColor(symbolAry[2]);
			this.setFillColor(symbolAry[3]);
			this.setWeight(symbolAry[4]);
			this.setOpacity(symbolAry[5]);
			var geometryFactory:GeometryFactory=new GeometryFactory();
			this.setGeometry(geometryFactory.setGeometryString(symbolAry[6]));
		}
		
		public override function toString():String {
			return getVectorString();
		}
		
		// 绘制符号
		public override function showVector(coord:Coordinate) : void {
			super.showVector(coord);
			if(geometry == null){
				return;
			}
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
				symbolUtil.updateGeometry(record.getGeometry(),this);
			}
			if(geometry) {
				this.x = 0;
				this.y = 0;
				//symbolUtil.updateGeometry(geometry,this);
			}
		}
		private function drawHotPoint(geometry:Geometry,pointCount:int):int {
			var pl:Polygon=geometry as Polygon;
			for(var i:int=0;i<pl.getPointLength();i++) {
				pointCount++;
				if(i==0||i==1||i==3) {
					continue;
				}
				var point:FPoint = pl.getPoint(i);
				if(hotRet>0) {
					if(pointCount==hotRet) {
						drawControlPEx(point,offsetx,offsety);
					} else {
						drawControlP(point);
					}
				} else if(hotRet==0) {
					drawControlPEx(point,offsetx,offsety);
				} else {
					drawControlP(point);
				}
			}
			return pointCount;
		}
		private function drawSinglePolygon(geometry:Geometry,coordinate:Coordinate,pointCount:int):int {
		  	var pl:Polygon=geometry as Polygon;
		  	var tPoint:jsoft.map.geometry.FPoint;
			var cPoint:jsoft.map.geometry.FPoint=pl.getCenter() as jsoft.map.geometry.FPoint;
			var x_arr:Array=new Array();
			var y_arr:Array=new Array();
			var x_tmp:int=0;
			var y_tmp:int=0;
			var i:int=0;
			var flag:Boolean =false;//有任何一点在当前视野中的标志,//判定线是否有点在当前视图范围内
			//取得点坐标数组
			for (i=0;i< pl.getPointLength();i++ )
			{
				tPoint=pl.getPoint(i);
				pointCount++;
				x_tmp=coordinate.mapToViewX(tPoint.getX());
				y_tmp=coordinate.mapToViewY(tPoint.getY());
				if(hotRet>0) {
					if(pointCount==hotRet) {
						x_tmp+=offsetx;
						y_tmp+=offsety;
						if(pl.getPointLength()==i+1) {
							x_arr[0]=x_tmp;
							y_arr[0]=y_tmp;
						}
					}
				} else if(hotRet==0) {
					x_tmp+=offsetx;
					y_tmp+=offsety;
					if(pl.getPointLength()==i+1) {
						x_arr[0]=x_tmp;
						y_arr[0]=y_tmp;
					}
				}
				x_arr.push(x_tmp);
				y_arr.push(y_tmp);
				if(coordinate.isInView(x_tmp,y_tmp)==true){
					flag=true;//有一点在当前视野中
				}
			}
			if(!flag){
				return pointCount;//没有任何一点在当前视野中
			}
			if(status) {
				drawUtil.setLineColor(AppContext.getDrawUtil().getReverseColor(_color));
				drawUtil.setFillColor(AppContext.getDrawUtil().getReverseColor(_fillColor));
			} else {
				drawUtil.setLineColor(_color);
				drawUtil.setFillColor(_fillColor);
			}
			drawUtil.setLineWidth(_weight);
			drawUtil.setFillAlpha(_opacity );
			var xLength:Number = x_arr[2] - x_arr[0];
			var yLength:Number = y_arr[2] - y_arr[0];
			var w:int = Math.abs(xLength);
			var h:int = Math.abs(yLength);
			drawUtil.drawDiamond(x_arr[0],y_arr[0],w,h);
			return pointCount;
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
				polygon.addPoint(startx,endy);
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
			poly.setPoint(1,endx,starty);
			poly.setPoint(2,endx,endy);
			poly.setPoint(3,startx,endy);
			poly.setPoint(4,startx,starty);
		}
		public override function hitTest(x:Number, y:Number):int {
			if(status) {
				var hotpoint:int = AppContext.getGeomUtil().hitTest(hotPointArea,x,y);
				if(hotpoint>0) {
					//AppContext.getAppUtil().alert("hotpoint="+hotpoint);
					if(hotpoint==1) {
						hotpoint=hotPointArea.length+1;
						return hotpoint;
					}
					if(hotpoint==3||hotpoint==5) {
						return hotpoint;
					}
					hotpoint=-1;
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
		
		public override function updateControlPoint(update:Boolean):void {
			if(update) {
				var coordinate:Coordinate = getCoordinate();
				var pointCount:int=0;
				if(geometry.getGeometryName() == "Polygon"){
					pointCount=moveSinglePolyEx(geometry,coordinate,pointCount);
				}
				if(geometry.getGeometryName() == "MultiPolygon"){
					var mpoly:MultiPolygon = geometry as MultiPolygon;
					for(var i:int=0;i<mpoly.getPolyLength();i++) {
						pointCount=moveSinglePolyEx(mpoly.getPoly(i),coordinate,pointCount);
					}
				}
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
	}
}