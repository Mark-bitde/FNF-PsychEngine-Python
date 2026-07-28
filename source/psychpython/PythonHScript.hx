#if PYTHON_ALLOWED

package psychpython;

import flixel.FlxG;
import states.PlayState;
import backend.Paths;
import backend.ClientPrefs;

// Импортируем Iris, если он используется в вашей версии движка
#if LUA_ALLOWED
import psychlua.HScript as IrisHScript;
#end

class PythonHScript
{
    // Наш собственный, независимый экземпляр HScript для Python
    #if LUA_ALLOWED
    private static var pythonIris:IrisHScript = null;
    #end

    public static function setup(script:PythonScript)
    {
        // Инициализируем собственный HScript-модуль для Python при старте
        #if LUA_ALLOWED
        if (pythonIris == null) {
            // Создаем чистый экземпляр HScript, не привязанный к Lua-скриптам
            pythonIris = new IrisHScript(null, "", null);
        }
        #end

        // ОБНОВЛЕННЫЙ runHaxeCode: работает автономно и изолированно
        script.set("runHaxeCode", function(codeToRun:String):Dynamic {
            #if LUA_ALLOWED
            if (pythonIris != null)
            {
                @:privateAccess {
                    // Обновляем код внутри нашего личного интерпретатора
                    pythonIris.scriptCode = codeToRun;
                    pythonIris.varsToBring = null;
                    
                    // Парсим и выполняем строку в контексте Iris
                    pythonIris.parse(true);
                    var ret:Dynamic = pythonIris.execute();
                    pythonIris.returnValue = ret;
                    
                    if (pythonIris.returnValue != null) {
                        return pythonIris.returnValue;
                    }
                }
            }
            #end
            return null;
        });
        script.set("runHaxeFunction", function(funcToRun:String, ?funcArgs:Array<Dynamic> = null):Dynamic {
            #if LUA_ALLOWED
            if (pythonIris != null) {
                // Вызываем уже скомпилированную функцию из памяти нашего Iris
                var retVal = pythonIris.call(funcToRun, funcArgs);
                if (retVal != null) return retVal.returnValue;
            }
            #end
            return null;
        });

    }
}

#end
