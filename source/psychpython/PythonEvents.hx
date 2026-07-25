package psychpython;
import backend.Conductor;
import states.PlayState;

class PythonEvents
{
	public static function setup(script:PythonScript)
	{
		// triggerEvent()
		script.set("triggerEvent", function(name:String, value1:String = "", value2:String = "")
        {
            if(PlayState.instance != null)
            {
                PlayState.instance.triggerEvent(
                    name,
                    value1,
                    value2,
                    Conductor.songPosition
                );
            }
        });


		// debug event
		script.set("debugPrint", function(value:Dynamic)
		{
			trace("[PYTHON] " + value);
		});
	}


	/* public static function triggerEvent(name:String, value1:String, value2:String)
	{
		if(PlayState.instance == null)
			return;

		PlayState.instance.triggerEvent(
            name,
            value1,
            value2
        );
	}*/
}