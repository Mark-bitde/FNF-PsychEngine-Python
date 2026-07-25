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

	public static function call(func:String, args:Array<Dynamic> = null):Dynamic
	{
		if(args == null)
			args = [];

		var result:Dynamic = null;

		for(script in scripts)
		{
			PythonGlobals.update(script);

			var value = script.call(func, args);

			if(value != null)
				result = value;
		}

		return result;
	}

	public static function destroy()
	{
		// ФИНАЛЬНЫЙ СБРОС: Перед тем как стереть скрипты, возвращаем настройки игры в исходное состояние!
		// Это гарантирует, что код из мода не перекочует в другие песни.
		if (states.PlayState.instance != null)
		{
			try {
				// Восстанавливаем видимость стрелок противника по умолчанию
				var opponentStrums = Reflect.field(states.PlayState.instance, "opponentStrums");
				if (opponentStrums != null) {
					Reflect.setField(opponentStrums, "visible", true);
				}
				
				// Принудительно перезагружаем пользовательские настройки MiddleScroll из конфига игрока
				backend.ClientPrefs.data.middleScroll = backend.ClientPrefs.defaultData.middleScroll;
			} catch(e:Dynamic) {}
		}

		// Дальше идет ваша стандартная очистка массива скриптов
		for(script in scripts)
		{
			if(script != null) script.destroy();
		}
		scripts = [];

		// Очистка всех статических ресурсов (спрайты, тексты, твины и т.д.) [INDEX]
		PythonSprites.clearSprites();
		PythonText.clearTexts();
		PythonTimers.clearTimers();
		PythonTweens.clearTweens();
		PythonVariables.clearVariables();
		PythonSound.clearSounds();
		PythonShader.clearShaders();
	}

}
