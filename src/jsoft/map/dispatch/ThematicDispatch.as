package jsoft.map.dispatch
{
	import jsoft.map.feature.thematic.ThematicServer;
	import jsoft.map.geometry.Box;
	import jsoft.map.geometry.Circle;
	import jsoft.map.geometry.Polygon;
	
	public class ThematicDispatch implements Dispatcher
	{
		public function ThematicDispatch() {
		}
		
		public function sendMessage(param:DispatchParam):void {
			if("countLayer" == param.Type) {
				countLayer(param.vstr,param.vstr,param.vstr);
				return;
			}
			if("sumLayer" == param.Type) {
				sumLayer(param.vstr,param.vstr,param.vstr,param.vstr);
				return;
			}
			if("avgLayer" == param.Type) {
				avgLayer(param.vstr,param.vstr,param.vstr,param.vstr);
				return;
			}
			if("countCircleLayer" == param.Type) {
				countCircleLayer(param.vnum,param.vnum,param.vnum,param.vstr);
				return;
			}
			if("sumCircleLayer" == param.Type) {
				sumCircleLayer(param.vnum,param.vnum,param.vnum,param.vstr,param.vstr);
				return;
			}
			if("avgCircleLayer" == param.Type) {
				avgCircleLayer(param.vnum,param.vnum,param.vnum,param.vstr,param.vstr);
				return;
			}
			if("countRectLayer" == param.Type) {
				countRectLayer(param.vnum,param.vnum,param.vnum,param.vnum,param.vstr);
				return;
			}
			if("sumRectLayer" == param.Type) {
				sumRectLayer(param.vnum,param.vnum,param.vnum,param.vnum,param.vstr,param.vstr);
				return;
			}
			if("avgRectLayer" == param.Type) {
				avgRectLayer(param.vnum,param.vnum,param.vnum,param.vnum,param.vstr,param.vstr);
				return;
			}		
			if("countPolyLayer" == param.Type) {
				countPolyLayer(param.vnumary,param.vnumary,param.vstr);
				return;
			}
			if("sumPolyLayer" == param.Type) {
				sumPolyLayer(param.vnumary,param.vnumary,param.vstr,param.vstr);
				return;
			}
			if("avgPolyLayer" == param.Type) {
				avgPolyLayer(param.vnumary,param.vnumary,param.vstr,param.vstr);
				return;
			}			
			
		}
	
		public function getMessage(param:DispatchParam):String {
			return "";
		}
		
		private function countLayer(layerName:String,countFieldName:String,targetLayerName:String):void {
			var server:ThematicServer = new ThematicServer();
			server.setType("countLayer");
			server.setLayerName(layerName);
			server.setLayerField(countFieldName);
			server.setTargetLayerName(targetLayerName);
			server.sendThematicQuery();
		}
		
		private function sumLayer(layerName:String,countFieldName:String,targetLayerName:String,targetField:String):void {
			var server:ThematicServer = new ThematicServer();
			server.setType("sumLayer");
			server.setLayerName(layerName);
			server.setLayerField(countFieldName);
			server.setTargetLayerName(targetLayerName);
			server.setTargetLayerField(targetField);
			server.sendThematicQuery();
		}
		
		private function avgLayer(layerName:String,countFieldName:String,targetLayerName:String,targetField:String):void {
			var server:ThematicServer = new ThematicServer();
			server.setType("avgLayer");
			server.setLayerName(layerName);
			server.setLayerField(countFieldName);
			server.setTargetLayerName(targetLayerName);
			server.setTargetLayerField(targetField);
			server.sendThematicQuery();
		}
		
		private function countCircleLayer(x:Number,y:Number,r:Number,targetLayerName:String):void {
			var circle:Circle = new Circle();
			circle.setCenterX(x);
			circle.setCenterY(y);
			circle.setRadius(r);
			var server:ThematicServer = new ThematicServer();
			server.setType("countCircleLayer");
			server.setGeometry(circle);
			server.setTargetLayerName(targetLayerName);
			server.sendThematicQuery();
		}
		
		private function sumCircleLayer(x:Number,y:Number,r:Number,targetLayerName:String,targetField:String):void {
			var circle:Circle = new Circle();
			circle.setCenterX(x);
			circle.setCenterY(y);
			circle.setRadius(r);
			var server:ThematicServer = new ThematicServer();
			server.setType("sumCircleLayer");
			server.setGeometry(circle);
			server.setTargetLayerName(targetLayerName);
			server.setTargetLayerField(targetField);
			server.sendThematicQuery();
		}
		
		private function avgCircleLayer(x:Number,y:Number,r:Number,targetLayerName:String,targetField:String):void {
			var circle:Circle = new Circle();
			circle.setCenterX(x);
			circle.setCenterY(y);
			circle.setRadius(r);
			var server:ThematicServer = new ThematicServer();
			server.setType("avgCircleLayer");
			server.setGeometry(circle);
			server.setTargetLayerName(targetLayerName);
			server.setTargetLayerField(targetField);
			server.sendThematicQuery();
		}
		
		private function countRectLayer(x1:Number,y1:Number,x2:Number,y2:Number,targetLayerName:String):void {
			var box:Box = new Box();
			box.setBox(x1,y1,x2,y2);
			var server:ThematicServer = new ThematicServer();
			server.setType("countRectLayer");
			server.setGeometry(box);
			server.setTargetLayerName(targetLayerName);
			server.sendThematicQuery();
		}
		
		private function sumRectLayer(x1:Number,y1:Number,x2:Number,y2:Number,targetLayerName:String,targetField:String):void {
			var box:Box = new Box();
			box.setBox(x1,y1,x2,y2);
			var server:ThematicServer = new ThematicServer();
			server.setType("sumRectLayer");
			server.setGeometry(box);
			server.setTargetLayerName(targetLayerName);
			server.setTargetLayerField(targetField);
			server.sendThematicQuery();
		}
		
		private function avgRectLayer(x1:Number,y1:Number,x2:Number,y2:Number,targetLayerName:String,targetField:String):void {
			var box:Box = new Box();
			box.setBox(x1,y1,x2,y2);
			var server:ThematicServer = new ThematicServer();
			server.setType("avgRectLayer");
			server.setGeometry(box);
			server.setTargetLayerName(targetLayerName);
			server.setTargetLayerField(targetField);
			server.sendThematicQuery();
		}
		
		private function countPolyLayer(xary:Array,yary:Array,targetLayerName:String):void{
			var poly:Polygon = new Polygon();
			poly.setXArray(xary);
			poly.setYArray(yary);
			var server:ThematicServer = new ThematicServer();
			server.setType("countPolyLayer");
			server.setGeometry(poly);
			server.setTargetLayerName(targetLayerName);
			server.sendThematicQuery();
		}
		
		private function sumPolyLayer(xary:Array,yary:Array,targetLayerName:String,targetField:String):void{
			var poly:Polygon = new Polygon();
			poly.setXArray(xary);
			poly.setYArray(yary);
			var server:ThematicServer = new ThematicServer();
			server.setType("sumPolyLayer");
			server.setGeometry(poly);
			server.setTargetLayerName(targetLayerName);
			server.setTargetLayerField(targetField);
			server.sendThematicQuery();
		}
		
		private function avgPolyLayer(xary:Array,yary:Array,targetLayerName:String,targetField:String):void{
			var poly:Polygon = new Polygon();
			poly.setXArray(xary);
			poly.setYArray(yary);
			var server:ThematicServer = new ThematicServer();
			server.setType("avgPolyLayer");
			server.setGeometry(poly);
			server.setTargetLayerName(targetLayerName);
			server.setTargetLayerField(targetField);
			server.sendThematicQuery();
		}
	}
}