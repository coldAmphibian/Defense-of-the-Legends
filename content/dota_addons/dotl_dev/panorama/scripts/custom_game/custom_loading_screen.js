var images = [["Leona.png","Diana.png"],["Leona1.png","Diana1.png"],["Leona2.png","Diana2.png"]];
var pair = Math.floor(Math.random()*images.length);

$("#PortraitLeft").SetImage("file://{images}/custom_game/loading_screen/" + images[pair][0]);
$("#PortraitRight").SetImage("file://{images}/custom_game/loading_screen/" + images[pair][1]);
$.Msg(pair);