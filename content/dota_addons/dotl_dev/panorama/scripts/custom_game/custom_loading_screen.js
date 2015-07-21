var images = [["Rubick.png","Viktor.png"],["Techies.png","Teemo.png"],["Phoenix.png","Anivia.png"],["Enigma.png","Bard.png"]];
var pair = Math.floor(Math.random()*images.length);

$("#PortraitLeft").SetImage("file://{images}/custom_game/loading_screen/" + images[pair][0]);
$("#PortraitRight").SetImage("file://{images}/custom_game/loading_screen/" + images[pair][1]);