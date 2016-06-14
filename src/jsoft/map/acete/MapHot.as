package jsoft.map.acete
{
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.MultiPoint;
	import jsoft.map.symbol.DynPointSymbol;
	import jsoft.map.symbol.LineDynSymbol;
	import jsoft.map.symbol.PolygonDynSymbol;
	import jsoft.map.tip.MapImageTip;
	import jsoft.map.tip.MapListTip;
	import jsoft.map.tip.MapTextTip;
	import jsoft.map.tip.MapVideoTip;
	import jsoft.map.tip.impl.MapMenuTipImpl;
	import jsoft.map.util.DrawUtil;
	
	
	public class MapHot
	{
		private var id:String;
		private var group:String;
		private var geometry:Geometry;
		private var content:String;
		private var method:int = 1;//鼠标滑动显示=1，鼠标点击显示=2
		private var size:int = 1;
		private var callBack:String;
		private var imageUrl:String;
		private var videoUrl:String;
		private var videoWinUrl:String;//还没有用到
		private var imageWidth:int;
		private var imageHeight:int;
		private var mapListTip:MapListTip;
		private var color:int = 0;
		private var fillColor:int = 0xFF0000;
		private var lightColor:int = 0xFFF000;
		private var lightFillColor:int = 0xFFFF00;
		private var weight:int = 1;
		private var opacity:Number = 0.1;
		private var hotArea:Array;
		private var xml:XML;
		private var pointType:int = 1;
		private var showFlare:Boolean = false;//闪烁
		private var showEvent:Boolean = false;//事件
		private var startArrow:String;
		private var endArrow:String;
		private var dashStyle:String;
		private var noShowLevel:Array = new Array();//全显示
		
		public function MapHot(){
		}
		
		public function getId():String{
			return id;
		}
		public function setId(id:String):void{
			this.id = id;
		}
		public function getGroup():String{
			return group;
		}
		public function setGroup(group:String):void{
			this.group = group;
		}
		public function getContent():String{
			return content;
		}
		public function setContent(content:String):void{
			this.content = content;
		}
		public function getGeometry():Geometry{
			return geometry;
		}
		public function setGeometry(geometry:Geometry):void{
			this.geometry = geometry;
		}
		public function getMethod():int{
			return method;
		}
		public function setMethod(method:int):void{
			this.method = method;
		}
		public function getSize():int{
			return size;
		}
		public function setSize(size:int):void{
			this.size = size;
		}
		public function getImageUrl():String{
			return imageUrl;
		}
		public function setImageUrl(imageUrl:String):void{
			this.imageUrl = imageUrl;
		}
		public function getImageWidth():int{
			return imageWidth;
		}
		public function setImageWidth(imageWidth:int):void{
			this.imageWidth = imageWidth;
		}
		public function getImageHeight():int{
			return imageHeight;
		}
		public function setImageHeight(imageHeight:int):void{
			this.imageHeight = imageHeight;
		}
		public function getVideoUrl():String{
			return videoUrl;
		}
		public function setVideoUrl(videoUrl:String):void{
			this.videoUrl = videoUrl;
		}
		public function getVideoWinUrl():String{
			return videoWinUrl;
		}
		public function setVideoWinUrl(videoWinUrl:String):void{
			this.videoWinUrl = videoWinUrl;
		}
		public function getMapListTip():MapListTip{
			return mapListTip;
		}
		public function setMapListTip(mapListTip:MapListTip):void{
			this.mapListTip = mapListTip;
		}
		public function getCallBack():String{
			return callBack;
		}
		public function setCallBack(callBack:String):void{
			this.callBack = callBack;
		}
		public function getColor():int{
			return color;
		}
		public function setColor(color:int):void{
			this.color = color;
		}
		public function getFillColor():int{
			return fillColor;
		}
		public function setFillColor(fillColor:int):void{
			this.fillColor = fillColor;
		}
		public function getLightColor():int{
			return lightColor;
		}
		public function setLightColor(lightColor:int):void{
			this.lightColor = lightColor;
		}
		public function getLightFillColor():int{
			return lightFillColor;
		}
		public function setLightFillColor(lightFillColor:int):void{
			this.lightFillColor = lightFillColor;
		}
		public function getWeight():int{
			return weight;
		}
		public function setWeight(weight:int):void{
			this.weight = weight;
		}
		public function getOpacity():Number{
			return opacity;
		}
		public function setOpacity(opacity:Number):void{
			this.opacity = opacity;
		}
		public function getXml():XML{
			return xml;
		}
		public function setXml(xml:XML):void{
			this.xml = xml;
		}
		public function getShowFlare():Boolean{
			return showFlare;
		}
		public function setShowFlare(showFlare:Boolean):void{
			this.showFlare = showFlare;
		}
		public function getShowEvent():Boolean{
			return showEvent;
		}
		public function setShowEvent(showEvent:Boolean):void{
			this.showEvent = showEvent;
		}
		public function getPointType():int{
			return pointType;
		}
		public function setPointType(pointType:int):void{
			this.pointType = pointType;
		}
		public function getStartArrow():String{
			return startArrow;
		}
		public function setStartArrow(startArrow:String):void{
			this.startArrow = startArrow;
		}
		public function getEndArrow():String{
			return endArrow;
		}
		public function setEndArrow(endArrow:String):void{
			this.endArrow = endArrow;
		}
		public function getDashStyle():String{
			return dashStyle;
		}
		public function setDashStyle(dashStyle:String):void{
			this.dashStyle = dashStyle;
		}
		public function getNoShowLevel():Array{
			return noShowLevel;
		}
		public function setNoShowLevel(noShowLevel:Array):void{
			this.noShowLevel = noShowLevel;
		}
		
		//提示
		public function show(drawUtil:DrawUtil,x:int,y:int,fontName:String,fontColor:int,fontSize:int,showBackColor:Boolean,backColor:int,showBackOutlineColor:Boolean,backOutlineColor:int):void{
			var sx:int = x + 10;
			var sy:int = y - 5;
			if(geometry != null &&(geometry is FPoint || geometry is MultiPoint)){
				var cp:FPoint = geometry.getCenter();
				sx = AppContext.getMapContext().getMapContent().getCoordinate().mapToViewX(cp.getX()) + 10;
				sy = AppContext.getMapContext().getMapContent().getCoordinate().mapToViewY(cp.getY()) - 5;
			}
			if(content != null && content.length > 0){//文字
				var mapTextTip:MapTextTip = AppContext.getMapContext().getMapTipFactory().getTextTip();
				mapTextTip.setText(content);
				mapTextTip.setFontName(fontName);
				mapTextTip.setFontColor(fontColor);
				mapTextTip.setFontSize(fontSize);
				mapTextTip.setShowBack(showBackColor);
				mapTextTip.setBackColor(backColor);
				mapTextTip.setShowBackOutline(showBackOutlineColor);
				mapTextTip.setBackOutlineColor(backOutlineColor);
				AppContext.getMapContext().getMapTipFactory().addMapTip(sx,sy,mapTextTip);
			}else if(imageUrl != null && imageUrl.length > 0){//图片
				var mapImageTip:MapImageTip =AppContext.getMapContext().getMapTipFactory().getImageTip();
				mapImageTip.setImageUrl(imageUrl);
				mapImageTip.setImageWidth(imageWidth);
				mapImageTip.setImageHeight(imageHeight);
				AppContext.getMapContext().getMapTipFactory().addMapTip(sx,sy,mapImageTip);
			}else if(videoUrl != null && videoUrl.length > 0){//视频
				var mapVideoTip:MapVideoTip = AppContext.getMapContext().getMapTipFactory().getMapVideoTip();
				mapVideoTip.setVideoUrl(videoUrl);
				mapVideoTip.setVideoWidth(imageWidth);
				mapVideoTip.setVideoHeight(imageHeight);
				AppContext.getMapContext().getMapTipFactory().addMapTip(sx,sy,mapVideoTip);
			}else if(videoWinUrl != null && videoWinUrl.length > 0){//视频列表(未用到)
				var mapVideoWinTip:MapVideoTip = AppContext.getMapContext().getMapTipFactory().getMapVideoWinTip();
				mapVideoWinTip.setVideoUrl(videoWinUrl);
				mapVideoWinTip.setVideoWidth(imageWidth);
				mapVideoWinTip.setVideoHeight(imageHeight);
				AppContext.getMapContext().getMapTipFactory().addMapTip(sx,sy,mapVideoWinTip);
			}else if(mapListTip != null){//列表
				mapListTip.initMapLitTip();
				mapListTip.setWidth(imageWidth);
				mapListTip.setHeight(imageHeight);
				AppContext.getMapContext().getMapTipFactory().addMapTip(x,y,mapListTip);
			}
		}
		//菜单
		public function showMenu(x:int,y:int):void{
			if(xml != null){
				var mapMenu:MapMenuTipImpl = AppContext.getMapContext().getMapTipFactory().getMenuTip();
				mapMenu.setXml(xml);
				AppContext.getMapContext().getMapTipFactory().addMapTip(x,y,mapMenu);
			}
		}
		//闪烁
		public function drawFlare():void{
			if(geometry == null){
				return;
			}
			if("Point" == geometry.getGeometryName()){
				addPointSymbol();
			}else if("Line" == geometry.getGeometryName()){
				addLineSymbol();
			}else if("Polygon" == geometry.getGeometryName()){
				addPolySymbol();
			}
		}
		private function addPointSymbol():void{//加入闪烁点符号层
			var symbol:DynPointSymbol = new DynPointSymbol();
			symbol.setGeometry(geometry);
			symbol.setColor(color);
			symbol.setLightColor(lightColor);
			symbol.setSize(weight);
			symbol.setType(pointType);
			symbol.name = "hotSymbol";
			symbol.setFlare(-1);
			symbol.enableFrame();
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			symbol.showSymbol(coord);
			symbol.updateSymbol();
			var hotAcete:MapHotAcete = AppContext.getMapContext().getHotContainer();
			//AppContext.getMapContext().getMapDynInputLayer().addChild(symbol);
			hotAcete.addChild(symbol);
		}
		private function addLineSymbol():void{//加入闪烁线符号层
			var symbol:LineDynSymbol = new LineDynSymbol();
			symbol.setGeometry(geometry);
			symbol.setColor(color);
			symbol.setLightColor(lightColor);
			if(weight == 0){
				weight = 1;
			}
			symbol.setWidth(weight);
			if(startArrow!=null && startArrow.length>0){
				symbol.setStartArrow(startArrow);
			}
			if(endArrow!=null && endArrow.length>0){
				symbol.setEndArrow(endArrow);
			}
			if(dashStyle!=null && dashStyle.length>0){
				symbol.setDashStyle(dashStyle);
			}
			symbol.name = "hotSymbol";
			symbol.setFlare(-1);
			symbol.enableFrame();
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			symbol.showSymbol(coord);
			symbol.updateSymbol();
			var hotAcete:MapHotAcete = AppContext.getMapContext().getHotContainer();
			hotAcete.addChild(symbol);
		}
		private function addPolySymbol():void{//加入闪烁面符号层
			var symbol:PolygonDynSymbol = new PolygonDynSymbol();
			symbol.setGeometry(geometry);
			symbol.setColor(color);
			symbol.setFillColor(fillColor);
			symbol.setLightColor(lightColor);
			symbol.setLightFillColor(lightFillColor);
			if(weight == 0){
				weight = 1;
			}
			symbol.setWeight(weight);
			symbol.setOpacity(opacity);
			symbol.name = "hotSymbol";
			symbol.setFlare(-1);
			symbol.enableFrame();
			var coord:Coordinate = AppContext.getMapContext().getMapContent().getCoordinate();
			symbol.showSymbol(coord);
			symbol.updateSymbol();
			var hotAcete:MapHotAcete = AppContext.getMapContext().getHotContainer();
			hotAcete.addChild(symbol);
		}
		/* build hot area */
		public function buildHotArea():void{
			if(geometry == null){
				return;
			}
			var viewGeo:Geometry = AppContext.getGeomUtil().getViewGeometry(geometry);
			hotArea = AppContext.getGeomUtil().buildGeometryArea(viewGeo,size);
		}
		/* check hot area */
		public function checkHotArea(x:int,y:int):Boolean{
			if(hotArea == null){
				return false;
			}
			for(var i:int=0;i<hotArea.length;i++){
				var box:Box = hotArea[i];
				if(box.isContain(x,y)){
					return true;
				}
			}
			return false;
		}
	}
}