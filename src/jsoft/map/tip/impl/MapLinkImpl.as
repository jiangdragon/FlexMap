package jsoft.map.tip.impl
{
	import flash.external.ExternalInterface;
	
	import jsoft.map.tip.MapLinkTip;
	//点击执行url链接
	public class MapLinkImpl extends BaseMapTip implements MapLinkTip
	{
		private var link:String = "";
		private var linkWinParam:String = "";
		private var type:int=1;
		
		public function MapLinkImpl()
		{
		}
		
		public function getType():int{
			return type;
		}
		public function setType(type:int):void{
			this.type=type;
		}
		// 获取提示的标题信息
		public function getLink() : String{
			return link;
		}
		
		// 设置提示的标题信息
		public function setLink(link:String) : void{
			this.link=link;
		}
		// 获取提示窗口显示参数
		public function getLinkWinParam() : String{
			return linkWinParam;
		}
		
		// 设置提示窗口显示参数
		public function setLinkWinParam(linkWinParam:String) : void{
			this.linkWinParam=linkWinParam;
		}

		// 在指定位置显示提示信息
		public override function showTip(x:int, y:int):void {
			showClick();
		}

		// 在指定位置显示信息提示框，并在鼠标移开后指定的空闲时间后关闭提示信息
		public override function showTipEx(x:int, y:int, timeOut:int):void {
			showClick();
		}
		public function showClick() : void {
			if(type==1){
				ExternalInterface.call("fMap.callback",link);
			}else{
				ExternalInterface.call("fMap.openWindow","",link,linkWinParam);
			}
		}
	}
}