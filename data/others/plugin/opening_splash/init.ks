;*****************************************************************************
;
;   opening_splash プラグイン v1.0
;   開発ロゴ・注意表示をマスクアニメーションで行うマクロを提供します
;
;   作：ている×ている 七咲凪(X:@nanasaki_sub)
;   ご自由にお使いください。クレジット表記は任意です。
;   ※ 二次配布・再配布はご遠慮ください。
;
;*****************************************************************************
;
; ■ 必要な環境
;   ・ティラノスクリプト標準の [mask] / [mask_off] / [bg] タグが使えること
;   ・mask_rule プラグインを使用している場合はそちらも事前に読み込んでください
;
; ■ 同梱ファイル
;   init.ks    … プラグイン本体
;   logo.png   … ロゴ画像サンプル（差し替えてください）
;   warning.png… 注意画像サンプル（差し替えてください）
;   white.png  … 背景用白画像（そのままお使いいただけます）
;
; ■ 導入方法
;   1. opening_splash フォルダを data/others/plugin/ に配置する
;
;      ※ 配置場所に注意！
;        ✕ data/others/opening_splash/        ← NG（よくあるミス）
;        ○ data/others/plugin/opening_splash/ ← OK
;
;   2. logo.png / warning.png を自分のプロジェクトのものに差し替える
;      （white.png はそのままでOK）
;
;   3. first.ks に以下を追記する
;
;      [plugin name="opening_splash"]
;      [show_opening logo=logo.png warning=warning.png]
;
;      ※ テーマプラグインを使う場合は間に挟む
;
;      [plugin name="opening_splash"]
;      [plugin name="テーマプラグイン名"]
;      [show_opening logo=logo.png warning=warning.png]
;
; ■ 使い方
;   [show_opening logo=ロゴ画像 warning=注意画像]
;
;   ・logo    のみ指定 → ロゴ表示だけ行う
;   ・warning のみ指定 → 注意表示だけ行う
;   ・両方指定         → ロゴ → 注意 の順に表示する
;   ・どちらも省略     → 何も表示しない
;
; ■ パラメータ一覧
;
;   logo         : ロゴ画像ファイル名
;                  画像は opening_splash フォルダに配置してください
;                  省略時はロゴ表示をスキップ
;                  例）logo=logo.png
;
;   warning      : 注意・アテンション画像ファイル名
;                  画像は opening_splash フォルダに配置してください
;                  省略時は注意表示をスキップ
;                  例）warning=warning.png
;
;   bg           : ロゴ表示後に背景として敷く画像ファイル名
;                  画像は opening_splash フォルダに配置してください
;                  省略時は white.png（同梱）
;                  例）bg=white.png
;
;   logo_time    : ロゴのマスク（暗転）時間 ミリ秒
;                  省略時は 1000
;
;   warning_time : 注意表示のマスク（暗転）時間 ミリ秒
;                  省略時は 2000
;
;   off_time     : 暗転解除にかける時間 ミリ秒
;                  省略時は 1000
;
; ■ 使用例
;
;   ; ロゴ＋注意（最小構成）
;   [show_opening logo=logo.png warning=warning.png]
;
;   ; ロゴのみ
;   [show_opening logo=logo.png]
;
;   ; 注意のみ
;   [show_opening warning=warning.png]
;
;   ; タイミングをカスタマイズ
;   [show_opening logo=logo.png warning=warning.png logo_time=1500 warning_time=3000 off_time=800]
;
;*****************************************************************************

[macro name="show_opening"]

  ; ── ロゴ表示 ──────────────────────────────────────
  [if exp="mp.logo != undefined && mp.logo != ''"]

    ; ロゴをマスクで表示（プラグインフォルダから読み込み）
    [mask time="%logo_time|1000" graphic="%logo" folder="others/plugin/opening_splash"]

    ; ロゴ背景を白に設定
    [iscript]
    var baseLayer = TYRANO.kag.layer.getLayer("base", "fore");
    baseLayer.css({"background-color": "#FFFFFF"});
    baseLayer.find("img").hide();
    [endscript]
    [wait time=100]

    ; 暗転解除
    [mask_off time="%off_time|1000"]

  [endif]

  ; ── 注意表示 ──────────────────────────────────────
  [if exp="mp.warning != undefined && mp.warning != ''"]

    ; 注意画像をマスクで表示（プラグインフォルダから読み込み）
    [mask time="%warning_time|2000" graphic="%warning" folder="others/plugin/opening_splash"]

    ; 暗転解除
    [mask_off time="%off_time|1000"]

  [endif]

[endmacro]

[return]
