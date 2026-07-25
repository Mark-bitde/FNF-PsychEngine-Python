package psychpython;

import flixel.FlxG;
import states.PlayState;

class PythonReflection
{
	public static function setup(script:PythonScript)
	{
		script.set("getProperty", function(path:Dynamic):Dynamic
		{
			return getProperty(Std.string(path));
		});


		script.set("setProperty", function(path:Dynamic,value:Dynamic)
		{
			setProperty(
				Std.string(path),
				value
			);
		});


		script.set("getHealth", function():Float
		{
			if(PlayState.instance == null)
				return 0;

			return PlayState.instance.health;
		});


		script.set("setHealth", function(value:Dynamic)
		{
			if(PlayState.instance != null)
				PlayState.instance.health =
				Std.parseFloat(value);
		});
	}



	public static function getProperty(path:String):Dynamic
	{
		return resolvePath(path,false,null);
	}



	public static function setProperty(path:String,value:Dynamic)
	{
		resolvePath(path,true,value);
	}



	static function resolvePath(
		path:String,
		set:Bool,
		value:Dynamic
	):Dynamic
	{
		var tokens = parsePath(path);


		var object:Dynamic =
			getRootObject(tokens.shift());


		if(object == null)
			return null;



		for(i in 0...tokens.length)
		{
			var token = tokens[i];


			var last =
				i == tokens.length - 1;



			if(last && set)
			{
				setValue(
					object,
					token,
					value
				);

				return value;
			}


			object =
				getValue(
					object,
					token
				);


			if(object == null)
				return null;
		}


		return object;
	}



	static function parsePath(path:String):Array<String>
	{
		var result:Array<String> = [];

		var current:String = "";

		var i:Int = 0;


		while(i < path.length)
		{
			var c = path.charAt(i);


			if(c == ".")
			{
				if(current != "")
				{
					result.push(current);
					current = "";
				}
			}
			else if(c == "[")
			{
				if(current != "")
				{
					result.push(current);
					current = "";
				}


				i++;

				var index:String = "";


				while(
					i < path.length &&
					path.charAt(i) != "]"
				)
				{
					index += path.charAt(i);
					i++;
				}


				result.push(index);
			}
			else
			{
				current += c;
			}


			i++;
		}


		if(current != "")
			result.push(current);


		return result;
	}



	static function getValue(
		object:Dynamic,
		key:String
	):Dynamic
	{
		if(object == null)
			return null;


		// массивы / members[index]
		if(Std.isOfType(object,Array))
		{
			return object[
				Std.parseInt(key)
			];
		}


		return Reflect.getProperty(
			object,
			key
		);
	}



	static function setValue(
		object:Dynamic,
		key:String,
		value:Dynamic
	)
	{
		if(object == null)
			return;


		if(Std.isOfType(object,Array))
		{
			object[
				Std.parseInt(key)
			]=value;

			return;
		}


		Reflect.setProperty(
			object,
			key,
			value
		);
	}



	static function getRootObject(
		key:String
	):Dynamic
	{
		switch(key)
		{
			case "FlxG" | "flxg":
				return FlxG;


			case "game" | "playstate":
				return PlayState.instance;


			default:
				if(
					PythonSprites.pythonSprites.exists(key)
				)
				{
					return
					PythonSprites.pythonSprites.get(key);
				}


				if(PlayState.instance != null)
				{
					var obj =
						Reflect.getProperty(
							PlayState.instance,
							key
						);

					if(obj != null)
						return obj;
				}
		}


		return null;
	}
}