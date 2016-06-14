package jsoft.map.dispatch
{
	
	import flash.external.ExternalInterface;
	import flash.utils.setTimeout;
	
	import jsoft.map.acete.VectorAcete;
	import jsoft.map.event.MapEvent;
	import jsoft.map.event.vector.AddPointVector;
	import jsoft.map.event.vector.CancelSelectVector;
	import jsoft.map.event.vector.CreateArrowVector;
	import jsoft.map.event.vector.CreateDoubleSarrowEvent;
	import jsoft.map.event.vector.CreateLineVectorEvent;
	import jsoft.map.event.vector.CreateMultiArrowVector;
	import jsoft.map.event.vector.CreatePointVectorEvent;
	import jsoft.map.event.vector.CreatePolyVectorEvent;
	import jsoft.map.event.vector.CreateSarrowEvent;
	import jsoft.map.event.vector.CreateVectorEvent;
	import jsoft.map.event.vector.RemovePointVector;
	import jsoft.map.event.vector.RemoveSelectVector;
	import jsoft.map.event.vector.ReverseSelectVector;
	import jsoft.map.event.vector.SelectVectorEvent;
	import jsoft.map.feature.FeatureCallBack;
	import jsoft.map.feature.FeatureServer;
	import jsoft.map.feature.VectorSave;
	import jsoft.map.geometry.FPoint;
	import jsoft.map.geometry.Line;
	import jsoft.map.geometry.Polygon;
	import jsoft.map.vector.BaseVector;
	import jsoft.map.vector.IVector;
	import jsoft.map.vector.line.ArrowVector;
	import jsoft.map.vector.line.DoubleSarrowVector;
	import jsoft.map.vector.line.EqualSarrowVector;
	import jsoft.map.vector.line.SarrowVector;
	import jsoft.map.vector.line.SimpleLineVector;
	import jsoft.map.vector.line.TailSarrowVector;
	import jsoft.map.vector.line.XSarrowVector;
	import jsoft.map.vector.point.PointImageVector;
	import jsoft.map.vector.point.PointStringVector;
	import jsoft.map.vector.point.SimplePointVector;
	import jsoft.map.vector.point.SimplePointVectorEx;
	import jsoft.map.vector.poly.CircleVector;
	import jsoft.map.vector.poly.DiamondVector;
	import jsoft.map.vector.poly.ImageVector;
	import jsoft.map.vector.poly.OvalVector;
	import jsoft.map.vector.poly.RectVector;
	import jsoft.map.vector.poly.SimplePolygonVector;
	import jsoft.map.vector.poly.SimplePolygonVectorEx;
	
	public class VectorDispatcher implements Dispatcher,FeatureCallBack
	{
		private var contentAry:Array;
		private var contentCycle:int = 0;
		
		public function VectorDispatcher() {
		}
		
		public function sendMessage(param:DispatchParam):void {
			var vector:BaseVector = null;
			if("createSimplePoint" == param.Type) {
				vector = createSimplePointVector(param);
				addPointEvent(vector);
				return;
			}
			if("createSimplePointEx" == param.Type) {
				vector = createSimplePointVectorEx(param);
				addPointEvent(vector);
				return;
			}
			if("createPointImage" == param.Type) {
				vector = createPointImageVector(param);
				addPointEvent(vector);
				return;
			}
			if("createPointString" == param.Type){//文字--by小江
				vector = createPointStringVector(param);
				addPointEvent(vector);
				return;
			}
			if("createLine" == param.Type) {
				vector = createSimpleLineVector(param);
				addLineEvent(vector);
				return;
			}
			if("createPoly" == param.Type) {
				vector = createSimplePolyVector(param);
				addPolyEvent(vector);
				return;
			}
			/**************以下是箭头*********************/
			//平面转弯箭头
			if("createEqualSarrow" == param.Type) {
				vector = createEqualSarrowVector(param);
				addSarrowEvent(vector);
				return;
			}
			//燕尾
			if("createTailSarrow" == param.Type) {
				vector = createTailSarrowVector(param);
				addSarrowEvent(vector);
				return;
			}
			//转弯箭头
			if("createSarrow" ==  param.Type){
				vector = createSarrowVector(param);
				addSarrowEvent(vector);
				return;
			}
			//多箭头
			if("createXSarrow" == param.Type){
				vector = createXSarrowVector(param);
				addSarrowEvent(vector);
			}
			//双箭头
			if("createDoubleSarrow" == param.Type){
				vector = createDoubleSarrowVector(param);
				addDoubleSarrowEvent(vector);
			}
			
			if("createArrow" == param.Type) {
				vector = createArrowVector(param);
				addArrowEvent(vector);
				return;
			}
			if("createMultiArrow" == param.Type) {
				vector = createArrowVector(param);
				addMultiArrowEvent(vector);
				return;
			}
			if("createCircle" == param.Type) {
				vector = createCircleVector(param);
				addVectorEvent(vector);
				return;
			}
			if("createOval" == param.Type) {
				vector = createOvalVector(param);
				addVectorEvent(vector);
				return;
			}
			if("createRect" == param.Type) {
				vector = createRectVector(param);
				addVectorEvent(vector);
				return;
			}
			if("createDiamond" == param.Type) {
				vector = createDiamondVector(param);
				addVectorEvent(vector);
				return;
			}
			if("createImage" == param.Type) {
				vector = createImageVector(param);
				addVectorEvent(vector);
				return;
			}
			
			if(param.Type == "addSimplePoint") {
				vector = addSimplePointVector(param);
				addVector(vector);
				return;
			}
			if(param.Type == "addSimplePointEx") {
				vector = addSimplePointVectorEx(param);
				addVector(vector);
				return;
			}
			if(param.Type == "addPointImage") {
				vector = addPointImageVector(param);
				addVector(vector);
				return;
			}
			if("addLine" == param.Type) {
				vector = addSimpleLineVector(param);
				addVector(vector);
				return;
			}
			if("addPoly" == param.Type) {
				vector = addSimplePolyVector(param);
				addVector(vector);
				return;
			}
			if("addPolyEx" == param.Type) {
				vector = addSimplePolyVectorEx(param);
				addVector(vector);
				return;
			}
			
			if(param.Type == "selectVector") {
				var selectVectorEvent:SelectVectorEvent = new SelectVectorEvent();
				addEvent(selectVectorEvent);
				return;
			}
			if(param.Type == "cancelSelectVector") {
				var cancelSelectVector:CancelSelectVector = new CancelSelectVector();
				cancelSelectVector.execute();
				return;
			}
			if(param.Type == "reverseSelectVector") {
				var reverseSelectVector:ReverseSelectVector = new ReverseSelectVector();
				reverseSelectVector.execute();
				return;
			}
			if(param.Type == "removeSelectVector") {
				var removeSelectVector:RemoveSelectVector = new RemoveSelectVector();
				removeSelectVector.execute();
				return;
			}
			if(param.Type == "addPointVector") {
				var addPointVector:AddPointVector = new AddPointVector();
				addEvent(addPointVector);
				return;
			}
			if(param.Type == "removePointVector") {
				var removePointVector:RemovePointVector = new RemovePointVector();
				addEvent(removePointVector);
				return;
			}
			if(param.Type == "setVectorSchemaData") {
				setVectorSchemaData(param.vstr);
				return;
			}
			if(param.Type == "openSchema") {
				openSchema(param.vstr,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "openSchemaEx") {
				openSchemaEx(param.vstr,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "playSchema") {
				playSchema(param.vint,param.vstr,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "saveSchema") {
				saveSchema(param.vstr,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "removeSchema") {
				removeSchema(param.vstr,param.vstr,param.vstr);
				return;
			}
			if(param.Type == "getSchemaList") {
				getSchemaList(param.vstr,param.vstr);
				return;
			}

			if(param.Type == "setMoveById") {
				setMoveById(param.vstr,param.vnum,param.vline,param.vbool);
				return;
			}
			if(param.Type == "setMoveByGroup") {
				setMoveByGroup(param.vstr,param.vnum,param.vline,param.vbool);
				return;
			}
			if(param.Type == "setMoveDelayById") {
				setMoveDelayById(param.vstr,param.vnum,param.vnum,param.vline,param.vbool);
				return;
			}
			if(param.Type == "setMmoveDelayByGroup") {
				setMoveDelayByGroup(param.vstr,param.vnum,param.vnum,param.vline,param.vbool);
				return;
			}
			if(param.Type == "moveById") {
				moveById(param.vstr,param.vnum,param.vline,param.vbool);
				return;
			}
			if(param.Type == "moveByGroup") {
				moveByGroup(param.vstr,param.vnum,param.vline,param.vbool);
				return;
			}
			if(param.Type == "moveDelayById") {
				moveDelayById(param.vstr,param.vnum,param.vnum,param.vline,param.vbool);
				return;
			}
			if(param.Type == "moveDelayByGroup") {
				moveDelayByGroup(param.vstr,param.vnum,param.vnum,param.vline,param.vbool);
				return;
			}
			if(param.Type == "moveToById") {
				moveToById(param.vstr,param.vnum,param.vnum);
				return;
			}
			if(param.Type == "moveToByGroup") {
				moveToByGroup(param.vstr,param.vnum,param.vnum);
				return;
			}
			if(param.Type == "removeVectorById") {
				AppContext.getMapContext().getMapContent().getVectorLayer().removeVectorById(param.vstr);
				return;
			}
			if(param.Type == "removeVectorByType") {
				AppContext.getMapContext().getMapContent().getVectorLayer().removeVectorByGroup(param.vstr);
				return;
			}
			if(param.Type == "start") {
				startAnimate();
				return;
			}
			if(param.Type == "pause") {
				pauseAnimate();
				return;
			}
			if(param.Type == "resume") {
				resumeAnimate();
				return;
			}
			if(param.Type == "stop") {
				stopAnimate();
				return;
			}
			if(param.Type == "setVectorIdVisible") {
				setVectorIdVisible(param.vstr,param.vbool);
				return;
			}
			if(param.Type == "setVectorGroupVisible") {
				setVectorGroupVisible(param.vstr,param.vbool);
				return;
			}

		}
	
		public function getMessage(param:DispatchParam):String {
			if(param.Type == "getVectorSchemaData") {
				return getVectorSchemaData();
			}
			if(param.Type == "getLocationById") {
				return getLocationById(param.vstr);
			}
			if(param.Type == "getLocationByGroup") {
				return getLocationByGroup(param.vstr);
			}
			if(param.Type == "getSelectedId") {
				return getSelectedId();
			}
			if(param.Type == "getSelectedGroup") {
				return getSelectedId();
			}
			if(param.Type == "getIdsByGroup") {
				return getIdsByGroup(param.vstr);
			}
			if(param.Type == "getGroupById") {
				return getGroupById(param.vstr);
			}
			if(param.Type == "getMoveIds") {
				return getMoveIds();
			}
			if(param.Type == "getDelayById") {
				return getDelayById(param.vstr);
			}
			if(param.Type == "getSpeedById") {
				return getSpeedById(param.vstr);
			}
			if(param.Type == "getLineById") {
				return getLineById(param.vstr);
			}
			if(param.Type == "getViewFlagById") {
				return getViewFlagById(param.vstr);
			}
			return "";
		}
		/******************创建箭头方法************************/
		private function createEqualSarrowVector(param:DispatchParam) :EqualSarrowVector {
			var vector:EqualSarrowVector = new EqualSarrowVector();
			return vector;
		}
		
		private function createTailSarrowVector(param:DispatchParam) :TailSarrowVector {
			var vector:TailSarrowVector = new TailSarrowVector();
			return vector;
		}
		
		private function createSarrowVector(param:DispatchParam) :SarrowVector {
			var vector:SarrowVector = new SarrowVector();
			return vector;
		}
		
		private function createXSarrowVector(param:DispatchParam) :XSarrowVector {
			var vector:XSarrowVector = new XSarrowVector();
			return vector;
		}
		
		private function createDoubleSarrowVector(param:DispatchParam) :DoubleSarrowVector {
			var vector:DoubleSarrowVector = new DoubleSarrowVector();
			return vector;
		}
		
		
		private function createSimplePointVector(param:DispatchParam) : SimplePointVector {
			var color:int = param.vcolor;
			var size:int = param.vint;
			var type:int = param.vint;
			var vector:SimplePointVector = new SimplePointVector();
			vector.setColor(color);
			vector.setSize(size);
			vector.setType(type);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function createSimplePointVectorEx(param:DispatchParam) : SimplePointVectorEx {
			var color:int = param.vcolor;
			var size:int = param.vint;
			var type:int = param.vint;
			var outlinecolor:int = param.vcolor;
			var outlinewidth:int = param.vint;
			var vector:SimplePointVectorEx = new SimplePointVectorEx();
			vector.setColor(color);
			vector.setSize(size);
			vector.setType(type);
			vector.setOutlineColor(outlinecolor);
			vector.setOutlineWidth(outlinewidth);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function createPointImageVector(param:DispatchParam) : PointImageVector {
			var imageUrl:String = param.vstr;
			var width:int = param.vint;
			var height:int = param.vint;
			var vector:PointImageVector = new PointImageVector();
			vector.setImageUrl(imageUrl);
			vector.setWidth(width);
			vector.setHeight(height);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			//vector.initImage();
			return vector;
		}
		//文字--by小江
		private function createPointStringVector(param:DispatchParam) : PointStringVector {
			var vector:PointStringVector = new PointStringVector();
			vector.setTxt(param.vstr);//字内容
			vector.setFontName(param.vstr);//字体
			vector.setFontSize(param.vint);//字号
			vector.setFontColor(param.vcolor);//字体色
			vector.setBackColor(param.vstr);//背景色
			vector.setBorderColor(param.vstr);//边框色
			vector.setBold(param.vbool);//加粗
			vector.setItalic(param.vbool);//倾斜
			vector.setUnderLine(param.vbool);//下划线
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}

		private function createSimpleLineVector(param:DispatchParam) : SimpleLineVector {
			var vector:SimpleLineVector = new SimpleLineVector();	
			var _pointGap1:int=param.vint; //线中两点间最短忽略距离，小于此距离则认为是一个点
			var _color1:int=param.vcolor;
			var _width1:int=param.vint;	
			var _startArrow1:String = param.vstr;   //线起始点形状 无箭头
			var _endArrow1:String   = param.vstr;   //线结束点形状 无箭头
			var _dashStyle1:String  = param.vstr ;  //线形状 实线
			
			vector.setPointGap(_pointGap1);
			vector.setColor(_color1);
			vector.setWidth(_width1);
			vector.setStartArrow(_startArrow1);
			vector.setEndArrow(_endArrow1);
			vector.setDashStyle(_dashStyle1);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function createSimplePolyVector(param:DispatchParam) : SimplePolygonVector {
			var vector:SimplePolygonVector = new SimplePolygonVector();	
			var _pointGap1:int=param.vint; //线中两点间最短忽略距离，小于此距离则认为是一个点
			var _color:int=param.vcolor;
			var _fillColor:int=param.vcolor;
			var _weight:int=param.vint;
			var _opacity:Number=param.vnum;
			
			vector.setPointGap(_pointGap1);
			vector.setColor(_color);
			vector.setFillColor(_fillColor);
			vector.setWeight(_weight);
			vector.setOpacity(_opacity);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function createArrowVector(param:DispatchParam) : ArrowVector {
			var vector:ArrowVector = new ArrowVector();	
			var _color:int=param.vcolor;
			var _width:int=param.vint;
			
			vector.setColor(_color);
			vector.setWidth(_width);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function createCircleVector(param:DispatchParam) : CircleVector {
			var vector:CircleVector = new CircleVector();
			var _pointGap1:int=param.vint;	
			var _color:int=param.vcolor;
			var _fillColor:int=param.vcolor;
			var _weight:int=param.vint;
			var _opacity:Number=param.vnum;
			
			vector.setPointGap(_pointGap1);
			vector.setColor(_color);
			vector.setFillColor(_fillColor);
			vector.setWeight(_weight);
			vector.setOpacity(_opacity);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function createOvalVector(param:DispatchParam) : OvalVector {
			var vector:OvalVector = new OvalVector();	
			var _pointGap1:int=param.vint;
			var _color:int=param.vcolor;
			var _fillColor:int=param.vcolor;
			var _weight:int=param.vint;
			var _opacity:Number=param.vnum;
			
			vector.setPointGap(_pointGap1);
			vector.setColor(_color);
			vector.setFillColor(_fillColor);
			vector.setWeight(_weight);
			vector.setOpacity(_opacity);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function createRectVector(param:DispatchParam) : RectVector {
			var vector:RectVector = new RectVector();	
			var _pointGap1:int=param.vint;
			var _color:int=param.vcolor;
			var _fillColor:int=param.vcolor;
			var _weight:int=param.vint;
			var _opacity:Number=param.vnum;
			
			vector.setPointGap(_pointGap1);
			vector.setColor(_color);
			vector.setFillColor(_fillColor);
			vector.setWeight(_weight);
			vector.setOpacity(_opacity);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function createDiamondVector(param:DispatchParam) : DiamondVector {
			var vector:DiamondVector = new DiamondVector();
			var _pointGap1:int=param.vint;
			var _color:int=param.vcolor;
			var _fillColor:int=param.vcolor;
			var _weight:int=param.vint;
			var _opacity:Number=param.vnum;
			
			vector.setPointGap(_pointGap1);
			vector.setColor(_color);
			vector.setFillColor(_fillColor);
			vector.setWeight(_weight);
			vector.setOpacity(_opacity);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function createImageVector(param:DispatchParam) : ImageVector {
			var vector:ImageVector = new ImageVector();
			var _pointGap1:int=param.vint;
			var _imageUrl:String=param.vstr;
			
			vector.setPointGap(_pointGap1);
			vector.setImageUrl(_imageUrl);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function addSimplePointVector(param:DispatchParam) : SimplePointVector {
			var p:FPoint = param.vpoint;
			var color:int = param.vcolor;
			var size:int = param.vint;
			var type:int = param.vint;
			var vector:SimplePointVector = new SimplePointVector();
			vector.setGeometry(p);
			vector.setColor(color);
			vector.setSize(size);
			vector.setType(type);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function addSimplePointVectorEx(param:DispatchParam) : SimplePointVectorEx {
			var p:FPoint = param.vpoint;
			var color:int = param.vcolor;
			var size:int = param.vint;
			var type:int = param.vint;
			var outlinecolor:int = param.vcolor;
			var outlinewidth:int = param.vint;
			var vector:SimplePointVectorEx = new SimplePointVectorEx();
			vector.setGeometry(p);
			vector.setColor(color);
			vector.setSize(size);
			vector.setType(type);
			vector.setOutlineColor(outlinecolor);
			vector.setOutlineWidth(outlinewidth);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function addPointImageVector(param:DispatchParam) : PointImageVector {
			var p:FPoint = param.vpoint;
			var imageUrl:String = param.vstr;
			var width:int = param.vint;
			var height:int = param.vint;
			var vector:PointImageVector = new PointImageVector();
			vector.setGeometry(p);
			vector.setImageUrl(imageUrl);
			vector.setWidth(width);
			vector.setHeight(height);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			//vector.initImage();
			return vector;
		}
		
		private function addSimpleLineVector(param:DispatchParam) : SimpleLineVector {
			var vector:SimpleLineVector = new SimpleLineVector();
			var line:Line = param.vline;
			var _pointGap1:int=param.vint; //线中两点间最短忽略距离，小于此距离则认为是一个点
			var _color1:int=param.vcolor;
			var _width1:int=param.vint;	
			var _startArrow1:String = param.vstr;   //线起始点形状 无箭头
			var _endArrow1:String   = param.vstr;   //线结束点形状 无箭头
			var _dashStyle1:String  = param.vstr ;  //线形状 实线
			
			vector.setGeometry(line);
			vector.setPointGap(_pointGap1);
			vector.setColor(_color1);
			vector.setWidth(_width1);
			vector.setStartArrow(_startArrow1);
			vector.setEndArrow(_endArrow1);
			vector.setDashStyle(_dashStyle1);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function addSimplePolyVector(param:DispatchParam) : SimplePolygonVector {
			var vector:SimplePolygonVector = new SimplePolygonVector();
			var poly:Polygon = param.vpoly;	
			var _pointGap1:int=param.vint; //线中两点间最短忽略距离，小于此距离则认为是一个点
			var _color:int=param.vcolor;
			var _fillColor:int=param.vcolor;
			var _weight:int=param.vint;
			var _opacity:Number=param.vnum;
			
			vector.setGeometry(poly);
			vector.setPointGap(_pointGap1);
			vector.setColor(_color);
			vector.setFillColor(_fillColor);
			vector.setWeight(_weight);
			vector.setOpacity(_opacity);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		/* 节点带图片的多边形 */
		private function addSimplePolyVectorEx(param:DispatchParam) : SimplePolygonVectorEx {
			var vector:SimplePolygonVectorEx = new SimplePolygonVectorEx();
			var poly:Polygon = param.vpoly;	
			var _pointGap1:int = param.vint; //线中两点间最短忽略距离，小于此距离则认为是一个点
			var _color:int = param.vcolor;
			var _fillColor:int = param.vcolor;
			var _weight:int = param.vint;
			var _opacity:Number = param.vnum;
			var _imageUrl:String = param.vstr;
			
			vector.setGeometry(poly);
			vector.setPointGap(_pointGap1);
			vector.setColor(_color);
			vector.setFillColor(_fillColor);
			vector.setWeight(_weight);
			vector.setOpacity(_opacity);
			vector.setImageUrl(_imageUrl);
			vector.setVectorId(param.vstr);
			vector.setGroup(param.vstr);
			return vector;
		}
		
		private function addPointEvent(vector:BaseVector):void {
			if(vector != null) {
				var event:CreatePointVectorEvent = new CreatePointVectorEvent(vector);
				addEvent(event);
			}
		}
		
		private function addLineEvent(vector:BaseVector):void {
			if(vector != null) {
				var event:CreateLineVectorEvent = new CreateLineVectorEvent(vector);
				addEvent(event);
			}
		}
		
		private function addPolyEvent(vector:BaseVector):void {
			if(vector != null) {
				var event:CreatePolyVectorEvent = new CreatePolyVectorEvent(vector);
				addEvent(event);
			}
		}
		
		private function addSarrowEvent(vector:BaseVector):void {
			if(vector != null) {
				var event:CreateSarrowEvent = new CreateSarrowEvent(vector);
				addEvent(event);
			}
		}
		
		private function addDoubleSarrowEvent(vector:BaseVector):void {
			if(vector != null) {
				var event:CreateDoubleSarrowEvent = new CreateDoubleSarrowEvent(vector);
				addEvent(event);
			}
		}
		
		private function addArrowEvent(vector:BaseVector):void {
			if(vector != null) {
				var event:CreateArrowVector = new CreateArrowVector(vector);
				addEvent(event);
			}
		}
		
		private function addMultiArrowEvent(vector:BaseVector):void {
			if(vector != null) {
				var event:CreateMultiArrowVector = new CreateMultiArrowVector(vector);
				addEvent(event);
			}
		}
		
		private function addVectorEvent(vector:BaseVector):void {
			if(vector != null) {
				var event:CreateVectorEvent = new CreateVectorEvent(vector);
				addEvent(event);
			}
		}
		
		private function addVector(vector:BaseVector):void {
			if(vector != null) {
				AppContext.getMapContext().getMapContent().getVectorLayer().addVector(vector);
			}
		}
		
		private function addEvent(event:MapEvent):void {
			if(event != null) {
				AppContext.getMapContext().getMapContent().setMapEvent(event);
			}
		}
		
		private function getVectorSchemaData():String {
			var theString:String = "";
			var layer:VectorAcete = AppContext.getMapContext().getMapContent().getVectorLayer(); 
			for(var i:int=0;i<layer.getVectors().length;i++) {
				var vector:IVector = layer.getVectors()[i];
				var type:String = vector.getVectorName();
				var vstr:String = vector.getVectorString();
				if(i!=0) {
					theString += "|";
				}
				theString += type + "|" + vstr;
			}
			return theString;
		}
		
		private function setVectorSchemaData(schemaData:String,clearFlag:Boolean=true):void {
			var layer:VectorAcete = AppContext.getMapContext().getMapContent().getVectorLayer();
			if(clearFlag) {
				layer.clear();
			}
//			AppContext.getAppUtil().alert(schemaData);
			var ary:Array = AppContext.getAppUtil().getStringArray(schemaData,"|");
			for(var i:int=0;i+1<ary.length;i+=2) {
				var type:String = ary[i];
				var vstr:String = ary[i+1];
//				AppContext.getAppUtil().alert(type);
//				AppContext.getAppUtil().alert(vstr);
				if(type=="PointImageVector") {
					var pointImageVector:PointImageVector = new PointImageVector();
					pointImageVector.setVectorString(vstr);
					layer.addVector(pointImageVector);
					continue;
				}
				if(type=="SimplePointVector") {
					var simplePointVector:SimplePointVector = new SimplePointVector();
					simplePointVector.setVectorString(vstr);
					layer.addVector(simplePointVector);
					continue;
				}
				if(type=="SimplePointVectorEx") {
					var simplePointVectorEx:SimplePointVectorEx = new SimplePointVectorEx();
					simplePointVectorEx.setVectorString(vstr);
					layer.addVector(simplePointVectorEx);
					continue;
				}
				if(type=="PointStringVector") {
					var pointStringVector:PointStringVector = new PointStringVector();
					pointStringVector.setVectorString(vstr);
					layer.addVector(pointStringVector);
					continue;
				}
				if(type=="SimpleLineVector") {
					var simpleLineVector:SimpleLineVector = new SimpleLineVector();
					simpleLineVector.setVectorString(vstr);
					layer.addVector(simpleLineVector);
					continue;
				}
				if(type=="SimplePolygonVector") {
					var simplePolygonVector:SimplePolygonVector = new SimplePolygonVector();
					simplePolygonVector.setVectorString(vstr);
					layer.addVector(simplePolygonVector);
					continue;
				}
				if(type=="CircleVector") {
					var circleVector:CircleVector = new CircleVector();
					circleVector.setVectorString(vstr);
					layer.addVector(circleVector);
					continue;
				}
				if(type=="DiamondVector") {
					var diamondVector:DiamondVector = new DiamondVector();
					diamondVector.setVectorString(vstr);
					layer.addVector(diamondVector);
					continue;
				}
				if(type=="ImageVector") {
					var imageVector:ImageVector = new ImageVector();
					imageVector.setVectorString(vstr);
					layer.addVector(imageVector);
					continue;
				}
				if(type=="OvalVector") {
					var ovalVector:OvalVector = new OvalVector();
					ovalVector.setVectorString(vstr);
					layer.addVector(ovalVector);
					continue;
				}
				if(type=="RectVector") {
					var rectVector:RectVector = new RectVector();
					rectVector.setVectorString(vstr);
					layer.addVector(rectVector);
					continue;
				}
				if(type=="ArrowVector") {
					var arrowVector:ArrowVector = new ArrowVector();
					arrowVector.setVectorString(vstr);
					layer.addVector(arrowVector);
					continue;
				}
				if(type=="EqualSarrowVector") {
					var equalSarrowVector:EqualSarrowVector = new EqualSarrowVector();
					equalSarrowVector.setVectorString(vstr);
					layer.addVector(equalSarrowVector);
					continue;
				}
				if(type=="TailSarrowVector") {
					var tailSarrowVector:TailSarrowVector = new TailSarrowVector();
					tailSarrowVector.setVectorString(vstr);
					layer.addVector(tailSarrowVector);
					continue;
				}
				if(type=="SarrowVector") {
					var sArrowVector:SarrowVector = new SarrowVector();
					sArrowVector.setVectorString(vstr);
					layer.addVector(sArrowVector);
					continue;
				}
				if(type=="XSarrowVector") {
					var xSarrowVector:XSarrowVector = new XSarrowVector();
					xSarrowVector.setVectorString(vstr);
					layer.addVector(xSarrowVector);
					continue;
				}
				if(type=="DoubleSarrowVector") {
					var doubleSarrowVector:DoubleSarrowVector = new DoubleSarrowVector();
					doubleSarrowVector.setVectorString(vstr);
					layer.addVector(doubleSarrowVector);
					continue;	
				}
				AppContext.getAppUtil().alert("不支持的矢量标绘类型：" + type);
				break;
			}
			layer.refresh();
		}
		
		private function openSchema(name:String,type:String,catalog:String):void {
			var server:FeatureServer = new FeatureServer(1);
			server.setFeatureCallBack(this);
			server.processMapEvent("openVector","name="+name+"&type="+type+"&catalog="+catalog);
		}
		
		private function openSchemaEx(name:String,type:String,catalog:String):void {
			var server:FeatureServer = new FeatureServer(1);
			server.setFeatureCallBack(this);
			server.processMapEvent("openVectorEx","name="+name+"&type="+type+"&catalog="+catalog);
		}
		
		private function playSchema(playTime:int,names:String,type:String,catalog:String):void {
			var server:FeatureServer = new FeatureServer(1);
			server.setFeatureCallBack(this);
			server.processMapEvent("playSchema","playTime="+playTime+"&name="+names+"&type="+type+"&catalog="+catalog);
		}
		
		private function saveSchemaOld(name:String,type:String,catalog:String):void {
			var server:FeatureServer = new FeatureServer(1);
			server.setFeatureCallBack(this);
			var content:String = getVectorSchemaData();
			server.addStringParam("content",content);
			server.processMapPostEvent("saveVector","name="+name+"&type="+type+"&catalog="+catalog);
		}
		
		private function saveSchema(name:String,type:String,catalog:String):void {
			var content:String = getVectorSchemaData();
			var length:int = content.length;
			var maxLen:int = 1000;
			var parts:int = length / maxLen;
			if(length > maxLen * parts) {
				parts++;
			}
			for(var i:int=0;i<=content.length;i+=maxLen) {
				var len:int=content.length-i;
				if(len>maxLen) {
					len=maxLen;
				}
				var server:FeatureServer = new FeatureServer(1);
				server.setFeatureCallBack(new VectorSave(name,type,catalog,content));
				var str:String=content.substr(i,len);
				
				server.addStringParam("name",name);
				server.addStringParam("type",type);
				server.addStringParam("catalog",catalog);
				server.addStringParam("index",i+"");
				server.addStringParam("len",len+"");
				server.addStringParam("max",parts+"");
				server.addStringParam("content",str);
				server.processMapEvent("saveVector");
				break;
			}
		}
		
		private function removeSchema(name:String,type:String,catalog:String):void {
			var server:FeatureServer = new FeatureServer(1);
			server.setFeatureCallBack(this);
			server.processMapEvent("deleteVector","name="+name+"&type="+type+"&catalog="+catalog);
		}
		
		private function getSchemaList(type:String,catalog:String):void {
			var server:FeatureServer = new FeatureServer(1);
			server.setFeatureCallBack(this);
			server.processMapEvent("findVectorList","type="+type+"&catalog="+catalog);
		}
		
		// 返回请求结果
		public function onResult(xml:XML):void {
		}
		
		// 返回请求结果
		public function onResultStr(result:String):void {
			var ret:String;
			ret = AppContext.getAppUtil().parseString(result,"vector");
			if(ret != null) {
				//AppContext.getAppUtil().alert(ret);
				setVectorSchemaData(ret);
				ExternalInterface.call("fMap.getFVector().onSchemaBack",1);
				return;
			}
			ret = AppContext.getAppUtil().parseString(result,"vectorEx");
			if(ret != null) {
				setVectorSchemaData(ret,false);
				ExternalInterface.call("fMap.getFVector().onSchemaBack",1);
				return;
			}
			ret = AppContext.getAppUtil().parseString(result,"schema");
			if(ret != null) {
				ExternalInterface.call("fMap.getFVector().onGetSchemaListBack",ret);
				return;
			}
			ret = AppContext.getAppUtil().parseString(result,"save");
			if(ret != null) {
				ExternalInterface.call("fMap.getFVector().onSchemaBack",ret);
				return;
			}
			ret = AppContext.getAppUtil().parseString(result,"remove");
			if(ret != null) {
				ExternalInterface.call("fMap.getFVector().onSchemaBack",ret);
				return;
			}
			ret = AppContext.getAppUtil().parseString(result,"play");
			if(ret != null) {
				var index:int = ret.indexOf("#");
				if(index <= 0) {
					ExternalInterface.call("fMap.getFVector().onSchemaBack",0);
					return;
				}
				var head:String = ret.substr(0,index);
				var content:String = ret.substr(index+1);
				var ary:Array = AppContext.getAppUtil().getStringArray(head,",");
				contentAry = new Array();
				contentCycle = 0;
				for(var i:int = 0;i < ary.length;i++) {
					var pos:int = AppContext.getAppUtil().getInt(ary[i]);
					var str:String = content.substr(0,pos);
					content = content.substr(pos);
					contentAry.push(str);
				}
				//最后的剩下的就是间隔时间了
				var playTime:int = AppContext.getAppUtil().getInt(content);
				if(playTime == 0){
					playTime = 1000;
				}
				flash.utils.setTimeout(playSchemaCycle,playTime,playTime);
				
				//flash.utils.setTimeout(playSchemaCycle,1000);
				ExternalInterface.call("fMap.getFVector().onSchemaBack",1);
				return;
			}
		}

		private function playSchemaCycle():void {
			var playTime:int = arguments[0];
			if(contentCycle>=contentAry.length) {
				return;
			}
			var layer:VectorAcete = AppContext.getMapContext().getMapContent().getVectorLayer();
			var content:String = contentAry[contentCycle++];
			layer.clear();
			setVectorSchemaData(content);
			AppContext.getMapContext().getMapContent().refresh();
			flash.utils.setTimeout(playSchemaCycle,playTime,playTime);
			//flash.utils.setTimeout(playSchemaCycle,1000);
		}
		
		// 请求错误
		public function onError():void {
		}
		
		public function setVectorIdVisible(id:String,visible:Boolean):void {
			AppContext.getMapContext().getMapVectorLayer().setVectorIdVisible(id,visible);
		}
		
		public function setVectorGroupVisible(group:String,visible:Boolean):void {
			AppContext.getMapContext().getMapVectorLayer().setVectorGroupVisible(group,visible);
		}
		
		private function getLocationById(id:String) : String {
			return AppContext.getMapContext().getMapVectorLayer().getLocationById(id);
		}
		
		private function getLocationByGroup(group:String) : String {
			return AppContext.getMapContext().getMapVectorLayer().getLocationByGroup(group);
		}
		
		private function getSelectedId() : String {
			return AppContext.getMapContext().getMapVectorLayer().getSelectedId();
		}
		
		private function getSelectedGroup() : String {
			return AppContext.getMapContext().getMapVectorLayer().getSelectedGroup();
		}
		
		private function getIdsByGroup(group:String) : String {
			return AppContext.getMapContext().getMapVectorLayer().getIdsByGroup(group);
		}
		
		private function getGroupById(id:String) : String {
			return AppContext.getMapContext().getMapVectorLayer().getGroupById(id);
		}
		
		private function getMoveIds() : String {
			return AppContext.getMapContext().getMapVectorLayer().getMoveIds();
		}
		
		private function getDelayById(id:String) : String {
			return AppContext.getMapContext().getMapVectorLayer().getDelayById(id) + "";
		}
		
		private function getSpeedById(id:String) : String {
			return AppContext.getMapContext().getMapVectorLayer().getSpeedById(id) + "";
		}
		
		private function getLineById(id:String) : String {
			var line:Line = AppContext.getMapContext().getMapVectorLayer().getLineById(id);
			var xstr:String = "";
			var ystr:String = "";
			for(var i:int=0;line!=null&&i<line.getXArray().length;i++) {
				if(i>0) {
					xstr+=",";
					ystr+=",";
				}
				xstr+=line.getXArray()[i];
				ystr+=line.getYArray()[i];
			}
			return line==null?"":xstr+";"+ystr;
		}
		
		private function getViewFlagById(id:String) : String {
			return AppContext.getMapContext().getMapVectorLayer().getViewFlagById(id) + "";
		}
		
		private function moveToById(id:String,x:Number,y:Number) : void {
			AppContext.getMapContext().getMapVectorLayer().moveToById(id,x,y);
		}
		
		private function moveToByGroup(group:String,x:Number,y:Number) : void {
			AppContext.getMapContext().getMapVectorLayer().moveToByGroup(group,x,y);
		}
		
		private function setMoveById(id:String,speed:Number,line:Line,viewFlag:Boolean) : void {
			AppContext.getMapContext().getMapVectorLayer().setMoveById(id,speed,line,viewFlag);
		}
		private function setMoveByGroup(group:String,speed:Number,line:Line,viewFlag:Boolean) : void {
			AppContext.getMapContext().getMapVectorLayer().setMoveByGroup(group,speed,line,viewFlag);
		}
		private function setMoveDelayById(id:String,delay:Number,speed:Number,line:Line,viewFlag:Boolean) : void {
			AppContext.getMapContext().getMapVectorLayer().setMoveDelayById(id,delay,speed,line,viewFlag);
		}
		private function setMoveDelayByGroup(group:String,delay:Number,speed:Number,line:Line,viewFlag:Boolean) : void {
			AppContext.getMapContext().getMapVectorLayer().setMoveDelayByGroup(group,delay,speed,line,viewFlag);
		}
		private function moveById(id:String,speed:Number,line:Line,viewFlag:Boolean) : void {
			AppContext.getMapContext().getMapVectorLayer().moveById(id,speed,line,viewFlag);
		}
		private function moveByGroup(group:String,speed:Number,line:Line,viewFlag:Boolean) : void {
			AppContext.getMapContext().getMapVectorLayer().moveByGroup(group,speed,line,viewFlag);
		}
		private function moveDelayById(id:String,delay:Number,speed:Number,line:Line,viewFlag:Boolean) : void {
			AppContext.getMapContext().getMapVectorLayer().moveDelayById(id,delay,speed,line,viewFlag);
		}
		private function moveDelayByGroup(group:String,delay:Number,speed:Number,line:Line,viewFlag:Boolean) : void {
			AppContext.getMapContext().getMapVectorLayer().moveDelayByGroup(group,delay,speed,line,viewFlag);
		}
		private function startAnimate():void {
			AppContext.getMapContext().getMapVectorLayer().startAnimate();
		}
		private function pauseAnimate():void {
			AppContext.getMapContext().getMapVectorLayer().pauseAnimate();
		}
		private function resumeAnimate():void {
			AppContext.getMapContext().getMapVectorLayer().resumeAnimate();
		}
		private function stopAnimate():void {
			AppContext.getMapContext().getMapVectorLayer().stopAnimate();
		}

	}
}