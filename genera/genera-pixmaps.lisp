;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: GENERA-CLIM; Base: 10; Lowercase: Yes -*-

;; $fiHeader: genera-pixmaps.lisp,v 1.6 92/09/08 15:18:53 cer Exp $

(in-package :genera-clim)

"Copyright (c) 1992 Symbolics, Inc.  All rights reserved."


(defclass genera-pixmap (pixmap) 
    ((pixmap :initarg :pixmap)
     (for-medium :initarg :for-medium)))

(defmethod port-allocate-pixmap ((port genera-port) medium width height)
  (fix-coordinates width height)
  (let ((pixmap (tv:allocate-bitmap-stream :for-stream (medium-drawable medium)
					   :width width :height height
					   :host-allowed t)))
    (make-instance 'genera-pixmap
      :pixmap pixmap
      :for-medium medium)))

(defmethod port-deallocate-pixmap ((port genera-port) (pixmap genera-pixmap))
  (with-slots (pixmap) pixmap
    (tv:deallocate-bitmap-stream pixmap)
    (setq pixmap nil)))

(defmethod pixmap-width ((pixmap genera-pixmap))
  (scl:send (slot-value pixmap 'pixmap) :width))

(defmethod pixmap-height ((pixmap genera-pixmap))
  (scl:send (slot-value pixmap 'pixmap) :height))

(defmethod pixmap-depth ((pixmap genera-pixmap))
  (scl:send (slot-value pixmap 'pixmap) :bits-per-pixel))


(defclass genera-pixmap-medium (genera-medium basic-pixmap-medium) ())

(defmethod medium-drawing-possible ((medium genera-pixmap-medium)) t)

(defmethod make-pixmap-medium ((port genera-port) sheet &key width height)
  (let* ((pixmap (with-sheet-medium (medium sheet)
		   (port-allocate-pixmap port medium width height)))
	 (medium (make-instance 'genera-pixmap-medium
		   :port port
		   :sheet sheet
		   :pixmap pixmap)))
    (setf (slot-value medium 'window) (slot-value pixmap 'pixmap))
    medium))

(defmethod medium-real-screen ((medium genera-pixmap-medium))
  (let* ((pixmap (slot-value medium 'silica::pixmap))
	 (for-medium (slot-value pixmap 'for-medium))
	 (drawable (medium-drawable for-medium)))
    (tv:sheet-screen drawable)))

(defmethod medium-copy-area
	   ((from-medium genera-medium) from-x from-y width height
	    (to-medium genera-medium) to-x to-y)
  (cond ((eq from-medium to-medium)
	 (when (medium-drawing-possible from-medium)
	   (let ((transform (sheet-device-transformation (medium-sheet from-medium))))
	     (convert-to-device-coordinates transform from-x from-y to-x to-y)
	     (convert-to-device-distances transform width height)
	     (when (>= to-x from-x)
	       ;; shifting to the right
	       (setq width (- (abs width))))
	     (when (>= to-y from-y)
	       (setq height (- (abs height))))
	     (let ((window (medium-drawable from-medium)))
	       (scl:send window :bitblt-within-sheet
			 tv:alu-seta width height from-x from-y to-x to-y)))))
	(t
	 (when (and (medium-drawing-possible from-medium)
		    (medium-drawing-possible to-medium))
	   (let* ((from-drawable (medium-drawable from-medium))
		  (to-drawable (medium-drawable to-medium))
		  (from-transform
		    (sheet-device-transformation (medium-sheet from-medium)))
		  (to-transform
		    (sheet-device-transformation (medium-sheet to-medium))))
	     (convert-to-device-coordinates from-transform from-x from-y)
	     (convert-to-device-coordinates to-transform to-x to-y)
	     (convert-to-device-distances from-transform width height)
	     (tv:bitblt-from-sheet-to-sheet
	       tv:alu-seta width height
	       from-drawable from-x from-y
	       to-drawable to-x to-y))))))

(defmethod medium-copy-area 
	   ((from-medium genera-medium) from-x from-y width height
	    (to-medium genera-pixmap-medium) to-x to-y)
  (when (medium-drawing-possible from-medium)
    (let ((transform (sheet-device-transformation (medium-sheet from-medium))))
      (convert-to-device-coordinates transform from-x from-y)
      (convert-to-device-distances transform width height)
      (let ((window (medium-drawable from-medium))
	    (pixmap (medium-drawable to-medium)))
	(tv:bitblt-from-sheet-to-sheet
	  tv:alu-seta width height
	  window from-x from-y
	  pixmap to-x to-y)))))

(defmethod medium-copy-area 
	   ((from-medium genera-pixmap-medium) from-x from-y width height
	    (to-medium genera-medium) to-x to-y)
  (when (medium-drawing-possible to-medium)
    (let ((transform (sheet-device-transformation (medium-sheet to-medium))))
      (convert-to-device-coordinates transform to-x to-y)
      (let ((window (medium-drawable to-medium))
	    (pixmap (medium-drawable from-medium)))
	(tv:bitblt-from-sheet-to-sheet
	  tv:alu-seta width height
	  pixmap from-x from-y
	  window to-x to-y)))))

(defmethod medium-copy-area 
	   ((from-medium genera-medium) from-x from-y width height
	    (pixmap genera-pixmap) to-x to-y)
  (when (medium-drawing-possible from-medium)
    (let ((transform (sheet-device-transformation (medium-sheet from-medium))))
      (convert-to-device-coordinates transform from-x from-y)
      (convert-to-device-distances transform width height)
      (let ((window (medium-drawable from-medium))
	    (pixmap (slot-value pixmap 'pixmap)))
	(tv:bitblt-from-sheet-to-sheet
	  tv:alu-seta width height
	  window from-x from-y
	  pixmap to-x to-y)))))

(defmethod medium-copy-area 
	   ((pixmap genera-pixmap) from-x from-y width height
	    (to-medium genera-medium) to-x to-y)
  (when (medium-drawing-possible to-medium)
    (let ((transform (sheet-device-transformation (medium-sheet to-medium))))
      (convert-to-device-coordinates transform to-x to-y)
      (let ((window (medium-drawable to-medium))
	    (pixmap (slot-value pixmap 'pixmap)))
	(tv:bitblt-from-sheet-to-sheet
	  tv:alu-seta width height
	  pixmap from-x from-y
	  window to-x to-y)))))