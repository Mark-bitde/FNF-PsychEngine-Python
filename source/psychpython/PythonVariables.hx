package psychpython;

import states.PlayState;
import flixel.FlxG;

class PythonVariables
{
	public static var globalVars:Map<String, Dynamic> = new Map();


	public static function setup(script:PythonScript)
	{
		// Аналог Lua setProperty
		script.set("setVar", function(name:String, value:Dynamic)
		{
			setVar(name, value);
		});


		// Аналог Lua getProperty
		script.set("getVar", function(name:String):Dynamic
		{
			return getVar(name);
		});


		script.set("removeVar", function(name:String)
		{
			removeVar(name);
		});


		// Аналог HScript/Lua глобальных переменных
		script.set("setGlobal", function(name:String, value:Dynamic)
		{
			globalVars.set(name, value);
		});


		script.set("getGlobal", function(name:String):Dynamic
		{
			return globalVars.exists(name) ? globalVars.get(name) : null;
		});
	}



	public static function setVar(name:String, value:Dynamic)
	{
		if(name.indexOf(".") != -1)
		{
			PythonReflection.setProperty(name, value);
			return;
		}


		if(PlayState.instance != null)
		{
			var field = Reflect.field(PlayState.instance, name);

			if(field != null)
			{
				Reflect.setProperty(
					PlayState.instance,
					name,
					value
				);
				return;
			}
		}


		globalVars.set(name, value);
	}



	public static function getVar(name:String):Dynamic
	{
		if(name.indexOf(".") != -1)
		{
			return PythonReflection.getProperty(name);
		}


		if(PlayState.instance != null)
		{
			var value = Reflect.field(
				PlayState.instance,
				name
			);

			if(value != null)
				return value;
		}


		if(globalVars.exists(name))
			return globalVars.get(name);


		return null;
	}



	public static function removeVar(name:String)
	{
		if(globalVars.exists(name))
			globalVars.remove(name);
	}



	public static function clearVariables()
	{
		globalVars.clear();
	}
}