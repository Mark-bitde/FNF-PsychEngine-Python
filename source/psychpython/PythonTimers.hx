package psychpython;

import flixel.util.FlxTimer;

class PythonTimers
{
	public static var timers:Map<String, FlxTimer> = new Map();

	public static function setup(script:PythonScript)
	{
		script.set("runTimer", function(tag:String, time:Float, loops:Int = 1)
		{
			runTimer(tag, time, loops);
		});

		script.set("cancelTimer", function(tag:String)
		{
			cancelTimer(tag);
		});
	}

	public static function runTimer(tag:String, time:Float, loops:Int)
	{
		if (timers.exists(tag))
		{
			cancelTimer(tag);
		}

		var timer = new FlxTimer();
		timer.start(time, function(tmr:FlxTimer)
		{
			PythonManager.call("onTimerCompleted", [
				tag,
				loops,
				tmr.loopsLeft
			]);

			if (tmr.finished)
			{
				timers.remove(tag);
			}
		}, loops);

		timers.set(tag, timer);
	}

	public static function cancelTimer(tag:String)
	{
		if (timers.exists(tag))
		{
			var timer = timers.get(tag);
			if (timer != null)
			{
				timer.cancel();
				timer.destroy();
			}
			timers.remove(tag);
		}
	}

	public static function clearTimers()
	{
		for (tag in timers.keys())
		{
			cancelTimer(tag);
		}
		timers.clear();
	}
}
