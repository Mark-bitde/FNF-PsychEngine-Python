package psychpython;

import states.PlayState;

class PythonGlobals
{
	public static function setup(script:PythonScript)
	{
		update(script);
	}

	public static function update(script:PythonScript)
	{
		var ps:PlayState = PlayState.instance;

		if(ps == null)
			return;

		script.set("curBeat", ps.getCurBeat());
		script.set("curStep", ps.getCurStep());

		if(PlayState.SONG != null)
			script.set("songName", PlayState.SONG.song);
	}
}