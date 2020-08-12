(define-configuration browser
  ((session-restore-prompt :never-ask)
   (autofills
     (list
        (nyxt::make-autofill :key "firstname" :fill "Thomas")
        (nyxt::make-autofill :key "lastname" :fill "Larrieu")
        (nyxt::make-autofill :key "email/perso" :fill "thomas.larrieu@gmail.com")
        (nyxt::make-autofill :key "email/pro" :fill "thomas.larrieu@jobteaser.com")))
   (external-editor-program "/usr/bin/nvim")
   (search-engines
     (list
       (make-search-engine "default" "https://duckduckgo.com/?q=~a")
       (make-search-engine "yt" "https://www.youtube.com/results?q=~a")
       (make-search-engine "vim" "https://vimawesome.com/?q=~a")
       (make-search-engine "g" "https://github.com/~a")
       (make-search-engine "gh" "https://github.com/search?q=~a")
       (make-search-engine "m" "https://scryfall.com/search?q=~a")
       (make-search-engine "a" "https://wiki.archlinux.org/index.php/~a")
       (make-search-engine "dt" "https://www.dndtools.net/spells/?name=~a&_filter=Filter")
       (make-search-engine "h" "https://www.haskell.org/hoogle?hoogle=~a")
       (make-search-engine "r" "https://reddit.com/r/~a")
       (make-search-engine "rg" "https://rubygems.org/search?query=~a")
       (make-search-engine "t" "https://www.xn--thepratebay-fcb.com/proxy/go.php?url=s/?q=~a")
       (make-search-engine "v" "https://vimawesome.com/?q=~a")
       (make-search-engine "wp" "https://wallhaven.cc/search?q=~a&atleast=1920x1080")
       (make-search-engine "w" "https://en.wikipedia.org/wiki/Special:Search?search=~a")
       (make-search-engine "ym" "https://music.youtube.com/search?q=~a")))))

(define-configuration buffer
  ((override-map
     (let
       ((custom-map (make-keymap "Custom bindings")))
       (define-key
         custom-map
         "C-," 'execute-command
         "C-l" 'set-url

         "C-é" 'delete-current-buffer
         "C-o" 'delete-other-buffers

         "C-b" 'switch-buffer)
         custom-map))))

; (define-configuration buffer
;   ((keymap-scheme-name scheme:vi-normal)
;    (override-map
;      (let
;        ((custom-map (make-keymap "Custom bindings")))
;        (define-key
;          custom-map
;          "è" 'execute-command
;          "," 'set-url-new-buffer

;          "c o" 'delete-other-buffers
;          "d" 'delete-current-buffer
;          "r" 'reload-current-buffer

;          "C-b" 'switch-buffer
;          "tab" 'switch-buffer-next
;          "C-tab" 'switch-buffer-previous

;          ; "C-o" 'history-backwards
;          ; "C-i" 'history-forwards

;          "y y" 'copy-url
;          ; "y e" 'copy-hint-url

;          "g b" 'show-bookmarks)
;          custom-map))))
