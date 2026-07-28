package psychpython;

import Type;
import Reflect;

class PythonClassAccess
{
	static var classCache:Map<String, Class<Dynamic>> = [];

	public static function setup(script:PythonScript)
	{
		script.set("getPropertyFromClass", get);
		script.set("setPropertyFromClass", set);
	}

	static function resolve(className:String):Class<Dynamic>
	{
		if (!classCache.exists(className))
			classCache.set(className, Type.resolveClass(className));

		return classCache.get(className);
	}

	static function get(className:String, field:String):Dynamic
	{
		var cls = resolve(className);

		if (cls == null)
			return null;

		return Reflect.field(cls, field);
	}

	static function set(className:String, field:String, value:Dynamic):Bool
	{
		var cls = resolve(className);

		if (cls == null)
			return false;

		Reflect.setField(cls, field, value);
		return true;
	}
}