package
{
	import flash.display.Stage;
	
	import jsoft.map.MapContext;
	import jsoft.map.dispatch.DispatchManager;
	import jsoft.map.util.AppUtil;
	import jsoft.map.util.DrawUtil;
	import jsoft.map.util.GeomUtil;
	
	import mx.core.Application;
	
	public class AppContext
	{
		private static var appContext:AppContext = new AppContext();
		private var startTime:Number = 0;
		private var seed:int = 0;
		private var application:Application;
		private var mapContext:MapContext = new MapContext();
		
		public function AppContext() {
		}
		
		public static function initContext(_application:Application):void {
			appContext.application = _application;
			//mx.controls.Alert.show("initDispatch","JFlexMap");
			DispatchManager.initDispatch();
			//mx.controls.Alert.show("init success","JFlexMap");
			appContext.mapContext.getMapConfigManager().setDefaultFeatureServer();
			appContext.mapContext.getMapConfigManager().loadMapConfig();
			//ExternalInterface.call("initFMap()");
		}
		
		public static function getApplication():Application {
			return appContext.application;
		}
		
		public static function getStage():Stage {
			return appContext.application.stage;
		}
		
		public static function getMapContext():MapContext {
			return appContext.mapContext;
		}
		
		public static function getTime():Number {
			return new Date().getTime();
		}
		
		public static function startTime():void {
			appContext.startTime = getTime();
			appContext.seed++;
		}
		
		public static function endTime(msg:String = ""):void {
			var endTime:Number = getTime();
			var timeSpan:Number = endTime - appContext.startTime;
			if(timeSpan > 0) {
				trace("Proc:" + appContext.seed + "  " + msg + " using " + timeSpan);
			}
			appContext.startTime = endTime;
		}
		
		public static function getAppUtil():AppUtil {
			return new AppUtil();
		}
		
		public static function getDrawUtil():DrawUtil {
			return new DrawUtil();
		}
		
		public static function getGeomUtil():GeomUtil {
			return new GeomUtil();
		}

	}
}