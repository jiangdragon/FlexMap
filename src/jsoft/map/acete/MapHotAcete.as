package jsoft.map.acete
{
	import flash.external.ExternalInterface;
	
	import jsoft.map.geometry.Envelope;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.Polygon;
	import jsoft.map.tip.MapTip;
	import jsoft.map.tip.impl.MapListTipImpl;
	import jsoft.map.tip.impl.MapMenuTipImpl;
	import jsoft.map.util.DrawUtil;
	
	import mx.core.UIComponent;
	
	public class MapHotAcete extends UIComponent
	{
		private var hots:Array = new Array();
		private var visibleHots:Array = new Array();
		private var drawUtil:DrawUtil;
		private var fontName:String="宋体";
		private var fontSize:int=12;
		private var fontColor:int = AppContext.getDrawUtil().getRed();
		private var showBackColor:Boolean = true;
		private var backColor:int = AppContext.getDrawUtil().getYellow();
		private var showBackOutlineColor:Boolean = true;
		private var backOutlineColor:int = AppContext.getDrawUtil().getBlue();
		
		public function MapHotAcete() {
			drawUtil = new DrawUtil(graphics);
		}
		//添加文字显示样式
		public function setTipStyle(fontName:String,fontColor:int,fontSize:int,showBackColor:Boolean,backColor:int,showBackOutlineColor:Boolean,backOutlineColor:int) : void {
			this.fontName=fontName;
			this.fontColor=fontColor;
			this.fontSize=fontSize;
			this.showBackColor=showBackColor;
			this.backColor=backColor;
			this.showBackOutlineColor=showBackOutlineColor;
			this.backOutlineColor=backOutlineColor;
		}
		//添加hot
		public function addHot(hot:MapHot):void{
			hots[hots.length] = hot;
		}
		//只显示
		public function show(mapHot:MapHot):void{
			var bounds:Envelope = mapHot.getGeometry().getBounds();
			var x:Number = bounds.getCenterX();
			var y:Number = bounds.getCenterY();
			var pX:int=AppContext.getMapContext().getMapContent().getCoordinate().mapToViewX(x);
			var pY:int=AppContext.getMapContext().getMapContent().getCoordinate().mapToViewY(y);
			mapHot.show(drawUtil,pX,pY,fontName,fontColor,fontSize,showBackColor,backColor,showBackOutlineColor,backOutlineColor);
			if(mapHot.getShowFlare()){//闪烁
				mapHot.drawFlare();
			}
		}
		/* mouse move show */
		public function showHot(x:int,y:int):Boolean{
			var mapTip:MapTip = AppContext.getMapContext().getMapTipFactory().getMapTip();
			if(mapTip is MapMenuTipImpl){
				var mapMenu:MapMenuTipImpl = mapTip as MapMenuTipImpl;
				if(mapMenu.getMenu()!=null){
					return false;
				}
			}
			var i:int = 0;
			var len:int = hots.length;
			for(i=0;i<len;i++){
				var mapHot:MapHot = hots[i];
				if(mapHot.getMethod() != 1){//1移动
					continue;//跳出本次循环
				}
				if(!mapHot.checkHotArea(x,y)){//不在区域
					continue;
				}
				//在某等级不显示
				var level:int = AppContext.getMapContext().getMapContent().getLevelIndex();
				if(mapHot.getNoShowLevel().indexOf(level)!=-1){
					continue;
				}
				//处理一个点的列有优先级2011-12-30
				
				if(mapHot.getContent() != null && mapHot.getContent().length > 0 && mapTip is MapListTipImpl){
					for(var j:int=0;j<len;j++){
						var t:MapHot = hots[j];
						if(t.getMapListTip() == mapTip){
							return false;
						}
						continue;
					}
				}
				//1.显示
				mapHot.show(drawUtil,x,y,fontName,fontColor,fontSize,showBackColor,backColor,showBackOutlineColor,backOutlineColor);
				if(mapHot.getShowFlare()){//2.显示、闪烁
					mapHot.drawFlare();
				}
				return true;
				
			}
			return false;
		}
		/* mouse click show */
		public function showClickHot(x:int,y:int):Boolean{
			for(var i:int=0;i<hots.length;i++){
				var mapHot:MapHot = hots[i];
				if(mapHot.getMethod() != 2){//2单击
					continue;
				}
				if(!mapHot.checkHotArea(x,y)){//不在区域
					continue;
				}
				if(mapHot.getShowEvent()){//事件
					var xAry:String = "";
					var yAry:String = "";
					var geo:Geometry = mapHot.getGeometry();
					if(geo is FPoint){
						var fPoint:FPoint = geo as FPoint;
						xAry = fPoint.getX().toString();
						yAry = fPoint.getY().toString();
					}else if(geo is Line){
						var line:Line = geo as Line;
						xAry = line.getXArrayString();
						yAry = line.getYArrayString();
					}else if(geo is Polygon){
						var poly:Polygon = geo as Polygon;
						xAry = poly.getXArrayString();
						yAry = poly.getYArrayString();
					}
					ExternalInterface.call(mapHot.getCallBack(),xAry,yAry);
					return true;
				}
				//在某等级不显示
				var level:int = AppContext.getMapContext().getMapContent().getLevelIndex();
				if(mapHot.getNoShowLevel().indexOf(level)!=-1){
					continue;
				}
				//显示
				mapHot.show(drawUtil,x,y,fontName,fontColor,fontSize,showBackColor,backColor,showBackOutlineColor,backOutlineColor);
				return true;
			}
			return false;
		}
		/* mouse right click */
		public function showMenuHot():void{
			var x:int = AppContext.getApplication().mouseX;
			var y:int = AppContext.getApplication().mouseY;
			for(var i:int=0;i<hots.length;i++){
				var mapHot:MapHot = hots[i];
				if(mapHot.getMethod() != 3){//3右键
					continue;
				}
				if(!mapHot.checkHotArea(x,y)){//不在区域
					continue;
				}
				//在某等级不显示
				var level:int = AppContext.getMapContext().getMapContent().getLevelIndex();
				if(mapHot.getNoShowLevel().indexOf(level) != -1){
					continue;
				}
				mapHot.showMenu(x,y);
				return;
			}
		}
		//clear all hot
		public function clear():void{
			hots = new Array();
			drawUtil.clear();
			AppContext.getMapContext().getMapTipFactory().clear();
		}
		//clear show some hot
		public function clearHot():void{
			AppContext.getMapContext().getMapTipFactory().clear();
		}
		//clear show one hot
		public function hideHot():void{
			while(this.getChildByName("hotSymbol")){//停止闪烁点线面
				this.removeChild(this.getChildByName("hotSymbol"));
			}
			AppContext.getMapContext().getMapTipFactory().hideTip();
		}
		public function removeHotById(id:String):void{
			var newHots:Array = new Array();
			for(var i:int=0;i<hots.length;i++){
				var mapHot:MapHot = hots[i];
				if(mapHot.getId() == id){
					drawUtil.clear();
					AppContext.getMapContext().getMapTipFactory().clear();
				}else{
					newHots.push(mapHot);
				}
			}
			hots = newHots;
		}
		public function removeHotByGroup(group:String):void{
			var newHots:Array = new Array();
			for(var i:int=0;i<hots.length;i++){
				var mapHot:MapHot = hots[i];
				if(mapHot.getGroup() == group){
					drawUtil.clear();
					AppContext.getMapContext().getMapTipFactory().clear();
				}else{
					newHots.push(mapHot);
				}
			}
			hots = newHots;
		}
		public function setHotGroupVisible(group:String,visible:Boolean):void{
			var i:int;
			var mapHot:MapHot;
			var temp:Array = new Array();
			if(visible){
				for(i=0;i<visibleHots.length;i++){
					mapHot = visibleHots[i];
					if(mapHot.getGroup() != group){
						temp.push(mapHot);
						continue;
					}
					hots.push(mapHot);
				}
				visibleHots = temp;
			}else{
				for(i=0;i<hots.length;i++){
					mapHot = hots[i];
					if(mapHot.getGroup() != group){
						temp.push(mapHot);
						continue;
					}
					drawUtil.clear();
					AppContext.getMapContext().getMapTipFactory().clear();
					visibleHots.push(mapHot);
				}
				hots = temp;
			}
		}
		//刷新
		public function refresh():void{
			for(var i:int=0;i<hots.length;i++){
				var mapHot:MapHot = hots[i];
				mapHot.buildHotArea();
			}
		}
		
	}
}