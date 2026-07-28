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
import psychpython.PythonCallbacks;

class PythonScript
{
	public var interp:Interp;
	public var file:String;

	public static var hudLogTexts:Array<FlxText> = [];

	public function new(path:String)
	{
		file = path;
		interp = new Interp();
		interp.maxDepth = 100000;

		psychpython.PythonManager.scripts.push(this);
		psychpython.PythonVariables.setup(this);
		//new hython version
		interp.errorHandler = function(error, pos)
		{
			var errorStr:String = Std.string(error);

			if(errorStr.indexOf("not found") != -1 ||
				errorStr.indexOf("EUnknownVariable") != -1)
				return;

			var filename:String = file.split("/").pop().split("\\").pop();
			var lineNum:String = (pos != null) ? Std.string(pos.line) : "?";

			createAndDisplayHudError(filename + ":" + lineNum + ": [Critical]: " + errorStr);

			trace(
				"[HYTHON CRITICAL ERROR] File '" +
				file +
				"':" + lineNum + ": " +
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
				trace("[HYTHON] Python script loaded successfully: " + path);
				
				// Automatically running the onCreate() method for this particular script
				this.call('onCreate', []);
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

		// БЕЗОПАСНАЯ ПРОВЕРКА НА ОТСУТСТВИЕ МЕТОДА:
		// Используем публичный метод getVar вместо приватного поля variables
		try {
			var functionObj = interp.getVar(func);
			if (functionObj == null)
				return null;
		} catch(e:Dynamic) {
			// Если getVar выкидывает ошибку при отсутствии переменной, 
			// значит метода гарантированно нет в скрипте
			return null;
		}

		try
		{
			return interp.callDef(func, args);
		}
		catch(e:Dynamic)
		{
			var errorStr:String = Std.string(e);

			if(errorStr.indexOf("not found") != -1 ||
				errorStr.indexOf("Unknown") != -1 ||
				errorStr.indexOf("does not exist") != -1)
				return null;

			var filename:String = file.split("/").pop().split("\\").pop();
			
			var lineNum:String = "Runtime";
			if (errorStr.indexOf("line ") != -1) {
				var splitErr = errorStr.split("line ");
				lineNum = splitErr[1].split(" ")[0];
			}

			trace(
				"[HYTHON RUNTIME ERROR] Error in function '" +
				func +
				"': " +
				errorStr
			);

			createAndDisplayHudError(filename + ":" + lineNum + ": " + errorStr);
		}
		
		return null;
	}


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

	public function getScriptName():String
	{
		var lastPart:String = file.split("/").pop().split("\\").pop();
		var dotIndex:Int = lastPart.lastIndexOf(".");
		if (dotIndex != -1) {
			return lastPart.substring(0, dotIndex);
		}
		return lastPart;
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
