import h3d.mat.Texture;
import h3d.prim.Cube;
import h3d.prim.FBXModel;
import h3d.prim.Primitive;
import h3d.scene.*;
import h3d.Vector;
import hxd.fmt.fbx.Library;
import hxd.Res;

import howler.Howl;

class Data
{
	public static var jungleBlockMesh : hxd.fmt.fbx.Geometry;
	public static var jungleBlockTexture : Texture;
	//public static var jungleBlockTexture2 : Texture;
	public static var shardFbx : Library;
	public static var shardMesh : hxd.fmt.fbx.Geometry;
	public static var shardTexture : Texture;
	public static var treesMesh : hxd.fmt.fbx.Geometry;
	public static var treesTexture : Texture;
	public static var jungle2Mesh : hxd.fmt.fbx.Geometry;
	public static var jungle2Texture : Texture;
	public static var glowTexture : Texture;
	public static var skyplane : Texture;
	public static var cube : Cube;
	
	public static var bgm : Howl;
	public static var win : Howl;
	public static var lose : Howl;
	
	public static function init()
	{
		jungleBlockMesh = Res.jungle3.toFbx().getGeometry();
		jungleBlockTexture = Res.jungle.toTexture();
		//jungleBlockTexture2 = Res.jungleflip.toTexture();
		
		shardFbx = Res.shard2.toFbx();
		shardMesh = shardFbx.getGeometry();
		shardTexture = Res.shardTexture.toTexture();
		
		treesMesh = Res.trees.toFbx().getGeometry();
		treesTexture = Res.treesTexture.toTexture();
		jungle2Mesh = Res.jungle2.toFbx().getGeometry();
		jungle2Texture = Res.jungle2Texture.toTexture();
		
		glowTexture = Res.glow.toTexture();
		skyplane = Res.skyplane.toTexture();
		
		cube = new h3d.prim.Cube();
		cube.addUVs();
		cube.addNormals();
		
		bgm = new Howl( { urls: ['music/bgm.mp3', 'music/bgm.ogg'] } );
		bgm.loop(true);
		win = new Howl( { urls: ['music/win.mp3', 'music/win.ogg'] } );
		lose = new Howl( { urls: ['music/lose.mp3', 'music/lose.ogg'] } );
	}
	
	public static function loadTexture(texture : Texture, name : String, _)
	{
		var texture = new h3d.mat.MeshMaterial(texture);
		texture.mainPass.culling = None;
		texture.texture.filter = Nearest;
		texture.mainPass.getShader(h3d.shader.Texture).killAlpha = true;
		return texture;
	}
}