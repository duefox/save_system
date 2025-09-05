# hash_manager.gd
extends RefCounted
class_name HashManager

const CHUNK_SIZE = 1024


## 对文件或字符串进行哈希。
## [param data] 文件路径（字符串）或要哈希的字符串。
## [param type] 哈希算法类型 (e.g., HashingContext.HASH_MD5).
static func _hash_data(data: String, type: int) -> String:
	var ctx = HashingContext.new()
	ctx.start(type)

	var is_file = false
	var file = null
	var hash_bytes = PackedByteArray()

	if typeof(data) == TYPE_STRING:
		if FileAccess.file_exists(data):
			is_file = true
			file = FileAccess.open(data, FileAccess.READ)
		else:
			# 如果是字符串，直接转换为字节数组。
			hash_bytes = data.to_utf8_buffer()
	else:
		push_error("Unsupported data type. Must be a file path string or a string.")
		return ""

	if is_file:
		if not file:
			push_error("Failed to open file: " + data)
			return ""
		# 分块读取文件。
		while file.get_position() < file.get_length():
			var remaining = file.get_length() - file.get_position()
			ctx.update(file.get_buffer(min(remaining, CHUNK_SIZE)))
		file.close()
	else:
		# 更新字符串哈希。
		ctx.update(hash_bytes)

	var res = ctx.finish()
	if res.is_empty():
		push_error("Failed to finish hashing.")
		return ""

	return res.hex_encode()


## 对文件或字符串进行 MD5 哈希。
## [param data] 文件路径（字符串）或要哈希的字符串。
static func hash_md5(data: String) -> String:
	return _hash_data(data, HashingContext.HASH_MD5)


## 对文件或字符串进行 SHA-256 哈希。
## [param data] 文件路径（字符串）或要哈希的字符串。
static func hash_sha256(data: String) -> String:
	return _hash_data(data, HashingContext.HASH_SHA256)


## 对文件或字符串进行 SHA-1 哈希。
## [param data] 文件路径（字符串）或要哈希的字符串。
static func hash_sha1(data: String) -> String:
	return _hash_data(data, HashingContext.HASH_SHA1)
