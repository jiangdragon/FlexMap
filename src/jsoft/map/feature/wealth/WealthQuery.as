package jsoft.map.feature.wealth
{
	import flash.external.ExternalInterface;
	
	import jsoft.map.feature.FeatureCallBack;
	import jsoft.map.feature.FeatureServer;
	import jsoft.map.feature.query.XMLUtil;
	

	public class WealthQuery implements FeatureCallBack
	{
		private var param:String;
		private var featureServer:FeatureServer;
		public function WealthQuery()
		{
		}
		//wealth
		public function saveWealth(troubleId:String,wealthName:String,count:int,catalogId:String):void{
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addStrParam("troubleId",troubleId);
			featureServer.addStrParam("wealthName",wealthName);
			featureServer.addIntParam("count",count);
			featureServer.addStrParam("catalogId",catalogId);
			featureServer.processMapEvent("saveWealth");
		}
		public function findWealthList(troubleId:String,layerName:String):void{
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addStrParam("troubleId",troubleId);
			featureServer.addStrParam("layerName",layerName);
			featureServer.processMapEvent("findWealthList");
		}
		public function deleteWealth(id:String):void{
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addStrParam("id",id);
			featureServer.processMapEvent("deleteWealth");
		}
		
		//Rk
		public function addRK(mc:String,bh:String,qy:String,x:Number,y:Number):void{
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addStrParam("mc",mc);
			featureServer.addStrParam("bh",bh);
			featureServer.addStrParam("qy",qy);
			featureServer.addNumParam("x",x);
			featureServer.addNumParam("y",y);
			featureServer.processMapEvent("addRK");
		}
		public function editRK(id:String,mc:String,bh:String,qy:String,x:Number,y:Number):void{
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addStrParam("id",id);
			featureServer.addStrParam("mc",mc);
			featureServer.addStrParam("bh",bh);
			featureServer.addStrParam("qy",qy);
			featureServer.addNumParam("x",x);
			featureServer.addNumParam("y",y);
			featureServer.processMapEvent("editRK");
		}
		public function delRK(id:String):void{
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addStrParam("id",id);
			featureServer.processMapEvent("delRK");
		}
		//SP
		public function addSP(mc:String,bh:String,dw:String,qy:String,user:String,pass:String,ip:String,channel:String,x:Number,y:Number):void{
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addStrParam("mc",mc);
			featureServer.addStrParam("bh",bh);
			featureServer.addStrParam("dw",dw);
			featureServer.addStrParam("qy",qy);
			featureServer.addStrParam("user",user);
			featureServer.addStrParam("pass",pass);
			featureServer.addStrParam("ip",ip);
			featureServer.addStrParam("channel",channel);
			featureServer.addNumParam("x",x);
			featureServer.addNumParam("y",y);
			featureServer.processMapEvent("addSP");
		}
		public function editSP(id:String,mc:String,bh:String,dw:String,qy:String,user:String,pass:String,ip:String,channel:String,x:Number,y:Number):void{
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addStrParam("id",id);
			featureServer.addStrParam("mc",mc);
			featureServer.addStrParam("bh",bh);
			featureServer.addStrParam("dw",dw);
			featureServer.addStrParam("qy",qy);
			featureServer.addStrParam("user",user);
			featureServer.addStrParam("pass",pass);
			featureServer.addStrParam("ip",ip);
			featureServer.addStrParam("channel",channel);
			featureServer.addNumParam("x",x);
			featureServer.addNumParam("y",y);
			featureServer.processMapEvent("editSP");
		
		}
		public function delSP(id:String):void{
			featureServer = new FeatureServer();
			featureServer.setFeatureCallBack(this);
			featureServer.setQueryMode("1");
			featureServer.addStrParam("id",id);
			featureServer.processMapEvent("delSP");
		}
		
		
		public function onResult(xml:XML):void
		{
			var js:String = new XMLUtil(xml).toJS();
			ExternalInterface.call("fMap.getFWealth().wealthBack",js);
		}
		
		public function onResultStr(result:String):void
		{
			ExternalInterface.call("fMap.getFWealth().wealthBack",result);
		}
		
		public function onError():void
		{
			AppContext.getAppUtil().alert("Cannot execute wealth("+featureServer.getServer()+"),param="+param);
		}
		
	}
}