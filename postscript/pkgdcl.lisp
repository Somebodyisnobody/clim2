;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: CL-USER; Base: 10; Lowercase: Yes -*-

;; $Id: pkgdcl.lisp,v 1.11 2000/05/01 21:43:30 layer Exp $

(in-package #-ansi-90 :user #+ansi-90 :common-lisp-user)

"Copyright (c) 1992 Symbolics, Inc.  All rights reserved."

(#-ansi-90 clim-lisp::defpackage #+ansi-90 defpackage postscript-clim
  (:use clim-lisp clim-sys clim clim-utils clim-silica)

  (:shadowing-import-from clim-utils
    defun
    flet labels
    defgeneric defmethod
    dynamic-extent
    #-(or allegro Lucid) non-dynamic-extent)

  #+(and allegro (not (version>= 4 1)))
  (:shadowing-import-from clim-utils
    with-slots))

#+allegro
(setf (package-lock (find-package :postscript-clim)) t)
