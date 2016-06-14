package jsoft.map.geometry
{
	public class Record
	{
		private var id:int;
		private var geometry:Geometry = null;
		private var attribute:Array = new Array();
		
		public function Record() {
		}
		
		public function getId() : int {
			return id;
		}
		
		public function setId(id:int) : void {
			this.id = id;
		}
		
		public function getGeometry():Geometry {
			return geometry;
		}
		
		public function setGeometry(geometry:Geometry):void {
			this.geometry = geometry;
		}
		
		public function addAttribute(name:String,cname:String,value:String):void {
			var attr:Attribute = new Attribute();
			attr.setName(name);
			attr.setCName(cname);
			attr.setValue(value);
			attribute[attribute.length] = attr;
		}
		
		public function getAttribute(pos:int):Attribute {
			return attribute[pos];
		}
		
		public function getAttributeAry():Array {
			return attribute;
		}
		
		public function getAttributeByName(name:String):String {
			for(var i:int=0;i<attribute.length;i++) {
				var attr:Attribute = attribute[i];
				if(attr.getName() == name) {
					return attr.getValue();
				}
			}
			return null;
		}
		
		public function getAttributeByCName(cname:String):String {
			for(var i:int=0;i<attribute.length;i++) {
				var attr:Attribute = attribute[i];
				if(attr.getCName() == cname) {
					return attr.getValue();
				}
			}
			return null;
		}
		
		public function getAttributeIndexByName(name:String):int {
			for(var i:int=0;i<attribute.length;i++) {
				var attr:Attribute = attribute[i];
				if(attr.getName() == name) {
					return i;
				}
			}
			return -1;
		}
		
		public function getAttributeIndexByCName(cname:String):int {
			for(var i:int=0;i<attribute.length;i++) {
				var attr:Attribute = attribute[i];
				if(attr.getCName() == cname) {
					return i;
				}
			}
			return -1;
		}
		
		public function clone() : Record {
			var record:Record = new Record();
			record.id = id;
			record.geometry = geometry==null?null:geometry.clone();
			for(var i:int=0;i<attribute.length;i++) {
				var attr:Attribute = attribute[i];
				record.addAttribute(attr.getName(),attr.getCName(),attr.getValue());
			}
			return record;
		}
		
		public function getAttributeLength():int {
			return attribute.length;
		}
		
		public function getGeometryString() : String {
			var theString:String = "Record:";
			for(var i:int=0;i<attribute.length;i++) {
				var attr:Attribute = attribute[i];
				if(i>0) {
					theString += "," + attr.getName() + "," + attr.getCName() + "," + attr.getValue();
				} else {
					theString += attr.getName() + "," + attr.getCName() + "," + attr.getValue();
				}
			}
			theString += ";";
			if(geometry != null) {
				theString += geometry.toString();
			}
			return theString;
		}
		public function setGeometryString(geometryString:String) : void {
			var str:String = AppContext.getAppUtil().parseString(geometryString,"Record");
			var mainAry:Array = AppContext.getAppUtil().getStringArray(str,";");
			var attrString:String = mainAry[0];
			var geometryString:String = mainAry[1];
			var ary:Array = AppContext.getAppUtil().getStringArray(attrString,",");
			for(var i:int=0;i+3<ary.length;i+=3) {
				var name:String = ary[i];
				var cname:String = ary[i+1];
				var value:String = ary[i+2];
				addAttribute(name,cname,value);
			}
			geometry = AppContext.getMapContext().getGeometryFactory().setGeometryString(geometryString);
		}
		public function toString() : String {
			var theString:String = "Record:";
			for(var i:int=0;i<attribute.length;i++) {
				var attr:Attribute = attribute[i];
				if(i>0) {
					theString += ";name=" + attr.getName() + ",cname=" + attr.getCName() + ",value=" + attr.getValue();
				} else {
					theString += "name=" + attr.getName() + ",cname=" + attr.getCName() + ",value=" + attr.getValue();
				}
			}
			if(geometry != null) {
				if(attribute.length > 0) {
					theString += ";geometry=" + geometry.toString();
				} else {
					theString += "geometry=" + geometry.toString();
				}
			} else {
				theString += "geometry=";
			}
			return theString;
		}

	}
}