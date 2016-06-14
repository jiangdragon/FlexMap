package jsoft.map.image
{
	public class ImagePool
	{
		private static var pool:ImagePool = new ImagePool();
		private var loaders:Array = new Array();
		
		public function ImagePool() {
		}
		
		public function getImage(imageURL:String,recv:ImageRecv):void {
			var loader:ImageLoader = loaders[imageURL];
			if(loader==null) {
				loader = new ImageLoader(imageURL);
				loader.addDataRecv(recv);
				loaders[imageURL] = loader;
			} else {
				loader.addDataRecv(recv);
			}
		}


	}
}