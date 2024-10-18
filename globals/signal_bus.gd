extends Node

signal cancel
signal energy_updated
signal cursor_pointer
signal cursor_arrow
signal new_turn
signal moved(new_position: Vector2, old_position: Vector2)
signal start
signal reset
signal level_complete
signal trigger_dialogue(title: String)
signal dialogue_triggered
signal show_tooltip(text: String)
signal hide_tooltip
signal pause_animation
signal resume_animation
signal open_options
signal open_credits
signal allow_continue
signal no_continue
signal open_menu
signal return_to_menu
