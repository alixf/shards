import h3d.Engine;
import h3d.mat.Texture;
import h3d.prim.FBXModel;
import h3d.prim.Primitive;
import h3d.scene.*;
import h3d.Vector;
import hxd.Res;
import hxd.res.Image;
import hxd.Timer;
import js.Browser;
import motion.Actuate;
import motion.easing.*;
import h3d.prim.Polygon;
import h3d.prim.UV;
import h3d.col.Point;
import hxd.Key;

import box2D.collision.shapes.B2CircleShape;
import box2D.collision.shapes.B2PolygonShape;
import box2D.common.math.B2Vec2;
import box2D.dynamics.B2Body;
import box2D.dynamics.B2BodyDef;
import box2D.dynamics.B2FixtureDef;
import box2D.dynamics.B2World;
import box2D.dynamics.B2ContactListener;
import box2D.dynamics.contacts.B2Contact;

import howler.Howl;

@:enum abstract BlockColor(Int)
{
	var wall = 0xFFFFFFFF;
	var start = 0xFF00FF00;
	var check = 0xFFFFFF00;
	var void = 0xFFFF0000;
	var end = 0xFF008000;
}

@:enum abstract SceneType(Int)
{
	var intro = 1;
	var level1 = 2;
	var level2 = 3;
	var level3 = 4;
}

class Main extends hxd.App
{	
	var time : Float = 0.;
	
	var character1 : Character;
	var character2 : Character;
	public static var world = new B2World(new B2Vec2(0, -250), true);
	public static var game : Main;
	private var checkpoints = new Array<Checkpoint>();
	private var checkpoint : Checkpoint;
	
	var trees : Mesh;
	var skyplane : Object;
	var currentLevel : Image;
	var level : Object;
	var levelId : Int;
	public static var maxLevel = 3;
	
	var test = new Array<Object>();
	var ui : UI;
	
	override function init()
	{	
		game = this;
		
		Data.init();
		
		world.setContactListener(new ContactListener());
		s3d.camera.pos = new Vector(0, 0, -31);
		
		levelId = Std.parseInt(Browser.getLocalStorage().getItem("level"));
		if (levelId == null)
			levelId = 0;
		
		ui = new UI(levelId);
		
		Engine.getCurrent().backgroundColor = 0xFF80B8FF;
		
		
		if (levelId > 0 && levelId < maxLevel)
		{
			currentLevel = switch(levelId)
			{
			case 1 : Res.levels.level1;
			case 2 : Res.levels.level2;
			case 3 : Res.levels.level3;
			case 4 : Res.levels.level4;
			default : throw 'Can\'t load level $currentLevel';
			}
			level = loadLevel(currentLevel);			
			update(0);
		}
	}
	
	public function loadLevel(levelImage : Image)
	{
		var level = new Object(s3d);
		
		skyplane = new Plane(level, Data.skyplane, false, true);
		skyplane.z = 1000;
		skyplane.scale(750);
		skyplane.scaleX *= 2;
		
		var o1 = new FBXModel(Data.treesMesh);
		var m1 = new h3d.mat.MeshMaterial(Data.treesTexture);
		trees = new Mesh(o1, m1, level);
		trees.rotate(0.0, Math.PI, 0.0);
		trees.scale(5);
		trees.z = 50;
		trees.y = 0.1;
		trees.x = 50;
		
		var o2 = new FBXModel(Data.jungle2Mesh);
		var m2 = new h3d.mat.MeshMaterial(Data.jungle2Texture);
		trees = new Mesh(o2, m2, level);
		trees.rotate(0.0, Math.PI, 0.0);
		trees.scale(0.25);
		trees.z = 10;
		trees.y = 15;
		trees.x = 10;
		
		var o2 = new FBXModel(Data.jungle2Mesh);
		var m2 = new h3d.mat.MeshMaterial(Data.jungle2Texture);
		trees = new Mesh(o2, m2, level);
		trees.rotate(0.0, Math.PI, 0.0);
		trees.scale(0.25);
		trees.z = 10;
		trees.y = 15;
		trees.x = 60;
		
		var startPosition = { x : 0.0, y : 0.0 };
		var levelBitmap = levelImage.toBitmap();
		
		var startPosition = { x : 0.0, y : 0.0 };
		var below = false;
		function createBlock(color : BlockColor, x : Float, y : Float, side : Bool)
		{
			switch (color)
			{
			case BlockColor.wall :
				var block = new Wall(level, below);
				block.setPosition(x, y);
				test.push(block);
			case BlockColor.start :
				startPosition = { x : x, y : y };
			case BlockColor.void :
				var void = new VoidBlock(level);
				void.setPosition(x, y);
			case BlockColor.end :
				var void = new End(level);
				void.setPosition(x, y);
			case BlockColor.check :
				var checkpoint = new Checkpoint(level, true);
				checkpoint.setPosition(x, y);
				checkpoints.push(checkpoint);
			}
		}
		
		for (x in 0...levelBitmap.width)
		{
			for (y in 0...Std.int(levelBitmap.height/2))
			{
				var color = levelBitmap.getPixel(x, y);
				below = (y == 0 || levelBitmap.getPixel(x, y - 1) == 0xFFFFFFFF);
				createBlock(cast color, x, 10 - y, true);
			}
		}
		character1 = new Character(s3d, 1);
		character1.body.setPosition(new B2Vec2(startPosition.x, startPosition.y));
		
		for (x in 0...levelBitmap.width)
		{
			for (y in Std.int(levelBitmap.height/2)...levelBitmap.height)
			{
				var color = levelBitmap.getPixel(x, y);
				
				below = (y == Std.int(levelBitmap.height / 2) || levelBitmap.getPixel(x, y - 1) == 0xFFFFFFFF);
				
				var y = y - Std.int(levelBitmap.height / 2);
				
				
				createBlock(cast color, x, -y, true);
			}
		}
		character2 = new Character(level, 2);
		character2.body.setPosition(new B2Vec2(startPosition.x, startPosition.y));
		
		checkpoints.sort(function(x : Checkpoint, y : Checkpoint) { return x.x > y.x ? 1 : x.x < y.x ? -1 : 0; } );
		checkpoint = new Checkpoint(level, false);
		checkpoint.setPosition(checkpoints[0].x, checkpoints[0].y);
		
		Data.bgm.play();
		
		return level;
	}
	
	override function update(dt : Float)
	{
		var t = Timer.deltaT;
		
		world.step(Timer.deltaT, 8, 3);
		
		var dist = 5;
		character1.update(Timer.deltaT);
		character2.update(Timer.deltaT);
		
		var cameraX = (character1.x + character2.x) / 2;
		cameraX = Math.min(100-17.6, Math.max(17.6, cameraX));
		s3d.camera.pos = new Vector(cameraX, 1, s3d.camera.pos.z);
		s3d.camera.target = new Vector(cameraX, 1, (character1.x+character2.x)/2);
		s3d.camera.up = new Vector(0, 1, 0);
		
		skyplane.x = s3d.camera.pos.x - 700;
		skyplane.y = s3d.camera.pos.y - 375;
		
		
		if (Key.isDown("R".charCodeAt(0)))
			retry();
	}
	
	public var canWin = false;
	public function validateCheckpoint()
	{
		var cpPos= checkpoints.shift();
		var nextPos = checkpoints[0];
		if (nextPos != null)
		{
			checkpoint.body.getUserData().type = BlockType.checkpointFlying;
			Data.win.play();
			cpPos.material.color.a = 0.0;
			Actuate.update(checkpoint.setPosition, 0.5, [cpPos.x, cpPos.y], [nextPos.x, nextPos.y]).ease(Quad.easeIn).onComplete(function(){checkpoint.body.getUserData().type = BlockType.checkpoint;});
			character1.accelerate();
			character2.accelerate();
		}
		else
		{
			checkpoint.body.getUserData().type = BlockType.checkpointFlying;
			Data.win.play();
			cpPos.material.color.a = 0.0;
			Actuate.update(checkpoint.setPosition, 0.5, [cpPos.x, cpPos.y], [120.0, 0.0]).ease(Quad.easeIn).onComplete(function(){checkpoint.body.getUserData().type = BlockType.checkpoint;});
			canWin = true;
		}
	}
	
	public function destroyCharacter()
	{
		Data.lose.play();
		//Actuate.update(character1.scale, 0.5, [1.0], [0.0]);
		//Actuate.update(character2.scale, 0.5, [1.0], [0.0]);
		Actuate.update(character1.setAlpha, 0.5, [0.75], [0.0]);
		Actuate.update(character2.setAlpha, 0.5, [0.75], [0.0]).onComplete(retry);
		character1.alive = false;
		character2.alive = false;
	}
	
	public function retry()
	{
		js.Browser.location.reload();
		/*
		level.dispose();
		level.remove();
		
		var bodyList = world.getBodyList();
		var toRemove = bodyList;
		while (bodyList != null)
		{
			toRemove = bodyList;
			bodyList = bodyList.getNext();
			toRemove.getWorld().destroyBody(toRemove);
		}
		
		loadLevel(currentLevel);
		*/
	}
	
	public function win()
	{
		if (canWin)
		{
			js.Browser.location.reload();
			
			
			Browser.getLocalStorage().setItem("level", ""+((levelId+1)%(maxLevel+1)));
		}
	}
	
	
	static function main()
	{
		hxd.Res.initEmbed();
		new Main();
	}
}
