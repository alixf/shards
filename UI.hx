import js.Browser;
import js.html.Element;

class UI
{
	var element : Element;
	
	public function new(levelId : Int)
	{
		var element = Browser.document.querySelector("#ui");
		
		trace(levelId);
		if(levelId == 0)
		{
			element.innerHTML = '<div style="text-align : center; color : white; font-family : sans-serif; font-size : 1.33em;">
			<img src="logo.png" style="width : 20%;"/><br />
			Hey there adventurer !<br />
			Do you know the story of the Rainbow Golem ?<br />
			There once existed a giant creature made of colorful cristals<br />
			But the beautiful beast was shattered into many pieces across different worlds !<br />
			The shards remained linked and connected very distant worlds together.<br />
			If your control can reach one, there\'s no doubt it will reach the others...<br />
			<div id="start" style="margin : 10px; cursor : pointer; color : #80D0F0; border-radius : 5px; border : 1px solid #80D0F0; display : inline-block; padding : 5px;" >Start the quest and bring together the shards !</div>';
			
			Browser.document.querySelector("#start").addEventListener('click', function(_)
			{
				Browser.getLocalStorage().setItem("level", "1");
				Browser.location.reload();
			});
		}
		else if (levelId == Main.maxLevel)
		{
			element.innerHTML = '<div style="text-align : center; color : white; font-family : sans-serif; font-size : 1.33em;">
			<img src="logo.png" style="width : 20%;"/><br />
			You finished the game !<br />
			Thank you for playing !<br />
			Please comment and rate the game on the Ludum Dare website ! ; )<br />
			You can follow me on twitter : <a target="_blank" href="http://twitter.com/eolhing">@eolhing</a><br />
			<div id="start" style="margin : 10px; cursor : pointer; color : #80D0F0; border-radius : 5px; border : 1px solid #80D0F0; display : inline-block; padding : 5px;" >Play  again !</div>';
			
			Browser.document.querySelector("#start").addEventListener('click', function(_)
			{
				Browser.getLocalStorage().setItem("level", "0");
				Browser.location.reload();
			});
		}
		else
		{
			var str = switch(levelId)
			{
				case 1 : 'Level 1 - Welcome ! Use arrow keys to move the shards and [Space] or [UP] to make them jump ! Collect all the parts and reach the end of the level ! If you get stuck, just press [R]';
				case 2 : 'Level 2 - You might have noticed it but the red areas in both worlds will throw the shards back at their origin !';
				default : '';
			}
			element.innerHTML = '<div style="font-family : sans-serif; display : inline-block; margin : 5px; padding : 5px; background-color : black; border-radius : 5px; color : white;">$str</div>';
		}
	}
}