;=========================================
; config.ks - コンフィグ（環境設定）画面
;
; thema_nagi_1 プラグインのコンフィグ画面実装。
; BGM音量・SE音量・テキスト速度・オート速度・未読スキップを設定できる。
;
; 画面遷移：
;   title.ks の Config ボタン → config.ks （jump）
;   *backtitle ラベル → title.ks （jump）
;
; thema_kopanda_09 ベースの実装
;=========================================

;-------------------------------------------
; 初期化処理
; コンフィグ画面を表示する前に、不要な要素を非表示にして状態を整える
;-------------------------------------------

; メッセージウィンドウを非表示
[layopt layer="message0" visible="false"]
; fixlayer のボタン類を非表示（コンフィグ中はシステムボタン不要）
[clearfix]
; キーボード操作を無効化（コンフィグ中の誤入力を防ぐ）
[stop_keyconfig]
; カメラのレイヤーモード解除（スチル演出後にカメラが残っている場合に備える）
[free_layermode time="100" wait="true"]
; カメラをリセット（ズームやオフセットが残っていた場合に備える）
[reset_camera time="100" wait="true"]

; カメラレイヤーの内容を空にして動画要素を削除
[iscript]
$(".layer_camera").empty();
$("#bgmovie").remove(); // 動画再生中に config を開いた場合の後始末
[endscript]

; システムメニューボタンを非表示
[hidemenubutton]

;-------------------------------------------
; コンフィグ変数の初期化
;
; TG.config から現在の設定値を読み取り、tf 変数に保存する。
; tf 変数は KS タグから参照しやすい形式になっている。
;-------------------------------------------
[iscript]

// 既読テキストカラー設定の自動記録を有効化
TG.config.autoRecordLabel = "true";

// 現在の音量・スピード設定を tf 変数にコピー（ボタン表示の初期値として使用）
tf.current_bgm_vol   = parseInt(TG.config.defaultBgmVolume);
tf.current_se_vol    = parseInt(TG.config.defaultSeVolume);
tf.current_ch_speed  = parseInt(TG.config.chSpeed);
tf.current_auto_speed = parseInt(TG.config.autoSpeed);

// 未読スキップの現在設定を "ON"/"OFF" 文字列で保持
tf.text_skip = "ON";
if(TG.config.unReadTextSkip != "true"){
    tf.text_skip = "OFF";
}

// 既読テキスト色の設定を保存し、コンフィグ中は 'default' に戻す
// （コンフィグ画面のテキストサンプルに色がつかないように）
tf.user_setting = TG.config.alreadyReadTextColor;
if(tf.user_setting != 'default'){
    TG.config.alreadyReadTextColor = 'default';
}

[endscript]

;-------------------------------------------
; 画像パス・ボタン座標・その他定数の初期化
;
; tf.img_path    : コンフィグ用画像フォルダのパス（KSからの相対パス）
; tf.config_x    : 各音量・スピードボタンの X 座標配列（index 1〜10 を使用）
; tf.text_sample : テキスト速度のサンプル文字列
;-------------------------------------------
[iscript]

tf.img_path     = '../image/config/';
tf.btn_path_off = tf.img_path + 'off.gif';  // 非選択状態のボタン画像
tf.btn_path_on  = tf.img_path + 'on.png';   // 選択状態のボタン画像
tf.img_check    = tf.img_path + 'check.png'; // チェックマーク画像（ミュート/スキップON）

// 各スライダーボタンの X 座標（index 0 = 未使用、1〜10 が各段階に対応）
tf.config_x = [1074, 375, 425, 475, 525, 575, 625, 675, 725, 775, 825];

// テキスト速度のサンプルテキスト（速度変更時に表示されるプレビュー）
tf.text_sample = 'テストメッセージです。このスピードでテキストが表示されます。';
tf.text_sample_speed; // サンプルの表示完了までの待機時間（後で計算）

// 現在の音量をボタン index（0〜10）に変換して保持
// BGM/SE は 10 刻みなので ÷10 で index を得る
tf.config_num_bgm  = Math.round(tf.current_bgm_vol / 10);
tf.config_num_se   = Math.round(tf.current_se_vol  / 10);

// テキスト速度・オート速度は対応テーブルで index に変換
var _ch_vals   = [100, 80, 50, 40, 30, 25, 20, 11, 8, 5];
var _auto_vals = [5000, 4500, 4000, 3500, 3000, 2500, 2000, 1300, 800, 500];
tf.config_num_ch   = _ch_vals.indexOf(tf.current_ch_speed);
tf.config_num_auto = _auto_vals.indexOf(tf.current_auto_speed);

// ミュート前の音量を記憶する配列（ミュートトグル機能で使用）
// [bgmvol_before, bgmvol_index_before, sevol_before, sevol_index_before]
if(typeof f.prev_vol_list === 'undefined'){
    f.prev_vol_list = [tf.current_bgm_vol, tf.config_num_bgm, tf.current_se_vol, tf.config_num_se];
}

[endscript]

[cm]

; コンフィグ背景画像を表示
[bg storage="&tf.img_path + 'bg_config.jpg'" time="100"]

; title.ks から来た場合の遷移オーバーレイをフェードアウトして削除
; title_ui の opacity を 0 に設定しておく（後で復元）
[iscript]
anime({targets:'#exit_overlay', opacity:[1,0], duration:300, easing:'easeOutQuad', complete:function(){ $('#exit_overlay').remove(); }});
$('#title_ui').css('opacity', '0');
[endscript]

; 戻るボタン（右上）を fixlayer に配置
; target="*backtitle" : クリックでタイトルに戻る
[button fix="true" graphic="&tf.img_path + 'c_btn_back.png'" enterimg="&tf.img_path + 'c_btn_back2.png'" target="*backtitle" x="1170" y="20"]

[jump target="*config_page"]


*config_page
; コールスタックをクリア（ボタン操作でここに戻ってくるたびにスタックが積まれないようにする）
[clearstack]

;------------------------------------------------------------------------------------------------------
; BGM音量ボタン（10段階）
; 各ボタンは exp で tf.current_bgm_vol と tf.config_num_bgm を同時に設定し、
; target="*vol_bgm_change" でリフレッシュ処理に遷移する
;------------------------------------------------------------------------------------------------------
[button name="bgmvol,bgmvol_10"  fix="true" target="*vol_bgm_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[1]"  y="195" exp="tf.current_bgm_vol =  10; tf.config_num_bgm =  1"]
[button name="bgmvol,bgmvol_20"  fix="true" target="*vol_bgm_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[2]"  y="195" exp="tf.current_bgm_vol =  20; tf.config_num_bgm =  2"]
[button name="bgmvol,bgmvol_30"  fix="true" target="*vol_bgm_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[3]"  y="195" exp="tf.current_bgm_vol =  30; tf.config_num_bgm =  3"]
[button name="bgmvol,bgmvol_40"  fix="true" target="*vol_bgm_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[4]"  y="195" exp="tf.current_bgm_vol =  40; tf.config_num_bgm =  4"]
[button name="bgmvol,bgmvol_50"  fix="true" target="*vol_bgm_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[5]"  y="195" exp="tf.current_bgm_vol =  50; tf.config_num_bgm =  5"]
[button name="bgmvol,bgmvol_60"  fix="true" target="*vol_bgm_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[6]"  y="195" exp="tf.current_bgm_vol =  60; tf.config_num_bgm =  6"]
[button name="bgmvol,bgmvol_70"  fix="true" target="*vol_bgm_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[7]"  y="195" exp="tf.current_bgm_vol =  70; tf.config_num_bgm =  7"]
[button name="bgmvol,bgmvol_80"  fix="true" target="*vol_bgm_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[8]"  y="195" exp="tf.current_bgm_vol =  80; tf.config_num_bgm =  8"]
[button name="bgmvol,bgmvol_90"  fix="true" target="*vol_bgm_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[9]"  y="195" exp="tf.current_bgm_vol =  90; tf.config_num_bgm =  9"]
[button name="bgmvol,bgmvol_100" fix="true" target="*vol_bgm_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[10]" y="195" exp="tf.current_bgm_vol = 100; tf.config_num_bgm = 10"]

; BGMミュートボタン（音量 0 にするトグルボタン）
[button name="bgmvol,bgmvol_0" fix="true" target="*vol_bgm_mute" graphic="&tf.btn_path_off" width="32" height="32" x="956" y="197"]

;------------------------------------------------------------------------------------------------------
; SE音量ボタン（10段階）
; BGM音量と同じ仕組みで SE 音量を設定する
;------------------------------------------------------------------------------------------------------
[button name="sevol,sevol_10"  fix="true" target="*vol_se_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[1]"  y="275" exp="tf.current_se_vol =  10; tf.config_num_se =  1"]
[button name="sevol,sevol_20"  fix="true" target="*vol_se_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[2]"  y="275" exp="tf.current_se_vol =  20; tf.config_num_se =  2"]
[button name="sevol,sevol_30"  fix="true" target="*vol_se_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[3]"  y="275" exp="tf.current_se_vol =  30; tf.config_num_se =  3"]
[button name="sevol,sevol_40"  fix="true" target="*vol_se_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[4]"  y="275" exp="tf.current_se_vol =  40; tf.config_num_se =  4"]
[button name="sevol,sevol_50"  fix="true" target="*vol_se_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[5]"  y="275" exp="tf.current_se_vol =  50; tf.config_num_se =  5"]
[button name="sevol,sevol_60"  fix="true" target="*vol_se_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[6]"  y="275" exp="tf.current_se_vol =  60; tf.config_num_se =  6"]
[button name="sevol,sevol_70"  fix="true" target="*vol_se_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[7]"  y="275" exp="tf.current_se_vol =  70; tf.config_num_se =  7"]
[button name="sevol,sevol_80"  fix="true" target="*vol_se_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[8]"  y="275" exp="tf.current_se_vol =  80; tf.config_num_se =  8"]
[button name="sevol,sevol_90"  fix="true" target="*vol_se_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[9]"  y="275" exp="tf.current_se_vol =  90; tf.config_num_se =  9"]
[button name="sevol,sevol_100" fix="true" target="*vol_se_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[10]" y="275" exp="tf.current_se_vol = 100; tf.config_num_se = 10"]

; SEミュートボタン
[button name="sevol,sevol_0" fix="true" target="*vol_se_mute" graphic="&tf.btn_path_off" width="32" height="32" x="956" y="280"]

;------------------------------------------------------------------------------------------------------
; テキスト速度ボタン（10段階）
; 値は ms 単位の1文字表示間隔（小さいほど速い）
; 100=最遅, 5=最速
;------------------------------------------------------------------------------------------------------
[button name="ch,ch_100" fix="true" target="*ch_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[1]"  y="355" exp="tf.set_ch_speed =100; tf.config_num_ch = 0"]
[button name="ch,ch_80"  fix="true" target="*ch_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[2]"  y="355" exp="tf.set_ch_speed = 80; tf.config_num_ch = 1"]
[button name="ch,ch_50"  fix="true" target="*ch_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[3]"  y="355" exp="tf.set_ch_speed = 50; tf.config_num_ch = 2"]
[button name="ch,ch_40"  fix="true" target="*ch_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[4]"  y="355" exp="tf.set_ch_speed = 40; tf.config_num_ch = 3"]
[button name="ch,ch_30"  fix="true" target="*ch_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[5]"  y="355" exp="tf.set_ch_speed = 30; tf.config_num_ch = 4"]
[button name="ch,ch_25"  fix="true" target="*ch_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[6]"  y="355" exp="tf.set_ch_speed = 25; tf.config_num_ch = 5"]
[button name="ch,ch_20"  fix="true" target="*ch_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[7]"  y="355" exp="tf.set_ch_speed = 20; tf.config_num_ch = 6"]
[button name="ch,ch_11"  fix="true" target="*ch_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[8]"  y="355" exp="tf.set_ch_speed = 11; tf.config_num_ch = 7"]
[button name="ch,ch_8"   fix="true" target="*ch_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[9]"  y="355" exp="tf.set_ch_speed =  8; tf.config_num_ch = 8"]
[button name="ch,ch_5"   fix="true" target="*ch_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[10]" y="355" exp="tf.set_ch_speed =  5; tf.config_num_ch = 9"]

;------------------------------------------------------------------------------------------------------
; オート速度ボタン（10段階）
; 値は ms 単位のオートモード待機時間（小さいほど速い）
; 5000=最遅, 500=最速
;------------------------------------------------------------------------------------------------------
[button name="auto,auto_5000" fix="true" target="*auto_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[1]"  y="435" exp="tf.set_auto_speed = 5000; tf.config_num_auto = 0"]
[button name="auto,auto_4500" fix="true" target="*auto_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[2]"  y="435" exp="tf.set_auto_speed = 4500; tf.config_num_auto = 1"]
[button name="auto,auto_4000" fix="true" target="*auto_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[3]"  y="435" exp="tf.set_auto_speed = 4000; tf.config_num_auto = 2"]
[button name="auto,auto_3500" fix="true" target="*auto_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[4]"  y="435" exp="tf.set_auto_speed = 3500; tf.config_num_auto = 3"]
[button name="auto,auto_3000" fix="true" target="*auto_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[5]"  y="435" exp="tf.set_auto_speed = 3000; tf.config_num_auto = 4"]
[button name="auto,auto_2500" fix="true" target="*auto_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[6]"  y="435" exp="tf.set_auto_speed = 2500; tf.config_num_auto = 5"]
[button name="auto,auto_2000" fix="true" target="*auto_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[7]"  y="435" exp="tf.set_auto_speed = 2000; tf.config_num_auto = 6"]
[button name="auto,auto_1300" fix="true" target="*auto_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[8]"  y="435" exp="tf.set_auto_speed = 1300; tf.config_num_auto = 7"]
[button name="auto,auto_800"  fix="true" target="*auto_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[9]"  y="435" exp="tf.set_auto_speed =  800; tf.config_num_auto = 8"]
[button name="auto,auto_500"  fix="true" target="*auto_speed_change" graphic="&tf.btn_path_off" width="40" height="40" x="&tf.config_x[10]" y="435" exp="tf.set_auto_speed =  500; tf.config_num_auto = 9"]

;------------------------------------------------------------------------------------------------------
; 未読スキップボタン（トグル）
; ON のときはチェックマーク画像が表示され、既読テキストのみスキップ可能
; OFF のときは未読テキストもスキップ可能
;------------------------------------------------------------------------------------------------------
[button name="unread_on" fix="true" target="*skip_on" graphic="&tf.btn_path_off" width="32" height="32" x="956" y="360"]

;------------------------------------------------------------------------------------------------------
; コンフィグ起動時の画面更新
; 現在の設定値に対応するボタン画像（on.png/check.png）を表示する
;------------------------------------------------------------------------------------------------------

; layer="0" を表示状態に戻す（BGM/SE/ch/auto/skip の画像が layer=0 に表示される）
[layopt layer="0" visible="true"]

; 各項目の「現在値に対応する画像」を layer=0 に配置するサブルーチンを呼ぶ
[call target="*load_bgm_img"]
[call target="*load_se_img"]
[call target="*load_ch_img"]
[call target="*load_auto_img"]
[call target="*load_skip_img"]

[s]

;================================================================================
; コンフィグ画面の終了処理
;================================================================================

*backtitle
[cm]

; 既読テキスト色の設定を元に戻す（コンフィグ画面中は 'default' にしていた）
; title_ui の opacity と pointer-events を復元してタイトル UI を再表示
[iscript]
TG.config.alreadyReadTextColor = tf.user_setting;
$('#title_ui').css({'opacity':'', 'pointer-events':'none'});
$('.title-btn').css('pointer-events', 'all'); // タイトルボタンを再有効化
[endscript]

; コンフィグ中に表示した layer=0 の画像を名前で個別削除
; [clearfix] は fixlayer のボタンのみ対象で layer=0 の [image] 要素は対象外のため個別に [free] が必要
[layopt layer="message1" visible="false"]
[free layer="0" name="bgmvol" time="0" wait="true"]
[free layer="0" name="sevol"  time="0" wait="true"]
[free layer="0" name="ch"     time="0" wait="true"]
[free layer="0" name="auto"   time="0" wait="true"]
[free layer="0" name="skip"   time="0" wait="true"]
; fixlayer のボタン類を削除
[clearfix]
; キーボード操作を再有効化
[start_keyconfig]
; コールスタックをクリアして title.ks にジャンプ
[clearstack]
[jump storage="title.ks"]

;================================================================================
; ボタンクリック時の処理
;================================================================================

;--------------------------------------------------------------------------------
; BGM音量の変更
;
; *vol_bgm_mute : ミュートトグル（0 ↔ 元の音量）
; *vol_bgm_change : 音量適用・ボタン表示更新・BGMに即時反映
;--------------------------------------------------------------------------------
*vol_bgm_mute

[iscript]
if(tf.current_bgm_vol != 0){
    // ミュート前の音量を記憶してから 0 に設定
    f.prev_vol_list[0] = tf.current_bgm_vol;
    f.prev_vol_list[1] = tf.config_num_bgm;
    tf.current_bgm_vol = 0;
    tf.config_num_bgm  = 0;
} else {
    // 記憶した音量に戻す
    tf.current_bgm_vol = f.prev_vol_list[0];
    tf.config_num_bgm  = f.prev_vol_list[1];
}
[endscript]

*vol_bgm_change
; 現在の BGM 音量ボタン画像を削除して再描画し、BGMの音量を即時変更
[free layer="0" name="bgmvol" time="0" wait="true"]
[call target="*load_bgm_img"]
[bgmopt volume="&tf.current_bgm_vol"]

[return]

;--------------------------------------------------------------------------------
; SE音量の変更
;
; BGM と同じ仕組みで SE 音量を設定する
;--------------------------------------------------------------------------------
*vol_se_mute

[iscript]
if(tf.current_se_vol != 0){
    f.prev_vol_list[2] = tf.current_se_vol;
    f.prev_vol_list[3] = tf.config_num_se;
    tf.current_se_vol = 0;
    tf.config_num_se  = 0;
} else {
    tf.current_se_vol = f.prev_vol_list[2];
    tf.config_num_se  = f.prev_vol_list[3];
}
[endscript]

*vol_se_change
[free layer="0" name="sevol" time="0" wait="true"]
[call target="*load_se_img"]
[seopt volume="&tf.current_se_vol"]

[return]

;--------------------------------------------------------------------------------
; テキスト速度の変更
;
; 速度変更後にサンプルテキストを message1 レイヤーに表示して
; 実際のテキスト速度をプレビューする
;--------------------------------------------------------------------------------
*ch_speed_change

[iscript]
tf.current_ch_speed = tf.set_ch_speed; // exp で設定された速度を確定
[endscript]

[free layer="0" name="ch" time="0" wait="true"]
[call target="*load_ch_img"]
[configdelay speed="&tf.set_ch_speed"] ; テキスト速度を即時適用

; message1 レイヤーにサンプルテキストを表示してプレビュー
[position layer="message1" left="90" top="580" width="1100" height="100" margint="2" marginl="30" page="fore" visible="true" opacity="0"]
[layopt layer="message1" visible="true"]
[current layer="message1"]

[emb exp="tf.text_sample"] ; サンプルテキストを現在の速度で表示

; サンプルテキストの文字色を設定
[iscript]
$(".current_span").css("color","#66564C");
tf.system.backlog.pop(); // バックログにサンプルテキストが残らないように削除
[endscript]

; テキストが流れ終わるまで待機（文字数×速度 + バッファ）
[eval exp="tf.text_sample_speed = tf.set_ch_speed * tf.text_sample.length + 700"]
[wait time="&tf.text_sample_speed"]

; message1 レイヤーをクリアして非表示にする
[er]
[layopt layer="message1" visible="false"]

[return]

;--------------------------------------------------------------------------------
; オート速度の変更
;--------------------------------------------------------------------------------
*auto_speed_change

[iscript]
tf.current_auto_speed = tf.set_auto_speed; // exp で設定された速度を確定
[endscript]

[free layer="0" name="auto" time="0" wait="true"]
[call target="*load_auto_img"]
[autoconfig speed="&tf.set_auto_speed"] ; オート速度を即時適用

[return]

;--------------------------------------------------------------------------------
; 未読スキップのトグル
; "ON" → "OFF" → "ON" と交互に切り替える
;--------------------------------------------------------------------------------
*skip_on

[if exp="tf.text_skip == 'ON'"]
; ON → OFF に切り替え（チェックマーク画像を削除、スキップ設定を false に）
[free layer="0" name="skip" time="0" wait="true"]
[eval exp="tf.text_skip = 'OFF'"]
[config_record_label skip="false"]

[else]
; OFF → ON に切り替え（チェックマーク画像を表示、スキップ設定を true に）
[image name="skip" layer="0" storage="&tf.img_check" x="956" y="360" width="32" height="32"]
[eval exp="tf.text_skip = 'ON'"]
[config_record_label skip="true"]

[endif]

[return]

;================================================================================
; 現在の設定値に対応するボタン画像の表示（サブルーチン）
;
; 選択中のボタン位置に on.png（インジケーター）を表示する。
; ミュート状態（index = 0）のときは check.png（チェックマーク）を表示。
;================================================================================

*load_bgm_img
[if exp="tf.config_num_bgm == 0"]
; ミュート状態：チェックマーク画像をミュートボタン位置に表示
[image layer="0" name="bgmvol" storage="&tf.img_check" x="956" y="197"]
[else]
; 通常状態：現在の音量段階に対応するボタン上に on.png を表示（-5 px で中央合わせ）
[image layer="0" name="bgmvol" storage="&tf.btn_path_on" x="&tf.config_x[tf.config_num_bgm] - 5" y="190"]
[endif]
[return]


*load_se_img
[if exp="tf.config_num_se == 0"]
[image layer="0" name="sevol" storage="&tf.img_check" x="956" y="280"]
[else]
[image layer="0" name="sevol" storage="&tf.btn_path_on" x="&tf.config_x[tf.config_num_se] - 5" y="270"]
[endif]
[return]


*load_ch_img
; テキスト速度は index+1 を使う（index 0 が最遅なので x[1] から開始）
[image layer="0" name="ch" storage="&tf.btn_path_on" x="&tf.config_x[tf.config_num_ch + 1] - 5" y="350"]
[return]


*load_auto_img
[image layer="0" name="auto" storage="&tf.btn_path_on" x="&tf.config_x[tf.config_num_auto + 1] - 5" y="430"]
[return]


*load_skip_img
; 未読スキップが ON のときのみチェックマークを表示
[if exp="tf.text_skip == 'ON'"]
[image layer="0" name="skip" storage="&tf.img_check" x="956" y="360"]
[endif]
[return]
