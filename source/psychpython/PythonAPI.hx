package psychpython;

class PythonAPI
{
	public static function setup(script:PythonScript)
	{
		PythonReflection.setup(script);
		PythonClassAccess.setup(script);
		PythonSprites.setup(script);
		PythonText.setup(script);

		PythonTweens.setup(script);
		PythonTimers.setup(script);

		PythonCamera.setup(script);

		PythonSound.setup(script);

		PythonEvents.setup(script);
		PythonCommunication.setup(script);
		PythonCharacters.setup(script);
		PythonScripts.setup(script);
		PythonShader.setup(script);

		PythonVariables.setup(script);

		PythonDebug.setup(script);
		PythonHScript.setup(script);
		PythonGroups.setup(script);

		PythonNotes.setup(script);

		PythonUtils.setup(script);
	}
}