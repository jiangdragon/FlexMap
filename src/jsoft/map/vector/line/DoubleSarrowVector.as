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

	public class DoubleSarrowVector extends BaseVector implements IVector
	{
		public function DoubleSarrowVector()
		{
			super();
		}
		//返回符号名称
		public override function getVectorName():String {
			return "DoubleSarrowVector";
		}
		// 克隆符号
		public override function clone():IVector {
			var newVector:DoubleSarrowVector = new DoubleSarrowVector();
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
			var geometryFactory:GeometryFactory = new GeometryFactory();
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
		//改变点坐标
		private function changePoints(x:Number, y:Number, angle:Number, x0:Number, y0:Number):Point{
            var x1:Number = x * Math.cos(angle) + y * Math.sin(angle) + x0;
            var y1:Number = y * Math.cos(angle) - x * Math.sin(angle) + y0;
            return new Point(x1, y1);
        }
		//创建N阶曲线点，屏幕点
		public function createGeometryPoints(ps:Array):Array{
			var end_point:Point;
            var point2:Point;
            var point1:Point;
            var point0:Point;
            var temp_point:Point;				//临时点，用于交换点
            var right_points:Array;
            var l_dis:Number;
            var c_dis:Number;
            var range:Number;
            var left_points:Array;
            var radius:Number;
            var l_points:Array;
            var r_points:Array;
            var middle_points:Array;
            var left_n_point:Point;
            var right_n_point:Point;
            var left_w_point:Point;
            var right_w_point:Point;
            var left_m_point:Point;
            var right_m_point:Point;
            var left_dis:Number;
            var x:Number;
            var y:Number;
            var left_angle:Number;
            var right_angle:Number;
            var point_m:Point;					//第一点和第二点的连线的中心点
            var point_m1:Point;					//第一点和第二点的连线的中垂线上的一点
            var i:Number;						//步长
            var k:Number;						//第一点和第二点的连线的中垂线斜率
            if (ps.length < 2){
                return null;
            }
            var rs:Array = new Array();
            if (ps.length == 2){
                //ps.push(ps[0]);
                //var _i:int = 0;
                //var n:int = ps.length;
                //while(_i < n){
                //	rs.push(ps[_i]);
                //	_i++;
                //}
                return null;
            }
            
            l_points = new Array();
            r_points = new Array();      
            middle_points = new Array();      
            
            if (ps.length == 3){
            	if(ps[0].x > ps[1].x){		//如果第一点在第二点的右边，则调换一下位置
            		temp_point = ps[0];
            		ps[0] = ps[1];
            		ps[1] = temp_point;
            	}
                l_dis = SarrowUtil.getDIS(ps[1], ps[2]);					//第二点和结束点的直线距离
                c_dis = SarrowUtil.getDisToTwoPoints(ps[0],ps[2],ps[1]);	//结束点到第一点和第二点的连线的垂直距离
            	range = Math.asin(c_dis / l_dis);							//结束点与第二点的连线和第一点和第二点的连线的角度
            	point_m = new Point((ps[0].x + ps[1].x) * 0.5,(ps[0].y + ps[1].y) * 0.5);		//第一点和第二点的连线的中心点
            	if(ps[0].y != ps[1].y){
            		k = (ps[0].x - ps[1].x)/(ps[1].y - ps[0].y);     
            		point_m1 = new Point((point_m.x + 100), (point_m.y + 100 * k));          
            	} else {
            		point_m1 = new Point((point_m.x ), (point_m.y + 100 )); 
            	}
            	
	            //		point0
	            var site1:String = SarrowUtil.findSite(ps[0], ps[2], ps[1]);
	            var site2:String = SarrowUtil.findSite(point_m, ps[2], point_m1);
	            //trace("--site2--" + site2);
	            if (site1 == "right"){
	                point0 = SarrowUtil.getThreePoint(ps[0],ps[1],range,l_dis,"left");
	            } else {
	                point0 = SarrowUtil.getThreePoint(ps[0],ps[1],range,l_dis,"right");
	            }            	         	            	
                right_points = SarrowUtil.getHeanGBJ(ps[1],null,ps[2]);    //右边箭头的耳朵		right_points
	            left_points = SarrowUtil.getHeanGBJ(ps[0],null,point0);		//左边箭头的耳朵		left_points  	
                end_point = ps[2];				//结束点		end_point
                point2 = ps[1];					//第二点		point2
                point1 = ps[0];					//第一点		point1            	
	            radius = 0;
                if (site1 == "left"){			//如果结束点在第一点和第二点的连线下方
                    left_n_point = left_points[5];
                    right_n_point = right_points[1];
                    left_w_point = left_points[1];
                    right_w_point = right_points[5];
                }else {																//如果结束点在第一点和第二点的连线上方 
                    left_n_point = left_points[1];
                    left_w_point = left_points[5];
                    right_n_point = right_points[5];
                    right_w_point = right_points[1];
                }
                left_m_point = new Point((point1.x + left_n_point.x) * 0.5,(point1.y + left_n_point.y) * 0.5);
                right_m_point = new Point((point2.x + right_n_point.x) * 0.5,(point2.y + right_n_point.y) * 0.5);
                left_dis = SarrowUtil.getDIS(point1,left_n_point);
                left_angle = 0;
                right_angle = 0;
                if (left_n_point.y != point1.y && point2.y != right_n_point.y){			//如果左耳的一点和第一点不在同一水平线，并且右耳的一点和第二点不在同一水平线上
                    left_angle = Math.atan((left_n_point.x - point1.x) / (left_n_point.y - point1.y));
                    right_angle = Math.atan((point2.x - right_n_point.x) / (point2.y - right_n_point.y));
                }
                if (site1 == "right"){		//如果结束点在第一点和第二点的连线上方
                	if(left_n_point.y < point1.y){
	                    i = 0.5 * Math.PI;
	                    while (i < (Math.PI * 1.5)) {
	                        x = ((Math.abs(left_dis) * 0.08) * Math.cos(i));
	                        y = ((Math.abs(left_dis) * 0.5) * Math.sin(i));
	                        l_points.push(changePoints(x, y, left_angle, left_m_point.x, left_m_point.y));			//左边箭头的弦
	                        i = i + Math.PI * 0.025;
	                    }
                 	}else{
	                    i = -0.5 * Math.PI;
	                    while (i < Math.PI * 0.5) {
	                        x = Math.abs(left_dis) * 0.08 * Math.cos(i);
	                        y = Math.abs(left_dis) * 0.5 * Math.sin(i);
	                        l_points.push(changePoints(x, y, left_angle, left_m_point.x, left_m_point.y));		//左边箭头的弦
	                        i = i + Math.PI * 0.025;
	                    }                 		
                 	}
                    if(right_n_point.y < point2.y){
	                    i = -0.5 * Math.PI;
	                    while (i < Math.PI * 0.5) {
	                        x = Math.abs(left_dis) * 0.08 * Math.cos(i);
	                        y = Math.abs(left_dis) * 0.5 * Math.sin(i);
	                        r_points.push(changePoints(x, y, right_angle, right_m_point.x, right_m_point.y));		//右边箭头的弦
	                        i = i + Math.PI * 0.025;
	                    }
                    }else{
	                    i = 0.5 * Math.PI;
	                    while (i < (Math.PI * 1.5)) {
	                        x = ((Math.abs(left_dis) * 0.08) * Math.cos(i));
	                        y = ((Math.abs(left_dis) * 0.5) * Math.sin(i));
	                        r_points.push(changePoints(x, y, right_angle, right_m_point.x, right_m_point.y));			//右边箭头的弦
	                        i = i + Math.PI * 0.025;
	                    }                    	
                    }
                    middle_points = SarrowUtil.usebezier(left_w_point, point_m, right_w_point);			//连接左边箭头和右边箭头的三次贝塞尔曲线
                    l_points.push(left_points[1]);
                    l_points.push(left_points[2]);
                    l_points.push(left_points[3]);
                    l_points.push(left_points[4]);
                    l_points.push(left_points[5]);
                    l_points = l_points.concat(middle_points);
                    l_points.push(right_points[1]);
                    l_points.push(right_points[2]);
                    l_points.push(end_point);
                    l_points.push(right_points[4]);
                    l_points.push(right_points[5]);
                    l_points = l_points.concat(r_points);
                    l_points.push(point2);
                    l_points.push(point1);
                } else {				//如果结束点在第一点和第二点的连线下方
                	if(left_n_point.y < point1.y){
                		i = 0.5 * Math.PI;
	                    while (i > (Math.PI * -0.5)) {
	                        x = Math.abs(left_dis) * 0.08 * Math.cos(i);
	                        y = Math.abs(left_dis) * 0.5 * Math.sin(i);
	                        l_points.push(changePoints(x,y,left_angle,left_m_point.x,left_m_point.y));		//左边箭头的弦
	                        i = i - Math.PI * 0.025;
	                    }
                 	}else{
	                    i = 1.5 * Math.PI;
	                    while (i > Math.PI * 0.5) {
	                        x = Math.abs(left_dis) * 0.08 * Math.cos(i);
	                        y = Math.abs(left_dis) * 0.5 * Math.sin(i);
	                        l_points.push(changePoints(x,y,left_angle,left_m_point.x,left_m_point.y));		//左边箭头的弦
	                        i = i - Math.PI * 0.025;
	                    }	                                     		
                 	}
                 	if(right_n_point.y < point2.y){
	                    i = 1.5 * Math.PI;
	                    while (i > Math.PI * 0.5) {
	                        x = Math.abs(left_dis) * 0.08 * Math.cos(i);
	                        y = Math.abs(left_dis) * 0.5 * Math.sin(i);
	                        r_points.push(changePoints(x,y,right_angle,right_m_point.x,right_m_point.y));	//右边箭头的弦
	                        i = i - Math.PI * 0.025;
	                    }
                 	}else{
	                    i = 0.5 * Math.PI;
	                    while (i > (Math.PI * -0.5)) {
	                        x = Math.abs(left_dis) * 0.08 * Math.cos(i);
	                        y = Math.abs(left_dis) * 0.5 * Math.sin(i);
	                        r_points.push(changePoints(x,y,right_angle,right_m_point.x,right_m_point.y));	//右边箭头的弦
	                        i = i - Math.PI * 0.025;
	                    }                 		
                 	}
                    middle_points = SarrowUtil.usebezier(left_w_point, point_m, right_w_point);
                    l_points.push(left_points[5]);
                    l_points.push(left_points[4]);
                    l_points.push(left_points[3]);
                    l_points.push(left_points[2]);
                    l_points.push(left_points[1]);
                    l_points = l_points.concat(middle_points);
                    l_points.push(right_points[5]);
                    l_points.push(right_points[4]);
                    l_points.push(end_point);
                    l_points.push(right_points[2]);
                    l_points.push(right_points[1]);
                    l_points = l_points.concat(r_points);
                    l_points.push(point2);
                    l_points.push(point1);
                }
                rs = l_points;
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