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
;; $fiHeader: event.lisp,v 1.17 92/07/08 16:29:05 cer Exp $

(in-package :silica)


(defgeneric process-next-event (port &key wait-function timeout))

(defgeneric distribute-event (port event))
(defgeneric dispatch-event (client event))
(defgeneric handle-event (client event))

(defgeneric port-keyboard-input-focus (port))

(defmethod handle-event (sheet (event window-repaint-event))
  (handle-repaint sheet nil (window-event-region event))
  (deallocate-event event))

(defclass sheet-with-event-queue-mixin ()
    ((event-queue :initform nil
		  :initarg :event-queue
		  :accessor sheet-event-queue)))

(defmethod note-sheet-grafted :after ((sheet sheet-with-event-queue-mixin))
  (unless (sheet-event-queue sheet)
    (setf (sheet-event-queue sheet)
	  (or (do ((sheet (sheet-parent sheet) (sheet-parent sheet)))
		  ((null sheet))
		(when (and (typep sheet 'sheet-with-event-queue-mixin)
			   (sheet-event-queue sheet))
		  (return (sheet-event-queue sheet))))
	      (make-queue)))))

(defgeneric queue-event (client event))
(defmethod queue-event ((sheet sheet-with-event-queue-mixin) event)
  (queue-put (sheet-event-queue sheet) event))

(defgeneric event-read (client))
(defmethod event-read ((sheet sheet-with-event-queue-mixin))
  (let ((queue (sheet-event-queue sheet)))
    (loop
      (process-wait "Event" #'(lambda ()
				(not (queue-empty-p queue))))
      (let ((event (queue-get queue)))
	(when event (return event))))))


(defgeneric event-read-no-hang (client))
(defmethod event-read-no-hang ((sheet sheet-with-event-queue-mixin))
  (queue-get (sheet-event-queue sheet) nil))

(defgeneric event-peek (client &optional event-type))
(defmethod event-peek ((sheet sheet-with-event-queue-mixin) &optional event-type)
  (loop
    (let ((event (event-read sheet)))
      (when (or (null event-type)
		(typep event event-type))
	(event-unread sheet event)
	(return-from event-peek event)))))

;; Is there a lock here?

(defgeneric event-unread (sheet event))
(defmethod event-unread ((sheet sheet-with-event-queue-mixin) event)
  (queue-unget (sheet-event-queue sheet) event))

(defgeneric event-listen (client))
(defmethod event-listen ((sheet sheet-with-event-queue-mixin))
  (not (queue-empty-p (sheet-event-queue sheet))))



;;; Standard 

(defclass standard-sheet-input-mixin (sheet-with-event-queue-mixin) ())

(defmethod dispatch-event ((sheet standard-sheet-input-mixin) event)
  (queue-event sheet event))

(defmethod dispatch-event ((sheet standard-sheet-input-mixin)
			   (event window-configuration-event))
  (handle-event sheet event))


;;; Immediate

(defclass immediate-sheet-input-mixin () ())

(defmethod dispatch-event ((sheet immediate-sheet-input-mixin) event)
  (handle-event sheet event))


;;; Delegate

(defclass delegate-sheet-input-mixin ()
    ((delegate :accessor delegate-sheet-delegate)))

(defmethod dispatch-event ((sheet delegate-sheet-input-mixin) event)
  (dispatch-event (delegate-sheet-delegate sheet) event))

(defclass sheet-mute-input-mixin () ())

(defmethod queue-event ((sheet sheet-mute-input-mixin) (event event))
  nil)


;;; Repaint protocol

(defgeneric dispatch-repaint (sheet region))

(defgeneric queue-repaint (sheet region))
(defmethod queue-repaint (sheet region)
  (queue-event sheet region))

(defgeneric handle-repaint (sheet medium region))
(defmethod handle-repaint ((sheet sheet) medium region)
  (when (null region)				;--- kludge
    (setq region +everywhere+))
  (with-sheet-medium-bound (sheet medium)
    (repaint-sheet sheet region))
  (when (typep sheet 'sheet-parent-mixin)
    (flet ((do-handle-repaint (child)
	     (unless (sheet-direct-mirror child)
	       (handle-repaint
		 child medium
		 (untransform-region (sheet-transformation child) region)))))
      (declare (dynamic-extent #'do-handle-repaint))
      (map-over-sheets-overlapping-region #'do-handle-repaint sheet region))))
	     
(defgeneric repaint-sheet (sheet region))


(defclass standard-repainting-mixin () ())

(defmethod dispatch-repaint ((sheet standard-repainting-mixin) region)
  (queue-repaint sheet region))

(defclass immediate-repainting-mixin () ())

(defmethod dispatch-repaint ((sheet immediate-repainting-mixin) region)
  (handle-repaint sheet region))

(defclass mute-repainting-mixin () ())

(defmethod dispatch-repaint ((sheet mute-repainting-mixin) region)
  (queue-repaint sheet region))

(defmethod repaint-sheet ((sheet mute-repainting-mixin) region)
  (declare (ignore region))
  nil)


;;; Crossing events

;; The following variable controls whether an exit event gets generated
;; when the pointer leaves a sheet to enter one of its children.  Consider
;; the following diagram:
;;
;;   +--------------------------------+
;;   |                                |<--- outer sheet 1
;;   |                                |
;;   |  +--------------------------+  |
;;   |  |                          |<------ middle sheet 2
;;   |  |                          |  |
;;   |  |  +--------------------+  |  |
;;   |  |  |                    |<--------- inner sheet 3
;;   |  |  |                    |  |  |
;;   |  |  |                    |  |  |
;;   |  |  +--------------------+  |  |
;;   |  |                          |  |
;;   |  |                          |  |
;;   |  +--------------------------+  |
;;   |                                |
;;   |                                |
;;   +--------------------------------+
;; 
;; Suppose you move the pointer from the left-hand side of the screen into
;; sheet 1, then into sheet 2, and finally into sheet 3.  When the following
;; variable is set to T, this event stream is generated:
;;
;;   pointer enters sheet 1
;;   pointer exits sheet 1
;;   pointer enters sheet 2
;;   pointer exits sheet 2
;;   pointer enters sheet 3
;; 
;; When it is set to NIL, this is generated:
;; 
;;   pointer enters sheet 1
;;   pointer enters sheet 2
;;   pointer enters sheet 3
;; 
;; Both schemes have their uses, so we support both.
(defparameter *generate-exit-event-when-entering-child* nil)


;; I think we have fun here to generate enter/exit events for unmirrored sheets
;; Three cases:
;; 1. Mouse motion event:
;;    [Last mirrored sheet, position] --> [new mirrored sheet, position]
;; 2. Enter: [last-mirrored sheet, position] -> [new sheet]
;; 3. Exit: [last-mirrored sheet, position] -> [new sheet]
;;
;; We boil this down to mouse moved to [new mirrored sheet, position]
;;  We have a current stack of sheets 0...n
;;  Find m such that 0...m - 1 contain mouse
;;  m...n require exit events
;; We can then go deep down inside m sheet generating enter events
;;
;; Who do we generate motion events for?
;; The 0th element of the trace is the mirrored sheet.
;;
;; Cases:
;; 1. It is the mirrored sheet.
;; 2. Ancestor: We have gone deeper.  Perhaps it still counts as exiting.
;;    We should just exit from the innermost sheet that encloses the new mirror.
;;    We should enter/exit intermediate ancestors.
;;    Ancestor-x,y,z-->Sheet
;; 3. Child: We have gone shallower.  Exit from all of the sheets.
;;    We should probably exit from intermediate descendents.
;;    Sheet- x,y,z --> Child
;; 4. Share a common ancestor: exit from all of the sheets.
;;--- This code does not deal with cases (2) and (3) correctly.
;;--- It will fail to generate enter/exit events for cases
(defun generate-crossing-events (port sheet x y modifiers button pointer)
  (macrolet ((generate-enter-event (sheet)
	       `(let ((sheet ,sheet))
		  (dispatch-event
		    sheet
		    (allocate-event 'pointer-enter-event
		      :sheet sheet
		      :x x :y y
		      :button button
		      :modifier-state modifiers
		      :pointer pointer))))
	     (generate-exit-event (sheet)
	       `(let ((sheet ,sheet))
		  (dispatch-event
		    sheet
		    (allocate-event 'pointer-exit-event
		      :sheet sheet
		      :x x :y y
		      :button button
		      :modifier-state modifiers
		      :pointer pointer)))))
    (let ((v (port-trace-thing port)))
      #+Genera (declare (sys:array-register v))
      ;; Pop up the stack of sheets
      (unless (zerop (fill-pointer v))
	(let ((m (if (eq (aref v 0) sheet)
		     (let ((new-x x)
			   (new-y y))
		       (dotimes (i (fill-pointer v) (fill-pointer v))
			 (unless (zerop i)
			   (multiple-value-setq (new-x new-y)
			     (map-sheet-position-to-child (aref v i) new-x new-y)))
			 (unless (region-contains-position-p 
				   (sheet-region (aref v i)) new-x new-y)
			   (return i))))
		     0)))
	  (do ((i (1- (fill-pointer v)) (1- i)))
	      ((< i m))
	    (generate-exit-event (aref v i))
	    (unless (zerop i)
	      (generate-enter-event (aref v (1- i)))))
	  (setf (fill-pointer v) m)))
      ;; If its empty initialize it
      (when (region-contains-position-p (sheet-region sheet) x y)
	(when (zerop (fill-pointer v))
	  (vector-push-extend sheet v)
	  (generate-enter-event sheet))
	;; We have to get the sheets into the correct coordinate space
	(loop for i from (1+ (position sheet v)) below (fill-pointer v)
	    do (multiple-value-setq (x y)
		 (map-sheet-position-to-child (aref v i) x y)))
	;; Add children
	(let ((new-x x)
	      (new-y y)
	      (sheet (aref v (1- (fill-pointer v))))
	      child)
	  (loop
	    (unless (typep sheet 'sheet-parent-mixin) 
	      (return nil))
	    (setq child (child-containing-position sheet new-x new-y))
	    (unless child
	      (return nil))
	    (when *generate-exit-event-when-entering-child*
	      (generate-exit-event sheet))
	    (generate-enter-event child)
	    (multiple-value-setq (new-x new-y)
	      (map-sheet-position-to-child child new-x new-y))
	    (setq sheet child)
	    (vector-push-extend child v)))))))

(defun distribute-pointer-event (port mirrored-sheet event-type x y modifiers button pointer)
  ;; Generate all the correct enter/exit events
  (generate-crossing-events port mirrored-sheet x y modifiers button pointer)
  ;; dispatch event to the innermost sheet
  (let ((sheet (let ((v (port-trace-thing port)))
		 (and (not (zerop (fill-pointer v)))
		      (aref v (1- (fill-pointer v)))))))
    (when (and sheet (port sheet))
      (multiple-value-bind (tx ty)
	  (untransform-position
	    (sheet-device-transformation sheet) x y)
	(dispatch-event
	  sheet
	  (allocate-event event-type
	    :sheet sheet
	    :native-x x :native-y y
	    :x tx :y ty
	    :modifier-state modifiers
	    :button button
	    :pointer pointer))))))


;;; Event distribution

(defmethod distribute-event ((port basic-port) event)
  (distribute-event-1 port event))

(defmethod distribute-event ((port null) (event event))
  #+++ignore (warn "Trying to distribute event ~S for a null port" event))

(defgeneric distribute-event-1 (port event))

(defmethod distribute-event-1 ((port basic-port) (event event))
  (dispatch-event (event-sheet event) event))

(defmethod distribute-event-1 ((port basic-port) (event keyboard-event))
  (let ((focus (or (port-keyboard-input-focus port)
		   (event-sheet event))))
    ;;--- Is this correct???
    (setf (slot-value event 'sheet) focus)
    (dispatch-event focus event)))

(defmethod distribute-event-1 ((port basic-port) (event window-event))
  (dispatch-event 
    (window-event-mirrored-sheet event)
    event))

(defmethod distribute-event-1 ((port basic-port) (event pointer-event))
  (distribute-pointer-event
    port
    (event-sheet event)
    (typecase event
      ((or pointer-exit-event pointer-enter-event)
       'pointer-motion-event)
      (t (class-name (class-of event))))
    (pointer-event-native-x event)
    (pointer-event-native-y event)
    (event-modifier-state event)
    (pointer-event-button event)
    (pointer-event-pointer event))
  (deallocate-event event))
	    

;;; Local event processing

(defun process-event-locally (sheet event)
  (declare (ignore sheet))
  (handle-event (event-sheet event) event))

(defun local-event-loop (sheet)
  (loop 
    (process-event-locally sheet (event-read sheet))))

(defun port-event-wait (port waiter 
			&key (wait-reason #+Genera si:*whostate-awaiting-user-input*
					  #-Genera "CLIM Input")
			     timeout)
  (declare (ignore port))
  (process-wait-with-timeout wait-reason timeout waiter) 
  (values))


;;; Event resources

(defvar *resourced-events* nil)

(defgeneric initialize-event (event &key &allow-other-keys))

(defmacro define-event-resource (event-class nevents)
  (let* ((slots #-CCL-2 (clos:class-slots (find-class event-class))
		#+CCL-2 (ccl:class-slots (find-class event-class)))
	 (slot-names #-CCL-2 (mapcar #'clos:slot-definition-name slots)
		     #+CCL-2 (mapcar #'ccl:slot-definition-name slots))
	 (resource-name (fintern "*~A-~A*" event-class 'resource)))
    `(progn
       (defvar ,resource-name nil)
       (defmethod initialize-event ((event ,event-class) &key ,@slot-names)
	 ,@(mapcar #'(lambda (slot)
		       (if (eq slot 'timestamp)
			   `(setf (slot-value event ',slot) 
				  (or ,slot (atomic-incf *event-timestamp*)))
			   `(setf (slot-value event ',slot) ,slot)))
		   slot-names))
       (let ((old (assoc ',event-class *resourced-events*)))
	 (unless old
	   (setq *resourced-events* 
		 (append *resourced-events*
			 (list (list ',event-class ',resource-name 
				     ;; Allocates, misses, creates, deallocates
				     #+meter-events ,@(list 0 0 0 0)))))))
       ;; When an event is in the event resource, we use the timestamp
       ;; to point to the next free event
       (let ((previous-event (make-instance ',event-class)))
	 (setq ,resource-name previous-event)
	 (repeat ,(1- nevents)
	   (let ((event (make-instance ',event-class
			  :timestamp nil)))
	     (setf (slot-value previous-event 'timestamp) event)
	     (setq previous-event event)))))))

(define-event-resource pointer-motion-event 20)
(define-event-resource pointer-enter-event 20)
(define-event-resource pointer-exit-event 20)
(define-event-resource pointer-button-press-event 10)
(define-event-resource pointer-button-release-event 10)
(define-event-resource key-press-event 10)
(define-event-resource key-release-event 10)
(define-event-resource window-configuration-event 10)
(define-event-resource window-repaint-event 10)

(defparameter *use-event-resources* nil)

;; Note that this assumes that the initarg for a slot has the same
;; symbol name as the slot itself
#+Genera (zwei:defindentation (allocate-event 1 1))
(defun allocate-event (event-class &rest initargs)
  (declare (dynamic-extent initargs))
  (let* ((entry (assoc event-class *resourced-events*))
	 (resource (second entry))
	 event)
    ;; Update the freelist, or allocate a new event if necessary
    #+meter-events (when resource (incf (nth 2 entry)))
    (cond ((and *use-event-resources* resource)
	   (without-scheduling
	     (setq event (symbol-value resource))
	     (when event
	       (setf (symbol-value resource) (event-timestamp event))))
	   ;; INITIALIZE-EVENT is slower than an optimized MAKE-INSTANCE
	   ;; when no slots have to be initialized, but usually we have
	   ;; to fill in most of the slots, in which case it is about the
	   ;; same speed.
	   (cond (event
		  (apply #'initialize-event event initargs)
		  event)
		 (t
		  #+meter-events (incf (nth 3 entry))
		  (apply #'make-instance event-class initargs))))
	  (t
	   #+meter-events (when resource (incf (nth 4 entry)))
	   (apply #'make-instance event-class initargs)))))

(defun deallocate-event (event)
  (when *use-event-resources*
    (unless (typep (event-timestamp event) 'fixnum)
      (cerror "Proceed anyway"
	      "The event ~S has already been deallocated" event)
      (return-from deallocate-event nil))
    (let* ((entry (assoc (class-name (class-of event)) *resourced-events*))
	   (resource (second entry)))
      (when resource
	(without-scheduling
	  (setf (slot-value event 'timestamp) (symbol-value resource))
	  (setf (symbol-value resource) event))
	#+meter-events (incf (nth 5 entry)))))
  nil)

#+meter-events
(defun describe-event-resources (&optional reset)
  (format t "~&Name~32TAlloc    Miss     New   Freed")
  (dolist (entry *resourced-events*)
    (destructuring-bind (name first allocates misses new deallocates) entry
      (declare (ignore first))
      (format t "~&~A~30T~7D ~7D ~7D ~7D" name allocates misses new deallocates)
      (when reset
	(setf (nth 2 entry) 0
	      (nth 3 entry) 0
	      (nth 4 entry) 0
	      (nth 5 entry) 0)))))

;; It's generally better to copy the event when passing it up to the API
;; level, because that ensures that our event resource remains relatively
;; localized in virtual memory.
#+Symbolics
(defun-inline copy-event (event)
  (clos-internals::%allocate-instance-copy event))

#+CCL-2
(defun copy-event (event)
  (without-scheduling
    (ccl::copy-uvector
      (ccl::%maybe-forwarded-instance event))))

#-(or Symbolics CCL-2)
(defun copy-event (event)
  (let* ((class (class-of event))
	 (copy (allocate-instance class)))
    (dolist (slot (clos:class-slots class))
      (let ((name (clos:slot-definition-name slot))
	    (allocation (clos:slot-definition-allocation slot)))
	(when (and (eql allocation :instance)
		   (slot-boundp event name))
	  (setf (slot-value copy name) (slot-value event name)))))
    copy))
