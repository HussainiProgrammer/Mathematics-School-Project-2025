extends MeshInstance3D
class_name Face

@export var p0: Vector3 = Vector3(-1, 0, -1)
@export var p1: Vector3 = Vector3(1, 0, -1)
@export var p2: Vector3 = Vector3(1, 0, 1)
@export var p3: Vector3 = Vector3(-1, 0, 1)

@export var face_color: Color = Color(1,1,1)

var st

func _ready(): drawFace()

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
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = face_color
	material.cull_mode = BaseMaterial3D.CULL_DISABLED
	set_surface_override_material(0, material)		

func updateFace():
	drawFace()
