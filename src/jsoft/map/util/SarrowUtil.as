package jsoft.map.util
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class SarrowUtil
	{
		public function SarrowUtil()
		{
		}
		/**
		 * 获取第三个点
		 * 
		 * 返回 Point
		*/
		public static function getThreePoint(st_point:Point,end_point:Point,angle:Number,d:Number,direction:String):Point{
			var xa:Number = end_point.x;
            var ya:Number = end_point.y;
            var xb:Number = st_point.x;
            var yb:Number = st_point.y;
            var kab:Number = Math.atan(((ya - yb) / (xa - xb)));
            var xbc:Number = 0;
            var ybc:Number = 0;
            if("left" == direction){
            	angle = (Math.PI - angle);
            	if(xa < xb){
            		xbc = (xb + (d * Math.cos((kab + angle))));
                    ybc = (yb + (d * Math.sin((kab + angle))));
            	}else if(xa >= xb){
           			xbc = (xb - (d * Math.cos((kab + angle))));
                	ybc = (yb - (d * Math.sin((kab + angle))));
            	}
            }else if("right" == direction){
            	angle = (Math.PI + angle);
            	if(xa < xb){
       				xbc = (xb + (d * Math.cos((kab + angle))));
                    ybc = (yb + (d * Math.sin((kab + angle))));
            	}else if(xa >= xb){
            		xbc = (xb - (d * Math.cos((kab + angle))));
            		ybc = (yb - (d * Math.sin((kab + angle))));
            	}
            }
            return new Point(xbc,ybc);
		}
		/**
		 * 获取两点间矩离
		 * 
		 * 参数说明
		 * startp 开始点 
		 * endp 结束点
		 * 
		 * 返回 Number  
		*/
		public static function getDIS(startp:Point,endp:Point):Number{
			var dis:Number = 0;
			dis = Math.sqrt((Math.pow((endp.x - startp.x), 2) + Math.pow((endp.y - startp.y), 2)));
			return dis;
		}
		
		public static function makeMiddlePoints(points:Array,equal:Boolean=false,tailsarrow:Boolean=false):Array{
			var points_num:Number = points.length;
			var sum_l:Number = 0;
			var i:int = 0;
			while(i < (points_num - 1)){
				sum_l = sum_l + getDIS(points[i],points[i+1]);
				i++;
			}
			var n_points:Array = new Array();
			var m_points:Array = useNbezier(points);
			m_points.push(sum_l);
			n_points = drawLRCurves(m_points,equal,tailsarrow)
			return n_points;
		}
		/**
		 * N阶曲线
		 * 
		 * 返回 Array
		*/
		public static function useNbezier(ps:Array):Array{
			var x:Number;
			var y:Number;
			if(ps.length <= 2){
				return ps;
			}
			var n:int = ps.length;
			var sum_n:int = 10 * (n - 1);
			var rs:Array = new Array();
			var i:Number = 0;
			while((i < 1) || (i == 1)){
				x = 0;
				y = 0;
				var j:int = 0;
				while(j < n){
					x = x + getRount(j,n) * Math.pow(1-i,n-1-j) * Math.pow(i,j) * ps[j].x;
					y = y + getRount(j,n) * Math.pow(1-i,n-1-j) * Math.pow(i,j) * ps[j].y;
					j++;
				}
				rs.push(new Point(x,y));
				i = i + 1 / sum_n;
			}
			rs.push(ps[(n - 1)]);
			return rs;
		}
		/**
		 * 返回 Number
		*/
		public static function getRount(i:int,n:int):Number{
			if((n < 2) || (i == 0)){
				return 1;
			}
			n--;
			var sum_i:Number = 1;
			var j:int = 1;
			while(j < (i + 1)){
				sum_i = sum_i * j;
				j++;
			}
			var sum_n:Number = 1;
			var k:int = n - i + 1;
			while(k < (n + 1)){
				sum_n = sum_n * k;
				k++;
			}
			return sum_n / sum_i;
		}
		/**
		 * 绘左边曲线
		 * 返回 Array
		*/
		public static function drawLRCurves(curvepoints:Array,equal:Boolean,tailsarrow:Boolean=false):Array{
            var m_point:Point;
            var pos_x:Number;
            var pos_y:Number;
            var pre_point:Point;
            var pre_pos_x:Number;
            var pre_pos_y:Number;
            var slope:Number;
            var bb:Number;
            var cos_number:Number;
            var sin_number:Number;
            var bottom_pos_x:Number;
            var bottom_pos_y:Number;
            var left_points:Array = new Array();
            var right_points:Array = new Array();
            var c_length:Number = curvepoints.length;
            var dis:Number = curvepoints[(c_length - 1)];
            dis = (dis / 15);
            curvepoints.splice((c_length - 1), 1);
            var top_pos_x:Number = 0;
            var top_pos_y:Number = 0;
            var u:Number = 1;
            while (u < (c_length - 1)) {
                m_point = curvepoints[u];
                pos_x = m_point.x;
                pos_y = m_point.y;
                pre_point = curvepoints[(u - 1)];
                pre_pos_x = pre_point.x;
                pre_pos_y = pre_point.y;
                slope = (pos_y - pre_pos_y) / (pos_x - pre_pos_x);
                if (!equal){
                    bb = dis * (1 - ((u / c_length) * 0.9));
                } else {
                    bb = dis / 2;
                };
                cos_number = Math.cos((Math.atan(slope) - (Math.PI / 2)));
                sin_number = Math.sin((Math.atan(slope) - (Math.PI / 2)));
                if ((pre_pos_x <= pos_x) && (pre_pos_y <= pos_y)){
                    top_pos_x = pre_pos_x + (bb * cos_number < 0 ? -bb * cos_number : bb * cos_number);
                    top_pos_y = pre_pos_y - (bb * sin_number < 0 ? -bb * sin_number : bb * sin_number);
                } else {
                    if ((pre_pos_x <= pos_x) && (pre_pos_y > pos_y)){
                        top_pos_x = pre_pos_x - (bb * cos_number < 0 ? -bb * cos_number : bb * cos_number);
                        top_pos_y = pre_pos_y - (bb * sin_number < 0 ? -bb * sin_number : bb * sin_number);
                    } else {
                        if ((pre_pos_x >= pos_x) && (pre_pos_y >= pos_y)){
                            top_pos_x = pre_pos_x - (bb * cos_number < 0 ? -bb * cos_number : bb * cos_number);
                            top_pos_y = pre_pos_y + (bb * sin_number < 0 ? -bb * sin_number : bb * sin_number);
                        } else {
                            if ((pre_pos_x >= pos_x) && (pre_pos_y <= pos_y)){
                                top_pos_x = pre_pos_x + (bb * cos_number < 0 ? -bb * cos_number : bb * cos_number);
                                top_pos_y = pre_pos_y + (bb * sin_number < 0 ? -bb * sin_number : bb * sin_number);
                            };
                        };
                    };
                };
                left_points.push(new Point(top_pos_x, top_pos_y));
                if ((pre_pos_x <= pos_x) && (pre_pos_y <= pos_y)){
                    bottom_pos_x = pre_pos_x - (bb * cos_number < 0 ? -bb * cos_number : bb * cos_number);
                    bottom_pos_y = pre_pos_y + (bb * sin_number < 0 ? -bb * sin_number : bb * sin_number);
                } else {
                    if ((pre_pos_x <= pos_x) && (pre_pos_y > pos_y)){
                        bottom_pos_x = pre_pos_x + (bb * cos_number < 0 ? -bb * cos_number : bb * cos_number);
                        bottom_pos_y = pre_pos_y + (bb * sin_number < 0 ? -bb * sin_number : bb * sin_number);
                    } else {
                        if ((pre_pos_x >= pos_x) && (pre_pos_y >= pos_y)){
                            bottom_pos_x = pre_pos_x + (bb * cos_number < 0 ? -bb * cos_number : bb * cos_number);
                            bottom_pos_y = pre_pos_y - (bb * sin_number < 0 ? -bb * sin_number : bb * sin_number);
                        } else {
                            if ((pre_pos_x >= pos_x) && (pre_pos_y <= pos_y)){
                                bottom_pos_x = pre_pos_x - (bb * cos_number < 0 ? -bb * cos_number : bb * cos_number);
                                bottom_pos_y = pre_pos_y - (bb * sin_number < 0 ? -bb * sin_number : bb * sin_number);
                            };
                        };
                    };
                };
                right_points.push(new Point(bottom_pos_x, bottom_pos_y));
                u++;
            };
            var leftpoint:Point = sarrowALG(left_points[(left_points.length - 2)], curvepoints[(curvepoints.length - 1)], "left", dis);
            var rightpoint:Point = sarrowALG(right_points[(right_points.length - 2)], curvepoints[(curvepoints.length - 1)], "right", dis);
            left_points.splice((left_points.length - 1), 1);
            left_points.push(leftpoint);
            left_points.push(curvepoints[(curvepoints.length - 1)]);
            right_points.splice((right_points.length - 1), 1);
            left_points.push(rightpoint);
            var rlength:Number = right_points.length;
            var k:int = (rlength - 1);
            while (k > 0) {
                left_points.push(right_points[k]);
                k--;
            };
            if (tailsarrow){
                left_points.push(curvepoints[4]);
            };
            left_points.push(left_points[0]);
			return left_points;
		}
		/**
		 * 获取第三点
		 * 返回Point
		*/
		public static function sarrowALG(st_point:Point,end_point:Point,direction:String,d:Number):Point{
			var angle:Number = (Math.PI * 0.7);
            var dir_w3_p:Point = getThreePoint(st_point, end_point, angle, d, direction);
            return dir_w3_p;
		}
		/**
		 * 
		 * 
		 */
		public static function getHeanGBJ(st_point:Point, middle_point:Point, end_point:Point):Array{
			var left_2_point:Point;
            var right_2_point:Point;
            var points:Array = new Array();
            var dis:Number = getDIS(st_point, end_point);
            var bottom_d:Number = (dis / 5);
            var top_x:Number = (dis / 4);
            var angle:Number = (Math.PI / 12);
            var b_angle:Number = (Math.PI / 8);
            var top_d:Number = (((Math.tan(angle) * top_x) / (Math.tan(angle) + Math.tan(b_angle))) / Math.cos(b_angle));
            var left_1_point:Point = new Point();
            var right_1_point:Point = new Point();
            var left_w3_point:Point = new Point();
            var left_n3_point:Point = new Point();
            var top_3_point:Point = new Point();
            var right_w3_point:Point = new Point();
            var right_n3_point:Point = new Point();
            left_1_point = getThreePoint(st_point, end_point, (Math.PI / 2), bottom_d, "left");
            right_1_point = getThreePoint(st_point, end_point, (Math.PI / 2), bottom_d, "right");
            if (middle_point == null){
                left_w3_point = getThreePoint(end_point, left_1_point, angle, top_x, "right");
                left_n3_point = getThreePoint(left_w3_point, end_point, b_angle, top_d, "right");
                right_w3_point = getThreePoint(end_point, right_1_point, angle, top_x, "left");
                right_n3_point = getThreePoint(right_w3_point, end_point, b_angle, top_d, "left");
            } else {
                dis = getDIS(st_point, middle_point) + getDIS(middle_point, end_point) / 2;
                bottom_d = (dis / 5);
                top_x = (dis / 5);
                top_d = (((Math.tan(angle) * top_x) / (Math.tan(angle) + Math.tan(b_angle))) / Math.cos(b_angle));
                left_2_point = getThreePoint(middle_point, end_point, (Math.PI / 2), bottom_d, "left");
                right_2_point = getThreePoint(middle_point, end_point, (Math.PI / 2), bottom_d, "right");
                left_w3_point = getThreePoint(end_point, left_2_point, angle, top_x, "right");
                left_n3_point = getThreePoint(left_w3_point, end_point, b_angle, top_d, "right");
                right_w3_point = getThreePoint(end_point, right_2_point, angle, top_x, "left");
                right_n3_point = getThreePoint(right_w3_point, end_point, b_angle, top_d, "left");
            };
            points.push(left_1_point);
            points.push(left_n3_point);
            points.push(left_w3_point);
            points.push(end_point);
            points.push(right_w3_point);
            points.push(right_n3_point);
            points.push(right_1_point);
            return points;
		}
		/**
		 * 获取一个矩形框
		 * 返回Rectangle
		 */
		public static function createRectangle(points:Array):Rectangle{
			var width:Number;
            var height:Number;
            var xs:Array = [];
            var ys:Array = [];
            var n:int = points.length;
            var i:int;
            while (i < n) {
                xs.push(points[i].x);
                ys.push(points[i].y);
                i++;
            };
            xs.sort(Array.NUMERIC, Array.DESCENDING);
            ys.sort(Array.NUMERIC, Array.DESCENDING);
            width = (xs[0] - xs[(n - 1)]);
            height = (ys[0] - ys[(n - 1)]);
            return new Rectangle(xs[(n - 1)], ys[(n - 1)], width, height);
		}
		/**
		 * 
		 * 
		 */
		public static function drawXMiddleCurves(ps:Array):Array{
            var points:Array = new Array();
            var n:Number = ps.length;
            var st_point:Point = ps[(n - 3)];
            var end_point:Point = ps[(n - 1)];
            var middle_point:Point = ps[(n - 2)];
            var z_points:Array = getHeanGBJ(st_point, middle_point, end_point);
            var left_point:Point = z_points[0];
            var top_nleft_point:Point = z_points[1];
            var top_wleft_point:Point = z_points[2];
            var top_wright_point:Point = z_points[4];
            var top_nright_point:Point = z_points[5];
            var right_point:Point = z_points[6];
            var left_ps:Array = usebezier(left_point, middle_point, top_nleft_point);
            var right_ps:Array = usebezier(top_nright_point, middle_point, right_point);
            points.push(st_point);
            var i:Number = 0;
            while (i < left_ps.length) {
                points.push(left_ps[i]);
                i++;
            };
            points.push(top_nleft_point);
            points.push(top_wleft_point);
            points.push(end_point);
            points.push(top_wright_point);
            points.push(top_nright_point);
            var j:Number = 0;
            while (j < right_ps.length) {
                points.push(right_ps[j]);
                j++;
            };
            points.push(st_point);
            return points;
		}
		/**
		 * 三次贝赛尔曲线
		 * 返回Array
		 */
		public static function usebezier(st_point:Point,middle_point:Point,end_point:Point):Array{
			var pos_x:Number;
            var pos_y:Number;
            var ps:Array = new Array();
            var j:Number = 0;
            while (j <= 1) {
                pos_x = (((Math.pow((1 - j), 2) * st_point.x) + (((2 * j) * (1 - j)) * middle_point.x)) + (Math.pow(j, 2) * end_point.x));
                pos_y = (((Math.pow((1 - j), 2) * st_point.y) + (((2 * j) * (1 - j)) * middle_point.y)) + (Math.pow(j, 2) * end_point.y));
                ps.push(new Point(pos_x, pos_y));
                j = (j + 0.05);
            }
            return ps;
		}
		/**
		 * 四次贝赛尔曲线
		 * 返回Array
		 */
		public static function useFourBezier(st_1_p:Point,st_2_p:Point,st_3_p:Point,st_4_p:Point):Array{
			var pos_x:Number;
            var pos_y:Number;
            var four_array:Array = new Array();
            var k:Number = 0;
            while (k <= 1) {
                pos_x = ((((st_1_p.x * Math.pow((1 - k), 3)) + (((3 * st_2_p.x) * k) * Math.pow((1 - k), 2))) + (((3 * st_3_p.x) * Math.pow(k, 2)) * (1 - k))) + (st_4_p.x * Math.pow(k, 3)));
                pos_y = ((((st_1_p.y * Math.pow((1 - k), 3)) + (((3 * st_2_p.y) * k) * Math.pow((1 - k), 2))) + (((3 * st_3_p.y) * Math.pow(k, 2)) * (1 - k))) + (st_4_p.y * Math.pow(k, 3)));
                four_array.push(new Point(pos_x, pos_y));
                k = (k + 0.05);
            };
            return four_array;
		}
		/**
		 * 五次贝赛尔曲线
		 * 返回Array
		 */
		public static function useFiveBezier(st_1_p:Point,st_2_p:Point,st_3_p:Point,st_4_p:Point,st_5_p:Point):Array{
			var pos_x:Number;
            var pos_y:Number;
            var five_array:Array = new Array();
            var k:Number = 0;
            while (k <= 1) {
                pos_x = (((((st_1_p.x * Math.pow((1 - k), 4)) + (((4 * st_2_p.x) * k) * Math.pow((1 - k), 3))) + (((6 * st_3_p.x) * Math.pow(k, 2)) * Math.pow((1 - k), 2))) + (((4 * st_4_p.x) * Math.pow(k, 3)) * (1 - k))) + (st_5_p.x * Math.pow(k, 4)));
                pos_y = (((((st_1_p.y * Math.pow((1 - k), 4)) + (((4 * st_2_p.y) * k) * Math.pow((1 - k), 3))) + (((6 * st_3_p.y) * Math.pow(k, 2)) * Math.pow((1 - k), 2))) + (((4 * st_4_p.y) * Math.pow(k, 3)) * (1 - k))) + (st_5_p.y * Math.pow(k, 4)));
                five_array.push(new Point(pos_x, pos_y));
                k = (k + 0.02);
            }
            return five_array;
		}
		/**
		 * 
		 * 返回Number
		 */
		public static function getDisToTwoPoints(st_point:Point,m_point:Point,end_point:Point):Number{
			var k:Number = (end_point.y - st_point.y) / (end_point.x - st_point.x);
            var c:Number = st_point.y - k * st_point.x;
            var dis:Number = Math.abs(k * m_point.x - m_point.y + c) / Math.sqrt(k * k + 1);
            return dis;
		}
		/**
		 * 判断左右
		 * 返回String
		 */
		public static function findSite(st_point:Point,m_point:Point,end_point:Point):String{
			var flag:String = "";
            var a:Number = end_point.y - st_point.y;
            var b:Number = st_point.x - end_point.x;
            var c:Number = end_point.x * st_point.y - end_point.y * st_point.x;
            var d:Number = a * m_point.x + b * m_point.y + c;
            if (d > 0){
                flag = "right";
            };
            if (d < 0){
                flag = "left";
            };
            return flag;
		}
		
		
	}
}