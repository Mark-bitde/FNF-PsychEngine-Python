#if PYTHON_ALLOWED
package psychpython;

class PythonCallbacks
{

	public static function onCreate()
	{
		PythonManager.call("onCreate");
	}


	public static function onCreatePost()
	{
		PythonManager.call("onCreatePost");
	}


	public static function onDestroy()
	{
		PythonManager.call("onDestroy");
	}



	public static function onUpdate(elapsed:Float)
	{
		PythonManager.call(
			"onUpdate",
			[elapsed]
		);
	}


	public static function onUpdatePost(elapsed:Float)
	{
		PythonManager.call(
			"onUpdatePost",
			[elapsed]
		);
	}



	public static function onStartCountdown():Dynamic
	{
		return PythonManager.call(
			"onStartCountdown"
		);
	}


	public static function onCountdownStarted()
	{
		PythonManager.call(
			"onCountdownStarted"
		);
	}


	public static function onCountdownTick(counter:Int)
	{
		PythonManager.call(
			"onCountdownTick",
			[counter]
		);
	}



	public static function onSongStart()
	{
		PythonManager.call(
			"onSongStart"
		);
	}


	public static function onEndSong():Dynamic
	{
		return PythonManager.call(
			"onEndSong"
		);
	}



	public static function onBeatHit()
	{
		PythonManager.call(
			"onBeatHit"
		);
	}


	public static function onStepHit()
	{
		PythonManager.call(
			"onStepHit"
		);
	}


	public static function onSectionHit()
	{
		PythonManager.call(
			"onSectionHit"
		);
	}



	public static function onEvent(
		name:String,
		value1:String,
		value2:String
	)
	{
		PythonManager.call(
			"onEvent",
			[
				name,
				value1,
				value2
			]
		);
	}



	public static function goodNoteHit(
		index:Int,
		noteData:Int,
		noteType:String,
		isSustain:Bool
	)
	{
		PythonManager.call(
			"goodNoteHit",
			[
				index,
				noteData,
				noteType,
				isSustain
			]
		);
	}



	public static function opponentNoteHit(
		index:Int,
		noteData:Int,
		noteType:String,
		isSustain:Bool
	)
	{
		PythonManager.call(
			"opponentNoteHit",
			[
				index,
				noteData,
				noteType,
				isSustain
			]
		);
	}



	public static function noteMiss(
		index:Int,
		noteData:Int,
		noteType:String,
		isSustain:Bool
	)
	{
		PythonManager.call(
			"noteMiss",
			[
				index,
				noteData,
				noteType,
				isSustain
			]
		);
	}


	public static function noteMissPress(direction:Int)
	{
		PythonManager.call(
			"noteMissPress",
			[
				direction
			]
		);
	}



	public static function onGhostTap(key:Int)
	{
		PythonManager.call(
			"onGhostTap",
			[
				key
			]
		);
	}



	public static function onKeyPressPre(key:Int):Dynamic
	{
		return PythonManager.call(
			"onKeyPressPre",
			[
				key
			]
		);
	}


	public static function onKeyPress(key:Int)
	{
		PythonManager.call(
			"onKeyPress",
			[
				key
			]
		);
	}


	public static function onKeyReleasePre(key:Int):Dynamic
	{
		return PythonManager.call(
			"onKeyReleasePre",
			[
				key
			]
		);
	}


	public static function onKeyRelease(key:Int)
	{
		PythonManager.call(
			"onKeyRelease",
			[
				key
			]
		);
	}



	public static function onMoveCamera(focus:String)
	{
		PythonManager.call(
			"onMoveCamera",
			[
				focus
			]
		);
	}



	public static function onPause()
	{
		PythonManager.call(
			"onPause"
		);
	}


	public static function onResume()
	{
		PythonManager.call(
			"onResume"
		);
	}



	public static function onTweenCompleted(tag:String)
	{
		PythonManager.call(
			"onTweenCompleted",
			[
				tag
			]
		);
	}



	public static function onTimerCompleted(
		tag:String,
		loops:Int,
		loopsLeft:Int
	)
	{
		PythonManager.call(
			"onTimerCompleted",
			[
				tag,
				loops,
				loopsLeft
			]
		);
	}



	public static function onSpawnNote(
		index:Int,
		noteData:Int,
		noteType:String,
		isSustain:Bool
	)
	{
		PythonManager.call(
			"onSpawnNote",
			[
				index,
				noteData,
				noteType,
				isSustain
			]
		);
	}



	public static function onFocus()
	{
		PythonManager.call(
			"onFocus"
		);
	}


	public static function onFocusLost()
	{
		PythonManager.call(
			"onFocusLost"
		);
	}



	public static function onNextDialogue(count:Int)
	{
		PythonManager.call(
			"onNextDialogue",
			[count]
		);
	}



	public static function onSkipDialogue(count:Int)
	{
		PythonManager.call(
			"onSkipDialogue",
			[count]
		);
	}



	public static function onGameOver()
	{
		PythonManager.call(
			"onGameOver"
		);
	}


	public static function onGameOverStart()
	{
		PythonManager.call(
			"onGameOverStart"
		);
	}


	public static function onGameOverConfirm(yes:Bool)
	{
		PythonManager.call(
			"onGameOverConfirm",
			[
				yes
			]
		);
	}



	public static function onRecalculateRating()
	{
		PythonManager.call(
			"onRecalculateRating"
		);
	}


	public static function onUpdateScore(miss:Bool)
	{
		PythonManager.call(
			"onUpdateScore",
			[
				miss
			]
		);
	}



	public static function onDisplayUpdate()
	{
		PythonManager.call(
			"onDisplayUpdate"
		);
	}



	public static function onCreatePostEvent(name:String)
	{
		PythonManager.call(
			"onCreatePostEvent",
			[name]
		);
	}

}
#end