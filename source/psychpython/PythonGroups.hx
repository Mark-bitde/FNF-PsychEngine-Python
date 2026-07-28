#if PYTHON_ALLOWED
package psychpython;

import states.PlayState;

class PythonGroups
{
	public static function setup(script:PythonScript)
	{
		script.set("getPropertyFromGroup", getPropertyFromGroup);
		script.set("setPropertyFromGroup", setPropertyFromGroup);
		script.set("getGroupSize", getGroupSize);
	}


	static function getGroup(group:String):Dynamic
	{
		if(PlayState.instance == null)
			return null;


		return switch(group.toLowerCase())
		{
			case "notes":
				PlayState.instance.notes;

			case "strumlinenotes":
				PlayState.instance.strumLineNotes;

			case "opponentstrums":
				PlayState.instance.opponentStrums;

			case "playerstrums":
				PlayState.instance.playerStrums;

			default:
				Reflect.field(
					PlayState.instance,
					group
				);
		};
	}


	static function getMember(
		group:String,
		index:Int
	):Dynamic
	{
		var obj = getGroup(group);

		if(obj == null)
			return null;


		if(Reflect.hasField(obj, "members"))
		{
			var members:Array<Dynamic> = obj.members;

			if(index < 0 || index >= members.length)
				return null;

			return members[index];
		}


		if(Std.isOfType(obj, Array))
		{
			var arr:Array<Dynamic> = cast obj;

			if(index < 0 || index >= arr.length)
				return null;

			return arr[index];
		}


		return null;
	}


	static function getPropertyFromGroup(
		group:String,
		index:Int,
		field:String
	):Dynamic
	{
		var member = getMember(group, index);

		if(member == null)
			return null;


		return Reflect.field(
			member,
			field
		);
	}


	static function setPropertyFromGroup(
		group:String,
		index:Int,
		field:String,
		value:Dynamic
	):Void
	{
		var member = getMember(group, index);

		if(member == null)
			return;


		Reflect.setField(
			member,
			field,
			value
		);
	}


	static function getGroupSize(group:String):Int
	{
		var obj = getGroup(group);

		if(obj == null)
			return 0;


		if(Reflect.hasField(obj, "members"))
		{
			return obj.members.length;
		}


		if(Std.isOfType(obj, Array))
		{
			return (cast obj:Array<Dynamic>).length;
		}


		return 0;
	}
}
#end