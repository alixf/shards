import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;
import h3d.mat.BlendMode;
import h3d.scene.Object;
import h3d.scene.Mesh;
import hxd.Key;
import hxd.Res;
import h3d.prim.FBXModel;

import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2FixtureDef;

class End extends Object
{
	public var body : B2Body;
	
	public function new(parent : Object)
	{
		super(parent);
		
		var tex = hxd.Res.end.toTexture();
		var mat = new h3d.mat.MeshMaterial(tex);
		mat.blendMode = BlendMode.SoftAdd;
		mat.color.a = 0.5;
		var obj1 = new Mesh(Data.cube, mat, this);
		
		var bodyDef = new B2BodyDef();
		var bodyBox = new B2PolygonShape();
		bodyBox.setAsBox(0.51, 0.51);
		var fixtureDef = new B2FixtureDef();
		fixtureDef.shape = bodyBox;
		fixtureDef.isSensor = true;
		body = Main.world.createBody(bodyDef);
		body.createFixture(fixtureDef);
		body.setUserData( { entity : this, type : BlockType.end, grounded : false } );
		body.setFixedRotation(true);
	}
	
	public function setPosition(x : Float, y : Float)
	{
		this.x = x;
		this.y = y;
		body.setPosition(new B2Vec2(x, y));
	}
}