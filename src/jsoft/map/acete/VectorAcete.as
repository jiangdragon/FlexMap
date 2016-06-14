package jsoft.map.acete
{
	import flash.events.Event;
	
	import jsoft.map.config.MapLevel;
	import jsoft.map.content.MapContent;
	import jsoft.map.content.MapLayer;
	import jsoft.map.event.vector.SelectVectorEvent;
	import jsoft.map.geometry.Coordinate;
	import jsoft.map.geometry.Line;
	import jsoft.map.vector.BaseVector;
	import jsoft.map.vector.IVector;
	
	import mx.core.UIComponent;
	
	public class VectorAcete extends UIComponent implements MapLayer
	{
		private var content:MapContent;
		private var centerX:Number;
		private var centerY:Number;
		private var vectors:Array = new Array();
		
		public function VectorAcete(content:MapContent) {
			this.content = content;
		}
		
		public function initLayer(layer:MapLayer):void {
			addEventListener(Event.RESIZE, onResize);
			onResize(null);
		}
		
		private function onResize(event:Event):void {
			refresh();
		}
		public function clearTiles():void {
		}
		//  删除图层
		public function removeLayer():void {
			if(content.contains(this)) {
				content.removeChild(this);
			}
		}
		public function addVector(vector:BaseVector):void {
			vector.setStatus(false);
			vectors.push(vector);
			addChild(vector);
			var coord:Coordinate = content.getCoordinate();
			vector.showVector(coord);
			//AppContext.getAppUtil().alert("addVector vectors.length="+vectors.length);
		}
		public function getVectors():Array {
			return vectors;
		}
		public function setVectors(newVectors:Array):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:BaseVector = vectors[i];
				if(this.contains(vec)) {
					this.removeChild(vec);
				}
			}
			vectors = newVectors;
			for(i=0;i<vectors.length;i++) {
				var vector:BaseVector = vectors[i];
				if(!this.contains(vector)) {
					this.addChild(vector);
				}
			}
		}
		public function removeVector(vector:IVector):void {
			//AppContext.getAppUtil().alert("removeVectorById vectors.length="+vectors.length);
			var newVec:Array = new Array();
			for(var i:int=0;i<vectors.length;i++) {
				var vec:BaseVector = vectors[i];
				if(vec == vector) {
					if(this.contains(vec)) {
						this.removeChild(vec);
					}
				} else {
					newVec.push(vec);
				}
			}
			vectors = newVec;
		}
		public function removeVectorById(id:String):void {
			//AppContext.getAppUtil().alert("removeVectorById vectors.length="+vectors.length);
			//AppContext.getAppUtil().alert("removeVectorById id="+id);
			var newVec:Array = new Array();
			for(var i:int=0;i<vectors.length;i++) {
				var vec:BaseVector = vectors[i];
				if(vec.getVectorId() == id) {
					//AppContext.getAppUtil().alert("removeVectorById id="+id);
					vec.stopAnimate();
					if(this.contains(vec)) {
						this.removeChild(vec);
					}
				} else {
					newVec.push(vec);
				}
			}
			vectors = newVec;
		}
		public function removeVectorByGroup(group:String):void {
			//AppContext.getAppUtil().alert("removeVectorByGroup vectors.length="+vectors.length);
			var newVec:Array = new Array();
			for(var i:int=0;i<vectors.length;i++) {
				var vec:BaseVector = vectors[i];
				if(vec.getGroup() == group) {
					if(this.contains(vec)) {
						this.removeChild(vec);
					}
				} else {
					newVec.push(vec);
				}
			}
			vectors = newVec;
			
		}
		public function clear():void {
			//AppContext.getAppUtil().alert("clear vectors.length="+vectors.length);
			for(var i:int=0;i<vectors.length;i++) {
				var vec:BaseVector = vectors[i];
				if(this.contains(vec)) {
					this.removeChild(vec);
				}
			}
			vectors = new Array();
		}
		public function clearSelectStatus():void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:BaseVector = vectors[i];
				if(vec.getStatus()) {
					vec.setStatus(false);
					vec.showVector(AppContext.getMapContext().getMapContent().getCoordinate());
					vec.updateVector();
				}
			}
		}
		//  载入图片
		public function loadTiles(x:Number,y:Number):void {
			centerX = x;
			centerY = y;
		}

		//  显示图片
		public function showMap(x:Number,y:Number):void {
			//AppContext.getAppUtil().alert("showMap");
			centerX = x;
			centerY = y;
			var coord:Coordinate = content.getCoordinate();
			for(var i:int=0;i<vectors.length;i++) {
				var vec:BaseVector = vectors[i];
				vec.showVector(coord);
			}
		}
		
		public function showZoomMap(zoomLevelIndex:int):void {
			var level:MapLevel = content.getMapConfig().getMapLevel(zoomLevelIndex);
			var coord:Coordinate = level.createCoordinate(width,height);
			coord.setCenter(centerX,centerY);
			for(var i:int=0;i<vectors.length;i++) {
				var vec:BaseVector = vectors[i];
				vec.showVector(coord);
				vec.updateVector();
			}
		}
		
		private function toInt(val:Number):int {
			var ret:int = val;
			if(ret < val) {
				ret++;
			}
			return ret;
		}
		
		// 刷新地图
		public function refresh():void {
			//AppContext.getAppUtil().alert("refresh vectors.length="+vectors.length);
			x = 0;
			y = 0;
			this.width = content.width;
			this.height = content.height;
			if(!content.contains(this)) {
				content.addChild(this);
			}
			for(var i:int=0;i<vectors.length;i++) {
				var vec:BaseVector = vectors[i];
				vec.updateVector();
				vec.x += content.getShowOffsetX();
				vec.y += content.getShowOffsetY();
			}
		}
		
		public function setSelectEvent():void {
			var selectVectorEvent:SelectVectorEvent = new SelectVectorEvent();
			AppContext.getMapContext().getMapContent().setMapEvent(selectVectorEvent);
		}
		
		// 刷新地图
		public function redraw():void {
			//AppContext.getAppUtil().alert("refresh vectors.length="+vectors.length);
			x = 0;
			y = 0;
			this.width = content.width;
			this.height = content.height;
			if(!content.contains(this)) {
				content.addChild(this);
			}
			for(var i:int=0;i<vectors.length;i++) {
				var vec:BaseVector = vectors[i];
				vec.refresh();
				vec.x += content.getShowOffsetX();
				vec.y += content.getShowOffsetY();
			}
		}
		// 获取中心点坐标
		public function getCenterX():Number {
			return centerX;
		}
		
		// 获取中心点坐标
		public function getCenterY():Number {
			return centerY;
		}
		
		public function getLocationById(id:String):String {
			var str:String = "";
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getVectorId()==id) {
					str = vec.getCenterX() + "," + vec.getCenterY();
					return str;
				}
			}
			return str;
		}
		public function getLocationByGroup(group:String):String {
			var str:String = "";
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getGroup()==group) {
					str = vec.getCenterX() + "," + vec.getCenterY();
					return str;
				}
			}
			return str;
		}
		public function getSelectedId():String {
			var str:String = "";
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];//AppContext.getAppUtil().alert(vec.getVectorId());
				if(vec.getStatus()) {
					if(str.length==0) {
						str = vec.getVectorId();
					} else {
						str += "," + vec.getVectorId();
					}
				}
			}
			return str;
		}
		public function getSelectedGroup():String {
			var str:String = "";
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getStatus()) {
					if(str.length==0) {
						str = vec.getGroup();
					} else {
						str += "," + vec.getGroup();
					}
				}
			}
			return str;
		}
		public function getIdsByGroup(group:String):String {
			var str:String = "";
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getGroup() == group) {
					if(str.length==0) {
						str = vec.getVectorId();
					} else {
						str += "," + vec.getVectorId();
					}
				}
			}
			return str;
		}
		public function setVectorIdVisible(id:String,visible:Boolean):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				//AppContext.getAppUtil().alert("id1="+vec.getVectorId()+", id2="+id);
				if(vec.getVectorId() == id) {
					if(visible && !vec.isViewFlag()) {
						vec.showVector(AppContext.getMapContext().getMapContent().getCoordinate());
					} else if(!visible) {
						vec.clear();
					}
					vec.set_Visible(visible);
					vec.setViewFlag(visible);
				}
			}
		}
		public function setVectorGroupVisible(group:String,visible:Boolean):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getGroup() == group) {
					if(visible && !vec.isViewFlag()) {
						vec.showVector(AppContext.getMapContext().getMapContent().getCoordinate());
					} else if(!visible) {
						vec.clear();
					}
					vec.set_Visible(visible);
					vec.setViewFlag(visible);
				}
			}
		}
		public function getMoveIds():String {
			var str:String = "";
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				//AppContext.getAppUtil().alert(vec.getVectorId());
				if(vec.getSpeed() > 0) {
					if(str.length==0) {
						str = vec.getVectorId();
					} else {
						str += "," + vec.getVectorId();
					}
				}
			}
			return str;
		}
		public function getGroupById(id:String):String {
			var str:String = "";
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getVectorId() == id) {
					if(str.length==0) {
						str = vec.getGroup();
					} else {
						str += "," + vec.getGroup();
					}
				}
			}
			return str;
		}
		public function getDelayById(id:String):Number {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getVectorId() == id) {
					return vec.getDelay();
				}
			}
			return 0;
		}
		public function getSpeedById(id:String):Number {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getVectorId() == id) {
					return vec.getSpeed();
				}
			}
			return 0;
		}
		public function getLineById(id:String):Line {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getVectorId() == id) {
					return vec.getLine();
				}
			}
			return null;
		}
		public function getViewFlagById(id:String):Boolean {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getVectorId() == id) {
					return vec.isViewFlag();
				}
			}
			return false;
		}
		public function moveToById(id:String,x:Number,y:Number):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getVectorId()==id) {
					vec.setCenter(x,y);
				}
			}
		}
		public function moveToByGroup(group:String,x:Number,y:Number):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getGroup()==group) {
					vec.setCenter(x,y);
				}
			}
		}
		public function setMoveById(id:String,speed:Number,line:Line,viewFlag:Boolean):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				//AppContext.getAppUtil().alert(vec.getVectorId());
				if(vec.getVectorId()==id) {
					vec.setMoveAnimate(speed,line,viewFlag);
				}
			}
		}
		public function setMoveByGroup(group:String,speed:Number,line:Line,viewFlag:Boolean):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getGroup()==group) {
					vec.setMoveAnimate(speed,line,viewFlag);
				}
			}
		}
		public function setMoveDelayById(id:String,delay:Number,speed:Number,line:Line,viewFlag:Boolean):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				//AppContext.getAppUtil().alert(vec.getVectorId());
				if(vec.getVectorId()==id) {
					vec.setMoveAnimateDelay(delay,speed,line,viewFlag);
				}
			}
		}
		public function setMoveDelayByGroup(group:String,delay:Number,speed:Number,line:Line,viewFlag:Boolean):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getGroup()==group) {
					vec.setMoveAnimateDelay(delay,speed,line,viewFlag);
				}
			}
		}
		public function moveById(id:String,speed:Number,line:Line,viewFlag:Boolean):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				//AppContext.getAppUtil().alert(vec.getVectorId());
				if(vec.getVectorId()==id) {
					vec.moveAnimate(speed,line,viewFlag);
				}
			}
		}
		public function moveByGroup(group:String,speed:Number,line:Line,viewFlag:Boolean):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getGroup()==group) {
					vec.moveAnimate(speed,line,viewFlag);
				}
			}
		}
		public function moveDelayById(id:String,delay:Number,speed:Number,line:Line,viewFlag:Boolean):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				//AppContext.getAppUtil().alert(vec.getVectorId());
				if(vec.getVectorId()==id) {
					vec.moveAnimateDelay(delay,speed,line,viewFlag);
				}
			}
		}
		public function moveDelayByGroup(group:String,delay:Number,speed:Number,line:Line,viewFlag:Boolean):void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				if(vec.getGroup()==group) {
					vec.moveAnimateDelay(delay,speed,line,viewFlag);
				}
			}
		}
		public function startAnimate():void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				vec.startMove();
			}
		}
		public function pauseAnimate():void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				vec.pauseAnimate();
			}
		}
		public function resumeAnimate():void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				vec.resumeAnimate();
			}
		}
		public function stopAnimate():void {
			for(var i:int=0;i<vectors.length;i++) {
				var vec:IVector = vectors[i];
				vec.stopAnimate();
			}
		}


	}
}