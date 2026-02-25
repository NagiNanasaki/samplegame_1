; ==============================================================
; thema_nagi_1 - TyranoScript システムUIテーマプラグイン
; 作者: [七咲凪（ている×ている）]
;
; 【導入方法】
;   data/others/plugin/ に thema_nagi_1 フォルダを配置し、
;   first.ks に [plugin name="thema_nagi_1"] と記述する。
;
; 【パラメータ一覧（すべて省略可）】
;   font_color    : 本文フォントカラー（例: 0xf2f2f2）
;   name_color    : 名前フォントカラー
;   frame_opacity : メッセージ枠の不透明度（0〜255）
;   glyph         : クリック待ちグリフ使用 on/off
;   btn_y         : 機能ボタンのY座標（デフォルト: 10）
; ==============================================================

[iscript]
// ---- 設定値（mpパラメータで上書き可能） ----
tf._ts = {
  dir:     "../others/plugin/thema_nagi_1/image/",
  font:    mp.font_color    || "0xf2f2f2",
  name:    mp.name_color    || "0xf2f2f2",
  opacity: mp.frame_opacity || "255",
  glyph:   mp.glyph         === "on",
  fade:    mp.fade          === "on",               // フェード on/off（デフォルト: off）
  btnPos:  mp.btn_pos       || "bottom",            // ボタン位置 "top" or "bottom"（デフォルト: bottom）
  btnY:    parseInt(mp.btn_y) || (mp.btn_pos === "top" ? 10 : 693),
};

// 既読テキストカラー設定
if (TG.config.alreadyReadTextColor !== "default") {
  TG.config.alreadyReadTextColor = mp.font_color2 || tf._ts.font;
}
[endscript]

; ---- メッセージウィンドウ設定 ----
[free name="chara_name_area" layer="message0"]
[position layer="message0" width="1280" height="275" top="447" left="0"]
[position layer="message0" frame="&tf._ts.dir+'frame_message.png'" margint="110" marginl="140" marginr="150" opacity="&tf._ts.opacity" page="fore"]

; 名前表示エリア
[ptext name="chara_name_area" layer="message0" color="&tf._ts.name" size="26" bold="bold" x="100" y="520"]
[chara_config ptext="chara_name_area"]

; フォントカラー
[font color="&tf._ts.font"]
[deffont color="&tf._ts.font"]

; クリック待ちグリフ（glyph="on" 指定時のみ有効）
[if exp="tf._ts.glyph"]
[glyph line="../../../data/others/plugin/thema_nagi_1/image/system/nextpage.gif"]
[endif]

; ==============================================================
; [tsw_button] マクロ
;   機能ボタンを表示したいシーンで呼び出す
;   非表示: [clearfix name="role_button"]
; ==============================================================
[macro name="tsw_button"]
[hidemenubutton]
; ---- ボタン一覧 ----
; 追加・削除・X座標変更はここを編集する。
; graphic/enterimg のパスは tf._ts.dir（init.ks 冒頭で定義）を参照。
; Y座標は tf._ts.btnY（plugin タグの btn_y パラメータで変更可）。
[button name="role_button" role="quicksave"  graphic="&tf._ts.dir+'button/qsave.png'"  enterimg="&tf._ts.dir+'button/qsave2.png'"  x="152"  y="&tf._ts.btnY"]
[button name="role_button" role="quickload"  graphic="&tf._ts.dir+'button/qload.png'"  enterimg="&tf._ts.dir+'button/qload2.png'"  x="234"  y="&tf._ts.btnY"]
[button name="role_button" role="save"       graphic="&tf._ts.dir+'button/save.png'"   enterimg="&tf._ts.dir+'button/save2.png'"   x="316"  y="&tf._ts.btnY"]
[button name="role_button" role="load"       graphic="&tf._ts.dir+'button/load.png'"   enterimg="&tf._ts.dir+'button/load2.png'"   x="398"  y="&tf._ts.btnY"]
[button name="role_button" role="auto"       graphic="&tf._ts.dir+'button/auto.png'"   enterimg="&tf._ts.dir+'button/auto2.png'"   x="480"  y="&tf._ts.btnY"]
[button name="role_button" role="skip"       graphic="&tf._ts.dir+'button/skip.png'"   enterimg="&tf._ts.dir+'button/skip2.png'"   x="562"  y="&tf._ts.btnY"]
[button name="role_button" role="backlog"    graphic="&tf._ts.dir+'button/log.png'"    enterimg="&tf._ts.dir+'button/log2.png'"    x="644"  y="&tf._ts.btnY"]
[button name="role_button" role="fullscreen" graphic="&tf._ts.dir+'button/screen.png'" enterimg="&tf._ts.dir+'button/screen2.png'" x="726"  y="&tf._ts.btnY"]
[button name="role_button" role="sleepgame"  graphic="&tf._ts.dir+'button/sleep.png'"  enterimg="&tf._ts.dir+'button/sleep2.png'"  x="808"  y="&tf._ts.btnY" storage="../others/plugin/thema_nagi_1/config.ks"]
[button name="role_button" role="menu"       graphic="&tf._ts.dir+'button/menu.png'"   enterimg="&tf._ts.dir+'button/menu2.png'"   x="890"  y="&tf._ts.btnY"]
[button name="role_button" role="window"     graphic="&tf._ts.dir+'button/close.png'"  enterimg="&tf._ts.dir+'button/close2.png'"  x="972"  y="&tf._ts.btnY"]
[button name="role_button" role="title"      graphic="&tf._ts.dir+'button/title.png'"  enterimg="&tf._ts.dir+'button/title2.png'"  x="1054" y="&tf._ts.btnY"]

; ---- ホバー表示の設定 ----
[iscript]
(function() {
  // ---- カスタマイズ項目 ----
  var TRIGGER_Y = 90;   // ホバー検知エリアの幅（px）。上端/下端からこの距離以内でボタン表示
  var FADE_MS   = 200;  // フェードの速さ（ミリ秒）

  var fade   = tf._ts.fade;    // true: フェードON（ホバー時のみ表示）  false: 常時表示
  var btnPos = tf._ts.btnPos;  // "top": 上端ホバー検知  "bottom": 下端ホバー検知

  var $base = $("#tyrano_base");

  function findBtns() {
    return $(".role_button");
  }

  function setBtns(visible) {
    findBtns().css({
      opacity:          visible ? 1 : 0,
      transition:       fade ? ("opacity " + FADE_MS + "ms ease") : "none",
      "pointer-events": visible ? "auto" : "none",
    });
  }

  if (!fade) {
    // フェードOFF: 常時表示
    setTimeout(function() { setBtns(true); }, 50);
    return;
  }

  // フェードON: ホバー検知
  // 追加直後に非表示にする（次フレームまで待つ）
  setTimeout(function() { setBtns(false); }, 50);

  // イベント登録（namespace で重複防止）
  if (!$base.data("tsw_hover")) {
    $base.data("tsw_hover", true);

    $(document).on("mousemove.tsw", function(e) {
      var rect  = $base[0].getBoundingClientRect();
      var scale = rect.height / 720;
      var gameY = (e.clientY - rect.top) / scale;
      var show  = (btnPos === "bottom") ? (gameY >= 720 - TRIGGER_Y) : (gameY <= TRIGGER_Y);
      setBtns(show);
    });

    $base.on("mouseleave.tsw", function() { setBtns(false); });
  }
})();
[endscript]
[endmacro]

; ==============================================================
; システム画面の切り替え
; ==============================================================
[sysview type="save"    storage="./data/others/plugin/thema_nagi_1/html/save.html"]
[sysview type="load"    storage="./data/others/plugin/thema_nagi_1/html/load.html"]
[sysview type="backlog" storage="./data/others/plugin/thema_nagi_1/html/backlog.html"]
[sysview type="menu"    storage="./data/others/plugin/thema_nagi_1/html/menu.html"]
[loadcss  file="./data/others/plugin/thema_nagi_1/style.css"]

; ==============================================================
; [cg] マクロ  ―  CG解放
;   ゲーム本編で CG を解放するときに呼ぶ。
;   storage に bgimage フォルダ基準のファイル名を指定する。
;   例: [cg storage="cg01.jpg"]
;   ファイル名の変換（ドット→アンダースコア等）は内部で自動処理。
; ==============================================================
[macro name="cg"]
[iscript]
var _key = "cg_" + mp.storage.replace(/[^a-zA-Z0-9]/g, "_");
sf[_key] = 1;
[endscript]
[endmacro]

; ==============================================================
; 画像プリロード（ゲーム開始時に先読みしておく）
; ==============================================================
[iscript]
var _d = "./data/others/plugin/thema_nagi_1/image/";

// ボタン画像（通常 + ホバー）
var _btnNames = ["qsave","qload","save","load","auto","skip","log","screen","sleep","menu","close","title"];
var _btnImgs  = _btnNames.reduce(function(arr, n) {
  return arr.concat([_d+"button/"+n+".png", _d+"button/"+n+"2.png"]);
}, []);

// システム・コンフィグ画像
var _sysImgs = [
  "frame_message.png",
  "system/arrow_down.png",  "system/arrow_next.png",
  "system/arrow_prev.png",  "system/arrow_up.png",
  "system/menu_bg.jpg",
  "system/menu_button_close.png",   "system/menu_button_close2.png",
  "system/menu_button_load.png",    "system/menu_button_load2.png",
  "system/menu_button_save.png",    "system/menu_button_save2.png",
  "system/menu_button_skip.png",    "system/menu_button_skip2.png",
  "system/menu_button_title.png",   "system/menu_button_title2.png",
  "system/menu_load_bg.jpg",        "system/menu_log_bg.jpg",
  "system/menu_message_close.png",  "system/menu_message_close2.png",
  "system/menu_save_bg.jpg",
  "system/nextpage.gif",
  "system/saveslot.png",            "system/saveslot2.png",
  "config/bg_config.jpg",
  "config/check.png",
  "config/c_btn_back.png",          "config/c_btn_back2.png",
  "config/off.gif",                 "config/on.png",
].map(function(p) { return _d + p; });

f._ts_preload = _btnImgs.concat(_sysImgs);
[endscript]
[preload storage="&f._ts_preload" wait="false"]

[return]
