(defvar *homepage*
  (concatenate 'string (uiop:getenv "HOME") "/.config/luakit/startpage.html"))

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
       (make-search-engine "ym" "https://music.youtube.com/search?q=~a")))
   (startup-function
     (make-startup-function :buffer-fn (lambda () (make-buffer :url *homepage*))))))

(define-configuration buffer
  ((default-modes (append '(vi-normal-mode) %slot-default))
   (override-map
     (let
       ((custom-map (make-keymap "Custom bindings")))
       (define-key
         custom-map
         "C-," 'execute-command
         "C-l" 'set-url
         "C-t" 'set-url-new-buffer

         "C-p" 'switch-buffer-previous
         "C-n" 'switch-buffer-next

         "C-e" 'nyxt/web-mode::follow-hint-new-buffer

         "C-c C-l" 'copy-url
         "C-c C-e" 'nyxt/web-mode::copy-hint-url

         "C-d" 'nyxt/web-mode::scroll-page-down
         "C-u" 'nyxt/web-mode::scroll-page-up

         "C-é" 'delete-current-buffer
         "C-o" 'delete-other-buffers

         "C-b" 'switch-buffer)
         custom-map))))

(define-configuration minibuffer
  ((override-map
     (let
       ((custom-map (make-keymap "Custom bindings")))
       (define-key
         custom-map
         "C-m" 'nyxt/minibuffer-mode::minibuffer-toggle-mark)
         custom-map))))
