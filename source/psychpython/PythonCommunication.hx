#if PYTHON_ALLOWED

package psychpython;

import states.PlayState;
import psychlua.FunkinLua;
class PythonCommunication
{
	public static function setup(script:PythonScript)
	{
		// callOnScripts()
		script.set(
			"callOnScripts",
			function(
				funcName:String,
				?args:Array<Dynamic> = null,
				?ignoreStops:Bool = false,
				?ignoreSelf:Bool = true,
				?excludeScripts:Array<String> = null,
				?excludeValues:Array<Dynamic> = null
			):Dynamic
			{
				if(args == null)
					args = [];


				if(excludeScripts == null)
					excludeScripts = [];


				if(ignoreSelf)
				{
					var name = script.getScriptName();

					if(!excludeScripts.contains(name))
						excludeScripts.push(name);
				}


				if(PlayState.instance != null)
				{
					return PlayState.instance.callOnScripts(
						funcName,
						args,
						ignoreStops,
						excludeScripts,
						excludeValues
					);
				}


				return null;
			}
		);



		// setOnScripts()
		script.set(
			"setOnScripts",
			function(
				varName:String,
				arg:Dynamic,
				?ignoreSelf:Bool = false,
				?exclusions:Array<String> = null
			)
			{
				if(exclusions == null)
					exclusions = [];


				if(ignoreSelf)
				{
					var name = script.getScriptName();

					if(!exclusions.contains(name))
						exclusions.push(name);
				}


				if(PlayState.instance != null)
				{
					PlayState.instance.setOnScripts(
						varName,
						arg,
						exclusions
					);
				}
			}
		);



		// callOnPython()
		script.set(
			"callOnPython",
			function(
				funcName:String,
				?args:Array<Dynamic> = null,
				?ignoreStops:Bool = false,
				?ignoreSelf:Bool = true,
				?excludeScripts:Array<String> = null,
				?excludeValues:Array<Dynamic> = null
			):Dynamic
			{
				if(args == null)
					args = [];


				if(excludeScripts == null)
					excludeScripts = [];


				if(ignoreSelf)
				{
					var name = script.getScriptName();

					if(!excludeScripts.contains(name))
						excludeScripts.push(name);
				}


				return PythonManager.callOnPython(
					funcName,
					args,
					ignoreStops,
					excludeScripts,
					excludeValues
				);
			}
		);



		// setOnPython()
		script.set(
			"setOnPython",
			function(
				varName:String,
				arg:Dynamic,
				?ignoreSelf:Bool = false,
				?exclusions:Array<String> = null
			)
			{
				if(exclusions == null)
					exclusions = [];


				if(ignoreSelf)
				{
					var name = script.getScriptName();

					if(!exclusions.contains(name))
						exclusions.push(name);
				}


				PythonManager.setOnPython(
					varName,
					arg,
					exclusions
				);
			}
		);
        // callOnHScript()
        script.set(
            "callOnHScript",
            function(
                funcName:String,
                ?args:Array<Dynamic> = null,
                ?ignoreStops:Bool = false,
                ?ignoreSelf:Bool = true,
                ?excludeScripts:Array<String> = null,
                ?excludeValues:Array<Dynamic> = null
            ):Dynamic
            {
                if(excludeScripts == null) excludeScripts = [];


                if(ignoreSelf && !excludeScripts.contains(script.getScriptName()))
					excludeScripts.push(script.getScriptName());
				return PlayState.instance.callOnHScript(funcName, args, ignoreStops, excludeScripts, excludeValues);

            }
        );
        // setOnHScript
        script.set(
            "setOnHScript",
            function(
                varName:String,
                arg:Dynamic,
                ?ignoreSelf:Bool = false,
                ?exclusions:Array<String> = null
            )
            {
                if(exclusions == null)
                    exclusions = [];


                if(ignoreSelf)
                {
                    var name = script.getScriptName();

                    if(!exclusions.contains(name))
                        exclusions.push(name);
                }


                if(PlayState.instance != null)
                {
                    PlayState.instance.setOnHScript(
                        varName,
                        arg,
                        exclusions
                    );
                }
            }
        );

		// isRunning()
		script.set("isRunning", function (scriptFile:String) {
			var pythonPath:String = PythonManager.findScript(scriptFile);
			if (pythonPath != null && PythonManager.isRunningPyScript(scriptFile)) return true;
			
			#if HSCRIPT_ALLOWED
			var hscriptPath:String = PythonManager.findScript(scriptFile, '.hx');
			if (hscriptPath != null) 
			{
				for (hscriptInstance in PlayState.instance.hscriptArray)
					if(hscriptInstance.origin == hscriptPath)
						return true;
			}
			#end
			#if LUA_ALLOWED
			var luaPath:String = PythonManager.findScript(scriptFile, '.lua');
			if(luaPath != null) 
			{
				for(luaInstance in PlayState.instance.luaArray)
					if(luaInstance.scriptName == luaPath)
						return true;
			}
			#end
			return false;
		});
	}
}

#end