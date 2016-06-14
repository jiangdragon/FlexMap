package jsoft.map.util
{
	import flash.display.Graphics;
	
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.MultiLine;
	import jsoft.map.geometry.MultiPolygon;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Polygon;
	
	import mx.core.UIComponent;
	
	public class SymbolUtil
	{
		private var coord:Coordinate;
		
		public function SymbolUtil(coord:Coordinate) {
			this.coord = coord;
		}

		public function drawLineArray(graphics:Graphics,xAry:Array,yAry:Array,minx:Number,miny:Number):void {
			graphics.moveTo(xAry[0]-minx,yAry[0]-miny);
			for(var i:int=1;i<xAry.length&&i<yAry.length;i++) {
				graphics.lineTo(xAry[i]-minx,yAry[i]-miny);
			}
		}
		public function drawPolyArray(graphics:Graphics,xAry:Array,yAry:Array,minx:Number,miny:Number):void {
			graphics.moveTo(xAry[0]-minx,yAry[0]-miny);
			for(var i:int=1;i<xAry.length&&i<yAry.length;i++) {
				graphics.lineTo(xAry[i]-minx,yAry[i]-miny);
			}
			graphics.lineTo(xAry[0]-minx,yAry[0]-miny);
		}
		public function updateGeometry(geometry:Geometry,comp:UIComponent):void {
			if(geometry.getGeometryName() == "Line"){
				updateSingleLine(geometry,comp);
				return;
			}
			if(geometry.getGeometryName() == "MultiLine"){
				var mline:MultiLine = geometry as MultiLine;
				for(var i:int=0;i<mline.getLineLength();i++) {
					updateSingleLine(mline.getLine(i),comp);
				}
				return;
			}
			if(geometry.getGeometryName() == "Polygon"){
				updateSinglePolygon(geometry,comp);
				return;
			}
			if(geometry.getGeometryName() == "MultiPolygon"){
				var mpolygon:MultiPolygon = geometry as MultiPolygon;
				for(i=0;i<mpolygon.getPolyLength();i++) {
					updateSinglePolygon(mpolygon.getPoly(i),comp);
				}
				return;
			}
		}
		public function updateLine(geometry:Geometry,comp:UIComponent):void {
			//AppContext.getAppUtil().alert("geometry="+geometry+",comp="+comp+",coord="+this.coord);
			//AppContext.getAppUtil().alert("geometry="+geometry.getGeometryName());
			if(geometry.getGeometryName() == "Line"){
				updateSingleLine(geometry,comp);
				return;
			}
			if(geometry.getGeometryName() == "MultiLine"){
				var mline:MultiLine = geometry as MultiLine;
				for(var i:int=0;i<mline.getLineLength();i++) {
					updateSingleLine(mline.getLine(i),comp);
				}
				return;
			}
		}
		public function updateSingleLine(geometry:Geometry,comp:UIComponent):void {
			//AppContext.getAppUtil().alert("updateSinglePoint");
			var line:Line = geometry as Line;
			var xAry:Array = getLineViewX(line);
			var yAry:Array = getLineViewY(line);
			var minx:Number = getMin(xAry);
			var miny:Number = getMin(yAry);
			
			comp.x = minx;
			comp.y = miny;
			comp.width = getMax(xAry)-minx;
			comp.height = getMax(yAry)-miny;
	    }
		public function updatePolygon(geometry:Geometry,comp:UIComponent):void {
			if(geometry.getGeometryName() == "Polygon"){
				updateSinglePolygon(geometry,comp);
				return;
			}
			if(geometry.getGeometryName() == "MultiPolygon"){
				var mpolygon:MultiPolygon = geometry as MultiPolygon;
				for(var i:int=0;i<mpolygon.getPolyLength();i++) {
					updateSinglePolygon(mpolygon.getPoly(i),comp);
				}
				return;
			}
		}
		public function updateSinglePolygon(geometry:Geometry,comp:UIComponent):void {
			//AppContext.getAppUtil().alert("updateSinglePoint");
			var poly:Polygon = geometry as Polygon;
			var xAry:Array = getPolyViewX(poly);
			var yAry:Array = getPolyViewY(poly);
			var minx:Number = getMin(xAry);
			var miny:Number = getMin(yAry);
			
			comp.x = minx;
			comp.y = miny;
			comp.width = getMax(xAry)-minx;
			comp.height = getMax(yAry)-miny;
	    }
	    public function getLineViewX(line:Line):Array {
	    	var ret:Array = new Array();
	    	for(var i:int=0;i<line.getPointLength();i++) {
	    		ret.push(coord.mapToViewX(line.getPoint(i).getX()));
	    	}
	    	return ret;
	    }
	    public function getLineViewY(line:Line):Array {
	    	var ret:Array = new Array();
	    	for(var i:int=0;i<line.getPointLength();i++) {
	    		ret.push(coord.mapToViewY(line.getPoint(i).getY()));
	    	}
	    	return ret;
	    }
	    public function getPolyViewX(poly:Polygon):Array {
	    	var ret:Array = new Array();
	    	for(var i:int=0;i<poly.getPointLength();i++) {
	    		ret.push(coord.mapToViewX(poly.getPoint(i).getX()));
	    	}
	    	return ret;
	    }
	    public function getPolyViewY(poly:Polygon):Array {
	    	var ret:Array = new Array();
	    	for(var i:int=0;i<poly.getPointLength();i++) {
	    		ret.push(coord.mapToViewY(poly.getPoint(i).getY()));
	    	}
	    	return ret;
	    }
	    public function getArray(ary:Array,min:Number):Array {
	    	var ret:Array = new Array();
	    	for(var i:int=1;i<ary.length;i++) {
	    		var val:Number = ary[i];
	    		ret.push(val-min);
	    	}
	    	return ret;
	    }
	    public function getArrayEx(ary:Array,min:Number):Array {
	    	var ret:Array = new Array();
	    	for(var i:int=0;i<ary.length;i++) {
	    		var val:Number = ary[i];
	    		ret.push(val-min);
	    	}
	    	return ret;
	    }
	    public function getMin(ary:Array):Number {
	    	if(ary.length==0) {
	    		return -100;
	    	}
	    	var ret:Number = ary[0];
	    	for(var i:int=1;i<ary.length;i++) {
	    		var val:Number = ary[i];
	    		if(val < ret) {
	    			ret = val;
	    		}
	    	}
	    	return ret;
	    }
	    public function getMax(ary:Array):Number {
	    	if(ary.length==0) {
	    		return 0;
	    	}
	    	var ret:Number = ary[0];
	    	for(var i:int=1;i<ary.length;i++) {
	    		var val:Number = ary[i];
	    		if(val > ret) {
	    			ret = val;
	    		}
	    	}
	    	return ret;
	    }
		public function drawLineHotPoint(graphics:Graphics,hotRet:int,offsetx:int,offsety:int,geometry:Geometry,pointCount:int):int {
			var line:Line=geometry.clone() as Line;
			var x_arr:Array = getLineViewX(line);
			var y_arr:Array = getLineViewY(line);
			var minx:Number = getMin(x_arr);
			var miny:Number = getMin(y_arr);
			x_arr = getArrayEx(x_arr,minx);
			y_arr = getArrayEx(y_arr,miny);
			var pl:Line = new Line();
			pl.setXArray(x_arr);
			pl.setYArray(y_arr);
			//AppContext.getAppUtil().alert("line="+line+",\npl="+pl);
			for(var i:int=0;i<pl.getPointLength();i++) {
				pointCount++;
				var point:FPoint = pl.getPoint(i);
				if(hotRet>0) {
					if(pointCount==hotRet) {
						drawControlPEx(graphics,point,offsetx,offsety);
					} else {
						drawControlP(graphics,point);
					}
				} else if(hotRet==0) {
					drawControlPEx(graphics,point,offsetx,offsety);
				} else {
					drawControlP(graphics,point);
				}
			}
			return pointCount;
		}
		public function drawPolyHotPoint(graphics:Graphics,hotRet:int,offsetx:int,offsety:int,geometry:Geometry,pointCount:int):int {
			var polygon:Polygon=geometry.clone() as Polygon;
			var x_arr:Array = getPolyViewX(polygon);
			var y_arr:Array = getPolyViewY(polygon);
			var minx:Number = getMin(x_arr);
			var miny:Number = getMin(y_arr);
			x_arr = getArrayEx(x_arr,minx);
			y_arr = getArrayEx(y_arr,miny);
			var pl:Polygon = new Polygon();
			pl.setXArray(x_arr);
			pl.setYArray(y_arr);
			for(var i:int=0;i<pl.getPointLength();i++) {
				pointCount++;
				var point:FPoint = pl.getPoint(i);
				if(hotRet>0) {
					if(pointCount==hotRet||(hotRet==1&&pointCount==pl.getPointLength())||(pointCount==1&&hotRet==pl.getPointLength())) {
						drawControlPEx(graphics,point,offsetx,offsety);
					} else {
						drawControlP(graphics,point);
					}
				} else if(hotRet==0) {
					drawControlPEx(graphics,point,offsetx,offsety);
				} else {
					drawControlP(graphics,point);
				}
			}
			return pointCount;
		}
		// 绘制控制点
		public function drawControlP(graphics:Graphics,point:FPoint) : void {
			drawControlPoint(graphics,point.getX(),point.getY());
		}
		public function drawControlPEx(graphics:Graphics,point:FPoint,offsetx:int,offsety:int) : void {
			drawControlPointEx(graphics,point.getX(),point.getY(),offsetx,offsety);
		}
		public function drawControlPoint(graphics:Graphics,mapx:Number,mapy:Number) : void {
			drawControlPointEx(graphics,mapx,mapy,0,0);
		}
		public function drawControlPointEx(graphics:Graphics,mapx:Number,mapy:Number,offsetx:int,offsety:int) : void {
			var x:Number = mapx;//coord.mapToViewX(mapx);
			var y:Number = mapy;//coord.mapToViewY(mapy);
			x+=offsetx;
			y+=offsety;
			var drawUtil:DrawUtil = new DrawUtil(graphics);
			drawUtil.setFill(true);
			drawUtil.setFillColor(AppContext.getDrawUtil().getBlack());
			drawUtil.setLineColor(AppContext.getDrawUtil().getBlack());
			drawUtil.setLineWidth(1);
			var span:int = 5;
			drawUtil.drawRect(x-span,y-span,x+span,y+span);
		}
	}
}