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


;オープニングスプラッシュ表示
[show_opening logo=logo.png warning=warning.png]

;タイトル画面へ移動
@jump storage="title.ks"

[s]


