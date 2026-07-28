
#if PYTHON_ALLOWED
package psychpython;

class PythonScripts
{
	public static function setup(script:PythonScript)
	{
		script.set(
			"getRunningScripts",
			function():Array<String>
			{
				return getRunningScripts();
			}
		);
	}


	static function getRunningScripts():Array<String>
	{
		var runningScripts:Array<String> = [];


		for(pyScript in PythonManager.scripts)
		{
			runningScripts.push(
				pyScript.getScriptName()
			);
		}


		return runningScripts;
	}
}
#end