package jsoft.map.geometry
{
	public class GeometryFactory
	{
		public function createBox(minx:Number,miny:Number,maxx:Number,maxy:Number):Box {
			var geometry:Box = new Box();
			geometry.setBox(minx,miny,maxx,maxy);
			return geometry;
		}

		public function createEnvelope(minx:Number,miny:Number,maxx:Number,maxy:Number):Envelope {
			var geometry:Envelope = new Envelope();
			geometry.setEnvelope(minx,miny,maxx,maxy);
			return geometry;
		}

		public function createCircle(cx:Number,cy:Number,radius:Number):Circle {
			var geometry:Circle = new Circle();
			geometry.setCenterX(cx);
			geometry.setCenterY(cy);
			geometry.setRadius(radius);
			return geometry;
		}

		public function createPoint(x:Number,y:Number):FPoint {
			var geometry:FPoint = new FPoint();
			geometry.setX(x);
			geometry.setY(y);
			return geometry;
		}

		public function createPointEx(x:String,y:String):FPoint {
			var geometry:FPoint = new FPoint();
			geometry.setX(AppContext.getAppUtil().getNumber(x));
			geometry.setY(AppContext.getAppUtil().getNumber(y));
			return geometry;
		}

		public function createMultiPoint(xAry:Array,yAry:Array):MultiPoint {
			var geometry:MultiPoint = new MultiPoint();
			for(var i:int=0;i<xAry.length;i++){
				geometry.addPoint(xAry[i],yAry[i]);
			}
			return geometry;
		}

		public function createLine(xAry:Array,yAry:Array):Line {
			var geometry:Line = new Line();
			for(var i:int=0;i<xAry.length;i++){
				geometry.addPoint(xAry[i],yAry[i]);
			}
			return geometry;
		}

		public function createLineEx(xAry:String,yAry:String):Line {
			return (Line)(AppContext.getAppUtil().getLine(xAry,yAry));
		}

		public function createMultiLine(lineAry:Array):MultiLine {
			var geometry:MultiLine = new MultiLine();
			var line:Line;
			for each(line in lineAry){
				geometry.addLine(line);
			}
			return geometry;
		}

		public function createPolygon(xAry:Array,yAry:Array):Polygon {
			var geometry:Polygon = new Polygon();
			for(var i:int=0;i<xAry.length;i++){
				geometry.addPoint(xAry[i],yAry[i]);
			}
			return geometry;
		}

		public function createPolygonEx(xAry:String,yAry:String):Polygon {
			return (Polygon)(AppContext.getAppUtil().getPoly(xAry,yAry));
		}

		public function createMultiPolygon(polyArray:Array):MultiPolygon {
			var geometry:MultiPolygon = new MultiPolygon();
			var polygon:Polygon;
			for each(polygon in polyArray){
				geometry.addPoly(polygon);
			}
			return geometry;
		}

		public function createRecord():Record {
			var record:Record = new Record();
			return record;
		}

		public function createRecordset():Recordset {
			var record:Recordset = new Recordset();
			return record;
		}
		
		public function setGeometryString(geometryString:String):Geometry {
			if(geometryString == null || geometryString.length == 0) {
				return null;
			}
			if(AppContext.getAppUtil().parseString(geometryString,"Box")!=null) {
				var box:Box = new Box();
				box.setGeometryString(geometryString);
				return box;
			}
			if(AppContext.getAppUtil().parseString(geometryString,"Envelope")!=null) {
				var envelope:Envelope = new Envelope();
				envelope.setGeometryString(geometryString);
				return envelope;
			}
			if(AppContext.getAppUtil().parseString(geometryString,"Circle")!=null) {
				var circle:Circle = new Circle();
				circle.setGeometryString(geometryString);
				return circle;
			}
			if(AppContext.getAppUtil().parseString(geometryString,"Point")!=null) {
				var point:FPoint = new FPoint();
				point.setGeometryString(geometryString);
				return point;
			}
			if(AppContext.getAppUtil().parseString(geometryString,"MultiPoint")!=null) {
				var multiPoint:MultiPoint = new MultiPoint();
				multiPoint.setGeometryString(geometryString);
				return multiPoint;
			}
			if(AppContext.getAppUtil().parseString(geometryString,"Line")!=null) {
				var line:Line = new Line();
				line.setGeometryString(geometryString);
				return line;
			}
			if(AppContext.getAppUtil().parseString(geometryString,"MultiLine")!=null) {
				var multiLine:MultiLine = new MultiLine();
				multiLine.setGeometryString(geometryString);
				return multiLine;
			}
			if(AppContext.getAppUtil().parseString(geometryString,"Polygon")!=null) {
				var polygon:Polygon = new Polygon();
				polygon.setGeometryString(geometryString);
				return polygon;
			}
			if(AppContext.getAppUtil().parseString(geometryString,"MultiPolygon")!=null) {
				var multiPolygon:MultiPolygon = new MultiPolygon();
				multiPolygon.setGeometryString(geometryString);
				return multiPolygon;
			}
			return null;
		}
	}
}