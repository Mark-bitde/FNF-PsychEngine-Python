package psychpython;

import flixel.math.FlxMath;
import flixel.util.FlxColor;
import flixel.FlxG;

class PythonUtils
{
	public static var Function_Stop:String = "FUNCTION_STOP";

	public static var Function_Continue:String = "FUNCTION_CONTINUE";

	public static var Function_StopHScript:String = "FUNCTION_STOP_HSCRIPT";

	public static function setup(script:PythonScript)
	{
		script.set("Function_Stop", Function_Stop);

		script.set("Function_Continue", Function_Continue);

		script.set(
			"Function_StopHScript",
			Function_StopHScript
		);

		script.set("getRandomInt", function(min:Int, max:Int):Int
		{
			return getRandomInt(min,max);
		});


		script.set("getRandomFloat", function(min:Float,max:Float):Float
		{
			return getRandomFloat(min,max);
		});


		script.set("clamp", function(value:Float,min:Float,max:Float):Float
		{
			return clamp(value,min,max);
		});


		script.set("lerp", function(a:Float,b:Float,t:Float):Float
		{
			return lerp(a,b,t);
		});


		script.set("round", function(value:Float):Int
		{
			return Math.round(value);
		});


		script.set("floor", function(value:Float):Int
		{
			return Math.floor(value);
		});


		script.set("ceil", function(value:Float):Int
		{
			return Math.ceil(value);
		});


		script.set("getColorFromHex", function(hex:String):Int
		{
			return getColorFromHex(hex);
		});


		script.set("getPropertyFromClass", function(path:String):Dynamic
		{
			return getPropertyFromClass(path);
		});


		script.set("setPropertyFromClass", function(path:String,value:Dynamic)
		{
			setPropertyFromClass(path,value);
		});
	}



	static function getRandomInt(min:Int,max:Int):Int
	{
		return FlxG.random.int(min,max);
	}



	static function getRandomFloat(min:Float,max:Float):Float
	{
		return FlxG.random.float(min,max);
	}



	static function clamp(value:Float,min:Float,max:Float):Float
	{
		return FlxMath.bound(
			value,
			min,
			max
		);
	}



	static function lerp(a:Float,b:Float,t:Float):Float
	{
		return FlxMath.lerp(
			a,
			b,
			t
		);
	}



	static function getColorFromHex(hex:String):Int
	{
		return FlxColor.fromString(hex);
	}



	static function getPropertyFromClass(path:String):Dynamic
	{
		var split = path.split(".");

		var obj:Dynamic = Type.resolveClass(split.shift());

		if(obj == null)
			return null;


		for(part in split)
		{
			obj = Reflect.getProperty(
				obj,
				part
			);
		}

		return obj;
	}



	static function setPropertyFromClass(path:String,value:Dynamic)
	{
		var split = path.split(".");

		var obj:Dynamic = Type.resolveClass(split.shift());

		if(obj == null)
			return;


		while(split.length > 1)
		{
			obj = Reflect.getProperty(
				obj,
				split.shift()
			);
		}


		Reflect.setProperty(
			obj,
			split[0],
			value
		);
	}
}