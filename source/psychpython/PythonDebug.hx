package psychpython;

class PythonDebug
{
	public static function setup(script:PythonScript)
	{
		script.set("debugPrint", function(value:Dynamic)
		{
			debugPrint(value);
		});

		script.set("trace", function(value:Dynamic)
		{
			debugPrint(value);
		});
	}


	static function debugPrint(value:Dynamic)
	{
		trace("[PYTHON] " + value);
	}
}