package jsoft.map.symbol
{
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.MultiPoint;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Record;
	
	import mx.controls.Image;
	import mx.controls.SWFLoader;
	
	public class SwfPointSymbol extends Symbol
	{
		private var imgUrl:String = "";
		private var imgWidth:int = 5;
		private	var imgHeight:int = 0;
		
		public function SwfPointSymbol() {
		}
		
		public override function clone():Symbol {
			var symbol:ImagePointSymbol = new ImagePointSymbol();
			copyTo(symbol);
			return symbol;
		}
		
		public override function copyTo(symbol:Symbol):void {
			super.copyTo(symbol);
			var point:SwfPointSymbol = symbol as SwfPointSymbol;
			point.imgUrl = imgUrl;
			point.imgWidth = imgWidth;
			point.imgHeight=imgHeight;
		}
		
		public override function getSymbolString():String {
			return "SwfPointSymbol";
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
	    private function getImg():SWFLoader {
	    	var swf:SWFLoader;
	    	if(numChildren > 0) {
	    		swf = getChildAt(0) as SWFLoader;
	    		if(swf.source != imgUrl) {
		    		swf.source = imgUrl;
		    	}
	    	} else {
	    		swf = new SWFLoader();
	    		swf.source = imgUrl;
	    		swf.trustContent = true;
	    		addChild(swf);
	    	}
	    	swf.x = 0;
	    	swf.y = 0;
	    	swf.width = imgWidth;
	    	swf.height = imgHeight;
	    	return swf;
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