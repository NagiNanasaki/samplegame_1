;=========================================
; CG モード　画面作成（theme_kopanda_09 ベース）
;=========================================

[layopt layer=message0 visible=false]
[layopt layer=0 visible=true]
[layopt layer=1 visible=true]
[hidemenubutton]
[clearfix]
[cm]

[bg storage="../image/append_theme/bg_gallery.png" time=300]
[iscript]
anime({targets:'#exit_overlay', opacity:[1,0], duration:300, easing:'easeOutQuad', complete:function(){ $('#exit_overlay').remove(); }});
$('#title_ui').css('opacity', '0');
[endscript]

[iscript]
tf.page              = 0;
tf.selected_cg_image = [];
tf.cg_index          = 0;
[endscript]

[jump target=*cgpage]

;-----------------------------------------------------------
*cgpage
;-----------------------------------------------------------
[cm]

[button graphic="append_theme/gallery_close.png" enterimg="append_theme/gallery_close2.png" target=*backtitle x=1170 y=20]

[jump target="& 'page_' + tf.page "]

;-------------------------------------------------------
*page_0
;-------------------------------------------------------

; 一段目
[cg_image_button graphic="rouka.jpg,room.jpg,title.png" no_graphic="../image/append_theme/lock.png" x=240 y=184 width=252 height=142 folder=bgimage]
[cg_image_button graphic="room.jpg" no_graphic="../image/append_theme/lock.png" x=512 y=184 width=252 height=142 folder=bgimage]
[cg_image_button graphic="" no_graphic="../image/append_theme/lock.png" x=784 y=184 width=252 height=142]

; 二段目
[cg_image_button graphic="" no_graphic="../image/append_theme/lock.png" x=240 y=349 width=252 height=142]
[cg_image_button graphic="" no_graphic="../image/append_theme/lock.png" x=512 y=349 width=252 height=142]
[cg_image_button graphic="" no_graphic="../image/append_theme/lock.png" x=784 y=349 width=252 height=142]

; 三段目
[cg_image_button graphic="" no_graphic="../image/append_theme/lock.png" x=240 y=514 width=252 height=142]
[cg_image_button graphic="" no_graphic="../image/append_theme/lock.png" x=512 y=514 width=252 height=142]
[cg_image_button graphic="" no_graphic="../image/append_theme/lock.png" x=784 y=514 width=252 height=142]

[jump target=*common]

;-------------------------------------------------------
*common
;-------------------------------------------------------

[s]

;-----------------------------------------------------------
*backtitle
;-----------------------------------------------------------
[cm]
[freeimage layer=0]
[freeimage layer=1]

[clearstack]
[jump storage="title.ks"]

;-----------------------------------------------------------
*nextpage
;-----------------------------------------------------------
[eval exp=tf.page++]
[jump target=*cgpage]

;-----------------------------------------------------------
*prevpage
;-----------------------------------------------------------
[eval exp=tf.page--]
[jump target=*cgpage]

;-----------------------------------------------------------
*no_image
;-----------------------------------------------------------
[jump target=*cgpage]

;-----------------------------------------------------------
*clickcg
;-----------------------------------------------------------
[cm]
[freeimage layer=1 page=back]

[eval exp="tf.cg_index = 0"]

;-------------------------------------------------------
*cg_next_image
;-------------------------------------------------------
[iscript]
tf.storage = tf.selected_cg_image[tf.cg_index];
[endscript]

[freeimage layer=1 page=back]
[image layer=1 page=back storage=&tf.storage folder=bgimage width=1280 height=720]
[trans layer=1 time=700]
[wt]
[l]

[eval exp=tf.cg_index++]

[if exp="tf.selected_cg_image.length > tf.cg_index"]
  [jump target=cg_next_image]
[else]
  [freeimage layer=1 page=back]
  [freeimage layer=1 page=fore time=700]
  [jump target=*cgpage]
[endif]
