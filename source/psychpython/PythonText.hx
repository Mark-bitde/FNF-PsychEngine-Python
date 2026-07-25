#if PYTHON_ALLOWED
package psychpython;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import states.PlayState;

class PythonText
{
	public static var texts:Map<String, FlxText> = new Map();

	public static function setup(script:PythonScript)
	{
		// 1. Создание текста (makePyText)
		script.set("makePyText", function(tag:Dynamic, text:Dynamic, width:Dynamic, x:Dynamic, y:Dynamic)
		{
			makePyTextInternal(cleanTag(tag), Std.string(text), Std.int(width), Std.parseFloat(x), Std.parseFloat(y));
		});

		// 2. Добавление на экран (addPyText)
		script.set("addPyText", function(tag:Dynamic)
		{
			var clean = cleanTag(tag);
			if (PlayState.instance == null || !texts.exists(clean)) return;
			
			var textObj = texts.get(clean);
			PlayState.instance.add(textObj);
		});

		// 3. Удаление текста (removePyText)
		script.set("removePyText", function(tag:Dynamic, ?destroy:Dynamic)
		{
			removePyTextInternal(cleanTag(tag), destroy == null ? true : destroy);
		});

		// 4. Изменение самого текста (setTextString)
		script.set("setTextString", function(tag:Dynamic, text:Dynamic)
		{
			var clean = cleanTag(tag);
			if (texts.exists(clean))
				texts.get(clean).text = Std.string(text);
		});

		// 5. Изменение размера шрифта (setTextSize)
		script.set("setTextSize", function(tag:Dynamic, size:Dynamic)
		{
			var clean = cleanTag(tag);
			if (texts.exists(clean)) {
				var txt = texts.get(clean);
				txt.size = Std.int(size);
				txt.updateHitbox();
			}
		});

		// 6. Изменение цвета текста (setTextColor)
		script.set("setTextColor", function(tag:Dynamic, color:Dynamic)
		{
			var clean = cleanTag(tag);
			if (texts.exists(clean)) {
				var colorStr:String = Std.string(color);
				if (!StringTools.startsWith(colorStr, "0x") && !StringTools.startsWith(colorStr, "#")) {
					colorStr = "0xFF" + colorStr;
				}
				texts.get(clean).color = FlxColor.fromString(colorStr);
			}
		});

		// 7. Изменение шрифта (setTextFont)
		script.set("setTextFont", function(tag:Dynamic, font:Dynamic)
		{
			var clean = cleanTag(tag);
			if (texts.exists(clean)) {
				texts.get(clean).font = backend.Paths.font(Std.string(font));
			}
		});

		// 8. Изменение выравнивания (setTextAlignment)
		script.set("setTextAlignment", function(tag:Dynamic, alignment:Dynamic)
		{
			var clean = cleanTag(tag);
			if (texts.exists(clean)) {
				var alignStr = Std.string(alignment).toLowerCase();
				var align:FlxTextAlign = LEFT;
				if (alignStr == 'center') align = CENTER;
				else if (alignStr == 'right') align = RIGHT;
				else if (alignStr == 'justify') align = JUSTIFY;
				
				texts.get(clean).alignment = align;
			}
		});

		// 9. Изменение обводки/границ (setTextBorder)
		script.set("setTextBorder", function(tag:Dynamic, size:Dynamic, color:Dynamic)
		{
			var clean = cleanTag(tag);
			if (texts.exists(clean)) {
				var colorStr:String = Std.string(color);
				if (!StringTools.startsWith(colorStr, "0x") && !StringTools.startsWith(colorStr, "#")) {
					colorStr = "0xFF" + colorStr;
				}
				var borderStyle:FlxTextBorderStyle = OUTLINE;
				texts.get(clean).setBorderStyle(borderStyle, FlxColor.fromString(colorStr), Std.parseFloat(size));
			}
		});

		// 10. Привязка к камере HUD/Game (setObjectCamera)
		script.set("setObjectCamera", function(tag:Dynamic, camera:Dynamic)
		{
			var clean = cleanTag(tag);
			if (texts.exists(clean) && PlayState.instance != null) {
				var camStr = Std.string(camera).toLowerCase();
				var txt = texts.get(clean);
				if (camStr == 'hud' || camStr == 'camhud') {
					txt.cameras = [PlayState.instance.camHUD];
				} else if (camStr == 'other' || camStr == 'camother') {
					txt.cameras = [PlayState.instance.camOther];
				} else {
					txt.cameras = [PlayState.instance.camGame];
				}
			}
		});

		// 11. ПОЛНОЦЕННЫЙ setProperty КАК В LUA PSYCH ENGINE
		script.set("setProperty", function(target:Dynamic, value:Dynamic)
		{
			var targetStr:String = cleanTag(target);
			var split:Array<String> = targetStr.split('.');
			
			if (texts.exists(split[0])) {
				var obj:Dynamic = texts.get(split[0]);
				if (split.length > 1) {
					split.shift();
					setObjectProperty(obj, split, value);
				}
				
				// Фикс альфы для FlxText
				if (targetStr.toLowerCase().indexOf('alpha') != -1) {
					var txt = texts.get(targetStr.split('.')[0]);
					if (txt != null) txt.dirty = true;
				}
				return;
			}
			
			if (PlayState.instance != null) {
				setObjectProperty(PlayState.instance, split, value);
			}
		});

		// 12. ПОЛНОЦЕННЫЙ getProperty КАК В LUA PSYCH ENGINE
		script.set("getProperty", function(target:Dynamic):Dynamic
		{
			var targetStr:String = cleanTag(target);
			var split:Array<String> = targetStr.split('.');
			
			if (texts.exists(split[0])) {
				var obj:Dynamic = texts.get(split[0]);
				if (split.length > 1) {
					split.shift();
					return getObjectProperty(obj, split);
				}
				return obj;
			}
			
			if (PlayState.instance != null) {
				return getObjectProperty(PlayState.instance, split);
			}
			return null;
		});
	}

	// Кастомные рекурсивные утилиты Reflection, независимые от LuaUtils движка
	private static function setObjectProperty(obj:Dynamic, properties:Array<String>, value:Dynamic):Void {
		if (obj == null || properties.length == 0) return;
		
		var currentProp = properties[0];
		if (properties.length == 1) {
			try {
				Reflect.setProperty(obj, currentProp, value);
			} catch(e:Dynamic) {}
		} else {
			var nextObj = null;
			try {
				nextObj = Reflect.getProperty(obj, currentProp);
			} catch(e:Dynamic) {}
			if (nextObj != null) {
				properties.shift();
				setObjectProperty(nextObj, properties, value);
			}
		}
	}

	private static function getObjectProperty(obj:Dynamic, properties:Array<String>):Dynamic {
		if (obj == null || properties.length == 0) return null;
		
		var currentProp = properties[0];
		var nextObj = null;
		try {
			nextObj = Reflect.getProperty(obj, currentProp);
		} catch(e:Dynamic) {}
		
		if (properties.length == 1) {
			return nextObj;
		} else {
			if (nextObj != null) {
				properties.shift();
				return getObjectProperty(nextObj, properties);
			}
		}
		return null;
	}

	private static function cleanTag(tag:Dynamic):String {
		var str = StringTools.trim(Std.string(tag));
		if (StringTools.startsWith(str, "'") && StringTools.endsWith(str, "'")) str = str.substring(1, str.length - 1);
		if (StringTools.startsWith(str, '"') && StringTools.endsWith(str, '"')) str = str.substring(1, str.length - 1);
		return StringTools.trim(str);
	}

	static function makePyTextInternal(tag:String, text:String, width:Int, x:Float, y:Float)
	{
		if (PlayState.instance == null) return;

		if (texts.exists(tag))
			removePyTextInternal(tag, true);

		var textObject = new FlxText(x, y, width, text, 16);
		textObject.setFormat(backend.Paths.font("vcr.ttf"), 16, FlxColor.WHITE, LEFT);
		textObject.cameras = [PlayState.instance.camHUD];
		textObject.antialiasing = backend.ClientPrefs.data.antialiasing;

		texts.set(tag, textObject);
	}

	static function removePyTextInternal(tag:String, destroy:Bool)
	{
		if (texts.exists(tag))
		{
			var textObject = texts.get(tag);
			if (PlayState.instance != null)
				PlayState.instance.remove(textObject);

			if (destroy)
			{
				textObject.destroy();
				texts.remove(tag);
			}
		}
	}

	public static function clearTexts()
	{
		for (text in texts.iterator())
		{
			if (text != null)
				text.destroy();
		}
		texts.clear();
	}
}
#end
