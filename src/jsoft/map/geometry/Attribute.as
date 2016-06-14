package jsoft.map.geometry
{
	public class Attribute
	{
		private var name:String = "";
		private var cname:String = "";
		private var value:String = "";
		
		public function Attribute()
		{
		}
		
		public function getName():String 
		{
			return name;
		}
		
		public function setName(name:String):void
		{
			this.name = name;
		}
		
		public function getCName():String 
		{
			return cname;
		}
		
		public function setCName(cname:String):void
		{
			this.cname = cname;
		}
		
		public function getValue():String 
		{
			return value;
		}
		
		public function setValue(value:String):void
		{
			this.value = value;
		}
		
		public function clone() : Attribute {
			var attr:Attribute = new Attribute();
			attr.name = name;
			attr.cname = cname;
			attr.value = value;
			return attr;
		}

	}
}