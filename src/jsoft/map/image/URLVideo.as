package jsoft.map.image
{
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	
	import mx.core.UIComponent;
	
	public class URLVideo extends UIComponent {
		private var videoURL:String;
		private var netConnection:NetConnection=null;
		private var netStream:NetStream=null;
		private var video:Video=null;
		private var meta:Object=null;
		private var orgWidth:int=-1;
		private var orgHeight:int=-1;
		private var totalTime:Number = 0;
		private var autoPlay:Boolean=false;
		private var autoReplay:Boolean=false;
		// 0代表未打开，1代表播放，2代表暂停，3代表停止
		private var playStatus:int=0;
		
		public function URLVideo() {
		}
		
		public function connect(url:String) : void {
			videoURL = url;
			var nsClient:Object = {};
			nsClient.onMetaData = ns_onMetaData;
			nsClient.onCuePoint = ns_onCuePoint; 
            netConnection = new NetConnection();
            netConnection.connect(null);
            netStream = new NetStream(netConnection);
            netStream.addEventListener(NetStatusEvent.NET_STATUS, netStatusEvent);
            netStream.play(url);
            netStream.client = nsClient;
            video = new Video();
            video.attachNetStream(netStream);
            addChild(video);
        }
        // 播放
        public function play() : void {
        	netStream.resume();
        	playStatus=1;
        }
        // 暂停
        public function pause() : void {
        	netStream.pause();
        	playStatus=2;
        }
        // 重播
        public function rewind() : void {
        	netStream.seek(0);
        }
        // 切换到指定时间
        public function seed(time:Number) : void {
        	netStream.seek(time);
        }
        // 获取当前的播放进度，如果播放实时视频流，则返回0
        public function getSeed() : Number {
        	return netStream.time;
        }
        // 获取当前的播放进度
        public function getSeedText() : String {
        	var text:String = formatTime(netStream.time) + "/" + formatTime(totalTime);
        	return text;
        }
        // 判断是否处于播放状态
        public function isPlay() : Boolean {
        	return playStatus == 1;
        }
        // 判断是否处于终止状态
        public function isPause() : Boolean {
        	return playStatus == 2;
        }
        // 判断是否处于终止状态
        public function isStop() : Boolean {
        	if(totalTime != 0 && getSeed() >= totalTime) {
        		playStatus=3;
        	}
        	return playStatus == 3;
        }
        // 判断是否处于关闭状态
        public function isClose() : Boolean {
        	if(video == null) {
        		return true;
        	}
        	return false;
        }
        public function isAutoPlay() : Boolean {
        	return autoPlay;
        }
        public function setAutoPlay(autoPlay:Boolean) : void {
        	this.autoPlay = autoPlay;
        }
        public function isAutoReplay() : Boolean {
        	return autoReplay;
        }
        public function setAutoReplay(autoReplay:Boolean) : void {
        	this.autoReplay = autoReplay;
        }
        public function stop() : void {
        	rewind();
        	pause();
        	playStatus=3;
        }
        // 获取当前的音量
        public function getVolumn() : Number {
        	var volumn:Number = netStream.soundTransform.volume;
        	return volumn;
        }
        // 设置当前的音量,范围：1-10
        public function setVolumn(volumn:Number) : void {
        	var soundTransform:SoundTransform = new SoundTransform();
        	soundTransform.volume = volumn;
        	netStream.soundTransform = soundTransform;
        }
        // 关闭
        public function close() : void {
        	video.clear();
        	netStream.close();
        	netConnection.close();
        	video = null;
        	netStream = null;
        	netConnection = null;
        	playStatus=0;
        }
        // 秒转成“分:秒”格式
        public function formatTime(sec:Number) : String {
        	var minutes:int = Math.floor(sec/60);
        	var seconds:int = Math.floor(sec-minutes*60);
        	var secondsString:String = seconds.toString();
        	if(seconds < 10){
        		secondsString = "0" + secondsString;
        	}
        	return minutes + ":" + secondsString;
        }
        
        public function getOrgWidth() : int {
        	return orgWidth;
        }
        
        public function getOrgHeight() : int {
        	return orgHeight;
        }
        
        public function getTotalTime() : Number {
        	return totalTime;
        }
        
        public function setWidth(width:int) : void {
        	if(width == -1) {
        		width = orgWidth;
        	}
        	this.width = width;
        	video.width = width;
        }
        
        public function setHeight(height:int) : void {
        	if(height == -1) {
        		height = orgHeight;
        	}
        	this.height = height;
        	video.height = height;
        }
        
        public function setPercentWidth(width:int) : void {
        	if(width == -1) {
        		width = orgWidth;
        	}
        	this.percentWidth = width;
        	video.width = width;
        }
        
        public function setPercentHeight(height:int) : void {
        	if(height == -1) {
        		height = orgHeight;
        	}
        	this.percentHeight = height;
        	video.height = height;
        }
        private function netStatusEvent(event:NetStatusEvent):void {
        	var netStatusCache:String = "";
			if(netStatusCache != event.info.code){
				trace(event.info.code);
				//AppContext.getAppUtil().alert(event.info.code);
				switch (event.info.code) {
					case "NetStream.Play.Start" :
						//playingBarTimer.start();
						break;
					case "NetStream.Buffer.Empty" :
						break;
					case "NetStream.Buffer.Full" :
						break;
					case "NetStream.Buffer.Flush" :
						//bufferFlush = true;
						break;
					case "NetStream.Seek.Notify" :
						//invalidTime = false;				
						break;
					case "NetStream.Seek.InvalidTime" :
						//bufferFlush = false;
						//invalidTime = true;						
						break;
					case "NetStream.Play.Stop":
						//if(bufferFlush) STOP();			
						break;
					case "NetStream.Play.StreamNotFound" :
						AppContext.getAppUtil().alert("没有找到服务器视频！服务器视频地址为：" + videoURL);			
						break;
					default:
						break;
				}
				netStatusCache = event.info.code;
			}
		}
        private function ns_onMetaData(item:Object):void {
			//AppContext.getAppUtil().alert("ns_onMetaData item="+item);
			meta = item;
            orgWidth = item.width;
            orgHeight = item.height;
            totalTime = item.duration;
            addEventListener(Event.ENTER_FRAME,enterFrameHandler);
            if(autoPlay) {
            	playStatus=1;
            } else {
            	netStream.pause();
            	playStatus=3;
            }
            //AppContext.getAppUtil().alert("ns_onMetaData.totalTime="+totalTime);
            // Resize Video object to same size as meta data.
            //video.width = item.width;
            //video.height = item.height;
            // Resize UIComponent to same size as Video object.
            //width = video.width;
            //height = video.height;
         }
         private function ns_onCuePoint(item:Object):void {
             //AppContext.getAppUtil().alert("cue");
         }
         private function enterFrameHandler(event:Event) : void { //在该事件中不断更新进度条的位置
         	//AppContext.getAppUtil().alert("enterFrameHandler");
         	if(isClose()) {
         		return;
         	}
         	if(autoReplay && isStop()) {
         		//AppContext.getAppUtil().alert("enterFrameHandler autoReplay");
         		rewind();
         		play();
         	}
         }
	}
}