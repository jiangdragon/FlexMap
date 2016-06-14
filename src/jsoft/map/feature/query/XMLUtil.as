package jsoft.map.feature.query
{
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
		
	public class XMLUtil
	{
		private var xml:XML;
		private var recordset:String="rs";
		private var record:String="r";
		public function XMLUtil(xml:XML) {
			this.xml = xml;
		}
		
		public function toJS() : String {
			var item:XML;
			var ret:String="";
            for each(item in xml) {
            	ret+=parseRecordset(item);
            }
			return ret;
		}
		
		private function parseRecordset(root:XML) : String {
			var ret:String = "";
			var recordNode:XMLList = root.elements("recordset");
			var item:XML;
			var i:int=0;
            for each(item in recordNode) {
            	ret+="var "+recordset+"=new RecordSet();"
            	var layerName:String = item.attribute("layerName");
				var layerCName:String = item.attribute("layerCName");
				if(layerCName==null||layerCName.length==0) {
					layerCName=layerName;
				}
				ret+=recordset+".l('"+layerName+"','"+layerCName+"');";
				//ret+=recordset+".setLayerName('"+layerName+"');";
				//ret+=recordset+".setLayerCName('"+layerCName+"');";
            	ret += parsePage(item);
            	ret += parseSchema(item);
            	ret += parseRecord(item);
           		ret+="rsa["+i+"]="+recordset+";";
           		i++;
            }
			return ret;
		}
		
		private function parsePage(root:XML) : String {
			var ret:String = "";
			var pageNode:XMLList = root.elements("page");
			var item:XML;
            for each(item in pageNode) {
				var index:String = item.attribute("index");
				var current:String = item.attribute("current");
				var max:String = item.attribute("max");
				var pageCount:String = item.attribute("pageCount");
				var count:String = item.attribute("count");
				ret+=recordset+".p("+index+","+current+","+max+","+pageCount+","+count+");";
            }
			return ret;
		}
		
		private function parseSchema(root:XML) : String {
			var ret:String = "";
			var attrNode:XMLList = root.elements("schema");
			var item:XML;
            for each(item in attrNode) {
				var name:String = item.attribute("name");
				var cname:String = item.attribute("cname");
				if(cname==null||cname.length==0) {
					cname=name;
				}
				ret+=recordset+".v(\""+name+"\",\""+cname+"\");";
            }
			return ret;
		}
		
		private function parseRecord(root:XML) : String {
//			AppContext.getAppUtil().alert("name="+root.toXMLString());
			var ret:String = "";
			var recordNode:XMLList = root.elements("record");
			var item:XML;
            for each(item in recordNode) {
            	ret+="var "+record+"=new Record("+recordset+");"
				var id:String = item.attribute("id");
            	ret+=parseFields(item);
            	ret+=parseGeometry(item);
           		ret+="rs.r("+id+",f,g);";
           		//break;
            }//AppContext.getAppUtil().alert("parseRecord="+ret);
			return ret;
		}
		
		private function parseFields(root:XML) : String {
			var ret:String = "var f=new Array();";
			var attrNode:XMLList = root.elements("fields");
			var item:XML;
			var i:int=0;
            for each(item in attrNode) {
				var field:String = item.attribute("field");
				ret+="f["+i+"]=\""+field+"\";";
				i++;
				//ret+=record+".addField('"+name+"');";
				//ret+=record+".addCField('"+cname+"');";
				//ret+=record+".addValue('"+field+"');";
				//AppContext.getAppUtil().alert("name="+name+",cname="+cname+",field="+value);
            }
			return ret;
		}
		
		private function parseGeometry(root:XML) : String {
			var ret:String = "";
			var geoNode:XMLList = root.elements("geometry");
			var item:XML;
			var coords:String;
			var coordArys:Array;
			var xAry:Array;
			var yAry:Array;
			var i:int;
            for each(item in geoNode) {
				var type:String = item.attribute("type");
				if(type == "point") {
					coords = item.attribute("coord");
					coordArys = AppContext.getAppUtil().getStringArray(coords,",");
					var x:Number = AppContext.getAppUtil().getNumber(coordArys[0]);
					var y:Number = AppContext.getAppUtil().getNumber(coordArys[1]);
					ret+="var g=geometryFactory.createPoint('"+x+"','"+y+"');";
					//ret+=record+".g(g);";
				}else if(type == "mpoint"){
					coords = item.attribute("coord");
					coordArys = AppContext.getAppUtil().getStringArray(coords,",");
					xAry=new Array();
					yAry=new Array();
					for(i=0;i<coordArys.length;i=i+2){
						xAry[i/2]= AppContext.getAppUtil().getNumber(coordArys[i]);
						yAry[i/2] = AppContext.getAppUtil().getNumber(coordArys[i+1]);
					}
					ret+="var g=geometryFactory.createMultiPoint('"+aryToString(xAry)+"','"+aryToString(yAry)+"');";
					//ret+=record+".g(g);";
				}else if(type == "line"){
					coords = item.attribute("coord");
					coordArys = AppContext.getAppUtil().getStringArray(coords,",");
					xAry=new Array();
					yAry=new Array();
					for(i=0;i<coordArys.length;i=i+2){
						xAry[i/2]= AppContext.getAppUtil().getNumber(coordArys[i]);
						yAry[i/2] = AppContext.getAppUtil().getNumber(coordArys[i+1]);
					}
					ret+="var g=geometryFactory.createLine('"+aryToString(xAry)+"','"+aryToString(yAry)+"');";
					//ret+=record+".g(g);";
				}else if(type == "mline"){
					var lineNode:XMLList = item.elements("line");
					var lineItem:XML;
					ret+="var lineAry=new Array();";
					ret+="var _line;";
					for each(lineItem in lineNode){
						coords = lineItem.attribute("coord");
						coordArys = AppContext.getAppUtil().getStringArray(coords,",");
						xAry=new Array();
						yAry=new Array();
						for(i=0;i<coordArys.length;i=i+2){
							xAry[i/2]= AppContext.getAppUtil().getNumber(coordArys[i]);
							yAry[i/2] = AppContext.getAppUtil().getNumber(coordArys[i+1]);
						}
						ret+="_line = new Line();";
						ret+="_line.addPoint('"+aryToString(xAry)+"','"+aryToString(yAry)+"');";
						ret+="lineAry[lineAry.length]=_line;";
					}
					ret+="var g=geometryFactory.createMultiLine(lineAry);";
					//ret+=record+".g(g);";
				}else if(type == "Polygon"){
					coords = item.attribute("coord");
					coordArys = AppContext.getAppUtil().getStringArray(coords,",");
					xAry=new Array();
					yAry=new Array();
					for(i=0;i<coordArys.length;i=i+2){
						xAry[i/2]= AppContext.getAppUtil().getNumber(coordArys[i]);
						yAry[i/2] = AppContext.getAppUtil().getNumber(coordArys[i+1]);
					}
					ret+="var g==new Polygon();";
					ret+="g.xy('"+aryToString(xAry)+"','"+aryToString(yAry)+"');";
					//ret+=record+".g(g);";
				}else if(type == "MultiPolygon"){
					var polygonNode:XMLList = item.elements("polygon");
					var polygonItem:XML;
					ret+="var g=new MultiPolygon();";
					//ret+="var p;";
					for each(polygonItem in polygonNode){
						coords = polygonItem.attribute("coord");
						coordArys = AppContext.getAppUtil().getStringArray(coords,",");
						xAry=new Array();
						yAry=new Array();
						for(i=0;i<coordArys.length;i=i+2){
							xAry[i/2]= AppContext.getAppUtil().getNumber(coordArys[i]);
							yAry[i/2] = AppContext.getAppUtil().getNumber(coordArys[i+1]);
						}
						ret+="g.xy('"+aryToString(xAry)+"','"+aryToString(yAry)+"');";
					}
					//ret+=record+".g(g);";
				}
            }
			return ret;
		}
		private function aryToString(ary:Array):String {
			return AppContext.getAppUtil().getArrayString(ary,",");
		}
	}
}