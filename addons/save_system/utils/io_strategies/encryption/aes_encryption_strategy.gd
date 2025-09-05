# aes_encryption_strategy.gd
extends "./encryption_strategy.gd"

# AES 加密操作的块大小，固定为 16 字节
const BLOCK_SIZE = 16


## @desc PKCS#7 填充函数。
## 在加密前，将数据填充到 16 字节的倍数。
## @param bytes: 要填充的 PackedByteArray。
## @return: 填充后的 PackedByteArray。
func _pad_data(bytes: PackedByteArray) -> PackedByteArray:
	# 计算需要填充的字节数
	var padding_size = BLOCK_SIZE - (bytes.size() % BLOCK_SIZE)
	# 如果数据已经是 16 字节的倍数，则填充 16 个字节
	if padding_size == 0:
		padding_size = BLOCK_SIZE

	var padded_bytes = bytes.duplicate()
	# 追加填充字节，每个字节的值等于填充的字节数
	for i in range(padding_size):
		padded_bytes.append(padding_size)
	return padded_bytes


## @desc PKCS#7 移除填充函数。
## 在解密后，移除数据末尾的填充字节。
## @param bytes: 填充后的 PackedByteArray。
## @return: 移除填充后的 PackedByteArray。
func _unpad_data(bytes: PackedByteArray) -> PackedByteArray:
	if bytes.is_empty():
		return PackedByteArray()
	# 获取最后一个字节的值，即填充的字节数
	var padding_size = bytes[bytes.size() - 1]

	# 检查填充的字节数是否合法
	if padding_size > bytes.size():
		push_error("Invalid padding. Possible data corruption.")
		return bytes

	# 返回不包含填充字节的切片
	return bytes.slice(0, bytes.size() - padding_size)


## @desc AES-256-CBC 加密实现。
## @param bytes: 要加密的 PackedByteArray。
## @param key: 32 字节的加密密钥。
## @return: 包含 IV 和密文的 PackedByteArray。
func encrypt(bytes: PackedByteArray, key: PackedByteArray) -> PackedByteArray:
	if key.size() != 32:
		push_error("AES encrypt: Invalid key size. Key must be 32 bytes.")
		return PackedByteArray()

	# 正确生成一个随机的 16 字节 IV
	var rng = RandomNumberGenerator.new()
	var iv = PackedByteArray()
	iv.resize(BLOCK_SIZE)
	for i in range(BLOCK_SIZE):
		iv[i] = rng.randi_range(0, 255)

	# 在加密前进行填充
	var padded_bytes = _pad_data(bytes)

	var aes = AESContext.new()
	# 使用 CBC 模式和生成的 IV 初始化加密上下文
	aes.start(AESContext.MODE_CBC_ENCRYPT, key, iv)

	# 调用 update() 方法执行加密，它会返回完整的加密数据
	var encrypted_bytes = aes.update(padded_bytes)
	# 调用 finish() 完成操作，不返回数据
	aes.finish()

	# 将 IV 附加到加密数据的开头，方便解密时读取
	var final_data = PackedByteArray()
	final_data.append_array(iv)
	final_data.append_array(encrypted_bytes)

	return final_data


## @desc AES-256-CBC 解密实现。
## @param bytes: 包含 IV 和密文的 PackedByteArray。
## @param key: 32 字节的解密密钥。
## @return: 解密后移除填充的 PackedByteArray。
func decrypt(bytes: PackedByteArray, key: PackedByteArray) -> PackedByteArray:
	if key.size() != 32:
		push_error("AES decrypt: Invalid key size. Key must be 32 bytes.")
		return PackedByteArray()

	# 检查数据长度是否足够包含 IV
	if bytes.size() < BLOCK_SIZE:
		push_warning("AES decrypt: Data is too short to contain a 16-byte IV.")
		return PackedByteArray()

	# 从数据开头提取 IV
	var iv = bytes.slice(0, BLOCK_SIZE)
	# 提取剩余的加密数据
	var encrypted_data = bytes.slice(BLOCK_SIZE)

	var aes = AESContext.new()
	# 使用提取的 IV 初始化解密上下文
	aes.start(AESContext.MODE_CBC_DECRYPT, key, iv)

	# 调用 update() 方法执行解密
	var decrypted_bytes = aes.update(encrypted_data)
	# 调用 finish() 完成操作
	aes.finish()

	# 解密后移除填充
	return _unpad_data(decrypted_bytes)
