package jsoft.map.symbol
{
	import flash.events.Event;
	
	import jsoft.map.cursor.MapCursorManager;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.MultiPoint;
	import jsoft.map.geometry.Record;
	
	import mx.controls.Image;
	
	public class ImageWinPointSymbol extends Symbol
	{
		private var imgUrl:String = "";
		private var imgWidth:int = 5;
		private	var imgHeight:int = 0;
		private var winId:String = "";
		
		public function ImageWinPointSymbol() {
		}
		
		public override function clone():Symbol {
			var symbol:ImageWinPointSymbol = new ImageWinPointSymbol();
			copyTo(symbol);
			return symbol;
		}
		
		public override function copyTo(symbol:Symbol):void {
			super.copyTo(symbol);
			var point:ImageWinPointSymbol = symbol as ImageWinPointSymbol;
			point.imgUrl = imgUrl;
			point.imgWidth = imgWidth;
			point.imgHeight = imgHeight;
			point.winId = winId;
		}
		
		public override function getSymbolString():String {
			return "ImageWinPointSymbol";
		}
		
		public function setImgUrl(_imgUrl:String):void {
			imgUrl = _imgUrl;
		}
		public function getImgUrl():String {
			return imgUrl;
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
		public function setWinId(_winId:String):void{
			winId = _winId;
		}
		public function getWinId():String{
			return winId;
		}
		// 绘制符号
		public override function showSymbol(coord:Coordinate):void {
			super.showSymbol(coord);
			show();
			//清除鼠标样式
			MapCursorManager.setHand();
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
	    private function getImg():Image {
	    	var img:Image;
	    	if(numChildren > 0) {
	    		img = getChildAt(0) as Image;
	    		if(img.source != imgUrl) {
	    			img.scaleContent=true;
	            	img.addEventListener(Event.COMPLETE,onComplete);
		    		img.source = imgUrl;
		    	}
	    	} else {
	    		img = new Image();
	    		img.scaleContent=true;
	            img.addEventListener(Event.COMPLETE,onComplete);
	    		img.source = imgUrl;
	    		addChild(img);
	    	}
	    	img.x = 0;
	    	img.y = 0;
	    	img.width = imgWidth;
	    	img.height = imgHeight;
	    	img.invalidateDisplayList();
	    	return img;
	    }
	    private function onComplete(event:Event):void {
			getImg();
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