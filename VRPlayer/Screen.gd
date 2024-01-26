extends MeshInstance

var shaderMaterial
onready var video_player = $VideoPlayer

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
	shaderMaterial.set_shader_param("movie", video_player.get_video_texture())

func _on_VideoPlayer_finished():
	video_player.play()
