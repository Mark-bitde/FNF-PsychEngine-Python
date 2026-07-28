package psychpython;

import states.PlayState;
import objects.Character;
import flixel.util.FlxColor;

class PythonCharacters
{
	public static function setup(script:PythonScript)
	{
		script.set("setCharacterX", setCharacterX);
		script.set("setCharacterY", setCharacterY);

		script.set("playAnim", playAnim);
		script.set("characterPlayAnim", playAnim);

		script.set("setCharacterAlpha", setCharacterAlpha);
		script.set("setCharacterScale", setCharacterScale);
		script.set("setCharacterAngle", setCharacterAngle);
		script.set("setCharacterColor", setCharacterColor);

		script.set("getCharacterX", getCharacterX);
		script.set("getCharacterY", getCharacterY);
		script.set("getCharacterAlpha", getCharacterAlpha);
		script.set("getCharacterAngle", getCharacterAngle);
	}

	static function getCharacter(char:String):Character
	{
		if (PlayState.instance == null)
			return null;

		return switch (char.toLowerCase())
		{
			case "dad":
				PlayState.instance.dad;

			case "gf":
				PlayState.instance.gf;

			case "bf", "boyfriend":
				PlayState.instance.boyfriend;

			default:
				null;
		}
	}

	static function parseColor(color:Dynamic):FlxColor
	{
		switch (Type.typeof(color))
		{
			case TInt:
				return cast color;

			case TClass(String):
				var parsed = FlxColor.fromString(cast color);
				return parsed == null ? FlxColor.WHITE : parsed;

			default:
				return FlxColor.WHITE;
		}
	}

	// Position

	static function setCharacterX(char:String, x:Float):Void
	{
		var c = getCharacter(char);
		if (c != null)
			c.x = x;
	}

	static function setCharacterY(char:String, y:Float):Void
	{
		var c = getCharacter(char);
		if (c != null)
			c.y = y;
	}

	static function getCharacterX(char:String):Float
	{
		var c = getCharacter(char);
		return c != null ? c.x : 0;
	}

	static function getCharacterY(char:String):Float
	{
		var c = getCharacter(char);
		return c != null ? c.y : 0;
	}

	// Animation

	static function playAnim(char:String, anim:String, forced:Bool = false):Void
	{
		var c = getCharacter(char);

		if (c != null)
			c.playAnim(anim, forced);
	}

	// Appearance

	static function setCharacterAlpha(char:String, alpha:Float):Void
	{
		var c = getCharacter(char);

		if (c != null)
			c.alpha = alpha;
	}

	static function getCharacterAlpha(char:String):Float
	{
		var c = getCharacter(char);
		return c != null ? c.alpha : 1;
	}

	static function setCharacterAngle(char:String, angle:Float):Void
	{
		var c = getCharacter(char);

		if (c != null)
			c.angle = angle;
	}

	static function getCharacterAngle(char:String):Float
	{
		var c = getCharacter(char);
		return c != null ? c.angle : 0;
	}

	static function setCharacterScale(char:String, x:Float, y:Float):Void
	{
		var c = getCharacter(char);

		if (c == null)
			return;

		c.scale.set(x, y);
		c.updateHitbox();
	}

	static function setCharacterColor(char:String, color:Dynamic):Void
	{
		var c = getCharacter(char);

		if (c != null)
			c.color = parseColor(color);
	}
}