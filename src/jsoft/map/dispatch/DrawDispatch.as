package jsoft.map.dispatch
{
	import flash.external.ExternalInterface;
	
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.symbol.BarSymbol;
	import jsoft.map.symbol.CircleDynSymbol;
	import jsoft.map.symbol.CircleSymbol;
	import jsoft.map.symbol.DynPointSymbol;
	import jsoft.map.symbol.DynPointSymbolEx;
	import jsoft.map.symbol.HotImagePointSymbol;
	import jsoft.map.symbol.ImagePointSymbol;
	import jsoft.map.symbol.ImageWinPointSymbol;
	import jsoft.map.symbol.LableSymbol;
	import jsoft.map.symbol.LegendSymbol;
	import jsoft.map.symbol.LineDynSymbol;
	import jsoft.map.symbol.LineSymbol;
//	import jsoft.map.symbol.LineSymbolMeter;
	import jsoft.map.symbol.MapCircleDynSymbol;
	import jsoft.map.symbol.MapCircleSymbol;
	import jsoft.map.symbol.PieSymbol;
	import jsoft.map.symbol.PolygonDynSymbol;
	import jsoft.map.symbol.PolygonSymbol;
	import jsoft.map.symbol.SimplePointSymbol;
	import jsoft.map.symbol.SimplePointSymbolEx;
	import jsoft.map.symbol.SwfPointSymbol;
	import jsoft.map.util.Map;
	
	public class DrawDispatch implements Dispatcher
	{
		public function DrawDispatch() {
		}
		
		public function sendMessage(param:DispatchParam):void {
			//AppContext.getAppUtil().alert("aaaa param.Type="+param.Type);
			//AppContext.getAppUtil().alert("DrawDispatch param.Type="+param.Type);
			if("spoint" == param.Type) {
				drawSimplePoint(param.vnum,param.vnum,param.vcolor,param.vnum,param.vint,param.vstr,param.vstr);
				return;
			}
			if("sepoint" == param.Type) {
				drawSimplePointEx(param.vnum,param.vnum,param.vcolor,param.vcolor,param.vnum,param.vnum,param.vint,param.vstr,param.vstr);
				return;
			}
			if("sdpoint" == param.Type) {
				drawDynPoint(param.vnum,param.vnum,param.vcolor,param.vcolor,param.vnum,param.vint,param.vint,param.vstr,param.vstr);
				return;
			}
			if("sedpoint" == param.Type) {
				drawDynPointEx(param.vnum,param.vnum,param.vcolor,param.vcolor,param.vcolor,param.vcolor,param.vnum,param.vnum,param.vint,param.vint,param.vstr,param.vstr);
				return;
			}
			if("pointimage" == param.Type) {
				drawImagePoint(param.vnum,param.vnum,param.vstr,param.vint,param.vint,param.vstr,param.vstr);
				return;
			}
			//带输入窗口的image 2012/03/28
			if("pointWinImage" == param.Type) {
				drawWinImagePoint(param.vnum,param.vnum,param.vstr,param.vint,param.vint,param.vstr,param.vstr);
				return;
			}
			if("pointHotimage" == param.Type) {
				drawHotImagePoint(param.vnum,param.vnum,param.vstr,param.vstr,param.vint,param.vint,param.vstr,param.vstr);
				return;
			}
			if("pointswf" == param.Type) {
				drawSwfPoint(param.vnum,param.vnum,param.vstr,param.vint,param.vint,param.vstr,param.vstr);
				return;
			}
			if("Line" == param.Type) {
				drawLine(param.vnumary,param.vnumary,param.vcolor,param.vint,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr);
				return;
			}
			if("LineDyn" == param.Type) {
				drawDynLine(param.vnumary,param.vnumary,param.vcolor,param.vcolor,param.vint,param.vstr,param.vstr,param.vstr,param.vint,param.vstr,param.vstr);
				return;
			}
			if("Polygon" == param.Type) {
				drawPolygon(param.vnumary,param.vnumary,param.vcolor,param.vcolor,param.vint,param.vnum,param.vstr,param.vstr);
				return;
			}
			if("PolygonDyn" == param.Type) {
				drawDynPolygon(param.vnumary,param.vnumary,param.vcolor,param.vcolor,param.vcolor,param.vcolor,param.vint,param.vnum,param.vint,param.vstr,param.vstr);
				return;
			}
			if("Lable" == param.Type) {
				drawLable(param.vnum,param.vnum,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "drawCircle") {
				drawCircle(param.vnum,param.vnum,param.vnum,param.vcolor,param.vcolor,param.vint,param.vnum,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "drawMapCircle") {
				drawMapCircle(param.vnum,param.vnum,param.vnum,param.vcolor,param.vcolor,param.vint,param.vnum,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "drawDynCircle") {
				drawDynCircle(param.vnum,param.vnum,param.vnum,param.vcolor,param.vcolor,param.vcolor,param.vcolor,param.vint,param.vnum,param.vint,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "drawMapDynCircle") {
				drawMapDynCircle(param.vnum,param.vnum,param.vnum,param.vcolor,param.vcolor,param.vcolor,param.vcolor,param.vint,param.vnum,param.vint,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "drawRect") {
				drawRect(param.vnum,param.vnum,param.vnum,param.vnum,param.vcolor,param.vcolor,param.vint,param.vnum,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "drawDynRect") {
				drawDynRect(param.vnum,param.vnum,param.vnum,param.vnum,param.vcolor,param.vcolor,param.vcolor,param.vcolor,param.vint,param.vnum,param.vint,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "drawPie") {
				drawPie(param.vnum,param.vnum,param.vstrary,param.vnumary,param.vcolorary,param.vnum,param.vnum,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "drawBar") {
				drawBar(param.vnum,param.vnum,param.vstrary,param.vnumary,param.vcolorary,param.vnum,param.vnum,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "drawLegend") {
				drawLegend(param.vint,param.vint,param.vstr,param.vint,param.vstr,param.vstr,param.vstrary,param.vstrary,param.vstrary,param.vstr,param.vstr);
			}
			if(param.Type == "removeById") {
				removeById(param.vstr);
				return;
			}
			if(param.Type == "removeByGroup") {
				removeByGroup(param.vstr);
				return;
			}
			if(param.Type == "moveById") {
				moveById(param.vstr,param.vnum,param.vline,param.vbool);
				return;
			}
			if(param.Type == "moveByGroup") {
				moveByGroup(param.vstr,param.vnum,param.vline,param.vbool);
				return;
			}
			if(param.Type == "moveToById") {
				moveToById(param.vstr,param.vnum,param.vnum);
				return;
			}
			if(param.Type == "moveToByGroup") {
				moveToByGroup(param.vstr,param.vnum,param.vnum);
				return;
			}
			if(param.Type == "pause") {
				pauseAnimate();
				return;
			}
			if(param.Type == "resume") {
				resumeAnimate();
				return;
			}
			if(param.Type == "stop") {
				stopAnimate();
				return;
			}
			//设置鼠标样式 start  end
			if(param.Type == "setCursor"){
				setCursor(param.vstr);
				return;
			}
			if(param.Type == "setSymbolIdVisible"){
				AppContext.getMapContext().getMapDrawLayer().setSymbolIdVisible(param.vstr,param.vbool);
				return;
			}
			if(param.Type == "setSymbolGroupVisible") {
				AppContext.getMapContext().getMapDrawLayer().setSymbolGroupVisible(param.vstr,param.vbool);
				return;
			}
		}
		
		public function getMessage(param:DispatchParam):String {
			if(param.Type == "getSymbolIds") {
				return getSymbolIds();
			}
			if(param.Type == "getSymbolGroups") {
				return getSymbolGroups();
			}
			if(param.Type == "getLocationById") {
				return getLocationById(param.vstr);
			}
			if(param.Type == "getLocationByGroup") {
				return getLocationByGroup(param.vstr);
			}
			return "";
		}
		
		public function drawSimplePoint(x:Number,y:Number,color:int,size:Number,type:int,id:String,group:String):void {
			var symbol:SimplePointSymbol = new SimplePointSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			if(size == 0) {
				size = 5;
			}
			symbol.setSize(size);
			symbol.setType(type);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		public function drawSimplePointEx(x:Number,y:Number,color:int,outlineColor:int,size:Number,outlineWidth:Number,type:int,id:String,group:String):void {
			var symbol:SimplePointSymbolEx = new SimplePointSymbolEx();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			if(size == 0) {
				size = 5;
			}
			symbol.setSize(size);
			symbol.setType(type);
			symbol.setOutlineColor(outlineColor);
			symbol.setOutlineWidth(outlineWidth);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		public function drawDynPoint(x:Number,y:Number,color:int,lightColor:int,size:Number,type:int,flare:int,id:String,group:String):void {
			var symbol:DynPointSymbol = new DynPointSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			symbol.setLightColor(lightColor);
			if(size == 0) {
				size = 5;
			}
			symbol.setSize(size);
			symbol.setType(type);
			symbol.setFlare(flare);
			if(flare == -1 || flare > 0) {
				symbol.enableFrame();
			}
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		public function drawDynPointEx(x:Number,y:Number,color:int,outlineColor:int,lightColor:int,lightOutlineColor:int,size:Number,outlineWidth:Number,type:int,flare:int,id:String,group:String):void {
			var symbol:DynPointSymbolEx = new DynPointSymbolEx();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			symbol.setLightColor(lightColor);
			if(size == 0) {
				size = 5;
			}
			symbol.setSize(size);
			symbol.setType(type);
			symbol.setOutlineColor(outlineColor);
			symbol.setLightOutlineColor(lightOutlineColor);
			symbol.setOutlineWidth(outlineWidth);
			symbol.setFlare(flare);
			if(flare == -1 || flare > 0) {
				symbol.enableFrame();
			}
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		public function drawImagePoint(x:Number,y:Number,imgUrl:String,width:int,height:int,id:String,group:String):void {
			var symbol:ImagePointSymbol = new ImagePointSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setImgUrl(imgUrl);
			symbol.setImgWidth(width);
			symbol.setImgHeight(height);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		//带输入窗口的image 2012/03/28
		public function drawWinImagePoint(x:Number,y:Number,imgUrl:String,width:int,height:int,id:String,group:String):void{
			var symbol:ImageWinPointSymbol = new ImageWinPointSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			var win:Map = AppContext.getMapContext().getMapDrawLayer().getHashMap();//获取key-value
			//随机生成一个id
			var id:String = "win_" + randRange(0,1000);
			while(win.containsKey(id)){
				id = "win_" + randRange(0,1000);
			}
			
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup("winImageGroup");
			symbol.setImgUrl(imgUrl);
			symbol.setImgWidth(width);
			symbol.setImgHeight(height);
			symbol.setWinId(id + "hot");//确保了key--value唯一
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
			//加入热点
			//回调js窗口
			ExternalInterface.call("fMap.callback");
		}
		//在一个范围内随机生成一个数  2012/03/28
		private function randRange(minNumber:Number,maxNumber:Number):Number{ 
        	return Math.floor(Math.random() * (maxNumber-minNumber+1)) + minNumber;
        } 
		
		public function drawHotImagePoint(x:Number,y:Number,imgUrl:String,hotImgUrl:String,width:int,height:int,id:String,group:String):void {
			var symbol:HotImagePointSymbol = new HotImagePointSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setImgUrl(imgUrl);
			symbol.setHotImgUrl(hotImgUrl);
			symbol.setImgWidth(width);
			symbol.setImgHeight(height);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		public function drawSwfPoint(x:Number,y:Number,imgUrl:String,width:int,height:int,id:String,group:String):void {
			var symbol:SwfPointSymbol = new SwfPointSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setImgUrl(imgUrl);
			symbol.setImgWidth(width);
			symbol.setImgHeight(height);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		public function drawLine(x:Array,y:Array,color:int,width:int,startArrow:String,endArrow:String,dashStyle:String,id:String,group:String):void {
			var symbol:LineSymbol = new LineSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createLine(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			if(width == 0) {
				width = 1;
			}
			symbol.setWidth(width);
			symbol.setStartArrow(startArrow);
			symbol.setEndArrow(endArrow);
			symbol.setDashStyle(dashStyle);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		public function drawDynLine(x:Array,y:Array,color:int,lightColor:int,width:int,startArrow:String,endArrow:String,dashStyle:String,flare:int,id:String,group:String):void {
			var symbol:LineDynSymbol = new LineDynSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createLine(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			symbol.setLightColor(lightColor);
			if(width == 0) {
				width = 1;
			}
			//AppContext.getAppUtil().alert("drawDynLine width="+width);
			symbol.setWidth(width);
			symbol.setStartArrow(startArrow);
			symbol.setEndArrow(endArrow);
			symbol.setDashStyle(dashStyle);
			symbol.setFlare(flare);
			if(flare == -1 || flare > 0) {
				symbol.enableFrame();
			}
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		public function drawPolygon(x:Array,y:Array,color:int,fillColor:int,weight:int,opacity:Number,id:String,group:String):void {
			var symbol:PolygonSymbol = new PolygonSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPolygon(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			symbol.setFillColor(fillColor);
			if(weight == 0) {
				weight = 1;
			}
			symbol.setWeight(weight);
			symbol.setOpacity(opacity);
			//AppContext.getAppUtil().alert("drawPolygon opacity="+opacity);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		public function drawDynPolygon(x:Array,y:Array,color:int,lightColor:int,fillColor:int,lightFillColor:int,weight:int,opacity:Number,flare:int,id:String,group:String):void {
			var symbol:PolygonDynSymbol = new PolygonDynSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPolygon(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			symbol.setLightColor(lightColor);
			symbol.setFillColor(fillColor);
			symbol.setLightFillColor(lightFillColor);
			if(weight == 0) {
				weight = 1;
			}
			symbol.setWeight(weight);
			symbol.setOpacity(opacity);
			symbol.setFlare(flare);
			if(flare == -1 || flare > 0) {
				symbol.enableFrame();
			}
			//AppContext.getAppUtil().alert("drawDynPolygon flare="+flare);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		public function drawLable(x:Number,y:Number,text:String,fontName:String,fontColor:String,fontSize:String,backColor:String,backOutlineColor:String,shadowColor:String,id:String,group:String):void {
			var symbol:LableSymbol = new LableSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setFieldValue(text);
			if(fontName != null && fontName != "") {
				symbol.setFontName(fontName);
			}
			if(fontColor != null && fontColor != "") {
				symbol.setColor(AppContext.getAppUtil().getColor(fontColor));
			}
			if(fontSize != null && fontSize != "") {
				symbol.setFontSize(AppContext.getAppUtil().getInt(fontSize));
			}
			if(backColor != null && backColor != "") {
				symbol.setBackColor(AppContext.getAppUtil().getColor(backColor));
			}
			if(backOutlineColor != null && backOutlineColor != "") {
				symbol.setBackOutlineColor(AppContext.getAppUtil().getColor(backOutlineColor));
			}
			if(shadowColor != null && shadowColor != "") {
				symbol.setShadowColor(AppContext.getAppUtil().getColor(shadowColor));
			}
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		private function drawCircle(x:Number,y:Number,r:Number,color:int,fillColor:int,weight:int,opacity:Number,id:String,group:String) : void {
			var symbol:CircleSymbol = new CircleSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSize(r);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			symbol.setFillColor(fillColor);
			if(weight == 0) {
				weight = 1;
			}
			symbol.setWeight(weight);
			symbol.setOpacity(opacity);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		private function drawMapCircle(x:Number,y:Number,r:Number,color:int,fillColor:int,weight:int,opacity:Number,id:String,group:String) : void {
			var symbol:MapCircleSymbol = new MapCircleSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSize(r);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			symbol.setFillColor(fillColor);
			if(weight == 0) {
				weight = 1;
			}
			symbol.setWeight(weight);
			symbol.setOpacity(opacity);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		private function drawDynCircle(x:Number,y:Number,r:Number,color:int,fillColor:int,lightColor:int,lightFillColor:int,weight:int,opacity:Number,flare:int,id:String,group:String) : void {
			var symbol:CircleDynSymbol = new CircleDynSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSize(r);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			symbol.setFillColor(fillColor);
			symbol.setLightColor(lightColor);
			symbol.setLightFillColor(lightFillColor);
			if(weight == 0) {
				weight = 1;
			}
			symbol.setWeight(weight);
			symbol.setOpacity(opacity);
			symbol.setFlare(flare);
			if(flare == -1 || flare > 0) {
				symbol.enableFrame();
			}
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		private function drawMapDynCircle(x:Number,y:Number,r:Number,color:int,fillColor:int,lightColor:int,lightFillColor:int,weight:int,opacity:Number,flare:int,id:String,group:String) : void {
			var symbol:MapCircleDynSymbol = new MapCircleDynSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSize(r);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			symbol.setFillColor(fillColor);
			symbol.setLightColor(lightColor);
			symbol.setLightFillColor(lightFillColor);
			if(weight == 0) {
				weight = 1;
			}
			symbol.setWeight(weight);
			symbol.setOpacity(opacity);
			symbol.setFlare(flare);
			if(flare == -1 || flare > 0) {
				symbol.enableFrame();
			}
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		private function drawRect(x1:Number,y1:Number,x2:Number,y2:Number,color:int,fillColor:int,weight:int,opacity:Number,id:String,group:String) : void {
			var symbol:PolygonSymbol = new PolygonSymbol();
			var x:Array = new Array();
			var y:Array = new Array();
			x[0] = x1;
			y[0] = y1;
			
			x[1] = x1;
			y[1] = y2;
			
			x[2] = x2;
			y[2] = y2;
			
			x[3] = x2;
			y[3] = y1;
			
			x[4] = x1;
			y[4] = y1;
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPolygon(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			symbol.setFillColor(fillColor);
			if(weight == 0) {
				weight = 1;
			}
			symbol.setWeight(weight);
			symbol.setOpacity(opacity);
			//AppContext.getAppUtil().alert("drawPolygon opacity="+opacity);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		private function drawDynRect(x1:Number,y1:Number,x2:Number,y2:Number,color:int,fillColor:int,lightColor:int,lightFillColor:int,weight:int,opacity:Number,flare:int,id:String,group:String) : void {
			var symbol:PolygonDynSymbol = new PolygonDynSymbol();
			var x:Array = new Array();
			var y:Array = new Array();
			x[0] = x1;
			y[0] = y1;
			
			x[1] = x1;
			y[1] = y2;
			
			x[2] = x2;
			y[2] = y2;
			
			x[3] = x2;
			y[3] = y1;
			
			x[4] = x1;
			y[4] = y1;
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPolygon(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setColor(color);
			symbol.setFillColor(fillColor);
			symbol.setLightColor(lightColor);
			symbol.setLightFillColor(lightFillColor);
			symbol.setFlare(flare);
			if(flare == -1 || flare > 0) {
				symbol.enableFrame();
			}
			if(weight == 0) {
				weight = 1;
			}
			symbol.setWeight(weight);
			symbol.setOpacity(opacity);
			//AppContext.getAppUtil().alert("drawPolygon opacity="+opacity);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		private function drawPie(x:Number,y:Number,nameAry:Array,valueAry:Array,colorAry:Array,size:Number,opacity:Number,id:String,group:String) : void {
			var symbol:PieSymbol = new PieSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setNameAry(nameAry);
			symbol.setValue(valueAry);
			symbol.setColor(colorAry);
			symbol.setSize(size);
			symbol.setOpacity(opacity);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		private function drawBar(x:Number,y:Number,nameAry:Array,valueAry:Array,colorAry:Array,size:Number,opacity:Number,id:String,group:String) : void {
			//AppContext.getAppUtil().alert("xxxddd");
			var symbol:BarSymbol = new BarSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			symbol.setNameAry(nameAry);
			symbol.setValue(valueAry);
			symbol.setColor(colorAry);
			symbol.setSize(size);
			symbol.setOpacity(opacity);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		//绘制图例 by--小江 
		private function drawLegend(x:int,y:int,directin:String,rowNum:int,bgColor:String,borderColor:String,type:Array,color_url:Array,lable:Array,id:String,group:String):void{
			var symbol:LegendSymbol = new LegendSymbol();
			var geo:Geometry = AppContext.getMapContext().getGeometryFactory().createPoint(x,y);
			symbol.setGeometry(geo);
			symbol.setDirection(directin);
			symbol.setRowNum(rowNum);
			symbol.setBgColor(bgColor);
			symbol.setBorderColor(borderColor);
			symbol.setTypeAry(type);
			symbol.setCol_Url(color_url);
			symbol.setLableAry(lable);
			symbol.setDirection(directin);
			symbol.setSymbolId(id);
			symbol.setGroup(group);
			AppContext.getMapContext().getMapDrawLayer().addSymbol(symbol);
		}
		
		private function removeById(id:String) : void {
			//AppContext.getAppUtil().alert("removeById id="+id);
			AppContext.getMapContext().getMapDrawLayer().removeSymbolById(id);
		}
		
		private function removeByGroup(group:String) : void {
			AppContext.getMapContext().getMapDrawLayer().removeSymbolByGroup(group);
		}
		
		private function getSymbolIds() : String {
			return AppContext.getMapContext().getMapDrawLayer().getSymbolIds();
		}
		
		private function getSymbolGroups() : String {
			return AppContext.getMapContext().getMapDrawLayer().getSymbolGroups();
		}
		
		private function getLocationById(id:String) : String {
			return AppContext.getMapContext().getMapDrawLayer().getLocationById(id);
		}
		
		private function getLocationByGroup(group:String) : String {
			return AppContext.getMapContext().getMapDrawLayer().getLocationByGroup(group);
		}
		
		private function moveToById(id:String,x:Number,y:Number) : void {
			AppContext.getMapContext().getMapDrawLayer().moveToById(id,x,y);
		}
		
		private function moveToByGroup(group:String,x:Number,y:Number) : void {
			AppContext.getMapContext().getMapDrawLayer().moveToByGroup(group,x,y);
		}
		
		private function moveById(id:String,speed:Number,line:Line,viewFlag:Boolean) : void {
			AppContext.getMapContext().getMapDrawLayer().moveById(id,speed,line,viewFlag);
		}
		
		private function moveByGroup(group:String,speed:Number,line:Line,viewFlag:Boolean) : void {
			AppContext.getMapContext().getMapDrawLayer().moveByGroup(group,speed,line,viewFlag);
		}
		private function pauseAnimate():void {
			AppContext.getMapContext().getMapDrawLayer().pauseAnimate();
		}
		private function resumeAnimate():void {
			AppContext.getMapContext().getMapDrawLayer().resumeAnimate();
		}
		private function stopAnimate():void {
			AppContext.getMapContext().getMapDrawLayer().stopAnimate();
		}
		private function setCursor(cursor:String):void{
			if(cursor == "start"){
				MapCursorManager.setStart();
			}else if(cursor == "end"){
				MapCursorManager.setEnd();
			}
		}
	}
}