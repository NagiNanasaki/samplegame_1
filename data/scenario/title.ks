
[cm]

@clearstack
[reset_camera layer="base" time="1"]
@bg storage="title_menu.png" time=0
@mask_off time="1000"
@wait time=200

*start
[playbgm storage="op.mp3"]

[iscript]
$('#title_ui').remove();

$('.tyrano_base').append(
  '<div id="title_ui" style="position:absolute;top:0;left:0;width:1280px;height:720px;pointer-events:none;z-index:10000;">' +
  '<style>' +
  '#title_logo{position:absolute;right:50px;top:120px;width:500px;pointer-events:none;}' +
  '#title_logo img{width:100%;height:auto;}' +
  '#title_buttons{position:absolute;bottom:45px;left:0;width:100%;display:flex;justify-content:space-around;align-items:center;padding:0 60px;box-sizing:border-box;pointer-events:none;}' +
  '.title-btn{text-align:center;cursor:pointer;padding:12px 24px;pointer-events:all;}' +
  '.title-btn-en{font-family:Georgia,"Times New Roman",serif;font-size:26px;letter-spacing:3px;color:rgba(255,245,225,0.88);text-shadow:0 2px 8px rgba(0,0,0,0.5);transition:color 0.3s,letter-spacing 0.3s,text-shadow 0.3s;}' +
  '.title-btn-ja{font-size:11px;letter-spacing:4px;color:rgba(255,230,190,0.7);margin-top:7px;text-shadow:0 1px 4px rgba(0,0,0,0.4);transition:color 0.3s;}' +
  '.title-btn:hover .title-btn-en{color:#fff;text-shadow:0 0 20px rgba(255,200,80,0.9),0 0 6px rgba(255,200,80,0.5),0 2px 8px rgba(0,0,0,0.4);letter-spacing:4px;}' +
  '.title-btn:hover .title-btn-ja{color:rgba(255,240,200,0.95);}' +
  '</style>' +
  '<div id="title_logo"><img src="./data/image/title/title_logo.png"></div>' +
  '<div id="title_buttons">' +
  '<div class="title-btn" id="tbtn_newgame"><div class="title-btn-en">New Game</div><div class="title-btn-ja">はじめから</div></div>' +
  '<div class="title-btn" id="tbtn_continue"><div class="title-btn-en">Continue</div><div class="title-btn-ja">つづきから</div></div>' +
  '<div class="title-btn" id="tbtn_config"><div class="title-btn-en">Config</div><div class="title-btn-ja">環境設定</div></div>' +
  '<div class="title-btn" id="tbtn_extra"><div class="title-btn-en">Extra</div><div class="title-btn-ja">エクストラ</div></div>' +
  '<div class="title-btn" id="tbtn_exit"><div class="title-btn-en">Exit</div><div class="title-btn-ja">ゲーム終了</div></div>' +
  '</div></div>'
);

$('#tbtn_newgame').on('click', function() {
  $('#title_ui').remove();
  TYRANO.kag.ftag.startTag('jump', {storage:'scene0.ks', target:''});
});
$('#tbtn_continue').on('click', function() {
  TYRANO.kag.menu.loadgame();
});
$('#tbtn_config').on('click', function() {
  TYRANO.kag.ftag.startTag('sleepgame', {storage:'config.ks', target:''});
});
$('#tbtn_extra').on('click', function() {
  $('#title_ui').remove();
  TYRANO.kag.ftag.startTag('jump', {storage:'cg.ks', target:''});
});
$('#tbtn_exit').on('click', function() {
  if (typeof nw !== 'undefined') { nw.App.quit(); }
  else { window.close(); }
});
[endscript]

[s]

*gamestart
[iscript]$('#title_ui').remove();[endscript]
@jump storage="scene0.ks"
