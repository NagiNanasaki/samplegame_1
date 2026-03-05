
[cm]

; 呼び出し履歴をリセット（[jump] で戻ってきた時にスタックが積まれないようにする）
@clearstack

; カメラをリセット（スチル演出などでカメラが動いた場合に備えて初期状態に戻す）
; NOTE: layer="base" が有効なレイヤー指定か不明だが現状動作している。将来的に確認推奨
[reset_camera layer="base" time="1"]

; タイトル背景画像を即座に設定（time=0 でフェードなし）
@bg storage="title_menu.png" time=0

;-------------------------------------------
; chara_ptext フックの設定
;
; [chara_ptext] タグが呼ばれるたびに、表示中のキャラ名を
; f._last_chara_name に保存する処理をフックとして差し込む。
;
; 目的：qsave/qload 後にキャラ名が消えるバグへの対策。
; TyranoScript の HTML セーブ/ロードは ptext 要素のテキストを
; 復元しないため、自前で名前を保存して make.ks で復元する。
;
; _hooked フラグを確認して二重フックを防いでいる。
;-------------------------------------------
[iscript]
try {
    if (TYRANO.kag.tag.chara_ptext && !TYRANO.kag.tag.chara_ptext._hooked) {
        // 元の start 関数を退避
        TYRANO.kag.tag.chara_ptext._origStart = TYRANO.kag.tag.chara_ptext.start;
        // 新しい start 関数でラップ（キャラ名を保存してから元の処理を呼ぶ）
        TYRANO.kag.tag.chara_ptext.start = function(pm) {
            // f 変数（セーブデータに含まれる）にキャラ名を保存
            // stat 直接プロパティは clearTmpVariable で消えるため f を使う
            if (TYRANO.kag.stat.f) { TYRANO.kag.stat.f._last_chara_name = pm.name != null ? pm.name : ""; }
            TYRANO.kag.tag.chara_ptext._origStart.call(this, pm);
        };
        TYRANO.kag.tag.chara_ptext._hooked = true;
    }
} catch(e) { console.error("[chara_ptext hook]", e); }
[endscript]

;-------------------------------------------
; 白オーバーレイを追加（Config/Extra からの復帰時や
; 初回表示時のちらつきを防ぐための白いフラッシュカバー）
;-------------------------------------------
[iscript]
// 既存の白オーバーレイを削除してから新規作成（二重作成を防ぐ）
$('#title_fade_overlay').remove();
$('.tyrano_base').append('<div id="title_fade_overlay" style="position:absolute;top:0;left:0;width:1280px;height:720px;background:#fff;z-index:99999;pointer-events:none;"></div>');
[endscript]

; マスク（黒暗転）を即座に解除
@mask_off time="0"

*start

; BGMを再生（Config/Extraから戻った場合はスキップ）
; tf._title_skip_anim は Config/Extra への jump 前に true にセットされ、
; 戻った後の iscript で false にリセットされる
[if exp="!tf._title_skip_anim"]
[playbgm storage="op.mp3"]
[endif]

;-------------------------------------------
; タイトル画面 UI の構築（anime.js を使ったアニメーション付き）
;
; DOM 構成:
;   #title_ui         : 全体のコンテナ（z-index:10000）
;   #title_bg_zoom    : 背景画像のズームアニメーション用要素
;   .title-orb        : 浮遊する光の玉（複数）
;   #title_chara      : キャラクター立ち絵
;   #title_chara_light: キャラクターの光エフェクト
;   #title_haze       : 画面下部のかすみエフェクト（白グラデーション）
;   #title_logo       : タイトルロゴ画像
;   #title_buttons    : ボタン群（NewGame/Continue/Config/Extra/Exit）
;
; Config/Extra から戻る場合は _skipAnim フラグで
; アニメーションをスキップして即座に最終状態に設定する。
;-------------------------------------------
[iscript]
// 既存の UI を削除してから再構築（[jump] ループでの二重作成を防ぐ）
$('#title_ui').remove();

// タイトル UI 全体を .tyrano_base に追加
$('.tyrano_base').append(
  '<div id="title_ui" style="position:absolute;top:0;left:0;width:1280px;height:720px;pointer-events:none;z-index:10000;">' +
  '<style>' +
  // 背景のズームアニメーション用レイヤー（画像を115%に拡大して中心を見せる）
  '#title_bg_zoom{position:absolute;top:-7.5%;left:-7.5%;width:115%;height:115%;background:url(./data/bgimage/title_menu.png) center/cover no-repeat;pointer-events:none;}' +
  // 光の玉の共通スタイル（円形・放射状グラデーション・ぼかし）
  '.title-orb{position:absolute;border-radius:50%;background:radial-gradient(circle,rgba(255,245,210,0.95) 0%,rgba(255,220,160,0.4) 45%,transparent 70%);pointer-events:none;opacity:0;filter:blur(5px);}' +
  // キャラクター立ち絵（中央下から表示）
  '#title_chara{position:absolute;bottom:-40px;left:50%;transform:translateX(-50%);height:580px;width:fit-content;pointer-events:none;opacity:0;}' +
  '#title_chara img{height:100%;width:auto;display:block;filter:drop-shadow(0 0 6px rgba(255,230,180,0.65)) drop-shadow(0 0 20px rgba(255,200,130,0.3));}' +
  // キャラクターの光エフェクト（screen ブレンドで金色に光らせる）
  '#title_chara_light{position:absolute;inset:0;background:linear-gradient(to left,rgba(255,210,130,0.7) 0%,rgba(255,190,100,0.35) 30%,rgba(255,170,80,0.08) 60%,transparent 80%);mix-blend-mode:screen;-webkit-mask-image:url(./data/fgimage/chara/tensi/tensi_normal.png);-webkit-mask-size:100% 100%;-webkit-mask-repeat:no-repeat;pointer-events:none;}' +
  // 画面下部の霞エフェクト（白→透明のグラデーション）
  '#title_haze{position:absolute;bottom:0;left:0;width:100%;height:420px;background:linear-gradient(to top,rgba(255,255,255,1) 0%,rgba(255,255,255,0.92) 12%,rgba(255,255,255,0.7) 30%,rgba(255,255,255,0.35) 55%,rgba(255,255,255,0.08) 80%,transparent 100%);pointer-events:none;opacity:0;}' +
  // タイトルロゴ（左上エリアに配置）
  '#title_logo{position:absolute;left:50px;top:260px;width:420px;pointer-events:none;opacity:0;}' +
  '#title_logo img{width:100%;height:auto;}' +
  // ボタン群のコンテナ（画面下部に横並び）
  '#title_buttons{position:absolute;bottom:45px;left:0;width:100%;display:flex;justify-content:space-around;align-items:center;padding:0 60px;box-sizing:border-box;pointer-events:none;z-index:100;}' +
  // 各ボタン共通スタイル
  '.title-btn{text-align:center;cursor:pointer;padding:12px 24px;pointer-events:all;opacity:0;}' +
  // ボタンの英語テキスト（セリフ体、ゴールド系）
  '.title-btn-en{font-family:Georgia,"Times New Roman",serif;font-size:26px;letter-spacing:3px;color:rgba(40,25,8,0.88);text-shadow:0 1px 3px rgba(255,255,255,0.7);transition:color 0.3s,letter-spacing 0.3s,text-shadow 0.3s;}' +
  // ボタンの日本語テキスト（小さめ、薄めのゴールド）
  '.title-btn-ja{font-size:11px;font-weight:600;letter-spacing:4px;color:rgba(60,40,15,0.7);margin-top:7px;text-shadow:0 1px 2px rgba(255,255,255,0.6);transition:color 0.3s;}' +
  // ホバー時のスタイル変化
  '.title-btn:hover .title-btn-en{color:rgba(120,70,0,1);text-shadow:0 0 12px rgba(180,120,0,0.4),0 1px 3px rgba(255,255,255,0.7);letter-spacing:4px;}' +
  '.title-btn:hover .title-btn-ja{color:rgba(140,90,10,0.95);}' +
  '</style>' +
  '<div id="title_bg_zoom"></div>' +
  // キャラクター画像と光エフェクト
  '<div id="title_chara"><img src="./data/fgimage/chara/tensi/tensi_normal.png"><div id="title_chara_light"></div></div>' +
  // 霞エフェクト
  '<div id="title_haze"></div>' +
  // 光の玉（各自 style で位置・サイズを個別指定）
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
  // ロゴ画像
  '<div id="title_logo"><img src="./data/image/title/title_logo.png"></div>' +
  // ボタン群
  '<div id="title_buttons">' +
  '<div class="title-btn" id="tbtn_newgame"><div class="title-btn-en">New Game</div><div class="title-btn-ja">はじめから</div></div>' +
  '<div class="title-btn" id="tbtn_continue"><div class="title-btn-en">Continue</div><div class="title-btn-ja">つづきから</div></div>' +
  '<div class="title-btn" id="tbtn_config"><div class="title-btn-en">Config</div><div class="title-btn-ja">環境設定</div></div>' +
  '<div class="title-btn" id="tbtn_extra"><div class="title-btn-en">Extra</div><div class="title-btn-ja">エクストラ</div></div>' +
  '<div class="title-btn" id="tbtn_exit"><div class="title-btn-en">Exit</div><div class="title-btn-ja">ゲーム終了</div></div>' +
  '</div></div>'
);

// Config/Extra から戻った場合はアニメーションをスキップするフラグを読み取る
// tf._title_skip_anim は各ボタンの jump 前に true にセットされている
var _skipAnim = !!(tf._title_skip_anim);
tf._title_skip_anim = false; // フラグをリセット（次回通常遷移のため）

// 白オーバーレイをフェードアウト（背景のフェードイン演出）
anime({
  targets: '#title_fade_overlay',
  opacity: [1, 0],
  duration: _skipAnim ? 600 : 1500, // スキップ時は短縮
  easing: 'easeOutQuad',
  complete: function() { $('#title_fade_overlay').remove(); }
});

// 霞・キャラ・ロゴ・ボタンのフェードイン
// _btnReady フラグ：ボタンが表示完了するまでクリック・ホバーSEを無効化するために使用
var _btnReady = false;
if (_skipAnim) {
  // Config/Extra から戻った場合：アニメーションなしで即表示
  $('#title_haze').css('opacity', 1);
  $('#title_chara').css('opacity', 1);
  $('#title_logo').css('opacity', 1);
  $('.title-btn').css('opacity', 1);
  _btnReady = true;
} else {
  // 通常の初回表示：段階的にフェードイン
  anime({ targets: '#title_haze', opacity: [0, 1], duration: 800, easing: 'easeOutQuad', delay: 1200 });
  anime({ targets: '#title_chara', opacity: [0, 1], duration: 800, easing: 'easeOutQuad', delay: 1800 });
  anime({ targets: '#title_logo', opacity: [0, 1], translateY: [-30, 0], duration: 1000, easing: 'easeOutCubic', delay: 3100 });
  anime({
    targets: '.title-btn',
    opacity: [0, 1],
    translateY: [15, 0],
    duration: 700,
    easing: 'easeOutCubic',
    delay: anime.stagger(120, {start: 4200}), // ボタンを順番にずらしてフェードイン
    complete: function() { _btnReady = true; } // 全ボタン表示完了でホバーSEを有効化
  });
}

// 光の玉の浮遊アニメーション
// 各玉に個別の不透明度・方向・速度を設定してランダム感を出す
var orbOpacity = [0.7, 0.55, 0.65, 0.6, 0.5, 0.6, 0.45, 0.65, 0.5, 0.6, 0.4, 0.55, 0.7, 0.5, 0.6, 0.5, 0.55, 0.45, 0.4];
var orbDirX = [1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1, -1, 1]; // 横方向（+右 / -左）
$('.title-orb').each(function(i, orb) {
  if (_skipAnim) {
    // スキップ時はアニメーションなしで最終不透明度に設定
    $(orb).css('opacity', orbOpacity[i]);
  } else {
    // 通常時：フェードインしてから浮遊
    anime({ targets: orb, opacity: [0, orbOpacity[i]], duration: 1800, easing: 'easeOutQuad', delay: 3900 + i * 250 });
  }
  // 上下・左右に揺れるループアニメーション（alternate で往復）
  anime({
    targets: orb,
    translateY: -(45 + i * 10),         // 上方向に移動する量（玉ごとに異なる）
    translateX: orbDirX[i] * (35 + i * 6), // 左右方向に移動する量
    duration: 3000 + i * 400,            // 浮遊スピード（玉ごとに異なる）
    easing: 'easeInOutSine',
    direction: 'alternate',              // 往復アニメーション
    loop: true,
    delay: _skipAnim ? 0 : (3900 + i * 250)
  });
});

// ホバーSE：ボタンにマウスが乗ったときに効果音を再生
// _btnReady が true になるまで（ボタン表示完了前）は再生しない
$('.title-btn').on('mouseenter', function() {
  if (!_btnReady) return;
  TYRANO.kag.ftag.startTag('playse', {storage:'piano_po-n.mp3'});
});

// クリックSE：どのボタンをクリックしても共通の効果音を再生
$('.title-btn').on('click', function() {
  TYRANO.kag.ftag.startTag('playse', {storage:'start.mp3'});
});

//-------------------------------------------
// NewGame ボタン
// 黒フェードしてから scene0.ks にジャンプ
//-------------------------------------------
$('#tbtn_newgame').on('click', function(e) {
  e.stopPropagation(); // イベントバブリングを防止（誤動作防止）
  // 黒オーバーレイを追加してフェードイン
  $('.tyrano_base').append('<div id="ng_black" style="position:absolute;top:0;left:0;width:1280px;height:720px;background:#000;z-index:99999;opacity:0;pointer-events:none;"></div>');
  anime({
    targets: '#ng_black',
    opacity: [0, 1],
    duration: 800,
    easing: 'easeInQuad',
    complete: function() {
      // フェードアウト完了後に UI を削除してゲーム開始
      // #ng_black は scene0.ks の iscript で削除される
      $('#title_ui').remove();
      TYRANO.kag.ftag.startTag('jump', {storage:'scene0.ks', target:''});
    }
  });
});

//-------------------------------------------
// Continue ボタン
// セーブ/ロード画面を表示（TyranoScript 標準機能）
// フェードオーバーレイでちらつきを防ぎ、
// ロード画面が閉じられたらボタンを再有効化する
//-------------------------------------------
$('#tbtn_continue').on('click', function(e) {
  e.stopPropagation();
  $('.title-btn').css('pointer-events', 'none'); // 多重クリック防止
  // 薄いベージュのオーバーレイを表示して画面切り替えを隠す
  $('<div id="exit_overlay">').css({position:'absolute',top:0,left:0,width:'1280px',height:'720px',background:'#f5e8d5',zIndex:99999,opacity:0,pointerEvents:'none'}).appendTo('.tyrano_base');
  anime({
    targets: '#exit_overlay',
    opacity: [0, 1],
    duration: 150,
    easing: 'easeInQuad',
    complete: function() {
      var wasShown = false;
      TYRANO.kag.menu.displayLoad(); // ロード画面を表示
      // setInterval でロード画面の表示/非表示を監視
      var check = setInterval(function() {
        var $menu = TYRANO.kag.layer.getMenuLayer();
        if (!wasShown) {
          if ($menu.is(':visible')) {
            // ロード画面が表示されたらオーバーレイをフェードアウト
            wasShown = true;
            anime({targets:'#exit_overlay', opacity:0, duration:200, easing:'easeOutQuad', complete:function(){ $('#exit_overlay').remove(); }});
          }
        } else if (!$menu.is(':visible')) {
          // ロード画面が閉じられたらボタンを再有効化して監視を止める
          clearInterval(check);
          $('.title-btn').css('pointer-events', 'all');
        }
      }, 100);
    }
  });
});

//-------------------------------------------
// Config ボタン
// config.ks にジャンプしてコンフィグ画面を表示
// 戻り時のアニメーションスキップフラグを立ててから遷移
//-------------------------------------------
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
      // タイトルに戻った時にアニメーションをスキップするフラグをセット
      tf._title_skip_anim = true;
      TYRANO.kag.ftag.startTag('jump', {storage:'config.ks', target:''});
    }
  });
});

//-------------------------------------------
// Extra ボタン
// cg.ks にジャンプして CG モード画面を表示
//-------------------------------------------
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

//-------------------------------------------
// Exit ボタン
// NW.js 環境ならアプリ終了、ブラウザならウィンドウを閉じる
//-------------------------------------------
$('#tbtn_exit').on('click', function(e) {
  e.stopPropagation();
  if (typeof nw !== 'undefined') { nw.App.quit(); } // NW.js (デスクトップアプリ)
  else { window.close(); }                           // ブラウザ
});
[endscript]

[s]


