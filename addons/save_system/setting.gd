extends RefCounted

const SETTING_SAVE_SYSTEM: String = "save_system/"
const SETTING_SAVE_SYSTEM_DEFAULTS := SETTING_SAVE_SYSTEM + "defaults/"
const SETTING_SAVE_SYSTEM_AUTO_SAVE := SETTING_SAVE_SYSTEM + "auto_save/"

const SETTING_INFO_DICT: Dictionary[StringName, Dictionary] = {
	"save_system/defaults/save_directory":
	{
		"name": SETTING_SAVE_SYSTEM_DEFAULTS + "save_directory",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_DIR,
		"hint_string": "存档路径",
		"basic": true,
		"default": "user://saves",  # 添加默认值
	},
	"save_system/defaults/save_group":
	{
		"name": SETTING_SAVE_SYSTEM_DEFAULTS + "save_group",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"basic": true,
		"default": "saveable",
	},
	"save_system/defaults/serialization_format":
	{
		"name": SETTING_SAVE_SYSTEM_DEFAULTS + "serialization_format",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "binary,json,resource",
		"basic": true,
		"default": "",
	},
	"save_system/defaults/encryption_key":
	{
		"name": SETTING_SAVE_SYSTEM_DEFAULTS + "encryption_key",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"basic": true,
		"default": "123456",
	},
	"save_system/auto_save/enabled":
	{
		"name": SETTING_SAVE_SYSTEM_AUTO_SAVE + "enabled",
		"type": TYPE_BOOL,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"basic": true,
		"default": true,
	},
	"save_system/auto_save/interval_seconds":
	{
		"name": SETTING_SAVE_SYSTEM_AUTO_SAVE + "interval_seconds",
		"type": TYPE_FLOAT,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"basic": true,
		"default": 300.0,
	},
	"save_system/auto_save/max_saves":
	{
		"name": SETTING_SAVE_SYSTEM_AUTO_SAVE + "max_saves",
		"type": TYPE_INT,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"basic": true,
		"default": 3,
	},
	"save_system/auto_save/name_prefix":
	{
		"name": SETTING_SAVE_SYSTEM_AUTO_SAVE + "name_prefix",
		"type": TYPE_STRING,
		"hint": PROPERTY_HINT_NONE,
		"hint_string": "",
		"basic": true,
		"default": "auto_",
	},
}


## 设置路径和字典名称里只要填对一个就能得到参数的傻瓜方法
static func get_setting_value(setting_name: StringName, default_value: Variant = null) -> Variant:
	var setting_dict: Dictionary = {}

	if SETTING_INFO_DICT.has(setting_name):
		setting_dict = SETTING_INFO_DICT.get(setting_name)
		setting_name = setting_dict.get("name")

	if setting_dict.is_empty():
		for dict in SETTING_INFO_DICT.values():
			if dict.get("name") == setting_name:
				setting_dict = dict
				break

	if setting_dict.has("default") && default_value == null:
		default_value = setting_dict.get("default")

	return ProjectSettings.get_setting(setting_name, default_value)
