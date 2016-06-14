package jsoft.map.symbol
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.MultiPoint;
	import jsoft.map.geometry.Record;
	
	import mx.controls.Image;
	
	public class HotImagePointSymbol extends Symbol
	{
		private var imgUrl:String = "";
		private var hotImgUrl:String = "";
		private var imgWidth:int = 5;
		private	var imgHeight:int = 0;
		private var img:Image = null;
		private var flag:Boolean = false;
		public function HotImagePointSymbol() {
		}
		
		public override function clone():Symbol {
			var symbol:HotImagePointSymbol = new HotImagePointSymbol();
			copyTo(symbol);
			return symbol;
		}
		
		public override function copyTo(symbol:Symbol):void {
			super.copyTo(symbol);
			var point:HotImagePointSymbol = symbol as HotImagePointSymbol;
			point.imgUrl = imgUrl;
			point.hotImgUrl = hotImgUrl;
			point.imgWidth = imgWidth;
			point.imgHeight=imgHeight;
		}
		
		public override function getSymbolString():String {
			return "HotImagePointSymbol";
		}
		
		public function setImgUrl(_imgUrl:String):void {
			imgUrl = _imgUrl;
		}
		public function getImgUrl():String {
			return imgUrl;
		}
		public function setHotImgUrl(_hotImgUrl:String):void {
			hotImgUrl = _hotImgUrl;
		}
		public function getHotImgUrl():String {
			return hotImgUrl;
		}
		public function setImgWidth(_imgWidth:int):void {
			imgWidth = _imgWidth;
		}
		public function getImgWidth():int {
			return imgWidth;
		}
		public function setImgHeight(_imgHeight:int):void {
			imgHeight = _imgHeight;
		}
		public function getImgHeight():int {
			return imgHeight;
		}
		// 绘制符号
		public override function showSymbol(coord:Coordinate):void {
			super.showSymbol(coord);
			show();
		}
		private function show():void {
			if(record) {
				drawRecord(record);
			}
			if(geometry) {
				drawGeometry(geometry);
			}
		}
		// 绘制指定记录
		private function drawRecord (record:Record):void {
			setRecord(record);
			var geometry:Geometry = record.getGeometry();
			drawGeometry(geometry);
		}
		// 绘制指定空间对象
		private function drawGeometry (geometry:Geometry):void {
			setGeometry(geometry);
			return drawPoint(geometry);
		}
		private function drawPoint (geometry:Geometry):void {
			if(geometry.getGeometryName() == "Point"){
				drawSinglePoint(geometry);
				return;
			}
			if(geometry.getGeometryName() == "MultiPoint"){
				var mpoint:MultiPoint = geometry as MultiPoint;
				for(var i:int=0;i<mpoint.getPointLength();i++) {
					drawSinglePoint(mpoint.getPoint(i));
				}
				return;
			}
			AppContext.getAppUtil().alert("点符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
		}
		private function drawSinglePoint(geometry:Geometry):void {
			getImg();
	    }
	    private function getImg():void{
	    	//var img:Image;
	    	if(img != null && this.contains(img)){
	    		
	    	}else{
	    		img = new Image();
	    		img.source = imgUrl;
	    		addChild(img);
	    		stage.addEventListener(MouseEvent.MOUSE_MOVE,changeImage);
	    	}
	    	/*
	    	if(numChildren > 0){
	    		img = getChildAt(0) as Image;
	    	}else{
	    		img = new Image();
	    		img.source = imgUrl;
	    		addChild(img);
	    	}*/
			img.scaleContent=true;
			img.addEventListener(Event.COMPLETE,onComplete);
	    	
			img.x = 0;
    		img.y = 0;
    		img.width = imgWidth;
	    	img.height = imgHeight;
	    	//img.invalidateDisplayList();
	    }
	    private function onComplete(event:Event):void {
	    	flag = true;
	    	/*
	    	if(AppContext.getApplication().contains(this)){
	    		stage.addEventListener(MouseEvent.MOUSE_MOVE,changeImage);
	    	}else{
	    		this.removeChild(img);
	    		stage.removeEventListener(MouseEvent.MOUSE_MOVE,changeImage);
	    	}*/
	    }
	    private function changeImage(event:MouseEvent):void{
	    	if(img == null || flag == false){
	    		return;
	    	}
	    	if(!AppContext.getApplication().contains(this)){
	    		return;
	    	}
	    	var sx:int = event.stageX;
	    	var sy:int = event.stageY;
	    	if(this.x<=sx && sx<=this.x+img.width && this.y<=sy && sy<=this.y+img.height){
	    		if((imgUrl!="")&&(img.source == imgUrl)){
	    			img.source = hotImgUrl;
	    		}
	    	}else{
	    		img.source = imgUrl
	    	}
	    	//stage.removeEventListener(MouseEvent.MOUSE_OVER,changeImage);
	    	//getImg();
	    }
		public override function updateSymbol():void {
			if(record) {
				updatePoint(record.getGeometry());
			}
			if(geometry) {
				updatePoint(geometry);
			}
		}
		private function updatePoint(geometry:Geometry):void {
			if(geometry.getGeometryName() == "Point"){
				updateSinglePoint(geometry);
				return;
			}
			if(geometry.getGeometryName() == "MultiPoint"){
				var mpoint:MultiPoint = geometry as MultiPoint;
				for(var i:int=0;i<mpoint.getPointLength();i++) {
					updateSinglePoint(mpoint.getPoint(i));
				}
				return;
			}
			AppContext.getAppUtil().alert("点符号无法绘制图形，图元类型("+geometry.getGeometryName()+")不对！");
		}
		private function updateSinglePoint(geometry:Geometry):void {
			//AppContext.getAppUtil().alert("updateSinglePoint");
			var point:FPoint = geometry as FPoint;
			var mx:Number = point.getX();
			var my:Number = point.getY();
			var vx:int= coord.mapToViewX(mx);
			var vy:int= coord.mapToViewY(my);
			//AppContext.getAppUtil().alert("updateSinglePoint vx="+vx+",vy="+vy);
			
			x = vx - imgWidth / 2;
			y = vy - imgHeight / 2;
			width = imgWidth;
			height = imgHeight;
	    }

	}
}