package jsoft.map.util
{
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.MultiLine;
	import jsoft.map.geometry.MultiPoint;
	import jsoft.map.geometry.MultiPolygon;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Polygon;
	
	public class GeomUtil {
		
		public function hitTest(ary:Array,x:Number,y:Number):int {
			for(var i:int=0;i<ary.length;i++) {
				var box:Box=ary[i];
				if(box.isContain(x,y)) {
					return i+1;
				}
			}
			return 0;
		}
		
		public function hitRectTest(ary:Array,x1:Number,y1:Number,x2:Number,y2:Number):Boolean {
			for(var i:int=0;i<ary.length;i++) {
				var box:Box=ary[i];
				if(box.isOverlapBox(x1,y1,x2,y2)) {
					return true;
				}
			}
			return false;
		}
		
		public function getViewGeometry(geometry:Geometry):Geometry {
			var type:String=geometry.getGeometryName();
			var coord:Coordinate=AppContext.getMapContext().getMapContent().getCoordinate();
			coord=AppContext.getMapContext().getMapContent().getCoordinate();
			var i:int=0;
			var j:int=0;
			switch(type) {
				case "Point":
			//AppContext.getAppUtil().alert("getViewGeometry coord="+coord);
					var p:FPoint=geometry as FPoint;
					var np:FPoint=toViewPoint(p,coord);
					return np;
				case "MultiPoint":
					var mp:MultiPoint=geometry as MultiPoint;
					var nmp:MultiPoint=new MultiPoint();
					for(i=0;i<mp.getPointLength();i++) {
						nmp.addPointEx(toViewPoint(mp.getPoint(i),coord));
					}
					return nmp;
				case "Line":
					var line:Line=geometry as Line;
					var nline:Line=toViewLine(line,coord);
					return nline;
				case "MultiPoint":
					var mline:MultiLine=geometry as MultiLine;
					var nmline:MultiLine=new MultiLine();
					for(j=0;j<mline.getLineLength();j++) {
						var newline:Line=toViewLine(mline.getLine(j),coord);
						nmline.addLine(newline);						
					}
					return nmline;
				case "Polygon":
					var poly:Polygon=geometry as Polygon;
					var npoly:Polygon=toViewPoly(poly,coord);
					return npoly;
				case "MultiPolygon":
					var mpoly:MultiPolygon=geometry as MultiPolygon;
					var nmpoly:MultiPolygon=new MultiPolygon();
					for(j=0;j<mpoly.getPolyLength();j++) {
						var newpoly:Polygon=toViewPoly(mpoly.getPoly(j),coord);
						nmpoly.addPoly(newpoly);						
					}
					return nmpoly;
				default:
					break;
			}
			return null;
		}
		
		private function toViewPoint(point:FPoint,coord:Coordinate) : FPoint {
			var npoint:FPoint=new FPoint();
			npoint.setX(coord.mapToViewX(point.getX()));
			npoint.setY(coord.mapToViewY(point.getY()));
			//AppContext.getAppUtil().alert("npoint="+npoint.getX()+","+npoint.getY());
			//AppContext.getDrawUtilEx(AppContext.getMapContext().getButtonContainer().graphics).clear();
			//AppContext.getDrawUtilEx(AppContext.getMapContext().getButtonContainer().graphics).drawCircle(npoint.getX(),npoint.getY(),5);
			//AppContext.getDrawUtilEx(AppContext.getMapContext().getButtonContainer().graphics).drawText(npoint.getX(),npoint.getY(),"npoint="+npoint.getX()+","+npoint.getY(),0,0,0);
			return npoint;
		}
		
		private function toViewLine(line:Line,coord:Coordinate) : Line {
			var nline:Line=new Line();
			for(var i:int=0;i<line.getXArray().length;i++) {
				var p:FPoint=line.getPoint(i);
				nline.addPoint(coord.mapToViewX(p.getX()),coord.mapToViewY(p.getY()));
			}
			return nline;
		}
		
		private function toViewPoly(poly:Polygon,coord:Coordinate) : Polygon {
			var npoly:Polygon=new Polygon();
			for(var i:int=0;i<poly.getXArray().length;i++) {
				var p:FPoint=poly.getPoint(i);
				npoly.addPoint(coord.mapToViewX(p.getX()),coord.mapToViewY(p.getY()));
			}
			return npoly;
		}
		
		public function buildGeometryArea(geometry:Geometry,gap:Number):Array {
			var ret:Array = new Array();
			//AppContext.getAppUtil().alert("geometry="+geometry);
			var type:String=geometry.getGeometryName();
			//AppContext.getAppUtil().alert("type="+type+",geometry="+geometry);
			var i:int;
			var r:Array;
			switch(type) {
				case "Point":
					var point:FPoint=geometry as FPoint;
					ret = buildPointArea(point.getX(),point.getY(),gap);
					break;
				case "MultiPoint":
					var multipoint:MultiPoint=geometry as MultiPoint;
					for(i=0;i<multipoint.getPointLength();i++) {
						r=buildPointArea(multipoint.getPoint(i).getX(),multipoint.getPoint(i).getY(),gap);
						combineArray(ret,r);						
					}
					break;
				case "Line":
					var line:Line=geometry as Line;
					ret = buildLineAryArea(line.getXArray(),line.getYArray(),gap);
					break;
				case "MultiLine":
					var mline:MultiLine=geometry as MultiLine;
					for(i=0;i<mline.getLineLength();i++) {
						r=buildLineAryArea(mline.getLine(i).getXArray(),mline.getLine(i).getYArray(),gap);
						combineArray(ret,r);						
					}
					break;
				case "Polygon":
					var poly:Polygon=geometry as Polygon;
					ret = buildPolyArea(poly.getXArray(),poly.getYArray(),gap);
					break;
				case "MultiPolygon":
					var mpoly:MultiPolygon=geometry as MultiPolygon;
					for(i=0;i<mpoly.getPolyLength();i++) {
						r=buildPolyArea(mpoly.getPoly(i).getXArray(),mpoly.getPoly(i).getYArray(),gap);
						combineArray(ret,r);						
					}
					break;
				default:
					break;
			}
			return combineArea(ret);
		}
		
		public function buildGeometryPointArea(geometry:Geometry,gap:Number):Array {
			var ret:Array = new Array();
			var type:String=geometry.getGeometryName();
			var i:int;
			var r:Array;
			switch(type) {
				case "FPoint":
					var point:FPoint=geometry as FPoint;
					ret = buildPointArea(point.getX(),point.getY(),gap);
					break;
				case "MultiPoint":
					var multipoint:MultiPoint=geometry as MultiPoint;
					for(i=0;i<multipoint.getPointLength();i++) {
						r=buildPointArea(multipoint.getPoint(i).getX(),multipoint.getPoint(i).getY(),gap);
						combineArray(ret,r);						
					}
					break;
				case "Line":
					var line:Line=geometry as Line;
					ret = buildPointAryArea(line.getXArray(),line.getYArray(),gap);
					break;
				case "MultiPoint":
					var mline:MultiLine=geometry as MultiLine;
					for(i=0;i<mline.getLineLength();i++) {
						r=buildPointAryArea(mline.getLine(i).getXArray(),mline.getLine(i).getYArray(),gap);
						combineArray(ret,r);						
					}
					break;
				case "Polygon":
					var poly:Polygon=geometry as Polygon;
					ret = buildPointAryArea(poly.getXArray(),poly.getYArray(),gap);
					break;
				case "MultiPolygon":
					var mpoly:MultiPolygon=geometry as MultiPolygon;
					for(i=0;i<mpoly.getPolyLength();i++) {
						r=buildPointAryArea(mpoly.getPoly(i).getXArray(),mpoly.getPoly(i).getYArray(),gap);
						combineArray(ret,r);
					}
					break;
				default:
					break;
			}
			return combineArea(ret);
		}
		
		public function buildPointAryArea(xary:Array,yary:Array,gap:Number):Array{
			var ret:Array = new Array();
			for(var i:int=0;i<xary.length;i++) {
				ret[i]=createBox(xary[i],yary[i],xary[i],yary[i],gap);
			}
			return ret;
		}
		
		public function buildPointArea(x:Number,y:Number,gap:Number):Array{
			var ret:Array = new Array();
			ret[0]=createBox(x,y,x,y,gap);
			return ret;
		}
				
		public function buildLineAryArea(xary:Array,yary:Array,gap:Number):Array{
			var ret:Array = new Array();
			for(var i:int=0;i<xary.length-1;i++) {
				var x1:Number=xary[i];
				var y1:Number=yary[i];
				var x2:Number=xary[i+1];
				var y2:Number=yary[i+1];
				var r:Array=buildLineArea(x1,y1,x2,y2,gap);
				combineArray(ret,r);
			}
			return ret;
		}
		
		private function combineArray(ary1:Array,ary2:Array):Array {
			for(var j:int=0;j<ary2.length;j++) {
				ary1[ary1.length]=ary2[j];
			}
			return ary1;
		}
		
		public function buildPolyArea(xary:Array,yary:Array,gap:Number):Array{
			var ret:Array = new Array();
			if(xary.length==0) {
				return ret;
			}
			if(xary.length==1) {
				ret[0]=createBox(xary[0],yary[0],xary[0],yary[0],gap);
				return ret;
			}
			var bounds:Box=new Box();
			bounds.setBox(xary[0],yary[0],xary[0],yary[0]);
			for(var i:int=1;i<xary.length;i++) {
				bounds.expandToInclude(xary[i],yary[i]);
			}
			for(var j:Number=bounds.getMinx()-gap;j<bounds.getMaxx();j+=gap) {
				var minx:Number=j;
				var maxx:Number=j+gap;
				var bbox:Box=null;
				for(i=0;i<xary.length-1;i++) {
					var box:Box=getLineBox(xary[i],yary[i],xary[i+1],yary[i+1],gap,minx,maxx);
					if(bbox==null) {
						bbox=box;
						
					} else if(box!=null) {
						bbox.expandToIncludeBox(box);
					}
					//AppContext.getAppUtil().alert("GeomUtil buildPolyArea\nbbox="+bbox+"\nx1="+xary[i]+",y1="+yary[i]+",x2="+xary[i+1]+",y2="+yary[i+1]+",gap="+gap+",\nminx="+minx+",maxx="+maxx+"\nbounds="+bounds+"\nbox="+box);
				}
				if(bbox!=null) {
					ret[ret.length]=bbox;
				}
			}
			return ret;
		}
		
		public function getLineBox(x1:Number,y1:Number,x2:Number,y2:Number,gap:Number,minx:Number,maxx:Number):Box {
			var box:Box = null;
			var bounds:Box=new Box();
			bounds.setBox(x1,y1,x2,y2);
			bounds.normalizeBox();
			bounds.buffer(gap);
			//AppContext.getAppUtil().alert("GeomUtil getLineBox\nx1="+x1+",y1="+y1+",x2="+x2+",y2="+y2+"\nbounds="+bounds+"\nbounds.isContain(minx,y1)="+bounds.isContain(minx,y1)+",minx="+minx+",y1="+y1+"\nbounds.isContain(maxx,y1)="+bounds.isContain(maxx,y1)+",maxx="+maxx+",y1="+y1);
			if(!bounds.isContain(minx,y1) && !bounds.isContain(maxx,y1)) {
				return null;
			}
			if(x1==x2) {
				return null;
			}
			var miny:Number=getLineY(x1,y1,x2,y2,minx);
			var maxy:Number=getLineY(x1,y1,x2,y2,maxx);
			box = new Box();
			box.setBox(minx,miny,maxx,maxy);
			box.normalizeBox();
			box.setMiny(box.getMiny()-gap);
			box.setMaxy(box.getMaxy()+gap);
			//AppContext.getAppUtil().alert("GeomUtil getLineBox\nx1="+x1+",y1="+y1+",x2="+x2+",y2="+y2+",gap="+gap+",\nminx="+minx+",maxx="+maxx+"\nbounds="+bounds+"\nbox="+box);
			return box;
		}
		
		// 将线段拆分成可识别操作的矩形
		public function buildLineArea(x1:Number,y1:Number,x2:Number,y2:Number,gap:Number):Array {
			var ret:Array = new Array();
			if(x1==x2||y1==y2) {
				ret[0]=createBox(x1,y1,x2,y2,gap);
			} else {
				if(x1>x2) {var x:Number=x1;x1=x2;x2=x;var y:Number=y1;y1=y2;y2=y;}
				var min:Number=y1<y2?y1-gap:y2-gap;
				var max:Number=y1<y2?y2+gap:y1+gap;
				for(var i:Number=x1-gap;i<x2;i+=gap) {
					var minx:Number=i;
					var miny:Number=getLineY(x1,y1,x2,y2,minx);
					var maxx:Number=i+gap;
					var maxy:Number=getLineY(x1,y1,x2,y2,maxx);
					var flag:Boolean=true;
					var count:int=0;
					while(flag) {
						var xx:Number=maxx+(count+1)*gap;
						if(xx>x2) {
							flag=false;
						} else {
							var yy:Number=getLineY(x1,y1,x2,y2,xx);
							if(Math.abs(yy-maxy)<gap) {
								count++;
							} else {
								flag=false;
							}
						}
					}
					maxx+=count*gap;
					i+=count*gap;
					maxy=getLineY(x1,y1,x2,y2,maxx);
					ret[ret.length]=createBox(minx,miny,maxx,maxy,0);
				}
			}
			return ret;
		}
		
		public function createBox(x1:Number,y1:Number,x2:Number,y2:Number,gap:Number):Box {
			var box:Box=new Box();
			if(x1>x2) {var x:Number=x1;x1=x2;x2=x;}
			if(y1>y2) {var y:Number=y1;y1=y2;y2=y;}
			box.setBox(x1-gap,y1-gap,x2+gap,y2+gap);
			return box;
		}
		
		// 判断点x,y是否在线段上
		public function isInLine(x1:Number,y1:Number,x2:Number,y2:Number,x:Number,y:Number,gap:Number) : Boolean {
			var xAry:Array=new Array();
			var yAry:Array=new Array();
			xAry[0]=x1;
			yAry[0]=y1;
			xAry[1]=x2;
			yAry[1]=y2;
			var boxs:Array = buildLineAryArea(xAry,yAry,gap);
			for(var i:int=0;i<boxs.length;i++) {
				var box:Box=boxs[i];
				if(box.isContain(x,y)) {
					return true;
				}
			}
			return false;
		}

		// 根据x计算线上y的值
		public function getLineY(x1:Number,y1:Number,x2:Number,y2:Number,x:Number) : Number {
			if(x1==x2) {
				return y1;
			}
			if(y1==y2) {
				return y1;
			}
			var temp:Number=(y2-y1)/(x2-x1);
			var y:Number=y1+temp*(x-x1);
			return y;
		}
		// 根据y计算线上x的值
		public function getLineX(x1:Number,y1:Number,x2:Number,y2:Number,y:Number) : Number {
			if(x1==x2) {
				return x1;
			}
			if(y1==y2) {
				return x1;
			}
			var temp:Number=(y2-y1)/(x2-x1);
			var x:Number=x1+(y-y1)/temp;
			return x;
		}
		
		public function combineArea(hotArea:Array) : Array {
			var hotNewArea:Array = new Array();
			for(var i:int=0;i<hotArea.length;i++) {
				var box:Box=hotArea[i];
				var flag:Boolean=true;
				for(var j:int=0;flag&&j<hotNewArea.length;j++) {
					var box1:Box=hotNewArea[j];
					if(box1.isEqual(box)) {
						flag=false;						
					}
				}
				if(flag) {
					hotNewArea[hotNewArea.length]=box;
				}
			}
			return hotNewArea;
		}
		
		public function printHotArea(hotArea:Array) : String {
			var theString:String = "";
			for(var i:int=0;i<hotArea.length;i++) {
				theString += "\nhotArea["+i+"]="+hotArea[i];
			}
			return theString;
		}
	}
}