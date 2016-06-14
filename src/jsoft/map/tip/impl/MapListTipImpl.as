package jsoft.map.tip.impl
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import jsoft.map.tip.MapListTip;
	import jsoft.map.tip.MapTip;
	import jsoft.map.tip.impl.item.MapImageItem;
	import jsoft.map.tip.impl.item.MapJSLinkItem;
	import jsoft.map.tip.impl.item.MapLinkItem;
	import jsoft.map.tip.impl.item.MapListTipItem;
	import jsoft.map.tip.impl.item.MapTextAreaItem;
	import jsoft.map.tip.impl.item.MapTextItem;
	import jsoft.map.tip.impl.item.MapVideoItem;
	import jsoft.map.ui.TipWindow;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.events.CloseEvent;

	public class MapListTipImpl extends BaseMapTip implements MapListTip {
		private var width:int = -1;
		private var height:int = -1;
		private var listArray:Array = new Array();
		private var closed:Boolean = false;
		
		public function MapListTipImpl() {
			super();
		}
		
		// 判断提示信息是否一致
		public override function isEqual(mapTip:MapTip) : Boolean {
			try {
				if(mapTip != null && mapTip is MapListTipImpl) {
					var tip:MapListTipImpl = mapTip as MapListTipImpl;
					if(tip.listArray.length == listArray.length) {
						for(var i:int=0;i<listArray.length;i++) {
							var item1:MapListTipItem=listArray[i];
							var item2:MapListTipItem=tip.listArray[i];
							if(!item1.isEqual(item2)) {
								return false;
							}
						}
						return true;
					}
				}
			} catch(errObject:Error) {
			}
			return false;
		}
		
		public override function showTip(x:int, y:int):void {
			initWindow(x,y);
			//startTimerEx(395000);
		}
		
		public override function showTipEx(x:int, y:int, timeOut:int):void {
			initWindow(x,y);
			startTimerEx(timeOut);
		}
		
		public override function hideTip() : void {
			//本来保留，但新增 无关闭提示框
			if(closed){
				destory();
			}
		}
		
		// 清除提示信息
		public override function destory() : void {
			for(var i:int=0;i<listArray.length;i++) {
				var item:MapListTipItem=listArray[i];
				item.destory();
			}
			//listArray = new Array();
			clearWindowLine();
			destoryWindow();
		}
		
		// 获取宽度
		public function getWidth() : int {
			return width;
		}
		
		// 设置宽度
		public function setWidth(width:int) : void {
			this.width = width;
		}
		
		// 获取高度
		public function getHeight() : int {
			return height;
		}
		
		// 设置高度
		public function setHeight(height:int) : void {
			this.height = height;
		}
		
		// 添加文本信息
		public function addText(name:String,value:String) : void {
			//AppContext.getAppUtil().alert("addText");
			var item:MapTextItem = new MapTextItem();
			item.setName(name);
			item.setValue(value);
			listArray[listArray.length]=item;
		}
		
		//添加文本域信息
		public function addTextArea(name:String,value:String):void{
			var item:MapTextAreaItem = new MapTextAreaItem();
			item.setName(name);
			item.setValue(value);
			listArray[listArray.length]=item;
		}
		
		// 添加图片信息
		public function addImage(name:String,url:String) : void {
			var item:MapImageItem = new MapImageItem();
			item.setName(name);
			item.setURL(url);
			listArray[listArray.length]=item;
		}
		
		// 添加视频信息
		public function addVideo(name:String,url:String) : void {
			var item:MapVideoItem = new MapVideoItem();
			item.setName(name);
			item.setURL(url);
			listArray[listArray.length]=item;
		}
		
		// 添加js响应函数
		public function addLinkJS(name:String,jsFuncName:String) : void {
			var item:MapJSLinkItem = new MapJSLinkItem();
			item.setName(name);
			item.setJS(jsFuncName);
			listArray[listArray.length]=item;
		}
		public function addClose(name:String,closed:Boolean):void{
			this.closed = closed;
		}
		// 添加链接的地址
		public function addLinkURL(name:String,url:String,linkWinParam:String) : void {
			var item:MapLinkItem = new MapLinkItem();
			item.setName(name);
			item.setURL(url);
			item.setLinkWinParam(linkWinParam);
			listArray[listArray.length]=item;
		}
		
		// 获取已经添加的列表
		public function getListItem(pos:int) : MapListTipItem {
			return listArray[pos];
		}
		
		// 获取已经添加的数量
		public function getListItemCount() : int {
			return listArray.length;
		}
		
		// 添加
		public function addListItem(item:MapListTipItem) : void {
			listArray[listArray.length]=item;
		}
		
		// 插入
		public function insertListItem(pos:int,item:MapListTipItem) : void {
			var temp:MapListTipItem = item;
			for(var i:int=pos;i<listArray.length;i++) {
				temp = listArray[i];
				listArray[i] = item;
				item = temp;
			}
			listArray[listArray.length]=item;
		}
		
		// 删除
		public function removeListItem(pos:int) : MapListTipItem {
			var item:MapListTipItem = listArray[pos];
			var temp:Array = new Array(listArray.length-1);
			for(var i:int=0;i<listArray.length;i++) {
				if(pos == i) {
					continue;
				}
				temp[temp.length]=listArray[i];
			}
			listArray = temp;
			return item;
		}
		
		// 清空
		public function clearListItem() : void {
			listArray = new Array();
		}
		
		private function titleWindow_close(evt:CloseEvent):void {
			//AppContext.getMapContext().getMapContent().setTipWinCloseFlag(true);
			//AppContext.getAppUtil().alert("set close");
			destory();
        }
        
        private function mouseEvent(evt:MouseEvent):void {
        	AppContext.getMapContext().getMapContent().setTipWinCloseFlag(true);
        }
        
        // 初始化
		public function initMapLitTip() : void {
			//destoryWindow();
		}
		
		private function initWindow(x:int, y:int) : void {
			var win:TipWindow = window as TipWindow;
			//var win:TitleWindow = window as TitleWindow;
			//AppContext.getAppUtil().alert("win="+win);
			if(win == null) {
				win = new TipWindow();
				win.setTitle(title);
				//win = new TitleWindow();
				//win.title = title;
				//AppContext.getAppUtil().alert("title="+title);
				//win.isPopUp = false;
				//win.layout = "absolute";
				//win.showCloseButton = true;
				//win.opaqueBackground = 0xFFFFFF;
				win.addEventListener(MouseEvent.MOUSE_DOWN,mouseEvent);
				win.addEventListener(MouseEvent.MOUSE_UP,mouseEvent);
				win.addEventListener(CloseEvent.CLOSE,titleWindow_close);
				var vbox:VBox = new VBox();
				vbox.setStyle("verticalGap", 1);
				vbox.percentWidth=100;
				vbox.percentHeight=100;
				win.addChild(vbox);
				var leftWidth:int = width / 3;
				var rightWidth:int = width - leftWidth - 10;
				//AppContext.getAppUtil().alert("listArray="+listArray+",length="+listArray.length);
				for(var i:int=0;i<listArray.length;i++) {
					var item:MapListTipItem = listArray[i];
					var hbox:HBox = new HBox();
					var titleObject:DisplayObject = item.getNameField(leftWidth);
					var valueObject:DisplayObject = item.getValueField(rightWidth);
					//win.addChild(titleObject);
					//win.addChild(valueObject);
					//AppContext.getAppUtil().alert("width="+leftWidth+"\ntitleObject="+titleObject+",valueObject="+valueObject);
					
					if(titleObject != null) {
						hbox.addChild(titleObject);
						if(valueObject != null) {
							hbox.addChild(valueObject);
						}
						vbox.addChild(hbox);
					} else {//AppContext.getAppUtil().alert("valueObject="+valueObject);
						if(valueObject != null) {
							hbox.addChild(valueObject);
							hbox.setStyle("horizontalAlign", "center");
							vbox.addChild(hbox);
							valueObject.width = width-30;
							//vbox.addChild(valueObject);
						}
					}
				}
				//AppContext.getAppUtil().alert("listArray.length");
				addWindow(win);
			}
			win.x = x;
			win.y = y;
			win.width = width;
			win.height = height;
			//win.width = width + win.viewMetrics.left + win.viewMetrics.right;
			//win.height = height + win.viewMetrics.top + win.viewMetrics.bottom;
			clearWindowLine();
			drawWindowLine(x,y);
		}
		
	}
}