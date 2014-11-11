import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.B2FilterData;
import box2D.dynamics.contacts.B2Contact;
import h3d.mat.BlendMode;
import h3d.scene.Object;
import h3d.scene.Mesh;
import h3d.Vector;
import hxd.Key;
import hxsl.Types.Vec;

import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2FixtureDef;

class Checkpoint extends Object
{
	public var body : B2Body;
	public var material : h3d.mat.MeshMaterial;
	public var shadow : Bool;
	
	public function new(parent : Object, shadow : Bool)
	{
		super(parent);
		this.shadow = shadow;
		
		var tex = hxd.Res.stars.toTexture();
		material = new h3d.mat.MeshMaterial(tex);
		var mesh = new Mesh(Data.cube, material, this);
		material.blendMode = BlendMode.Alpha;
		
		if (shadow)
			material.color.a = 0.5;
		
		if (!shadow)
		{
			var bodyDef = new B2BodyDef();
			var bodyBox = new B2PolygonShape();
			bodyBox.setAsBox(0.5, 0.5);
			var fixtureDef = new B2FixtureDef();
			fixtureDef.shape = bodyBox;
			fixtureDef.density = 1.0;
			fixtureDef.isSensor = true;
			
			body = Main.world.createBody(bodyDef);
			body.createFixture(fixtureDef);
			body.setUserData( { entity : this, type : shadow ? BlockType.checkpointShadow : BlockType.checkpoint, grounded : false } );
			body.setFixedRotation(true);
		}
	}
	
	public function setPosition(x : Float, y : Float)
	{
		this.x = x;
		this.y = y;
		if(!shadow)
			body.setPosition(new B2Vec2(x, y));
	}
}