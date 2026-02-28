*scene1

;暗転中に背景を設定
[stopbgm]
[bg storage="church.jpg" time=100]

;暗転解除（クロスフェード）
[mask_off time=3000]
[stopbgm]

;メッセージウィンドウ再設定
[free name="chara_name_area" layer="message0"]
[position layer="message0" width="1280" height="275" top="447" left="0" visible="true"]
[position layer="message0" frame="../others/plugin/thema_nagi_1/image/frame_message.png" margint="110" marginl="140" marginr="150" opacity="255" page="fore"]
[ptext name="chara_name_area" layer="message0" color="0xf2f2f2" size="26" bold="bold" x="100" y="520"]
[chara_config ptext="chara_name_area"]
[font color="0xf2f2f2"]
[deffont color="0xf2f2f2"]
[tsw_button]

# 主人公
「……ん……」[p]

[chara_show name="tensi" top=50]
[playbgm storage="bgm1.mp3" loop="true" volume="80" ]

# ???
「やっと起きたかい」[p]

#
目を覚ますと、知らない場所で、知らない奴がいる。[p]

# 主人公
「……教会？それに誰だお前」[p]

[chara_mod name="tensi" face="smile"]
# ???
「ああ。場所はどこでもよかったし、僕のことも知らなくていいよ」[p]

# ???
「ここは【サンプルゲーム】だよ」[p]

# 主人公
「……？」[p]

#
【サンプルゲーム】……？[p]

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

[chara_mod name="tensi" face="angry"]
[image layer=2 page=fore storage="ikari_icon.png" folder=image name="ikari" x=655 y=120 width=90 height=90]
[kanim name="tensi" keyframe="pyoko_s" time="300" count="1"]
[playse storage="ikari.mp3" ]
# ???
「……もう、怒るよ」[p]

[free layer=2 name="ikari"]
[chara_mod name="tensi" face="normal"]
# ???
「――なんてね。」[p]

[chara_mod name="tensi" face="kutiake"]
# ???
「こんな感じで、キャラクターのセリフに合わせて、動きや表情、効果音をつけられるよ」[p]

# ???
「次は、シーンチェンジを見せるね」[p]

# 


;シーンチェンジ演出（廊下へ）
[chara_hide name="tensi"]
[mask_rule graphic="rouka.jpg" rule="032.png" folder="bgimage" time="1500"]
[bg storage="rouka.jpg" time=0]
[transparent_frame]
[mask_off_rule rule="032.png" time=1]
[wait time="300"]
[fadein_frame time="400"]
[chara_show name="tensi" top=50]

[chara_mod name="tensi" face="normal"]
# ???
「…教室だね」[p]

[chara_mod name="tensi" face="smile"]
# ???
「戻るね」[p]

;元の背景（教会）へ戻る
[iscript]
TYRANO.kag.layer.getLayer("message0","fore").animate({opacity:0},400);
[endscript]
[chara_hide name="tensi"]
[wait time="450"]
[layopt layer="message0" visible="false"]
[iscript]
TYRANO.kag.layer.getLayer("message0","fore").css("opacity","");
[endscript]
[mask_rule graphic="church.jpg" rule="030.png" folder="bgimage" time="1500"]
[bg storage="church.jpg" time=0]
[mask_off_rule rule="030.png" time=1]
[wait time="300"]
[layopt layer="message0" visible="true"]
[chara_show name="tensi" top=50]

[chara_mod name="tensi" face="smile"]
[kanim name="tensi" keyframe="pyoko_s" time="300" count="2"]
# ???
「こんなふうに、場面を切り替えることができるよ」[p]
「あとは、スチルの表示もアニメーションを付けることができるよ」[p]
「やってみるね」[p]

;--- スチル演出（メモロビ風）---
[stop_keyconfig]
[cancelskip]
[iscript]
$('.fixlayer').css('pointer-events','none');
[endscript]
;UIとキャラをフェードアウト
[fadeout_frame time="2000"]
[chara_hide name="tensi"]

;白暗転（[mask]使用・[start_keyconfig]なし・[stop_keyconfig]維持）
[cancelskip]
[mask_off time=1]
[mask time="1000" color="0xffffff"]

;スチルをベースレイヤーにセット・カメラを右下2倍ズームにセット
[bg storage="star.png" time=0]
[camera layer="base" time="1" zoom="2" y="-160" x="100"]

;layer1に全体画像をセット（透明状態）
[iscript]
var $l = TYRANO.kag.layer.getLayer("1","fore");
$l.css({
    "background-image": "url('./data/image/star.png')",
    "background-size": "cover",
    "background-position": "center",
    "opacity": 0
});
[endscript]

;カメラパン開始（右下→中央、9秒、ノンブロッキング）
[camera layer="base" time="9000" wait="false" zoom="2" y="0" x="0" ease_type="ease"]

;白暗転解除
[cancelskip]
[mask_off time="1000"]

;全体画像フェードイン（カメラパン中に重ねる）
[cancelskip]
[iscript]
var $l = TYRANO.kag.layer.getLayer("1","fore");
$l.animate({opacity:1}, 9000);
[endscript]
[wait time="8000"]

;メッセージウィンドウフェードイン
[fadein_frame time="1500"]
[start_keyconfig]

# ???
「…こんな感じ」[p]

「戻るね」[p]

[stop_keyconfig]
[cancelskip]
;黒フェードで全体を暗転
[mask time="800" color="0x000000"]
;暗転中にlayer1・カメラ・背景・ウィンドウをリセット
[iscript]
var $l = TYRANO.kag.layer.getLayer("1","fore");
$l.stop();
$l.css({"background-image":"","background-size":"","background-position":"","opacity":""});
$(".message0_fore").children().stop(true, true).css("opacity", 0);
$(".fixlayer").stop(true, true).css("opacity", 0);
[endscript]
[reset_camera layer="base" time="1"]
[bg storage="church.jpg" time=0]
[cm]
;暗転解除（教会フェードイン）
[mask_off time="1000"]
[wait time="300"]
;ウィンドウ・ボタンをフェードイン
[iscript]
$(".message0_fore").children().stop(true, true).animate({opacity: 1}, 1000);
$(".fixlayer").stop(true, true).animate({opacity: 1}, 1000);
[endscript]
[wait time="1000"]
[chara_show name="tensi" top=50 time=400]
[start_keyconfig]

[chara_mod name="tensi" face="normal"]
# ???
「次は、選択肢と分岐だ」[p]
[iscript]
$('.fixlayer').css('pointer-events','');
[endscript]

;選択肢
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

[chara_mod name="tensi" face="normal"]
# ???
「ところで、タイトル画面は見てくれたかな」[p]
「もう一度見てみようか」[p]

[iscript]
var _check = setInterval(function() {
    var v = document.getElementById("bgmovie");
    if (v) {
        clearInterval(_check);
        v.style.width  = "640px";
        v.style.height = "360px";
        v.style.left   = "320px";
        v.style.top    = "180px";
        v.currentTime  = 3.5;
    }
}, 10);
[endscript]
[movie storage="gameplay_demo.mp4"]
# ???
「最初にブランドロゴや注意書きが出て、アニメーション付きでタイトル画面が表示されていたよね」[p]

;[chara_mod name="tensi" face="smile"]
# ???
「CGモードや、コンフィグなどの機能も付けられるよ」[p]

;[chara_mod name="tensi" face="normal"]
# ???
「それと、今見ている画面のUIデザインもできる」[p]

[chara_mod name="tensi" face="kutiake"]
# ???
「UIっていうのは、メッセージウィンドウやスキップ、オートなどのシステムボタン、フォントのことだよ」[p]
「ちなみに、このゲームではシステムボタンは上部にカーソルを合わせると出てくるよ」[p]

[chara_mod name="tensi" face="normal"]
# ???
「それから、ボイスもつけられる」[p]

;TODO: ボイス再生を入れる
[chara_mod name="tensi" face="kutiake2"]
[playse storage="voice1.wav"]
[bgmopt volume="50"] 
# ???
「こんにちは。僕は天使」[p]

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


;BGM徐々に停止--------------
[fadeoutbgm time=1000]
;SE停止-------------------
[stopse]
[mask time="800" color="0x000000"]
[chara_hide name="tensi"]

/*
シーン1終了
*/



;メッセージ消去・ウィンドウ非表示
[cm]
[layopt layer="message0" visible="false"]
[clearfix name="role_button"]

;タイトルに戻る
@jump storage=title.ks