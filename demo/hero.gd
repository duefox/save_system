extends Sprite2D
class_name Hero

@export var hero_position: Vector2 = Vector2.ZERO

# 运动时长（秒）
@export var duration: float = 4.0
# 运动距离（像素）
@export var distance: float = 400.0

var _is_forward: bool = true  # 标记当前是向前还是向后移动
var tween: Tween


func _ready() -> void:
	# 注册需要序列化的属性
	SaveSystem.register_saveable_node(self)


func _start_tween():
	# 创建一个新的 Tween
	tween = create_tween()
	# 根据移动方向确定目标位置
	var target_x: float
	if _is_forward:
		target_x = position.x + distance
	else:
		target_x = position.x - distance
	# 改变方向
	_is_forward = not _is_forward
	# tween 移动，使用 Trans.LINEAR 可以实现匀速直线运动
	tween.tween_property(self, "position:x", target_x, duration).set_trans(Tween.TRANS_LINEAR)
	# 动画结束时，重新启动
	await tween.finished
	_start_tween()


func save() -> Dictionary:
	print("begin save hero.")
	if tween:
		tween.kill()
	return {
		"hero_position": position,
	}


func load_data(data: Dictionary) -> void:
	print("load hero data from save")
	hero_position = data.get("hero_position", hero_position)
	position = hero_position

	# 循环运动
	_start_tween()
