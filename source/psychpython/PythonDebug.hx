#if PYTHON_ALLOWED
package psychpython;

import states.PlayState;
import backend.CoolUtil;

class PythonDebug
{
	public static function setup(script:PythonScript)
	{
		script.set("debugPrint", debugPrint);
		script.set("trace", debugPrint);
	}

	static function debugPrint(
		text:Dynamic = '',
		color:String = 'WHITE'
	):Void
	{
		var message:String = Std.string(text);

		trace("[PYTHON] " + message);

		if (PlayState.instance != null)
		{
			PlayState.instance.addTextToDebug(
				message,
				CoolUtil.colorFromString(color)
			);
		}
	}
}
#end