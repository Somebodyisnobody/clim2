;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: SILICA; Base: 10; Lowercase: Yes -*-

;; 
;; copyright (c) 1985, 1986 Franz Inc, Alameda, Ca.  All rights reserved.
;; copyright (c) 1986-1991 Franz Inc, Berkeley, Ca.  All rights reserved.
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
;; $fiHeader: std-sheet.lisp,v 1.6 92/07/01 15:45:17 cer Exp $

(in-package :silica)


;;--- This should probably be flushed
(defclass standard-sheet 
	  (permanent-medium-sheet-output-mixin
	   mirrored-sheet-mixin
	   sheet-multiple-child-mixin
	   sheet-transformation-mixin
	   standard-repainting-mixin
	   standard-sheet-input-mixin
	   sheet)
    ())


;;--- This should probably be flushed
(defclass simple-sheet
	  (sheet-multiple-child-mixin 
	   sheet-transformation-mixin
	   standard-repainting-mixin
	   standard-sheet-input-mixin
	   temporary-medium-sheet-output-mixin
	   sheet)
    ())


(defmethod handle-event (sheet event)
  (declare (ignore sheet event))
  #+++ignore (warn "Ignoring event ~S on sheet ~S" sheet event)
  nil)
