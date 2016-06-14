package jsoft.map.tip
{
	import jsoft.map.acete.MapHotAcete;
	import jsoft.map.tip.impl.MapImageTipImpl;
	import jsoft.map.tip.impl.MapListTipImpl;
	import jsoft.map.tip.impl.MapMenuTipImpl;
	import jsoft.map.tip.impl.MapTextTipImpl;
	import jsoft.map.tip.impl.MapVideoTipImpl;
	import jsoft.map.tip.impl.MapVideoWinTipImpl;
	
	public class MapTipFactory {
		private var mapTip:MapTip = null;

		public function MapTipFactory() {
		}
		//加一个接口获取一个提示框实例mapTip
		public function getMapTip():MapTip{
			return mapTip;
		}
		// 创建一个文本信息显示框
		public function getTextTip() : MapTextTip {
			return new MapTextTipImpl();
		}
		
		// 创建一个图片信息显示框
		public function getImageTip() : MapImageTip {
			return new MapImageTipImpl();
		}
		
		// 创建一个视频信息显示框
		public function getMapVideoTip() : MapVideoTip {
			return new MapVideoTipImpl();
		}
		
		// 创建一个视频信息窗口
		public function getMapVideoWinTip() : MapVideoTip {
			return new MapVideoWinTipImpl();
		}
		
		// 创建一个列表信息显示框
		public function getListTip() : MapListTip {
			return new MapListTipImpl();
		}
		//创建一个菜单
		public function getMenuTip():MapMenuTipImpl{
			return new MapMenuTipImpl();
		}
		
		public function addMapTip(x:int,y:int,newMapTip:MapTip):void {
			//AppContext.getAppUtil().alert("MapTipFactory.addMapTip mapTip="+mapTip+", equal="+(this.mapTip == null || !this.mapTip.isEqual(mapTip)));
			if(mapTip == null || !mapTip.isEqual(newMapTip)) {
				destory();
				newMapTip.destory();
				mapTip = newMapTip;
			}
			//AppContext.getAppUtil().alert("addMapTip mapTip="+mapTip);
			mapTip.showTip(x,y);
		}
		
		public function addMapTipEx(x:int,y:int,timeOut:int,mapTip:MapTip):void {
			//AppContext.getAppUtil().alert("addMapTipEx mapTip="+mapTip);
			if(!this.mapTip.isEqual(mapTip)) {
				destory();
				this.mapTip = mapTip;
			}
			mapTip.showTipEx(x,y,timeOut);
		}
		
		public function hideTip() : void {
			//AppContext.getAppUtil().alert("destory mapTip="+mapTip);
			if(mapTip != null) {
				//AppContext.getAppUtil().alert("destory mapTip="+mapTip);
				mapTip.hideTip();
			}
		}
		
		public function destory() : void {
			//AppContext.getAppUtil().alert("destory mapTip="+mapTip);
			if(mapTip != null) {
				mapTip.destory();
				mapTip = null;
			}
			var hot:MapHotAcete = AppContext.getMapContext().getHotContainer();
			while(hot.numChildren > 0) {
				hot.removeChildAt(0);
			}
		}
		public function clear():void{
			if(mapTip != null) {
				if(mapTip is MapMenuTipImpl){
					mapTip.isEqual(mapTip);//清菜单
				}
				mapTip.destory();
				mapTip = null;
			}
			var hot:MapHotAcete = AppContext.getMapContext().getHotContainer();
			while(hot.numChildren > 0) {
				hot.removeChildAt(0);
			}
		}

	}
}