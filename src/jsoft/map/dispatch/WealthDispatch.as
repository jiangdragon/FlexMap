package jsoft.map.dispatch
{
	import jsoft.map.feature.wealth.WealthQuery;
	
	
	public class WealthDispatch implements Dispatcher
	{
		public function WealthDispatch()
		{
		}

		public function sendMessage(param:DispatchParam):void
		{
			//wealth
			if("saveWealth" == param.Type) {
				querySaveWealth(param.vstr,param.vstr,param.vint,param.vstr);
				return;
			}
			if("findWealthList" == param.Type) {
				queryFindWealthList(param.vstr,param.vstr);
				return;
			}
			if("deleteWealth" == param.Type) {
				queryDeleteWealth(param.vstr);
				return;
			}
			//LayerRK
			if("addRK" == param.Type){
				queryAddRK(param.vstr,param.vstr,param.vstr,param.vnum,param.vnum);
				return;
			}
			if("editRK" == param.Type){
				queryEditRK(param.vstr,param.vstr,param.vstr,param.vstr,param.vnum,param.vnum);
				return;
			}
			if("delRK" == param.Type){
				queryDelRK(param.vstr);
				return;
			}
			//LayerSP
			if("addSP" == param.Type){
				queryAddSP(param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vnum,param.vnum);
				return;
			}
			if("editSP" == param.Type){
				queryEditSP(param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vstr,param.vnum,param.vnum);
				return;
			}
			if("delSP" == param.Type){
				queryDelSP(param.vstr);
				return;
			}
			
		}
		
		public function getMessage(param:DispatchParam):String
		{
			return null;
		}
		
		private function querySaveWealth(troubleId:String,wealthName:String,count:int,catalogId:String):void{
			var query:WealthQuery = new WealthQuery();
			query.saveWealth(troubleId,wealthName,count,catalogId);
		}
		private function queryFindWealthList(troubleId:String,layerName:String):void{
			var query:WealthQuery = new WealthQuery();
			query.findWealthList(troubleId,layerName);
		}
		private function queryDeleteWealth(id:String):void{
			var query:WealthQuery = new WealthQuery();
			query.deleteWealth(id);
		}
		//LayerRK
		private function queryAddRK(mc:String,bh:String,qy:String,x:Number,y:Number):void{
			var query:WealthQuery = new WealthQuery();
			query.addRK(mc,bh,qy,x,y);
			
		}
		private function queryEditRK(id:String,mc:String,bh:String,qy:String,x:Number,y:Number):void{
			var query:WealthQuery = new WealthQuery();
			query.editRK(id,mc,bh,qy,x,y);
		}
		private function queryDelRK(id:String):void{
			var query:WealthQuery = new WealthQuery;
			query.delRK(id);
		}
		//LayerSP
		private function queryAddSP(mc:String,bh:String,dw:String,qy:String,user:String,pass:String,ip:String,channel:String,x:Number,y:Number):void{
			var query:WealthQuery = new WealthQuery();
			query.addSP(mc,bh,dw,qy,user,pass,ip,channel,x,y);
		}
		private function queryEditSP(id:String,mc:String,bh:String,dw:String,qy:String,user:String,pass:String,ip:String,channel:String,x:Number,y:Number):void{
			var query:WealthQuery = new WealthQuery();
			query.editSP(id,mc,bh,dw,qy,user,pass,ip,channel,x,y);
		}
		private function queryDelSP(id:String):void{
			var query:WealthQuery = new WealthQuery();
			query.delSP(id);
		}
	}
}