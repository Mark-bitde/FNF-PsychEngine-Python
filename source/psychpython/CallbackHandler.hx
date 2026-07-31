#if PYTHON_ALLOWED
package psychpython;

import markbitde.hython.*;
import haxe.Exception;

class CallbackHandler
{
    /**
     * Inline-метод вызова Python-функций.
     * @param p Состояние интерпретатора PythonState.
     * @param fname Имя функции (например, 'onCreate' или 'onUpdate').
     * @param args Необязательный массив аргументов для передачи в Python.
     * @return Int (1 — функция успешно найдена и вызвана, 0 — функции нет в скрипте).
     */
    public static inline function call(p:PythonState, fname:String, ?args:Array<Dynamic>):Int
    {
        try 
        {
            // 1. Извлекаем функцию из пространства имен Hython
            var cbf:Dynamic = p.interp.getVar(fname);
            
            // 2. Если метода 'def' с таким именем в скрипте нет — возвращаем 0
            if (cbf == null) return 0;

            // Инициализируем пустой массив, если аргументы не были переданы
            if (args == null) args = [];

            // 3. Вызываем Python-метод напрямую через callDef
            p.interp.callDef(fname, args);

            return 1; // Успешно выполнено
        }
        catch(e:Exception)
        {
            // Ловим рантайм-ошибки самого скрипта (например, деление на ноль внутри def)
            trace('HYTHON RUNTIME ERROR IN $fname: ' + e.message);
            return 0;
        }
    }
}
#end
