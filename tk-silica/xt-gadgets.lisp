;; -*- mode: common-lisp; package: xm-silica -*-
;;
;;				-[Thu Aug 19 15:39:02 1993 by colin]-
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
;; $fiHeader: xt-gadgets.lisp,v 1.39 1993/10/26 03:22:54 colin Exp $

(in-package :xm-silica)

(defclass ask-widget-for-size-mixin () ())

(defmethod compose-space ((pane ask-widget-for-size-mixin) &key width height)
  (multiple-value-bind
      (x y width height borderwidth
       care-x care-y care-width care-height care-borderwidth)
      (tk::widget-best-geometry (sheet-direct-mirror pane) :width
				width :height height)
    (declare (ignore x y borderwidth care-x care-y care-width
		     care-height care-borderwidth)) 
    (make-space-requirement :width width :height height)))


;;; Pane

(defmethod find-widget-class-and-initargs-for-sheet :around
	   ((port xt-port) (parent t)
	    (pane pane))
  ;; Include the name of the pane
  (multiple-value-bind
      (class initargs)
      (call-next-method)
    (let ((name (pane-name pane)))
      (values class
	      (progn
		(when (and name 
			   (not (getf initargs :name)))
		  (setf (getf initargs :name) name))
		initargs)))))

;; Background/foreground/text-style mixin

(defmethod find-widget-class-and-initargs-for-sheet :around
    ((port xt-port) (parent t)
     (sheet sheet-with-resources-mixin))
  (multiple-value-bind (class initargs)
      (call-next-method)
    (let ((other-initargs (find-widget-resource-initargs-for-sheet port sheet)))
      (values class (append initargs other-initargs)))))

(defun ensure-color (c palette)
  (etypecase c
    (color c)
    (string (find-named-color c palette))
    (integer (make-device-color palette c))))

(defmethod find-widget-resource-initargs-for-sheet
    ((port xt-port) (sheet sheet-with-resources-mixin) &key)
  (let ((background (pane-background sheet))
	(foreground (pane-foreground sheet)))
    (with-sheet-medium (medium sheet)
      (let ((palette (medium-palette medium)))
	`(,@(when background
	      (decode-gadget-background medium sheet
					(ensure-color background palette)))
	  ,@(when foreground
	      (decode-gadget-foreground medium sheet 
					(ensure-color foreground palette))))))))

(defmethod find-widget-resource-initargs-for-sheet
    ((port xt-port) (sheet t) &key)
  (let* ((resources (get-application-resources port))
	 (background (or (getf resources :background) *default-pane-background*))
	 (foreground (or (getf resources :foreground) *default-pane-foreground*))
	 (palette (port-default-palette port)))
    `(:background ,(decode-color-in-palette (ensure-color background palette)
					    palette)
      :foreground ,(decode-color-in-palette (ensure-color foreground palette)
					    palette))))
    
(defmethod find-widget-resource-initargs-for-sheet :around
    ((port xt-port) (sheet t) &key foreground background)
  (let ((initargs (call-next-method))
	(palette (port-default-palette port)))
    (when foreground
      (setf (getf initargs :foreground)
	(decode-color-in-palette (ensure-color foreground palette) palette)))
    (when background
      (setf (getf initargs :background)
	(decode-color-in-palette (ensure-color background palette) palette)))
    initargs))

(defmethod decode-gadget-background (medium sheet ink)
  (declare (ignore sheet))
  (let ((pixel (decode-color ink medium)))
    (list :background pixel)))

(defmethod decode-gadget-background (medium sheet (ink pattern))
  (declare (ignore sheet))
  (let ((pixmap (pixmap-from-pattern ink medium :pixmap)))
    (list :background-pixmap pixmap)))

(defmethod decode-gadget-foreground (medium sheet ink)
  (declare (ignore sheet))
  (let ((pixel (decode-color ink medium)))
    (list :foreground pixel)))

(defmethod silica::port-set-pane-foreground ((port xt-port) pane m ink)
  (when (typep m 'xt::xt-root-class)
    (with-sheet-medium (medium pane)
      (apply #'tk::set-values m (decode-gadget-foreground medium pane ink)))))

(defmethod silica::port-set-pane-background ((port xt-port) pane m ink)
  (when (typep m 'xt::xt-root-class)
    (with-sheet-medium (medium pane)
      (apply #'tk::set-values m (decode-gadget-background medium pane ink)))))


(defclass xt-pane (basic-pane) 
	  ;;--- Is this useful a hack enabling things to be passed through
	  ;;--- to the mirror
	  ((silica::mirror-initargs  :initarg :mirror-initargs))
  (:default-initargs :mirror-initargs nil))

(defmethod find-widget-class-and-initargs-for-sheet :around ((port xt-port)
							     (parent t)
							     (sheet xt-pane))
  (multiple-value-bind
      (class initargs)
      (call-next-method)
    (values class (append (slot-value sheet 'silica::mirror-initargs) initargs))))
	    
(defmethod note-gadget-activated :after ((client t) (gadget xt-pane))
  (let (m)
    (when (setq m (sheet-direct-mirror gadget))
      (xt::set-sensitive m t))))

(defmethod note-gadget-deactivated :after ((client t) (gadget xt-pane))
  (let (m)
    (when (setq m (sheet-direct-mirror gadget))
      (xt::set-sensitive m nil))))

;(defclass xt-composite-pane () ())

(defclass xt-leaf-pane (sheet-permanently-enabled-mixin
			client-overridability-mixin
			mirrored-sheet-mixin 
			ask-widget-for-size-mixin
			xt-pane)
	  ())

(defclass xt-top-level-sheet (top-level-sheet) 
	  ((accelerator-gestures :initform nil :reader top-level-sheet-accelerator-gestures)))

;;-- Is this safe?

(defmethod sheet-transformation ((sheet xm-silica::xt-top-level-sheet))
  (let (m)
    (if (setq m (sheet-direct-mirror sheet))
	(multiple-value-bind (x y) (tk::get-values (tk::widget-parent m) :x :y)
	  (make-translation-transformation  x y))
      +identity-transformation+)))

;;; this needs to return region in co-ordinate system of parent.
;;; However CLIM's idea of parent is the graft, while Xt's is the
;;; shell. So we have to use the x and y from the shell to make things
;;; consistent (cim)

(defmethod mirror-region* ((port xt-port) (sheet xt-top-level-sheet))
  (let ((mirror (sheet-mirror sheet)))
    (when mirror
      (multiple-value-bind (x y)
	  (get-values (tk::widget-parent mirror) :x :y)
	(multiple-value-bind (width height)
	    (get-values mirror :width :height)
	  (values (coordinate x) (coordinate y) 
		  (coordinate (+ x width)) (coordinate (+ y height))))))))

(defmethod top-level-sheet-accelerator-gestures ((sheet top-level-sheet)) nil)

(defmethod sheet-disown-child :after ((sheet xt-top-level-sheet) (child basic-sheet))
  (setf (slot-value sheet 'accelerator-gestures) nil))

;;--- This isn't really right.  Genera and CLX ports have kludges
;;--- for the time being, too.
(defmethod sheet-shell (sheet)
  (do ((w (sheet-mirror sheet) (tk::widget-parent w)))
      ((typep w '(or tk::shell null))
       w)))

(defmethod add-sheet-callbacks :after
    ((port xt-port) (sheet xt-top-level-sheet) widget)
  (tk::add-event-handler (tk::widget-parent widget)
			 '(:structure-notify)
			 1
			 'sheet-mirror-event-handler
			 sheet))
			 

;;; scroll bar utilities

(defun convert-scroll-bar-value-out (scroll-bar value)
  (multiple-value-bind 
      (smin smax) (gadget-range* scroll-bar)
    (fix-coordinate
     (compute-symmetric-value
      smin smax value 0 1000))))

(defun convert-scroll-bar-value-in (scroll-bar value)
  (multiple-value-bind 
      (smin smax) (gadget-range* scroll-bar)
    (compute-symmetric-value
     0 1000 value smin smax )))

(defun compute-new-scroll-bar-values (scroll-bar value slider-size line-increment)
  (values 
   (and value
	(convert-scroll-bar-value-out scroll-bar value))
   (and slider-size
	(max 1 (convert-scroll-bar-value-out scroll-bar slider-size)))
   (and line-increment
	(max 1 (convert-scroll-bar-value-out scroll-bar line-increment)))))


(defun wait-for-callback-invocation (port predicate &optional (whostate "Waiting for callback"))
  (if (eq mp:*current-process* (port-process port))
      (progn
	(loop 
	  (when (funcall predicate) (return nil))
	  (process-next-event port)))
    (mp:process-wait whostate predicate)))

(defun set-button-mnemonic (menubar button mnem)
  (when mnem 
    (record-accelerator menubar (list mnem :meta))
    (tk::set-values button :mnemonic mnem)))


(defun record-accelerator (menubar gesture)
  (let ((sheet (frame-top-level-sheet (pane-frame menubar))))
    (push gesture (slot-value sheet 'accelerator-gestures))))

(defmethod distribute-event ((port xt-port) (event keyboard-event))
  (unless (discard-accelerator-event-p port event)
    (call-next-method)))

(defmethod discard-accelerator-event-p ((port xt-port) event)
  (let ((frame (pane-frame (event-sheet event))))
    (and frame
	 (some #'(lambda (gesture)
		   (clim-internals::keyboard-event-matches-gesture-name-p event gesture port))
	       (top-level-sheet-accelerator-gestures (frame-top-level-sheet frame))))))



;; Xt-orriented-gadget

(defclass xt-oriented-gadget () ())

(defmethod find-widget-class-and-initargs-for-sheet :around ((port xt-port)
                                                             (parent t)
                                                             (sheet xt-oriented-gadget))
  (multiple-value-bind
      (class initargs)
      (call-next-method)
    (with-accessors ((orientation gadget-orientation)) sheet
      (unless (getf initargs :orientation)
        (setf (getf initargs :orientation) orientation)))
    (values class initargs)))

(defmethod (setf gadget-orientation) :after (nv (gadget xt-oriented-gadget))
  (when (sheet-direct-mirror gadget)
    (set-widget-orientation gadget nv)))

(defmethod set-widget-orientation ((gadget xt-oriented-gadget) nv)
  (tk::set-values (sheet-direct-mirror gadget) :orientation nv))

(defun normalize-space-for-text-field-or-label (sheet sr)
  (multiple-value-bind (width min-width max-width height min-height max-height)
      (space-requirement-components sr)
    (if (and (numberp width)
	     (numberp min-width)
	     (numberp max-width))
	sr
      (make-space-requirement
       :width (and width (process-width-specification sheet width))
       :min-width (and min-width (process-width-specification sheet min-width))
       :max-width (and max-width (process-width-specification sheet max-width))
       :height height
       :min-height min-height
       :max-height max-height))))


(defun normalize-space-requirement-for-text-editor (sheet sr)
  (multiple-value-bind (width min-width max-width height min-height max-height)
      (space-requirement-components sr)
    (if (and (numberp width)
	     (numberp min-width)
	     (numberp max-width)
	     (numberp height)
	     (numberp min-height)
	     (numberp max-height))
	sr
      (make-space-requirement
       :width (and width (process-width-specification sheet width))
       :min-width (and min-width (process-width-specification sheet min-width))
       :max-width (and max-width (process-width-specification sheet max-width))
       :height (and height (process-height-specification sheet height))
       :min-height (and min-height (process-height-specification sheet min-height))
       :max-height (and max-height (process-height-specification sheet max-height))))))

(defvar *funny-accelerator-characters* 
    '(
      ((#\\ :\\) "backslash")
      ((#\space :\ ) "space")
      ((#\: :\: ) "colon")
      ((#\, :\, ) "comma")
      ))

(defun get-accelerator-text (keystroke &optional olit)
  (let ((key (car keystroke)))
    (let ((x (assoc key *funny-accelerator-characters* 
		    :test #'member)))
      (if x
	  (values (if olit 
		      (format nil "<~A>"  (second x))
		      (format nil "<Key>~A"  (second x)))
		  (format nil "~A" key))
	(values (if olit 
		    (format nil "<~A>" key)
		  (format nil "<Key>~A" key))
		(format nil "~A" key))))))


