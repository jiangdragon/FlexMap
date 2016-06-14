package jsoft.map.test
{
	import jsoft.map.dispatch.DispatchManager;
	import jsoft.map.dispatch.MapDispatcher;
	
	public class TestManager
	{
		public function TestManager()
		{
		}
		
		public static function test():void {
			var testManager:TestManager = new TestManager();
			//testManager.testLoadConfig();
			testManager.testLoadMap();
			testManager.testMapPan();
			//testManager.testMapZoomIn();
			testManager.testDraw();
			//testManager.testArrow();
		}
		
		private function testLoadConfig():void {
			AppContext.getMapContext().getMapConfigManager().addMapConfig("矢量","http://10.72.237.103:9990/map/image");
			//AppContext.getMapContext().getMapConfigManager().addMapConfig("矢量","http://localhost:9000/vector");
			//AppContext.getMapContext().getMapConfigManager().addMapConfigEx("矢量","http://localhost:8180/portal/module/map/standard/config/map0/image.xml","http://10.71.62.71:9990/map/image");
		}
		
		private function testLoadMap():void {
			//AppContext.getMapContext().getMapConfigManager().addMapConfig("矢量","http://10.72.237.103:9990/map/image");
			//MapDispatcher.addMapConfig("矢量","http://localhost:9000/klmy/image");
			//MapDispatcher.addMapConfigEx("矢量","image.xml","http://localhost:9000/vector");
			MapDispatcher.addMapConfigEx("矢量","http://localhost:8180/portal/module/map/standard/config/map0/image.xml","http://localhost:9000/test/image");
			MapDispatcher.showMapConfig("矢量");
		}

		private function testMapPan():void {
			MapDispatcher.setMapPan();
		}

		private function testMapZoomIn():void {
			MapDispatcher.setMapZoomIn();
		}
		
		private function testDraw():void {
			//DispatchManager.sendMessage("draw","drawCircle","120.2809","29.82715","50","red","blue","2","0.2","circle","ccc1","","","","","","");
			//DispatchManager.sendMessage("draw","removeById","circle","","","","","","","","","","","","","","");
			DispatchManager.sendMessage("draw","drawBar","84.8080","45.1915","aa,bb,cc","30,20,50","red,blue,yellow","100","0.5","circle","ccc1","","","","","","");
		}
		
		private function testArrow():void {
			//DispatchManager.sendMessage("vector","createArrow","red","1","50","red","blue","2","0.2","circle","ccc1","","","","","","");
			DispatchManager.sendMessage("vector","createMultiArrow","red","1","50","red","blue","2","0.2","circle","ccc1","","","","","","");
		}

	}
}