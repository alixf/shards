import h3d.scene.*;
import h3d.Vector;
import hxd.Res;
import hxd.Timer;

import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;

class ContactListener extends B2ContactListener
{
	override public function beginContact(contact : B2Contact):Void 
	{
		super.beginContact(contact);
		var dataA = contact.getFixtureA().getBody().getUserData();
		var dataB = contact.getFixtureB().getBody().getUserData();
		
		if (dataA.type == BlockType.wall && dataB.type == BlockType.character)
			dataB.grounded = true;
		if (dataB.type == BlockType.wall && dataA.type == BlockType.character)
			dataA.grounded = true;
			
		if (dataA.type == BlockType.character && dataB.type == BlockType.checkpoint)
			Main.game.validateCheckpoint();
		if (dataA.type == BlockType.checkpoint && dataB.type == BlockType.character)
			Main.game.validateCheckpoint();
			
		if (dataA.type == BlockType.character && dataB.type == BlockType.void)
			Main.game.destroyCharacter();
		if (dataA.type == BlockType.void && dataB.type == BlockType.character)
			Main.game.destroyCharacter();
			
		if (dataA.type == BlockType.character && dataB.type == BlockType.end)
			Main.game.win();
		if (dataA.type == BlockType.end && dataB.type == BlockType.character)
			Main.game.win();
	}
	override public function endContact(contact : B2Contact):Void 
	{
		super.endContact(contact);
		var dataA = contact.getFixtureA().getBody().getUserData();
		var dataB = contact.getFixtureB().getBody().getUserData();
		
		if (dataA.type == BlockType.wall && dataB.type == BlockType.character)
			dataB.grounded = false;
		if (dataB.type == BlockType.wall && dataA.type == BlockType.character)
			dataA.grounded = false;
	}
}