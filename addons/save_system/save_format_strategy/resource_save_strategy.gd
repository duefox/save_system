extends "./save_format_strategy.gd"

const GameStateData = SaveSystem.GameStateData


## 文件名是否有效
func is_valid_save_file(file_name: String) -> bool:
	return file_name.ends_with(".tres")


## 获取存档ID
func get_save_name_from_file(file_name: String) -> String:
	return file_name.trim_suffix(".tres")


## 获取存档路径
func get_save_path(directory: String, save_name: String) -> String:
	return directory.path_join("%s.tres" % save_name)


## 保存存档
func save(path: String, data: Dictionary, with_metadata: bool = true) -> bool:
	var save_data = data.get("data", null) as Resource
	if with_metadata:
		save_data = (
			GameStateData
			. new(
				data.metadata.id,
				data.metadata.save_name,
				data.metadata.timestamp,
				data.metadata.save_date,
				data.metadata.game_version,
				data.metadata.playtime,
			)
		)
		# 设置节点状态
		save_data.nodes_state = data.nodes

	# 保存资源
	var error = ResourceSaver.save(save_data, path)
	return error == OK


## 加载存档数据
func load_save(path: String, with_metadata: bool = true) -> Variant:
	if not FileAccess.file_exists(path):
		return {}

	var resource = ResourceLoader.load(path)
	if not resource:
		return {}
	if with_metadata:
		var result = {"metadata": resource.metadata, "nodes": resource.nodes_state}
		return result
	else:
		return resource


## 加载元数据
func load_metadata(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var resource = ResourceLoader.load(path)
	if check_has_property(resource, "metadata"):
		return resource.metadata
	else:
		return {}


## 检查对象是否包含指定的属性
func check_has_property(object: Object, property_name: String) -> bool:
	# 确保对象有效
	if not is_instance_valid(object):
		return false
	# 遍历属性列表
	var property_list: Array = object.get_property_list()
	for prop in property_list:
		# prop 是一个包含 "name" 和 "type" 的字典
		if prop.get("name") == property_name:
			return true

	return false
