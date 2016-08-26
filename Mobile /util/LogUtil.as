package util
{
	//reference : http://doc.neolao.com/flex3/mx/logging/package-detail.html
	import mx.logging.ILogger;
	import mx.logging.Log;
	import conf.AppConfig;

	import CANNOT.SHOW.WHERE.IS.THE.Logger;

	public class LogUtil
	{
		private static var loggerObj:Logger = new Logger();

		public function LogUtil()
		{

		}

		public static function getAllLogs():String
		{
			return loggerObj.messages;
		}

		public static function debug(msg:String, className:String = "None"):void
		{
			writeLog("debug", msg, className);
		}

		public static function info(msg:String, className:String = "None"):void
		{
			writeLog("info", msg, className);
		}

		public static function warn(msg:String, className:String = "None"):void
		{
			writeLog("warn", msg, className);
		}

		public static function error(msg:String, className:String = "None"):void
		{
			writeLog("error", msg, className);
		}

		private static function writeLog(level:String, msg:String, className:String):void
		{
			if (!AppConfig.LOGGING_ON)
				return;

			var m:String = "[" + className + "]\t" + msg;
			trace("[" + level.toUpperCase() + "] " + m);
			logger[level](m);
		}

		private static function get logger():ILogger
		{
			return Log.getLogger(Logger.LOGGER);
		}
	}
}
