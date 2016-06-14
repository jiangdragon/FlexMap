package jsoft.map.vector.line
{
	import __AS3__.vec.Vector;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.GraphicsPathCommand;
	import flash.display.GraphicsPathWinding;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.GeometryFactory;
	import jsoft.map.geometry.Line;
	import jsoft.map.util.DrawUtil;
	import jsoft.map.util.SarrowUtil;
	import jsoft.map.vector.BaseVector;
	import jsoft.map.vector.IVector;

	public class TailSarrowVector extends BaseVector implements IVector
	{
		public function TailSarrowVector()
		{
			super();
		}
		//返回符号名称
		public override function getVectorName():String{
			return "TailSarrowVector";
		}
		//克隆符号
		public override function clone():IVector{
			var newVector:TailSarrowVector = new TailSarrowVector();
			copyTo(newVector);
			return newVector;
		}
		// 符号的形状是否固定
		public override function isFix():Boolean{
			return true;
		}
		//获取Vector字符串
		public override function getVectorString():String{
			var theString:String = super.getVectorString();
			var split:String=getSplitString();
			theString+=split+getGeometry().getGeometryString();
			return theString;
		}
		//设置Vector字符串
		public override function setVectorString(symbolString:String):void{
			var symbolAry:Array=symbolString.split(getSplitString());
			super.setVectorString(symbolAry[0]);
			var geometryFactory:GeometryFactory=new GeometryFactory();
			this.setGeometry(geometryFactory.setGeometryString(symbolAry[1]));
		}
		// 转 Vector字符串
		public override function toString():String{
			return getVectorString();
		}
		//设置coord
		public override function showVector(coord:Coordinate):void{
			super.showVector(coord);
		}
		//显示符号
		public override function updateVector():void{
			//加入热区
			buildHotArea();
			if(geometry){
				if(geometry.getGeometryName() == "Line"){
					//下面返回数组时要加入偏移量，并非真实的geometry
					var ps:Array = geometryToArry(geometry);
					var ring:Array = createGeometryPoints(ps);
					drawSarrow(graphics,ring);
					if(status){
						drawPoints(ps);
					}
					this.x = 0;
					this.y = 0;
				}
			}
		}
		//绘制控点
		private function drawPoints(ring:Array):void{
			var span:int = 5;
			for(var i:int=0;i<ring.length;i++){
				var p:Point = ring[i];
				var drawUtil:DrawUtil = new DrawUtil(graphics);
				drawUtil.setFill(true);
				drawUtil.setFillColor(AppContext.getDrawUtil().getBlack());
				drawUtil.setLineColor(AppContext.getDrawUtil().getBlack());
				drawUtil.setLineWidth(1);
				drawUtil.drawRect(p.x-span,p.y-span,p.x+span,p.y+span);
			}
		}
		//点选 判断点在符号上
		public override function hitTest(x:Number, y:Number):int{
			if(status){//已选中
				var hotpoint:int = AppContext.getGeomUtil().hitTest(hotPointArea,x,y);
				if(hotpoint > 0){
					return hotpoint;
				}
			}
			if(AppContext.getGeomUtil().hitTest(hotArea,x,y) > 0){
				return 0;
			}
			return -1;
		}
		//框选
		public override function hitRectTest(minx:Number, miny:Number, maxx:Number, maxy:Number):Boolean{
			if(AppContext.getGeomUtil().hitRectTest(hotArea,minx,miny,maxx,maxy)) {
				return true;
			}
			return false;
		}
		//调置控点
		public override function moveControlPoint(hotPoint:int, offsetx:int, offsety:int):void{
			this.hotRet = hotPoint;
			this.offsetx = offsetx;
			this.offsety = offsety;
		}
		//更新控点
		public override function updateControlPoint(update:Boolean):void{
			if(update){
				if(geometry.getGeometryName() == "Line"){
					var ps:Array = geometryToArry(geometry);
					var xArray:Array = new Array();
					var yArray:Array = new Array();
					for(var i:int=0;i<ps.length;i++){
						var p:Point = ps[i];
						xArray[i] = coord.mapFromViewX(p.x);
						yArray[i] = coord.mapFromViewY(p.y);
					}
					var line:Line = new GeometryFactory().createLine(xArray,yArray);
					this.setGeometry(line);
				}
			}
			hotRet = -1;
			offsetx = 0;
			offsety = 0;
		}
		//geometryToArry  加入偏移量的点数组，屏幕点
		private function geometryToArry(ge:Geometry):Array{
			var line:Line = ge as Line;
			var rs:Array = new Array();
			var pointCount:int = 0;
			var x:Number;
			var y:Number;
			for(var i:int=0;i<line.getPointLength();i++){
				pointCount++;
				if(hotRet > 0){
					if(pointCount == hotRet){
						x = coord.mapToViewX(line.getPoint(i).getX()) + offsetx;
						y = coord.mapToViewY(line.getPoint(i).getY()) + offsety;
						rs.push(new Point(x,y));
					}else{
						x = coord.mapToViewX(line.getPoint(i).getX());
						y = coord.mapToViewY(line.getPoint(i).getY());
						rs.push(new Point(x,y));
					}
				}else if(hotRet == 0){
					x = coord.mapToViewX(line.getPoint(i).getX()) + offsetx;
					y = coord.mapToViewY(line.getPoint(i).getY()) + offsety;
					rs.push(new Point(x,y));
				}else if(hotRet == -1){
					x = coord.mapToViewX(line.getPoint(i).getX());
					y = coord.mapToViewY(line.getPoint(i).getY());
					rs.push(new Point(x,y));
				}
			}
			return rs;
		}
		//创建N阶曲线点，屏幕点
		public function createGeometryPoints(ps:Array):Array{
			if(ps.length < 2){
				return null;
			}
			var rs:Array = new Array();
			var i:int;
			var n:int;
			if(ps.length == 2){
				var m_point:Point = new Point((ps[0].x + ps[1].x) * 0.5,(ps[0].y + ps[1].y) * 0.5);
				var _ps:Array = SarrowUtil.getHeanGBJ(ps[0],m_point,ps[1]);
				var dis:Number = SarrowUtil.getDIS(ps[0],ps[1]);
				var angle:Number = (ps[1].y - ps[0].y) / (ps[1].x - ps[0].x);
				var x:Number = dis * 0.2 * Math.cos(Math.atan(angle));
				var y:Number = dis * 0.2 * Math.sin(Math.atan(angle))
				var tail_point:Point = new Point(ps[0].x + x,ps[0].y + y);
				n = _ps.length;
				i = 0;
				while(i < n){
					rs.push(_ps[n-1-i]);
					i++;
				}
				rs.push(tail_point);
				rs.push(rs[0]);
			}
			if(ps.length > 2){
				var d:Number = 0;
				n = ps.length;
				i = 0;
				while(i < n-1){
					d = d + SarrowUtil.getDIS(ps[i],ps[i+1]) * (n-i-1) / n;
					i++;
				}
				rs = SarrowUtil.makeMiddlePoints(ps,false,true);
			}
			return rs;
		}
		//绘制符号
		public function drawSarrow(g:Graphics,ring:Array):void{
			//var color:int = 11674146;
			//var alpha:Number = 0.8;
			g.clear();
			var gradientBoxMatrix:Matrix = new Matrix();
			gradientBoxMatrix.createGradientBox(1400,1500,(Math.PI / 2),0,0);
			g.beginGradientFill(GradientType.LINEAR,[0xFF0000,0xFF00,0xFFACD],[1,0.35,0],[0,100,0xFF],gradientBoxMatrix,SpreadMethod.REFLECT);
			if((ring == null) ||(ring.length ==0)){
				return;
			}
			var rings:Array = new Array();
			var i:int = 0;
			var n:int = ring.length;
			while(i < n){
				rings.push(new Point(ring[i].x,ring[i].y));
				i++;
			}
			
			var commands:Vector.<int> = new __AS3__.vec.Vector.<int>();
			var datas:Vector.<Number> = new __AS3__.vec.Vector.<Number>();
			commands.push(GraphicsPathCommand.MOVE_TO);
			datas.push(rings[0].x,rings[0].y);
			i = 1;
			while(i < n){
				commands.push(GraphicsPathCommand.LINE_TO);
				datas.push(rings[i].x,rings[i].y);
				i++;
			}
			g.drawPath(commands,datas,GraphicsPathWinding.NON_ZERO);
			
//			var start_point:Point = (rings[0] as Point);
//			g.moveTo(start_point.x, start_point.y);
//			i = 0;
//			while (i < n) {
//                g.lineTo(rings[i].x, rings[i].y);
//                i++;
//            }
            g.endFill();
		}
		
	}
}