#if PYTHON_ALLOWED
package psychpython;

import flixel.FlxG;

import backend.Conductor;
import backend.Difficulty;
import psychlua.LuaUtils;
import backend.Paths;
import backend.Song;
import backend.WeekData;
import objects.NoteSplash;
import states.MainMenuState;
import states.PlayState;
import substates.GameOverSubstate;

import objects.Note;

class PythonGlobals
{
	public static function setup(script:PythonScript)
	{
		var game = PlayState.instance;


		// Lua shit

		script.set(
			"Function_StopLua",
			LuaUtils.Function_StopLua
		);

		script.set(
			"Function_StopHScript",
			LuaUtils.Function_StopHScript
		);

		script.set(
			"Function_StopAll",
			LuaUtils.Function_StopAll
		);

		script.set(
			"Function_Stop",
			LuaUtils.Function_Stop
		);

		script.set(
			"Function_Continue",
			LuaUtils.Function_Continue
		);


		script.set(
			"luaDebugMode",
			false
		);

		script.set(
			"luaDeprecatedWarnings",
			true
		);


		script.set(
			"version",
			MainMenuState.psychEngineVersion.trim()
		);


		// modFolder лучше будет брать из PythonScript,
		// как this.modFolder в FunkinLua
		script.set(
			"modFolder",
			""
		);



		// Song / Week shit

		if(PlayState.SONG != null)
		{
			script.set(
				"bpm",
				PlayState.SONG.bpm
			);

			script.set(
				"scrollSpeed",
				PlayState.SONG.speed
			);

			script.set(
				"songName",
				PlayState.SONG.song
			);

			script.set(
				"songPath",
				Paths.formatToSongPath(
					PlayState.SONG.song
				)
			);

			script.set(
				"curStage",
				PlayState.SONG.stage
			);

			script.set(
				"hasVocals",
				PlayState.SONG.needsVoices
			);
		}


		script.set(
			"curBpm",
			Conductor.bpm
		);

		script.set(
			"crochet",
			Conductor.crochet
		);

		script.set(
			"stepCrochet",
			Conductor.stepCrochet
		);


		if(FlxG.sound.music != null)
		{
			script.set(
				"songLength",
				FlxG.sound.music.length
			);
		}


		script.set(
			"loadedSongName",
			Song.loadedSongName
		);

		script.set(
			"loadedSongPath",
			Paths.formatToSongPath(
				Song.loadedSongName
			)
		);

		script.set(
			"chartPath",
			Song.chartPath
		);


		script.set(
			"startedCountdown",
			false
		);



		// Story

		script.set(
			"isStoryMode",
			PlayState.isStoryMode
		);

		script.set(
			"difficulty",
			PlayState.storyDifficulty
		);

		script.set(
			"difficultyName",
			Difficulty.getString(false)
		);

		script.set(
			"difficultyPath",
			Difficulty.getFilePath()
		);

		script.set(
			"difficultyNameTranslation",
			Difficulty.getString(true)
		);

		script.set(
			"weekRaw",
			PlayState.storyWeek
		);


		
		script.set(
			"week",
			WeekData.weeksList[PlayState.storyWeek]
		);
		


		script.set(
			"seenCutscene",
			PlayState.seenCutscene
		);



		// Screen

		script.set(
			"screenWidth",
			FlxG.width
		);

		script.set(
			"screenHeight",
			FlxG.height
		);



		// PlayState-only variables

		if(game != null)
		@:privateAccess
		{
			var curSection:Dynamic = null;


			if(
				PlayState.SONG != null &&
				PlayState.SONG.notes != null &&
				game.curSection < PlayState.SONG.notes.length
			)
			{
				curSection =
					PlayState.SONG.notes[game.curSection];
			}



			script.set(
				"curSection",
				game.curSection
			);

			script.set(
				"curBeat",
				game.curBeat
			);

			script.set(
				"curStep",
				game.curStep
			);

			script.set(
				"curDecBeat",
				game.curDecBeat
			);

			script.set(
				"curDecStep",
				game.curDecStep
			);



			// Score

			script.set(
				"score",
				game.songScore
			);

			script.set(
				"misses",
				game.songMisses
			);

			script.set(
				"hits",
				game.songHits
			);

			script.set(
				"combo",
				game.combo
			);

			script.set(
				"deaths",
				PlayState.deathCounter
			);



			// Rating

			script.set(
				"rating",
				game.ratingPercent
			);

			script.set(
				"ratingName",
				game.ratingName
			);

			script.set(
				"ratingFC",
				game.ratingFC
			);

			script.set(
				"totalPlayed",
				game.totalPlayed
			);

			script.set(
				"totalNotesHit",
				game.totalNotesHit
			);



			// Section flags

			script.set(
				"inGameOver",
				GameOverSubstate.instance != null
			);

			script.set(
				"mustHitSection",
				curSection != null
					? curSection.mustHitSection
					: false
			);

			script.set(
				"altAnim",
				curSection != null
					? curSection.altAnim
					: false
			);

			script.set(
				"gfSection",
				curSection != null
					? curSection.gfSection
					: false
			);



			// Gameplay

			script.set(
				"healthGainMult",
				game.healthGain
			);

			script.set(
				"healthLossMult",
				game.healthLoss
			);


			#if FLX_PITCH
			script.set(
				"playbackRate",
				game.playbackRate
			);
			#else
			script.set(
				"playbackRate",
				1
			);
			#end


			script.set(
				"guitarHeroSustains",
				game.guitarHeroSustains
			);

			script.set(
				"instakillOnMiss",
				game.instakillOnMiss
			);

			script.set(
				"botPlay",
				game.cpuControlled
			);

			script.set(
				"practice",
				game.practiceMode
			);



			// Strums

			for(i in 0...4)
			{
				script.set(
					"defaultPlayerStrumX" + i,
					0
				);

				script.set(
					"defaultPlayerStrumY" + i,
					0
				);

				script.set(
					"defaultOpponentStrumX" + i,
					0
				);

				script.set(
					"defaultOpponentStrumY" + i,
					0
				);
			}



			// Default character data

			script.set(
				"defaultBoyfriendX",
				game.BF_X
			);

			script.set(
				"defaultBoyfriendY",
				game.BF_Y
			);

			script.set(
				"defaultOpponentX",
				game.DAD_X
			);

			script.set(
				"defaultOpponentY",
				game.DAD_Y
			);

			script.set(
				"defaultGirlfriendX",
				game.GF_X
			);

			script.set(
				"defaultGirlfriendY",
				game.GF_Y
			);



			// Character names

			script.set(
				"boyfriendName",
				game.boyfriend != null
					? game.boyfriend.curCharacter
					: PlayState.SONG.player1
			);

			script.set(
				"dadName",
				game.dad != null
					? game.dad.curCharacter
					: PlayState.SONG.player2
			);

			script.set(
				"gfName",
				game.gf != null
					? game.gf.curCharacter
					: PlayState.SONG.gfVersion
			);
		}

		// Other settings
		script.set('downscroll', ClientPrefs.data.downScroll);
		script.set('middlescroll', ClientPrefs.data.middleScroll);
		script.set('framerate', ClientPrefs.data.framerate);
		script.set('ghostTapping', ClientPrefs.data.ghostTapping);
		script.set('hideHud', ClientPrefs.data.hideHud);
		script.set('timeBarType', ClientPrefs.data.timeBarType);
		script.set('scoreZoom', ClientPrefs.data.scoreZoom);
		script.set(
			"cameraZoomOnBeat",
			ClientPrefs.data.camZooms
		);

		script.set(
			"flashingLights",
			ClientPrefs.data.flashing
		);

		script.set(
			"noteOffset",
			ClientPrefs.data.noteOffset
		);

		script.set(
			"healthBarAlpha",
			ClientPrefs.data.healthBarAlpha
		);

		script.set(
			"noResetButton",
			ClientPrefs.data.noReset
		);

		script.set(
			"lowQuality",
			ClientPrefs.data.lowQuality
		);

		script.set(
			"shadersEnabled",
			ClientPrefs.data.shaders
		);


		// Script info

		script.set(
			"scriptName",
			script.getScriptName()
		);

		script.set(
			"currentModDirectory",
			Mods.currentModDirectory
		);



		// Noteskin / Splash

		script.set(
			"noteSkin",
			ClientPrefs.data.noteSkin
		);

		script.set(
			"noteSkinPostfix",
			Note.getNoteSkinPostfix()
		);

		script.set(
			"splashSkin",
			ClientPrefs.data.splashSkin
		);

		script.set(
			"splashSkinPostfix",
			NoteSplash.getSplashSkinPostfix()
		);

		script.set(
			"splashAlpha",
			ClientPrefs.data.splashAlpha
		);



		// Build target

		script.set(
			"buildTarget",
			LuaUtils.getBuildTarget()
		);
		
	}
}
#end