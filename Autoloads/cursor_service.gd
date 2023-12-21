extends Node
## Handles what clicking does and so on

#region cursor states
enum CursorState {FREE, SELECTING_TRAIN_DESTINATION, BUILDING}
var cursor_state: CursorState = CursorState.FREE


func free_cursor():
	cursor_state = CursorState.FREE
	for train in TrainService.trains:
		train.enable_click()

# TODO put this in town menu instead of button/cursor state
# That means you need a menu for clicking random road as well 🙃
func set_selecting_train_destination():
	cursor_state = CursorState.SELECTING_TRAIN_DESTINATION
	TrainService.enable_train_click() # you probably aren't going to click where the train currently is
	
func set_building():
	cursor_state = CursorState.BUILDING
	TrainService.disable_train_click()

func set_train_destination(node):
	if (cursor_state == CursorState.SELECTING_TRAIN_DESTINATION):
		cursor_state = CursorState.FREE
		TrainService.set_target_train_destination(node)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
