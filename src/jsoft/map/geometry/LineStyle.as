package jsoft.map.geometry
{
	public class LineStyle extends Object
	{
		public static const METERS:String = "esriMeters";
			/********箭头的样式*********/
		public static const  ARROW_NO:String  = "none";
		public static const  ARROW_BLOCK:String   = "block";
		public static const  ARROW_CLASSIC:String  ="classic";
		public static const  ARROW_DIAMOND:String  ="diamond";
		public static const  ARROW_OVAL:String  ="oval";
		public static const  ARROW_OPEN:String  ="open";
		public static const  ARROW_CHEVRON:String  ="chevron";
		public static const  ARROW_DOUBLECHEVRON:String  ="doublechevron";
		
		public static const  ARROW_WIDTH_NARROW:String  ="narrow";
		public static const  ARROW_WIDTH_MEDIUM:String  ="medium";
		public static const  ARROW_WIDTH_WIDE:String  ="wide";
		
		public static const  ARROW_LENGTH_SHORT:String  ="short";
		public static const  ARROW_LENGTH_MEDIUM:String  ="medium";
		public static const  ARROW_LENGTH_LONG:String  ="long";
		
		/********线体的样式*********/
		public static const  DASHSTYLE_SOLID:String   = "solid";
		public static const  DASHSTYLE_DOT:String   = "dot";
		public static const  DASHSTYLE_DASH:String   = "dash";
		public static const  DASHSTYLE_DASHDOT:String   = "dashdot";
		public static const  DASHSTYLE_LONGDASH:String   = "longdash";
		public static const  DASHSTYLE_LONGDASHDOT:String   = "longdashdot";
		public static const  DASHSTYLE_LONGDASHDOTDOT:String   = "longdashdotdot";
		public static const  DASHSTYLE_SHORTDOT :String  = "shortdot";
		public static const  DASHSTYLE_SHORTDASH :String  = "shortdash";
		public static const  DASHSTYLE_SHORTDASHDOT:String   = "shortdashdot";
		public static const  DASHSTYLE_SHORTDASHDOTDOT:String   = "shortdashdotdot";
		 
		public function LineStyle()
		{
			super();
		}
		
	}
}