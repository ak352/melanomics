
;;; ---------- Settings of Emacs Package System -------------
;; For Package Management by ELPA
(when (>= emacs-major-version 24)
    (require 'package)
    (package-initialize)
    ;; Any add to list for package-archives (to add marmalade or melpa) goes here
    (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
    (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
    (add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
    (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
    (require 'vlf-setup)
    (require 'google)
    (google-this-mode 1)
    
    (autoload 'python-mode "python-mode" "Python Mode." t)
    (add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
    (add-to-list 'auto-mode-alist '("\\.tex\\'" . latex-mode))
    (add-to-list 'interpreter-mode-alist '("python" . python-mode))
    
    (require 'ess-site)


    
)


;; autoload configuration
;; (Not required if you have installed Wanderlust as XEmacs package)
(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;; Directory where icons are placed.
;; Default: the peculiar value to the running version of Emacs.
;; (Not required if the default value points properly)
;; (setq wl-icon-directory "~/work/wl/etc")

;; SMTP server for mail posting. Default: 'nil'
(setq wl-smtp-posting-server "smtp-3.uni.lu")
;; NNTP server for news posting. Default: 'nil'
;; (setq wl-nntp-posting-server "your.nntp.example.com")


(global-set-key (kbd "<f5>") 'comment-region)
(global-set-key (kbd "<f6>") 'uncomment-region)
(global-set-key (kbd "<f7>") 'compile)

(require 'compile)
 (add-hook 'sh-mode-hook
           (lambda ()
	          (unless (file-exists-p "Makefile")
		           (set (make-local-variable 'compile-command)
                    ;; emulate make's .c.o implicit pattern rule, but with
                    ;; different defaults for the CC, CPPFLAGS, and CFLAGS
                    ;; variables:
                    ;; $(CC) -c -o $@ $(CPPFLAGS) $(CFLAGS) $<
				    (let ((file (file-name-nondirectory buffer-file-name)))
                      (format "./%s" file))))))


(require 'compile)
 (add-hook 'python-mode-hook
           (lambda ()
	          (unless (file-exists-p "Makefile")
		           (set (make-local-variable 'compile-command)
                    ;; rum 'python file.py'
				    (let ((file (file-name-nondirectory buffer-file-name)))
                      (format "python %s" file))))))


(require 'compile)
 (add-hook 'latex-mode-hook
           (lambda ()
	          (unless (file-exists-p "Makefile")
		           (set (make-local-variable 'compile-command)
                    ;; rum 'pdflatex file.tex'
				    (let ((file (file-name-nondirectory buffer-file-name)))
                      (format "pdflatex %s" file))))))

