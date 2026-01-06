extends MeshInstance3D

@export var scalar: float
@export var height: float

var p0: Vector3 = Vector3(-1, 0, -1)
var p1: Vector3 = Vector3(1, 0, -1)
var p2: Vector3 = Vector3(1, 0, 1)
var p3: Vector3 = Vector3(-1, 0, 1)
var face_color: Color = Color(1,1,1)

var st

func _ready():
	p0 *= scalar
	p1 *= scalar
	p2 *= scalar
	p3 *= scalar
	
	p0.y = height
	p1.y = height
	p2.y = height
	p3.y = height
	
	drawFace()

func drawFace():
	st = SurfaceTool.new()
	
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	st.add_vertex(p0)
	st.add_vertex(p1)
	st.add_vertex(p2)
	
	st.add_vertex(p0)
	st.add_vertex(p2)
	st.add_vertex(p3)
	
	st.generate_normals()
	
	var myMesh = st.commit()
	set_mesh(myMesh)
	
	var material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = face_color
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	set_surface_override_material(0, material)		

func updateFace():
	drawFace()
