#if PYTHON_ALLOWED

package psychpython;

import hscript.Parser;
import hscript.Interp;

import flixel.FlxG;

import states.PlayState;
import backend.Paths;
import backend.ClientPrefs;

class PythonHScript
{
	public static function setup(script:PythonScript)
	{
		script.set(
			"runHaxeCode",
			function(code:String)
			{
				runHaxeCode(code);
			}
		);
	}



	static function runHaxeCode(code:String)
	{
		if(code == null || code == "")
			return;


		try
		{
			var parser = new Parser();

			var interp = new Interp();


			// Psych-style variables

			interp.variables.set(
				"game",
				PlayState.instance
			);


			interp.variables.set(
				"PlayState",
				PlayState
			);


			interp.variables.set(
				"FlxG",
				FlxG
			);


			interp.variables.set(
				"Paths",
				Paths
			);


			interp.variables.set(
				"ClientPrefs",
				ClientPrefs
			);


			interp.variables.set(
				"Math",
				Math
			);


			var expr =
				parser.parseString(code);


			interp.execute(expr);

		}
		catch(e:Dynamic)
		{
			trace(
				"[PYTHON HAXE ERROR] "
				+ e
			);
		}
	}
}

#end