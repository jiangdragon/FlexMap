package jsoft.map.tip.impl
{
	import flash.display.DisplayObject;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import jsoft.map.acete.MapHotAcete;
	import jsoft.map.tip.MapTip;
	import jsoft.map.util.DrawUtil;

	public class BaseMapTip implements MapTip
	{
		private var timeOutId:int = -1;
		private var timeOut:Number = 5000;
		protected var title:String = "";
		protected var window:DisplayObject = null;
		
		public function BaseMapTip() {
		}
		
		// 判断提示信息是否一致
		public function isEqual(mapTip:MapTip) : Boolean {
			return false;
		}
		
		// 获取提示的标题信息
		public function getTitle() : String {
			return title;
		}
		
		// 设置提示的标题信息
		public function setTitle(title:String) : void {
			this.title = title;
		}

		// 在指定位置显示提示信息
		public function showTip(x:int, y:int):void {
			showTipEx(x,y,5000);
		}

		// 在指定位置显示信息提示框，并在鼠标移开后指定的空闲时间后关闭提示信息
		public function showTipEx(x:int, y:int, timeOut:int):void {
			this.timeOut = timeOut;
			startTimer();
		}
		
		public function hideTip() : void {
			//AppContext.getAppUtil().alert("hideTip="+window);
			destoryWindow();
		}
		
		// 清除提示信息
		public function destory() : void {
			//AppContext.getAppUtil().alert("destory="+window);
			destoryWindow();
		}
		
		protected function addWindow(win:DisplayObject) : void {
			if(win != window) {
				destoryWindow();
			}
			var hot:MapHotAcete = AppContext.getMapContext().getHotContainer();
			//AppContext.getAppUtil().alert("addwindow="+window);
			//AppContext.getMapContext().getTopContainer().addChild(window);
			var oldWinAry:Array = new Array();
			for(var i:int=0;i<hot.numChildren;i++) {
				var oldWin:DisplayObject = hot.getChildAt(i);
				if(oldWin != win) {
					oldWinAry.push(oldWin);
				}
			}
			for(i=0;i<oldWinAry.length;i++) {
				oldWin = oldWinAry[i];
				if(hot.contains(oldWin)) {
					hot.removeChild(oldWin);
				}
			}
			window = win;
			if(!hot.contains(window)) {
				hot.addChild(window);
			}
		}
		
		protected function destoryWindow() : void {
			//AppContext.getAppUtil().alert("destoryWindow window="+window);
			if(window != null) {
				//AppContext.getMapContext().getTopContainer().removeChild(window);
				if(AppContext.getMapContext().getHotContainer().contains(window)) {
					AppContext.getMapContext().getHotContainer().removeChild(window);
				}
				window = null;
				//处理列表比文字优先2011-12-30
				AppContext.getMapContext().getMapTipFactory().destory();
			}
			if(timeOutId != -1) {
				clearTimeout(timeOutId);
				timeOutId = -1;
			}
		}
		
		protected function startTimer() : void {
			clearTimer();
			timeOutId = setTimeout(this.onTimeOut,timeOut*1000);
		}
		
		protected function startTimerEx(timeOut:Number) : void {
			clearTimer();
			this.timeOut = timeOut;
			timeOutId = setTimeout(this.onTimeOut,timeOut*1000);
		}
		
		protected function clearTimer() : void {
			if(timeOutId != -1) {
				clearTimeout(timeOutId);
				timeOutId = -1;
			}
		}
		
		private function onTimeOut() :  void {//AppContext.getAppUtil().alert("onTimeOut="+window);
			timeOutId = -1;
			destory();
		}
		
		protected function clearWindowLine() : void {
			// 绘制句柄
			var drawUtil:DrawUtil = new DrawUtil(AppContext.getMapContext().getHotContainer().graphics);
			drawUtil.clear();
		}
		
		protected function drawWindowLine(sx:int,sy:int) : void {
			// 热点坐标
			//var sx:int = window.x;
			//var sy:int = window.y;
			// 屏幕尺寸
			var scrWidth:int = AppContext.getMapContext().getMapContent().getScreenWidth();
			var scrHeight:int = AppContext.getMapContext().getMapContent().getScreenHeight();
			// 窗口尺寸
			var width:int = window.width;
			var height:int = window.height;
			// 箭头尺寸
			var arrowWidth:int = 50;
			var arrowHeight:int = 30;
			// 绘制句柄
			var drawUtil:DrawUtil = new DrawUtil(AppContext.getMapContext().getHotContainer().graphics);
			drawUtil.setLineColor(0xDFDFDF);
			drawUtil.setFillColor(0xDFDFDF)
			//drawUtil.setLineColor(AppContext.getDrawUtil().getGray());
			//drawUtil.setFillColor(AppContext.getDrawUtil().getWhite());
			drawUtil.setFill(true);
			drawUtil.setFillAlpha(0.8);
			// 计算窗口位置
			var winx:int = sx + arrowWidth;
			var winy:int = sy - arrowHeight - height;
			if(winx + width >= scrWidth - 10) {
				winx = sx - arrowWidth - width;
				if(winx <= 0) {
					winx = (scrWidth-width) / 2;
				}
			}
			if(winy <= 10) {
				winy = sy + arrowHeight;
				if(winy + height >= scrHeight) {
					winy = (scrHeight-height) / 2;
				}
			}
			// 设置窗口
			window.x = winx;
			window.y = winy;
			// 计算外围多边形
			//winx = winx - 2;
			//winy = winy - 2;
			//width += 4;
			//height += 4;
			var xAry:Array = new Array();
			var yAry:Array = new Array();
			xAry[0]=sx;
			yAry[0]=sy;
			if(sx < winx + width / 2) {
				if(sy < winy + height / 2) {
					//AppContext.getAppUtil().alert("1 象限内");
					// 1 象限内
					xAry[xAry.length]= winx + width / 3;
					yAry[yAry.length]= winy;
					//xAry[xAry.length]= winx + width;
					//yAry[yAry.length]= winy;
					//xAry[xAry.length]= winx + width;
					//yAry[yAry.length]= winy + height;
					//xAry[xAry.length]= winx;
					//yAry[yAry.length]= winy + height;
					xAry[xAry.length]= winx;
					yAry[yAry.length]= winy + height / 3;
					sx += 2;
					sy += 2;
				} else {
					//AppContext.getAppUtil().alert("3 象限内");
					// 3 象限内
					xAry[xAry.length]= winx + width / 3;
					yAry[yAry.length]= winy + height;
					//xAry[xAry.length]= winx + width;
					//yAry[yAry.length]= winy + height;
					//xAry[xAry.length]= winx + width;
					//yAry[yAry.length]= winy;
					//xAry[xAry.length]= winx;
					//yAry[yAry.length]= winy;
					xAry[xAry.length]= winx;
					yAry[yAry.length]= winy + height * 2 / 3;
					sx += 2;
					sy -= 2;
				}
			} else {
				if(sy < winy + height / 2) {
					//AppContext.getAppUtil().alert("2 象限内");
					// 2 象限内
					xAry[xAry.length]= winx + width * 2 / 3;
					yAry[yAry.length]= winy;
					//xAry[xAry.length]= winx;
					//yAry[yAry.length]= winy;
					//xAry[xAry.length]= winx;
					//yAry[yAry.length]= winy + height;
					//xAry[xAry.length]= winx + width;
					//yAry[yAry.length]= winy + height;
					xAry[xAry.length]= winx + width;
					yAry[yAry.length]= winy + height / 3;
					sx -= 2;
					sy += 2;
				} else {
					//AppContext.getAppUtil().alert("4 象限内");
					// 4 象限内
					xAry[xAry.length]= winx + width * 2 / 3;
					yAry[yAry.length]= winy + height;
					//xAry[xAry.length]= winx;
					//yAry[yAry.length]= winy + height;
					//xAry[xAry.length]= winx;
					//yAry[yAry.length]= winy;
					//xAry[xAry.length]= winx + width;
					//yAry[yAry.length]= winy;
					xAry[xAry.length]= winx + width;
					yAry[yAry.length]= winy + height * 2 / 3;
					sx -= 2;
					sy -= 2;
				}
			}
			xAry[0]=sx;
			yAry[0]=sy;
			xAry[xAry.length]=sx;
			yAry[yAry.length]=sy;
			// 绘制
			window.x = winx;
			window.y = winy;
			drawUtil.drawPolygon(xAry,yAry);
		}
		
	}
}