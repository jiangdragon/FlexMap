package jsoft.map.dispatch
{
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Polygon;
	
	public class DispatchParam
	{
		private var type:String;
		private var param1:String;
		private var param2:String;
		private var param3:String;
		private var param4:String;
		private var param5:String;
		private var param6:String;
		private var param7:String;
		private var param8:String;
		private var param9:String;
		private var param10:String;
		private var param11:String;
		private var param12:String;
		private var param13:String;
		private var param14:String;
		private var param15:String;
		private var paramIndex:int = 1;
		
		public function DispatchParam(type:String,param1:String,param2:String,param3:String,param4:String,param5:String,param6:String,param7:String,param8:String,param9:String,param10:String,param11:String,param12:String,param13:String,param14:String,param15:String) {
			this.type = type;
			this.param1 = param1;
			this.param2 = param2;
			this.param3 = param3;
			this.param4 = param4;
			this.param5 = param5;
			this.param6 = param6;
			this.param7 = param7;
			this.param8 = param8;
			this.param9 = param9;
			this.param10 = param10;
			this.param11 = param11;
			this.param12 = param12;
			this.param13 = param13;
			this.param14 = param14;
			this.param15 = param15;
		}
		
		public function get Type():String {
			return type;
		}
		
		public function set Type(type:String):void {
			this.type = type;
		}
		
		public function getParamIndex():int {
			return paramIndex;
		}
		
		public function setParamIndex(paramIndex:int):void {
			this.paramIndex = paramIndex;
		}
		
		public function getStr():String {
			var index:int=paramIndex++;
			switch(index) {
			case 1:
				return param1;
			case 2:
				return param2;
			case 3:
				return param3;
			case 4:
				return param4;
			case 5:
				return param5;
			case 6:
				return param6;
			case 7:
				return param7;
			case 8:
				return param8;
			case 9:
				return param9;
			case 10:
				return param10;
			case 11:
				return param11;
			case 12:
				return param12;
			case 13:
				return param13;
			case 14:
				return param14;
			case 15:
				return param15;
			default:
				return "";
			}
		}
		
		public function getStrAry(split:String=","):Array {
			var ret:Array = AppContext.getAppUtil().getStringArray(getStr(),split);
			return ret;
		}
		
		public function getBoolean():Boolean {
			var str:String = getStr();
			return AppContext.getAppUtil().getBoolean(str);
		}
		
		public function getInt():int {
			return AppContext.getAppUtil().getIntEx(getStr(),0);
		}
		
		public function getIntAry():Array {
			var ary:Array = getStrAry();
			var ret:Array = new Array();
			for(var i:int=0;i<ary.length;i++) {
				ret.push(AppContext.getAppUtil().getIntEx(ary[i],0));
			}
			return ret;
		}
		
		public function getNumber():Number {
			return AppContext.getAppUtil().getNumberEx(getStr(),0);
		}
		
		public function getNumberAry():Array {
			var ary:Array = getStrAry();
			var ret:Array = new Array();
			for(var i:int=0;i<ary.length;i++) {
				ret.push(AppContext.getAppUtil().getNumberEx(ary[i],0));
			}
			return ret;
		}
		
		public function getColor():int {
			return AppContext.getAppUtil().getColor(getStr());
		}
		
		public function getColorAry():Array {
			var ary:Array = getStrAry();
			var ret:Array = new Array();
			for(var i:int=0;i<ary.length;i++) {
				var color:int = AppContext.getAppUtil().getColor(ary[i]);
				ret.push(color);
			}
			return ret;
		}
		
		public function getPoint():FPoint {
			var xstr:String = getStr();
			var ystr:String = getStr();
			var geo:FPoint = AppContext.getAppUtil().getPoint(xstr,ystr) as FPoint;
			return geo;
		}
		
		public function getLine():Line {
			var xstr:String = getStr();
			var ystr:String = getStr();
			var geo:Line = AppContext.getAppUtil().getLine(xstr,ystr) as Line;
			return geo;
		}
		
		public function getPolygon():Polygon {
			var xstr:String = getStr();
			var ystr:String = getStr();
			var geo:Polygon = AppContext.getAppUtil().getPoly(xstr,ystr) as Polygon;
			return geo;
		}
		
		public function get vstr():String {
			return getStr();
		}
		
		public function get vbool():Boolean {
			return getBoolean();
		}
		
		public function get vstrary():Array {
			return getStrAry();
		}
		
		public function get vint():int {
			return getInt();
		}
		
		public function get vintary():Array {
			return getIntAry();
		}
		
		public function get vnum():Number {
			return getNumber();
		}
		
		public function get vnumary():Array {
			return getNumberAry();
		}
		
		public function get vcolor():Number {
			return getColor();
		}
		
		public function get vcolorary():Array {
			return getColorAry();
		}
		
		public function get vpoint():FPoint {
			return getPoint();
		}
		
		public function get vline():Line {
			return getLine();
		}
		
		public function get vpoly():Polygon {
			return getPolygon();
		}
		
		public function get vpolygon():Polygon {
			return getPolygon();
		}
		
		public function get Param1():String {
			return param1;
		}
		
		public function set Param1(param1:String):void {
			this.param1 = param1;
		}
		
		public function get Param2():String {
			return param2;
		}
		
		public function set Param2(param2:String):void {
			this.param2 = param2;
		}
		
		public function get Param3():String {
			return param3;
		}
		
		public function set Param3(param3:String):void {
			this.param3 = param3;
		}
		
		public function get Param4():String {
			return param4;
		}
		
		public function set Param4(param4:String):void {
			this.param4 = param4;
		}
		
		public function get Param5():String {
			return param5;
		}
		
		public function set Param5(param5:String):void {
			this.param5 = param5;
		}
		
		public function get Param6():String {
			return param6;
		}
		
		public function set Param6(param6:String):void {
			this.param6 = param6;
		}
		
		public function get Param7():String {
			return param7;
		}
		
		public function set Param7(param7:String):void {
			this.param7 = param7;
		}
		
		public function get Param8():String {
			return param8;
		}
		
		public function set Param8(param8:String):void {
			this.param8 = param8;
		}
		
		public function get Param9():String {
			return param9;
		}
		
		public function set Param9(param9:String):void {
			this.param9 = param9;
		}
		
		public function get Param10():String {
			return param10;
		}
		
		public function set Param10(param10:String):void {
			this.param10 = param10;
		}
		
		public function get Param11():String {
			return param11;
		}
		
		public function set Param11(param11:String):void {
			this.param11 = param11;
		}
		
		public function get Param12():String {
			return param12;
		}
		
		public function set Param12(param12:String):void {
			this.param12 = param12;
		}
		
		public function get Param13():String {
			return param13;
		}
		
		public function set Param13(param13:String):void {
			this.param13 = param13;
		}
		
		public function get Param14():String {
			return param14;
		}
		
		public function set Param14(param14:String):void {
			this.param14 = param14;
		}
		
		public function get Param15():String {
			return param15;
		}
		
		public function set Param15(param15:String):void {
			this.param15 = param15;
		}
		
		public function get IntParam1():int {
			return AppContext.getAppUtil().getInt(param1);
		}
		
		public function set IntParam1(param1:int):void {
			this.param1 = param1 + "";
		}
		
		public function get IntParam2():int {
			return AppContext.getAppUtil().getInt(param2);
		}
		
		public function set IntParam2(param2:int):void {
			this.param2 = param2 + "";
		}
		
		public function get IntParam3():int {
			return AppContext.getAppUtil().getInt(param3);
		}
		
		public function set IntParam3(param3:int):void {
			this.param3 = param3 + "";
		}
		
		public function get IntParam4():int {
			return AppContext.getAppUtil().getInt(param4);
		}
		
		public function set IntParam4(param4:int):void {
			this.param4 = param4 + "";
		}
		
		public function get IntParam5():int {
			return AppContext.getAppUtil().getInt(param5);
		}
		
		public function set IntParam5(param5:int):void {
			this.param5 = param5 + "";
		}
		
		public function get IntParam6():int {
			return AppContext.getAppUtil().getInt(param6);
		}
		
		public function set IntParam6(param6:int):void {
			this.param6 = param6 + "";
		}
		
		public function get IntParam7():int {
			return AppContext.getAppUtil().getInt(param7);
		}
		
		public function set IntParam7(param7:int):void {
			this.param7 = param7 + "";
		}
		
		public function get IntParam8():int {
			return AppContext.getAppUtil().getInt(param8);
		}
		
		public function set IntParam8(param8:int):void {
			this.param8 = param8 + "";
		}
		
		public function get IntParam9():int {
			return AppContext.getAppUtil().getInt(param9);
		}
		
		public function set IntParam9(param9:int):void {
			this.param9 = param9 + "";
		}
		
		public function get IntParam10():int {
			return AppContext.getAppUtil().getInt(param10);
		}
		
		public function set IntParam10(param10:int):void {
			this.param10 = param10 + "";
		}
		
		public function get IntParam11():int {
			return AppContext.getAppUtil().getInt(param11);
		}
		
		public function set IntParam11(param11:int):void {
			this.param11 = param11 + "";
		}
		
		public function get IntParam12():int {
			return AppContext.getAppUtil().getInt(param12);
		}
		
		public function set IntParam12(param12:int):void {
			this.param12 = param12 + "";
		}
		
		public function get IntParam13():int {
			return AppContext.getAppUtil().getInt(param13);
		}
		
		public function set IntParam13(param13:int):void {
			this.param13 = param13 + "";
		}
		
		public function get IntParam14():int {
			return AppContext.getAppUtil().getInt(param14);
		}
		
		public function set IntParam14(param14:int):void {
			this.param14 = param14 + "";
		}
		
		public function get IntParam15():int {
			return AppContext.getAppUtil().getInt(param15);
		}
		
		public function set IntParam15(param15:int):void {
			this.param15 = param15 + "";
		}
		
		public function get NumParam1():Number {
			return AppContext.getAppUtil().getNumber(param1);
		}
		
		public function set NumParam1(param1:Number):void {
			this.param1 = param1 + "";
		}
		
		public function get NumParam2():Number {
			return AppContext.getAppUtil().getNumber(param2);
		}
		
		public function set NumParam2(param2:Number):void {
			this.param2 = param2 + "";
		}
		
		public function get NumParam3():Number {
			return AppContext.getAppUtil().getNumber(param3);
		}
		
		public function set NumParam3(param3:Number):void {
			this.param3 = param3 + "";
		}
		
		public function get NumParam4():Number {
			return AppContext.getAppUtil().getNumber(param4);
		}
		
		public function set NumParam4(param4:Number):void {
			this.param4 = param4 + "";
		}
		
		public function get NumParam5():Number {
			return AppContext.getAppUtil().getNumber(param5);
		}
		
		public function set NumParam5(param5:Number):void {
			this.param5 = param5 + "";
		}
		
		public function get NumParam6():Number {
			return AppContext.getAppUtil().getNumber(param6);
		}
		
		public function set NumParam6(param6:Number):void {
			this.param6 = param6 + "";
		}
		
		public function get NumParam7():Number {
			return AppContext.getAppUtil().getNumber(param7);
		}
		
		public function set NumParam7(param7:Number):void {
			this.param7 = param7 + "";
		}
		
		public function get NumParam8():Number {
			return AppContext.getAppUtil().getNumber(param8);
		}
		
		public function set NumParam8(param8:Number):void {
			this.param8 = param8 + "";
		}
		
		public function get NumParam9():Number {
			return AppContext.getAppUtil().getNumber(param9);
		}
		
		public function set NumParam9(param9:Number):void {
			this.param9 = param9 + "";
		}
		
		public function get NumParam10():Number {
			return AppContext.getAppUtil().getNumber(param10);
		}
		
		public function set NumParam10(param10:Number):void {
			this.param10 = param10 + "";
		}
		
		public function get NumParam11():Number {
			return AppContext.getAppUtil().getNumber(param11);
		}
		
		public function set NumParam11(param11:Number):void {
			this.param11 = param11 + "";
		}
		
		public function get NumParam12():Number {
			return AppContext.getAppUtil().getNumber(param12);
		}
		
		public function set NumParam12(param12:Number):void {
			this.param12 = param12 + "";
		}
		
		public function get NumParam13():Number {
			return AppContext.getAppUtil().getNumber(param13);
		}
		
		public function set NumParam13(param13:Number):void {
			this.param13 = param13 + "";
		}
		
		public function get NumParam14():Number {
			return AppContext.getAppUtil().getNumber(param14);
		}
		
		public function set NumParam14(param14:Number):void {
			this.param14 = param14 + "";
		}
		
		public function get NumParam15():Number {
			return AppContext.getAppUtil().getNumber(param15);
		}
		
		public function set NumParam15(param15:Number):void {
			this.param15 = param15 + "";
		}

	}
}