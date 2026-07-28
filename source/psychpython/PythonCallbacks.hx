#if PYTHON_ALLOWED
package psychpython;

class PythonCallbacks
{
    /**
     * Единственный универсальный метод для вызова Python-событий.
     * @param name Имя функции в Python (например, 'onCreate', 'onBeatHit')
     * @param args Массив аргументов (необязательный)
     */
    public static function call(name:String, ?args:Array<Dynamic>):Dynamic
    {
        return PythonManager.call(name, args == null ? [] : args);
    }
}
#end

