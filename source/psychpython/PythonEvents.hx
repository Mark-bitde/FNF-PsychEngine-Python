#if PYTHON_ALLOWED
package psychpython;

import backend.Conductor;
import states.PlayState;

class PythonEvents
{
	public static function setup(script:PythonScript)
	{
		script.set("triggerEvent", triggerEvent);
	}

	static function triggerEvent(
		name:String,
		value1:String = "",
		value2:String = ""
	):Void
	{
		if (PlayState.instance == null)
			return;

		PlayState.instance.triggerEvent(
			name,
			value1,
			value2,
			Conductor.songPosition
		);
	}
}
#end