package psychpython;

import states.PlayState;

class PythonGroups
{
	public static function setup(script:PythonScript)
	{
		script.set("getPropertyFromGroup",
		function(group:String,index:Int,field:String):Dynamic
		{
			return getPropertyFromGroup(
				group,
				index,
				field
			);
		});


		script.set("setPropertyFromGroup",
		function(group:String,index:Int,field:String,value:Dynamic)
		{
			setPropertyFromGroup(
				group,
				index,
				field,
				value
			);
		});


		script.set("getGroupSize",
		function(group:String):Int
		{
			return getGroupSize(group);
		});
	}



	static function getGroup(group:String):Dynamic
	{
		if(PlayState.instance == null)
			return null;


		return switch(group.toLowerCase())
		{

			case "notes":
				PlayState.instance.notes;


			case "strumlin eNotes":
				PlayState.instance.strumLineNotes;


			case "strumlinenotes":
				PlayState.instance.strumLineNotes;


			case "opponentstrums":
				PlayState.instance.opponentStrums;


			case "playerstrums":
				PlayState.instance.playerStrums;


			default:

				Reflect.getProperty(
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


		if(Reflect.hasField(obj,"members"))
		{
			return obj.members[index];
		}


		if(Std.isOfType(obj,Array))
        {
            var arr:Array<Dynamic> = cast obj;
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
		var member =
			getMember(
				group,
				index
			);


		if(member == null)
			return null;


		return Reflect.getProperty(
			member,
			field
		);
	}



	static function setPropertyFromGroup(
		group:String,
		index:Int,
		field:String,
		value:Dynamic
	)
	{
		var member =
			getMember(
				group,
				index
			);


		if(member == null)
			return;


		Reflect.setProperty(
			member,
			field,
			value
		);
	}



	static function getGroupSize(group:String):Int
	{
		var obj =
			getGroup(group);


		if(obj == null)
			return 0;


		if(Reflect.hasField(obj,"length"))
			return obj.length;


		if(Reflect.hasField(obj,"members"))
			return obj.members.length;


		return 0;
	}
}