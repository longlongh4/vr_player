extends MeshInstance

var shaderMaterial
onready var video_player = $VideoPlayer
var player_ready = false

func _ready():
	var gdShader = Shader.new()
	gdShader.set_code("""
	shader_type spatial;
	render_mode unshaded;

	uniform sampler2D movie;

	void vertex() {
		UV = vec2(UV.x, UV.y * 0.5);
		if (VIEW_INDEX == VIEW_RIGHT) {
			UV.y += 0.5;
		}
	}

	void fragment() {
		ALBEDO = texture(movie, UV).rgb;
	}
	""")
	shaderMaterial = ShaderMaterial.new()
	shaderMaterial.shader = gdShader
	set_surface_material(0, shaderMaterial)
	player_ready = true

func _process(_delta):
	if player_ready and video_player.is_playing():
		var texture = video_player.get_video_texture()
		if texture:
			shaderMaterial.set_shader_param("movie", texture)

func _on_VideoPlayer_finished():
	video_player.play()
