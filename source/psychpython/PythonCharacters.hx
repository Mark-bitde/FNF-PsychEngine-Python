package psychpython;

import states.PlayState;
import objects.Character;
import flixel.util.FlxColor;
class PythonCharacters
{
	public static function setup(script:PythonScript)
	{
		script.set("setCharacterX", function(char:String, x:Float)
		{
			setCharacterX(char,x);
		});


		script.set("setCharacterY", function(char:String, y:Float)
		{
			setCharacterY(char,y);
		});


		script.set("playAnim", function(char:String, anim:String, forced:Bool = false)
		{
			playAnim(char,anim,forced);
		});


		script.set("characterPlayAnim", function(char:String, anim:String, forced:Bool = false)
		{
			playAnim(char,anim,forced);
		});


		script.set("setCharacterAlpha", function(char:String, alpha:Float)
		{
			setCharacterAlpha(char,alpha);
		});


		script.set("setCharacterScale", function(char:String, x:Float, y:Float)
		{
			setCharacterScale(char,x,y);
		});


		script.set("setCharacterAngle", function(char:String, angle:Float)
		{
			setCharacterAngle(char,angle);
		});


		script.set("setCharacterColor", function(char:String, color:Int)
		{
			setCharacterColor(char,color);
		});


		script.set("getCharacterX", function(char:String):Float
		{
			return getCharacterX(char);
		});


		script.set("getCharacterY", function(char:String):Float
		{
			return getCharacterY(char);
		});


		script.set("getCharacterAlpha", function(char:String):Float
		{
			return getCharacterAlpha(char);
		});


		script.set("getCharacterAngle", function(char:String):Float
		{
			return getCharacterAngle(char);
		});
	}

	static function getCharacter(char:String):Character
	{
		if(PlayState.instance == null)
			return null;

		return switch(char.toLowerCase())
		{
			case "dad":
				PlayState.instance.dad;

			case "gf":
				PlayState.instance.gf;

			case "boyfriend" | "bf":
				PlayState.instance.boyfriend;

			default:
				null;
		}
	}


	static function setCharacterX(char:String, x:Float)
	{
		var character = getCharacter(char);

		if(character != null)
			character.x = x;
	}


	static function setCharacterY(char:String, y:Float)
	{
		var character = getCharacter(char);

		if(character != null)
			character.y = y;
	}


	static function getCharacterX(char:String):Float
	{
		var character = getCharacter(char);

		if(character != null)
			return character.x;

		return 0;
	}


	static function getCharacterY(char:String):Float
	{
		var character = getCharacter(char);

		if(character != null)
			return character.y;

		return 0;
	}


	static function playAnim(char:String, anim:String, forced:Bool)
	{
		var character = getCharacter(char);

		if(character != null)
			character.playAnim(anim, forced);
	}

	static function setCharacterAlpha(char:String, alpha:Float)
	{
		var character = getCharacter(char);

		if(character != null)
			character.alpha = alpha;
	}

	static function setCharacterScale(char:String, x:Float, y:Float)
	{
		var character = getCharacter(char);

		if(character != null)
		{
			character.scale.set(x,y);
			character.updateHitbox();
		}
	}

	static function setCharacterAngle(char:String, angle:Float)
	{
		var character = getCharacter(char);

		if(character != null)
			character.angle = angle;
	}

	static function setCharacterColor(char:String,color:Int)
	{
		var character = getCharacter(char);

		if(character != null)
			character.color = color;
	}

	static function getCharacterAlpha(char:String):Float
	{
		var character = getCharacter(char);

		if(character != null)
			return character.alpha;

		return 1;
	}

	static function getCharacterAngle(char:String):Float
	{
		var character = getCharacter(char);

		if(character != null)
			return character.angle;

		return 0;
	}
}