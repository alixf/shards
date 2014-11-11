import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;
import h3d.scene.Object;
import h3d.scene.Mesh;
import hxd.Key;
import hxd.Res;
import h3d.prim.FBXModel;

import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2FixtureDef;

class Wall extends Object
{
	public var body : B2Body;
	
	public function new(parent : Object, flip : Bool = false)
	{
		super(parent);
		
		var object = new FBXModel(Data.jungleBlockMesh);
		var mat = new h3d.mat.MeshMaterial(Data.jungleBlockTexture);
		var obj = new Mesh(object, mat, this);
		scale(0.5);
		obj.rotate(Math.PI / 2, 0.0, Math.PI);
		obj.x += 1.0;
		obj.y += 1.0;
		if (flip)
		{
			
			obj.x -= 2.0;
			setRotateAxis(0.0, 1.0, 0.0, Math.PI);
		}
		//setRotateAxis(1.0, 0.0, 1.0, Math.PI / 2);
		
		//var prim = new h3d.prim.Cube();
		//prim.addUVs();
		//prim.addNormals();
		//var tex = hxd.Res.hxlogo.toTexture();
		//var mat = new h3d.mat.MeshMaterial(tex);
		//var obj1 = new Mesh(prim, mat, this);
		
		var bodyDef = new B2BodyDef();
		var bodyBox = new B2PolygonShape();
		bodyBox.setAsBox(0.51, 0.51);
		var fixtureDef = new B2FixtureDef();
		fixtureDef.shape = bodyBox;
		fixtureDef.density = 1.0;
		
		body = Main.world.createBody(bodyDef);
		body.createFixture(fixtureDef);
		body.setUserData( { entity : this, type : BlockType.wall, grounded : false } );
		body.setFixedRotation(true);
	}
	
	public function setPosition(x : Float, y : Float)
	{
		this.x = x;
		this.y = y;
		body.setPosition(new B2Vec2(x, y));
	}
}