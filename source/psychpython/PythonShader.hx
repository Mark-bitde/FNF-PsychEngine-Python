package psychpython;

import openfl.filters.ShaderFilter;
import flixel.addons.display.FlxRuntimeShader;
import states.PlayState;

class PythonShader
{
	public static var shaders:Map<String, FlxRuntimeShader> = new Map();

	public static function setup(script:PythonScript)
	{
		script.set("createRuntimeShader", function(tag:String, fragment:String)
		{
			createRuntimeShader(tag, fragment);
		});

		script.set("setShader", function(camera:String, tag:String)
		{
			setShader(camera, tag);
		});

		script.set("removeShader", function(camera:String)
		{
			removeShader(camera);
		});

		script.set("setShaderFloat", function(tag:String, name:String, value:Float)
		{
			setShaderFloat(tag, name, value);
		});
	}

	static function createRuntimeShader(tag:String, fragment:String)
	{
		var shader = new FlxRuntimeShader(fragment, null);
		shaders.set(tag, shader);
	}

	static function setShader(camera:String, tag:String)
	{
		if(PlayState.instance == null || !shaders.exists(tag))
			return;

		var shader = shaders.get(tag);

		switch(camera.toLowerCase())
		{
			case "game":
				PlayState.instance.camGame.filters = [new ShaderFilter(shader)];
			case "hud":
				PlayState.instance.camHUD.filters = [new ShaderFilter(shader)];
		}
	}

	static function removeShader(camera:String)
	{
		if(PlayState.instance == null)
			return;

		switch(camera.toLowerCase())
		{
			case "game":
				PlayState.instance.camGame.filters = [];
			case "hud":
				PlayState.instance.camHUD.filters = [];
		}
	}

	static function setShaderFloat(tag:String, name:String, value:Float)
	{
		if(shaders.exists(tag))
		{
			shaders.get(tag).setFloat(name, value);
		}
	}

	public static function clearShaders()
	{
		shaders.clear();
	}
}
