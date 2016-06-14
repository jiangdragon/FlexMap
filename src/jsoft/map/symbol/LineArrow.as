package jsoft.map.symbol
{
	import flash.display.Graphics;
	import flash.geom.Point;
	
	import jsoft.map.util.DrawUtil;
	public class LineArrow
	{
		//箭头的大小
        private var _Radius:int=8;//与线的宽度有一定的比例关系
        private var _FromPoint:flash.geom.Point; //前一点
        private var _ToPoint:flash.geom.Point;   //终点
        private var _linewidth:int=1; //_Radius
        //线性的颜色
        private var _LineColor:uint=0x000000;
        //是否需要画箭头
        private var NeedArrow:Boolean=true;
        
        private var drawUtil:DrawUtil;
        
		public function LineArrow() {
		}
		public function drawLineArrow(_startArrow:String,_endArrow:String,x_arr:Array,y_arr:Array):void {
			if((_startArrow==null||_startArrow==LineStyle.ARROW_NO)&&(_endArrow==null||_endArrow==LineStyle.ARROW_NO)) {
				return;
			}
			//起始端点+终止端点
			if (x_arr.length>1) {
				var s_x:Array=new Array();
				var s_y:Array=new Array();
				s_x.push(x_arr[1]);s_y.push(y_arr[1]);
				s_x.push(x_arr[0]);s_y.push(y_arr[0]);
				//AppContext.getAppUtil().alert("_startArrow="+_startArrow+",s_x[0]="+s_x[0]+",s_y[0]="+s_y[0]+",s_x[1]="+s_x[1]+",s_y[1]="+s_y[1]);
				drawArrow(_startArrow,s_x,s_y);
				var e_x:Array=new Array;var e_y:Array=new Array;
				e_x.push(x_arr[x_arr.length-2]);e_y.push(y_arr[x_arr.length-2]);
				e_x.push(x_arr[x_arr.length-1]);e_y.push(y_arr[x_arr.length-1]);
				//AppContext.getAppUtil().alert("_endArrow="+_endArrow+",e_x[0]="+e_x[0]+",e_y[0]="+e_y[0]+",e_x[1]="+e_x[1]+",e_y[1]="+e_y[1]);
				drawArrow(_endArrow,e_x,e_y);
			}	
		}
         //绘制端点符号
         public function drawArrow(iArrow:String,xAry:Array,yAry:Array):void{
            setFromPoint(new flash.geom.Point(xAry[0],yAry[0]));
            setToPoint(new flash.geom.Point(xAry[1],yAry[1]));
         	switch(iArrow){
         		case LineStyle.ARROW_NO:
         			break;
         		case LineStyle.ARROW_BLOCK:         	
         			DrawBlock();
         			break;
         		case LineStyle.ARROW_CLASSIC:
         			DrawClassic();
         			break;
         		case LineStyle.ARROW_DIAMOND:         	
         			DrawDiamond();
         			break;
         		case LineStyle.ARROW_OPEN:         	
         			DrawOpen();
         			break;
         		case LineStyle.ARROW_OVAL:         	
         			DrawOval();
         			break;
         		case LineStyle.ARROW_CHEVRON:         	
         			DrawChevron();
         			break;
         		case LineStyle.ARROW_DOUBLECHEVRON:         	
         			DrawDoubleChevron();
         			break;
         		default:
         			break;
         	}
         }
        
        public function setFromPoint (fp:flash.geom.Point):void {
        	this._FromPoint=fp;
        }
        
        public function getFromPoint ():flash.geom.Point {
        	return this._FromPoint;
        }
        
        public function setToPoint (tp:flash.geom.Point):void {
        	this._ToPoint=tp;
        }
         public function getToPoint ():flash.geom.Point
        {
        	return this._ToPoint;
        }
        
        public function getGraphic ():Graphics
        {
        	return drawUtil.getGraphics();
        }
        
        public function setDrawUtil(drawUtil:DrawUtil):void
        {
        	this.drawUtil = drawUtil;
        }
        
        public function setLinewidth (inLinewidth:int):void
        {
        	this._linewidth=inLinewidth;
        }
         public function getLinewidth ():int
        {
        	return this._linewidth;
        }
        
         public function setLineColor (inLinecolor:int):void
        {
        	this._LineColor=inLinecolor;
        }
         public function getLineColor ():int
        {
        	return this._LineColor;
        }
        private function GetAngle():int
        {
            var tmpx:int=_ToPoint.x-_FromPoint.x ;
            var tmpy:int=_FromPoint.y -_ToPoint.y ;
            var angle:int= Math.atan2(tmpy,tmpx)*(180/Math.PI);
            return angle;
        }
        
        private function GetKAngle():int
        {
            var tmpx:int=_FromPoint.x-_ToPoint.x ;
            var tmpy:int=_FromPoint.y -_ToPoint.y ;
            var angle:int= Math.atan2(tmpy,tmpx)*(180/Math.PI);
            return angle;
        }
        
        //三角块形 
        public function DrawBlock():void
        {
            _Radius=this._linewidth*8;
            if(NeedArrow)
            {
                var angle:int =GetKAngle();
                var t_left_x:int=_ToPoint.x-_Radius/2 * Math.cos((90-angle )*(Math.PI/180)) ;//left x
                var t_left_y:int=_ToPoint.y+_Radius/2 * Math.sin((90-angle) *(Math.PI/180)) ;//left y
                var t_right_x:int  =_ToPoint.x-_Radius/2 * Math.cos((90-angle-180 )*(Math.PI/180)) ;//right x
                var t_right_y:int  =_ToPoint.y+_Radius/2 * Math.sin((90-angle-180) *(Math.PI/180)) ;//right y
                
                var t_2_X:int      =_ToPoint.x-_Radius * Math.cos((-angle-180 )*(Math.PI/180)) ;//line2  x 
                var t_2_Y:int      =_ToPoint.y+_Radius * Math.sin((-angle-180) *(Math.PI/180)) ;//line2  y
                
                var t2_left_x:int =t_2_X-_Radius/2 * Math.cos((90-angle )*(Math.PI/180)) ;//2 left x
                var t2_left_y:int =t_2_Y+_Radius/2 * Math.sin((90-angle ) *(Math.PI/180)) ;//2 left y
                var t2_right_x:int=t_2_X-_Radius/2 * Math.cos((90-angle-180 )*(Math.PI/180)) ;//2 right x
                var t2_right_y:int=t_2_Y+_Radius/2 * Math.sin((90-angle-180) *(Math.PI/180)) ;//2 right y
                
                
                var topX:int=_ToPoint.x ;
                var topY:int=_ToPoint.y  ;
                                
                drawUtil.getGraphics().lineStyle(1,_LineColor,1);
                drawUtil.getGraphics().beginFill(_LineColor,1);
             /* 方块
                this._graphic.moveTo(t_left_x,t_left_y);//左点
                this._graphic.lineTo(t_right_x,t_right_y);
                this._graphic.lineTo(t2_right_x,t2_right_y);
                this._graphic.lineTo(t2_left_x,t2_left_y);
                this._graphic.lineTo(t_left_x,t_left_y);
             */ 
                //三角形 
                drawUtil.getGraphics().moveTo(_ToPoint.x,_ToPoint.y);
                drawUtil.getGraphics().lineTo(t2_right_x,t2_right_y);
                drawUtil.getGraphics().lineTo(t2_left_x,t2_left_y);  //左点
                drawUtil.getGraphics().moveTo(_ToPoint.x,_ToPoint.y);
                drawUtil.getGraphics().endFill();
                
            }
        }

        //绘箭头
        public function DrawClassic():void
        {
            _Radius=this._linewidth*6;
            if(NeedArrow)
            {
                var angle:int =GetAngle();
                var centerX:int=_ToPoint.x-_Radius * Math.cos(angle *(Math.PI/180)) ;
                var centerY:int=_ToPoint.y+_Radius * Math.sin(angle *(Math.PI/180)) ;
                var topX:int=_ToPoint.x;
                var topY:int=_ToPoint.y;
                
                var leftX:int=centerX + _Radius * Math.cos((angle +120) *(Math.PI/180))  ;
                var leftY:int=centerY - _Radius * Math.sin((angle +120) *(Math.PI/180))  ;
                
                var rightX:int=centerX + _Radius * Math.cos((angle +240) *(Math.PI/180))  ;
                var rightY:int=centerY - _Radius * Math.sin((angle +240) *(Math.PI/180))  ;
                           
                drawUtil.getGraphics().lineStyle(1,_LineColor,1);
                drawUtil.getGraphics().beginFill(_LineColor,1);
                drawUtil.getGraphics().moveTo(topX,topY);
                drawUtil.getGraphics().lineTo(leftX,leftY);
                drawUtil.getGraphics().lineTo(centerX,centerY);
                drawUtil.getGraphics().lineTo(rightX,rightY);
                drawUtil.getGraphics().lineTo(topX,topY);
                drawUtil.getGraphics().endFill();
            }
        }

		
	    public function DrawDiamond():void{
	    	 //drawUtil.getGraphics().clear();
            drawUtil.getGraphics().lineStyle(1,_LineColor,1);
            //drawUtil.getGraphics().moveTo(_FromPoint.x,_FromPoint.y);
            //drawUtil.getGraphics().lineTo(_ToPoint.x,_ToPoint.y);
            _Radius=this._linewidth*8;
            if(NeedArrow)
            {
                var angle:int =GetKAngle();
                var t_left_x:int=_ToPoint.x-_Radius/2 * Math.cos((90-angle )*(Math.PI/180)) ;//left x
                var t_left_y:int=_ToPoint.y+_Radius/2 * Math.sin((90-angle) *(Math.PI/180)) ;//left y
                var t_right_x:int  =_ToPoint.x-_Radius/2 * Math.cos((90-angle-180 )*(Math.PI/180)) ;//right x
                var t_right_y:int  =_ToPoint.y+_Radius/2 * Math.sin((90-angle-180) *(Math.PI/180)) ;//right y
                
                var t_2_X:int      =_ToPoint.x-_Radius * Math.cos((-angle-180 )*(Math.PI/180)) ;//line2  x 
                var t_2_Y:int      =_ToPoint.y+_Radius * Math.sin((-angle-180) *(Math.PI/180)) ;//line2  y
                
                var t_m_x:int=(_ToPoint.x+t_2_X)/2;
                var t_m_y:int=(_ToPoint.y+t_2_Y)/2;
                
                var t2_left_x:int =t_m_x-_Radius/2 * Math.cos((90-angle )*(Math.PI/180)) ;//2 left x
                var t2_left_y:int =t_m_y+_Radius/2 * Math.sin((90-angle ) *(Math.PI/180)) ;//2 left y
                var t2_right_x:int=t_m_x-_Radius/2 * Math.cos((90-angle-180 )*(Math.PI/180)) ;//2 right x
                var t2_right_y:int=t_m_y+_Radius/2 * Math.sin((90-angle-180) *(Math.PI/180)) ;//2 right y
                
                
                var topX:int=_ToPoint.x ;
                var topY:int=_ToPoint.y  ;
                
                drawUtil.getGraphics().beginFill(_LineColor,1);                
                drawUtil.getGraphics().lineStyle(1,_LineColor,1);
             
                drawUtil.getGraphics().moveTo(_ToPoint.x,_ToPoint.y);//左点
                drawUtil.getGraphics().lineTo(t2_right_x,t2_right_y);
                drawUtil.getGraphics().lineTo(t_2_X,t_2_Y);
                drawUtil.getGraphics().lineTo(t2_left_x,t2_left_y);
                drawUtil.getGraphics().moveTo(_ToPoint.x,_ToPoint.y);  
                drawUtil.getGraphics().endFill();
	    	}
	  
	   }
	
	   public function DrawOval():void{
	    	 //drawUtil.getGraphics().clear();
            drawUtil.getGraphics().lineStyle(1,_LineColor,1);
            //drawUtil.getGraphics().moveTo(_FromPoint.x,_FromPoint.y);
            //drawUtil.getGraphics().lineTo(_ToPoint.x,_ToPoint.y);
             _Radius=this._linewidth*6;
            if(NeedArrow)
            {
               var angle:int =GetKAngle();
                var t_left_x:int=_ToPoint.x-_Radius/2 * Math.cos((90-angle )*(Math.PI/180)) ;//left x
                var t_left_y:int=_ToPoint.y+_Radius/2 * Math.sin((90-angle) *(Math.PI/180)) ;//left y
                var t_right_x:int  =_ToPoint.x-_Radius/2 * Math.cos((90-angle-180 )*(Math.PI/180)) ;//right x
                var t_right_y:int  =_ToPoint.y+_Radius/2 * Math.sin((90-angle-180) *(Math.PI/180)) ;//right y
                
                var t_2_X:int      =_ToPoint.x-_Radius * Math.cos((-angle-180 )*(Math.PI/180)) ;//line2  x 
                var t_2_Y:int      =_ToPoint.y+_Radius * Math.sin((-angle-180) *(Math.PI/180)) ;//line2  y
                
                var t_m_x:int=(_ToPoint.x+t_2_X)/2;
                var t_m_y:int=(_ToPoint.y+t_2_Y)/2;
                
                var t2_left_x:int =t_m_x-_Radius/2 * Math.cos((90-angle )*(Math.PI/180)) ;//2 left x
                var t2_left_y:int =t_m_y+_Radius/2 * Math.sin((90-angle ) *(Math.PI/180)) ;//2 left y
                var t2_right_x:int=t_m_x-_Radius/2 * Math.cos((90-angle-180 )*(Math.PI/180)) ;//2 right x
                var t2_right_y:int=t_m_y+_Radius/2 * Math.sin((90-angle-180) *(Math.PI/180)) ;//2 right y
                
                
                var topX:int=_ToPoint.x ;
                var topY:int=_ToPoint.y  ;
                
                drawUtil.getGraphics().beginFill(_LineColor,1);                
                //drawUtil.getGraphics().lineStyle(1,_LineColor,1);
            
                //drawUtil.getGraphics().moveTo(_ToPoint.x,_ToPoint.y);//左点
                //drawUtil.getGraphics().curveTo(t2_right_x,t2_right_y,0,0);
                //drawUtil.getGraphics().curveTo(t_2_X,t_2_Y,0,0);
                //drawUtil.getGraphics().curveTo(t2_left_x,t2_left_y,0,0);
            
                //drawUtil.getGraphics().beginFill(_LineColor,1);                
                //drawUtil.getGraphics().lineStyle(1,_LineColor,1);
                drawUtil.getGraphics().drawCircle(t_m_x,t_m_y,_Radius/2);
                drawUtil.getGraphics().endFill();
	    	}
	  
	   }
	
	  
	
		//绘箭头open
        public function DrawOpen():void
        {
            //drawUtil.getGraphics().lineStyle(1,_LineColor,1);
            _Radius=this._linewidth*12;
            if(NeedArrow)
            {
                var angle:int =GetAngle();
                var centerX:int=_ToPoint.x-_Radius * Math.cos(angle *(Math.PI/180)) ;
                var centerY:int=_ToPoint.y+_Radius * Math.sin(angle *(Math.PI/180)) ;
                var topX:int=_ToPoint.x ;
                var topY:int=_ToPoint.y  ;
                
               	
                
                var leftX:int=centerX + _Radius * Math.cos((angle +120+30) *(Math.PI/180))  ;
                var leftY:int=centerY - _Radius * Math.sin((angle +120+30) *(Math.PI/180))  ;
                
                var rightX:int=centerX + _Radius * Math.cos((angle +240-30) *(Math.PI/180))  ;
                var rightY:int=centerY - _Radius * Math.sin((angle +240-30) *(Math.PI/180))  ;
                
                leftX=topX + _Radius * Math.cos((angle +120+30) *(Math.PI/180))  ;
                leftY=topY - _Radius * Math.sin((angle +120+30) *(Math.PI/180))  ;
                
                rightX=topX + _Radius * Math.cos((angle +240-30) *(Math.PI/180))  ;
                rightY=topY - _Radius * Math.sin((angle +240-30) *(Math.PI/180))  ;
                
                var centerX2:int=_ToPoint.x-_Radius/2 * Math.cos(angle *(Math.PI/180)) ;
                var centerY2:int=_ToPoint.y+_Radius/2 * Math.sin(angle *(Math.PI/180)) ;
                var leftX2:int=centerX2 + _Radius/2 * Math.cos((angle +120+30) *(Math.PI/180))  ;
                var leftY2:int=centerY2 - _Radius/2 * Math.sin((angle +120+30) *(Math.PI/180))  ;
                
                var rightX2:int=centerX2 + _Radius/2 * Math.cos((angle +240-30) *(Math.PI/180))  ;
                var rightY2:int=centerY2 - _Radius/2 * Math.sin((angle +240-30) *(Math.PI/180))  ;
                
                drawUtil.getGraphics().beginFill(_LineColor,1);                
               // drawUtil.getGraphics().lineStyle(1,_LineColor,1);
                //drawUtil.getGraphics().drawCircle(centerX,centerY,1);
 /*               drawUtil.getGraphics().drawCircle(centerX2,centerY2,1);
                drawUtil.getGraphics().drawCircle(leftX2,leftY2,1);
                drawUtil.getGraphics().drawCircle(rightX2,rightY2,1);
                drawUtil.getGraphics().drawCircle(leftX,leftY,1);
                drawUtil.getGraphics().drawCircle(rightX,rightY,1);
 */               
                drawUtil.getGraphics().moveTo(topX,topY);
                //drawUtil.getGraphics().lineTo(rightX,rightY);  
                //drawUtil.getGraphics().lineTo(rightX2,rightY2);   
                
                var c_rx:int=(rightX+rightX2)/2 ;
                var c_ry:int=(rightY+rightY2)/2 ;
                var c_r:int=Math.pow(Math.pow(Math.abs(rightX-rightX2),2)+Math.pow(Math.abs(rightY-rightY2),2),0.5)/2;
                 //drawUtil.getGraphics().moveTo(rightX,rightY);
                // drawUtil.getGraphics().curveTo(c_rx,c_ry,rightX2,rightY2);
                
                
                drawUtil.getGraphics().lineTo(rightX,rightY);
                drawUtil.getGraphics().lineTo(rightX2,rightY2);                 
                drawUtil.getGraphics().lineTo(centerX2,centerY2);
                drawUtil.getGraphics().lineTo(leftX2,leftY2);
                drawUtil.getGraphics().lineTo(leftX,leftY);
                drawUtil.getGraphics().lineTo(topX,topY);
               // drawUtil.getGraphics().lineTo(topX,topY);
              	 drawUtil.getGraphics().endFill();
                
            }
        }
	
	//绘Chevron箭头
        public function DrawChevron():void
        {
            drawUtil.getGraphics().lineStyle(1,_LineColor,1);
            _Radius=this._linewidth*6;
            if(NeedArrow)
            {
                var angle:int =GetAngle();
                var centerX:int=_ToPoint.x-_Radius * Math.cos(angle *(Math.PI/180)) ;
                var centerY:int=_ToPoint.y+_Radius * Math.sin(angle *(Math.PI/180)) ;
                var topX:int=_ToPoint.x ;
                var topY:int=_ToPoint.y  ;
                
                var leftX:int=centerX + _Radius * Math.cos((angle +120) *(Math.PI/180))  ;
                var leftY:int=centerY - _Radius * Math.sin((angle +120) *(Math.PI/180))  ;
                
                var rightX:int=centerX + _Radius * Math.cos((angle +240) *(Math.PI/180))  ;
                var rightY:int=centerY - _Radius * Math.sin((angle +240) *(Math.PI/180))  ;
                
                //drawUtil.getGraphics().beginFill(_LineColor,1);                
                drawUtil.getGraphics().lineStyle(1,_LineColor,1);                
                drawUtil.getGraphics().moveTo(topX,topY);
                /*
                drawUtil.getGraphics().lineTo(leftX,leftY);
                drawUtil.getGraphics().lineTo(centerX,centerY);
                drawUtil.getGraphics().lineTo(rightX,rightY);
                */
                
                drawUtil.getGraphics().curveTo(centerX,centerY,leftX,leftY);
                drawUtil.getGraphics().moveTo(topX,topY);
                drawUtil.getGraphics().curveTo(centerX,centerY,rightX,rightY);
                //drawUtil.getGraphics().drawCircle(centerX,centerY,1);
                drawUtil.getGraphics().endFill();
                
            }
        }
        
         //绘Chevron箭头
        public function DrawDoubleChevron():void
        {
            //drawUtil.getGraphics().lineStyle(1,_LineColor,1);
            _Radius=this._linewidth*9;
            if(NeedArrow)
            {
                var angle:int =GetAngle();
                var centerX:int=_ToPoint.x-_Radius * Math.cos(angle *(Math.PI/180)) ;
                var centerY:int=_ToPoint.y+_Radius * Math.sin(angle *(Math.PI/180)) ;
                var topX:int=_ToPoint.x ;
                var topY:int=_ToPoint.y  ;
                
                var leftX:int=centerX + _Radius * Math.cos((angle +120) *(Math.PI/180))  ;
                var leftY:int=centerY - _Radius * Math.sin((angle +120) *(Math.PI/180))  ;
                
                var rightX:int=centerX + _Radius * Math.cos((angle +240) *(Math.PI/180))  ;
                var rightY:int=centerY - _Radius * Math.sin((angle +240) *(Math.PI/180))  ;
                
                var p2x:int=_ToPoint.x-_Radius *0.618 * Math.cos(angle *(Math.PI/180)) ;
                var p2y:int=_ToPoint.y+_Radius *0.618 * Math.sin(angle *(Math.PI/180)) ;
                drawUtil.getGraphics().lineStyle(0,0,0);
                drawUtil.getGraphics().beginFill(_LineColor,1);                
                //drawUtil.getGraphics().lineStyle(1,_LineColor,1);                
                drawUtil.getGraphics().moveTo(topX,topY);               //p0
                /*
 				drawUtil.getGraphics().curveTo(centerX,centerY,leftX,leftY);   //p1,p2
                drawUtil.getGraphics().moveTo(topX,topY);                      //p0
                drawUtil.getGraphics().curveTo(centerX,centerY,rightX,rightY); //p1,p3
                
                drawUtil.getGraphics().moveTo(topX,topY);
                drawUtil.getGraphics().lineTo(rightX,rightY);
                drawUtil.getGraphics().lineTo(centerX,centerY);
                drawUtil.getGraphics().lineTo(leftX,leftY);
                */
                
                drawUtil.getGraphics().curveTo(p2x,p2y,leftX,leftY);   //p1,p2
                drawUtil.getGraphics().moveTo(topX,topY);               //p0
                drawUtil.getGraphics().curveTo(p2x,p2y,rightX,rightY); //p1,p3
                
                drawUtil.getGraphics().moveTo(topX,topY);     //p0
                drawUtil.getGraphics().lineTo(leftX,leftY); //p2
                drawUtil.getGraphics().lineTo(p2x,p2y);//p1
                drawUtil.getGraphics().lineTo(rightX,rightY);    //p3
                
                drawUtil.getGraphics().moveTo(leftX,leftY);               //p2
                drawUtil.getGraphics().curveTo(p2x,p2y,rightX,rightY); //p1,p3
                drawUtil.getGraphics().lineTo(leftX,leftY); //p2
                drawUtil.getGraphics().lineTo(p2x,p2y);     //p1
                drawUtil.getGraphics().lineTo(rightX,rightY);    //p3
                drawUtil.getGraphics().endFill();
                //drawUtil.getGraphics().drawCircle(centerX,centerY,1);
                
            }
        }
	}
}