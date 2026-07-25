#if PYTHON_ALLOWED
package psychpython;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.PlayState;

class PythonText
{
	public static var texts:Map<String, FlxText> = new Map();

	public static function setup(script:PythonScript)
	{
		// Используем Dynamic для всех аргументов, чтобы hython читал их внутри def
		script.set("makeLuaText", function(tag:Dynamic, text:Dynamic, width:Dynamic, x:Dynamic, y:Dynamic)
		{
			makeLuaText(Std.string(tag), Std.string(text), Std.int(width), Std.parseFloat(x), Std.parseFloat(y));
		});

		script.set("addLuaText", function(tag:Dynamic)
		{
			addLuaText(Std.string(tag));
		});

		script.set("removeLuaText", function(tag:Dynamic, ?destroy:Dynamic)
		{
			removeLuaText(Std.string(tag), destroy == null ? true : destroy);
		});

		script.set("setTextString", function(tag:Dynamic, text:Dynamic)
		{
			if (texts.exists(Std.string(tag)))
				texts.get(Std.string(tag)).text = Std.string(text);
		});

		script.set("setTextSize", function(tag:Dynamic, size:Dynamic)
		{
			if (texts.exists(Std.string(tag)))
				texts.get(Std.string(tag)).setFormat(null, Std.int(size), FlxColor.WHITE);
		});
	}

	static function makeLuaText(tag:String, text:String, width:Int, x:Float, y:Float)
	{
		if (PlayState.instance == null) return;

		if (texts.exists(tag))
			removeLuaText(tag, true);

		var textObject = new FlxText(x, y, width, text, 16);
		textObject.cameras = [PlayState.instance.camHUD];
		textObject.antialiasing = backend.ClientPrefs.data.antialiasing;

		texts.set(tag, textObject);
	}

	static function addLuaText(tag:String)
	{
		if (PlayState.instance == null || !texts.exists(tag)) return;
		PlayState.instance.add(texts.get(tag));
	}

	static function removeLuaText(tag:String, destroy:Bool)
	{
		if (texts.exists(tag))
		{
			var textObject = texts.get(tag);
			if (PlayState.instance != null)
				PlayState.instance.remove(textObject);

			if (destroy)
			{
				textObject.destroy();
				texts.remove(tag);
			}
		}
	}

	public static function clearTexts()
	{
		for (text in texts.iterator())
		{
			if (text != null)
				text.destroy();
		}
		texts.clear();
	}
}
#end
