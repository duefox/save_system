extends RefCounted

## 存档格式策略接口


## 是否为有效的存档文件
## [param file_name] 文件名称
## [return] 是否存在有效的存档文件
func is_valid_save_file(file_name: String) -> bool:
	return false


## 从文件名获取存档ID
## [param file_name] 文件名称
## [return] 存档ID
func get_save_name_from_file(file_name: String) -> String:
	return ""


## 获取存档路径
## [param directory]
## [param save_name] 存档ID
## [return] 存档路径
func get_save_path(directory: String, save_name: String) -> String:
	return ""


## 获取存档绝对路径
## [param directory] 存档文件夹路径
## [param save_name] 存档文件名
## [return] 存档路径
func get_absolute_path(directory: String, save_name: String) -> String:
	return ""


## 保存数据
## [param path] 存档路径
## [param data] 存储数据
## [param callback] 完成回调，参数bool是否完成
func save(path: String, data: Dictionary, with_metadata: bool = true) -> bool:
	return false


## 加载数据
## [param path] 存档路径
## [param callback] 完成回调，参数：bool是否完成，Dictionary存档数据
func load_save(path: String, with_metadata: bool = true) -> Variant:
	if with_metadata:
		return {}
	else:
		return null


## 加载元数据
## [param path] 存档路径
## [param callback] 完成回调，参数：bool是否完成，Dictionary存档元数据
func load_metadata(path: String) -> Dictionary:
	return {}


## 删除存档 (实际是删除包含该存档的整个文件夹)
## [param path] 存档的具体文件路径 (例如 .../save_1/save_1.tres)
## [return] 是否删除成功
func delete_file(path: String) -> bool:
	# 1. 获取存档所在的文件夹路径
	var folder_path = path.get_base_dir()
	# 2. 检查目录是否存在
	if not DirAccess.dir_exists_absolute(folder_path):
		push_warning("尝试删除不存在的存档目录: " + folder_path)
		return false
	# 3. 安全检查：防止意外删除根目录
	# 如果 folder_path 恰好等于你的存档根目录 (save_directory)，则不应该删除
	if folder_path.replace("user://", "").replace("res://", "").strip_edges() == "":
		return false
	# 4. 执行递归删除
	_delete_directory_recursive(folder_path)
	# 5. 验证结果：如果文件夹不存在了，说明删除成功
	return not DirAccess.dir_exists_absolute(folder_path)


## [私有辅助函数] 递归删除目录及其内容
func _delete_directory_recursive(dir_path: String) -> void:
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				# 跳过当前目录和父目录标识
				if file_name != "." and file_name != "..":
					# 递归处理子文件夹
					_delete_directory_recursive(dir_path.path_join(file_name))
			else:
				# 删除文件
				dir.remove(file_name)
			file_name = dir.get_next()
		# 清空后，删除文件夹本身 (必须使用 absolute 路径)
		DirAccess.remove_absolute(dir_path)
	else:
		push_error("无法访问目录进行删除: " + dir_path)


## 列出文件
## [param directory] 存档目录
## [return] 文件列表
func list_files(directory: String) -> Array:
	var files := []
	var dir := DirAccess.open(directory)
	if not dir:
		return files

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while not file_name.is_empty():
		if file_name != "." and file_name != ".." and not dir.current_is_dir():
			if is_valid_save_file(file_name):
				files.append(file_name)
		file_name = dir.get_next()
	dir.list_dir_end()
	return files
