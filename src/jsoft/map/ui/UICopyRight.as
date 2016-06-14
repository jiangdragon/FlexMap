package jsoft.map.ui
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.text.TextFieldAutoSize;
	
	import mx.core.UIComponent;
	import mx.core.UITextField;
	import mx.graphics.ImageSnapshot;
	/*
	* 主要写在地图 中显示中的用户的制作公司的文字
	*/
	public class UICopyRight extends UIComponent
	{
		//private var textStr:String = "@ 2010 - 绍兴市公安局警用地理信息系统";
		//private var textStr:String = "@ 2010 - 太极计算机股份有限公司";
		private var textStr:String = "@ 2010 - 红有软件公司";
		//		构造方法
		public function UICopyRight() {
		}
//		展示textStr的字符串
		public function show(width:int=0,height:int=0):void {
			this.graphics.clear();
			if(width == 0) {
				width = AppContext.getApplication().width;
			}
			if(height == 0) {
				height = AppContext.getApplication().height;
			}
			var left:int = width - textStr.length * 12 - 30;
			var top:int = height - 30;
			//AppContext.getAppUtil().alert("show:left="+left+",top="+top);
			this.x = left;
			this.y = top;
			this.width = textStr.length * 12;
			this.height = 12;
			var color:int = rgbToInt(0,0,0);
			this.graphics.lineStyle(1,color);
			var fromX:int = 0;
			var fromY:int = 0;
			var toX:int = textStr.length * 12;
			var toY:int = 12;
			//this.graphics.moveTo(fromX,fromY);
			//this.graphics.lineTo(toX,toY);
			var uit:UITextField = new UITextField();
			uit.text = textStr;
			uit.autoSize =   TextFieldAutoSize.LEFT;
			var textBitmapData:BitmapData = ImageSnapshot.captureBitmapData(uit);
			var sizeMatrix:Matrix = new Matrix();
			var coef:Number = Math.min(uit.measuredWidth/textBitmapData.width,uit.measuredHeight/textBitmapData.height);
			sizeMatrix.a = coef;
			sizeMatrix.d = coef;
			textBitmapData = ImageSnapshot.captureBitmapData(uit,sizeMatrix);
			this.graphics.lineStyle(0,0,0);
			var sm:Matrix = new Matrix();
			sm.tx = 0;
			sm.ty = 0;
			this.graphics.beginBitmapFill(textBitmapData,sm,false);
			this.graphics.drawRect(0,0,uit.measuredWidth,uit.measuredHeight);
			this.graphics.endFill();
		}
//		对颜色的rgb的值转化成int型
		private function rgbToInt(r:int, g:int, b:int):int {
			return r << 16 | g << 8 | b << 0;
		}
		
	}
}