extends "./async_io_strategy.gd"


func _init() -> void:
	_io_manager = AsyncIOManager.new(AsyncIOManager.JSONSerializationStrategy.new())


## 是否为有效的存档文件
func is_valid_save_file(file_name: String) -> bool:
	return file_name.ends_with(".json")


## 获取存档名
func get_save_name_from_file(file_name: String) -> String:
	return file_name.trim_suffix(".json")


## 获取存档路径
func get_save_path(directory: String, save_name: String) -> String:
	directory += "/" + save_name
	return directory.path_join("%s.json" % save_name)
	
## 获取导出存档的绝对路径
## @param directory：指定的存档文件夹
## @param save_name：存档文件名
func get_absolute_path(directory: String, save_name: String) -> String:
	return directory.path_join("%s.json" % save_name)
