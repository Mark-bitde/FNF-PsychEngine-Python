#if PYTHON_ALLOWED
package psychpython;

import flixel.FlxCamera;
import flixel.util.FlxColor;
import states.PlayState;

class PythonCamera
{
	public static function setup(script:PythonScript)
	{
		script.set("setCameraZoom", setCameraZoom);
		script.set("setCamZoom", setCameraZoom);

		script.set("cameraShake", cameraShake);
		script.set("cameraFlash", cameraFlash);
		script.set("cameraFade", cameraFade);

		script.set("setCameraScroll", setCameraScroll);
		script.set("moveCamera", moveCamera);

		script.set("getCameraZoom", getCameraZoom);
	}

	static function getCamera(camera:String):FlxCamera
	{
		if (PlayState.instance == null)
			return null;

		return switch (camera.toLowerCase())
		{
			case "hud":
				PlayState.instance.camHUD;

			case "other":
				PlayState.instance.camOther;

			default:
				PlayState.instance.camGame;
		}
	}

	static function parseColor(color:String):FlxColor
	{
		var c = FlxColor.fromString(color);
		return c == null ? FlxColor.WHITE : c;
	}

	static function setCameraZoom(camera:String, zoom:Float):Void
	{
		var cam = getCamera(camera);
		if (cam == null) return;

		cam.zoom = zoom;
	}

	static function getCameraZoom(camera:String):Float
	{
		var cam = getCamera(camera);
		return cam != null ? cam.zoom : 1;
	}

	static function cameraShake(camera:String, intensity:Float, duration:Float):Void
	{
		var cam = getCamera(camera);
		if (cam == null) return;

		cam.shake(intensity, duration);
	}

	static function cameraFlash(camera:String, color:String, duration:Float):Void
	{
		var cam = getCamera(camera);
		if (cam == null) return;

		cam.flash(parseColor(color), duration);
	}

	static function cameraFade(
		camera:String,
		color:String,
		duration:Float,
		force:Bool = false
	):Void
	{
		var cam = getCamera(camera);
		if (cam == null) return;

		cam.fade(
			parseColor(color),
			duration,
			false,
			null,
			force
		);
	}

	static function setCameraScroll(camera:String, x:Float, y:Float):Void
	{
		var cam = getCamera(camera);
		if (cam == null) return;

		cam.scroll.set(x, y);
	}

	static function moveCamera(target:String):Void
	{
		if (PlayState.instance == null)
			return;

		switch (target.toLowerCase())
		{
			case "bf", "boyfriend":
				PlayState.instance.moveCamera(true);

			case "dad":
				PlayState.instance.moveCamera(false);

			// TODO: Реализовать отдельную камеру GF, если она поддерживается.
			case "gf":
				PlayState.instance.moveCamera(false);
		}
	}
}
#end