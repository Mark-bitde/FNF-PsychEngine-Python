#if PYTHON_ALLOWED
package psychpython;
import flixel.animation.FlxAnimationController;
import states.PlayState;
import flixel.FlxSprite;
import backend.Paths;
import openfl.display.BlendMode;
class PythonSprites
{
	// Собственная изолированная мапа для Python, чтобы не трогать переменные Lua!
	public static var pythonSprites:Map<String, FlxSprite> = new Map();

	public static function setup(script:PythonScript)
	{
		script.set("makeLuaSprite", function(tag:String, image:String, x:Float = 0, y:Float = 0)
		{
			makeLuaSprite(tag, image, x, y);
		});

		script.set("addLuaSprite", function(tag:String, front:Bool = false)
		{
			addLuaSprite(tag, front);
		});

		script.set("removeLuaSprite", function(tag:String, destroy:Bool = true)
		{
			removeLuaSprite(tag, destroy);
		});
		script.set("scaleObject", function(tag:String, x:Float, y:Float, update:Bool = true)
		{
			scaleObject(tag, x, y, update);
		});


		script.set("setScrollFactor", function(tag:String, x:Float, y:Float)
		{
			setScrollFactor(tag, x, y);
		});


		script.set("setObjectCamera", function(tag:String, camera:String)
		{
			setObjectCamera(tag, camera);
		});


		script.set("setBlendMode", function(tag:String, mode:String)
		{
			setBlendMode(tag, mode);
		});


		script.set("setGraphicSize", function(tag:String, width:Int, height:Int = 0)
		{
			setGraphicSize(tag, width, height);
		});


		script.set("updateHitbox", function(tag:String)
		{
			updateHitbox(tag);
		});

		script.set("getSprite", function(tag:String):Dynamic
		{
			return pythonSprites.get(tag);
		});
		script.set("setSpriteProperty",
		function(tag:String, property:String, value:Dynamic)
		{
			setSpriteProperty(tag, property, value);
		});
		script.set("getSpriteProperty",
		function(tag:String, property:String):Dynamic
		{
			return getSpriteProperty(tag, property);
		});
		script.set("makeAnimatedLuaSprite", function(tag:String, image:String, x:Float = 0, y:Float = 0)
		{
			makeAnimatedLuaSprite(tag,image,x,y);
		});


		script.set("addAnimationByPrefix", function(tag:String, name:String, prefix:String, fps:Int = 24, loop:Bool = false)
		{
			addAnimationByPrefix(tag,name,prefix,fps,loop);
		});


		script.set("playAnim", function(tag:String, anim:String, forced:Bool = false)
		{
			playAnim(tag,anim,forced);
		});
	}
	

	static function makeLuaSprite(tag:String, image:String, x:Float, y:Float)
	{
		if (PlayState.instance == null) return;

		if (pythonSprites.exists(tag)) {
			removeLuaSprite(tag, true);
		}

		var sprite:FlxSprite = new FlxSprite(x, y);
		sprite.loadGraphic(Paths.image(image));
		sprite.antialiasing = backend.ClientPrefs.data.antialiasing;

		pythonSprites.set(tag, sprite);
	}

	static function addLuaSprite(tag:String, front:Bool)
	{
		if (PlayState.instance == null) return;

		var sprite = pythonSprites.get(tag);
		if (sprite == null) return;

		if (front) {
			PlayState.instance.add(sprite);
		} else {
			var dad = PlayState.instance.dad;
			if (dad != null) {
				var index = PlayState.instance.members.indexOf(dad);
				PlayState.instance.insert(index, sprite);
			} else {
				PlayState.instance.add(sprite);
			}
		}
	}

	static function removeLuaSprite(tag:String, destroy:Bool)
	{
		if (PlayState.instance == null)
			return;

		var sprite = pythonSprites.get(tag);

		if(sprite == null)
			return;


		PlayState.instance.remove(sprite, true);


		if(destroy)
		{
			sprite.destroy();
			pythonSprites.remove(tag);
		}
	}
	static function scaleObject(tag:String, x:Float, y:Float, update:Bool)
	{
		var sprite = pythonSprites.get(tag);

		if(sprite == null)
			return;

		sprite.scale.set(x, y);

		if(update)
			sprite.updateHitbox();
	}
	static function setScrollFactor(tag:String,x:Float,y:Float)
	{
		var sprite = pythonSprites.get(tag);

		if(sprite == null)
			return;

		sprite.scrollFactor.set(x,y);
	}
	static function setObjectCamera(tag:String,camera:String)
	{
		var sprite = pythonSprites.get(tag);

		if(sprite == null || PlayState.instance == null)
			return;


		switch(camera.toLowerCase())
		{
			case "hud":
				sprite.cameras =
				[
					PlayState.instance.camHUD
				];


			case "other":
				sprite.cameras =
				[
					PlayState.instance.camOther
				];


			default:
				sprite.cameras =
				[
					PlayState.instance.camGame
				];
		}
	}
	static function setBlendMode(tag:String,mode:String)
	{
		var sprite = pythonSprites.get(tag);

		if(sprite == null)
			return;


		switch(mode.toLowerCase())
		{
			case "add":
				sprite.blend = BlendMode.ADD;

			case "multiply":
				sprite.blend = BlendMode.MULTIPLY;

			case "screen":
				sprite.blend = BlendMode.SCREEN;

			default:
				sprite.blend = BlendMode.NORMAL;
		}
	}
	static function setGraphicSize(tag:String,width:Int,height:Int)
	{
		var sprite = pythonSprites.get(tag);

		if(sprite == null)
			return;

		sprite.setGraphicSize(width,height);
		sprite.updateHitbox();
	}

	static function updateHitbox(tag:String)
	{
		var sprite = pythonSprites.get(tag);

		if(sprite == null)
			return;

		sprite.updateHitbox();
	}

	static function addAnimationByPrefix(
		tag:String,
		name:String,
		prefix:String,
		fps:Int,
		loop:Bool
	)
	{
		var sprite = pythonSprites.get(tag);

		if(sprite == null)
			return;


		sprite.animation.addByPrefix(
			name,
			prefix,
			fps,
			loop
		);
	}

	static function playAnim(
		tag:String,
		anim:String,
		forced:Bool
	)
	{
		var sprite = pythonSprites.get(tag);

		if(sprite == null)
			return;


		sprite.animation.play(
			anim,
			forced
		);
	}

	static function setSpriteProperty(tag:String, property:String, value:Dynamic)
	{
		var sprite = pythonSprites.get(tag);

		if(sprite == null)
			return;

		Reflect.setProperty(
			sprite,
			property,
			value
		);
	}
	static function getSpriteProperty(tag:String, property:String):Dynamic
	{
		var sprite = pythonSprites.get(tag);

		if(sprite == null)
			return null;

		return Reflect.getProperty(sprite, property);
	}

	static function makeAnimatedLuaSprite(tag:String,image:String,x:Float,y:Float)
	{
		if(PlayState.instance == null)
			return;


		var sprite = new FlxSprite(x,y);

		sprite.frames = Paths.getSparrowAtlas(image);

		pythonSprites.set(tag,sprite);
	}

	public static function clearSprites()
	{
		for (sprite in pythonSprites.iterator()) {
			if (sprite != null) sprite.destroy();
		}
		pythonSprites.clear();
	}
}
#end
