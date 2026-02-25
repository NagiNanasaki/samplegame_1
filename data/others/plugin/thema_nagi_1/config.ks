; ==============================================================
; thema_nagi_1 - コンフィグ（設定）画面
; sleepgame ロールのボタンから自動的に呼び出される
; ==============================================================

[layopt layer="message0" visible="false"]
[clearfix]
[stop_keyconfig]
[free_layermode time="100" wait="true"]
[reset_camera time="100" wait="true"]
[iscript]
$(".layer_camera").empty();
$("#bgmovie").remove();
[endscript]
[hidemenubutton]

[iscript]
// ---- 設定値マッピング（変更する場合はここを編集） ----
tf._vols  = [0, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100]; // 音量（11段階）
tf._chs   = [100, 80, 50, 40, 30, 25, 20, 11, 8, 5];       // テキスト速度（10段階）
tf._autos = [5000, 4500, 4000, 3500, 3000, 2500, 2000, 1300, 800, 500]; // オート速度（10段階）

// ボタンのX座標（10段階スライダー）
tf._cfgXs = [375, 425, 475, 525, 575, 625, 675, 725, 775, 825];

// 現在の設定を読み込んでインデックスに変換
tf._bgmIdx  = tf._vols.indexOf(parseInt(TG.config.defaultBgmVolume));
tf._seIdx   = tf._vols.indexOf(parseInt(TG.config.defaultSeVolume));
tf._chIdx   = tf._chs.indexOf(parseInt(TG.config.chSpeed));
tf._autoIdx = tf._autos.indexOf(parseInt(TG.config.autoSpeed));
tf._skipUnread = (TG.config.unReadTextSkip === "true");

// インデックスが見つからない場合のデフォルト（各中間値）
if (tf._bgmIdx  < 0) tf._bgmIdx  = 5;
if (tf._seIdx   < 0) tf._seIdx   = 5;
if (tf._chIdx   < 0) tf._chIdx   = 4;
if (tf._autoIdx < 0) tf._autoIdx = 4;

// ミュート前の音量を記憶（一度だけ初期化）
if (typeof f._prevBgmVol === "undefined") {
  f._prevBgmVol = [tf._bgmIdx > 0 ? tf._vols[tf._bgmIdx] : 50, tf._bgmIdx > 0 ? tf._bgmIdx : 5];
  f._prevSeVol  = [tf._seIdx  > 0 ? tf._vols[tf._seIdx]  : 50, tf._seIdx  > 0 ? tf._seIdx  : 5];
}

tf._cfgImg = "../others/plugin/thema_nagi_1/image/config/";
[endscript]

[cm]
[bg storage="&tf._cfgImg + 'bg_config.jpg'" time="100"]
[button fix="true" graphic="&tf._cfgImg+'c_btn_back.png'" enterimg="&tf._cfgImg+'c_btn_back2.png'" target="*cfg_end" x="1170" y="20"]

[jump target="*cfg_draw"]

; ==============================================================
; コンフィグ画面の描画
; ==============================================================
*cfg_draw
[clearstack]

[iscript]
var _off = tf._cfgImg + "off.gif";

// ---- BGM音量ボタン（10段階） ----
for (var i = 0; i < 10; i++) {
  TYRANO.kag.ftag.startTag("button", {
    name: "bgmvol,bgmvol_"+(i+1), fix: "true", target: "*vol_bgm_change",
    graphic: _off, width: "40", height: "40",
    x: String(tf._cfgXs[i]), y: "195",
    exp: "tf._bgmIdx="+(i+1),
  });
}
// BGMミュートボタン
TYRANO.kag.ftag.startTag("button", {
  name: "bgmvol,bgmvol_0", fix: "true", target: "*vol_bgm_mute",
  graphic: _off, width: "32", height: "32", x: "956", y: "197",
});

// ---- SE音量ボタン（10段階） ----
for (var i = 0; i < 10; i++) {
  TYRANO.kag.ftag.startTag("button", {
    name: "sevol,sevol_"+(i+1), fix: "true", target: "*vol_se_change",
    graphic: _off, width: "40", height: "40",
    x: String(tf._cfgXs[i]), y: "275",
    exp: "tf._seIdx="+(i+1),
  });
}
// SEミュートボタン
TYRANO.kag.ftag.startTag("button", {
  name: "sevol,sevol_0", fix: "true", target: "*vol_se_mute",
  graphic: _off, width: "32", height: "32", x: "956", y: "280",
});

// ---- テキスト速度ボタン（10段階） ----
for (var i = 0; i < 10; i++) {
  TYRANO.kag.ftag.startTag("button", {
    name: "ch,ch_"+tf._chs[i], fix: "true", target: "*ch_speed_change",
    graphic: _off, width: "40", height: "40",
    x: String(tf._cfgXs[i]), y: "355",
    exp: "tf._chIdx="+i,
  });
}

// ---- オート速度ボタン（10段階） ----
for (var i = 0; i < 10; i++) {
  TYRANO.kag.ftag.startTag("button", {
    name: "auto,auto_"+tf._autos[i], fix: "true", target: "*auto_speed_change",
    graphic: _off, width: "40", height: "40",
    x: String(tf._cfgXs[i]), y: "435",
    exp: "tf._autoIdx="+i,
  });
}

// ---- 未読スキップトグルボタン ----
TYRANO.kag.ftag.startTag("button", {
  name: "unread_on", fix: "true", target: "*skip_toggle",
  graphic: _off, width: "32", height: "32", x: "956", y: "360",
});
[endscript]

[layopt layer="0" visible="true"]
[call target="*draw_bgm"]
[call target="*draw_se"]
[call target="*draw_ch"]
[call target="*draw_auto"]
[call target="*draw_skip"]

[s]

; ==============================================================
; 終了処理
; ==============================================================
*cfg_end
[cm]
[layopt layer="message1" visible="false"]
[clearfix]
[start_keyconfig]
[clearstack]
[awakegame]

; ==============================================================
; ボタンクリック処理
; ==============================================================

; ---- BGM ----
*vol_bgm_mute
[iscript]
if (tf._bgmIdx !== 0) {
  f._prevBgmVol = [tf._vols[tf._bgmIdx], tf._bgmIdx];
  tf._bgmIdx = 0;
} else {
  tf._bgmIdx = f._prevBgmVol[1];
}
[endscript]
*vol_bgm_change
[free layer="0" name="bgmvol" time="0" wait="true"]
[call target="*draw_bgm"]
[bgmopt volume="&tf._vols[tf._bgmIdx]"]
[return]

; ---- SE ----
*vol_se_mute
[iscript]
if (tf._seIdx !== 0) {
  f._prevSeVol = [tf._vols[tf._seIdx], tf._seIdx];
  tf._seIdx = 0;
} else {
  tf._seIdx = f._prevSeVol[1];
}
[endscript]
*vol_se_change
[free layer="0" name="sevol" time="0" wait="true"]
[call target="*draw_se"]
[seopt volume="&tf._vols[tf._seIdx]"]
[return]

; ---- テキスト速度 ----
*ch_speed_change
[free layer="0" name="ch" time="0" wait="true"]
[call target="*draw_ch"]
[configdelay speed="&tf._chs[tf._chIdx]"]
[return]

; ---- オート速度 ----
*auto_speed_change
[free layer="0" name="auto" time="0" wait="true"]
[call target="*draw_auto"]
[autoconfig speed="&tf._autos[tf._autoIdx]"]
[return]

; ---- 未読スキップ ----
*skip_toggle
[iscript]
tf._skipUnread = !tf._skipUnread;
[endscript]
[free layer="0" name="skip" time="0" wait="true"]
[call target="*draw_skip"]
[config_record_label skip="&tf._skipUnread ? 'true' : 'false'"]
[return]

; ==============================================================
; インジケータ画像の描画
; ==============================================================

*draw_bgm
[if exp="tf._bgmIdx === 0"]
[image layer="0" name="bgmvol" storage="&tf._cfgImg+'check.png'" x="956" y="197"]
[else]
[image layer="0" name="bgmvol" storage="&tf._cfgImg+'on.png'" x="&tf._cfgXs[tf._bgmIdx-1]-5" y="190"]
[endif]
[return]

*draw_se
[if exp="tf._seIdx === 0"]
[image layer="0" name="sevol" storage="&tf._cfgImg+'check.png'" x="956" y="280"]
[else]
[image layer="0" name="sevol" storage="&tf._cfgImg+'on.png'" x="&tf._cfgXs[tf._seIdx-1]-5" y="270"]
[endif]
[return]

*draw_ch
[image layer="0" name="ch" storage="&tf._cfgImg+'on.png'" x="&tf._cfgXs[tf._chIdx]-5" y="350"]
[return]

*draw_auto
[image layer="0" name="auto" storage="&tf._cfgImg+'on.png'" x="&tf._cfgXs[tf._autoIdx]-5" y="430"]
[return]

*draw_skip
[if exp="tf._skipUnread"]
[image layer="0" name="skip" storage="&tf._cfgImg+'check.png'" x="956" y="360"]
[else]
[free layer="0" name="skip" time="0" wait="true"]
[endif]
[return]
