;; -*- mode: common-lisp; package: tk -*-
;;
;;				-[]-
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
;; $fiHeader: xm-font-list.lisp,v 1.5 92/03/09 17:41:05 cer Exp $

(in-package :tk)

(defforeign 'xm_font_list_init_font_context
    :entry-point "_XmFontListInitFontContext")

(defforeign 'xm_font_list_free_font_context
    :entry-point "_XmFontListFreeFontContext")


(defforeign 'xm_font_list_get_next_font
    :entry-point "_XmFontListGetNextFont")

(defforeign 'xm_font_list_create
    :entry-point "_XmFontListCreate")



(defmethod convert-resource-out (parent (type (eql 'font-list)) value)
  (declare (ignore parent))
  (when (atom value)
    (setq value (list value)))
  (let* ((charset xm_string_default_char_set)
	 (font-list
	  (xm_font_list_create 
	   (car value)
	   charset)))
    (dolist (font (cdr value))
      (setq font-list
	(xm_font_list_add font-list 
			  font
			  charset)))
    font-list))

(defmethod convert-resource-in (class (type (eql 'font-list)) value)
  (import-font-list value))

(defun import-font-list (font-list)
  (let ((context
	 (with-ref-par ((context 0))
	   (assert (not (zerop (xm_font_list_init_font_context context font-list))))
	   (aref context 0)))
	(res nil))
    (with-ref-par
	((char-set 0)
	 (font 0))
      (loop
	(when (zerop 
	       (xm_font_list_get_next_font
		context
		char-set
		font))
	  (return nil))
	(push (list (let ((x (aref char-set 0)))
		      (prog1
			  (ff:char*-to-string x)
		      (xt_free x)))
		    (let ((x (aref font 0)))
		      (intern-object-address
		       x
		       'font
		       :name :unknown!)))
	      res))
      (xm_font_list_free_font_context context)
      res)))
	
