extends Resource

## 游戏状态数据

## 存档元数据
@export var metadata: Dictionary = {
	"id": "",
	"save_name": "",
	"timestamp": 0,
	"save_date": "",
	"game_version": "",
	"playtime": 0.0,
}
## 节点状态
@export var nodes_state: Array[Dictionary] = []


func _init(
	p_id: StringName = "",
	p_save_name: StringName = "",
	p_timestamp: int = 0,
	p_save_date: String = "",
	p_game_version: String = "",
	p_playtime: float = 0.0,
) -> void:
	metadata.id = p_id
	metadata.save_name = p_save_name
	metadata.timestamp = p_timestamp
	metadata.save_date = p_save_date
	metadata.game_version = p_game_version
	metadata.playtime = p_playtime
