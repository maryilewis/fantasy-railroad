extends Node
## Handles what clicking does and so on

#region cursor states
enum CursorState {FREE, SELECTING_TRAIN_DESTINATION, BUILDING}
var cursor_state: CursorState = CursorState.FREE

func set_train_destination(node):
	TrainService.set_target_train_destination(node)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
