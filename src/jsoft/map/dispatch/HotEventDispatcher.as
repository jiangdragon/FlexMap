package jsoft.map.dispatch
{
	import jsoft.map.acete.MapHot;
	import jsoft.map.acete.MapHotAcete;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.Polygon;
	import jsoft.map.tip.MapListTip;
	
	public class HotEventDispatcher implements Dispatcher
	{
		public function HotEventDispatcher(){
		}
		/* send message */
		public function sendMessage(param:DispatchParam):void{
			var hots:MapHotAcete = AppContext.getMapContext().getHotInstance();
			var hot:MapHot;
			if(param.Type == "setTipStyle") {
				hots.setTipStyle(param.vstr,param.vint,param.vint,param.vbool,param.vcolor,param.vbool,param.vcolor);
				return;
			}
			//点
			if(param.Type == "addPointHot"){
				hot = pointHot(param);
				hots.addHot(hot);
				return;
			}
			if(param.Type == "addPointEvent"){//左键事件
				hot = pointEvent(param);
				hots.addHot(hot);
				return;
			}
			if(param.Type == "addPointHotFlare"){
				hot = pointHotFlare(param);
				hots.addHot(hot);
				return;
			}
			if(param.Type == "addPointMenu"){
				hot = menu(param.vpoint,getMapXml(param.vstr),param.vintary,param.vint,param.vstr,param.vstr);
				hots.addHot(hot);
				return;
			}
			if(param.Type == "showPointHot"){
				hot = pointHot(param);
				hots.show(hot);
				return;
			}
			if(param.Type == "showPointHotFlare"){
				hot = pointHotFlare(param);
				hots.show(hot);
				return;
			}
			//线
			if(param.Type == "addLineHot"){
				hot = lineHot(param);
				hots.addHot(hot);
				return;
			}
			if(param.Type == "addLineEvent"){
				hot = lineEvent(param);
				hots.addHot(hot);
				return;
			}
			if(param.Type == "addLineHotFlare"){
				hot = lineHotFlare(param);
				hots.addHot(hot);
				return;
			}
			if(param.Type == "addLineMenu"){
				hot = menu(param.vline,getMapXml(param.vstr),param.vintary,param.vint,param.vstr,param.vstr);
				hots.addHot(hot);
				return;
			}
			if(param.Type == "showLineHot"){
				hot = lineHot(param);
				hots.show(hot);
				return;
			}
			if(param.Type == "showLineHotFlare"){
				hot = lineHotFlare(param);
				hots.show(hot);
				return;
			}
			//面
			if(param.Type == "addPolyHot"){
				hot = polyHot(param);
				hots.addHot(hot);
				return;
			}
			if(param.Type == "addPolyEvent"){
				hot = polyEvent(param);
				hots.addHot(hot);
				return;
			}
			if(param.Type == "addPolyHotFlare"){
				hot = polyHotFlare(param);
				hots.addHot(hot);
				return;
			}
			if(param.Type == "addPolyMenu"){
				hot = menu(param.vpoly,getMapXml(param.vstr),param.vintary,param.vint,param.vstr,param.vstr);
				hots.addHot(hot);
				return;
			}
			if(param.Type == "showPolyHot"){
				hot = polyHot(param);
				hots.show(hot);
				return;
			}
			if(param.Type == "showPolyHotFlare"){
				hot = polyHotFlare(param);
				hots.show(hot);
				return;
			}
			//菜单
			if(param.Type == "showMenu"){
				AppContext.getMapContext().getHotInstance().showMenuHot();
			}
			if(param.Type == "clear") {
				hots.clear();
				return;
			}
			if(param.Type == "hideTip") {
				AppContext.getMapContext().getMapTipFactory().destory();
				return;
			}
			if(param.Type =="removeHotById"){
				hots.removeHotById(param.vstr);
				return;
			}
			if(param.Type == "removeHotByGroup") {
				hots.removeHotByGroup(param.vstr);
				return;
			}
			if(param.Type == "setHotGroupVisible") {
				hots.setHotGroupVisible(param.vstr,param.vbool);
				return;
			}
		}
		/* get  message */ 
		public function getMessage(param:DispatchParam):String{
			return "";
		}
		/* point's hot */
		private function pointHot(param:DispatchParam):MapHot{
			var hot:MapHot = new MapHot();
			var type:String = param.vstr;
			if("tip" == type){
				addStr(hot,param.vint,param.vpoint,param.vstr,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("image" == type){
				addImage(hot,param.vint,param.vpoint,param.vstr,param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("video" == type){
				addVideo(hot,param.vint,param.vpoint,param.vstr,param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("listWin" == type){
				addListWin(hot,param.vint,param.vpoint,param.vstr,getMapListTip(param.vstr),param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			return hot;
		}
		/* line's hot */
		private function lineHot(param:DispatchParam):MapHot{
			var hot:MapHot = new MapHot();
			var type:String = param.vstr;
			if("tip" == type){
				addStr(hot,param.vint,param.vline,param.vstr,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("image" == type){
				addImage(hot,param.vint,param.vline,param.vstr,param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("video" == type){
				addVideo(hot,param.vint,param.vline,param.vstr,param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("listWin" == type){
				addListWin(hot,param.vint,param.vline,param.vstr,getMapListTip(param.vstr),param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			return hot;
		}
		/* poly's hot */
		private function polyHot(param:DispatchParam):MapHot{
			var hot:MapHot = new MapHot();
			var type:String = param.vstr;
			if("tip" == type){
				addStr(hot,param.vint,param.vpoly,param.vstr,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("image" == type){
				addImage(hot,param.vint,param.vpoly,param.vstr,param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("video" == type){
				addVideo(hot,param.vint,param.vpoly,param.vstr,param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("listWin" == type){
				addListWin(hot,param.vint,param.vpoly,param.vstr,getMapListTip(param.vstr),param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			return hot;
		}
		/* point's event */
		private function pointEvent(param:DispatchParam):MapHot{
			var hot:MapHot = new MapHot();
			hot.setShowEvent(true);
			hot.setMethod(2);
			hot.setGeometry(param.vpoint);
			var callBack:String = param.vstr;
			hot.setCallBack(callBack);
			var size:int = param.vint;
			if(size == 0){
				size = 1;
			}
			hot.setSize(size);
			hot.setId(param.vstr);
			hot.setGroup(param.vstr);
			return hot;
		}
		/* line's event */
		private function lineEvent(param:DispatchParam):MapHot{
			var hot:MapHot = new MapHot();
			hot.setGeometry(param.vline);
			hot.setShowEvent(true);
			hot.setMethod(2);
			var callBack:String = param.vstr;
			hot.setCallBack(callBack);
			var size:int = param.vint;
			if(size == 0){
				size = 1;
			}
			hot.setSize(size);
			hot.setId(param.vstr);
			hot.setGroup(param.vstr);
			return hot;
		}
		/* poly's event */
		private function polyEvent(param:DispatchParam):MapHot{
			var hot:MapHot = new MapHot();
			hot.setGeometry(param.vpoly);
			hot.setShowEvent(true);
			hot.setMethod(2);
			var callBack:String = param.vstr;
			hot.setCallBack(callBack);
			var size:int = param.vint;
			if(size == 0){
				size = 1;
			}
			hot.setSize(size);
			hot.setId(param.vstr);
			hot.setGroup(param.vstr);
			return hot;
		}
		/* point's hot and flare */
		private function pointHotFlare(param:DispatchParam):MapHot{
			var hot:MapHot = new MapHot();
			var type:String = param.vstr;
			if("tip" == type){
				addStrFlare(hot,param.vstr,param.vpoint,param.vstr,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("image" == type){
				addImageFlare(hot,param.vstr,param.vpoint,param.vstr,param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("video" == type){
				addVideoFlare(hot,param.vstr,param.vpoint,param.vstr,param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("listWin" == type){
				addListWinFlare(hot,param.vstr,param.vpoint,param.vstr,getMapListTip(param.vstr),param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			return hot;
		}
		/* line's hot and flare */
		private function lineHotFlare(param:DispatchParam):MapHot{
			var hot:MapHot = new MapHot();
			var type:String = param.vstr;
			if("tip" == type){
				addStrFlare(hot,param.vstr,param.vline,param.vstr,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("image" == type){
				addImageFlare(hot,param.vstr,param.vline,param.vstr,param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("video" == type){
				addVideoFlare(hot,param.vstr,param.vline,param.vstr,param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("listWin" == type){
				addListWinFlare(hot,param.vstr,param.vline,param.vstr,getMapListTip(param.vstr),param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			return hot;
		}
		/* poly's hot and flare */
		private function polyHotFlare(param:DispatchParam):MapHot{
			var hot:MapHot = new MapHot();
			var type:String = param.vstr;
			if("tip" == type){
				addStrFlare(hot,param.vstr,param.vpoly,param.vstr,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("image" == type){
				addImageFlare(hot,param.vstr,param.vpoly,param.vstr,param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("video" == type){
				addVideoFlare(hot,param.vstr,param.vpoly,param.vstr,param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			if("listWin" == type){
				addListWinFlare(hot,param.vstr,param.vpoly,param.vstr,getMapListTip(param.vstr),param.vint,param.vint,param.vint,param.vintary,param.vstr,param.vstr);
				return hot;
			}
			return hot;
		}
		/* menu */
		private function menu(geo:Geometry,xml:XML,noShowLevel:Array,size:int,id:String,group:String):MapHot{
			var hot:MapHot = new MapHot();
			hot.setMethod(3);//3右键
			hot.setGeometry(geo);
			hot.setXml(xml);
			//callBack
			hot.setNoShowLevel(noShowLevel);
			hot.setSize(size);
			hot.setId(id);
			hot.setGroup(group);
			return hot;
		}
		//文字
		private function addStr(hot:MapHot,method:int,geo:Geometry,content:String,size:int,noShowLevel:Array,id:String,group:String):void{
			hot.setMethod(method);
			hot.setGeometry(geo);
			hot.setContent(content);
			hot.setSize(size);
			hot.setNoShowLevel(noShowLevel);
			hot.setId(id);
			hot.setGroup(group);
		}
		private function addStrFlare(hot:MapHot,flare:String,geo:Geometry,content:String,size:int,noShowLevel:Array,id:String,group:String):void{
			hot.setMethod(1);//移动时闪烁
			hot.setShowFlare(true);
			hot.setGeometry(geo);
			hot.setContent(content);
			hot.setSize(size);
			hot.setNoShowLevel(noShowLevel);
			hot.setId(id);
			hot.setGroup(group);
			//设置flare
			if(geo is FPoint){
				pointFlare(hot,flare);
			}else if(geo is Line){
				lineFlare(hot,flare);
			}else if(geo is Polygon){
				polyFlare(hot,flare);
			}
		}
		//图片
		private function addImage(hot:MapHot,method:int,geo:Geometry,url:String,size:int,width:int,height:int,noShowLevel:Array,id:String,group:String):void{
			hot.setMethod(method);
			hot.setGeometry(geo);
			hot.setImageUrl(url);
			hot.setSize(size);
			hot.setImageWidth(width);
			hot.setImageHeight(height);
			hot.setNoShowLevel(noShowLevel);
			hot.setId(id);
			hot.setGroup(group);
		}
		private function addImageFlare(hot:MapHot,flare:String,geo:Geometry,url:String,size:int,width:int,height:int,noShowLevel:Array,id:String,group:String):void{
			hot.setMethod(1);
			hot.setShowFlare(true);
			hot.setGeometry(geo);
			hot.setImageUrl(url);
			hot.setSize(size);
			hot.setImageWidth(width);
			hot.setImageHeight(height);
			hot.setNoShowLevel(noShowLevel);
			hot.setId(id);
			hot.setGroup(group);
			//设置flare
			if(geo is FPoint){
				pointFlare(hot,flare);
			}else if(geo is Line){
				lineFlare(hot,flare);
			}else if(geo is Polygon){
				polyFlare(hot,flare);
			}
		}
		//视频
		private function addVideo(hot:MapHot,method:int,geo:Geometry,url:String,size:int,width:int,height:int,noShowLevel:Array,id:String,group:String):void{
			hot.setMethod(method);
			hot.setGeometry(geo);
			hot.setVideoUrl(url);
			hot.setSize(size);
			hot.setImageWidth(width);
			hot.setImageHeight(height);
			hot.setNoShowLevel(noShowLevel);
			hot.setId(id);
			hot.setGroup(group);
		}
		private function addVideoFlare(hot:MapHot,flare:String,geo:Geometry,url:String,size:int,width:int,height:int,noShowLevel:Array,id:String,group:String):void{
			hot.setMethod(1);
			hot.setShowFlare(true);
			hot.setGeometry(geo);
			hot.setVideoUrl(url);
			hot.setSize(size);
			hot.setImageWidth(width);
			hot.setImageHeight(height);
			hot.setNoShowLevel(noShowLevel);
			hot.setId(id);
			hot.setGroup(group);
			//设置flare
			if(geo is FPoint){
				pointFlare(hot,flare);
			}else if(geo is Line){
				lineFlare(hot,flare);
			}else if(geo is Polygon){
				polyFlare(hot,flare);
			}
		}
		//视频列表(暂未用到)
		private function addVideoWin(hot:MapHot,method:int,geo:Geometry,url:String,size:int,width:int,height:int,noShowLevel:Array,id:String):void{
			hot.setMethod(method);
			hot.setGeometry(geo);
			hot.setVideoWinUrl(url);
			hot.setSize(size);
			hot.setImageWidth(width);
			hot.setImageHeight(height);
			hot.setNoShowLevel(noShowLevel);
			hot.setId(id);
		}
		//列表
		private function addListWin(hot:MapHot,method:int,geo:Geometry,title:String,mapListTip:MapListTip,size:int,width:int,height:int,noShowLevel:Array,id:String,group:String):void{
			hot.setMethod(method);
			hot.setGeometry(geo);
			mapListTip.setTitle(title);
			hot.setMapListTip(mapListTip);
			hot.setSize(size);
			hot.setImageWidth(width);
			hot.setImageHeight(height);
			hot.setNoShowLevel(noShowLevel);
			hot.setId(id);
			hot.setGroup(group);
		}
		private function addListWinFlare(hot:MapHot,flare:String,geo:Geometry,title:String,mapListTip:MapListTip,size:int,width:int,height:int,noShowLevel:Array,id:String,group:String):void{
			hot.setMethod(1);
			hot.setShowFlare(true);
			hot.setGeometry(geo);
			mapListTip.setTitle(title);
			hot.setMapListTip(mapListTip);
			hot.setSize(size);
			hot.setImageWidth(width);
			hot.setImageHeight(height);
			hot.setNoShowLevel(noShowLevel);
			hot.setId(id);
			hot.setGroup(group);
			//设置flare
			if(geo is FPoint){
				pointFlare(hot,flare);
			}else if(geo is Line){
				lineFlare(hot,flare);
			}else if(geo is Polygon){
				polyFlare(hot,flare);
			}
		}
		
		private function pointFlare(hot:MapHot,param:String):void{
			var splitResult:Array = AppContext.getAppUtil().getStringArray(param,"||");
			for(var i:int=1;i<splitResult.length;i+=2){
				var type:String = splitResult[i];
				var value:String = splitResult[i+1];
				if("color" == type){
					hot.setColor(AppContext.getAppUtil().getColor(value));
				}else if("lightColor" == type){
					hot.setLightColor(AppContext.getAppUtil().getColor(value));
				}else if("weight" == type){
					hot.setWeight(AppContext.getAppUtil().getInt(value));
				}else if("type" == type){
					hot.setPointType(AppContext.getAppUtil().getInt(value));
				}
			}
		}
		private function lineFlare(hot:MapHot,param:String):void{
			var splitResult:Array = AppContext.getAppUtil().getStringArray(param,"||");
			for(var i:int=1;i<splitResult.length;i+=2){
				var type:String = splitResult[i];
				var value:String = splitResult[i+1];
				if("color" == type){
					hot.setColor(AppContext.getAppUtil().getColor(value));
				}else if("lightColor" == type){
					hot.setLightColor(AppContext.getAppUtil().getColor(value));
				}else if("weight" == type){
					hot.setWeight(AppContext.getAppUtil().getInt(value));
				}else if("startArrow" == type && value.length > 0){
					hot.setStartArrow(value);
				}else if("endArrow" == type && value.length > 0){
					hot.setEndArrow(value);
				}else if("dashStyle" == type && value.length > 0){
					hot.setDashStyle(value);
				}
			}
		}
		private function polyFlare(hot:MapHot,param:String):void{
			var splitResult:Array = AppContext.getAppUtil().getStringArray(param,"||");
			for(var i:int=1;i<splitResult.length;i+=2){
				var type:String = splitResult[i];
				var value:String = splitResult[i+1];
				if("color" == type){
					hot.setColor(AppContext.getAppUtil().getColor(value));
				}else if("fillColor" == type){
					hot.setFillColor(AppContext.getAppUtil().getColor(value));
				}else if("lightColor" == type){
					hot.setLightColor(AppContext.getAppUtil().getColor(value));
				}else if("lightFillColor" == type){
					hot.setLightFillColor(AppContext.getAppUtil().getColor(value));
				}else if("weight" == type){
					hot.setWeight(AppContext.getAppUtil().getInt(value));
				}else if("opacity" == type){
					hot.setOpacity(AppContext.getAppUtil().getNumberEx(value,0.1));
				}
			}
		}
		//获取mapListTip
		private function getMapListTip(param:String):MapListTip{
			var splitResult:Array = AppContext.getAppUtil().getStringArray(param,"||");
			var itemCount:int = AppContext.getAppUtil().getIntEx(splitResult[0],0);
			var mapListTip:MapListTip = AppContext.getMapContext().getMapTipFactory().getListTip();
			for(var i:int=1;i<splitResult.length;i+=3){
				var type:String = splitResult[i];
				var name:String = splitResult[i+1];
				var value:String = splitResult[i+2];
				if("txt" == type){
					mapListTip.addText(name,value);
				}else if("textArea" == type){
					mapListTip.addTextArea(name,value);
				}else if("img" == type){
					mapListTip.addImage(name,value);
				}else if("vid" == type){
					mapListTip.addVideo(name,value);
				}else if("link" == type){
					var linkParam:String = splitResult[i+3];//新打开页面标题
					mapListTip.addLinkURL(name,value,linkParam);
					i++;
				}else if("js" == type){
					mapListTip.addLinkJS(name,value);
				}else if("close" == type){
					var closed:Boolean = AppContext.getAppUtil().getBoolean(value);
					mapListTip.addClose(name,closed);
				}
			}
			return mapListTip;
		}
		private function getMapXml(param:String):XML{
			var xml:XML = new XML(param);
			//trace(xml.toString());
			return xml;
		}
	}
}