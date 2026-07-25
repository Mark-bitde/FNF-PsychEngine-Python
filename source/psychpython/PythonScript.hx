#if PYTHON_ALLOWED

package psychpython;

import paopao.hython.Interp;
import paopao.hython.Parser;
import sys.io.File;
import sys.FileSystem;

class PythonScript
{
	public var interp:Interp;
	public var file:String;


	public function new(path:String)
	{
		file = path;
		interp = new Interp();

		interp.maxDepth = 100;


	
		//new hython version!
		interp.errorHandler = function(error, pos)
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
		}; 
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



		// Регистрируем API
		PythonAPI.setup(this);


		var parser = new Parser();


		try
		{
			trace("[HYTHON] Trying file: " + path);
			trace("[HYTHON] Exists: " + FileSystem.exists(path));

			var code = File.getContent(path);

			// очистка от табов
			code = StringTools.replace(
				code,
				"\t",
				"    "
			);

			code = StringTools.replace(
				code,
				"\r\n",
				"\n"
			);


			var program = parser.parseString(code);
			// trace(program);


			if(program != null)
			{
				interp.execute(program);
				/* trace("[HYTHON] onCreatePost = " + interp.getVar("onCreatePost"));
				trace("[HYTHON] onBeatHit = " + interp.getVar("onBeatHit"));
				trace("[HYTHON] onUpdate = " + interp.getVar("onUpdate")); */


				trace(
					"[HYTHON] Успешно загружен скрипт: " +
					path
				);
			}
		}
		catch(e:Dynamic)
		{
			trace(
				"[HYTHON PARSER ERROR] " +
				e
			);
		}
	}



	public function call(
		func:String,
		args:Array<Dynamic>
	):Dynamic
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

			trace(
				"[HYTHON RUNTIME ERROR] Сбой в '" +
				func +
				"': " +
				errorStr
			);
		}

		return null;
	}


		public function set(
			name:String,
			value:Dynamic
		)
		{
			interp.setVar(
				name,
				value
			);
		}



	public function destroy()
	{
		if(interp != null)
		{
			interp.errorHandler = null;
		}

		interp = null;
	}
}

#end
