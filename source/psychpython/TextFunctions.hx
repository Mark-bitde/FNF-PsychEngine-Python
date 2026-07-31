package psychpython;

class TextFunctions
{
	public static function implement(pyFunk:FunkinPython)
	{
		var py = pyFunk.interp;
		py.setVar("makePyText", function(tag:String, ?text:String = '', ?width:Int = 0, ?x:Float = 0, ?y:Float = 0) {
			tag = tag.replace('.', '');

			PyUtils.destroyObject(tag);
			var leText:FlxText = new FlxText(x, y, width, text, 16);
			leText.setFormat(Paths.font("vcr.ttf"), 16, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			if(PlayState.instance != null) leText.cameras = [PlayState.instance.camHUD];
			leText.scrollFactor.set();
			leText.borderSize = 2;
			MusicBeatState.getVariables().set(tag, leText);
		});
        py.setVar("setTextString", function(tag:String, text:String) {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				obj.text = text;
				return true;
			}
			FunkinPython.pythonTrace("setTextString: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		py.setVar("setTextSize", function(tag:String, size:Int) {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				obj.size = size;
				return true;
			}
			FunkinPython.pythonTrace("setTextSize: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		py.setVar("setTextWidth", function(tag:String, width:Float) {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				obj.fieldWidth = width;
				return true;
			}
			FunkinPython.pythonTrace("setTextWidth: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		py.setVar("setTextHeight", function(tag:String, height:Float) {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				obj.fieldHeight = height;
				return true;
			}
			FunkinPython.pythonTrace("setTextHeight: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		py.setVar("setTextAutoSize", function(tag:String, value:Bool) {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				obj.autoSize = value;
				return true;
			}
			FunkinPython.pythonTrace("setTextAutoSize: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
	    py.setVar("setTextBorder", function(tag:String, size:Float, color:String, ?style:String = 'outline') {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				CoolUtil.setTextBorderFromString(obj, (size > 0 ? style : 'none'));
				if(size > 0)
					obj.borderSize = size;
				
				obj.borderColor = CoolUtil.colorFromString(color);
				return true;
			}
			FunkinPython.pythonTrace("setTextBorder: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		py.setVar("setTextColor", function(tag:String, color:String) {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				obj.color = CoolUtil.colorFromString(color);
				return true;
			}
			FunkinPython.pythonTrace("setTextColor: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		py.setVar("setTextFont", function(tag:String, newFont:String) {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				obj.font = Paths.font(newFont);
				return true;
			}
			FunkinPython.pythonTrace("setTextFont: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		py.setVar("setTextItalic", function(tag:String, italic:Bool) {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				obj.italic = italic;
				return true;
			}
			FunkinPython.pythonTrace("setTextItalic: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});
		py.setVar("setTextAlignment", function(tag:String, alignment:String = 'left') {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				obj.alignment = LEFT;
				switch(alignment.trim().toLowerCase())
				{
					case 'right':
						obj.alignment = RIGHT;
					case 'center':
						obj.alignment = CENTER;
					case 'justify':
						obj.alignment = JUSTIFY;
				}
				return true;
			}
			FunkinPython.pythonTrace("setTextAlignment: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return false;
		});

		py.setVar("getTextString", function(tag:String) {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null && obj.text != null)
			{
				return obj.text;
			}
			FunkinPython.pythonTrace("getTextString: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return null;
		});
		py.setVar("getTextSize", function(tag:String) {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				return obj.size;
			}
			FunkinPython.pythonTrace("getTextSize: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return -1;
		});
	    py.setVar("getTextFont", function(tag:String) {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				return obj.font;
			}
			FunkinPython.pythonTrace("getTextFont: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return null;
		});
		py.setVar("getTextWidth", function(tag:String) {
			var split:Array<String> = tag.split('.');
			var obj:FlxText = split.length > 1 ? (PyUtils.getVarInArray(PyUtils.getPropertyLoop(split), split[split.length-1])) : PyUtils.getObjectDirectly(split[0]);
			if(obj != null)
			{
				return obj.fieldWidth;
			}
			FunkinPython.pythonTrace("getTextWidth: Object " + tag + " doesn't exist!", false, false, FlxColor.RED);
			return 0;
		});

		py.setVar("addPyText", function(tag:String) {
			var text:FlxText = MusicBeatState.getVariables().get(tag);
			if(text != null) PyUtils.getTargetInstance().add(text);
		});
		py.setVar("removePyText", function(tag:String, destroy:Bool = true) {
			var variables = MusicBeatState.getVariables();
			var text:FlxText = variables.get(tag);
			if(text == null) return;

			var instance:Dynamic = CustomSubstate.instance != null ? CustomSubstate.instance : PyUtils.getTargetInstance();
			instance.remove(text, true);
			if(destroy)
			{
				text.destroy();
				variables.remove(tag);
			}
		});
	}
}