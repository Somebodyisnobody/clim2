U;; -*- mode: common-lisp; package: xm-silica -*-
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
;; $fiHeader: xt-graphics.lisp,v 1.13 92/03/24 19:37:15 cer Exp Locker: cer $

(in-package :xm-silica)

(defclass xt-medium (medium)
  ((foreground-gcontext :reader medium-foreground-gcontext :initform nil)
   (background-gcontext :reader medium-background-gcontext :initform nil)
   (flipping-gcontext :reader medium-flipping-gcontext :initform nil)
   (drawable :initform nil)
   (color-p)
   (ink-table :initform (make-hash-table))
   (stipple-gcontext :initform nil)		; These don't belong here.
   (white-pixel :initform 0)
   (black-pixel :initform 1)))

(defmethod medium-drawable ((medium xt-medium))
  (with-slots (drawable sheet) medium
    (or drawable
	(setf drawable (fetch-medium-drawable 
			sheet
			(sheet-mirror sheet))))))

(defmethod deallocate-medium :after (port (medium xt-medium))
  (declare (ignore port))
  (with-slots (drawable) medium
    (setf drawable nil)))

(defmethod fetch-medium-drawable (sheet (mirror tk::xt-root-class))
  (declare (ignore sheet))
  (tk::widget-window mirror nil))

(defmethod engraft-medium :after ((medium xt-medium) (port xt-port) sheet)
   (with-slots (foreground-gcontext background-gcontext flipping-gcontext color-p
		drawable stipple-gcontext white-pixel black-pixel)
      medium
    (setf (medium-sheet medium) sheet)
    (when (and drawable
	       (not (eq (port-display port)
			(tk::object-display drawable))))
      (error "drawable and display do not match"))
    (let* ((display (port-display port))
	   (screen (tk::display-screen-number display))
	   (drawable (or drawable
			 (tk::display-root-window display))))
      (setf foreground-gcontext (tk::make-instance 'tk::gcontext
				    :drawable drawable))
      (setf background-gcontext (tk::make-instance 'tk::gcontext
				    :drawable drawable))
      (setf flipping-gcontext
	(tk::make-instance 'tk::gcontext 
	  :drawable drawable
	  :function boole-xor))
      (setf color-p (color-medium-p medium))
      (setf white-pixel (x11:xwhitepixel display screen))
      (setf black-pixel (x11:xblackpixel display screen))
      (setf stipple-gcontext (make-instance 'tk::gcontext
				 :drawable drawable
				 :foreground black-pixel
				 :background white-pixel))
      (recompute-gcs medium))))

(defmethod degraft-medium :after ((medium xt-medium) (port xt-port) sheet)
  (declare (ignore sheet))
  (with-slots 
       (foreground-gcontext background-gcontext flipping-gcontext stipple-gcontext
	drawable)
      medium
    (setf drawable nil
	  (medium-sheet medium) nil)
    (macrolet ((loose-gc (gc)
		 `(when ,gc
		    (tk::free-gcontext ,gc)
		    (setf ,gc nil))))
      (loose-gc foreground-gcontext)
      (loose-gc background-gcontext)
      (loose-gc flipping-gcontext)
      (loose-gc stipple-gcontext))))

(defparameter *use-color* t)		; For debugging monochrome
(defun color-medium-p (medium)
  (and *use-color*
       (let ((display (port-display (port (medium-sheet medium)))))
	 (> (x11:xdefaultdepth display
			       (tk::display-screen-number display)) 2))))

(defun recompute-gcs (medium)
  (with-slots 
      (foreground-gcontext background-gcontext flipping-gcontext)
      medium
    (when (and foreground-gcontext background-gcontext flipping-gcontext)
      (let ((foreground-pixel
	     (decode-color medium (medium-foreground medium)))
	    (background-pixel
	     (decode-color medium (medium-background medium))))
	(setf (tk::gcontext-foreground foreground-gcontext) foreground-pixel
	      (tk::gcontext-background foreground-gcontext) background-pixel
	      (tk::gcontext-foreground background-gcontext) background-pixel
	      (tk::gcontext-foreground flipping-gcontext)
	      (logxor foreground-pixel background-pixel))))))
      
(defmethod (setf medium-background) :after (ink (medium xt-medium))
  (declare (ignore ink))
  (recompute-gcs medium)
  ;;--- Call handle-repaint
  )

(defmethod (setf medium-foreground) :after (ink (medium xt-medium))
  (declare (ignore ink))
  (recompute-gcs medium)
  ;;--- Call handle-repaint
  )

(defmethod (setf medium-ink) :after (ink (medium xt-medium))
  (declare (ignore ink))
  (recompute-gcs medium))


;;; Colors and their monochrome imposters
;;; Much of this is taken from CLX-IMPLEMENTATION

(defun make-stipple-image (height width patterns)
  (make-instance 'tk::image :width width :height height
		 :data (clim-internals::make-stipple-array height width patterns)
		 :depth 1))

(defvar *luminance-stipples*
	(mapcar #'(lambda (entry)
		    (cons (first entry) (apply #'make-stipple-image (second entry))))
		'((0.1 (8 16 (#b0111111111111111
			      #b1111110111111111
			      #b1111111111110111
			      #b1101111111111111
			      #b1111111101111111
			      #b1111111111111101
			      #b1111011111111111
			      #b1111111111011111)))
		  (0.2 (8 8 (#b01111111
			     #b11101111
			     #b11111101
			     #b10111111
			     #b11110111
			     #b11111110
			     #b11011111
			     #b11111011)))
		  (0.3 (4 4 (#b0111
			     #b1101
			     #b1011
			     #b1110)))
		  (0.4 (3 3 (#b011
			     #b101
			     #b110)))
		  (0.6 (2 2 (#b01
			     #b10)))
		  (0.7 (3 3 (#b100
			     #b010
			     #b001)))
		  (0.8 (4 4 (#b1000
			     #b0010
			     #b0100
			     #b0001)))
		  (0.9 (8 8 (#b10000000
			     #b00010000
			     #b00000010
			     #b01000000
			     #b00001000
			     #b00000001
			     #b00100000
			     #b00000100)))
		  (0.95 (8 16 (#b1000000000000000
			       #b0000001000000000
			       #b0000000000001000
			       #b0010000000000000
			       #b0000000010000000
			       #b0000000000000010
			       #b0000100000000000
			       #b0000000000100000))))))
		
;; The tk::image objects are created at load time to save startup time.
;; Here a '0' means white, '1' black.
(defun decode-luminance (luminance stipple-p)
  (if (not stipple-p)
      (if (< luminance 0.5) 1 0)	; Questionable.  XX
      (if (< luminance 0.05)
	  1
	  (dolist (entry *luminance-stipples* 0)
	    (let ((l (car entry))
		  (stipple (cdr entry)))
	      (when (< luminance l)
		(return-from decode-luminance stipple)))))))

(defgeneric decode-ink (ink medium))

(defmethod decode-ink ((ink (eql +foreground-ink+)) medium)
  (slot-value medium 'foreground-gcontext))

(defmethod decode-ink ((ink (eql +background-ink+)) medium)
  (slot-value medium 'background-gcontext))

(defmethod decode-ink ((ink (eql +flipping-ink+)) stream)
  (slot-value stream 'flipping-gcontext))

(defmethod decode-ink ((ink color) (medium xt-medium))
  (with-slots (ink-table sheet stipple-gcontext white-pixel black-pixel drawable
			 color-p)
      medium
    (let ((drawable (or drawable
			(tk::display-root-window (port-display (port sheet)))))
	  (ink-table (slot-value medium 'ink-table)))
      (or (gethash ink ink-table)
	  (let ((new-gc (make-instance 'tk::gcontext :drawable drawable)))
	    (cond (color-p
		   (setf (tk::gcontext-foreground new-gc)
		     (decode-color medium ink)))
		  (t
		   (multiple-value-bind (r g b) (color-rgb ink)
		   ;; The luminance formula isn't really right.  XXX
		   (let* ((luminance (color-luminosity r g b))
			  (color (decode-luminance luminance t)))
		     (cond ((eq color 1)
			    (setf (tk::gcontext-fill-style new-gc) :solid
				  (tk::gcontext-foreground new-gc) black-pixel))
			   ((eq color 0)
			    (setf (tk::gcontext-fill-style new-gc) :solid
				  (tk::gcontext-foreground new-gc) white-pixel))
			   (t			; color is an image
			    (setf (tk::gcontext-fill-style new-gc) :tiled)
			    (let ((pixmap (make-instance 'tk::pixmap
					    :drawable drawable
					    :width (tk::image-width color)
					    :height (tk::image-height color)
					    :depth (tk::drawable-depth drawable))))
			      (tk::put-image pixmap stipple-gcontext color)
			      (setf (tk::gcontext-tile new-gc) pixmap))))))))
	    (setf (gethash ink ink-table) new-gc))))))

(defmethod decode-ink ((ink contrasting-ink) stream)
  (decode-ink (make-color-for-contrasting-ink ink) stream))

(defmethod decode-ink ((ink rectangular-tile) medium)
  (multiple-value-bind (pattern width height)
      (decode-rectangular-tile ink)
    (xt-decode-pattern pattern medium width height t)))

(defmethod decode-ink ((ink pattern) medium)
  (xt-decode-pattern ink medium))
    
(defmethod decode-color ((medium xt-medium) (x (eql +foreground-ink+)))
  (with-slots (foreground-gcontext) medium
    (tk::gcontext-foreground foreground-gcontext)))

(defmethod decode-color ((medium xt-medium) (x (eql +background-ink+)))
  (with-slots (background-gcontext) medium
    (tk::gcontext-foreground background-gcontext)))

(defmethod decode-color ((stream xt-medium) (ink standard-opacity))
  (if (> (slot-value ink 'clim-utils::value) 0.5)
      (decode-color stream +foreground-ink+)
      (decode-color stream +background-ink+)))

(defmethod decode-color ((medium xt-medium) (ink color))
  (with-slots (color-p white-pixel black-pixel) medium
    (or (gethash ink (port-color-cache (port medium)))
	(setf (gethash ink (port-color-cache (port medium)))
	  (cond (color-p
		 (multiple-value-bind (red green blue)
		     (color-rgb ink)
		   (tk::allocate-color
		     (tk::default-colormap (port-display (port (medium-sheet medium))))
		     (make-instance 'tk::color
				    :red (truncate (* 65356 red))
				    :green (truncate (* 65356 green))
				    :blue (truncate (* 65356 blue))))))
		(t
		 (multiple-value-bind (r g b) (color-rgb ink)
		   ;; The luminance formula isn't really right.  XXX
		   (let* ((luminance (/ (+ (* r r) (* g g) (* b b)) 3)))
		     (if (> luminance .5)
			 white-pixel
			 black-pixel)))))))))


(defmethod adjust-ink ((medium xt-medium) gc ink line-style x-origin y-origin)
  (declare (ignore ink))
  (let* ((dashes (line-style-dashes line-style))
	 (gc-line-style
	  (etypecase dashes
	    ((member nil t) :solid)
	    (sequence :dash))))
	
    (tk::set-line-attributes 
     gc
     (let ((thickness (line-style-thickness line-style)))
       (when (< thickness 2)
	 (setq thickness 0))
       (round thickness))
     gc-line-style
     (ecase (line-style-cap-shape line-style)
       (:butt :butt)
       (:square :projecting)
       (:round :round)
       (:no-end-point :not-last))
     (ecase (line-style-joint-shape line-style)
       ((:miter :none) :miter)
       (:bevel :bevel)
       (:round :round)))
    
    (when (eq gc-line-style :dash)
      (setf (tk::gcontext-dashes gc) dashes))
    
    (let* ((sheet (medium-sheet medium))
	   (dr (sheet-device-region sheet))
	   (mcr (medium-clipping-region medium)))
      (unless (eq mcr +everywhere+)
	(setq mcr (transform-region (sheet-device-transformation sheet) mcr))
	(setq dr (region-intersection dr (bounding-rectangle mcr))))
      (cond ((or #+ignore t (eq dr +everywhere+))
	     (setf (tk::gcontext-clip-mask gc) 
	       :none))
	    ((eq dr +nowhere+)
	     (setf (tk::gcontext-clip-mask gc) 
	       :nowhere))
	    (t
	     (with-bounding-rectangle*
		 (a b c d) dr
		 (with-stack-list (x 
				   (integerize-coordinate a) 
				   (integerize-coordinate b) 
				   (integerize-coordinate (- c a)) 
				   (integerize-coordinate (- d b)))
		   (setf (tk::gcontext-clip-mask gc) x))))))
    
    (when (eq (tk::gcontext-fill-style gc) :tiled)
      (setf (tk::gcontext-ts-x-origin gc) x-origin
	    (tk::gcontext-ts-y-origin gc) y-origin))
    gc))

(defmethod decode-ink :around ((ink t) (medium xt-medium))
  (let ((gc (call-next-method)))
    gc))

(defmethod xt-decode-pattern ((pattern pattern) medium &optional width height tiled-p)    
  (let* ((ink-table (slot-value medium 'ink-table))
	 (drawable (or (slot-value medium 'drawable)
		       (tk::display-root-window
			(port-display (port (medium-sheet medium))))))
	 (depth (tk::drawable-depth drawable)))
    (or (gethash pattern ink-table)
	(setf (gethash pattern ink-table)
	      (multiple-value-bind (array designs)
		  (decode-pattern pattern)
		(let ((image-data (make-array (array-dimensions array)))
		      (design-pixels (make-array (length designs))))
		  (declare (simple-vector design-pixels))
		  ;; Cache the decoded designs from the pattern
		  (do* ((num-designs (length designs))
			(n 0 (1+ n))
			design)
		       ((eq n num-designs))
		    (setq design (elt designs n))
		    (setf (svref design-pixels n) (decode-color medium design)))
		  (dotimes (w (array-dimension array 1))
		    (dotimes (h (array-dimension array 0))
		      (setf (aref image-data h w)
			    (svref design-pixels (aref array h w)))))
		  (let* ((pattern-height (array-dimension array 0))
			 (pattern-width (array-dimension array 1))
			 (image (make-instance 'tk::image
					       :width pattern-width
					       :height pattern-height
					       :data image-data
					       :depth depth))
			 (gc 
			   (make-instance 'tk::gcontext :drawable drawable))
			 (pixmap 
			   (make-instance 'tk::pixmap
					  :drawable drawable
					  :width pattern-width
					  :height pattern-height
					  :depth depth)))
		    (tk::put-image pixmap gc image)
		    (setf (tk::gcontext-tile gc) pixmap
			  (tk::gcontext-fill-style gc) :tiled)
		    gc)))))))


(defmethod port-draw-point* ((port xt-port) sheet medium x y)
  (let ((transform (sheet-device-transformation sheet)))
    (convert-to-device-coordinates transform x y))
  (when (medium-drawable medium)
    (let ((thickness (line-style-thickness (medium-line-style medium))))
      (if (< thickness 2)
	  (tk::draw-point
	   (medium-drawable medium)
	   (adjust-ink medium
		       (decode-ink (medium-ink medium) medium)
		       (medium-ink medium)
		       (medium-line-style medium)
		       x y)
	   x y)
	(let ((thickness (round thickness)))
	  (tk::draw-ellipse (medium-drawable medium) 
			    (adjust-ink medium
					(decode-ink (medium-ink medium) medium)
					(medium-ink medium)
					(medium-line-style medium)
					(- x thickness)
					(- y thickness))
			    x y 
			    0
			    thickness 
			    0
			    thickness 0 2pi
			    t))))))

(defmethod port-draw-line* ((port xt-port) sheet medium
			    x1 y1 x2 y2)
  (let ((transform (sheet-device-transformation sheet)))
    (convert-to-device-coordinates transform
      x1 y1 x2 y2))
  (when (medium-drawable medium)
    (tk::draw-line
      (medium-drawable medium)
      (adjust-ink medium
		  (decode-ink (medium-ink medium) medium)
		  (medium-ink medium)
		  (medium-line-style medium)
		  (min x1 x2) (min y1 y2))
      x1 y1 x2 y2)))

(defmethod port-draw-rectangle* ((port xt-port) sheet medium
				 x1 y1 x2 y2 filled)
  (let ((transform (sheet-device-transformation sheet)))
    (if (rectilinear-transformation-p transform)
	(progn
	  (convert-to-device-coordinates transform
	    x1 y1 x2 y2) 
	  (when (medium-drawable medium)
	    (tk::draw-rectangle
	      (medium-drawable medium)
	      (adjust-ink medium
			  (decode-ink (medium-ink medium) medium)
			  (medium-ink medium)
			  (medium-line-style medium)
			  (min x1 x2) (min y1 y2))
	      (min x1 x2) (min y1 y2)
	      (abs (- x2 x1)) (abs (- y2 y1))
	      filled)))
      (port-draw-transformed-rectangle*
	port sheet medium x1 y1 x2 y2 filled))))

(ff::def-c-type (xpoint-array :in-foreign-space) 2 x11::xpoint)
  
(defmethod port-draw-polygon* ((port xt-port) sheet medium
			       list-of-x-and-ys
			       closed filled)
  (let* ((transform (sheet-device-transformation sheet))
	 (npoints (/ (length list-of-x-and-ys) 2))
	 (points (excl::malloc ;; BUG BUG BUG
		  (* 4 (cond ((and closed (not filled))
			      (incf npoints))
			     (t npoints)))))
	 (window (medium-drawable medium))
	 ;;--- is this right
	 (minx most-positive-fixnum)
	 (miny most-positive-fixnum))
    (do ((ps list-of-x-and-ys (cddr ps))
	 (i 0 (1+ i))
	 r)
	((null ps)
	 (setq list-of-x-and-ys (nreverse r)))
      (let ((x (first ps))
	    (y (second ps)))
	(convert-to-device-coordinates transform x y)
	(minf minx x)
	(minf miny y)
	(setf (xpoint-array-x points i) x
	      (xpoint-array-y points i) y)))
    (when (and closed (not filled))
      (setf (xpoint-array-x points (- npoints 1)) (xpoint-array-x points 0)
	    (xpoint-array-y points (- npoints 1)) (xpoint-array-y points 0)))
    (when (medium-drawable medium)
      (if filled
	  (x11:xfillpolygon
	   (tk::object-display window)
	   window
	   (adjust-ink medium
					      (decode-ink (medium-ink medium) medium)
					      (medium-ink medium)
					      (medium-line-style medium)
					      minx miny)
	   points
	   npoints
	   x11:complex
	   x11:coordmodeorigin)
	(x11:xdrawlines
	  (tk::object-display window)
	  window
	  (adjust-ink medium
					 (decode-ink (medium-ink medium) medium)
					 (medium-ink medium)
					 (medium-line-style medium)
					 minx miny)
	  points
	  npoints
	  x11:coordmodeorigin)))))

(defmethod port-draw-ellipse* ((port xt-port) sheet medium
			       center-x center-y
			       radius-1-dx radius-1-dy radius-2-dx radius-2-dy 
			       start-angle end-angle filled)
  (let ((transform (sheet-device-transformation sheet)))
    (convert-to-device-coordinates transform center-x center-y)
    (convert-to-device-distances transform 
      radius-1-dx radius-1-dy radius-2-dx radius-2-dy)
    (when (medium-drawable medium)
      (tk::draw-ellipse
	(medium-drawable medium)
	(adjust-ink medium
		    (decode-ink (medium-ink medium) medium)
		    (medium-ink medium)
		    (medium-line-style medium)
		    (- center-x 
		       (if (zerop radius-1-dx) radius-2-dx radius-1-dx))
		    (- center-y 
		       (if (zerop radius-1-dy) radius-2-dy radius-1-dy)))
	center-x center-y
	radius-1-dx radius-1-dy radius-2-dx radius-2-dy 
	start-angle end-angle 
	filled)))) 

(defmethod port-draw-text* ((port xt-port) sheet medium
			    string-or-char x y start end
			    align-x align-y
			    ;; towards-point towards-x towards-y
			    ;; transform-glyphs
			    )
  (let ((transform (sheet-device-transformation sheet))
	(font (text-style-mapping port (medium-text-style medium))))
    (convert-to-device-coordinates transform x y)
    (when (typep string-or-char 'character)
      (setq string-or-char (string string-or-char)))
    (ecase align-x
      (:center 
	(decf x (floor (text-size sheet string-or-char
				  :text-style (medium-text-style medium)
				  :start start :end end) 2)))
      (:left nil))
    (ecase align-y
      (:center 
	(decf y (- (text-style-descent (medium-text-style medium) port)
		   (floor (text-style-height (medium-text-style medium) port) 2))))
      (:baseline nil)
      (:top
	(incf y (tk::font-ascent font)))) 
    (when (medium-drawable medium)
      (let ((gc (decode-ink (medium-ink medium) medium)))
	(setf (tk::gcontext-font gc) font)
	(tk::draw-string
	  (medium-drawable medium)
	  gc
	  x y
	  string-or-char start end)))))

;;--- Is this used any more?
(defmethod port-write-string-1 ((port xt-port) medium
				glyph-buffer start end 
				x-font color x y)
  (unless (= start end)
    (let* ((sheet (medium-sheet medium))
	   (transform (sheet-device-transformation sheet))
	   (window (medium-drawable medium))
	   (font x-font))
      ;; At one point we checked to see whether the widget is unrealized
      ;; or not.  Can we draw on disabled sheets?
      (convert-to-device-coordinates transform x y)
      (incf y (tk::font-ascent font))
      (when (medium-drawable medium)
	(let ((gc (decode-ink (medium-ink medium) medium)))
	  (setf (tk::gcontext-font gc) font)
	  (etypecase glyph-buffer
	    ((simple-array (unsigned-byte 16))
	     (x11::xdrawstring16
	       (tk::object-display window)
	       window
	       gc
	       x y
	       glyph-buffer (- end start)))))))))


(defmethod port-beep ((port xt-port) (sheet t))
  (x11:xbell (port-display port) 100))

   

;;--- FROM-SHEET and TO-SHEET should be mediums, not sheets
;;--- This needs to be able to copy to/from pixmaps, too
;;--- arglist s/b FROM-MEDIUM FROM-X FROM-Y TO-MEDIUM TO-X TO-Y WIDTH HEIGHT
(defmethod port-copy-area ((port xt-port)
			   from-sheet to-sheet
			   from-left from-top from-right from-bottom
			   to-left to-top)
  ;; coords in "host" coordinate system
  (let ((transform (sheet-native-transformation from-sheet)))
    (convert-to-device-coordinates transform
       from-left from-top from-right from-bottom to-left to-top)
    (with-sheet-medium (from-medium from-sheet)
      (with-sheet-medium (to-medium to-sheet)
	(let* ((from-drawable (medium-drawable from-medium))
	       (to-drawable (medium-drawable to-medium))
	       (width (- from-right from-left))
	       (height (- from-bottom from-top))
	       (copy-gc (port-copy-gc port)))
	  (when (and from-drawable to-drawable)
	    (tk::copy-area from-drawable copy-gc from-left from-top width height
			   to-drawable to-left to-top)))))))