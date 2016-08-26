package controller
{
	
	public class AppSetting
	{
		import util.LogUtil;
		import conf.AppConfig;
		//PersistenceManagerFactory, reference : https://flex.apache.org/asdoc/spark/managers/PersistenceManager.html
		import spark.managers.PersistenceManager;

		//Function Key
		public var LOAD_AUTH_SERVER_URL:String = new String("Load_Auth_Server_URL");
		public var LOAD_REALTIME_SERVER_URL:String = new String("Load_Realtime_Server_URL");
		public var LOAD_HOST_AND_RTMPSERVER_URL:String = new String("Load_Host_And_RtmpServer_URL");
		public var LOAD_SIP_SERVER_URL:String = new String("Load_SIP_Server_URL");

		private static var persistenceManager:PersistenceManager = new PersistenceManager();
		private static var instance:AppSetting;

		private var _changed:Boolean;
		private var _protocol:String;
		private var _contactlist:String;
		private var _realtime:String;
		private var _meet:String;
		private var _sip:String;

		//Constructor AppSetting , default changed is false.
		public function AppSetting(changed:Boolean = false, protocol:String = null, contactlist:String = null, realtime:String = null, meet:String = null, sip:String = null)
		{
			this._changed = changed;
			this._protocol = protocol;
			this._contactlist = contactlist;
			this._realtime = realtime;
			this._meet = meet;
			this._sip = sip;
		}

		//New this class
		public static function getInstance():AppSetting
		{
			if (instance == null)
				instance = new AppSetting();
			return instance;
		}

		public function get changed():Boolean
		{
			return _changed;
		}

		public function set changed(value:Boolean):void
		{
			_changed = value;
		}

		public function get protocol():String
		{
			if (_protocol != null)
			{
				return _protocol;

			}
			else
			{
				return "";
			}
		}

		public function set protocol(value:String):void
		{

			_protocol = value;

		}

		public function get contactlist():String
		{
			if (_contactlist != null)
			{
				return _contactlist;
			}
			else
			{
				return "";
			}
		}

		public function set contactlist(value:String):void
		{

			_contactlist = value;

		}

		public function get realtime():String
		{
			if (_realtime != null)
			{
				return _realtime;
			}
			else
			{
				return "";
			}
		}

		public function set realtime(value:String):void
		{

			_realtime = value;

		}

		public function get meet():String
		{
			if (_meet != null)
			{
				return _meet;
			}
			else
			{
				return "";
			}
		}

		public function set meet(value:String):void
		{
			_meet = value;
		}

		public function get sip():String
		{
			if (_sip != null)
			{
				return _sip;
			}
			else
			{
				return "";
			}
		}

		public function set sip(value:String):void
		{
			_sip = value;
		}

		//save Info
		public function saveSettingDataToLocal():void
		{
			persistenceManager.setProperty(AppConfig.APP_SETTING_INFO_KEY, this);
		}

		//load info
		public function loadLocalSettingData():void
		{
			LogUtil.debug("load setting data", "AppSetting");
			try
			{
				if (persistenceManager.load())
				{

					var settingDataObj:Object = persistenceManager.getProperty(AppConfig.APP_SETTING_INFO_KEY);
					if (settingDataObj != null)
					{
						LogUtil.debug("AppSetting has setting object", "AppSetting");
						changed = settingDataObj.changed;
						protocol = settingDataObj.protocol;
						contactlist = settingDataObj.contactlist;
						realtime = settingDataObj.realtime;
						meet = settingDataObj.meet;
						sip = settingDataObj.sip;
					}
					else
					{
						LogUtil.debug("User Do Not change SETTING DATA , so settingDataObj == null ", "AppSetting");
					}
				}
			}
			catch (e:Error)
			{
				LogUtil.error(e.name, "AppSetting");
				LogUtil.error(e.message, "AppSetting");
				LogUtil.error(e.getStackTrace(), "AppSetting");
			}
		}

		//load URL
		public function loadAppConfigURL(name:String):Array
		{
			LogUtil.debug("loadAppConfigURL", "AppSetting");
			return loadAppConfigInfo(name);
		}

		//change server IP
		public function changeServerIP():void
		{
			try
			{
				LogUtil.debug("Change AppConfig Server IP", "AppSetting");
				var smallProtocol:String = "";
				// assign value
				//contact list server
				if (protocol == "HTTP")
				{
					smallProtocol = "http://";
				}
				else
				{
					smallProtocol = "https://";
				}
				AppConfig.AUTH_SERVER = smallProtocol + contactlist;

				//realtime server
				AppConfig.REALTIME_SERVER = smallProtocol + realtime;

				//SIP server
				var sipsplit:Array = sip.split(":"); //xxx.xxx.xxx.xxx:oooo
				if (sipsplit[0] == "")
				{
					AppConfig.SIP_SERVER = "";
					AppConfig.SIP_SERVER_PORT = "";
				}
				else
				{
					AppConfig.SIP_SERVER = sipsplit[0];
					AppConfig.SIP_SERVER_PORT = sipsplit[1];
				}

				var search:Array = meet.split(":");
				AppConfig.RTMP_SERVER = search[0];
				AppConfig.HOST = search[0];
				AppConfig.HTTP_PORT = (search[1]) ? search[1] : "80";

				changeMeetModuleConnectAddress();
			}
			catch (e:Error)
			{
				LogUtil.error(e.name, "AppSetting");
				LogUtil.error(e.message, "AppSetting");
				LogUtil.error(e.getStackTrace(), "AppSetting");
			}

		}

		public function productionServer(psContactlist:String, psRealtime:String, psMeet:String, psSip:String):Array
		{
			LogUtil.debug("Checking Production Server Info", "AppSetting");
			//Contactlist Server
			var clServer:Array = loadAppConfigInfo(LOAD_AUTH_SERVER_URL);
			//realtime server
			var rlServer:Array = loadAppConfigInfo(LOAD_REALTIME_SERVER_URL);
			//meet server
			var hAndRServer:Array = loadAppConfigInfo(LOAD_HOST_AND_RTMPSERVER_URL);
			//SIP server always "" , sipAddress for temp data.
			var sServer:Array = loadAppConfigInfo(LOAD_SIP_SERVER_URL);
			var result:Array = new Array();
			
			if (psContactlist == clServer[1] && psRealtime == rlServer[1] && psMeet == hAndRServer[0] && psSip == sServer[0])
			{
				LogUtil.debug("It's Production Server.", "AppSetting");
				result = ["true", "false"];
				return result; // [0]=producttionServer , [1]=sip is not "".
			}
			else if (psContactlist == clServer[1] && psRealtime == rlServer[1] && psMeet == hAndRServer[0] && psSip == "")
			{
				LogUtil.debug("It's Production Server , but sip server need assign again.", "AppSetting");
				result = ["true", sServer[0]]; // [0]=producttionServer , [1]=sip is "" , assign the sipServer when using producttionServer.
				return result;
			}
			else
			{
				LogUtil.debug("It is NOOOOOOT Production Server", "AppSetting");
				result = ["false", "null"]; // [0]= is not producttionServer
				return result;
			}
		}

		private function loadAppConfigInfo(urlName:String):Array
		{
			var url_Array:Array = new Array();
			try
			{
				if (urlName == LOAD_AUTH_SERVER_URL)
				{
					LogUtil.debug("Spliting AppConfig.AUTH_SERVER URL", "AppSetting");
					url_Array = AppConfig.AUTH_SERVER.split("://");
				}
				else if (urlName == LOAD_REALTIME_SERVER_URL)
				{
					LogUtil.debug("Spliting AppConfig.REALTIME_SERVER URL", "AppSetting");
					url_Array = AppConfig.REALTIME_SERVER.split("://");
				}
				else if (urlName == LOAD_HOST_AND_RTMPSERVER_URL)
				{
					LogUtil.debug("HOST and RTMP_SERVER URL does not split", "AppSetting");
					var HOST_and_RTMP_SERVER_URL_noSplit_Array:Array = new Array(AppConfig.HOST + ":" + AppConfig.HTTP_PORT);
					url_Array = HOST_and_RTMP_SERVER_URL_noSplit_Array;
				}
				else
				{
					LogUtil.debug("SIP_SERVER URL does not split", "AppSetting");
					var SIP_SERVER_URL_noSplit_Array:Array = new Array(AppConfig.SIP_SERVER + ":" + AppConfig.SIP_SERVER_PORT);
					url_Array = SIP_SERVER_URL_noSplit_Array;
				}
			}
			catch (e:Error)
			{
				LogUtil.error(e.name, "AppSetting");
				LogUtil.error(e.message, "AppSetting");
				LogUtil.error(e.getStackTrace(), "AppSetting");
				var error_Array:Array = new Array("Error ID" + e.name);
				url_Array = error_Array;
			}
			return url_Array;
		}

		//change Module URL and HOST link address
		private function changeMeetModuleConnectAddress():void
		{
			try
			{
				LogUtil.debug("Change Module Connect Address", "AppSetting");
				//VIEWER_MODULE
				AppConfig.MODULES.VIEWER_MODULE.uri = "rtmp://" + AppConfig.HOST + "/server";
				AppConfig.MODULES.VIEWER_MODULE.host = "http://" + AppConfig.HOST + ":" + AppConfig.HTTP_PORT + "/api/enter";
				//PHONE_MODULE
				AppConfig.MODULES.PHONE_MODULE.uri = "rtmp://" + AppConfig.HOST + "/sip";
				//PRESENT_MODULE
				AppConfig.MODULES.PRESENT_MODULE.uri = "rtmp://" + AppConfig.HOST + "/server";
				AppConfig.MODULES.PRESENT_MODULE.host = "http://" + AppConfig.HOST + ":" + AppConfig.HTTP_PORT;
				//WHITEBOARD_MODULE 
				AppConfig.MODULES.WHITEBOARD_MODULE.uri = "rtmp://" + AppConfig.HOST + "/server";
				//LISTENER_MODULE
				AppConfig.MODULES.LISTENER_MODULE.uri = "rtmp://" + AppConfig.HOST + "/server";
				AppConfig.MODULES.LISTENER_MODULE.recordingHost = "http://" + AppConfig.HOST + ":" + AppConfig.HTTP_PORT;
			}
			catch (e:Error)
			{
				LogUtil.error(e.name, "AppSetting");
				LogUtil.error(e.message, "AppSetting");
				LogUtil.error(e.getStackTrace(), "AppSetting");
			}
		}

	}
}
