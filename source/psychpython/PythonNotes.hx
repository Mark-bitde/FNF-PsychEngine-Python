package psychpython;

import states.PlayState;
import objects.Note;

class PythonNotes
{
	public static function setup(script:PythonScript)
	{
		script.set("setNoteAlpha", function(index:Int, alpha:Float, opponent:Bool = false)
		{
			setNoteAlpha(index, alpha, opponent);
		});


		script.set("setNoteAngle", function(index:Int, angle:Float, opponent:Bool = false)
		{
			setNoteAngle(index, angle, opponent);
		});


		script.set("setNoteScale", function(index:Int, scale:Float, opponent:Bool = false)
		{
			setNoteScale(index, scale, opponent);
		});


		script.set("getNoteData", function(index:Int):Dynamic
		{
			return getNoteData(index);
		});


		script.set("removeNote", function(index:Int)
		{
			removeNote(index);
		});


		script.set("hideOpponentStrums", function()
		{
			hideOpponentStrums();
		});


		script.set("showOpponentStrums", function()
		{
			showOpponentStrums();
		});
	}


	static function getNote(index:Int):Note
	{
		if(PlayState.instance == null)
			return null;


		if(PlayState.instance.notes == null)
			return null;


		if(index < 0 || index >= PlayState.instance.notes.length)
			return null;


		return PlayState.instance.notes.members[index];
	}


	static function setNoteAlpha(index:Int, alpha:Float, opponent:Bool)
	{
		var note = getNote(index);

		if(note != null)
			note.alpha = alpha;
	}


	static function setNoteAngle(index:Int, angle:Float, opponent:Bool)
	{
		var note = getNote(index);

		if(note != null)
			note.angle = angle;
	}


	static function setNoteScale(index:Int, scale:Float, opponent:Bool)
	{
		var note = getNote(index);

		if(note != null)
		{
			note.scale.set(scale, scale);
			note.updateHitbox();
		}
	}


	static function getNoteData(index:Int):Dynamic
	{
		var note = getNote(index);

		if(note == null)
			return null;


		return {
			strumTime: note.strumTime,
			noteData: note.noteData,
			mustPress: note.mustPress,
			isSustainNote: note.isSustainNote,
			noteType: note.noteType
		};
	}


	static function removeNote(index:Int)
	{
		var note = getNote(index);

		if(note == null)
			return;


		PlayState.instance.notes.remove(note,true);

		note.destroy();
	}


	static function hideOpponentStrums()
	{
		if(PlayState.instance == null)
			return;


		if(PlayState.instance.opponentStrums != null)
			PlayState.instance.opponentStrums.visible = false;
	}


	static function showOpponentStrums()
	{
		if(PlayState.instance == null)
			return;


		if(PlayState.instance.opponentStrums != null)
			PlayState.instance.opponentStrums.visible = true;
	}
}