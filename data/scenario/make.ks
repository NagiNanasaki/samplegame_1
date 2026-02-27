;このファイルは削除しないでください！
;
;make.ks はデータをロードした時に呼ばれる特別なKSファイルです。
;Fixレイヤーの初期化など、ロード時点で再構築したい処理をこちらに記述してください。
;
;

;make.ks はロード時にcallとして呼ばれるため、return必須です。

; tf._ts（thema_nagi_1の状態変数）はawakegame後にclearTmpVariableで消えるため、ここで再初期化する
[plugin name="thema_nagi_1" fade="off" btn_pos="bottom"]

[return]

