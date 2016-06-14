package jsoft.map.dispatch
{
	import jsoft.map.feature.query.CircleQuery;
	import jsoft.map.feature.query.LineQuery;
	import jsoft.map.feature.query.PageQuery;
	import jsoft.map.feature.query.PolyQuery;
	import jsoft.map.feature.query.Query;
	import jsoft.map.feature.query.RectQuery;
	import jsoft.map.feature.query.IdentityQuery;
	import jsoft.map.feature.query.CircleIdentityQuery;
	import jsoft.map.feature.query.RectIdentityQuery;
	
	public class QueryDispatcher implements Dispatcher
	{
		public function QueryDispatcher()
		{
		}

		public function sendMessage(param:DispatchParam):void {
			if("query" == param.Type) {
				query(param.vstr,param.vstr,param.vstr,param.vint);
				return;
			}
			if("rect" == param.Type) {
				rectQuery(param.vstr,param.vstr,param.vnum,param.vnum,param.vnum,param.vnum,param.vnum,param.vstr,param.vint,param.vint);
				return;
			}
			if("circle" == param.Type) {
				circleQuery(param.vstr,param.vstr,param.vnum,param.vnum,param.vnum,param.vnum,param.vstr,param.vint,param.vint);
				return;
			}
			if("line" == param.Type) {
				lineQuery(param.vstr,param.vstr,param.vstr,param.vstr,param.vnum,param.vstr,param.vint,param.vint);
				return;
			}
			if("poly" == param.Type) {
				polyQuery(param.vstr,param.vstr,param.vstr,param.vstr,param.vnum,param.vstr,param.vint,param.vint);
				return;
			}
			if("queryPage" == param.Type) {
				queryPage(param.vint,param.vint,param.vint);
				return;
			}
			if("identity" == param.Type) {
				queryIdentity(param.vstr,param.vstr,param.vstr,param.vint);
				return;
			}
			if("identityCircle" == param.Type) {
				queryIdentityByCircle(param.vstr,param.vstr,param.vstr,param.vnum,param.vnum,param.vnum,param.vnum,param.vint,param.vint);
				return;
			}
			if("identityRect" == param.Type) {
				queryIdentityByRect(param.vstr,param.vstr,param.vstr,param.vnum,param.vnum,param.vnum,param.vnum,param.vnum,param.vint,param.vint);
				return;
			}
		}
		
		public function getMessage(param:DispatchParam):String {
			return null;
		}
		
		public static function query(source:String,layerName:String,where:String,maxRecord:int):void {
			var query:Query = new Query();
			query.query(source,layerName,where,maxRecord);
		}
		
		public static function rectQuery(source:String,layerName:String,minx:Number,miny:Number,maxx:Number,maxy:Number,around:Number,where:String,queryFlag:int,maxRecord:int):void {
			var query:RectQuery = new RectQuery();
			query.query(source,layerName,minx,miny,maxx,maxy,around,where,queryFlag,maxRecord);
		}
		
		public static function circleQuery(source:String,layerName:String,cx:Number,cy:Number,r:Number,around:Number,where:String,queryFlag:int,maxRecord:int):void {
			var query:CircleQuery = new CircleQuery();
			query.query(source,layerName,cx,cy,r,around,where,queryFlag,maxRecord);
		}
		
		public static function lineQuery(source:String,layerName:String,xAry:String,yAry:String,around:Number,where:String,queryFlag:int,maxRecord:int):void {
			var query:LineQuery = new LineQuery();
			query.query(source,layerName,xAry,yAry,around,where,queryFlag,maxRecord);
		}
		
		public static function polyQuery(source:String,layerName:String,xAry:String,yAry:String,around:Number,where:String,queryFlag:int,maxRecord:int):void {
			var query:PolyQuery = new PolyQuery();
			query.query(source,layerName,xAry,yAry,around,where,queryFlag,maxRecord);
		}
		
		public static function queryPage(recordsetIndex:int,pageIndex:int,maxRecord:int):void {
			var query:PageQuery = new PageQuery();
			query.query(recordsetIndex,pageIndex,maxRecord);
		}
		public static function queryIdentity(source:String,layerGroup:String,queryValue:String,maxRecord:int):void {
			var query:IdentityQuery = new IdentityQuery();
			query.query(source,layerGroup,queryValue,maxRecord);
		}
		public static function queryIdentityByCircle(source:String,layerGroup:String,queryValue:String,cx:Number,cy:Number,r:Number,around:Number,queryFlag:int,maxRecord:int):void {
			var query:CircleIdentityQuery = new CircleIdentityQuery();
			query.query(source,layerGroup,queryValue,cx,cy,r,around,queryFlag,maxRecord);
		}
		public static function queryIdentityByRect(source:String,layerGroup:String,queryValue:String,minx:Number,miny:Number,maxx:Number,maxy:Number,around:Number,queryFlag:int,maxRecord:int):void {
			var query:RectIdentityQuery = new RectIdentityQuery();
			query.query(source,layerGroup,queryValue,minx,miny,maxx,maxy,around,queryFlag,maxRecord);
		}
		
	}
}