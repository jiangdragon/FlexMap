package jsoft.map.vector.line
{
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.GeometryFactory;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.MultiLine;
	import jsoft.map.util.ArrowHelper;
	import jsoft.map.util.DrawUtil;
	import jsoft.map.util.SymbolUtil;
	import jsoft.map.vector.BaseVector;
	import jsoft.map.vector.IVector;

	public class ArrowVector extends BaseVector implements IVector
	{
		private var _color:int=0x000000;
		private var _width:int=1;
		
		public function ArrowVector() {
			super();
		}
		
		public override function getVectorName():String {
			return "ArrowVector";
		}
		
		public override function clone():IVector {
			var newVector:ArrowVector = new ArrowVector();
			copyTo(newVector);
			newVector._color = _color;
			newVector._width = _width;
			return newVector;
		}
		//  符号的形状是否固定
		public override function isFix() : Boolean {
			return true;
		}
		// 为符号添加点
		public override function addPoint(x:int,y:int) : void {
			var mpline:MultiLine;
			if(geometry.getGeometryName() == "Line"){
				addPointToLine(geometry as Line,x,y);
			} else if(geometry.getGeometryName() == "MultiLine"){
				mpline = geometry as MultiLine;
				for(var i:int=0;i<mpline.getLineLength();i++) {
					addPointToLine(mpline.getLine(i),x,y);
				}
			} else {
				AppContext.getAppUtil().alert("线符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
			}
			buildHotArea();
		}
		private function addPointToLine(line:Line,x:int,y:int) : void {
			var coordinate:Coordinate = getCoordinate();
			for(var i:int=1;i<line.getPointLength();i++) {
				var x1:int=coordinate.mapToViewX(line.getXArray()[i-1]);
				var y1:int=coordinate.mapToViewY(line.getYArray()[i-1]);
				var x2:int=coordinate.mapToViewX(line.getXArray()[i]);
				var y2:int=coordinate.mapToViewY(line.getYArray()[i]);
				if(AppContext.getGeomUtil().isInLine(x1,y1,x2,y2,x,y,5)) {
					var mx:Number=coordinate.mapFromViewX(x);
					var my:Number=coordinate.mapFromViewY(y);
					line.insertPoint(i,mx,my);
					return;
				}
			}
		}
		// 删除符号点
		public override function removePoint(index:int) : void {
			var mpline:MultiLine;
			var pointCount:int=0;
			if(geometry.getGeometryName() == "Line"){
				removeLinePoint(geometry as Line,index,pointCount);
			} else if(geometry.getGeometryName() == "MultiLine"){
				mpline = geometry as MultiLine;
				for(var i:int=0;i<mpline.getLineLength();i++) {
					pointCount+=removeLinePoint(mpline.getLine(i),index,pointCount);
				}
			} else {
				AppContext.getAppUtil().alert("点符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
			}
			buildHotArea();
		}
		private function removeLinePoint(line:Line,index:int,pointCount:int) : int {
			if(line.getPointLength()<index-pointCount-1) {
				return line.getPointLength();
			}
			line.removePoint(index-pointCount-1);
			return line.getPointLength();
		}
		public override function getVectorString():String {
			var theString:String = super.getVectorString();
			var split:String=getSplitString();
			theString+=split+_color+split+_width+split+getGeometry().getGeometryString();
			return theString;
		}
		
		public override function setVectorString(symbolString:String):void {
			var symbolAry:Array=symbolString.split(getSplitString());
			super.setVectorString(symbolAry[0]);
			this.setColor(symbolAry[1]);
			this.setWidth(symbolAry[2]);
			var geometryFactory:GeometryFactory=new GeometryFactory();
			this.setGeometry(geometryFactory.setGeometryString(symbolAry[3]));
		}
		
		public override function toString():String {
			return getVectorString();
		}
		// 绘制符号
		public override function showVector(coord:Coordinate) : void {
			super.showVector(coord);
			var pointCount:int=0;
			var mpline:MultiLine;
			var i:int=0;
			if(geometry.getGeometryName() == "Line"){
				pointCount=drawSingleLine(geometry,coord,pointCount);
			} else if(geometry.getGeometryName() == "MultiLine"){
				mpline = geometry as MultiLine;
				for(i=0;i<mpline.getLineLength();i++) {
					pointCount=drawSingleLine(mpline.getLine(i),coord,pointCount);
				}
			} else {
				AppContext.getAppUtil().alert("点符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
			}
			if(status) {
				pointCount=0;
				if(geometry.getGeometryName() == "Line"){
					pointCount=drawHotPoint(geometry,pointCount);
				} else if(geometry.getGeometryName() == "MultiLine"){
					mpline = geometry as MultiLine;
					for(i=0;i<mpline.getLineLength();i++) {
						pointCount=drawHotPoint(mpline.getLine(i),pointCount);
					}
				}
			}
		}
		// 绘制符号
		public override function updateVector() : void {
			buildHotArea();
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
			//AppContext.getAppUtil().alert("record="+record);
			if(record!=null&&record.getGeometry()!=null) {
				symbolUtil.updateLine(record.getGeometry(),this);
			}
			if(geometry) {
				symbolUtil.updateLine(geometry,this);
			}
		}
		
		private function drawHotPoint(geometry:Geometry,pointCount:int):int {
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
			return symbolUtil.drawLineHotPoint(graphics,hotRet,offsetx,offsety,geometry,pointCount);
		}
		
		private function drawSingleLine(geometry:Geometry,coordinate:Coordinate,pointCount:int):int {
			var pl:Line=geometry as Line;
			var symbolUtil:SymbolUtil = new SymbolUtil(coord);
			var tPoint:jsoft.map.geometry.FPoint;
			var cPoint:jsoft.map.geometry.FPoint=pl.getCenter() as jsoft.map.geometry.FPoint;
			var x_arr:Array=new Array();
			var y_arr:Array=new Array();
			var x_tmp:int=0;
			var y_tmp:int=0;
			var i:int=0;
			var flag:Boolean =false;
			//有任何一点在当前视野中的标志,//判定线是否有点在当前视图范围内
			//AppContext.getAppUtil().alert("pl.getPointLength()="+pl.getPointLength());
			//取得点坐标数组
			var retPointCount:int = pointCount;
			for (i=0;i< pl.getPointLength();i++) {
				tPoint=pl.getPoint(i);
				x_tmp=coordinate.mapToViewX(tPoint.getX());
				y_tmp=coordinate.mapToViewY(tPoint.getY());
				pointCount++;
//				if(hotRet>0) {
//					if(pointCount==hotRet) {
//						x_tmp+=offsetx;
//						y_tmp+=offsety;
//					}
//				} else if(hotRet==0) {
//					x_tmp+=offsetx;
//					y_tmp+=offsety;
//				}
				//AppContext.getAppUtil().alert("x_tmp="+x_tmp+",y_tmp="+y_tmp);
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
					}
				} else if(hotRet==0) {
					x_arr[i]+=offsetx;
					y_arr[i]+=offsety;
				}
			}
			//var draw:DrawUtil = drawUtil;
			//if(status) {
				//draw = highDrawUtil;
			//}
			//draw.setLineWidth(_width);
			//draw.setFill(false);
			var helper:ArrowHelper = new ArrowHelper(graphics,_color,_width);
			helper.addPoints(x_arr,y_arr);
			helper.draw();
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
				var line:Line = new Line();
				line.addPoint(startx,starty);
				line.addPoint(endx,endy);
				geometry = line;
			} else {
				if(geometry.getGeometryName() == "Line"){
					setArrowLine(startx,starty,endx,endy,geometry as Line);
					return;
				}
				if(geometry.getGeometryName() == "MultiLine"){
					var mpline:MultiLine = geometry as MultiLine;
					for(var i:int=0;i<mpline.getLineLength();i++) {
						setArrowLine(startx,starty,endx,endy,mpline.getLine(i));
					}
					return;
				}
			}
		}
		
		private function setArrowLine(startx:Number,starty:Number,endx:Number,endy:Number,line:Line):void {
			line.setPoint(0,startx,starty);
			if(line.getPointLength()>1) {
				line.setPoint(line.getPointLength()-1,endx,endy);
			} else {
				line.setPoint(line.getPointLength(),endx,endy);
			}
		}
		
		public override function hitTest(x:Number, y:Number):int {
			if(status) {
				var hotpoint:int = AppContext.getGeomUtil().hitTest(hotPointArea,x,y);
				if(hotpoint>0) {
					//AppContext.getAppUtil().alert("SimpleLineVector.hitTest.hotpoint="+hotpoint);
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
		
		public override function updateControlPoint(update:Boolean):void {
			if(update) {
				var coordinate:Coordinate = getCoordinate();
				var pointCount:int=0;
				if(geometry.getGeometryName() == "Line"){
					pointCount=moveSingleLine(geometry,coordinate,pointCount);
				}
				if(geometry.getGeometryName() == "MultiLine"){
					var mpline:MultiLine = geometry as MultiLine;
					for(var i:int=0;i<mpline.getLineLength();i++) {
						pointCount=moveSingleLine(mpline.getLine(i),coordinate,pointCount);
					}
				}
			}
			hotRet=-1;
			offsetx=0;
			offsety=0;
			//AppContext.getAppUtil().alert("offsetx="+offsetx+",offsety="+offsety);
		}
		
		private function moveSingleLine(geometry:Geometry,coordinate:Coordinate,pointCount:int):int {
			var pl:Line=geometry as Line;
			var tPoint:jsoft.map.geometry.FPoint;
			var x_tmp:Number=0;
			var y_tmp:Number=0;
			var i:int=0;
			//有任何一点在当前视野中的标志,//判定线是否有点在当前视图范围内
			//AppContext.getAppUtil().alert("pl.getPointLength()="+pl.getPointLength());
			//取得点坐标数组
			for (i=0;i< pl.getPointLength();i++ ) {
				pointCount++;
				if(hotRet>0) {
					if(pointCount==hotRet) {
						tPoint=pl.getPoint(i);
						x_tmp=coordinate.mapToViewX(tPoint.getX());
						y_tmp=coordinate.mapToViewY(tPoint.getY());
						x_tmp+=offsetx;
						y_tmp+=offsety;
						x_tmp=coordinate.mapFromViewX(x_tmp);
						y_tmp=coordinate.mapFromViewY(y_tmp);
						pl.setPoint(i,x_tmp,y_tmp);
						return pointCount;
					}
				} else if(hotRet==0) {
					tPoint=pl.getPoint(i);
					x_tmp=coordinate.mapToViewX(tPoint.getX());
					y_tmp=coordinate.mapToViewY(tPoint.getY());
					x_tmp+=offsetx;
					y_tmp+=offsety;
					x_tmp=coordinate.mapFromViewX(x_tmp);
					y_tmp=coordinate.mapFromViewY(y_tmp);
					pl.setPoint(i,x_tmp,y_tmp);
				}
			}
			return pointCount;
	     }
		
		public function setColor(incolor:int):void{
			this._color=incolor;
		}
		public function getColor():int
		{
			return this._color;
		}
		public function setWidth(inwidth:int):void{
			this._width = inwidth;
		}
		public function getWidth():int{
			return this._width;
		}
		
	}
}