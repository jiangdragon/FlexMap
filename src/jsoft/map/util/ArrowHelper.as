package jsoft.map.util
{
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import jsoft.map.geometry.Line;
	
	public class ArrowHelper
	{
		private var g:Graphics;
		private var color:int;
		private var width:int;
		private var pointArray:Array = new Array();
		private var arrow:Array = new Array();
		private var errArray:Array=new Array();
		
		public function ArrowHelper(g:Graphics,color:int,width:int) {
			this.g = g;
			this.color = color;
			this.width = width;
		}
		public function createHelper():ArrowHelper {
			var arrow:ArrowHelper = new ArrowHelper(g,color,width);
			return arrow;
		}
		public function clear():void {
			g.clear();
		}
		public function addPoint(x:int,y:int):void {
			var point:Point = new Point(x,y);
			pointArray.push(point);
		}
		public function addPointEx(x1:int,y1:int,x2:int,y2:int):void {
			addPoint(x1,y1);
			addPoint(x2,y2);
		}
		public function addPoints(xAry:Array,yAry:Array):void {
			for(var i:int=0;xAry!=null&&i<xAry.length;i++) {
				addPoint(xAry[i],yAry[i]);
			}
		}
		public function addPointsEx(xAry:Array,yAry:Array,offsetx:int,offsety:int):void {
			for(var i:int=0;xAry!=null&&i<xAry.length;i++) {
				addPoint(xAry[i]+offsetx,yAry[i]+offsety);
			}
		}
		private function removePoint(pos:int):void{
			if(pointArray.length>1){
				for(var i:int=pos+1;i<pointArray.length;i++){
					pointArray[i-1]=pointArray[i];
					arrow[i-2]=arrow[i-1];
				}
				pointArray.pop();
				arrow.pop();
			}
		}
		private function insertPoint(pos1:int,pos2:int):void{
			var point:Point=pointArray[pos2];
			var line:Line=arrow[pos2-1];
			for(var i:int=pos2;i>pos1;i--){
				pointArray[i]=pointArray[i-1];
				arrow[i-1]=arrow[i-2];
			}
			pointArray[pos1]=point;
			arrow[pos1-1]=line;
		}
		public function draw():void {
			buildArrow();
			linkArrow();
			drawArrow();
		}
		private function sortPoint():void {
			for(var i:int=1;pointArray!=null&&i<pointArray.length;i++) {
				var p1:Point = pointArray[i];
				for(var j:int=i+1;pointArray!=null&&j<pointArray.length;j++) {
					var p2:Point = pointArray[j];
					if(p2.x < p1.x) {
						pointArray[i] = p2;
						pointArray[j] = p1;
						p1 = p2;
					}
				}
			}
		}
		private function buildArrow():void {
			for(var i:int=1;pointArray!=null&&i<pointArray.length;i++) {
				var line:Line = getArrowLine(pointArray[0],pointArray[i]);
				arrow.push(line);
			}
		}
		private function linkArrow():void {
			var i:int,j:int;
			for(i=2;i<pointArray.length;i++){
				var center:Point=new Point(pointArray[0].x,-pointArray[0].y);
				for(j=1;j<i;j++){
					var temp1:Array,temp2:Array,temp3:Array,interPoint:Array;
					var start:Point=new Point(pointArray[j].x,-pointArray[j].y);
					var end:Point=new Point(pointArray[i].x,-pointArray[i].y);
					var b:Array=judgeSide(center,start,end);
					temp1=calcPoint(pointArray[0],pointArray[j]);
					temp2=calcPoint(pointArray[0],pointArray[i]);
					var line1:Line=arrow[j-1];
					var line2:Line=arrow[i-1];
					if(b[0]<0){
						break;
					}
				}
				if(i!=j){//交叉
					if(j!=1){//在1的右边
						var interPoint1:Array=new Array();
						temp1=calcPoint(pointArray[0],pointArray[j-1]);
						temp2=calcPoint(pointArray[0],pointArray[i]);
						b=judgeSide(center,temp1[4],temp2[4]);
						interPoint=interSection(temp1[6],temp1[7],temp1[8],temp2[0],temp2[1],temp2[2]);
						if(b[1]<90&&interPoint.length!=3){//第一次无交点
							removePoint(i);
							i--;
						}
						if(b[1]>90&&interPoint.length!=3){//第一次无交点
							temp3=calcPoint(pointArray[0],pointArray[j]);
							b=judgeSide(center,temp2[4],temp3[4]);
							interPoint=interSection(temp2[6],temp2[7],temp2[8],temp3[0],temp3[1],temp3[2]);
							if(b[1]<90&&interPoint.length!=3){//第二次无交点
								removePoint(i);
								i--;
							}
							if(b[1]>90&&interPoint.length!=3){//第二次无交点
								arrow[j-2].setPoint(8,temp2[0].x,temp2[0].y);
								arrow[i-1].setPoint(8,temp3[0].x,temp3[0].y);
								insertPoint(j,i);//还要处理，交换位置
							}
							if(interPoint.length==3){//第二次有交点
								arrow[j-2].setPoint(8,temp2[0].x,temp2[0].y);
								arrow[i-1].setPoint(8,interPoint[2].x,interPoint[2].y);
								arrow[j-1].setPoint(0,interPoint[2].x,interPoint[2].y);
								insertPoint(j,i);//还要处理，交换位置
							}	
						}
						if(interPoint.length==3){//第一次有交点
							temp3=calcPoint(pointArray[0],pointArray[j]);
							b=judgeSide(center,temp2[4],temp3[4]);
							interPoint1=interSection(temp2[6],temp2[7],temp2[8],temp3[0],temp3[1],temp3[2]);
							if(b[1]<90&&interPoint1.length!=3){//第二次无交点
								removePoint(i);
								i--;
							}
							if(b[1]>90&&interPoint1.length!=3){//第二次无交点
								arrow[j-2].setPoint(8,interPoint[2].x,interPoint[2].y);
								arrow[i-1].setPoint(0,interPoint[2].x,interPoint[2].y);
								arrow[i-1].setPoint(8,temp3[0].x,temp3[0].y);
								insertPoint(j,i);//还要处理，交换位置
							}
							if(interPoint1.length==3){//第二次有交点
								arrow[j-2].setPoint(8,interPoint[2].x,interPoint[2].y);
								arrow[i-1].setPoint(0,interPoint[2].x,interPoint[2].y);
								arrow[i-1].setPoint(8,interPoint1[2].x,interPoint1[2].y);
								arrow[j-1].setPoint(0,interPoint1[2].x,interPoint1[2].y);
								insertPoint(j,i);//还要处理，交换位置
							}
						}
					}else{//在1的左边
						interPoint=interSection(temp2[6],temp2[7],temp1[8],temp1[0],temp1[1],temp1[2]);
						if(b[1]<90&&interPoint.length!=3){
							removePoint(i);
							i--;
						}
						if(b[1]>90&&interPoint.length!=3){
							arrow[i-1].setPoint(8,temp1[0].x,temp1[0].y);
							insertPoint(j,i);
						}
						if(interPoint.length==3){
							arrow[i-1].setPoint(8,interPoint[2].x,interPoint[2].y);
							arrow[j-1].setPoint(0,interPoint[2].x,interPoint[2].y);
							insertPoint(j,i);
						}
					}
				}else{//不交叉
					interPoint=interSection(temp1[6],temp1[7],temp1[8],temp2[0],temp2[1],temp2[2]);
					if(b[1]<90&&interPoint.length!=3){
						removePoint(i);
						i--;
					}
					if(b[1]>90&&interPoint.length!=3){
						line1.setPoint(8,temp2[0].x,temp2[0].y);
					}
					if(interPoint.length==3){
						line1.setPoint(8,interPoint[2].x,interPoint[2].y);
						line2.setPoint(0,interPoint[2].x,interPoint[2].y);
					}
				}
			}
		}
		private function drawArrow():void {
			g.clear();
			var endPoint:Point = pointArray[0];
			for(var i:int=0;arrow!=null&&i<arrow.length;i++) {
				var line:Line = arrow[i];
				var startPoint:Point = pointArray[i+1];
				var colors:Array = [color,0xffffff];
    			var alphas:Array = [0.1, 1];
				var ratios:Array = [0x00, 0xFF];
				var matrix:Matrix = new Matrix();
				var r:Number = Math.sqrt((endPoint.y - startPoint.y)*(endPoint.y - startPoint.y)+(endPoint.x - startPoint.x)*(endPoint.x - startPoint.x));
				var angle:Number = Math.acos(Math.abs(endPoint.x - startPoint.x)/r);
				var rotation:Number = 0;
				if(endPoint.y >= startPoint.y && endPoint.x >= startPoint.x) {
					if(angle < Math.PI / 4) {
						rotation = 0;
					} else {
						rotation = Math.PI / 2;
					}
				}
				if(endPoint.y >= startPoint.y && endPoint.x <= startPoint.x) {
					if(angle < Math.PI / 4) {
						rotation = Math.PI;
					} else {
						rotation = Math.PI / 2;
					}
				}
				if(endPoint.y <= startPoint.y && endPoint.x >= startPoint.x) {
					if(angle < Math.PI / 4) {
						rotation = 0;
					} else {
						rotation = -Math.PI / 2;
					}
				}
				if(endPoint.y <= startPoint.y && endPoint.x <= startPoint.x) {
					if(angle < Math.PI / 4) {
						rotation = Math.PI;
					} else {
						rotation = -Math.PI / 2;
					}
				}
				
				var tx:Number = endPoint.x > startPoint.x ? startPoint.x : endPoint.x;
				var ty:Number = endPoint.y > startPoint.y ? startPoint.y : endPoint.y;
				//trace("rotation="+rotation);
				matrix.createGradientBox(Math.abs(endPoint.x-startPoint.x), Math.abs(endPoint.y-startPoint.y), rotation, tx, ty);
				var spreadMethod:String = SpreadMethod.PAD;
				g.lineStyle(width,color,0);
				g.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix,spreadMethod);
				drawLine(line);
				g.endFill();
				g.lineStyle(width,color);
				drawLine(line);
			}
		}
		private function drawLine(line:Line):void {
			for(var j:int=0;j<line.getPointLength();j++) {
				var x:Number = line.getXArray()[j];
				var y:Number = line.getYArray()[j];
				if(j==0) {
					g.moveTo(x,-y);
				} else {
					g.lineTo(x,-y);
				}
			}
		}
		private function getArrowLine(p1:Point,p2:Point):Line {
			var ret:Array = calcPoint(p1,p2);
			var line:Line = new Line();
			for(var i:int=0;i<ret.length;i++) {
				var point:Point = ret[i];
				line.addPoint(point.x,point.y);
			}
			return line;
		}
		//计算箭头九个点，参数是经纬度，中间处理是像素，最后返回是地理信息
		private function calcPoint(startPoint:Point,endPoint:Point):Array{
			var x:Number,y:Number;
			var rad:Number,rad1:Number,rad2:Number,rad3:Number;
			var L:Number,Xline0:Number,Xline1:Number,Xline2:Number,Xline3:Number;
			var start:Point=new Point(startPoint.x,-startPoint.y);//将要对startPoint、endPoint进行转化
			var end:Point=new Point(endPoint.x,-endPoint.y);
			var point:Point;
			var points:Array=new Array();
			rad=Math.atan2(end.y-start.y,end.x-start.x);
			L=Math.sqrt(Math.pow(end.x-start.x,2)+Math.pow(end.y-start.y,2));
			if(L<81){
				Xline0=L*8/40;
				Xline1=Math.sqrt(Math.pow(L*14/20,2)+Math.pow(L*3/40,2));
				Xline2=Math.sqrt(Math.pow(L*13/20,2)+Math.pow(L*9/40,2));
				Xline3=Math.sqrt(Math.pow(L/2,2)+Math.pow(L*7/80,2));//新加的點
				rad1=Math.atan((3/40)/(14/20));
				rad2=Math.atan((9/40)/(13/20));
				rad3=Math.atan((7/80)/(1/2));//新加的點的角度
			}else{
				Xline0=81*8/40;
				Xline1=Math.sqrt(Math.pow(L-81*6/20,2)+Math.pow(81*3/40,2));
				Xline2=Math.sqrt(Math.pow(L-81*7/20,2)+Math.pow(81*9/40,2));
				Xline3=Math.sqrt(Math.pow(L/2,2)+Math.pow(81*7/80,2));//新加的點
				rad1=Math.atan((81*3/40)/(L-81*6/20));
				rad2=Math.atan((81*9/40)/(L-81*7/20));
				rad3=Math.atan((81*7/80)/(L/2));//新加的點的角度
			}
			//第一个点
			x=start.x+Math.cos(rad+Math.PI/2)*Xline0;
			y=start.y+Math.sin(rad+Math.PI/2)*Xline0;
			point=new Point(x,y)//将要把像素转专经纬度
			points.push(point);
        	//新加點
       		x=start.x+Math.cos(rad+rad3)*Xline3;
        	y=start.y+Math.sin(rad+rad3)*Xline3;
			point=new Point(x,y)//将要把像素转专经纬度
			points.push(point);
        	//第二个点
        	x=start.x+Math.cos(rad+rad1)*Xline1;
			y=start.y+Math.sin(rad+rad1)*Xline1;
			point=new Point(x,y)//将要把像素转专经纬度
			points.push(point);
        	//第三个点
        	x=start.x+Math.cos(rad+rad2)*Xline2;
			y=start.y+Math.sin(rad+rad2)*Xline2;
			point=new Point(x,y)//将要把像素转专经纬度
			points.push(point);
        	//第四个点
        	x=start.x+Math.cos(rad)*L;
			y=start.y+Math.sin(rad)*L;
			point=new Point(x,y)//将要把像素转专经纬度
			points.push(point);
        	//第五个点
        	x=start.x+Math.cos(rad-rad2)*Xline2;
			y=start.y+Math.sin(rad-rad2)*Xline2;
			point=new Point(x,y)//将要把像素转专经纬度
			points.push(point);
        	//第六个点
        	x=start.x+Math.cos(rad-rad1)*Xline1;
			y=start.y+Math.sin(rad-rad1)*Xline1;
			point=new Point(x,y)//将要把像素转专经纬度
			points.push(point);
        	//新加點
        	x=start.x+Math.cos(rad-rad3)*Xline3;
			y=start.y+Math.sin(rad-rad3)*Xline3;
			point=new Point(x,y)//将要把像素转专经纬度
			points.push(point);
        	//第七个点
        	x=start.x+Math.cos(rad+Math.PI*3/2)*Xline0;
			y=start.y+Math.sin(rad+Math.PI*3/2)*Xline0;
			point=new Point(x,y)//将要把像素转专经纬度
			points.push(point);
        	return points;
		}
		//获取扫描角
		private function getAngle(point:Point,centerPoint:Point):Number{
			//比atan更好确定象限
			var angle:Number;
			angle=Math.atan2(point.y-centerPoint.y,point.x-centerPoint.x);
			if(angle<0){
				angle=angle+2*Math.PI;
			}
			angle=angle*180/Math.PI;
			return angle;
		}
		//获取两点间距离或半径
		private function getCenterR(startPoint:Point,endPoint:Point):Number{
			var R:Number;
			R=Math.sqrt(Math.pow(startPoint.x-endPoint.x,2)+Math.pow(startPoint.y-endPoint.y,2));
			return R;
		}
		//获取中心点
		private function getCenterPoint(startPoint:Point,secondPoint:Point,endPoint:Point):Point{
			var tempA1:Number,tempA2:Number,tempB1:Number,tempB2:Number;
			var tempC1:Number,tempC2:Number,temp:Number,x:Number,y:Number;
			
			tempA1=startPoint.x-secondPoint.x;
        	tempB1=startPoint.y-secondPoint.y;
        	tempC1=(Math.pow(startPoint.x,2)-Math.pow(secondPoint.x,2)+Math.pow(startPoint.y,2)-Math.pow(secondPoint.y,2))/2;
        
        	tempA2=endPoint.x-secondPoint.x;
        	tempB2=endPoint.y-secondPoint.y;
        	tempC2=(Math.pow(endPoint.x,2)-Math.pow(secondPoint.x,2)+Math.pow(endPoint.y,2)-Math.pow(secondPoint.y,2))/2;
        	temp=tempA1*tempB2-tempA2*tempB1;
        	if(temp==0){
        		x=startPoint.x;
            	y=startPoint.y;
        	}else{
        		x=(tempC1*tempB2-tempC2*tempB1)/temp;
            	y=(tempA1*tempC2-tempA2*tempC1)/temp;
        	}
        	return new Point(x,y);
		}
		//求两弧交点，有交点数组长度为3，没有交点长度为2
		private function interSection(point1:Point,point2:Point,point3:Point,point4:Point,point5:Point,point6:Point):Array{
			var center1:Point,center2:Point;
			var L:Number,r1:Number,r2:Number,x:Number,y:Number;
			var angle1:Number,angle2:Number,angle3:Number;
			var pointInter1:Point,pointInter2:Point,interSectPoint:Point;
			var points:Array=new Array();
			center1=this.getCenterPoint(point1,point2,point3);
			center2=this.getCenterPoint(point4,point5,point6);
			points.push(center1);
			points.push(center2);
			L=this.getCenterR(center1,center2);//其实是求两圆心的长
			r1=this.getCenterR(point1,center1);
			r2=this.getCenterR(point4,center2);
			angle1=Math.acos((Math.pow(r2,2)+Math.pow(L,2)-Math.pow(r1,2))/(2*r2*L));
			angle2=Math.atan2(center1.y-center2.y,center1.x-center2.x);
			if(L==(r1+r2)){//兩圓相切,只有一個交點
				x=center2.x+Math.cos(angle2*Math.PI/180)*r2;
				y=center2.y+Math.cos(angle2*Math.PI/180)*r2;
				points.push(new Point(x,y));
			}
			if(L>(r1+r2)){//兩圓相離，無交點
			}
			if(L<(r1+r2)){//兩圓相交，兩交點
				x=center2.x+Math.cos(angle2-angle1)*r2;
				y=center2.y+Math.sin(angle2-angle1)*r2;
				pointInter1=new Point(x,y);//上边的
				x=center2.x+Math.cos(angle2+angle1)*r2;
				y=center2.y+Math.sin(angle2+angle1)*r2;
				pointInter2=new Point(x,y);//下边的
				//判斷點在弧上
				var t1:Boolean=this.judgeAtCurve(point6,point4,pointInter1,center2);
				var t2:Boolean=this.judgeAtCurve(point3,point1,pointInter1,center1);
				var t3:Boolean=this.judgeAtCurve(point6,point4,pointInter2,center2);
				var t4:Boolean=this.judgeAtCurve(point3,point1,pointInter2,center1);
				if(t1&&t2){//選擇第一個交點
					points.push(pointInter1);
				}
				if(t3&&t4){//選擇第二個交點
					points.push(pointInter2);
				}
				
			}
			return points;//兩交點都不是求的交點
		}
		//判斷點是否在弧上，返回一个真、假
		private function judgeAtCurve(startPoint:Point,endPoint:Point,point:Point,centerPoint:Point):Boolean{
			var startAngle:Number,endAngle:Number,interAngle:Number,t:Boolean=false;
			startAngle=this.getAngle(startPoint,centerPoint);
			endAngle=this.getAngle(endPoint,centerPoint);
			interAngle=this.getAngle(point,centerPoint);//交点
			if(startAngle>endAngle){
				if((startAngle>=interAngle)&&(interAngle>=endAngle)){
					t=true;
				}
			}else{
				if((startAngle>=interAngle)||(interAngle>=endAngle)){
					t=true;
				}
			}
			return t;
		}
		//判断点在线的左右边及夹角，左右用正负表示
		private function judgeSide(center:Point,start:Point,end:Point):Array{
			//笛卡尔坐标系
			var point0:Point,point1:Point,point2:Point;
			var a:Number,b:Number,c:Number,d:Number,angle:Number;
			point0=center;//将要把经纬度转化成像素
			point1=start;//将要把经纬度转化成像素
			point2=end;//将要把经纬度转化成像素
			a=point1.y-point0.y;
			b=point0.x-point1.x;
			c=point1.x*point0.y-point0.x*point1.y;
			d=a*point2.x+b*point2.y+c;
			//d=(point1.x-point0.x)*(point2.y-point0.y)-(point1.y-point0.y)*(point2.x-point0.x);
			a=Math.sqrt(Math.pow(point2.y-point0.y,2)+Math.pow(point2.x-point0.x,2));
			b=Math.sqrt(Math.pow(point1.y-point0.y,2)+Math.pow(point1.x-point0.x,2));
			c=Math.sqrt(Math.pow(point2.y-point1.y,2)+Math.pow(point2.x-point1.x,2));
			angle=Math.acos((Math.pow(a,2)+Math.pow(b,2)-Math.pow(c,2))/(2*a*b));
			angle=angle*180/Math.PI;
			return new Array(d,angle);//d>0右边,d<0左边
		}

	}
}