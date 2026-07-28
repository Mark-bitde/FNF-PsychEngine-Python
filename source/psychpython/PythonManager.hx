#if PYTHON_ALLOWED

package psychpython;

class PythonManager
{
	public static var scripts:Array<PythonScript> = [];


	public static function load(path:String)
	{
		trace("[PYTHON LOAD] " + path);

		var script = new PythonScript(path);
		scripts.push(script);
	}


	public static function addScript(path:String)
	{
		load(path);
	}



	public static function call(
		func:String,
		args:Array<Dynamic> = null
	):Dynamic
	{
		if(args == null)
			args = [];


		var result:Dynamic = null;


		for(script in scripts)
		{
			if(script == null)
				continue;


			


			var value = script.call(
				func,
				args
			);


			if(value != null)
				result = value;
		}


		return result;
	}



	/**
	 * Аналог setOnLuas()
	 * Только для Python-скриптов
	 */
	public static function setOnPython(
		varName:String,
		arg:Dynamic,
		?exclusions:Array<String>
	)
	{
		if(exclusions == null)
			exclusions = [];


		for(script in scripts)
		{
			if(script == null)
				continue;


			if(exclusions.contains(script.getScriptName()))
				continue;


			script.set(
				varName,
				arg
			);
		}
	}

	public static function findScript(scriptFile:String, ext:String = ".py"):String
	{
		if(!scriptFile.endsWith(ext))
			scriptFile += ext;

		var path:String = Paths.getPath(scriptFile, TEXT);

		#if MODS_ALLOWED
		if(sys.FileSystem.exists(path))
		#else
		if(openfl.utils.Assets.exists(path, TEXT))
		#end
		{
			return path;
		}

		#if MODS_ALLOWED
		else if(sys.FileSystem.exists(scriptFile))
		#else
		else if(openfl.utils.Assets.exists(scriptFile, TEXT))
		#end
		{
			return scriptFile;
		}

		return null;
	}

	/**
	 * Общая рассылка.
	 * Аналог PlayState.setOnScripts()
	 */
	public static function setOnScripts(
		varName:String,
		arg:Dynamic,
		?exclusions:Array<String>
	)
	{
		#if PYTHON_ALLOWED
		setOnPython(
			varName,
			arg,
			exclusions
		);
		#end


		#if LUA_ALLOWED
		if(states.PlayState.instance != null)
		{
			states.PlayState.instance.setOnLuas(
				varName,
				arg,
				exclusions
			);
		}
		#end


		#if HSCRIPT_ALLOWED
		if(states.PlayState.instance != null)
		{
			states.PlayState.instance.setOnHScript(
				varName,
				arg,
				exclusions
			);
		}
		#end
	}

	public static function callOnPython(
		funcName:String,
		args:Array<Dynamic> = null,
		ignoreStops:Bool = false,
		excludeScripts:Array<String> = null,
		excludeValues:Array<Dynamic> = null
	):Dynamic
	{
		if(args == null)
			args = [];

		if(excludeScripts == null)
			excludeScripts = [];

		if(excludeValues == null)
			excludeValues = [];


		var result:Dynamic = null;


		for(script in scripts)
		{
			if(script == null)
				continue;


			if(excludeScripts.contains(script.getScriptName()))
				continue;


			var value = script.call(
				funcName,
				args
			);


			if(excludeValues.contains(value))
				continue;


			if(value != null)
			{
				result = value;

				if(ignoreStops)
					break;
			}
		}


		return result;
	}

	public static function destroy()
	{
		for(script in scripts)
		{
			if(script != null)
				script.destroy();
		}


		scripts = [];


		PythonSprites.clearSprites();
		PythonText.clearTexts();
		PythonTimers.clearTimers();
		PythonTweens.clearTweens();
		PythonVariables.clearVariables();
		PythonSound.clearSounds();
		PythonShader.clearShaders();
	}
	public static function isRunningPyScript(scriptName:String):Bool
	{
		for(script in scripts)
		{
			if(script == null)
				continue;

			if(script.getScriptName() == scriptName)
				return true;
		}

		return false;
	}
}

#end