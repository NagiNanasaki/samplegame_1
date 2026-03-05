;Perseids
; ゲーム開始時の初期化シーン。NewGameボタンから必ずここを通る。

*start

;-------------------------------------------
; 画面・状態のリセット
;-------------------------------------------
; メッセージウィンドウのテキストをクリア
[cm]
; fixlayerのボタン類をすべて非表示にする
[clearfix]
; システムメニューボタンを非表示
[hidemenubutton]
; キーボード操作を有効化
[start_keyconfig]

; 2周目以降のリセット処理
; [jump]でループするたびにDOMの状態が引き継がれるため、
; 1周目と同じ初期状態になるよう手動でリセットする
[iscript]
// fixlayer（SAVEなどのシステムボタン）のopacityをリセット
// シーンチェンジ演出でフェードアウトしたまま残る場合があるため
$(".fixlayer").stop(true, true).css("opacity", 1);

// メッセージウィンドウ内要素のopacityをリセット
// 同様にフェードアウト状態が残る場合があるため
$(".message0_fore").children().stop(true, true).css("opacity", 1);

// bg_ruleプラグインのcanvasをクリア
// 前周のシーンチェンジ演出の残像が残る場合があるため
var c = document.getElementById('canvas_bg_rule');
if (c) { c.getContext('2d').clearRect(0, 0, c.width, c.height); }
[endscript]

;-------------------------------------------
; キャラクター定義
;-------------------------------------------
; 天使キャラの画像を登録する。face指定で表情を切り替える。
[chara_new name="tensi" storage="chara/tensi/tensi_normal.png" jname="てんし"]
[chara_face name="tensi" face="normal"   storage="chara/tensi/tensi_normal.png"]
[chara_face name="tensi" face="angry"    storage="chara/tensi/tensi_angry.png"]
[chara_face name="tensi" face="konwaku"  storage="chara/tensi/tensi_konwaku.png"]
[chara_face name="tensi" face="kutiake"  storage="chara/tensi/tensi_kutiake.png"]
[chara_face name="tensi" face="kutiake2" storage="chara/tensi/tensi_kutiake2.png"]
[chara_face name="tensi" face="metoji"   storage="chara/tensi/tensi_metoji.png"]
[chara_face name="tensi" face="smile"    storage="chara/tensi/tensi_smile.png"]
[chara_face name="tensi" face="warai"    storage="chara/tensi/tensi_warai.png"]

;-------------------------------------------
; キーフレームアニメーション定義
; [kanim]タグで呼び出すアニメーションパターンを登録する
;-------------------------------------------

; ぴょこぴょこ上下に跳ねるアニメーション（小）
[keyframe name=pyoko_s]
[frame p=25%  y=10]
[frame p=75%  y=0]
[frame p=100% y=0]
[endkeyframe]

; 左右に振るアニメーション
[keyframe name=furifuri]
[frame p=25%  x=10  y=0]
[frame p=75%  x=-10 y=0]
[frame p=100% x=0   y=0]
[endkeyframe]

; 驚いて上に跳び上がるアニメーション
[keyframe name=odoroki]
[frame p=25%  y=-30]
[frame p=75%  y=0]
[frame p=100% y=0]
[endkeyframe]

;-------------------------------------------
; レイヤー初期化
; 前周でvisible=falseにしたレイヤーを全て表示状態に戻す
;-------------------------------------------
[layopt layer="0" visible="true"]
[layopt layer="1" visible="true"]
[layopt layer="2" visible="true"]
[layopt layer="3" visible="true"]
[layopt layer="4" visible="true"]
[layopt layer="5" visible="true"]

;-------------------------------------------
; 黒マスクを適用してからNewGame黒オーバーレイを除去
; タイトル画面のNewGameボタンがanime.jsで黒フェードしてからここに来るため、
; マスクを先に適用することでちらつきを防ぐ
;-------------------------------------------
[mask time="1" color="0x000000"]
[iscript]
// title.ksのNewGameボタンが作成した黒オーバーレイ(#ng_black)を削除
// ここで削除しないとゲーム中も黒い幕が残ってしまう
$('#ng_black').remove();
[endscript]

;-------------------------------------------
; scene1へジャンプ
;-------------------------------------------
@jump storage=scene1.ks target=*scene1

[s]
