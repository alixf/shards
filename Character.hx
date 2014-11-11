import box2D.collision.shapes.B2MassData;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;
import h3d.col.Point;
import h3d.mat.Material;
import h3d.prim.Plan3D;
import h3d.prim.Polygon;
import h3d.prim.UV;
import h3d.scene.Object;
import h3d.scene.Mesh;
import hxd.Key;
import h3d.prim.FBXModel;
import motion.Actuate;
import motion.easing.*;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.collision.shapes.B2PolygonShape;
import box2D.dynamics.B2FixtureDef;
import h3d.mat.BlendMode;
import h3d.mat.MeshMaterial;

class Character extends Object
{
	var speed = 5;
	public var body : B2Body;
	private var jumpClock = 0.0;
	private var jumpCooldown = 0.33;
	private var obj : Mesh;
	private var id : Int;
	private var rotatingSpeed = Math.PI / 2;
	private var mat : MeshMaterial;
	public var alive = true;
	private var glow : Plane;
	
	public function new(parent : Object, id : Int)
	{
		super(parent);
		
		this.id = id;
		var object = new FBXModel(Data.shardMesh);
		mat = new MeshMaterial(Data.shardTexture);
		mat.blendMode = BlendMode.Alpha;
		
		obj = new Mesh(object, mat, this);
		scale(0.33);
		obj.rotate(Math.PI / 2, 0.0, Math.PI);
		obj.x += 1.0;
		obj.y += 2.0;
		Actuate.tween(obj, 0.5, { y : obj.y + 0.25 } ).ease(Linear.easeNone).repeat().reflect();
		
		glow = new Plane(this, Data.glowTexture, true);		
		glow.scale(5);
		glow.x -= 1.75;
		glow.y -= 0.5;
		
		setAlpha(0.75);
		
		var bodyDef = new B2BodyDef();
		bodyDef.type = B2Body.b2_dynamicBody;
		var bodyBox = new B2PolygonShape();
		bodyBox.setAsBox(0.45, 0.45);
		
		var fixtureDef = new B2FixtureDef();
		fixtureDef.shape = bodyBox;
		fixtureDef.density = 1.0;
		
		body = Main.world.createBody(bodyDef);
		body.setFixedRotation(true);
		body.createFixture(fixtureDef);
		body.setUserData( { entity : this, type : BlockType.character, grounded : false } );
		var massData = new B2MassData();
		massData.mass = 1.0;
		body.setMassData(massData);
		body.setLinearDamping(10.0);
	}
	
	public var jumpStatus = 2;
	public function update(dt : Float)
	{
		if (alive)
		{
			//if (jumpStatus == 0 && body.getLinearVelocity().y < 0.0) // Fall
			//	jumpStatus = 0;
			if (jumpStatus == 0 && body.getLinearVelocity().y == 0.0) // Land
				jumpStatus = 2;
			
			obj.rotate(0.0, (id == 1 ? -1.0 : 1.0) * rotatingSpeed * dt, 0.0);
			x = body.getPosition().x;
			y = body.getPosition().y;
			
			jumpClock += dt;
			if (Key.isDown(Key.UP) && jumpStatus == 2 && jumpClock >= jumpCooldown)
			{
				body.applyImpulse(new B2Vec2(0, 75), body.getWorldCenter());
				jumpClock = 0.0;
				body.getUserData().grounded = false;
				jumpStatus = 0;
			}
			
			var dx = 0.0;
			if (Key.isDown(Key.LEFT))
				dx -= 1.0;
			if (Key.isDown(Key.RIGHT))
				dx += 1.0;
			
			if (dx != 0.0)
				body.applyImpulse(new B2Vec2(dx * speed, 0.0), body.getWorldCenter());
		}
	}
	
	public function accelerate()
	{
		rotatingSpeed *= 1.33;
	}
	
	public function setAlpha(alpha : Float)
	{
		mat.color.a = alpha;
		if (glow.material.color.a > alpha)
			glow.material.color.a = alpha;
	}
}