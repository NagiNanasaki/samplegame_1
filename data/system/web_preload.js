(function() {
    "use strict";

    var IMAGE_EXT = /\.(png|jpe?g|webp|gif|svg)(\?.*)?$/i;
    var REQUIRED_ASSETS = [
        "./data/others/plugin/opening_splash/logo.png",
        "./data/others/plugin/opening_splash/warning.png",

        "./data/bgimage/title_menu.webp",
        "./data/image/title/title_logo.webp",
        "./data/fgimage/chara/tensi/tensi_normal.webp",

        "./data/bgimage/church.webp",
        "./data/bgimage/rouka.webp",
        "./data/image/bg_rule_image/001.png",
        "./data/image/ikari_icon.webp",
        "./data/fgimage/star.webp",

        "./data/bgm/op.mp3",
        "./data/bgm/bgm1.mp3",
        "./data/sound/piano_po-n.mp3",
        "./data/sound/start.mp3",
        "./data/sound/se_papa.mp3",
        "./data/sound/ikari.mp3",
        "./data/sound/voice1.wav",

        "./data/others/Mplus1-SemiBold.otf",
        "./data/others/plugin/thema_nagi_1/image/frame_message.png",
    ];

    var BACKGROUND_ASSETS = [
        "./data/video/gameplay_demo.mp4",
        "./data/image/append_theme/bg_gallery.png",
        "./data/others/plugin/thema_nagi_1/image/config/bg_config.jpg",
        "./data/others/plugin/thema_nagi_1/image/config/check.png",
        "./data/others/plugin/thema_nagi_1/image/config/c_btn_back.png",
        "./data/others/plugin/thema_nagi_1/image/config/c_btn_back2.png",
        "./data/others/plugin/thema_nagi_1/image/config/off.gif",
        "./data/others/plugin/thema_nagi_1/image/config/on.png",
    ];

    var CHARA_FACES = [
        "angry", "konwaku", "kutiake", "kutiake2",
        "metoji", "normal", "smile", "warai"
    ];
    var THEME_BUTTONS = [
        "qsave", "qload", "save", "load", "auto", "skip",
        "log", "screen", "sleep", "menu", "close", "title"
    ];
    var THEME_SYSTEM = [
        "arrow_down.png", "arrow_next.png", "arrow_prev.png", "arrow_up.png",
        "menu_bg.jpg", "menu_button_close.png", "menu_button_close2.png",
        "menu_button_load.png", "menu_button_load2.png",
        "menu_button_save.png", "menu_button_save2.png",
        "menu_button_skip.png", "menu_button_skip2.png",
        "menu_button_title.png", "menu_button_title2.png",
        "menu_load_bg.jpg", "menu_log_bg.jpg",
        "menu_message_close.png", "menu_message_close2.png",
        "menu_save_bg.jpg", "nextpage.gif", "saveslot.png", "saveslot2.png"
    ];

    CHARA_FACES.forEach(function(face) {
        REQUIRED_ASSETS.push("./data/fgimage/chara/tensi/tensi_" + face + ".webp");
    });
    THEME_BUTTONS.forEach(function(name) {
        REQUIRED_ASSETS.push("./data/others/plugin/thema_nagi_1/image/button/" + name + ".png");
        REQUIRED_ASSETS.push("./data/others/plugin/thema_nagi_1/image/button/" + name + "2.png");
    });
    THEME_SYSTEM.forEach(function(name) {
        REQUIRED_ASSETS.push("./data/others/plugin/thema_nagi_1/image/system/" + name);
    });

    function uniq(list) {
        var seen = {};
        return list.filter(function(path) {
            var key = String(path);
            if (seen[key]) return false;
            seen[key] = true;
            return true;
        });
    }

    function toUrl(path) {
        return new URL(path, document.baseURI).href;
    }

    function loadImage(path) {
        return new Promise(function(resolve) {
            var img = new Image();
            img.onload = function() {
                var decoded = img.decode ? img.decode().catch(function() {}) : Promise.resolve();
                decoded.then(function() { resolve({ path: path, ok: true }); });
            };
            img.onerror = function() { resolve({ path: path, ok: false }); };
            img.src = toUrl(path);
        });
    }

    function loadByFetch(path) {
        if (!window.fetch) return Promise.resolve({ path: path, ok: true });
        return fetch(toUrl(path), { cache: "force-cache" })
            .then(function(response) {
                if (!response.ok) throw new Error(response.status + " " + path);
                return response.arrayBuffer();
            })
            .then(function() { return { path: path, ok: true }; })
            .catch(function(error) {
                console.warn("[web preload]", error);
                return { path: path, ok: false };
            });
    }

    function loadAsset(path) {
        return IMAGE_EXT.test(path) ? loadImage(path) : loadByFetch(path);
    }

    function runQueue(list, options) {
        var assets = uniq(list);
        var concurrency = options && options.concurrency || 6;
        var onProgress = options && options.onProgress || function() {};
        var total = assets.length;
        var index = 0;
        var done = 0;

        onProgress(done, total);

        return new Promise(function(resolve) {
            function next() {
                if (index >= total) {
                    if (done >= total) resolve();
                    return;
                }

                var path = assets[index++];
                loadAsset(path).then(function() {
                    done++;
                    onProgress(done, total);
                    next();
                    if (done >= total) resolve();
                });
            }

            for (var i = 0; i < Math.min(concurrency, total); i++) {
                next();
            }
        }).then(function() {
            if (document.fonts && document.fonts.load) {
                return document.fonts.load("16px Mplus1SemiBold").catch(function() {});
            }
        });
    }

    var preparePromise = null;

    window.NAGI_WEB_PRELOAD = {
        shouldRun: function() {
            return location.protocol === "http:" || location.protocol === "https:";
        },
        prepare: function(options) {
            if (!this.shouldRun()) return Promise.resolve();
            if (!preparePromise) {
                preparePromise = runQueue(REQUIRED_ASSETS, options).then(function() {
                    setTimeout(function() {
                        runQueue(BACKGROUND_ASSETS, { concurrency: 2 });
                    }, 0);
                });
            }
            return preparePromise;
        }
    };
})();
