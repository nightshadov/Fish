extends Spatial


const TILE_MATERIALS = [
	preload("res://Assets/Material/air.tres"),
	preload("res://Assets/Material/bedrock.tres"),
	preload("res://Assets/Material/earth.tres"),
	
]

const TILE_SIZE := 2.0
const TILE_HEIGHT := 2.0
const BUILDING_SIZE := 1.0
const HEX_TILE = preload("res://HexTile.tscn")
const CITY = preload("res://Assets/Models/city.tscn")

export (int, 2, 20) var grid_size := 10
var grid_levels=1

func _ready() -> void:
	fill_hexgrid()
	place_city(3,1,3)
	place_city(4,1,3)
	_generate_grid()

var tile_inf={"type":0, "ref":null}

var hexgrid=[[[tile_inf.duplicate(true)]]]

func solid_layer(y,mat):
	for k in range(hexgrid.size()):
		for m in range(hexgrid[0][y].size()):
			hexgrid[k][y][m]["type"]=mat
			
func mark_layer(y,mat):
	for k in range(hexgrid.size()):
		for m in range(hexgrid[0][y].size()):
			if((k + m) % 2 == 0):
				hexgrid[k][y][m]["type"]=mat
			else:
				hexgrid[k][y][m]["type"]=0

func rand_layer(y,mat):
	for k in range(hexgrid.size()):
		for m in range(hexgrid[0][y].size()):
			if(65>randi() % 100):
				hexgrid[k][y][m]["type"]=0
			else:
				hexgrid[k][y][m]["type"]=mat
				
func iterate_cave(y,mat):
	var W=mat
	var F=0
	var type
	for k in range(hexgrid.size()):
		for m in range(hexgrid[0][y].size()):
			type=hexgrid[k][y][m]["type"]
			if(type==W ):
				pass

func count_tiletype_ring(pos,ring,type):
	pass

func road_x_layer(y,z):
	for k in range(hexgrid.size()):
		for m in range(hexgrid[0][y].size()):
			if(m==z):
				hexgrid[k][y][m]["type"]=0

func road_z_layer(y,x):
	for k in range(hexgrid.size()):
		for m in range(hexgrid[0][y].size()):
			if(k==x):
				hexgrid[k][y][m]["type"]=0

func change_tile_type(x,y,z,type):
	#hexgrid[k][y][m]["type"]=0
	pass


func fill_hexgrid():
	hexgrid=[]
	var x=100
	var y=2
	var z=100
	for k in range(x):
		var wall=[]
		for l in range(y):
			var line=[]
			for m in range(z):
				line.append(tile_inf.duplicate(true))
			wall.append(line)
		hexgrid.append(wall)
	solid_layer(0,1)
	#mark_layer(1,2)
	rand_layer(1,2)
	road_x_layer(1,3)
	road_z_layer(1,3)
				
	
func place_city(x,y,z):
	var city = CITY.instance()
	var pos = Vector3(x,y,z)
	add_child(city)
	city.translate(hexgrid_to_global(pos))
	city.global_scale(Vector3(BUILDING_SIZE,BUILDING_SIZE*2,BUILDING_SIZE))
		
func global_to_hexgrid(hexvec):
	var vec := Vector3.ZERO
	vec.y = round(hexvec.y / TILE_HEIGHT)
	vec.x = round(hexvec.x / TILE_SIZE / cos(deg2rad(30)))
	vec.z = round(hexvec.z / TILE_SIZE if fmod(hexvec.x,TILE_SIZE) == 0 else vec.z / TILE_SIZE - 0.5)
	return vec

func hexgrid_to_global(vec):
	var hexvec := Vector3.ZERO
	hexvec.y = vec.y * TILE_HEIGHT
	hexvec.x = vec.x * TILE_SIZE * cos(deg2rad(30))
	hexvec.z = vec.z * TILE_SIZE if int(vec.x) % 2 == 0 else vec.z * TILE_SIZE + TILE_SIZE / 2
	return hexvec




func _generate_grid():
	for x in range(hexgrid.size()):
		for y in range(hexgrid[0].size()):
			for z in range(hexgrid[0][0].size()):
				var tile = HEX_TILE.instance()
				hexgrid[x][y][z]["ref"]=tile
				add_child(tile)
				tile.translate(hexgrid_to_global(Vector3(x,y,z)))
				tile.global_scale(Vector3(TILE_SIZE,TILE_HEIGHT,TILE_SIZE))
				tile.get_node("unit_hex/mergedBlocks(Clone)").material_override = get_tile_material(hexgrid[x][y][z]["type"])


func get_tile_material(tile_index: int):
	var index = tile_index % TILE_MATERIALS.size()
	return TILE_MATERIALS[index]
