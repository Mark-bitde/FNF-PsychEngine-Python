package psychpython;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

class PythonTweens
{
	public static var tweens:Map<String, FlxTween> = new Map();

	public static function setup(script:PythonScript)
	{
		script.set("doTweenX", function(tag:String, object:String, value:Float, duration:Float, ease:String = "linear")
		{
			doTweenX(tag, object, value, duration, ease);
		});

		script.set("doTweenY", function(tag:String, object:String, value:Float, duration:Float, ease:String = "linear")
		{
			doTweenY(tag, object, value, duration, ease);
		});

		script.set("doTweenAlpha", function(tag:String, object:String, value:Float, duration:Float, ease:String = "linear")
		{
			doTweenAlpha(tag, object, value, duration, ease);
		});

		script.set("doTweenAngle", function(tag:String, object:String, value:Float, duration:Float, ease:String = "linear")
		{
			doTweenAngle(tag, object, value, duration, ease);
		});

		script.set("cancelTween", function(tag:String)
		{
			cancelTween(tag);
		});
		script.set("doTweenProperty",
		function(tag:String, object:String, value:Dynamic, duration:Float, ease:String = "linear")
		{
			doTweenProperty(tag, object, value, duration, ease);
		});
	}

	static function doTweenX(tag:String, object:String, value:Float, duration:Float, ease:String)
	{
		var obj = PythonReflection.getProperty(object);
		if(obj == null) return;

		if (tweens.exists(tag)) cancelTween(tag);

		tweens.set(tag,
			FlxTween.tween(obj, {x: value}, duration, {
				ease: getEase(ease),
				onComplete: function(twn:FlxTween) {
					PythonManager.call("onTweenCompleted", [tag]);
					tweens.remove(tag);
				}
			})
		);
	}

	static function doTweenY(tag:String, object:String, value:Float, duration:Float, ease:String)
	{
		var obj = PythonReflection.getProperty(object);
		if(obj == null) return;

		if (tweens.exists(tag)) cancelTween(tag);

		tweens.set(tag,
			FlxTween.tween(obj, {y: value}, duration, {
				ease: getEase(ease),
				onComplete: function(twn:FlxTween) {
					PythonManager.call("onTweenCompleted", [tag]);
					tweens.remove(tag);
				}
			})
		);
	}

	static function doTweenAlpha(tag:String, object:String, value:Float, duration:Float, ease:String)
	{
		var obj = PythonReflection.getProperty(object);
		if(obj == null) return;

		if (tweens.exists(tag)) cancelTween(tag);

		tweens.set(tag,
			FlxTween.tween(obj, {alpha: value}, duration, {
				ease: getEase(ease),
				onComplete: function(twn:FlxTween) {
					PythonManager.call("onTweenCompleted", [tag]);
					tweens.remove(tag);
				}
			})
		);
	}

	static function doTweenAngle(tag:String, object:String, value:Float, duration:Float, ease:String)
	{
		var obj = PythonReflection.getProperty(object);
		if(obj == null) return;

		if (tweens.exists(tag)) cancelTween(tag);

		tweens.set(tag,
			FlxTween.tween(obj, {angle: value}, duration, {
				ease: getEase(ease),
				onComplete: function(twn:FlxTween) {
					PythonManager.call("onTweenCompleted", [tag]);
					tweens.remove(tag);
				}
			})
		);
	}
	static function doTweenProperty(
		tag:String,
		object:String,
		value:Dynamic,
		duration:Float,
		ease:String
	)
	{
		var split = object.split(".");
		var property = split.pop();
		var obj = PythonReflection.getProperty(split.join("."));

		if(obj == null)
			return;

		if(tweens.exists(tag))
			cancelTween(tag);


		var data = {};

		Reflect.setField(data, property, value);


		tweens.set(tag,
			FlxTween.tween(obj, data, duration,
			{
				ease:getEase(ease),

				onComplete:function(_)
				{
					PythonManager.call(
						"onTweenCompleted",
						[tag]
					);

					tweens.remove(tag);
				}
			})
		);
	}

	public static function cancelTween(tag:String)
	{
		if(tweens.exists(tag))
		{
			var tween = tweens.get(tag);
			if (tween != null)
			{
				tween.cancel();
				tween.destroy();
			}
			tweens.remove(tag);
		}
	}

	public static function clearTweens()
	{
		for (tag in tweens.keys())
		{
			cancelTween(tag);
		}
		tweens.clear();
	}

	static function getEase(name:String):Dynamic
	{
		return switch(name.toLowerCase())
		{
			case "linear": FlxEase.linear;
			case "quadin": FlxEase.quadIn;
			case "quadout": FlxEase.quadOut;
			case "quadinout": FlxEase.quadInOut;
			case "cubein": FlxEase.cubeIn;
			case "cubeout": FlxEase.cubeOut;
			default: FlxEase.linear;
		}
	}
}
