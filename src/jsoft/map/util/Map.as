package jsoft.map.util
{
	public class Map
	{
		private var _size:int = 0;
		private var key:Array = null;
		private var value:Array = null;
		
		public function Map()
		{
		}
		/**
		 * 返回size大小.
		 * @return the size.
		 */
		public function get size():int{
			return _size;
		}
		/**
		 * return true if this map contains no
		 * key-value mappings.
		 * @return true if this map contains no
		 *         key-value mappings.
		 */
		public function isEmpty():Boolean{
			return _size == 0;
		}
		/**
		 * 据key取value.
		 * @param key a string.
		 * @return the value of key-value mappings.
		 */
		public function getVlaueByKey(_key:String):String{
			var hash:int = (_key == null || key == null) ? -1 : key.indexOf(_key);
			if(hash != -1){
				return value[hash];
			}
			return null;
		}
		/**
		 * put a key-value mapping into this map.
		 * @param key a string.
		 * @param value a string.
		 */
		public function put(_key:String,_value:String):Boolean{
			if(_key == null || _value == null){
				return false;
			}
			if(key == null && value == null){
				key = new Array();
				value = new Array();
			}
			var hash:int = key.indexOf(_key);
			if(hash != -1){
				remove(_key);
			}
			_size++;
			addEntry(_key,_value,key.length);
			return true;
		}
		/**
		 * return true if this map contains a mapping for the key.
		 * @param key the key for this map.
		 * @return true if this map contains a mapping for the key.
		 */
		public function containsKey(_key:String):Boolean{
			var hash:int = (_key == null || key == null) ? -1 : key.indexOf(_key);
			return (hash == -1) ? false : true;
		}
		/**
		 * remove all the mappings for this map.
		 * the map will be empty after this call returns.
		 */
		public function clear():void{
			_size = 0;
			key = null;
			value = null;
		}
		/**
		 * add a new mapping with the key.
		 */
		private function addEntry(_key:String,_value:String,bucketIndex:int):void{
			key[bucketIndex] = _key;
			value[bucketIndex] = _value;
		}
		/**
		 * remove a mapping with the key.
		 * @param key the string.
		 * @return null if the key is null or
		 *         contains no mapping.
		 */
		public function remove(_key:String):String{
			var hash:int = (_key == null || key == null) ? -1 : key.indexOf(_key);
			if(hash != -1){
				var ret:String = key.splice(hash,1);
				value.splice(hash,1);
				_size--;
				return ret;
			}
			return null;
		}
		/**
		 * return if this map contains one or more
		 * value for specified value.
		 * @param value will be in this map test.
		 * @return true if this map contains one
		 *         or more value for specified value.
		 */
		public function containsValue(_value:String):Boolean{
			var hash:int = (_value == null || key == null) ? -1 : value.indexOf(_value);
			return (hash == -1) ? false : true;
		}
		/**
		 * return a string for this map.
		 * @return a string for this map.
		 */
		public function toString():String{
			var len:int = (key == null) ? 0 : key.length;
			var ret:String = "";
			for(var i:int = 0;i < len;i++){
				if(i != len - 1)
					ret += key[i] + "=" + value[i] + ",";
				else
					ret += key[i] + "=" + value[i];
			}
			return ret; 
		}
	}
}