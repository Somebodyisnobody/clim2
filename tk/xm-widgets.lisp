;; -*- mode: common-lisp; package: tk -*-
;;
;;				-[Thu Jul 22 17:17:19 1993 by colin]-
;; 
;; copyright (c) 1985, 1986 Franz Inc, Alameda, CA  All rights reserved.
;; copyright (c) 1986-1991 Franz Inc, Berkeley, CA  All rights reserved.
;;
;; The software, data and information contained herein are proprietary
;; to, and comprise valuable trade secrets of, Franz, Inc.  They are
;; given in confidence by Franz, Inc. pursuant to a written license
;; agreement, and may be stored and used only in accordance with the terms
;; of such license.
;;
;; Restricted Rights Legend
;; ------------------------
;; Use, duplication, and disclosure of the software, data and information
;; contained herein by any agency, department or entity of the U.S.
;; Government are subject to restrictions of Restricted Rights for
;; Commercial Software developed at private expense as specified in FAR
;; 52.227-19 or DOD FAR Supplement 252.227-7013 (c) (1) (ii), as
;; applicable.
;;
;; $fiHeader: xm-widgets.lisp,v 1.17 1993/10/26 03:22:35 colin Exp $

(in-package :tk)

(defmethod make-widget ((w xm-gadget) name parent &rest args &key (managed t)
			&allow-other-keys)
  (remf args :managed)
  (let ((class (class-of w)))
    (if managed
	(apply #'create-managed-widget name class parent args)
      (apply #'create-widget name class parent args))))

(defmethod make-widget ((w xm-dialog-shell) name parent &rest args)
  (apply #'create-popup-shell name (class-of w) parent args))

#+ignore
(defmethod make-widget ((w override-shell) name parent &rest args)
  (apply #'create-popup-shell name (class-of w) parent args))

(defmethod make-widget ((w xm-menu-shell) name parent &rest args)
  (apply #'create-popup-shell name (class-of w) parent args))

(tk::add-resource-to-class (find-class 'vendor-shell)
			   (make-instance 'resource
					  :name :delete-response
					  :type 'tk::delete-response
					  :original-name 
					  (string-to-char*
					   "deleteResponse")))

(tk::add-resource-to-class (find-class 'xm-text)
			   (make-instance 'resource
					  :name :font-list
					  :type 'font-list
					  :original-name 
					  (string-to-char*
					   "fontList")))

(tk::add-resource-to-class (find-class 'vendor-shell)
			   (make-instance 'resource
					  :name :keyboard-focus-policy
					  :type 'tk::keyboard-focus-policy
					  :original-name 
					  (string-to-char*
					   "keyboardFocusPolicy")))


(tk::add-resource-to-class (find-class 'xm-cascade-button-gadget)
			   (make-instance 'resource
					  :name :label-type
					  :type 'tk::label-type
					  :original-name 
					  (string-to-char*
					   "labelType")))


;; Moved here as to be after loading xm-funs.

;;-- This is a problem cos we dont know the number of items

(defconstant xm_string_default_char_set "")

(defmethod convert-resource-in ((parent t) (type (eql 'xm-string)) value)
  (and (not (zerop value))
       (with-ref-par ((string 0))
	 ;;--- I think we need to read the book about
	 ;;--- xm_string_get_l_to_r and make sure it works with multiple
	 ;;-- segment strings
	 (xm_string_get_l_to_r value xm_string_default_char_set string)
	 (char*-to-string (aref string 0)))))

(defmethod convert-resource-in ((parent t) (type (eql 'xm-string-table)) value)
  value)

(defun convert-xm-string-table-in (parent table n)
  (let ((r nil))
    (dotimes (i n (nreverse r))
      (push (convert-resource-in parent 'xm-string (x-arglist table i))
	    r))))

(defmethod convert-resource-out ((parent t) (type (eql 'xm-string)) value)
  (note-malloced-object
   (xm_string_create_l_to_r 
    (note-malloced-object (string-to-char* value))
    (note-malloced-object (string-to-char* "")))))

(defmethod convert-resource-out ((parent t) (type (eql 'xm-background-pixmap)) value)
  (etypecase value
    (pixmap
     (encode-pixmap nil value))))

(defun encode-box-child (child)
  (let ((x (getf '(
                   :none                  0 
                   :apply         1
                   :cancel    2
                   :default   3
                   :ok        4
                   :filter-label     5
                   :filter-text      6
                   :help      7
                   :list                  8
                   :history-list     :list
                   :list-label    9
                   :message-label    10
                   :selection-label  11
                   :prompt-label     :selection-label
                   :symbol-label     12
                   :text                  13
                   :value-text       :text
                   :command-text     :text
                   :separator             14
                   :dir-list         15
                   :dir-list-label   16
                   :file-list        :list
                   :file-list-label  :list-label
                   ) 
                 child)))
    (cond ((null x)
           (error "cannot encode child ~S" child))
          ((symbolp x)
           (encode-box-child x))
          (t x))))

(defmethod convert-resource-out ((parent t) (type (eql 'default-button-type)) value)
  (encode-box-child value))


(tk::add-resource-to-class (find-class 'xm-text)
			   (make-instance 'resource
					  :name :scroll-horizontal
					  :type 'tk::boolean
					  :original-name 
					  (string-to-char*
					   "scrollHorizontal")))

(tk::add-resource-to-class (find-class 'xm-text)
			   (make-instance 'resource
					  :name :scroll-vertical
					  :type 'tk::boolean
					  :original-name 
					  (string-to-char*
					   "scrollVertical")))

(tk::add-resource-to-class (find-class 'xm-text)
			   (make-instance 'resource
					  :name :word-wrap
					  :type 'tk::boolean
					  :original-name 
					  (string-to-char*
					   "wordWrap")))

(defmethod convert-resource-out ((parent t) (type (eql 'xm-string-table)) value)
  (if value
      (do* ((n (length value))
	    (r (note-malloced-object
		(make-xm-string-table :number n :in-foreign-space t)))
	    (v value (cdr v))
	    (i 0 (1+ i)))
	  ((null v)
	   r)
	(setf (xm-string-table r i)
	  (convert-resource-out parent 'xm-string (car v))))
    0))

(defmethod convert-pixmap-out (parent (value string))
  (let* ((display (widget-display parent))
	 (screen (x11:xdefaultscreenofdisplay display))
	 (white (x11::xwhitepixel display 0))
	 (black (x11::xblackpixel display 0)))
    (xm_get_pixmap screen value white black)))
