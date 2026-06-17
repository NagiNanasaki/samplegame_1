;一番最初に呼び出されるファイル

[title name="サンプルゲーム"]

[stop_keyconfig]


;ティラノスクリプトが標準で用意している便利なライブラリ群
;コンフィグ、CG、回想モードを使う場合は必須
@call storage="tyrano.ks"

;ゲームで必ず必要な初期化処理はこのファイルに記述するのがオススメ

;最初は右下のメニューボタン・メッセージウィンドウを非表示にする
[iscript]
$(".menu_icon_area").hide();
$(".layer_menu").hide();
[endscript]
[hidemenubutton]
@layopt layer="message0" visible=false

;opening_splashプラグイン読み込み
[plugin name="opening_splash"]

;テーマプラグイン読み込み
[plugin name="thema_nagi_1" fade="off" btn_pos="bottom"]
@layopt layer="message0" visible=false
[hidemenubutton]

[plugin name="fade_frame" ]

;マスクプラグイン読み込み
[plugin name=mask_rule]
[plugin name=bg_rule]


;-------------------------------------------
; 音声注意画面
; ブラウザの Web Audio 制限により、最初のユーザー操作が
; 必要なため、ここでクリックを要求する。
; このクリックが音声コンテキストの解放も兼ねる。
;-------------------------------------------
[iscript]
$('#_sound_notice').remove();
$('.tyrano_base').append(
  '<div id="_sound_notice" style="' +
    'position:absolute;top:0;left:0;width:1280px;height:720px;' +
    'background:#faf8f4;z-index:99999;cursor:pointer;pointer-events:all;' +
    'display:flex;flex-direction:column;align-items:center;justify-content:center;">' +
  '<div style="text-align:center;font-family:Georgia,serif;">' +
    '<p style="font-size:17px;color:#3a2a10;letter-spacing:0.2em;margin:0 0 10px;">' +
      'このゲームには BGM・効果音が含まれます' +
    '</p>' +
    '<p style="font-size:12px;color:#7a5a30;letter-spacing:0.15em;margin:0 0 52px;">' +
      'ヘッドホン・スピーカーの音量にご注意ください' +
    '</p>' +
    '<p style="font-size:12px;color:#a07840;letter-spacing:0.35em;' +
      'border:1px solid rgba(160,120,64,0.45);padding:11px 36px;display:inline-block;">' +
      'C L I C K &nbsp; T O &nbsp; S T A R T' +
    '</p>' +
  '</div>' +
  '</div>'
);
var _soundNoticeStarted = false;
$('#_sound_notice').on('click', function() {
  if (_soundNoticeStarted) return;
  _soundNoticeStarted = true;
  var $notice = $(this);
  try {
    if (TYRANO.kag && !TYRANO.kag.tmp.ready_audio) {
      TYRANO.kag.readyAudio();
    }
  } catch(e) { console.error("[sound notice readyAudio]", e); }

  // タイトルBGMをオーディオAPIが解放されたタイミングで先行バッファリング
  // opening splash 中にデコードを済ませ、title.ks 到達時に即再生できるようにする
  try {
    if (!window._nagiOpPreload) {
      window._nagiOpPreload = new Audio('./data/bgm/op.mp3');
      window._nagiOpPreload.preload = 'auto';
      window._nagiOpPreload.muted = true;
      window._nagiOpPreload.load();
    }
  } catch(e) {}

  $notice.find('p').eq(2).text('L O A D I N G').css('letter-spacing', '0.32em');
  $notice.find('div').first().append(
    '<p id="_sound_notice_progress" style="font-size:11px;color:#a07840;letter-spacing:0.12em;margin:18px 0 0;">0%</p>'
  );

  var startOpening = function() {
    $notice.animate({opacity: 0}, 350, function() {
      $(this).remove();
      TYRANO.kag.ftag.startTag('jump', {storage:'first.ks', target:'*_show_opening'});
    });
  };

  if (window.NAGI_WEB_PRELOAD && window.NAGI_WEB_PRELOAD.shouldRun()) {
    window.NAGI_WEB_PRELOAD.prepare({
      onProgress: function(done, total) {
        var percent = total > 0 ? Math.floor(done / total * 100) : 100;
        $('#_sound_notice_progress').text(percent + '%');
      }
    }).then(startOpening).catch(function(e) {
      console.error("[web preload]", e);
      startOpening();
    });
  } else {
    startOpening();
  }
});
[endscript]
[s]

;オープニングスプラッシュ表示
*_show_opening
[show_opening logo=logo.png warning=warning.png]

;タイトル画面へ移動
@jump storage="title.ks"

[s]


