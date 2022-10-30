;;; sixcolors-mode.el --- A horizontal colored scrollbar

;; *heavily based* on
;; nyan-mode.el by Jacek "TeMPOraL" Zlydach <temporal.pl@gmail.com>
;; 
;; ... I mean, this is basically Jacek's code with small modifications

;;; Commentary:
;; Author: Davide Mastromatteo <mastro35@gmail.com>
;; URL: https://github.com/mastro35/sixcolors-mode
;; Keywords: convenience, colors
;; Version: 1.0
;; Package-Requires: ((Emacs "27.1"))

;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Code:

(defconst sixcolors-directory (file-name-directory
                               (or load-file-name buffer-file-name)))
(defconst sixcolors-size 3)
(defconst sixcolors-rainbow-image (concat sixcolors-directory
                                          "img/rainbow.xpm"))
(defconst sixcolors-outerspace-image (concat sixcolors-directory
                                             "img/outerspace.xpm"))
(defconst sixcolors-modeline-help-string "nmouse-1: Scroll buffer position")

(defvar sixcolors-old-car-mode-line-position nil)

(defgroup sixcolors nil
  "Customization group for `sixcolors-mode'."
  :group 'frames)

(defun sixcolors-refresh ()
  "Refresh sixcolors mode.
Intended to be called when customizations were changed, to
reapply them immediately."
  (when (featurep 'sixcolors-mode)
    (when (and (boundp 'sixcolors-mode)
               sixcolors-mode)
      (sixcolors-mode -1)
      (sixcolors-mode 1))))

(defcustom sixcolors-minimum-window-width 64
  "Minimum width of the window, below which the bar will not be displayed.
This is important because `sixcolors-mode' will push out all
informations from small windows."
  :type 'integer
  :set (lambda (sym val)
         (set-default sym val)
         (sixcolors-refresh))
  :group 'sixcolors)

(defcustom sixcolors-bar-length 35
  "Length of sixcolors bar in units.
Each unit is equal to an 8px image.
Minimum of 3 units are required for `sixcolors-mode'."
  :type 'integer
  :set (lambda (sym val)
         (set-default sym val)
         (sixcolors-refresh))
  :group 'sixcolors)

;;; Load the rainbow.

(defvar sixcolors-current-frame 0)

(defun sixcolors-scroll-buffer (percentage buffer)
  "Move point `BUFFER' to `PERCENTAGE' percent in the buffer."
  (interactive)
  (with-current-buffer buffer
    (goto-char (floor (* percentage (point-max))))))

(defun sixcolors-add-scroll-handler (string percentage buffer)
  "Propertize `STRING' to scroll `BUFFER' to `PERCENTAGE' on click."
  (let ((percentage percentage)
        (buffer buffer))
    (propertize string
                'keymap
                `(keymap (mode-line
                          keymap
                          (down-mouse-1 . ,(lambda ()
                                             (interactive)
                                             (sixcolors-scroll-buffer
                                              percentage
                                              buffer))))))))

(defun sixcolors-number-of-rainbows ()
  "Number of rainbows to print on screen based on the point position."
  (+ 1 (round (/ (* (round (* 100
                              (/ (- (float (point))
                                    (float (point-min)))
                                 (float (point-max)))))
                    sixcolors-bar-length)
                 100))))


(defun sixcolors-create ()
  "Main function that create the bar."
  (if (< (window-width) sixcolors-minimum-window-width)
      ""                                ; disabled for too small windows
    (let* ((rainbows (sixcolors-number-of-rainbows))
           (outerspaces (- sixcolors-bar-length rainbows -2))
           (rainbow-string "")
           (xpm-support (image-type-available-p 'xpm))
           (outerspace-string "")
           (buffer (current-buffer)))
      (dotimes (number rainbows)
        (setq rainbow-string
              (concat rainbow-string
                      (sixcolors-add-scroll-handler
                       (if xpm-support
                           (propertize
                            "|"
                            'display
                            (create-image
                             sixcolors-rainbow-image 'xpm nil :ascent
                             'center))
                         "|")
                       (/ (float number) sixcolors-bar-length) buffer))))
      (dotimes (number outerspaces)
        (setq outerspace-string
              (concat outerspace-string
                      (sixcolors-add-scroll-handler
                       (if xpm-support
                           (propertize
                            "-"
                            'display
                            (create-image
                             sixcolors-outerspace-image 'xpm nil :ascent
                             'center))
                         "-")
                       (/ (float (+ rainbows sixcolors-size number))
                          sixcolors-bar-length) buffer))))
      (propertize (concat rainbow-string
                          ;;  sixcolors-string
                          outerspace-string)
                  'help-echo sixcolors-modeline-help-string))))


;;;###autoload
(define-minor-mode sixcolors-mode
  "Use sixcolors bar to show buffer size and position in mode-line.

Note: If you turn this mode on then you probably want to turn off
option `scroll-bar-mode'."

  :global t
  :group 'sixcolors
  (cond (sixcolors-mode
         (unless sixcolors-old-car-mode-line-position
           (setq sixcolors-old-car-mode-line-position (car mode-line-position)))
         (setcar mode-line-position '(:eval (list (sixcolors-create)))))
        ((not sixcolors-mode)
         (setcar mode-line-position sixcolors-old-car-mode-line-position)
         (setq sixcolors-old-car-mode-line-position nil))))


(provide 'sixcolors-mode)


(provide 'sixcolors-mode)

;;; sixcolors-mode.el ends here
