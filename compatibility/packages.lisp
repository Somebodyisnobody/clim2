;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: CLIM-INTERNALS; Base: 10; Lowercase: Yes -*-

;; $fiHeader: packages.lisp,v 1.2 92/09/08 15:19:35 cer Exp Locker: cer $

(in-package :clim-internals)

"Copyright (c) 1992 Symbolics, Inc.  All rights reserved."


(eval-when (compile load eval)
(defvar *clim-1-symbols*
	'(*abort-characters*
	  *activation-characters*
	  *blip-characters*
	  *completion-characters*
	  *help-characters*
	  *possibilities-characters*
	  *standard-activation-characters*
	  *unsupplied-argument*
	  +background+
	  +dialog-view+
	  +foreground+
	  +menu-view+
	  activation-character-p
	  add-output-record-element
	  add-pointer-gesture-name
	  add-text-style-mapping
	  blip-character-p
	  bounding-rectangle-position*
	  call-presentation-generic-function
	  command-enabled-p
	  compose-rotation-transformation
	  compose-scaling-transformation
	  compose-translation-transformation
	  cursor-position*
	  cursor-set-position*
	  delete-output-record-element
	  dialog-view
	  disable-command
	  dragging-output-record
	  draw-character
	  draw-character*
	  draw-icon
	  draw-icon*
	  draw-string
	  draw-string*
	  enable-command
	  frame-top-level-window
	  input-position
	  insertion-pointer
	  make-color-ihs
	  make-color-rgb
	  map-over-output-record-elements
	  map-over-output-record-elements-containing-point*
	  map-over-output-record-elements-overlapping-region
	  menu-view
	  open-root-window
	  open-window-stream
	  output-record-element-count
	  output-record-elements
	  output-record-end-position*
	  output-record-position*
	  output-record-refined-sensitivity-test
	  output-record-set-position*
	  output-record-set-end-position*
	  output-record-set-start-position*
	  output-record-start-position
	  output-record-start-position*
	  output-recording-stream-current-output-record-stack
	  output-recording-stream-output-record
	  output-recording-stream-replay
	  point-position*
	  pointer-set-position*
	  pointer-event-shift-mask
	  pointer-position*
	  position-window-near-carefully
	  position-window-near-pointer
	  region-contains-point*-p 
	  redisplay-1
	  replay-1
	  remove-pointer-gesture-name
	  rescanning-p
	  set-frame-layout
	  size-menu-appropriately
	  stream-cursor-position*
	  stream-set-cursor-position*
	  stream-draw-p
	  stream-increment-cursor-position*
	  stream-pointer-position*
	  stream-set-pointer-position*
	  stream-record-p
	  stream-vsp
	  transform-point*
	  untransform-point*
	  window-viewport-position*
	  window-set-viewport-position*
	  with-activation-characters
	  with-blip-characters
	  with-frame-state-variables)))

#+Genera
(defmacro with-package-unlocked ((package) &body body)
  `(si:with-package-lock ,package nil
     ,@body))

#-Genera 
(defmacro with-package-unlocked ((package) &body body)
  (declare (ignore package))
  `(progn ,@body))

;; Import the above symbols into the CLIM package, then export them
(eval-when (compile load eval)
  (let ((clim (find-package :clim)))
    (dolist (symbol *clim-1-symbols*)
      (import symbol clim)
      (export symbol clim))))