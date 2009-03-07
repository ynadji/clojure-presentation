;; Clojure mode
(add-to-list 'load-path "/Users/ynadji/Code/Lisp/slime/clojure-mode")
;(require 'clojure-auto)
(autoload 'clojure-mod "clojure-mode" "A major mode for Clojure" t)

(defvar *clojure-running* nil)

(setq swank-clojure-extra-classpaths (list "/Users/ynadji/Code/Lisp" "/Users/ynadji/.clojure" "/Users/ynadji/Code/Lisp/clojure-contrib/clojure-contrib.jar" "/Users/ynadji/Code/Lisp/programming-clojure"))
 
(defun run-clojure ()
  "Starts clojure in Slime"
  (setq *clojure-running* 1)
  (interactive)
  (slime 'clojure))
 
;; Slime
(add-to-list 'load-path "/Users/ynadji/Code/Lisp/slime") 
(add-to-list 'load-path "/Users/ynadji/Code/Lisp/slime/contrib")
(add-to-list 'load-path "/Users/ynadji/.elisp/load")
(add-to-list 'load-path "/Users/ynadji/Code/Lisp/slime/swank-clojure")
(setq swank-clojure-jar-path "/Users/ynadji/Code/Lisp/clojure/clojure.jar")
(require 'swank-clojure-autoload)

(global-set-key [f6] 'run-clojure)
 
;; To use other Lisps...
;; Incidentally, you can then choose different Lisps with
;;   M-- M-x slime <tab>
;;;; Slime infoz!
(require 'slime)
(add-to-list 'slime-lisp-implementations
             '(sbcl   ("/opt/local/bin/sbcl" "--no-linedit")))

(require 'slime-autoloads)

;;; lisp-mode
(add-hook 'lisp-mode-hook
	  (lambda ()
	    (slime-mode t)
	    (show-paren-mode t)
	    (setq lisp-indent-function
		  'common-lisp-indent-function)))
; this makes tab not also indent, should try and fix that
(add-hook 'clojure-mode-hook '(lambda () (define-key 
	  clojure-mode-map (kbd "TAB") 'dabbrev-completion)))
(define-key lisp-mode-map (kbd "TAB")
	    'slime-indent-and-complete-symbol)

;;; Something is wrong with this, slime-fancy
;;; should automatically load slime-fuzzy, but it doesn't
;;;
;;; Also, try and get pretty colors back :(
;(eval-after-load "slime"
;	 '(when (not *clojure-running*)
;		 (progn
;		  (slime-setup '(slime-fancy slime-asdf slime-banner))
;		  (require 'slime-fuzzy)
;		  (setq slime-complete-symbol*-fancy t)
;		  (setq slime-complete-symbol-function 'slime-fuzzy-complete-symbol))))
(require 'slime-fancy)

;;; slime-repl-mode
(add-hook 'slime-repl-mode-hook
	  (lambda ()
	    (progn (show-paren-mode t)
		   (local-set-key "\M-p" 'slime-repl-previous-input)
		   (local-set-key "\M-n" 'slime-repl-previous-input)
		   (local-set-key [up] 'slime-repl-previous-input)
		   (local-set-key [down] 'slime-repl-next-input))))

(global-set-key [f5] 'slime)
;; Shortcut to kill slime
(global-set-key [(control q)] 'slime-quit-lisp)

; HyperSpec
(setenv "GC_NPROCS" "1")
(require 'w3m)

(setq common-lisp-hyperspec-root "/Users/ynadji/.hyperspec/")
(setq common-lisp-hyperspec-symbol-table
      (concat common-lisp-hyperspec-root "Data/Map_Sym.txt"))
(setq browse-url-browser-function 'w3m-browse-url)
(menu-bar-mode)

;;;; Scheme infoz!
(require 'quack)
(setq scheme-program-name "mzscheme")
(global-set-key [f7] 'run-scheme)

;;;; General options
(setq scroll-conservatively most-positive-fixnum)
(split-window-vertically)

;;; fix iTerm problem
(global-set-key [?\C-h] 'delete-backward-char)
(global-set-key [?\C-x ?h] 'help-command)

;;; syntax highlighting
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

(setq slime-multiprocessing t)

;;; keyzzz
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-m" 'execute-extended-command)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key "\C-x\C-k" 'kill-region)
(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key "\r" 'newline-and-indent)

;;; gpg
(require 'pgg)

(defvar pgg-gpg-user-id "Yacin Nadji")
(autoload 'pgg-make-temp-file "pgg" "PGG")
(autoload 'pgg-gpg-decrypt-region "pgg-gpg" "PGG GnuPG")
(define-generic-mode 'gpg-file-mode
  (list ?#) 
  nil nil
  '(".asc\\'" ".gpg\\'" ".gpg-encrypted\\'")
  (list (lambda ()
	    (add-hook 'before-save-hook
                      (lambda () 
                        (let ((pgg-output-buffer (current-buffer)))
                          (pgg-gpg-encrypt-region (point-min) (point-max)
                                                  (list pgg-gpg-user-id))))
                      nil t)
	    (add-hook 'after-save-hook 
		      (lambda ()
                        (let ((pgg-output-buffer (current-buffer)))
                          (pgg-gpg-decrypt-region (point-min) (point-max)))
			(set-buffer-modified-p nil)
			(auto-save-mode nil))
		      nil t)
            (let ((pgg-output-buffer (current-buffer)))
              (pgg-gpg-decrypt-region (point-min) (point-max)))
	    (auto-save-mode nil)
	    (set-buffer-modified-p nil)))
  "Mode for gpg encrypted files")
