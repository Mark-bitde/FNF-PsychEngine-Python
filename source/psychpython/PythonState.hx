package psychpython;

import paopao.hython.Interp;

class PythonState 
{
    // Вместо сырого указателя храним полноценный объект интерпретатора
    public var interp:Interp;

    public function new() 
    {
        interp = new Interp();
        // Здесь можно сразу задать глобальные лимиты для безопасности движка
        interp.maxDepth = 100000; 
    }

    /**
     * Аналог State.create() из llua, возвращающий чистый контекст
     */
    public static inline function create():PythonState 
    {
        return new PythonState();
    }
}
