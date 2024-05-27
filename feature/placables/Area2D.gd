extends Area2D

const MAX_HEALTH = 100
var health = MAX_HEALTH

const DAMAGE_PER_SECOND = 10
const DAMAGE_INTERVAL = 1.0
var last_damage_time = 0.0

func _ready():
	# Nastavi začetno zdravje zidu
	health = MAX_HEALTH
	# Poveži dogodkovne metode
	var area = self
	if not area.is_connected("body_entered", _on_body_entered):
		area.connect("body_entered", _on_body_entered)
	if not area.is_connected("body_exited", _on_body_exited):
		area.connect("body_exited", _on_body_exited)

func _process(delta):
	# Preveri in posodobi škodo za sovražnike, če je čas za to
	if can_damage_enemies(delta):
		damage_enemies(delta)

func _on_body_entered(body):
	print("Sovražnik je vstopil v območje zidu.")
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		apply_damage()

func _on_body_exited(body):
	if body.is_in_group("Player") or body.is_in_group("Enemy"):
		stop_damage()

func can_damage_enemies(delta: float) -> bool:
	# Preveri, ali je čas, da se povzroči škoda sovražnikom
	return last_damage_time >= DAMAGE_INTERVAL

func damage_enemies(delta: float):
	print("Pred klicem funkcije za povzročanje škode.")
	# Povzroči škodo sovražnikom, ki so blizu zidu
	health -= DAMAGE_PER_SECOND * delta
	if health <= 0:
		print("Zid je uničen.")
		queue_free()  # Uniči zid, če je zdravje 0 ali manj
	# Posodobi čas zadnje povzročene škode
	last_damage_time = 0
	print("Po klicu funkcije za povzročanje škode.")

func apply_damage():
	# Začni povzročati škodo sovražnikom
	last_damage_time = 0

func stop_damage():
	# Prenehaj povzročati škodo sovražnikom
	last_damage_time = DAMAGE_INTERVAL

func get_health_ratio() -> float:
	# Vrne razmerje med trenutnim in maksimalnim zdravjem zida
	return health / MAX_HEALTH
