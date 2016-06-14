package jsoft.map.vector
{
	import flash.events.Event;
	
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.Polygon;
	import jsoft.map.geometry.Record;
	import jsoft.map.util.DrawUtil;
	import jsoft.map.util.LineHelper;
	
	import mx.core.UIComponent;
	
	public class BaseVector extends UIComponent implements IVector
	{
		private var vid:String="";
		private var group:String="";
		//private var visible:Boolean=true;
		private var enable:Boolean=true;
		protected var geometry:Geometry = null;
		protected var record:Record = new Record();
		protected var coord:Coordinate = null;
		protected var bounds:Box = null;
		protected var status:Boolean = false;
		protected var drawUtil:DrawUtil = null;
		protected var highDrawUtil:DrawUtil = null;
		// 标绘编辑通用变量
		protected var hotArea:Array=new Array();
		protected var hotPointArea:Array=new Array();
		protected var hotRet:int=-1;
		protected var offsetx:int=0;
		protected var offsety:int=0;
		// 动画变量
		protected var enableFrameFlag:Boolean = false;
		protected var animateFlag:Boolean = false;
		protected var animateFrameFlag:Boolean = false;
		protected var animateTime:Number = 0;
		protected var animateDistance:Number = 0;
		protected var delay:Number=0;
		protected var lastDelayTime:Number=0;
		protected var delayRemain:Number=0;
		protected var speed:Number=0;
		protected var line:Line=null;
		protected var viewFlag:Boolean=true;
		
		public function BaseVector() {
			drawUtil = new DrawUtil(graphics);
			highDrawUtil = new DrawUtil(graphics);
		}
		
		public function enableFrame():void {
			this.addEventListener(Event.ENTER_FRAME,onEnterFrame);
			enableFrameFlag = true;
		}
		
		public function disableFrame():void {
			this.removeEventListener(Event.ENTER_FRAME,onEnterFrame);
			enableFrameFlag = false;
		}
		
		protected function onEnterFrame(event:Event):void {
			if(animateFlag) {
				if(delayRemain > 0) {
					var newTime:Number = new Date().getTime();
					delayRemain -= newTime - lastDelayTime;
					lastDelayTime = newTime;
					animateTime = newTime;
					var startPoint:FPoint= this.line.getPoint(0);
					updateVectorView(startPoint);
					return;
				}
				//AppContext.getAppUtil().alert("onEnterFrame");
				var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
				var time:Number = new Date().getTime();
				var timeSpan:Number = (time - animateTime) / 1000;
				animateTime = time;
				var distance:Number = coord.distanceToMapUnit(timeSpan * speed);
				animateDistance += distance;
				distance = 0;
				var flag:Boolean = false;
				for(var i:int=1;i<this.line.getPointLength();i++) {
					var p1:FPoint= this.line.getPoint(i-1);
					var p2:FPoint = this.line.getPoint(i);
					var line:LineHelper = new LineHelper(p1,p2);
					var d:Number = line.getDistance();
					if(distance + d < animateDistance) {
						distance += d;
						continue;
					}
					var p:FPoint = line.getPointByDistance(animateDistance-distance);
					//AppContext.getAppUtil().alert("i="+i+",total="+this.line.getPointLength()+"\nanimateDistance="+animateDistance+",distance="+distance+",timeSpan="+timeSpan+"\n"+line.toString()+"\n"+p);
					updateVectorView(p);
					flag = true;
					break;
				}
				if(!flag) {
					updateVectorView(this.line.getPoint(this.line.getPointLength()-1));
					stopAnimate();
				}
			}
		}
		
		private function updateVectorView(p:FPoint):void {
			setCenter(p.x,p.y);
			if(viewFlag) {
				var cx:Number = getCenterX();
				var cy:Number = getCenterY();
				var vx:Number = coord.mapToViewX(cx);
				var vy:Number = coord.mapToViewY(cy);
				if(!coord.isInView(vx,vy)) {
					AppContext.getMapContext().getMapContent().centerMapAt(cx,cy);
					AppContext.getMapContext().getMapContent().refresh();
				}
			}
		}
		// 获取id
		public function getVectorId() : String {
			return vid;
		}
		// 设置id
		public function setVectorId(vid:String) : void {
			this.vid = vid;
		}
		// 获取分组
		public function getGroup() : String {
			return group;
		}
		// 设置分组
		public function setGroup(group:String) : void {
			this.group = group;
		}
		// 获取是否可见
		public function isVisible() : Boolean {
			return visible;
		}
		public function set_Visible(visible:Boolean):void{
			this.visible = visible;
		}
		// 获取是否有效
		public function isEnable() : Boolean {
			return visible;
		}
		// 设置是否有效
		public function setEnable(enable:Boolean) : void {
			this.enable = enable;
		}
		// 获取延迟
		public function getDelay() : Number {
			return delay;
		}
		// 设置延迟
		public function setDelay(delay:Number) : void {
			this.delay = delay;
		}
		// 获取速度
		public function getSpeed() : Number {
			return speed;
		}
		// 设置速度
		public function setSpeed(speed:Number) : void {
			this.speed = speed;
		}
		// 获取道路
		public function getLine() : Line {
			return line;
		}
		// 设置道路
		public function setLine(line:Line) : void {
			this.line = line;
		}
		// 获取是否可见
		public function isViewFlag() : Boolean {
			return viewFlag;
		}
		// 设置是否可见
		public function setViewFlag(viewFlag:Boolean) : void {
			this.viewFlag = viewFlag;
		}
		
		protected function buildHotArea():void {
			var geo:Geometry=AppContext.getGeomUtil().getViewGeometry(geometry);
			hotArea=AppContext.getGeomUtil().buildGeometryArea(geo,20);
			hotPointArea=AppContext.getGeomUtil().buildGeometryPointArea(geo,20);
			//AppContext.getAppUtil().alert(AppContext.getGeomUtil().printHotArea(hotPointArea));
		}
		// 获取符号对象的类型
		public function getVectorName() : String {
			return "BaseVector";
		}
		// 复制一份新的符号对象
		public function clone() : IVector {
			var baseVector:BaseVector = new BaseVector();
			copyTo(baseVector);
			return baseVector;
		}
		protected function copyTo(baseVector:BaseVector):void {
			baseVector.geometry = geometry==null?null:geometry.clone();
			baseVector.record = record==null?null:record.clone();
			baseVector.bounds = bounds==null?null:bounds.getBox();
			baseVector.delay = delay;
			baseVector.speed = speed;
			baseVector.line = line==null?null:line.clone() as Line;
			baseVector.viewFlag = viewFlag;
			baseVector.status = status;
			baseVector.visible = visible;
			baseVector.enable = enable;
			baseVector.group = group;
			baseVector.vid = vid;
		}
		// 将符号对象转换为字符串
		public function getVectorString() : String {
			//AppContext.getAppUtil().alert("line="+line);
			var split:String = "!";
			var ret:String = vid + split + group + split + enable + split + visible + split + status;
			ret += split + delay + split + speed + split + viewFlag + split + (line==null?"":line.getGeometryString());
			//AppContext.getAppUtil().alert(ret);
			return ret;
		}
		// 将字符串转换为符号对象
		public function setVectorString(symbolString:String):void {
			var split:String = "!";
			var ary:Array = AppContext.getAppUtil().getStringArray(symbolString,split);
			this.vid = ary[0];
			group = ary[1];
			enable = AppContext.getAppUtil().getBoolean(ary[2]);
			visible = AppContext.getAppUtil().getBoolean(ary[3]);
			status = AppContext.getAppUtil().getBoolean(ary[4]);
			if(ary.length <= 5) {
				return;
			}
			delay = AppContext.getAppUtil().getNumber(ary[5]);
			speed = AppContext.getAppUtil().getNumber(ary[6]);
			viewFlag = AppContext.getAppUtil().getBoolean(ary[7]);
			if(ary[8] != null && ary[8] != "") {
				line = new Line();
				line.setGeometryString(ary[8]);
				if(line.getPointLength()>0) {
					var startPoint:FPoint= line.getPoint(0);
					updateVectorView(startPoint);
				}
			} else {
				line = null;
			}
		}
		// 获取空间对象
		public function getGeometry():Geometry {
			return geometry;
		}
		public function getGeometryEx():Geometry {
			if(geometry == null) {
				if(record == null || record.getGeometry() == null) {
					if(bounds == null) {
						return null;
					}
					return bounds;
				}
				return record.getGeometry();
			}
			return geometry;
		}
		// 设置空间对象
		public function setGeometry(geometry:Geometry):void {
			this.geometry = geometry;
		}
		// 获取记录对象
		public function getRecord():Record {
			return record;
		}
		// 设置记录对象
		public function setRecord(record:Record):void {
			this.record = record;
		}
		// 打印符号对象
		public override function toString() : String {
			return getVectorString();
		}
		// 绘制符号
		public function showVector(coord:Coordinate) : void {
			if(coord != null) {
				this.coord = coord;
			}
			graphics.clear();
			//加入清内容
//			while(this.numChildren > 0) {
//				this.removeChildAt(0);
//			}
		}
		// 绘制符号
		public function updateVector() : void {
		}
		// 刷新符号
		public function refresh():void {
			if(!viewFlag) {
				graphics.clear();
				return;
			}
//			//加入清内容
//			while(this.numChildren > 0) {
//				this.removeChildAt(0);
//			}
			showVector(AppContext.getMapContext().getMapContent().getCoordinate());
			updateVector();
		}
		public function clear() : void {
			graphics.clear();
			//加入清内容
			while(this.numChildren > 0) {
				this.removeChildAt(0);
			}
		}
		// 判断符号是否被选中
		public function getStatus() : Boolean {
			if(!viewFlag) {
				return false;
			}
			return status;
		}
		// 设置符号是否被选中
		public function setStatus(status:Boolean):void {
			this.status = status;
		}
		// 获取符号的最大地理范围
		public function getMapRange():Box {
			return bounds;
		}
		// 设置符号的最大地理范围
		public function setMapRange(minx:Number,miny:Number,maxx:Number,maxy:Number):void {
			var bounds:Box = new Box();
			bounds.setBox(minx,miny,maxx,maxy);
			setMapRangeBox(bounds);
		}
		// 设置符号的最大地理范围
		public function setMapRangeBox(bounds:Box):void {
			bounds.normalizeBox();
			this.bounds = bounds;
		}
		// 设置符号的最大视图范围，自动将视图范围转换为地理范围
		public function setViewRange(minx:Number,miny:Number,maxx:Number,maxy:Number):void {
			var coord:Coordinate = getCoordinate();
			var x1:Number = coord.mapFromViewX(minx);
			var y1:Number = coord.mapFromViewY(miny);
			var x2:Number = coord.mapFromViewX(maxx);
			var y2:Number = coord.mapFromViewY(maxy);
			setMapRange(x1,y1,x2,y2);
		}
		// 设置符号的最大视图范围，自动将视图范围转换为地理范围
		public function setViewRangeBox(bounds:Box):void {
			setViewRange(bounds.getMinx(),bounds.getMiny(),bounds.getMaxx(),bounds.getMaxy());
		}
		// 判断是否点中空间对象,-1代表未选中,0代表选中对象,1..n代表选中某个控制点
		public function hitTest(x:Number,y:Number):int {
			return -1;
		}
		// 判断是否点中空间对象
		public function hitRectTest(minx:Number,miny:Number,maxx:Number,maxy:Number): Boolean {
			return false;
		}
		// 将某个控制点移动到某个偏移量
		public function moveControlPoint(hotPoint:int,offsetx:int,offsety:int):void {
		}
		// 将某个控制点偏移量更新到实际的对象中
		public function updateControlPoint(update:Boolean):void {
		}
		
		protected function getCoordinate() : Coordinate {
			return coord;
		}
		
		// 绘制控制点
		protected function drawControlP(point:FPoint) : void {
			drawControlPoint(point.getX(),point.getY());
		}
		protected function drawControlPEx(point:FPoint,offsetx:int,offsety:int) : void {
			drawControlPointEx(point.getX(),point.getY(),offsetx,offsety);
		}
		protected function drawControlPoint(mapx:Number,mapy:Number) : void {
			drawControlPointEx(mapx,mapy,0,0);
		}
		protected function drawControlPointEx(mapx:Number,mapy:Number,offsetx:int,offsety:int) : void {
			var coord:Coordinate = getCoordinate();
			var x:Number = coord.mapToViewX(mapx);
			var y:Number = coord.mapToViewY(mapy);
			x+=offsetx;
			y+=offsety;
			drawUtil.setFill(true);
			drawUtil.setFillColor(AppContext.getDrawUtil().getBlack());
			drawUtil.setLineColor(AppContext.getDrawUtil().getBlack());
			drawUtil.setLineWidth(1);
			var span:int = 5;
			drawUtil.drawRect(x-span,y-span,x+span,y+span);
		}
		
		protected function moveSinglePoly(geometry:Geometry,coordinate:Coordinate,pointCount:int):int {
			var pl:Polygon=geometry as Polygon;
			var tPoint:jsoft.map.geometry.FPoint;
			var x_tmp:Number=0;
			var y_tmp:Number=0;
			var i:int=0;
			//有任何一点在当前视野中的标志,//判定线是否有点在当前视图范围内
			//AppContext.getAppUtil().alert("pl.getPointLength()="+pl.getPointLength());
			//取得点坐标数组
			for (i=0;i< pl.getPointLength();i++ )
			{
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
						if(pl.getPointLength()==i+1) {
							pl.setPoint(0,x_tmp,y_tmp);
						}
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
					if(pl.getPointLength()==i+1) {
						pl.setPoint(0,x_tmp,y_tmp);
					}
				}
			}
			return pointCount;
	     }
		
		protected function moveSinglePolyEx(geometry:Geometry,coordinate:Coordinate,pointCount:int):int {
			var pl:Polygon=geometry as Polygon;
			var tPoint:jsoft.map.geometry.FPoint;
			var x_tmp:Number=0;
			var y_tmp:Number=0;
			var i:int=0;
			//有任何一点在当前视野中的标志,//判定线是否有点在当前视图范围内
			//AppContext.getAppUtil().alert("pl.getPointLength()="+pl.getPointLength());
			//取得点坐标数组
			for (i=0;i< pl.getPointLength();i++ )
			{
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
						if(pl.getPointLength()==i+1) {
							pl.setPoint(0,x_tmp,y_tmp);
						}
						if(i==2) {
							pl.setPointX(1,x_tmp);
							pl.setPointY(3,y_tmp);
						} else if(i==4) {
							pl.setPointX(3,x_tmp);
							pl.setPointY(1,y_tmp);
						}
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
					if(pl.getPointLength()==i+1) {
						pl.setPoint(0,x_tmp,y_tmp);
					}
				}
			}
			return pointCount;
	     }
		//  符号的形状是否固定
		public function isFix() : Boolean {
			return false;
		}
		// 为符号添加点
		public function addPoint(x:int,y:int) : void {
		}
		// 删除符号点
		public function removePoint(index:int) : void {
		}
		public function getSplitString():String {
			return "~";
		}
		// 获取中心点坐标
		public function getCenterX():Number {
			return getMapRange().getCenterX();
		}
		// 获取中心点坐标
		public function getCenterY():Number {
			return getMapRange().getCenterY();
		}
		// 移动到指定位置
		public function setCenter(cx:Number,cy:Number):void {
			var range:Box = getMapRange();
			//AppContext.getAppUtil().alert("range="+range);
			if(range == null) {
				return;
			}
			var p:FPoint = new FPoint();
			p.setXY(cx,cy);
			range.setCenter(p);
			updateVector();
		}
		// 设置移动参数
		public function setMoveAnimate(speed:Number,line:Line,viewFlag:Boolean):void {
			if(speed < 0 || line == null) {
				return;
			}
			delay = 0;
			delayRemain = 0;
			this.speed = speed;
			this.line = line;
			this.viewFlag = viewFlag;
		}
		// 设置移动参数
		public function setMoveAnimateDelay(delay:Number,speed:Number,line:Line,viewFlag:Boolean):void {
			if(speed < 0 || line == null) {
				return;
			}
			this.delay = delay;
			delayRemain = delay;
			lastDelayTime = new Date().getTime();
			//AppContext.getAppUtil().alert("delay="+delay);
			this.speed = speed;
			this.line = line;
			this.viewFlag = viewFlag;
		}
		// 开始移动
		public function startMove():void {
			if(speed < 0 || line == null) {
				return;
			}
			animateFlag = true;
			animateTime = new Date().getTime();
			animateDistance = 0;
			if(enableFrameFlag) {
				animateFrameFlag = false;
			} else {
				enableFrame();
				animateFrameFlag = true;
			}
		}
		// 开始移动
		public function moveAnimate(speed:Number,line:Line,viewFlag:Boolean):void {
			if(speed < 0 || line == null) {
				return;
			}
			delay = 0;
			delayRemain = 0;
			this.speed = speed;
			this.line = line;
			this.viewFlag = viewFlag;
			animateFlag = true;
			animateTime = new Date().getTime();
			animateDistance = 0;
			if(enableFrameFlag) {
				animateFrameFlag = false;
			} else {
				enableFrame();
				animateFrameFlag = true;
			}
		}
		// 开始移动
		public function moveAnimateDelay(delay:Number,speed:Number,line:Line,viewFlag:Boolean):void {
			if(speed < 0 || line == null) {
				return;
			}
			this.delay = delay;
			delayRemain = delay;
			lastDelayTime = new Date().getTime();
			//AppContext.getAppUtil().alert("delay="+delay);
			this.speed = speed;
			this.line = line;
			this.viewFlag = viewFlag;
			animateFlag = true;
			animateTime = new Date().getTime();
			animateDistance = 0;
			if(enableFrameFlag) {
				animateFrameFlag = false;
			} else {
				enableFrame();
				animateFrameFlag = true;
			}
		}
		// 暂停移动
		public function pauseAnimate():void {
			animateFlag = false;
		}
		// 恢复移动
		public function resumeAnimate():void {
			animateFlag = true;
			animateTime = new Date().getTime();
		}
		// 停止移动
		public function stopAnimate():void {
			animateFlag = false;
			if(animateFrameFlag) {
				disableFrame();
			}
		}
		
		public function rgbToInt(r:int, g:int, b:int):int {
			return r << 16 | g << 8 | b << 0;
		}

	}
}