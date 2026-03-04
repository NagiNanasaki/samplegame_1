;このファイルは削除しないでください！
;
;make.ks はデータをロードした時に呼ばれる特別なKSファイルです。
;Fixレイヤーの初期化など、ロード時点で再構築したい処理をこちらに記述してください。
;
;

;make.ks はロード時にcallとして呼ばれるため、return必須です。

; tf._ts（thema_nagi_1の状態変数）はawakegame後にclearTmpVariableで消えるため、ここで再初期化する
[plugin name="thema_nagi_1" fade="off" btn_pos="bottom"]

; キャラ名表示エリアの再構築（ロード後に消えるため）
[free name="chara_name_area" layer="message0"]
[ptext name="chara_name_area" layer="message0" color="0xf2f2f2" size="26" bold="bold" x="100" y="520"]
[chara_config ptext="chara_name_area"]

; ロード時にタイトル画面のDOMが残っていたら消す
[iscript]
$('#title_ui').remove();
$('#title_fade_overlay').remove();
$('#ng_black').remove();
$('#exit_overlay').remove();
[endscript]

[return]

