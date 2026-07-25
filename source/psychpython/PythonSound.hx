package psychpython;

import flixel.FlxG;
import flixel.sound.FlxSound;
import backend.Paths;
import states.PlayState;

import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
class PythonSound
{
	public static var sounds:Map<String, FlxSound> = new Map();

	public static function setup(script:PythonScript)
	{
		script.set("playSound", function(file:String, tag:String = "", volume:Float = 1)
		{
			playSound(file, tag, volume);
		});

		script.set("stopSound", function(tag:String)
		{
			stopSound(tag);
		});

		script.set("setSoundVolume", function(tag:String, volume:Float)
		{
			setSoundVolume(tag, volume);
		});
		script.set("playMusic", function(file:String, volume:Float = 1, loop:Bool = true)
		{
			playMusic(file, volume, loop);
		});


		script.set("stopMusic", function()
		{
			stopMusic();
		});


		script.set("pauseMusic", function()
		{
			pauseMusic();
		});


		script.set("resumeMusic", function()
		{
			resumeMusic();
		});


		script.set("soundFadeIn", function(tag:String, duration:Float, from:Float, to:Float)
		{
			soundFadeIn(tag,duration,from,to);
		});


		script.set("soundFadeOut", function(tag:String, duration:Float, from:Float, to:Float)
		{
			soundFadeOut(tag,duration,from,to);
		});
	}

	static function playSound(file:String, tag:String, volume:Float)
	{
		var finalTag:String = (tag == null || tag == "") ? file : tag;

		var sound = FlxG.sound.load(Paths.sound(file), volume);
		if(sound == null) return;

		if (sounds.exists(finalTag))
		{
			sounds.get(finalTag).stop();
			sounds.get(finalTag).destroy();
		}

		sound.play();
		sounds.set(finalTag, sound);
	}

	static function stopSound(tag:String)
	{
		if(sounds.exists(tag))
		{
			sounds.get(tag).stop();
			sounds.get(tag).destroy();
			sounds.remove(tag);
		}
	}

	static function setSoundVolume(tag:String, volume:Float)
	{
		if(sounds.exists(tag))
			sounds.get(tag).volume = volume;
	}

	static function playMusic(file:String, volume:Float, loop:Bool)
	{
		FlxG.sound.playMusic(
			Paths.music(file),
			volume,
			loop
		);
	}

	static function stopMusic()
	{
		if(FlxG.sound.music != null)
		{
			FlxG.sound.music.stop();
		}
	}

	static function pauseMusic()
	{
		if(FlxG.sound.music != null)
			FlxG.sound.music.pause();
	}

	static function resumeMusic()
	{
		if(FlxG.sound.music != null)
			FlxG.sound.music.resume();
	}

	static function soundFadeIn(
		tag:String,
		duration:Float,
		from:Float,
		to:Float
	)
	{
		var sound = getSound(tag);

		if(sound == null)
			return;


		sound.volume = from;


		FlxTween.tween(
			sound,
			{
				volume:to
			},
			duration
		);
	}

	static function soundFadeOut(
		tag:String,
		duration:Float,
		from:Float,
		to:Float
	)
	{
		var sound = getSound(tag);

		if(sound == null)
			return;


		sound.volume = from;


		FlxTween.tween(
			sound,
			{
				volume:to
			},
			duration
		);
	}

	static function getSound(tag:String):FlxSound
	{
		if(sounds.exists(tag))
			return sounds.get(tag);

		return null;
	}

	public static function clearSounds()
	{
		for (sound in sounds.iterator())
		{
			if (sound != null)
			{
				sound.stop();
				sound.destroy();
			}
		}
		sounds.clear();
	}
}
