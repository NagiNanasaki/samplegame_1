;=========================================
; make.ks - ロード時に必ず実行される特殊ファイル
;
; TyranoScript の仕様として、セーブデータをロードした際に
; このファイルが [call] として呼ばれる（callなので末尾に [return] が必要）。
;
; ここには「ゲームをロードした直後に必ず再構築が必要な処理」を書く。
; 例: プラグインの再初期化、フック関数の再設定、DOM のクリーンアップ
;
; このファイルは削除しないでください！
;=========================================

;-------------------------------------------
; thema_nagi_1 プラグインの再初期化
;
; tf._ts（thema_nagi_1 が使う状態変数）は、[awakegame] の後に
; clearTmpVariable() によって消去される。
; そのため、コンフィグ→ New Game の順で操作すると
; "Cannot read properties of undefined (reading 'fade')" エラーが発生し、
; システムボタンが表示されなくなる。
;
; ここで [plugin] を再実行することで tf._ts を再初期化し、
; ロード後も正常にシステムボタンが動作するようにする。
;-------------------------------------------
[plugin name="thema_nagi_1" fade="off" btn_pos="bottom"]

;-------------------------------------------
; chara_ptext フックの再設定
;
; qsave/qload 後にキャラ名が消える問題への対策。
; ロード後もフックが有効になるよう保険として再設定する。
;
; フックの役割：[chara_ptext] タグが実行されるたびに
; f._last_chara_name にキャラ名を保存する。
; title.ks にも同じフックがあるが、ロード後は title.ks を
; 経由しないことがあるため、make.ks でも設定する。
;
; _hooked フラグで二重フックを防いでいる。
;-------------------------------------------
[iscript]
try {
    if (TYRANO.kag.tag.chara_ptext && !TYRANO.kag.tag.chara_ptext._hooked) {
        // 元の start 関数を退避
        TYRANO.kag.tag.chara_ptext._origStart = TYRANO.kag.tag.chara_ptext.start;
        // 新しい start 関数でラップ（キャラ名を保存してから元の処理を呼ぶ）
        TYRANO.kag.tag.chara_ptext.start = function(pm) {
            // f 変数（セーブデータに含まれる）にキャラ名を保存
            // stat 直接プロパティは clearTmpVariable で消えるため f を使う
            if (TYRANO.kag.stat.f) { TYRANO.kag.stat.f._last_chara_name = pm.name != null ? pm.name : ""; }
            TYRANO.kag.tag.chara_ptext._origStart.call(this, pm);
        };
        TYRANO.kag.tag.chara_ptext._hooked = true;
    }
} catch(e) { console.error("[chara_ptext hook make.ks]", e); }
[endscript]

;-------------------------------------------
; ロード後のキャラ名復元
;
; TyranoScript の HTML セーブ/ロードは ptext 要素の
; テキスト内容を復元しない。
; そのため、上のフックで保存した f._last_chara_name を読み取り、
; ロード後 100ms 後（DOM 構築完了のタイミング）に ptext 要素に再セットする。
;
; stat.chara_ptext : 名前表示に使っている ptext 要素のクラス名
; f._last_chara_name : フックで保存した最後のキャラ名
;-------------------------------------------
[iscript]
setTimeout(function() {
    var cls  = TYRANO.kag.stat.chara_ptext;   // ptext のクラス名
    var name = (TYRANO.kag.stat.f && TYRANO.kag.stat.f._last_chara_name != null)
               ? TYRANO.kag.stat.f._last_chara_name : null;
    if (cls && name !== null) {
        var $p = $("." + cls);
        if ($p.length > 0) { $p.html(name); } // ptext 要素にキャラ名をセット
    }
}, 100);
[endscript]

;-------------------------------------------
; タイトル画面 DOM のクリーンアップ
;
; ゲームのロード後にタイトル画面の DOM 要素が残っていると
; ゲーム画面上に重なって表示されてしまう。
; ロード直後に確実に削除しておく。
;
; #title_ui       : タイトル画面の UI コンテナ
; #title_fade_overlay : タイトルのフェードイン/アウト用白オーバーレイ
; #ng_black       : NewGame ボタンの黒フェードオーバーレイ
; #exit_overlay   : Config/Extra 遷移時のフェードオーバーレイ
;-------------------------------------------
[iscript]
$('#title_ui').remove();
$('#title_fade_overlay').remove();
$('#ng_black').remove();
$('#exit_overlay').remove();
[endscript]

; make.ks は [call] で呼ばれるため [return] で呼び出し元に戻る
[return]

