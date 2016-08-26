package conf
{

	public class AppConfig
	{
		public static var AUTO_LOGIN:Boolean = true;
		public static var AUTO_ORIENTS:Boolean = true;
		public static var AUTO_SAVE:Boolean = true;
		public static var IS_CONTACT_LIST:Boolean = true;
		//the sign for app setting info , DO NOT change.
		public static var APP_SETTING_INFO_KEY:String = "App_change_server_ip_address_flag";

		// logging causes massive memory/resource loss, turn off for Production build
		public static var LOGGING_ON:Boolean = true;

		// Development Only
		public static var LOGIN_NAME:String = "";
		public static var LOGIN_PASSWORD:String = "";

		// version number , remember check versionNumber in BigBlueButton-app.xml
		public static var APP_VERSION:String = "v X.X.X";
		public static var VERSION:String = "YYYY-MM-DD:SS";

		// ------- Server infomation -------
		public static var AUTH_SERVER:String = "SERVER ADDRESS (ex: http://192.192.192.192:port)";
		public static var REALTIME_SERVER:String = "REALTIME SERVER ADDRESS (ex: http://192.192.192.192:port)";
		public static var RTMP_SERVER:String = "PLATFORM SERVER ADDRESS (ex: 192.192.192.192)";
		public static var HOST:String = "PLATFORM SERVER ADDRESS (ex: 192.192.192.192)";
		public static var HTTP_PORT:String = "THE_HTTP_PORT_WE_USE_FOR_PLATFORM(ex: 80)";
		public static var SIP_SERVER_PROTOCOL:String = "rtmp://";
		public static var SIP_SERVER:String = "FREESWITCH_IP(ex: 192.192.192.192)";
		public static var SIP_SERVER_PORT:String = "FREESWITCH_IP_PORT";
		public static var SIP_SERVER_PATH:String = "FREESWITCH_IP_PATH";
		public static var SIP_SERVER_PASSWORD:String = "PASSWORD";
		public static var SIP_SERVER_AUDIO_CODEC:String = "AUDIO_CODEC"; // Option: SPEEX whideband, Nellymoser
		//-------------------------

		public static var ACC_KEY:String = "userAccount";
		public static var CLIENT_KEY:String = "userClient";
		public static var DEFAULT_LANGUAGE:String = "en_US";
		public static var LANGUAGES:Object = {"zh_TW": "繁體中文", "en_US": "English"};
		public static var LANGUAGE:Object = {"userSelectionEnabled": true};

		public static var LOCALE_VERSION:Object = {"suppressWarning": false, "value": "0.8"};
		public static var BUTTON_ORDER:Array = ["video", "whiteboard", "chat", "participants", "setting"];
		public static var TEST_MODE:Object = {"enabled": false, "joinUrl": "http://HOST/bigbluebutton/api/join"}
		public static var CONTACT_LIST_MODE:Boolean = true;
		public static var HELP_URL:String = "http://" + HOST + "/help.html"
		public static var PORT_TEST:Object = {"host": HOST, "application": "video"};
		public static var APPLICATION:Object = {"uri": "rtmp://" + HOST + "/bigbluebutton", "host": "http://" + HOST + "/bigbluebutton/api/enter", "logoutUrl": "http://" + HOST + "/bigbluebutton/api/signOut"}
		public static var WEB_API:Object = {"uri": "rtmp://" + HOST + "/bigbluebutton/api", "salt": "SALT"}

		public static var LANG_SELECTION:Boolean = true;
		public static var LAYOUT:Object = {"showLogButton": false, "showVideoLayout": false, "showResetLayout": true, "showToolbar": true, "showHelpButton": true, "showLogoutWindow": false}

		public static var WEBCAM_DEFAULT_ON:Boolean = false;

		public static var MODULES:Object = {"VIEWER_MODULE": {"name": "ViewersModule", "url": "ViewersModule.swf?v=4006", "uri": "rtmp://" + AppConfig.HOST + "/bigbluebutton", "host": "http://" + AppConfig.HOST + "/bigbluebutton/api/enter", "allowKickUser": "false", "windowVisible": "true"}, "PHONE_MODULE": {"name": "PhoneModule", "url": "PhoneModule.swf?v=4006", "uri": "rtmp://" + AppConfig.HOST + "/sip", "autoJoin": true, "skipCheck": true, "showButton": true, "enabledEchoCancel": false, "dependsOn": "ViewersModule"}, "PRESENT_MODULE": {"name": "PresentModule", "url": "PresentModule.swf?v=4006", "uri": "rtmp://" + AppConfig.HOST + "/bigbluebutton", "host": "http://" + AppConfig.HOST, "showPresentWindow": true, "showWindowControls": true, "dependsOn": "ViewersModule"}, "WHITEBOARD_MODULE": {"name": "WhiteboardModule", "url": "WhiteboardModule.swf?v=4006", "uri": "rtmp://" + AppConfig.HOST + "/bigbluebutton", "dependsOn": "PresentModule"}, "LISTENER_MODULE": {"name": "ListenersModule", "url": "ListenersModule.swf?v=4006", "uri": "rtmp://" + AppConfig.HOST + "/bigbluebutton", "recordingHost": "http://" + AppConfig.HOST, "windowVisible": true}

		public function AppConfig()
		{
		}
	}
}
