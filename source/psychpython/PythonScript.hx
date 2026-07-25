#if PYTHON_ALLOWED

package psychpython;

import paopao.hython.Interp;
import paopao.hython.Parser;
import sys.io.File;
import sys.FileSystem;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import states.PlayState;

class PythonScript
{
	public var interp:Interp;
	public var file:String;

	// Массив для хранения активных строк ошибок на экране
	public static var hudLogTexts:Array<FlxText> = [];

	public function new(path:String)
	{
		file = path;
		interp = new Interp();

		interp.maxDepth = 100;

		// Новый Hython использует другую сигнатуру обработчика ошибок: (error, pos)
		interp.errorHandler = function(error, pos)
		{
			var errorStr:String = Std.string(error);

			if(errorStr.indexOf("not found") != -1 ||
				errorStr.indexOf("EUnknownVariable") != -1)
				return;

			// Получаем чистое имя файла без полного системного пути (например, "script.py")
			var filename:String = file.split("/").pop().split("\\").pop();
			
			// Вытаскиваем номер строки из pos (если структуры pos нет или она пустая, ставим '?')
			var lineNum:String = (pos != null) ? Std.string(pos.line) : "?";

			// [АПДЕЙТ]: Форматируем вывод как в оригинальном Psych Engine: файл.py:строка: текст
			createAndDisplayHudError(filename + ":" + lineNum + ": [Critical]: " + errorStr);

			trace(
				"[HYTHON CRITICAL ERROR] В файле '" +
				file +
				"' на строке " + lineNum + ": " +
				errorStr
			);
		}; 

		PythonAPI.setup(this);

		var parser = new Parser();

		try
		{
			trace("[HYTHON] Trying file: " + path);
			trace("[HYTHON] Exists: " + FileSystem.exists(path));

			var code = File.getContent(path);

			code = StringTools.replace(code, "\t", "    ");
			code = StringTools.replace(code, "\r\n", "\n");

			var program = parser.parseString(code);

			if(program != null)
			{
				interp.execute(program);
				trace("[HYTHON] Успешно загружен скрипт: " + path);
			}
		}
		catch(e:Dynamic)
		{
			var filename:String = file.split("/").pop().split("\\").pop();
			createAndDisplayHudError(filename + ": [Parser Error]: " + Std.string(e));
			trace("[HYTHON PARSER ERROR] " + e);
		}
	}

	public function call(func:String, args:Array<Dynamic>):Dynamic
	{
		if(interp == null)
			return null;

		if(args == null)
			args = [];

		try
		{
			return interp.callDef(func, args);
		}
		catch(e:Dynamic)
		{
			var errorStr:String = Std.string(e);

			if(errorStr.indexOf("not found") != -1 ||
				errorStr.indexOf("Unknown") != -1)
				return null;

			var filename:String = file.split("/").pop().split("\\").pop();
			
			// Попробуем распарсить номер строки из текста рантайм-исключения, если hython его туда вшил
			var lineNum:String = "Runtime";
			if (errorStr.indexOf("line ") != -1) {
				var splitErr = errorStr.split("line ");
				lineNum = splitErr[1].split(" ")[0];
			}

			// Выводим ошибку рантайма с указанием файла
			createAndDisplayHudError(filename + ":" + lineNum + ": " + errorStr);

			trace(
				"[HYTHON RUNTIME ERROR] Сбой в '" +
				func +
				"': " +
				errorStr
			);
		}

		return null;
	}

	// Кастомный менеджер логов в стиле ShadowMario
	private function createAndDisplayHudError(message:String) {
		if (PlayState.instance == null) return;

		#if LUA_ALLOWED
		try {
			PlayState.instance.addTextToDebug(message, FlxColor.RED);
			return;
		} catch(e:Dynamic) {}
		#end

		var formattedMessage = "ERROR: " + message;
		
		if (hudLogTexts.length >= 5) {
			var oldLog = hudLogTexts.shift();
			if (oldLog != null) {
				PlayState.instance.remove(oldLog);
				oldLog.destroy();
			}
		}

		for (log in hudLogTexts) {
			if (log != null) {
				log.y += 25;
			}
		}

		var errorTxt:FlxText = new FlxText(10, 10, 1250, formattedMessage, 16);
		errorTxt.setFormat(backend.Paths.font("vcr.ttf"), 16, FlxColor.RED, LEFT);
		errorTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 1.5);
		errorTxt.cameras = [PlayState.instance.camHUD];
		errorTxt.antialiasing = backend.ClientPrefs.data.antialiasing;

		PlayState.instance.add(errorTxt);
		hudLogTexts.push(errorTxt);

		new FlxTimer().start(6.0, function(tmr:FlxTimer) {
			if (errorTxt != null) {
				FlxTween.tween(errorTxt, {alpha: 0}, 1.0, {
					onComplete: function(twn:FlxTween) {
						if (errorTxt != null) {
							if (hudLogTexts.contains(errorTxt))
								hudLogTexts.remove(errorTxt);
							
							PlayState.instance.remove(errorTxt);
							errorTxt.destroy();
						}
					}
				});
			}
		});
	}

	public function set(name:String, value:Dynamic)
	{
		interp.setVar(name, value);
	}

	public function destroy()
	{
		for (log in hudLogTexts) {
			if (log != null) log.destroy();
		}
		hudLogTexts = [];

		if(interp != null)
		{
			interp.errorHandler = null;
		}

		interp = null;
	}
}

#end


//older hython version
		/* interp.errorHandler = function(error)
		{
			var errorStr:String = Std.string(error);

			if(errorStr.indexOf("not found") != -1 ||
				errorStr.indexOf("EUnknownVariable") != -1)
				return;

			trace(
				"[HYTHON CRITICAL ERROR] В файле '" +
				file +
				"': " +
				errorStr
			);
		}; */
		// new hython version