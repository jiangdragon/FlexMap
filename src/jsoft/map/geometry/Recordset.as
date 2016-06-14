package jsoft.map.geometry
{
	public class Recordset
	{
		private var record:Array = new Array();
		
		public function Recordset()	{
		}
		
		public function addRecord(record:Record):void {
			this.record[this.record.length] = record;
		}
		
		public function addRecords(record:Array):void {
			for(var i:int=0;i<record.length;i++) {
				this.record[this.record.length] = record[i];
			}
		}
		
		public function getRecord(pos:int):Record {
			return record[pos];
		}
		
		public function getRecordLength():int {
			return record.length;
		}
	}
}