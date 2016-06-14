package jsoft.map.util
{
	import flash.external.ExternalInterface;
	
	import jsoft.map.geometry.Geometry;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.MultiLine;
	import jsoft.map.geometry.MultiPoint;
	import jsoft.map.geometry.MultiPolygon;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Polygon; 
	
	public class AppUtil
	{
		public function AppUtil() {
		}
		
		public function alert(msg:String) : void {
			ExternalInterface.call("fMap.showAlert",msg);
			//Alert.show(msg,"JFlexMap");
		}
		
		public function showStatus(msg:String) : void {
			ExternalInterface.call("fMap.showStatus",msg);
		}
		
		public function getTime() : Number {
			var date:Date = new Date();
			return date.getTime();
		}
		
		public function parseString(str:String,title:String):String {
			var name:String = title + ":";
			if(str.length >= name.length) {
				var s:String = str.substring(0,name.length);
				if(s == name) {
					s = str.substring(name.length);
					return s;
				}
			}
			return null;
		}
		
		public function getStringArray(str:String,split:String):Array {
			var ret:Array = new Array();
			if(str == null) {
				return ret;
			}
			var pos:int = str.indexOf(split);
			while(pos >= 0) {
				//AppContext.getAppUtil().alert("str="+str+"\npos="+pos);
				var s:String = str.substring(0,pos);
				ret[ret.length] = s;
				str = str.substring(pos+split.length);
				pos = str.indexOf(split);
//				pos--;
			}
			if(str.length>0) {
				ret[ret.length] = str;
			}
			return ret;
		}
		
		public function getArrayString(arry:Array,split:String=",") : String {
			var theString:String = "";
			for(var i:int=0;arry!=null&&i<arry.length;i++) {
				if(i>0) {
					theString += split;
				}
				theString += arry[i];
			}
			return theString
		}
		
		public function getStringNumber(str:Array,pos:int):Number {
			if(str == null || str.length <= pos) {
				return 0;
			}
			return parseFloat(str[pos]);
		}
		
		public function getBoolean(str:String) : Boolean {
			if(str == null || str == "") {
				return false;
			}
			str = str.toLowerCase();
			if("1" == str || "true" == str || "t" == str) {
				return true;
			}
			return false;
		}
		
		public function getColor(str:String) : int {
			if(str == null || str == "") {
				return AppContext.getDrawUtil().getRed();
			}
			str = str.toLowerCase();
			if("black" == str) {
				return AppContext.getDrawUtil().getBlack();
			}
			if("white" == str) {
				return AppContext.getDrawUtil().getWhite();
			}
			if("red" == str) {
				return AppContext.getDrawUtil().getRed();
			}
			if("blue" == str) {
				return AppContext.getDrawUtil().getBlue();
			}
			if("green" == str) {
				return AppContext.getDrawUtil().getGreen();
			}
			if("yellow" == str) {
				return AppContext.getDrawUtil().getYellow();
			}
			if("lightyellow" == str) {
				return AppContext.getDrawUtil().getLightYellow();
			}
			if("orange" == str) {
				return AppContext.getDrawUtil().getOrange();
			}
			if("lightorange" == str) {
				return AppContext.getDrawUtil().getLightOrange();
			}
			if("#" == str.charAt(0) && str.length > 6) {
				var redstr:String=str.substring(1,3);
				var red:int = getColorInt(redstr);
				var greenstr:String=str.substr(3,5);
				var green:int = getColorInt(greenstr);
				var bluestr:String=str.substr(5,7);
				var blue:int = getColorInt(bluestr);
				return AppContext.getDrawUtil().rgbToInt(red,green,blue);
				
			}
			return parseInt(str);
		}
		
		private function getColorInt(str:String) : int {
			var aa1:int = getColorCharInt(str.charAt(0));
			var aa2:int = getColorCharInt(str.charAt(1));
			var ret:int = aa1 * 16 + aa2;
			return ret;
		}
		
		private function getColorCharInt(str:String) : int {
			switch(str) {
				case "a":
					return 10;
				case "b":
					return 11;
				case "c":
					return 12;
				case "d":
					return 13;
				case "e":
					return 14;
				case "f":
					return 15;
				default:
					return getInt(str);
			}
			if("f" == str) {
				return 15;
			}			
		}
		
		public function getInt(str:String) : int {
			if(str == null || str == "") {
				return 0;
			}
			return parseInt(str);
		}
		
		public function getIntEx(str:String,defaultValue:int) : int {
			if(str == null || str == "") {
				return defaultValue;
			}
			if("0" == str) {
				return 0;
			}
			var ret:int = parseInt(str);
			return ret == 0 ? defaultValue : ret;
		}
		
		public function getNumber(str:String) : Number {
			if(str == null || str == "") {
				return 0;
			}
			return parseFloat(str);
		}
		
		public function getNumberEx(str:String,defaultValue:Number) : Number {
			if(str == null || str == "") {
				return defaultValue;
			}
			if("0" == str || "0.0" == str) {
				return 0;
			}
			var ret:Number = parseFloat(str);
			return ret == 0 ? defaultValue : ret;
		}
		
		public function getPoint(x_str:String,y_str:String) : Geometry {
			//考虑多段线分隔符; 坐标分割符,
			var i:int =0;
			var splitString:String = ",";
			var index:int = x_str.indexOf(",");
			if(index < 0) {
				splitString = ";";
			}
			var ixArr:Array=x_str.split(splitString);
			var iyArr:Array=y_str.split(splitString);
		    var vPoint:FPoint=new FPoint();
		    var vMPoint:MultiPoint=new MultiPoint();
			if (ixArr.length>1) {
				for(i=0;i<ixArr.length;i++) {
					var j:int=0;
					for(j=0;j<ixArr.length;j++)
					{
						vMPoint.addPoint(getNumber(ixArr[i]),getNumber(iyArr[i]));
					}
					
				}
				return vMPoint;
			}else {
				vPoint.setX(getNumber(x_str));
				vPoint.setY(getNumber(y_str));
				return vPoint;
			}
		}
		
		public function getLine(x_str:String,y_str:String) : Geometry {
			//考虑多段线分隔符; 坐标分割符,
			var i:int =0;
			var ixArr:Array=x_str.split(";");
			var iyArr:Array=y_str.split(";");
		    var vLine:Line=new Line();
		    var vMLine:MultiLine=new MultiLine();
			if (ixArr.length>1){
				//mline
				for(i=0;i<ixArr.length;i++)
				{
					var j:int=0;
					for(j=0;j<ixArr.length;j++)
					{
						var x_arr1:Array=ixArr[i].split(',');
						var y_arr1:Array=iyArr[i].split(',');
						var m:int=0;
						var vLine1:Line=new Line();
						for(m=0;m<x_arr1.length;m++)
						{
							vLine1.addPoint(x_arr1[m],y_arr1[m]);
						}
						vMLine.addLine(vLine1);
					}
					
				}
				return vMLine;
			}else{
				//line
				var x_arr:Array=x_str.split(',');
				var y_arr:Array=y_str.split(',');
				for (i=0;i<x_arr.length;i++)
				{
					vLine.addPoint(x_arr[i],y_arr[i]);
				}
				return vLine;
			}
		}
		
		public function getPoly(x_str:String,y_str:String) : Geometry {
			//考虑多段线分隔符; 坐标分割符,
			var i:int =0;
			var ixArr:Array=x_str.split(";");
			var iyArr:Array=y_str.split(";");
		    var vPolygon:Polygon=new Polygon();
		    var vMPolygon:MultiPolygon=new MultiPolygon();
			if (ixArr.length>1){
				//mline
				for(i=0;i<ixArr.length;i++)
				{
					var j:int=0;
					for(j=0;j<ixArr.length;j++)
					{
						var x_arr1:Array=ixArr[i].split(',');
						var y_arr1:Array=iyArr[i].split(',');
						var m:int=0;
						var vPolygon1:Polygon=new Polygon();
						for(m=0;m<x_arr1.length;m++)
						{
							vPolygon1.addPoint(x_arr1[m],y_arr1[m]);
						}
						vMPolygon.addPoly(vPolygon1);
					}
					
				}
				return vMPolygon;
			}else{
				//line
				var x_arr:Array=x_str.split(',');
				var y_arr:Array=y_str.split(',');
				for (i=0;i<x_arr.length;i++)
				{
					vPolygon.addPoint(x_arr[i],y_arr[i]);
				}
				return vPolygon;
			}
		}

	}
}