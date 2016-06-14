package jsoft.map.feature
{
	public class RequestParam
	{
		private var name:String;
		private var value:String;
		
		public function RequestParam(name:String="",value:String="") {
			this.name = name;
			this.value = value;
		}
		
		public function getName():String {
			return name;
		}
		
		public function setName(name:String):void {
			this.name = name;
		}
		
		public function getValue():String {
			return value;
		}
		
		public function setValue(value:String):void {
			this.value = value;
		}
		
		public function setAryValue(ary:Array):void {
			var theString:String = "";
			for(var i:int=0;i<ary.length;i++) {
				if(i>0) {
					theString += "," + ary[i];
				} else {
					theString += "" + ary[i];
				}
			}
			this.value = theString;
		}
		
		public function getParam():String {
			return name + "=" + value;
		}
		
		public function setParam(name:String,value:String):void {
			this.name = name;
			this.value = value;
		}

	}
}