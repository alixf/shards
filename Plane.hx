import h3d.mat.MeshMaterial;
import h3d.prim.Polygon;
import h3d.scene.Mesh;
import h3d.scene.Object;
import h3d.col.Point;
import h3d.prim.UV;
import h3d.mat.BlendMode;
import h3d.mat.Texture;

class Plane extends Object
{
	public var mesh1 : Polygon;
	public var mesh2 : Polygon;
	public var part1 : Mesh;
	public var part2 : Mesh;
	public var material : MeshMaterial;
	
	public function new(parent : Object, texture : Texture, transparent : Bool, invertY : Bool = false)
	{
		super(parent);
		
		mesh1 = new Polygon([new Point(0, 0, 0), new Point(0, 1, 0), new Point(1, 1, 0)]);
		mesh2 = new Polygon([new Point(0, 0, 0), new Point(1, 1, 0), new Point(1, 0, 0)]);
		mesh1.uvs = [new UV(0, invertY ? 1 : 0), new UV(0, invertY ? 0 : 1), new UV(1, invertY ? 0 : 1)];
		mesh2.uvs = [new UV(0, invertY ? 1 : 0), new UV(1, invertY ? 0 : 1), new UV(1, invertY ? 1 : 0)];
		
		material = new h3d.mat.MeshMaterial(texture);
		if(transparent)
			material.blendMode = BlendMode.Alpha;
		
		var part1 = new Mesh(mesh1, material, this);
		var part2 = new Mesh(mesh2, material, this);
	}
}