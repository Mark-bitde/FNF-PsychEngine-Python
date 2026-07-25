package psychpython;

class PythonClassAccess
{
	public static function setup(script:PythonScript)
	{
		script.set("getPropertyFromClass",
		function(className:String, field:String)
		{
			return get(className, field);
		});


		script.set("setPropertyFromClass",
		function(className:String, field:String, value:Dynamic)
		{
			set(className, field, value);
		});
	}


	static function get(className:String, field:String):Dynamic
	{
		var cls = Type.resolveClass(className);

		if(cls == null)
			return null;

		return Reflect.getProperty(cls, field);
	}


	static function set(className:String, field:String, value:Dynamic)
	{
		var cls = Type.resolveClass(className);

		if(cls != null)
			Reflect.setProperty(cls, field, value);
	}
}