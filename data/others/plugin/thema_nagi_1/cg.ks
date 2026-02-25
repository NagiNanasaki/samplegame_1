; ==============================================================
; cg.ks  ―  CGモード
; thema_nagi_1 プラグイン 同梱テンプレート
; --------------------------------------------------------------
;
; 【配置方法】
;   このファイルを data/scenario/ にコピーして使用します。
;   ナビボタン・ロック画像は
;   data/others/plugin/thema_nagi_1/image/cg/ から参照します。
;
; 【CG画像の登録】
;   各ページラベル（*cg_p0 など）の [cg_image_button] を編集します。
;
;   graphic : 解放時に閲覧するCG（bgimage フォルダ基準のファイル名）
;   thumb   : サムネイル画像。省略時は graphic と同じ画像を使用
;   差分あり: graphic="['差分A.jpg','差分B.jpg']" のように配列で指定
;   未登録 : graphic="" のままにしてください（鍵アイコン表示）
;
; 【ページ数の変更】
;   1. *cg_p1, *cg_p2 … ラベルを複製して追加する
;   2. iscript 内の tf._cg.total を総ページ数に合わせる
;
; 【閉じたときの遷移先】
;   *cg_close ラベルの [jump storage=] を書き換えてください
;
; 【このファイルの画像について】
;   image/cg/ 内の素材は theme_kopanda_16（copanda 様）の
;   CGモードサンプルを流用したプレースホルダーです。
;   頒布の際はご自身の画像に差し替えるか、
;   copanda 様の配布規約を確認してください。
;
; ==============================================================


; ==============================================================
; [cg_image_button] マクロ定義
; TyranoScript 標準タグではないため、ここで定義します。
; --------------------------------------------------------------
; ・graphic が空のスロットは非表示
; ・sf["cg_"+graphic] == 1 なら解放済み → サムネ表示 → *clickcg へ
; ・未解放 → 鍵アイコン表示 → *no_image へ
; ==============================================================
[macro name="cg_image_button"]
[if exp="mp.graphic != ''"]

[iscript]
var _g = mp.graphic;
var _key = "cg_" + _g.replace(/[^a-zA-Z0-9]/g, "_");
tf._cg_slot_unlocked = (TYRANO.kag.variable.sf[_key] === 1);
// クリック時に実行するJS式を描画時に確定させる（変数の上書き問題を防ぐ）
tf._cg_slot_exp = "tf._cg_slot_graphic='" + _g.replace(/'/g, "\\'") + "'";
[endscript]

[if exp="tf._cg_slot_unlocked"]
; 解放済み: サムネイルを表示してクリックで閲覧
[button folder="bgimage" graphic="&mp.graphic" target="*cg_slot_click" exp="&tf._cg_slot_exp" x="&mp.x" y="&mp.y" width="&mp.width" height="&mp.height"]
[else]
; 未解放: 鍵アイコンを表示（クリック無効）
[button graphic="&mp.no_graphic" target="*no_image" x="&mp.x" y="&mp.y" width="&mp.width" height="&mp.height"]
[endif]

[endif]
[endmacro]

; ==============================================================
; [cg_slot] マクロ  ―  スロット番号でCG登録（簡易版）
;   col / row でスロット位置を指定するだけで配置できる。
;   col=0〜2（列）, row=0〜1（行）
;   例: [cg_slot graphic="cg01.jpg" col="0" row="0"]
;       graphic="" のままにするとスロットが非表示になる。
; ==============================================================
[macro name="cg_slot"]
[iscript]
tf._cg_slot_x = tf._cg.slot.cols[parseInt(mp.col)];
tf._cg_slot_y = tf._cg.slot.rows[parseInt(mp.row)];
[endscript]
[cg_image_button graphic="&mp.graphic" no_graphic="&tf._cg.slot.lock" x="&tf._cg_slot_x" y="&tf._cg_slot_y" width="&tf._cg.slot.w" height="&tf._cg.slot.h"]
[endmacro]

; マクロ定義後は *start へ（直後のラベルが誤って実行されないよう）
[jump target="*start"]

; ==============================================================
; *cg_slot_click  ―  解放済みサムネをクリックしたとき
; ==============================================================
*cg_slot_click
[iscript]
tf.selected_cg_image = [tf._cg_slot_graphic];
tf._cg_idx = 0;
[endscript]
[jump target="*clickcg"]


; --------------------------------------------------------------
*start
; --------------------------------------------------------------

[mask time="100"]

[layopt layer="message0" visible="false"]
[layopt layer="0"        visible="true"]
[hidemenubutton]
[clearfix]
[cm]
[freeimage layer="0"]
[freeimage layer="1"]

[iscript]

// ---- CGモード設定 ----
var _d = "../others/plugin/thema_nagi_1/image/cg/";

tf._cg = {
  dir  : _d,
  page : 0,   // 現在のページ番号（0始まり）
  total: 1,   // 総ページ数 ← ページを増やしたらここを変更

  // サムネイルスロット（3列 × 2行）
  slot: {
    w   : 272,
    h   : 153,
    cols: [225, 517, 809],
    rows: [240, 413],
    lock: _d + "lock.png",
  },

  // 各ボタンの座標と画像
  back: { x:    0, y: 645, img: _d+"btn_back.png", hov: _d+"btn_back_hov.png", clk: _d+"btn_back_clk.png" },
  prev: { x:  103, y: 363, img: _d+"btn_prev.png", hov: _d+"btn_prev_hov.png", clk: _d+"btn_prev_clk.png" },
  next: { x: 1157, y: 363, img: _d+"btn_next.png", hov: _d+"btn_next_hov.png", clk: _d+"btn_next_clk.png" },
};

// TyranoScript の [cg_image_button] が使うワーク変数
tf.selected_cg_image = [];
tf._cg_idx = 0;

[endscript]

; 背景
[image storage="&tf._cg.dir+'gallery_bg.jpg'" layer="base" x="0" y="0" time="0" wait="false"]

[jump target="*cg_page"]




; ==============================================================
; *cg_page  ―  ページ描画ハブ
;   ここで共通ボタンを配置し、ページ別ラベルへジャンプする
; ==============================================================
*cg_page

[cm]

; ---- 共通ボタン ----

; 戻る（全ページ共通）
[button graphic="&tf._cg.back.img" enterimg="&tf._cg.back.hov" activeimg="&tf._cg.back.clk" target="*cg_close" x="&tf._cg.back.x" y="&tf._cg.back.y"]

; 前ページ（2ページ目以降のみ表示）
[if exp="tf._cg.page > 0"]
[button graphic="&tf._cg.prev.img" enterimg="&tf._cg.prev.hov" activeimg="&tf._cg.prev.clk" target="*cg_prev" x="&tf._cg.prev.x" y="&tf._cg.prev.y"]
[endif]

; 次ページ（最終ページ以外のみ表示）
[if exp="tf._cg.page < tf._cg.total - 1"]
[button graphic="&tf._cg.next.img" enterimg="&tf._cg.next.hov" activeimg="&tf._cg.next.clk" target="*cg_next" x="&tf._cg.next.x" y="&tf._cg.next.y"]
[endif]

; ページ別スロット定義へ（動的ジャンプ）
[jump target="& 'cg_p' + tf._cg.page"]




; ==============================================================
; *cg_p0  ―  1ページ目
;   [cg_slot] でスロットを定義してください。
;   col=列（0〜2）, row=行（0〜1）で位置を指定。
;   graphic="" のままだとスロット自体が非表示になります（空扱い）。
;   ゲーム本編で [cg storage="ファイル名"] を呼ぶと解放されます。
; ==============================================================
*cg_p0

[cg_slot graphic="cg01.jpg" col="0" row="0"]
[cg_slot graphic="cg02.jpg" col="1" row="0"]
[cg_slot graphic="cg03.jpg" col="2" row="0"]

[cg_slot graphic="cg04.jpg" col="0" row="1"]
[cg_slot graphic="cg05.jpg" col="1" row="1"]
[cg_slot graphic="cg06.jpg" col="2" row="1"]

[jump target="*cg_wait"]

; ページを追加する場合は以下を複製し、tf._cg.total の値も増やしてください
;
; *cg_p1
; [cg_slot graphic="" col="0" row="0"]
; ... （スロット6個）
; [jump target="*cg_wait"]




; ==============================================================
; *cg_wait  ―  ページネーション表示 → 入力待ち
; ==============================================================
*cg_wait

; ページ番号（例: 1 / 2）
[free layer="0" name="cg_pgnum" time="1"]
[ptext layer="0" name="cg_pgnum" text="& (tf._cg.page + 1) + ' / ' + tf._cg.total" x="0" y="600" size="18" color="0xa0a0a0" width="1280" align="center"]

[mask_off time="300"]
[s]




; ==============================================================
; *cg_close  ―  CGモードを閉じて遷移
; ==============================================================
*cg_close

[mask time="200"]
[cm]
[freeimage layer="0"]
[freeimage layer="1"]
[freeimage layer="base"]
[mask_off time="200"]

; 遷移先を変えたい場合はここを書き換えてください
[jump storage="title.ks"]




; ==============================================================
; ページ送り
; ==============================================================
*cg_next
[eval exp="tf._cg.page++"]
[jump target="*cg_page"]

*cg_prev
[eval exp="tf._cg.page--"]
[jump target="*cg_page"]




; ==============================================================
; *no_image  ―  未解放スロットをクリック（何もしない）
; ==============================================================
*no_image
[jump target="*cg_page"]




; ==============================================================
; *clickcg  ―  解放済みCGをクリック → 閲覧開始
;   TyranoScript が tf.selected_cg_image[] に差分リストをセットして
;   このラベルへジャンプしてくる
; ==============================================================
*clickcg

[cm]
[freeimage layer="1" page="back"]
[eval exp="tf._cg_idx = 0"]


; ---- 差分ループ ----
*cg_view

[iscript]
tf._cg_storage = tf.selected_cg_image[tf._cg_idx];
[endscript]

[freeimage layer="1" page="back"]
[image     layer="1" page="back" storage="&tf._cg_storage" folder="bgimage" width="1280" height="720"]
[trans     layer="1" time="700"]
[wt]
[l]

[eval exp="tf._cg_idx++"]

; 差分が残っていれば続けて表示、なければギャラリーへ戻る
[if exp="tf._cg_idx < tf.selected_cg_image.length"]
  [jump target="*cg_view"]
[else]
  [freeimage layer="1" page="back"]
  [freeimage layer="1" page="fore" time="700"]
  [jump target="*cg_page"]
[endif]
