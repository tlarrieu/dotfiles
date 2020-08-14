(defvar *homepage*
  (concatenate 'string (uiop:getenv "HOME") "/.config/luakit/startpage.html"))

(define-mode base-mode ()
  ((keymap-scheme
     :accessor
     keymap-scheme
     :initarg
     :keymap-scheme
     :type keymap:scheme
     :initform
     (define-scheme "base"
       scheme:cua
       (list
         "C-q" 'quit
         "C-[" 'switch-buffer-previous
         "C-]" 'switch-buffer-next
         "C-x b" 'switch-buffer
         "C-x k" 'delete-buffer
         "C-w" 'delete-current-buffer
         "C-x C-k" 'delete-current-buffer
         "C-shift-tab" 'switch-buffer-previous
         "C-tab" 'switch-buffer-next
         "C-pageup" 'switch-buffer-previous
         "C-pagedown" 'switch-buffer-next
         "C-l" 'set-url-from-current-url
         "M-l" 'set-url-new-buffer
         "f5" 'reload-current-buffer
         "C-r" 'reload-current-buffer
         "C-R" 'reload-buffer
         "C-m o" 'set-url-from-bookmark
         "C-m C-o" 'set-url-from-bookmark-new-buffer
         "C-m s" 'bookmark-current-page
         "C-d" 'bookmark-current-page
         "C-m C-s" 'bookmark-page
         "C-m k" 'bookmark-delete
         "C-t" 'make-buffer-focus
         "C-m u" 'bookmark-url
         "C-b" 'show-bookmarks
         "M-c l" 'copy-url
         "M-c t" 'copy-title
         "f1 f1" 'help
         "f1 t" 'tutorial
         "f1 r" 'manual
         "f1 v" 'describe-variable
         "f1 f" 'describe-function
         "f1 c" 'describe-command
         "f1 C" 'describe-class
         "f1 s" 'describe-slot
         "f1 k" 'describe-key
         "f1 b" 'describe-bindings
         "f11" 'fullscreen-current-window
         "C-o" 'load-file
         "C-j" 'download-list
         "C-space" 'execute-command
         "C-n" 'make-window
         "C-shift-W" 'delete-current-window
         "C-W" 'delete-current-window
         "M-w" 'delete-window
         "C-/" 'reopen-buffer
         "C-shift-t" 'reopen-buffer
         "C-T" 'reopen-buffer
         "C-p" 'print-buffer
         "C-x C-f" 'open-file)
       scheme:emacs
       (list
         "C-x C-c" 'quit
         "C-[" 'switch-buffer-previous
         "C-]" 'switch-buffer-next
         "C-x b" 'switch-buffer
         "C-x k" 'delete-buffer ; Emacs' default behaviour is to query.
         "C-x C-k" 'delete-current-buffer
         "C-x left" 'switch-buffer-previous
         "C-x right" 'switch-buffer-next
         "C-pageup" 'switch-buffer-previous
         "C-pagedown" 'switch-buffer-next
         "C-l" 'set-url
         "M-l" 'set-url-new-buffer
         "C-t" 'make-buffer-focus
         "C-r" 'reload-current-buffer
         "C-R" 'reload-buffer
         "C-m o" 'set-url-from-bookmark
         "C-m C-o" 'set-url-from-bookmark-new-buffer
         "C-m s" 'bookmark-current-page
         "C-m C-s" 'bookmark-page
         "C-m k" 'bookmark-delete
         "C-m u" 'bookmark-url
         "C-M-l" 'copy-url
         "C-M-i" 'copy-title
         "C-h C-h" 'help
         "C-h h" 'help
         "C-h t" 'tutorial
         "C-h r" 'manual
         "C-h v" 'describe-variable
         "C-h f" 'describe-function
         "C-h c" 'describe-command
         "C-h C" 'describe-class
         "C-h s" 'describe-slot
         "C-h k" 'describe-key
         "C-h b" 'describe-bindings
         "C-o" 'load-file
         "M-x" 'execute-command
         "C-x 5 2" 'make-window
         "C-x 5 0" 'delete-current-window
         "C-x 5 1" 'delete-window
         "C-/" 'reopen-buffer
         "C-x C-f" 'open-file)
       scheme:vi-normal
       (list
         "Z Z" 'quit
         "[" 'switch-buffer-previous
         "]" 'switch-buffer-next
         "C-pageup" 'switch-buffer-previous
         "C-pagedown" 'switch-buffer-next
         "g b" 'switch-buffer
         "B" 'make-buffer-focus
         "m u" 'bookmark-url
         "m d" 'bookmark-delete
         "m o" 'set-url-from-bookmark
         "m O" 'set-url-from-bookmark-new-buffer
         "m m" 'bookmark-page
         "m M" 'bookmark-current-page
         "y t" 'copy-title
         "C-h C-h" 'help
         "C-h h" 'help
         "C-h t" 'tutorial
         "C-h r" 'manual
         "C-h v" 'describe-variable
         "C-h f" 'describe-function
         "C-h c" 'describe-command
         "C-h C" 'describe-class
         "C-h s" 'describe-slot
         "C-h k" 'describe-key
         "C-h b" 'describe-bindings
         "C-o" 'load-file
         "W" 'make-window
         "C-w C-w" 'make-window
         "C-w q" 'delete-current-window
         "C-w C-q" 'delete-window
         "u" 'reopen-buffer
         "C-x C-f" 'open-file

         ;; overridden mapping
         "r" 'reload-current-buffer
         "R" 'reload-buffer
         "y y" 'copy-url
         "y e" 'nyxt/web-mode::copy-hint-url
         "D" 'delete-buffer
         "d" 'delete-current-buffer
         "c o" 'delete-other-buffers
         "o" 'set-url
         "," 'set-url-new-buffer
         "è" 'execute-command
         "é" 'nyxt/web-mode::search-buffer
         "e" 'nyxt/web-mode::follow-hint
         "t" 'nyxt/web-mode::follow-hint-new-buffer)))))

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
         "C-d" 'nyxt/web-mode::scroll-page-down
         "C-u" 'nyxt/web-mode::scroll-page-up
         "C-p" 'switch-buffer-previous
         "C-n" 'switch-buffer-next
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
