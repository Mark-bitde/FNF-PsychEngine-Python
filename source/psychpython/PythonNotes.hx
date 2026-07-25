package psychpython;

import states.PlayState;
import objects.Note;
import objects.StrumNote;

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
				// Универсальный твин нот для Python, использующий оригинальную функцию Psych Engine
				// Универсальный твин нот для Python, использующий оригинальную функцию Psych Engine
		script.set("pyNoteTween", function(tag:String, note:Int, value:Float, duration:Float, ease:String, type:String)
		{
			var data:Dynamic = {};
			var cleanType = StringTools.trim(type).toLowerCase();
			
			if (cleanType == 'x') data = {x: value};
			else if (cleanType == 'y') data = {y: value};
			else if (cleanType == 'angle') data = {angle: value};
			else if (cleanType == 'alpha') data = {alpha: value};
			else if (cleanType == 'direction') data = {direction: value};

			// [ФИКС ОШИБКИ]: Проверяем, запущены ли Lua-скрипты в игре
			if (states.PlayState.instance != null && states.PlayState.instance.luaArray != null && states.PlayState.instance.luaArray.length > 0) {
				// Берем первый попавшийся активный инстанс FunkinLua
				var activeLua = states.PlayState.instance.luaArray[0];
				if (activeLua != null) {
					try {
						// Вызываем метод у инстанса класса, а не статически!
						Reflect.callMethod(activeLua, Reflect.field(activeLua, "noteTweenFunction"), [tag, note, data, duration, ease]);
					} catch(e:Dynamic) {
						trace("PythonNotes Error: Failed to call noteTweenFunction dynamically: " + e);
					}
				}
			}
		});

	}

	static function getNote(index:Int):Note
	{
		if(PlayState.instance == null || PlayState.instance.notes == null)
			return null;

		if(index < 0 || index >= PlayState.instance.notes.length)
			return null;

		return PlayState.instance.notes.members[index];
	}

	static function setNoteAlpha(index:Int, alpha:Float, opponent:Bool)
	{
		// Если передан флаг opponent, меняем альфу у статичной стрелки (Strum)
		if (opponent && PlayState.instance != null && PlayState.instance.strumLineNotes != null) {
			if (index >= 0 && index < 4) {
				var strum = PlayState.instance.strumLineNotes.members[index];
				if (strum != null) strum.alpha = alpha;
			}
			return;
		}

		// Иначе меняем у летящей ноты
		var note = getNote(index);
		if(note != null)
			note.alpha = alpha;
	}

	static function setNoteAngle(index:Int, angle:Float, opponent:Bool)
	{
		if (opponent && PlayState.instance != null && PlayState.instance.strumLineNotes != null) {
			if (index >= 0 && index < 4) {
				var strum = PlayState.instance.strumLineNotes.members[index];
				if (strum != null) strum.angle = angle;
			}
			return;
		}

		var note = getNote(index);
		if(note != null)
			note.angle = angle;
	}

	static function setNoteScale(index:Int, scale:Float, opponent:Bool)
	{
		if (opponent && PlayState.instance != null && PlayState.instance.strumLineNotes != null) {
			if (index >= 0 && index < 4) {
				var strum = PlayState.instance.strumLineNotes.members[index];
				if (strum != null) {
					strum.scale.set(scale, scale);
					strum.updateHitbox();
				}
			}
			return;
		}

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

		PlayState.instance.notes.remove(note, true);
		note.destroy();
	}

	static function hideOpponentStrums()
	{
		if(PlayState.instance == null || PlayState.instance.strumLineNotes == null)
			return;

		// Скрываем первые 4 стрелки (0, 1, 2, 3), которые принадлежат оппоненту
		for (i in 0...4) {
			var strum = PlayState.instance.strumLineNotes.members[i];
			if (strum != null) strum.visible = false;
		}
	}

	static function showOpponentStrums()
	{
		if(PlayState.instance == null || PlayState.instance.strumLineNotes == null)
			return;

		// Показываем первые 4 стрелки обратно
		for (i in 0...4) {
			var strum = PlayState.instance.strumLineNotes.members[i];
			if (strum != null) strum.visible = true;
		}
	}
}
