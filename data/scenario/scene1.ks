*scene1

;-------------------------------------------
; 背景・メッセージウィンドウの初期設定
; ※ここに来るときは [mask] で黒暗転中のため、
;   bg や position の設定をしてから mask_off で明ける
;-------------------------------------------

; 暗転中に背景を設定（time=100 で即座に切り替え）
[bg storage="church.jpg" time=100]

; 暗転解除（3秒かけてフェードイン）
[mask_off time=3000]
[stopbgm]

; メッセージウィンドウのレイアウトを設定
; layer="message0" : 会話テキストが表示されるレイヤー
; width/height/top/left : ウィンドウの位置とサイズ（1280x720基準）
[free name="chara_name_area" layer="message0"]
[position layer="message0" width="1280" height="275" top="447" left="0" visible="true"]

; ウィンドウの外枠画像・テキストマージンを設定
; frame : ウィンドウ背景に使うフレーム画像のパス
; margint/marginl/marginr : テキストが描画される内側の余白（px）
; opacity="255" : 完全不透明
[position layer="message0" frame="../others/plugin/thema_nagi_1/image/frame_message.png" margint="110" marginl="140" marginr="150" opacity="255" page="fore"]

; キャラ名を表示するptext要素を作成
; ptext : テキスト専用の描画オブジェクト（HTMLには依存しない）
[ptext name="chara_name_area" layer="message0" color="0xf2f2f2" size="26" bold="bold" x="100" y="520"]

; 名前表示に使うptext要素をchara_ptextとして登録
; これにより # キャラ名 の記法でキャラ名が自動設定される
[chara_config ptext="chara_name_area"]

; テキスト色を白系に設定（foreカラー・デフォルトカラー両方）
[font color="0xf2f2f2"]
[deffont color="0xf2f2f2"]

; システムボタン（SAVE/LOAD等）を表示する
; thema_nagi_1 プラグインのマクロ。fixlayer にボタンを配置する
[tsw_button]

;-------------------------------------------
; 会話開始
;-------------------------------------------

# 主人公
「……ん……」[p]

; キャラクター「tensi」を画面に表示（top=50 : 上から50px位置）
[chara_show name="tensi" top=50]
[playbgm storage="bgm1.mp3" loop="true" volume="80" ]

# ???
「やっと起きたかい」[p]

#
目を覚ますと、知らない場所で、知らない奴がいる。[p]

# 主人公
「……教会？それに誰だお前」[p]

; 表情を smile に変更（chara_face で登録済みの画像に切り替わる）
[chara_mod name="tensi" face="smile"]
# ???
「ああ。場所はどこでもよかったし、僕のことも知らなくていいよ」[p]

# ???
「ここは【サンプルゲーム】だよ」[p]

# 主人公
「……？」[p]

#
【サンプルゲーム】……？[p]

; 表情を warai に変更し、ぴょこぴょこアニメーション（pyoko_s）を2回再生
[chara_mod name="tensi" face="warai"]
[kanim name="tensi" keyframe="pyoko_s" time="300" count="2"]
[playse storage="se_papa.mp3" ]
[wait time="300"]
[playse storage="se_papa.mp3" ]
# ???
「あはは。面白い反応だね」[p]

[chara_mod name="tensi" face="normal"]
# ???
「君の出番はここまでだよ。ここからは、ゲームにつけられる機能を紹介するね」[p]

# ???
「まずは、キャラクター関連の動きから見せるよ」[p]

[chara_mod name="tensi" face="warai"]
[kanim name="tensi" keyframe="pyoko_s" time="300" count="2"]
[playse storage="se_papa.mp3" ]
[wait time="300"]
[playse storage="se_papa.mp3" ]
# ???
「ふふ、君は面白いね」[p]

; 怒り表情 + 怒りアイコン画像をlayer=2に表示
; name="ikari" をつけることで [free] で個別に消去できる
[chara_mod name="tensi" face="angry"]
[image layer=2 page=fore storage="ikari_icon.png" folder=image name="ikari" x=655 y=120 width=90 height=90]
[kanim name="tensi" keyframe="pyoko_s" time="300" count="1"]
[playse storage="ikari.mp3" ]
# ???
「……もう、怒るよ」[p]

; 怒りアイコンをlayer=2から削除（name="ikari" で対象を特定）
[free layer=2 name="ikari"]
[chara_mod name="tensi" face="normal"]
# ???
「――なんてね。」[p]

[chara_mod name="tensi" face="kutiake"]
# ???
「こんな感じで、キャラクターのセリフに合わせて、動きや表情、効果音をつけられるよ」[p]

# ???
「次は、シーンチェンジを見せるね」[p]

;-------------------------------------------
; シーンチェンジ演出（教会 → 廊下）
; bg_rule プラグインを使いルール画像でトランジション
;
; 手順:
;   1. UIとキャラをフェードアウト
;   2. キャラを非表示、メッセージウィンドウを非表示
;   3. [bg_rule] でルール画像トランジション（内部で背景も切り替わる）
;   4. メッセージウィンドウを表示に戻す
;   5. UIとキャラをフェードイン
;-------------------------------------------

; UIとキャラをフェードアウト
; fixlayer は pointer-events を維持（SAVE等のシステム操作を可能にするため）
[iscript]
$(".message0_fore").children().stop(true,true).animate({opacity:0}, 2000);
$(".fixlayer").stop(true,true).animate({opacity:0}, 2000);
[endscript]
[wait time="500"]
[chara_hide name="tensi" time="300"]
[layopt layer="message0" visible="false"]

; ルール画像（001.png）を使って廊下画像にトランジション
; bg_rule プラグインが背景の切り替えとアニメーションを処理する
[bg_rule storage="rouka.jpg" rule="001.png"]

; メッセージウィンドウを戻す
[layopt layer="message0" visible="true"]
; UIとキャラをフェードイン
[iscript]
$(".message0_fore").children().stop(true, true).animate({opacity: 1}, 1000);
$(".fixlayer").stop(true, true).animate({opacity: 1}, 1000);
[endscript]
[wait time="1000"]
[chara_show name="tensi" top=50 time=400]

# ???
「廊下だね」[p]
「戻るね」[p]

;-------------------------------------------
; シーンチェンジ演出（廊下 → 教会）
; 上と同じ手順で教会に戻る
;-------------------------------------------

[iscript]
$(".message0_fore").children().stop(true,true).animate({opacity:0}, 2000);
$(".fixlayer").stop(true,true).animate({opacity:0}, 2000);
[endscript]
[wait time="500"]
[chara_hide name="tensi" time="300"]
[layopt layer="message0" visible="false"]

[bg_rule storage="church.jpg" rule="001.png"]

[layopt layer="message0" visible="true"]
[iscript]
$(".message0_fore").children().stop(true, true).animate({opacity: 1}, 1000);
$(".fixlayer").stop(true, true).animate({opacity: 1}, 1000);
[endscript]
[wait time="1000"]
[chara_show name="tensi" top=50 time=400]

# ???
「こんなふうに、場面を切り替えることができるよ」[p]
「あとは、スチルの表示もアニメーションを付けることができるよ」[p]
「やってみるね」[p]

;-------------------------------------------
; スチル演出（カメラパン付き）
;
; 概要:
;   layer=1 にスチル画像をセットし、カメラをズームした状態から
;   パンさせながらフェードイン。その後 layer=2 に全体画像を重ねる。
;
; スキップ対策:
;   演出中の意図しないスキップを防ぐため [cancelskip] + [stop_keyconfig]
;   で操作を封鎖する。セリフ直前で [start_keyconfig] を再有効化。
;-------------------------------------------

; スキップを無効化（演出中の意図しない早送りを防ぐ）
[stop_keyconfig]
[cancelskip]

; UIとキャラをフェードアウト
[iscript]
$(".message0_fore").children().stop(true,true).animate({opacity:0}, 2000);
$(".fixlayer").stop(true,true).animate({opacity:0}, 2000);
[endscript]
[wait time="2000"]
[chara_hide name="tensi"]

; カメラをズーム2倍・右下オフセット位置にセット（スチル演出の開始位置）
; zoom="2" : 拡大率2倍　y="-160" x="100" : 画面下方向・右にオフセット
[camera layer="1" time="1" zoom="2" y="-160" x="100"]

; 白暗転（スチル表示切り替えのためのフラッシュ）
[cancelskip]
[mask_off time=1]
[mask time="1000" color="0xffffff"]

; スチル画像を layer=1 にセット（まだ非表示状態）
[image layer="1" storage="star.png" left="0" top="0"]

; カメラパン開始：ズーム2倍のまま右下→中央に9秒かけて移動
; wait="false" でブロッキングなし（次の処理に即移行）
[camera layer="1" time="9000" wait="false" zoom="2" y="0" x="0" ease_type="ease"]

; 白暗転解除（Bug#3対策：[mask_off] タグはスキップ状態で不安定なためjQueryで代替）
; - #root_layer_game の opacity を 1 に戻す（[mask] 後に 0 にされているため）
; - .layer_mask の CSS アニメーションを止めてから jQuery animate で徐々にフェードアウト
; - アニメーション終了後に DOM から削除
[cancelskip]
[iscript]
$("#root_layer_game").css("opacity", 1);
$(".layer_mask").css("animation", "none").animate({opacity:0}, 1000, function(){ $(this).remove(); });
[endscript]
[wait time="1000"]

; layer=2 に全体スチル画像を time="9000" で徐々にフェードイン
; wait="false" でブロッキングなし（後続の [wait] で別途待機する）
[cancelskip]
[image layer="2" time="9000" wait="false" storage="star.png"]
[wait time="5000"]

; スチルを見せた後にメッセージウィンドウを表示してセリフへ
; [fadein_frame] はウィンドウ枠を徐々に表示するマクロ（thema_nagi_1 提供）
[fadein_frame time="1500"]
[start_keyconfig]

# ???
「…こんな感じ」[p]

「戻るね」[p]

; セリフ後・遷移前にスキップ操作を再封鎖
[stop_keyconfig]
[cancelskip]

; 黒フェードで全体を暗転してからリセット
[mask time="800" color="0x000000"]

; 暗転中に layer=1/2 の画像を解放し、カメラと背景をリセット
; NOTE: [reset_camera layer="1" time="1"] はカメラアニメーションが動いている状態でのみ
;       正常動作する。スチル後はカメラが動いているため問題ないが、
;       カメラ静止状態で呼んだ場合は処理がブロッキングする可能性がある
[freeimage layer="1"]
[freeimage layer="2"]
[reset_camera layer="1" time="1"]
[bg storage="church.jpg" time=0]
[layopt layer="1" visible="false"]
[layopt layer="2" visible="false"]
[cm]

; 黒暗転を解除して教会背景をフェードイン
[mask_off time="1000"]
[bg storage="church.jpg" time=0]
[wait time="300"]

; UIとキャラをフェードイン
[iscript]
$(".message0_fore").children().stop(true, true).animate({opacity: 1}, 1000);
$(".fixlayer").stop(true, true).animate({opacity: 1}, 1000);
[endscript]
[wait time="1000"]
[chara_show name="tensi" top=50 time=400]

; スキップとキーボード操作を再有効化
[start_keyconfig]

;-------------------------------------------
; 選択肢と分岐の説明
;-------------------------------------------

[chara_mod name="tensi" face="normal"]
# ???
「次は、選択肢と分岐だ」[p]

; 選択肢ボタンを表示して待機
; glink : グラフィック付きリンクボタン（color="tswitch" でテーマのスタイルを適用）
; target : クリック時にジャンプするラベル名
[glink color="tswitch" text="選択肢A" target="*select_a" size="20" width="400" x="400" y="300"]
[glink color="tswitch" text="選択肢B" target="*select_b" size="20" width="400" x="400" y="380"]
[s]

*select_a

[chara_mod name="tensi" face="smile"]
# ???
「君は、Aを選んだね」[p]
@jump target="*after_select"

*select_b

[chara_mod name="tensi" face="smile"]
# ???
「君は、Bを選んだね」[p]
@jump target="*after_select"

*after_select

[chara_mod name="tensi" face="normal"]
# ???
「こんな感じで、選択によって展開を変えられる」[p]

[chara_mod name="tensi" face="kutiake"]
# ???
「今回は見せないけど、もっと複雑な条件分岐もできるよ」[p]

;-------------------------------------------
; 動画再生（タイトル画面のデモ映像）
;-------------------------------------------

[chara_mod name="tensi" face="normal"]
# ???
「ところで、タイトル画面は見てくれたかな」[p]
「もう一度見てみようか」[p]

; [movie] タグで動画再生する前に、出現するDOM要素（bgmovie）を監視して
; サイズ・位置・再生開始時刻を設定する
; setInterval で bgmovie 要素が出現するまでポーリングし、見つかったら設定してクリア
[iscript]
var _check = setInterval(function() {
    var v = document.getElementById("bgmovie");
    if (v) {
        clearInterval(_check);
        // 動画を画面中央に640x360でリサイズして表示
        v.style.width  = "640px";
        v.style.height = "360px";
        v.style.left   = "320px";
        v.style.top    = "180px";
        // 冒頭3.5秒（ブランドロゴ部分）をスキップして再生開始
        v.currentTime  = 3.5;
    }
}, 10);
[endscript]
[movie storage="gameplay_demo.mp4"]
# ???
「最初にブランドロゴや注意書きが出て、アニメーション付きでタイトル画面が表示されていたよね」[p]

# ???
「CGモードや、コンフィグなどの機能も付けられるよ」[p]

# ???
「それと、今見ている画面のUIデザインもできる」[p]

[chara_mod name="tensi" face="kutiake"]
# ???
「UIっていうのは、メッセージウィンドウやスキップ、オートなどのシステムボタン、フォントのことだよ」[p]
「ちなみに、このゲームではシステムボタンは上部にカーソルを合わせると出てくるよ」[p]

;-------------------------------------------
; ボイス再生の説明
;-------------------------------------------

[chara_mod name="tensi" face="normal"]
# ???
「それから、ボイスもつけられる」[p]

; ボイス再生中にBGMを小さくして聞き取りやすくする
[chara_mod name="tensi" face="kutiake2"]
[playse storage="voice1.wav"]
[bgmopt volume="50"]
# ???
「こんにちは。僕は天使」[p]

; ボイス後にBGMを元の音量に戻す
[chara_mod name="tensi" face="metoji"]
[bgmopt volume="100"]
# ???
「……こんな感じ」[p]

[chara_mod name="tensi" face="smile"]
# ???
「他にも必要な機能があれば、相談してね」[p]

[chara_mod name="tensi" face="normal"]
# ???
「君の企画に合わせて、最適な形で実装できる」[p]

;-------------------------------------------
; エンディング処理・タイトルへ戻る
;-------------------------------------------

; BGMを1秒かけてフェードアウト
[fadeoutbgm time=1000]
; SEをすべて停止
[stopse]
; 黒暗転でシーンを締める
[mask time="800" color="0x000000"]
[chara_hide name="tensi"]

/*
シーン1終了
*/

; メッセージをクリア・ウィンドウを非表示にする
[cm]
[layopt layer="message0" visible="false"]

; fixlayer に残っているシステムボタン（role_button）を消去
; ※[mask] 黒画面中でも fixlayer は生きているため、jump 前に明示的にクリアする
[clearfix name="role_button"]

; タイトルに戻る
@jump storage=title.ks
