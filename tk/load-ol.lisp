;; -*- mode: common-lisp; package: user -*-
;;
;; copyright (c) 1985, 1986 Franz Inc, Alameda, CA  All rights reserved.
;; copyright (c) 1986-1993 Franz Inc, Berkeley, CA  All rights reserved.
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
;; $fiHeader: load-ol.lisp,v 1.25 1993/11/23 19:58:58 cer Exp $

(in-package :user)

(require :climg)

#+svr4
(unless (ff:get-entry-point (ff:convert-to-lang "ol_appl_add_item")
			    :note-shared-library-references nil)
  (defun reinitialize-toolkit ()
    (ol-initialize)
    (xt_toolkit_initialize)
    (setup-error-handlers)
    (install-ol-error-handlers)
    (fixup-class-entry-points))
  (push '(:eval reinitialize-toolkit) excl::*restart-actions*)
  (load "climol.so"))

#-svr4
(progn
  (defvar sys::*libxt-pathname* "Xt")
  (defvar sys::*clim-olit-pathname* "clim-olit.o")

  (x11::load-undefined-symbols-from-library
   sys::*clim-olit-pathname*
   (x11::symbols-from-file "misc/undefinedsymbols.olit")
   (list sys::*libxt-pathname* sys::*libx11-pathname*))

  (unless (ff:get-entry-point (ff:convert-to-lang "ol_appl_add_item"))
    (load "olsupport.o"
	  :system-libraries (list sys::*libxt-pathname*
				  sys::*libx11-pathname*)
	  :print t))

  (unless (ff:get-entry-point (ff:convert-to-lang "XtAppIntervalNextTimer"))
    (load "xtsupport.o"
	  :system-libraries (list sys::*libxt-pathname*
				  sys::*libx11-pathname*)
	  :print t)))

(pushnew :clim-openlook *features*)
