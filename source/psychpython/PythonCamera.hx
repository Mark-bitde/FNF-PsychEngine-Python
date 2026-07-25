package psychpython;

import flixel.FlxG;
import flixel.util.FlxColor;
import states.PlayState;

class PythonCamera
{
	public static function setup(script:PythonScript)
	{
		script.set("setCameraZoom", function(camera:String, zoom:Float)
		{
			setCameraZoom(camera, zoom);
		});


		script.set("setCamZoom", function(camera:String, zoom:Float)
		{
			setCameraZoom(camera, zoom);
		});


		script.set("cameraShake", function(camera:String, intensity:Float, duration:Float)
		{
			cameraShake(camera, intensity, duration);
		});


		script.set("cameraFlash", function(camera:String, color:String, duration:Float)
		{
			cameraFlash(camera, color, duration);
		});


		script.set("cameraFade", function(camera:String, color:String, duration:Float, force:Bool = false)
		{
			cameraFade(camera,color,duration,force);
		});


		script.set("setCameraScroll", function(camera:String,x:Float,y:Float)
		{
			setCameraScroll(camera,x,y);
		});


		script.set("moveCamera", function(target:String)
		{
			moveCamera(target);
		});


		script.set("getCameraZoom", function(camera:String):Float
		{
			return getCameraZoom(camera);
		});
	}

	static function setCameraZoom(camera:String, zoom:Float)
	{
		if(PlayState.instance == null)
			return;

		switch(camera.toLowerCase())
		{
			case "game":
				PlayState.instance.camGame.zoom = zoom;
			case "hud":
				PlayState.instance.camHUD.zoom = zoom;
		}
	}

	static function cameraShake(camera:String, intensity:Float, duration:Float)
	{
		if(PlayState.instance == null)
			return;

		switch(camera.toLowerCase())
		{
			case "game":
				PlayState.instance.camGame.shake(intensity, duration);
			case "hud":
				PlayState.instance.camHUD.shake(intensity, duration);
		}
	}

	static function cameraFlash(camera:String, color:String, duration:Float)
	{
		if(PlayState.instance == null)
			return;

		var cam = switch(camera.toLowerCase())
		{
			case "hud":
				PlayState.instance.camHUD;
			default:
				PlayState.instance.camGame;
		};

		cam.flash(FlxColor.fromString(color), duration);
	}
	static function cameraFade(
		camera:String,
		color:String,
		duration:Float,
		force:Bool
	)
	{
		if(PlayState.instance == null)
			return;


		var cam = getCamera(camera);

		if(cam == null)
			return;


		cam.fade(
			FlxColor.fromString(color),
			duration,
			false,
			null,
			force
		);
	}
	static function getCamera(camera:String):Dynamic
	{
		if(PlayState.instance == null)
			return null;


		return switch(camera.toLowerCase())
		{
			case "hud":
				PlayState.instance.camHUD;


			case "other":
				PlayState.instance.camOther;


			default:
				PlayState.instance.camGame;
		}
	}
	static function setCameraScroll(
		camera:String,
		x:Float,
		y:Float
	)
	{
		var cam = getCamera(camera);

		if(cam == null)
			return;


		cam.scroll.set(x,y);
	}
	static function moveCamera(target:String)
	{
		if(PlayState.instance == null)
			return;


		switch(target.toLowerCase())
		{
			case "bf" | "boyfriend":
				PlayState.instance.moveCamera(true);


			case "dad":
				PlayState.instance.moveCamera(false);


			case "gf":
				PlayState.instance.moveCamera(false);
		}
	}
	static function getCameraZoom(camera:String):Float
	{
		var cam = getCamera(camera);

		if(cam == null)
			return 1;


		return cam.zoom;
	}
}
