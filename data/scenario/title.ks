
[cm]

@clearstack
[reset_camera layer="base" time="1"]
@bg storage="title_menu.png" time=0

[iscript]
$('#title_fade_overlay').remove();
$('.tyrano_base').append('<div id="title_fade_overlay" style="position:absolute;top:0;left:0;width:1280px;height:720px;background:#fff;z-index:99999;pointer-events:none;"></div>');
[endscript]

@mask_off time="0"

*start
[if exp="!tf._title_skip_anim"]
[playbgm storage="op.mp3"]
[endif]

[iscript]
$('#title_ui').remove();

$('.tyrano_base').append(
  '<div id="title_ui" style="position:absolute;top:0;left:0;width:1280px;height:720px;pointer-events:none;z-index:10000;">' +
  '<style>' +
  '#title_bg_zoom{position:absolute;top:-7.5%;left:-7.5%;width:115%;height:115%;background:url(./data/bgimage/title_menu.png) center/cover no-repeat;pointer-events:none;}' +
  '.title-orb{position:absolute;border-radius:50%;background:radial-gradient(circle,rgba(255,245,210,0.95) 0%,rgba(255,220,160,0.4) 45%,transparent 70%);pointer-events:none;opacity:0;filter:blur(5px);}' +
  '#title_chara{position:absolute;bottom:-40px;left:50%;transform:translateX(-50%);height:580px;width:fit-content;pointer-events:none;opacity:0;}' +
  '#title_chara img{height:100%;width:auto;display:block;filter:drop-shadow(0 0 6px rgba(255,230,180,0.65)) drop-shadow(0 0 20px rgba(255,200,130,0.3));}' +
  '#title_chara_light{position:absolute;inset:0;background:linear-gradient(to left,rgba(255,210,130,0.7) 0%,rgba(255,190,100,0.35) 30%,rgba(255,170,80,0.08) 60%,transparent 80%);mix-blend-mode:screen;-webkit-mask-image:url(./data/fgimage/chara/tensi/tensi_normal.png);-webkit-mask-size:100% 100%;-webkit-mask-repeat:no-repeat;pointer-events:none;}' +
  '#title_haze{position:absolute;bottom:0;left:0;width:100%;height:420px;background:linear-gradient(to top,rgba(255,255,255,1) 0%,rgba(255,255,255,0.92) 12%,rgba(255,255,255,0.7) 30%,rgba(255,255,255,0.35) 55%,rgba(255,255,255,0.08) 80%,transparent 100%);pointer-events:none;opacity:0;}' +
  '#title_logo{position:absolute;left:50px;top:260px;width:420px;pointer-events:none;opacity:0;}' +
  '#title_logo img{width:100%;height:auto;}' +
  '#title_buttons{position:absolute;bottom:45px;left:0;width:100%;display:flex;justify-content:space-around;align-items:center;padding:0 60px;box-sizing:border-box;pointer-events:none;z-index:100;}' +
  '.title-btn{text-align:center;cursor:pointer;padding:12px 24px;pointer-events:all;opacity:0;}' +
  '.title-btn-en{font-family:Georgia,"Times New Roman",serif;font-size:26px;letter-spacing:3px;color:rgba(40,25,8,0.88);text-shadow:0 1px 3px rgba(255,255,255,0.7);transition:color 0.3s,letter-spacing 0.3s,text-shadow 0.3s;}' +
  '.title-btn-ja{font-size:11px;font-weight:600;letter-spacing:4px;color:rgba(60,40,15,0.7);margin-top:7px;text-shadow:0 1px 2px rgba(255,255,255,0.6);transition:color 0.3s;}' +
  '.title-btn:hover .title-btn-en{color:rgba(120,70,0,1);text-shadow:0 0 12px rgba(180,120,0,0.4),0 1px 3px rgba(255,255,255,0.7);letter-spacing:4px;}' +
  '.title-btn:hover .title-btn-ja{color:rgba(140,90,10,0.95);}' +
  '</style>' +
  '<div id="title_bg_zoom"></div>' +
  '<div id="title_chara"><img src="./data/fgimage/chara/tensi/tensi_normal.png"><div id="title_chara_light"></div></div>' +
  '<div id="title_haze"></div>' +
  '<div class="title-orb" style="width:38px;height:38px;top:180px;left:130px;"></div>' +
  '<div class="title-orb" style="width:22px;height:22px;top:350px;left:55px;"></div>' +
  '<div class="title-orb" style="width:30px;height:30px;top:95px;left:400px;"></div>' +
  '<div class="title-orb" style="width:28px;height:28px;top:290px;left:970px;"></div>' +
  '<div class="title-orb" style="width:20px;height:20px;top:450px;left:1090px;"></div>' +
  '<div class="title-orb" style="width:24px;height:24px;top:130px;left:860px;"></div>' +
  '<div class="title-orb" style="width:16px;height:16px;top:500px;left:45px;"></div>' +
  '<div class="title-orb" style="width:32px;height:32px;top:240px;left:680px;"></div>' +
  '<div class="title-orb" style="width:18px;height:18px;top:420px;left:300px;"></div>' +
  '<div class="title-orb" style="width:26px;height:26px;top:60px;left:600px;"></div>' +
  '<div class="title-orb" style="width:14px;height:14px;top:550px;left:820px;"></div>' +
  '<div class="title-orb" style="width:20px;height:20px;top:310px;left:1150px;"></div>' +
  '<div class="title-orb" style="width:34px;height:34px;top:160px;left:250px;"></div>' +
  '<div class="title-orb" style="width:18px;height:18px;top:480px;left:730px;"></div>' +
  '<div class="title-orb" style="width:26px;height:26px;top:540px;left:200px;"></div>' +
  '<div class="title-orb" style="width:20px;height:20px;top:580px;left:950px;"></div>' +
  '<div class="title-orb" style="width:16px;height:16px;top:520px;left:560px;"></div>' +
  '<div class="title-orb" style="width:22px;height:22px;top:600px;left:380px;"></div>' +
  '<div class="title-orb" style="width:14px;height:14px;top:560px;left:1150px;"></div>' +
  '<div id="title_logo"><img src="./data/image/title/title_logo.png"></div>' +
  '<div id="title_buttons">' +
  '<div class="title-btn" id="tbtn_newgame"><div class="title-btn-en">New Game</div><div class="title-btn-ja">はじめから</div></div>' +
  '<div class="title-btn" id="tbtn_continue"><div class="title-btn-en">Continue</div><div class="title-btn-ja">つづきから</div></div>' +
  '<div class="title-btn" id="tbtn_config"><div class="title-btn-en">Config</div><div class="title-btn-ja">環境設定</div></div>' +
  '<div class="title-btn" id="tbtn_extra"><div class="title-btn-en">Extra</div><div class="title-btn-ja">エクストラ</div></div>' +
  '<div class="title-btn" id="tbtn_exit"><div class="title-btn-en">Exit</div><div class="title-btn-ja">ゲーム終了</div></div>' +
  '</div></div>'
);

// Config/Extraから戻った場合はアニメーションをスキップ
var _skipAnim = !!(tf._title_skip_anim);
tf._title_skip_anim = false;

// 背景フェードイン（白オーバーレイをフェードアウト）
anime({
  targets: '#title_fade_overlay',
  opacity: [1, 0],
  duration: _skipAnim ? 600 : 1500,
  easing: 'easeOutQuad',
  complete: function() { $('#title_fade_overlay').remove(); }
});

// 霞・キャラ・ロゴ・ボタンのフェードイン
var _btnReady = false;
if (_skipAnim) {
  // Config/Extraから戻った場合：アニメーションなしで即表示
  $('#title_haze').css('opacity', 1);
  $('#title_chara').css('opacity', 1);
  $('#title_logo').css('opacity', 1);
  $('.title-btn').css('opacity', 1);
  _btnReady = true;
} else {
  // 通常のフェードインアニメーション
  anime({ targets: '#title_haze', opacity: [0, 1], duration: 800, easing: 'easeOutQuad', delay: 1200 });
  anime({ targets: '#title_chara', opacity: [0, 1], duration: 800, easing: 'easeOutQuad', delay: 1800 });
  anime({ targets: '#title_logo', opacity: [0, 1], translateY: [-30, 0], duration: 1000, easing: 'easeOutCubic', delay: 3100 });
  anime({
    targets: '.title-btn',
    opacity: [0, 1],
    translateY: [15, 0],
    duration: 700,
    easing: 'easeOutCubic',
    delay: anime.stagger(120, {start: 4200}),
    complete: function() { _btnReady = true; }
  });
}


// 光の玉 浮遊アニメーション
var orbOpacity = [0.7, 0.55, 0.65, 0.6, 0.5, 0.6, 0.45, 0.65, 0.5, 0.6, 0.4, 0.55, 0.7, 0.5, 0.6, 0.5, 0.55, 0.45, 0.4];
var orbDirX = [1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1];
$('.title-orb').each(function(i, orb) {
  if (_skipAnim) {
    $(orb).css('opacity', orbOpacity[i]);
  } else {
    anime({ targets: orb, opacity: [0, orbOpacity[i]], duration: 1800, easing: 'easeOutQuad', delay: 3900 + i * 250 });
  }
  anime({
    targets: orb,
    translateY: -(45 + i * 10),
    translateX: orbDirX[i] * (35 + i * 6),
    duration: 3000 + i * 400,
    easing: 'easeInOutSine',
    direction: 'alternate',
    loop: true,
    delay: _skipAnim ? 0 : (3900 + i * 250)
  });
});

// ホバーSE
$('.title-btn').on('mouseenter', function() {
  if (!_btnReady) return;
  TYRANO.kag.ftag.startTag('playse', {storage:'piano_po-n.mp3'});
});

// クリックSE
$('.title-btn').on('click', function() {
  TYRANO.kag.ftag.startTag('playse', {storage:'start.mp3'});
});

$('#tbtn_newgame').on('click', function(e) {
  e.stopPropagation();
  $('.tyrano_base').append('<div id="ng_black" style="position:absolute;top:0;left:0;width:1280px;height:720px;background:#000;z-index:99999;opacity:0;pointer-events:none;"></div>');
  anime({
    targets: '#ng_black',
    opacity: [0, 1],
    duration: 800,
    easing: 'easeInQuad',
    complete: function() {
      $('#title_ui').remove();
      TYRANO.kag.ftag.startTag('jump', {storage:'scene0.ks', target:''});
    }
  });
});
$('#tbtn_continue').on('click', function(e) {
  e.stopPropagation();
  $('.title-btn').css('pointer-events', 'none');
  $('<div id="exit_overlay">').css({position:'absolute',top:0,left:0,width:'1280px',height:'720px',background:'#f5e8d5',zIndex:99999,opacity:0,pointerEvents:'none'}).appendTo('.tyrano_base');
  anime({
    targets: '#exit_overlay',
    opacity: [0, 1],
    duration: 150,
    easing: 'easeInQuad',
    complete: function() {
      var wasShown = false;
      TYRANO.kag.menu.displayLoad();
      var check = setInterval(function() {
        var $menu = TYRANO.kag.layer.getMenuLayer();
        if (!wasShown) {
          if ($menu.is(':visible')) {
            wasShown = true;
            anime({targets:'#exit_overlay', opacity:0, duration:200, easing:'easeOutQuad', complete:function(){ $('#exit_overlay').remove(); }});
          }
        } else if (!$menu.is(':visible')) {
          clearInterval(check);
          $('.title-btn').css('pointer-events', 'all');
        }
      }, 100);
    }
  });
});
$('#tbtn_config').on('click', function(e) {
  e.stopPropagation();
  $('.title-btn').css('pointer-events', 'none');
  $('<div id="exit_overlay">').css({position:'absolute',top:0,left:0,width:'1280px',height:'720px',background:'#f5e8d5',zIndex:99999,opacity:0,pointerEvents:'none'}).appendTo('.tyrano_base');
  anime({
    targets: '#exit_overlay',
    opacity: [0, 1],
    duration: 150,
    easing: 'easeInQuad',
    complete: function() {
      tf._title_skip_anim = true;
      TYRANO.kag.ftag.startTag('jump', {storage:'config.ks', target:''});
    }
  });
});
$('#tbtn_extra').on('click', function(e) {
  e.stopPropagation();
  $('.title-btn').css('pointer-events', 'none');
  $('<div id="exit_overlay">').css({position:'absolute',top:0,left:0,width:'1280px',height:'720px',background:'#f5e8d5',zIndex:99999,opacity:0,pointerEvents:'none'}).appendTo('.tyrano_base');
  anime({
    targets: '#exit_overlay',
    opacity: [0, 1],
    duration: 150,
    easing: 'easeInQuad',
    complete: function() {
      tf._title_skip_anim = true;
      TYRANO.kag.ftag.startTag('jump', {storage:'cg.ks', target:''});
    }
  });
});
$('#tbtn_exit').on('click', function(e) {
  e.stopPropagation();
  if (typeof nw !== 'undefined') { nw.App.quit(); }
  else { window.close(); }
});
[endscript]

[s]

*do_newgame
*gamestart
[iscript]$('#title_ui').remove();[endscript]
@jump storage="scene0.ks"

*do_load
[iscript]$('#title_ui').remove();[endscript]
[load]
@jump storage="title.ks"

*do_config
[iscript]$('#title_ui').remove();[endscript]
[sleepgame storage="config.ks"]
@jump storage="title.ks"

*do_exit
[iscript]
if (typeof nw !== 'undefined') { nw.App.quit(); }
else { window.close(); }
[endscript]
