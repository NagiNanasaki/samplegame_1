;Perseids

*start

[cm]
[clearfix]
[hidemenubutton]
[start_keyconfig]

;てんし
[chara_new name="tensi" storage="chara/tensi/tensi_normal.png" jname="てんし"]
[chara_face name="tensi" face="normal" storage="chara/tensi/tensi_normal.png"]
[chara_face name="tensi" face="angry" storage="chara/tensi/tensi_angry.png"]
[chara_face name="tensi" face="konwaku" storage="chara/tensi/tensi_konwaku.png"]
[chara_face name="tensi" face="kutiake" storage="chara/tensi/tensi_kutiake.png"]
[chara_face name="tensi" face="kutiake2" storage="chara/tensi/tensi_kutiake2.png"]
[chara_face name="tensi" face="metoji" storage="chara/tensi/tensi_metoji.png"]
[chara_face name="tensi" face="smile" storage="chara/tensi/tensi_smile.png"]
[chara_face name="tensi" face="warai" storage="chara/tensi/tensi_warai.png"]

; キーフレームアニメーション定義
[keyframe name=pyoko_s]
[frame p=25% y=10 ]
[frame p=75% y=0]
[frame p=100% y=0]
[endkeyframe]

[keyframe name=furifuri]
[frame p=25% x=10 y=0]
[frame p=75% x=-10 y=0]
[frame p=100% x=0 y=0]
[endkeyframe]

[keyframe name=odoroki]
[frame p=25% y=-30 ]
[frame p=75% y=0]
[frame p=100% y=0]
[endkeyframe]

[layopt layer="0" visible="true"]
[layopt layer="1" visible="true"]
[layopt layer="2" visible="true"]
[layopt layer="3" visible="true"]
[layopt layer="4" visible="true"]
[layopt layer="5" visible="true"]

;マスクを先に適用してからカスタム黒オーバーレイを除去（ちらつき防止）
[mask time="1" color="0x000000"]
[iscript]
$('#ng_black').remove();
[endscript]

;scene1へジャンプ
@jump storage=scene1.ks target=*scene1

[s]
