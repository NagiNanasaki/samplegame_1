================================================================
  thema_nagi_1 - TyranoScript システムUIテーマプラグイン
================================================================

【概要】
  ティラノスクリプトのシステム周りのUI（メッセージウィンドウ・
  機能ボタン・メニュー/セーブ/ロード/バックログ/コンフィグ画面）を
  一括で差し替えるオリジナルテーマプラグインです。

  ・機能ボタンは常時表示またはカーソルを端に近づけたときだけ表示（切替可）
  ・セーブ/ロード/バックログ/メニューは専用HTMLでデザインを統一
  ・glink選択肢にも統一感のあるボタンスタイルを適用可能
  ・CGモードテンプレート同梱


【ファイル構成】
  thema_nagi_1/
  ├── init.ks           ← メインファイル（プラグイン本体）
  ├── config.ks         ← コンフィグ（設定）画面
  ├── cg.ks             ← CGモード（テンプレート／要コピー）
  ├── style.css         ← スタイルシート
  ├── README.txt        ← このファイル
  ├── html/
  │   ├── menu.html     ← メニュー画面
  │   ├── save.html     ← セーブ画面
  │   ├── load.html     ← ロード画面
  │   └── backlog.html  ← バックログ画面
  └── image/
      ├── frame_message.png   ← メッセージ枠
      ├── button/             ← 機能ボタン画像（通常 + ホバー用）
      ├── system/             ← メニュー・セーブ等の画像
      ├── config/             ← コンフィグ画面の画像
      └── cg/                 ← CGモード用画像（プレースホルダー）


【導入手順】
  ① thema_nagi_1 フォルダを data/others/plugin/ 以下に配置する

  ② first.ks に以下を追記する：
       [plugin name="thema_nagi_1"]

  ③ 機能ボタンを表示したいシーンで以下を呼び出す：
       [tsw_button]
     　※ マクロ内や [set_message_window] 相当の処理でまとめて呼ぶと便利

  ④ 機能ボタンを非表示にするには：
       [clearfix name="role_button"]

  ⑤ glink選択肢にプラグインのボタンスタイルを適用するには：
       [glink color="tswitch" text="選択肢テキスト" target="*label"]


【pluginタグのパラメータ】
  すべて省略可能です。

  font_color    : 本文のフォントカラー          （デフォルト: 0xf2f2f2）
  name_color    : 名前欄のフォントカラー         （デフォルト: 0xf2f2f2）
  font_color2   : 既読テキストのフォントカラー   （デフォルト: font_color と同値）
  frame_opacity : メッセージ枠の不透明度（0〜255）（デフォルト: 255）
  glyph         : クリック待ちグリフ on/off       （デフォルト: off）
  fade          : ホバーフェード on/off           （デフォルト: off）
                    off = 常時表示
                    on  = カーソルを端に近づけたときだけ表示
  btn_pos       : ボタン位置 top/bottom           （デフォルト: bottom）
                    bottom = 画面下部に常時表示（btn_y デフォルト: 693）
                    top    = 画面上部にホバーで表示（btn_y デフォルト: 10）
  btn_y         : 機能ボタンのY座標              （btn_pos により自動設定、手動上書き可）

  記述例：
    [plugin name="thema_nagi_1" font_color="0xe8f4f0" btn_pos="top" glyph="on"]
    [plugin name="thema_nagi_1" fade="on" btn_pos="top"]


【機能ボタンのホバー表示について】
  fade="off"（デフォルト）の場合、機能ボタンは常時表示されます。

  fade="on" にすると、カーソルを画面端に近づけたときだけ
  機能ボタンがフェードインして表示されます。
  カーソルが離れると自動的にフェードアウトします。

  btn_pos="top" なら上端、"bottom" なら下端が検知エリアです。

  ホバー検知エリアの幅や速度を変えたい場合は init.ks 内の以下を編集してください：
    var TRIGGER_Y = 90;   ← 数値を大きくすると検知エリアが広くなります
    var FADE_MS   = 200;  ← フェードの速さ（ミリ秒）


【CGモードの導入方法】
  ① cg.ks を data/scenario/ にコピーする

  ② タイトル画面など、CGモードに入りたい箇所から呼び出す：
       [jump storage="cg.ks"]

  ③ cg.ks の *cg_p0 ラベル内の [cg_slot] を編集して
     ゲームのCG画像を登録する（bgimage フォルダ基準のファイル名）

       [cg_slot graphic="cg01.jpg" col="0" row="0"]
       [cg_slot graphic="cg02.jpg" col="1" row="0"]

     col=列（0〜2）, row=行（0〜1）でスロット位置を指定します。
     graphic="" のままにすると、そのスロットは非表示になります。

  ④ ゲーム本編で CG を解放するには：
       [cg storage="cg01.jpg"]

     storage にファイル名を指定するだけでOKです。
     ファイル名の変換処理は内部で自動的に行われます。

  ⑤ ページを増やす場合は *cg_p1, *cg_p2 … を追加し、
     iscript 内の tf._cg.total を総ページ数に変更する

  ⑥ 終了後の遷移先は *cg_close ラベルの [jump storage=] で変更する

  ※ image/cg/ 内の素材は theme_kopanda_16（copanda 様）の
     CGモードサンプルからのプレースホルダーです。
     頒布する場合はご自身の画像に差し替えるか、copanda 様の
     配布規約を確認のうえ使用してください。


【カスタマイズ方法】
  ■ ボタンの配置・種類を変えたい
    init.ks 内の [button] タグ一覧を編集してください。
    x 座標を変えてボタン位置を調整できます。
    不要なボタンは行ごと削除可能です。

  ■ 画像を差し替えたい
    image/ フォルダ内の画像を同名ファイルで上書きしてください。
    ホバー時の画像は末尾が「2.png」のファイルです（例: save.png → save2.png）。

  ■ メニュー・セーブ等のレイアウトを変えたい
    html/ フォルダ内の HTML を編集してください。
    ※ TyranoScript が参照するクラス名（menu_item, save_list 等）は
       削除しないでください。

  ■ セーブデータの日付・テキストの色を変えたい
    style.css の .save_list_item_date / .save_list_item_text を編集してください。

  ■ コンフィグ画面の段階数・速度値を変えたい
    config.ks 冒頭の tf._vols / tf._chs / tf._autos 配列を編集してください。


================================================================
