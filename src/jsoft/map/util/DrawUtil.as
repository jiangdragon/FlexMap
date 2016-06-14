package jsoft.map.util
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	
	import jsoft.map.geometry.LineStyle;
	
	import mx.core.UITextField;
	import mx.graphics.ImageSnapshot;
	
	public class DrawUtil
	{
		private var graphics:Graphics;
		private var lineWidth:int = 1;
		private var lineColor:int = 0;
		private var fillColor:int = 0;
		private var fillAlpha:Number = 1;
		
		public function DrawUtil(graphics:Graphics=null) {
			this.graphics = graphics;
		}
		
		public function getGraphics() : Graphics {
			return graphics;
		}
		public function clear() : void {
			graphics.clear();
		}
		public function getLineWidth() : int {
			return lineWidth;
		}
		public function setLineWidth(lineWidth:int) : void {
			this.lineWidth = lineWidth;
		}
		public function getLineColor() : int {
			return fillColor;
		}
		public function setLineColor(lineColor:int) : void {
			this.lineColor = lineColor;
		}
		public function getFillColor() : int {
			return fillColor;
		}
		public function setFillColor(fillColor:int) : void {
			this.fillColor = fillColor;
		}
		public function isFill() : Boolean {
			return fillAlpha > 0;
		}
		public function setFill(fill:Boolean) : void {
			if(!fill) {
				fillAlpha = 0;
				graphics.endFill();
			} else {
				fillAlpha = 1;
			}
		}
		public function isFillTransparent() : Boolean {
			return fillAlpha == 0;
		}
		public function setFillTransparent(transparent:Boolean) : void {
			if(transparent) {
				fillAlpha = 0;
			} else {
				fillAlpha = 1;
			}
		}
		public function setFillAlpha(alpha:Number) : void {
			fillAlpha = alpha;
		}
		public function drawCircle(x:int,y:int,radius:int) : void {
			beginDraw();
			graphics.drawCircle(x,y,radius);
			endDraw();
		}
		public function drawOval(x:int,y:int,width:int,height:int) : void {
			beginDraw();
			graphics.drawEllipse(x,y,width,height);
			endDraw();
		}
		public function drawDiamond(x:int,y:int,width:int,height:int) : void {
			var xary:Array = new Array();
			var yary:Array = new Array();
			xary[0]=x+width/2;
			yary[0]=y;
			xary[1]=x+width;
			yary[1]=y+height/2;
			xary[2]=x+width/2;
			yary[2]=y+height;
			xary[3]=x;
			yary[3]=y+height/2;
			xary[4]=x+width/2;
			yary[4]=y;
			drawLineAry(xary,yary);
		}
		public function drawLine(x1:int,y1:int,x2:int,y2:int) : void {
			beginDraw();
			graphics.moveTo(x1,y1);
			graphics.lineTo(x2,y2);
			endDraw();
		}
		public function drawLineAry(xAry:Array,yAry:Array) : void {
			beginDraw();
			if(xAry.length>0&&yAry.length>0) {
				graphics.moveTo(xAry[0],yAry[0]);
			}
			for(var i:int=1;i<xAry.length&&i<yAry.length;i++) {
				graphics.lineTo(xAry[i],yAry[i]);
			}
			endDraw();
		}
	     //根据样式绘制线样式
	     public function drawStyleLine(_dashStyle:String,xAry:Array,yAry:Array,_pointGap:Number,_width:Number):void{
				beginDraw();
             	var ps:flash.geom.Point;
             	var pf:flash.geom.Point;
             	var i:int=0;
             	switch (_dashStyle){
		        	case LineStyle.DASHSTYLE_SOLID:
						if(xAry.length>0&&yAry.length>0) {
							graphics.moveTo(xAry[0],yAry[0]);
						}
						for(i=1;i<xAry.length&&i<yAry.length;i++) {
							graphics.lineTo(xAry[i],yAry[i]);
						}
		        		break;
		        	case LineStyle.DASHSTYLE_DASH:
			        	if(xAry.length>0&&yAry.length>0) {
							getGraphics().moveTo(xAry[0],yAry[0]);
						}
						for(i=1;i<xAry.length&&i<yAry.length;i++) {
							ps =new flash.geom.Point(xAry[i],yAry[i]);
							pf =new flash.geom.Point(xAry[i-1],yAry[i-1]);					
							drawDashedLinePart(pf,ps,6,_pointGap);
						}	
		        		break;
		        	case LineStyle.DASHSTYLE_DOT:
		        		if(xAry.length>0&&yAry.length>0) {
							getGraphics().moveTo(xAry[0],yAry[0]);
						}
						for(i=1;i<xAry.length&&i<yAry.length;i++) {
							ps =new flash.geom.Point(xAry[i],yAry[i]);
							pf =new flash.geom.Point(xAry[i-1],yAry[i-1]);					
							drawDotLinePart(pf,ps,6,_pointGap,_width);
						}	
		        		break;
		        	case LineStyle.DASHSTYLE_DASHDOT:
		        		if(xAry.length>0&&yAry.length>0) {
							getGraphics().moveTo(xAry[0],yAry[0]);
						}
						for(i=1;i<xAry.length&&i<yAry.length;i++) {
							ps =new flash.geom.Point(xAry[i],yAry[i]);
							pf =new flash.geom.Point(xAry[i-1],yAry[i-1]);					
							drawDashDotLinePart(pf,ps,6,_pointGap,_width);
						}	
		        		break;
		        	case LineStyle.DASHSTYLE_LONGDASH:
		        		if(xAry.length>0&&yAry.length>0) {
							getGraphics().moveTo(xAry[0],yAry[0]);
						}
						for(i=1;i<xAry.length&&i<yAry.length;i++) {
							ps =new flash.geom.Point(xAry[i],yAry[i]);
							pf =new flash.geom.Point(xAry[i-1],yAry[i-1]);					
							drawDashedLinePart(pf,ps,12,_pointGap);
						}	
		        		break;
		        	case LineStyle.DASHSTYLE_LONGDASHDOT:
		        		if(xAry.length>0&&yAry.length>0) {
							getGraphics().moveTo(xAry[0],yAry[0]);
						}
						for(i=1;i<xAry.length&&i<yAry.length;i++) {
							ps =new flash.geom.Point(xAry[i],yAry[i]);
							pf =new flash.geom.Point(xAry[i-1],yAry[i-1]);					
							drawDashDotLinePart(pf,ps,12,_pointGap,_width);
						}	
		        		break;
		        	case LineStyle.DASHSTYLE_LONGDASHDOTDOT:
		        		if(xAry.length>0&&yAry.length>0) {
							getGraphics().moveTo(xAry[0],yAry[0]);
						}
						for(i=1;i<xAry.length&&i<yAry.length;i++) {
							ps =new flash.geom.Point(xAry[i],yAry[i]);
							pf =new flash.geom.Point(xAry[i-1],yAry[i-1]);					
							drawDashDotDotLinePart(pf,ps,12,_pointGap,_width);
						}	
		        		break;
		        	case LineStyle.DASHSTYLE_SHORTDASH:
		        		if(xAry.length>0&&yAry.length>0) {
							getGraphics().moveTo(xAry[0],yAry[0]);
						}
						for(i=1;i<xAry.length&&i<yAry.length;i++) {
							ps =new flash.geom.Point(xAry[i],yAry[i]);
							pf =new flash.geom.Point(xAry[i-1],yAry[i-1]);					
							drawDashedLinePart(pf,ps,3,_pointGap);
						}	
		        		break;
		        	case LineStyle.DASHSTYLE_SHORTDOT:
		        		if(xAry.length>0&&yAry.length>0) {
							getGraphics().moveTo(xAry[0],yAry[0]);
						}
						for(i=1;i<xAry.length&&i<yAry.length;i++) {
							ps =new flash.geom.Point(xAry[i],yAry[i]);
							pf =new flash.geom.Point(xAry[i-1],yAry[i-1]);					
							drawDotLinePart(pf,ps,4,2,_width);
						}
		        		break;
		        	case LineStyle.DASHSTYLE_SHORTDASHDOT:
		        		if(xAry.length>0&&yAry.length>0) {
							getGraphics().moveTo(xAry[0],yAry[0]);
						}
						for(i=1;i<xAry.length&&i<yAry.length;i++) {
							ps =new flash.geom.Point(xAry[i],yAry[i]);
							pf =new flash.geom.Point(xAry[i-1],yAry[i-1]);					
							drawDashDotLinePart(pf,ps,4,_pointGap,_width);
						}	
		        		break;
		        	case LineStyle.DASHSTYLE_SHORTDASHDOTDOT:
		        		if(xAry.length>0&&yAry.length>0) {
							getGraphics().moveTo(xAry[0],yAry[0]);
						}
						for(i=1;i<xAry.length&&i<yAry.length;i++) {
							ps =new flash.geom.Point(xAry[i],yAry[i]);
							pf =new flash.geom.Point(xAry[i-1],yAry[i-1]);					
							drawDashDotDotLinePart(pf,ps,4,_pointGap,_width);
						}	
		        		break;
		        	default:
		        		break;		
	          	}
			endDraw();
         }
		//length 每段线长度；gap 间距 ； 线+间距
		private function drawDashedLinePart(pf:flash.geom.Point,ps:flash.geom.Point,length:Number,gap:Number):void {
            var max:Number = flash.geom.Point.distance(pf,ps); //最大间距 两点之间距离
            var l:Number = 0; //最小间距 0
            var p3:flash.geom.Point;
            var p4:flash.geom.Point;
            while(l<max) {
               p3 = flash.geom.Point.interpolate(ps,pf,l/max);
               l+=length;
               if(l>max)
	               l=max;
	           p4 = flash.geom.Point.interpolate(ps,pf,l/max);
               drawLine(p3.x,p3.y,p4.x,p4.y);
               l+=gap;
              }
           }
            //length 每段线长度；gap 间距； 线+点+间距 
         private function drawDashDotLinePart(pf:flash.geom.Point,ps:flash.geom.Point,length:Number,gap:Number,_width:Number):void {
                var max:Number = flash.geom.Point.distance(pf,ps); //最大间距 两点之间距离
                var l:Number = 0; //最小间距 0
                var p3:flash.geom.Point;
                var p4:flash.geom.Point;
                var i:int=0;
                while(l<max) {
                    p3 = flash.geom.Point.interpolate(ps,pf,l/max);
                    l+=length;
                    if(l>max)
                       l=max;
                    p4 = flash.geom.Point.interpolate(ps,pf,l/max);
                    if((i%2)==0){
	                   drawLine(p3.x,p3.y,p4.x,p4.y);   
                    }else{
                       drawCircle(p4.x,p4.y,_width/2);	
                    }
                    l+=gap;
                    i++;
                }
            }
            //length 每段线长度；gap 间距； 线+点+点+间距 
            private function drawDashDotDotLinePart(pf:flash.geom.Point,ps:flash.geom.Point,length:Number,gap:Number,_width:Number):void {
                var max:Number = flash.geom.Point.distance(pf,ps); //最大间距 两点之间距离
                var l:Number = 0; //最小间距 0
                var p3:flash.geom.Point;
                var p4:flash.geom.Point;
                var i:int=0;
                while(l<max) {
                    p3 = flash.geom.Point.interpolate(ps,pf,l/max);
                    l+=length;
                    if(l>max)l=max;
                    p4 = flash.geom.Point.interpolate(ps,pf,l/max);
                    switch (i%3){
                    	case 0:
                    		drawLine(p3.x,p3.y,p4.x,p4.y);   
                    	break;
                    	case 1:
                    		drawCircle(p4.x,p4.y,_width/2);	
                    	break;
                    	case 2:
                    		drawCircle(p4.x,p4.y,_width/2);	
                    	break;
                    	default:
                    		break;
                    }
                    l+=gap;
                    i++;
                }
            }
            //length 每段线长度；gap 间距 ；点+间距
            private function drawDotLinePart(pf:flash.geom.Point,ps:flash.geom.Point,length:Number,gap:Number,_width:Number):void {
                var max:Number = flash.geom.Point.distance(pf,ps); //最大间距 两点之间距离
                var l:Number = 0; //最小间距 0
                var p3:flash.geom.Point;
                var p4:flash.geom.Point;
                var i:int=0;
                while(l<max) {
                	
                    p3 = flash.geom.Point.interpolate(ps,pf,l/max);
                    l+=length;
                   if(l>max)l=max;
                    p4 = flash.geom.Point.interpolate(ps,pf,l/max);                 
                    drawCircle(p4.x,p4.y,_width/2);	                  
                    l+=gap;
                    i++;
                }
            }
		public function drawPolygon(xAry:Array,yAry:Array) : void {
			drawLineAry(xAry,yAry);
		}
		public function drawRect(x1:int,y1:int,x2:int,y2:int) : void {
			var left:int = x1 <= x2 ? x1 : x2;
			var top:int = y1 <= y2 ? y1 : y2;
			var width:int = Math.abs(x2-x1);
			var height:int = Math.abs(y2-y1);
			beginDraw();
			graphics.drawRect(left,top,width,height);
			endDraw();
		}
		public function drawText(x:int,y:int,text:String,fontName:String,fontSize:int,color:int,backColor:int,backOutlineColor:int) : void {
			var textLeft:int = x;
			var textTop:int = y;
	     	var textStr:String = text;
	     	var textWidth:int = textStr.length * 12;
	     	var textHeight:int = 12;
			graphics.lineStyle(1,color);
			var fromX:int = 0;
			var fromY:int = 0;
			var toX:int = textStr.length * 12;
			var toY:int = 12;
			//this.graphics.moveTo(fromX,fromY);
			//this.graphics.lineTo(toX,toY);
			var uit:UITextField = new UITextField();
			uit.text = textStr;
			uit.autoSize = TextFieldAutoSize.LEFT;
			var textBitmapData:BitmapData = ImageSnapshot.captureBitmapData(uit);
			var sizeMatrix:Matrix = new Matrix();
			var coef:Number = Math.min(uit.measuredWidth/textBitmapData.width,uit.measuredHeight/textBitmapData.height);
			sizeMatrix.a = coef;
			sizeMatrix.d = coef;
			textBitmapData = ImageSnapshot.captureBitmapData(uit,sizeMatrix);
			textWidth = uit.measuredWidth;
			textHeight = uit.measuredHeight;
			
			// draw background
			setFill(true);
	     	setFillColor(backColor);
	     	setLineColor(backOutlineColor);
	     	setLineWidth(1);
	     	drawRect(textLeft,textTop,textWidth+textLeft,textHeight+textTop);
	     	// draw text
	     	graphics.lineStyle(0,color,0);
			var sm:Matrix = new Matrix();
			sm.tx = textLeft;
			sm.ty = textTop;
			graphics.beginBitmapFill(textBitmapData,sm,false);
			graphics.drawRect(textLeft,textTop,textWidth,textHeight);
			graphics.endFill();
		}
		public function drawTextList(x:int,y:int,textLine:Array,textButton:Array,textLink:Array,fontName:String,fontSize:int,color:int,backColor:int,backOutlineColor:int) : void {
			
		}
		private function beginDraw() : void {
			graphics.lineStyle(lineWidth,lineColor);
			if(isFill()) {
				graphics.beginFill(fillColor,fillAlpha);
			} else {
				graphics.endFill();
			}
		}
		private function endDraw() : void {
			if(isFill()) {
				graphics.endFill();
			}
		}
		
		public function getBlack():int {
			return rgbToInt(0,0,0);
		}
		public function getWhite():int {
			return rgbToInt(255,255,255);
		}
		public function getLightGray():int {
			return rgbToInt(192,192,192);
		}
		public function getGray():int {
			return rgbToInt(128,128,128);
		}
		public function getRed():int {
			return rgbToInt(255,0,0);
		}
		public function getBlue():int {
			return rgbToInt(0,0,255);
		}
		public function getGreen():int {
			return rgbToInt(0,255,0);
		}
		public function getYellow():int {
			return rgbToInt(255,255,0);
		}
		public function getLightYellow():int {
			return rgbToInt(255,255,128);
		}
		public function getOrange():int {
			return rgbToInt(255,128,0);
		}
		public function getLightOrange():int {
			return rgbToInt(255,128,64);
		}
		public function rgbToInt(r:int, g:int, b:int):int {
			return r << 16 | g << 8 | b << 0;
		}
		
		public function getReverseColor(color:int):int {
			var red:int = color >> 16 & 0xff;
			var green:int = color >> 8 & 0xff;
			var blue:int = color & 0xff;
			return rgbToInt(255-red,255-green,255-blue);
		}
	}
}