extends MeshInstance3D
@onready var viewport = $SubViewport

@export var material_instance : int = 1
@export var uv_coordinates : Vector3 = Vector3(0.5, 1, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	viewport.set_clear_mode(SubViewport.CLEAR_MODE_ONCE)
	
	#(material_override as StandardMaterial3D).albedo_texture = viewport.get_texture()
	
	var material = StandardMaterial3D.new()
	material.albedo_texture = viewport.get_texture()
	material.uv1_scale = uv_coordinates
	set_surface_override_material(material_instance, material)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
