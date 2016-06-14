package jsoft.map
{
	import flash.events.Event;
	
	import jsoft.map.acete.DrawLayer;
	import jsoft.map.acete.InputLayer;
	import jsoft.map.acete.MapHotAcete;
	import jsoft.map.acete.VectorAcete;
	import jsoft.map.config.MapConfigManager;
	import jsoft.map.content.MapContent;
	import jsoft.map.geometry.GeometryFactory;
	import jsoft.map.tip.MapTipFactory;
	import jsoft.map.ui.UICopyRight;
	import jsoft.map.ui.UIEagle;
	import jsoft.map.ui.UILevel;
	import jsoft.map.ui.UIScale;
	
	import mx.containers.Canvas;
	
	public class MapContext
	{
		private var mapConfigManager:MapConfigManager = new MapConfigManager();
		private var mapTipFactory:MapTipFactory = new MapTipFactory();
		private var mapContent:MapContent = null;
		private var mapInput:InputLayer = null;
		private var mapDynInput:InputLayer = null;
		private var buttonContainer:Canvas = null;
		private var mapHot:MapHotAcete = null;
		private var levelButton:UILevel = null;
		private var scale:UIScale = null;
		private var copyRight:UICopyRight = null;
		private var eagle:UIEagle = null;
		
		public function MapContext() {
		}
		
		public function getMapConfigManager():MapConfigManager {
			return mapConfigManager;
		}
		
		public function getMapContent():MapContent {
			if(mapContent == null) {
				refresh();
			}
			return mapContent;
		}
		
		public function showLevel(flag:Boolean):void {
			if(levelButton == null) {
				return;
			}
			if(flag) {
				if(!AppContext.getApplication().contains(levelButton)) {
					AppContext.getApplication().addChild(levelButton);
				}
			} else {
				if(AppContext.getApplication().contains(levelButton)) {
					AppContext.getApplication().removeChild(levelButton);
				}
			}
		}
		
		public function showScale(flag:Boolean):void {
			if(scale == null) {
				return;
			}
			if(flag) {
				if(!AppContext.getApplication().contains(scale)) {
					AppContext.getApplication().addChild(scale);
				}
			} else {
				if(AppContext.getApplication().contains(scale)) {
					AppContext.getApplication().removeChild(scale);
				}
			}
		}
		
		public function showEagle(flag:Boolean):void {
			if(eagle == null) {
				return;
			}
			if(flag) {
				if(!AppContext.getApplication().contains(eagle)) {
					AppContext.getApplication().addChild(eagle);
				}
			} else {
				if(AppContext.getApplication().contains(eagle)) {
					AppContext.getApplication().removeChild(eagle);
				}
			}
		}
		
		public function refresh():void {
			if(mapContent == null) {
				mapContent = new MapContent();
				AppContext.getApplication().addChild(mapContent);
				AppContext.getApplication().addEventListener(Event.RESIZE, onResize);
			}
			mapContent.x = 0;
			mapContent.y = 0;
			mapContent.width = AppContext.getApplication().width;
			mapContent.height = AppContext.getApplication().height;
			if(mapInput == null) {
				mapInput = new InputLayer();
				AppContext.getApplication().addChild(mapInput);
				mapInput.initLayer();
			}
			if(mapDynInput == null) {
				mapDynInput = new InputLayer();
				AppContext.getApplication().addChild(mapDynInput);
				mapDynInput.initLayer();
			}
			if(mapHot == null) {
				mapHot = new MapHotAcete();
				AppContext.getApplication().addChild(mapHot);
			}
			if(levelButton == null) {
				levelButton = new UILevel();
				AppContext.getApplication().addChild(levelButton);
			}
			levelButton.x = 50;
			levelButton.y = 50;//(AppContext.getApplication().height - levelButton.height) / 2;
			if(scale == null) {
				scale = new UIScale();
				scale.show();
				AppContext.getApplication().addChild(scale);
			}
			if(copyRight == null) {
				copyRight = new UICopyRight();
				copyRight.show();
				AppContext.getApplication().addChild(copyRight);
			}
			if(eagle == null) {
				eagle = new UIEagle();
				AppContext.getApplication().addChild(eagle);
			}
			if(buttonContainer == null) {
				buttonContainer = new Canvas();
				buttonContainer.visible = true;
				AppContext.getApplication().addChild(buttonContainer);
			}
		}
		
		public function getButtonContainer():Canvas {
			if(buttonContainer == null) {
				refresh();
			}
			buttonContainer.x = 0;
			buttonContainer.y = 0;
			buttonContainer.width = AppContext.getApplication().width;
			buttonContainer.height = AppContext.getApplication().height;
			//AppContext.getAppUtil().alert("buttonContainer.width="+buttonContainer.width);
			return buttonContainer;
		}
		
		public function getLevelUI():UILevel {
			if(levelButton == null) {
				refresh();
			}
			return levelButton;
		}
		
		public function getScale():UIScale {
			if(scale == null) {
				refresh();
			}
			return scale;
		}
		
		public function getCopyRight():UICopyRight {
			if(copyRight == null) {
				refresh();
			}
			return copyRight;
		}
		
		public function getEagle():UIEagle {
			if(eagle == null) {
				refresh();
			}
			return eagle;
		}
		
		public function getMapDrawLayer():DrawLayer {
			if(mapContent == null) {
				refresh();
			}
			return mapContent.getDrawLayer();
		}
		
		public function getMapVectorLayer():VectorAcete {
			if(mapContent == null) {
				refresh();
			}
			return mapContent.getVectorLayer();
		}
		
		public function getMapInputLayer():InputLayer {
			if(mapInput == null) {
				refresh();
			}
			return mapInput;
		}
		
		public function getMapDynInputLayer():InputLayer {
			if(mapDynInput == null) {
				refresh();
			}
			return mapDynInput;
		}
		
		public function clearInputLayer():void {
			getMapInputLayer().clear();
			getMapDynInputLayer().clear();
		}
		
		private function onResize(event:Event):void {
			refresh();
		}
		
		public function getGeometryFactory():GeometryFactory {
			return new GeometryFactory();
		}
		
		public function getHotInstance():MapHotAcete {
			return mapHot;
		}
		
		public function getHotContainer():MapHotAcete {
			return mapHot;
		}
		
		public function getMapTipFactory():MapTipFactory {
			return mapTipFactory;
			//return new MapTipFactory();
		}
	}
}