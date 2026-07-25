package psychpython;

import Type;

class PythonClassAccess
{
	public static function setup(script:PythonScript)
	{
		script.set("getPropertyFromClass", function(className:String, field:String)
		{
			return get(className, field);
		});

		script.set("setPropertyFromClass", function(className:String, field:String, value:Dynamic)
		{
			set(className, field, value);
		});
	}

	static function get(className:String, field:String):Dynamic
	{
		var cls = Type.resolveClass(className);
		if(cls == null) return null;

		// Для статических полей класса используем Reflect.field вместо getProperty
		return Reflect.field(cls, field);
	}

	static function set(className:String, field:String, value:Dynamic)
	{
		var cls = Type.resolveClass(className);
		if(cls != null) {
			// Для статических полей класса используем Reflect.setField вместо setProperty
			Reflect.setField(cls, field, value);
		}
	}
}
