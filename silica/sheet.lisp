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
;; $fiHeader: sheet.lisp,v 1.21 92/07/08 16:29:23 cer Exp $

(in-package :silica)


(defgeneric sheet-parent (sheet))
(defgeneric sheet-children (sheet))
(defgeneric sheet-child (sheet))
(defgeneric sheet-enabled-children (sheet))
(defgeneric sheet-siblings (sheet))
(defgeneric sheet-ancestor-p (sheet putative-ancestor))

(defgeneric sheet-adopt-child (sheet child))
(defgeneric sheet-disown-child (sheet child))

(defgeneric raise-sheet (sheet))
(defgeneric bury-sheet (sheet))
(defgeneric reorder-sheets (sheet new-ordering))

(defgeneric sheet-enabled-p (sheet))
(defgeneric (setf sheet-enabled-p) (enabled-p sheet))
(defgeneric sheet-viewable-p (sheet))
(defgeneric occluding-sheets (sheet child))

(defmethod bounding-rectangle* ((sheet sheet))
  (bounding-rectangle* (sheet-region sheet)))

(defmethod sheet-child ((sheet sheet))
  (let ((children (sheet-children sheet)))
    (unless (and children (null (cdr children)))
      (error "The sheet ~S has more than one child" sheet))
    (car children)))


;;; Genealogy

(defclass sheet-leaf-mixin () ())

(defclass sheet-parent-mixin () ())

(defclass sheet-single-child-mixin (sheet-parent-mixin)
    ((children :initform nil :accessor sheet-children)))

(defun map-over-sheets (function sheet)
  (declare (dynamic-extent function))
  (funcall function sheet)
  (when (typep sheet 'sheet-parent-mixin)
    (dolist (child (sheet-children sheet))
      (map-over-sheets function child))))

(defmethod sheet-adopt-child :before ((sheet sheet) (child sheet))
  (when (sheet-parent child)
    (error "Sheet ~S trying to adopt child ~S that already has a parent" sheet child)))

(defmethod sheet-adopt-child ((sheet sheet-single-child-mixin) child)
  (when (sheet-children sheet)
    (error "Single-child sheet ~S already has a child" sheet))
  (setf (sheet-children sheet) (list child)
	(sheet-parent child) sheet))

(defmethod sheet-child ((sheet sheet-single-child-mixin))
  (car (sheet-children sheet)))

(defmethod sheet-adopt-child :after ((sheet sheet) child)
  (note-sheet-adopted child)
  (when (port sheet)
    (setf (port child :graft (graft sheet)) (port sheet))))



(defclass sheet-multiple-child-mixin (sheet-parent-mixin)
    ((children :initform nil :accessor sheet-children)))

(defmethod sheet-adopt-child ((sheet sheet-multiple-child-mixin) child)
  (setf (sheet-children sheet) 
	;; Preserve the order in which the sheets were adopted
	;;--- This may have unwanted effects if the children overlap...
	(append (sheet-children sheet) (list child)))
  (setf (sheet-parent child) sheet))

(defmethod (setf port) ((port null) sheet &key graft)
  (declare (ignore graft))
  (note-sheet-degrafted sheet)
  (setf (slot-value sheet 'port) port)
  (when (typep sheet 'sheet-parent-mixin)
    (dolist (child (sheet-children sheet))
      (setf (port child) port))))

(defmethod (setf port) ((port basic-port) sheet &key graft)
  (setf (slot-value sheet 'port)  port
	(slot-value sheet 'graft) graft)
  (note-sheet-grafted sheet)
  (when (typep sheet 'sheet-parent-mixin)
    (dolist (child (sheet-children sheet))
      (setf (port child :graft graft) port)))
  (note-sheet-tree-grafted port sheet))

(defmethod note-sheet-tree-grafted ((port port) (sheet sheet))
  ;; This method is invoked when the sheet and its descendents have
  ;; been mirrored
  nil)

(defmethod sheet-disown-child ((parent sheet-multiple-child-mixin) child)
  (unless (eq (sheet-parent child) parent)
    (error "~S is not child of ~S" child parent))
  (note-sheet-disowned child)
  (when (port parent)
    (setf (port child) nil))
  (setf (sheet-parent child) nil)
  (setf (sheet-children parent)
	(delete child (sheet-children parent))))

(defmethod sheet-disown-child ((parent sheet-single-child-mixin) child)
  (unless (eq (sheet-parent child) parent)
    (error "~S is not child of ~S" child parent))
  (note-sheet-disowned child)
  (when (port parent)
    (setf (port child) nil))
  (setf (sheet-parent child) nil
	(sheet-children parent) nil))


;;; Geometry

(defgeneric map-sheet-position-to-parent (sheet x y))
(defmethod map-sheet-position-to-parent ((sheet sheet) x y)
  (transform-position (sheet-transformation sheet) x y))

(defgeneric map-sheet-position-to-child (sheet x y))
(defmethod map-sheet-position-to-child ((sheet sheet) x y)
  (untransform-position (sheet-transformation sheet) x y))

(defgeneric map-sheet-rectangle*-to-parent (sheet min-x min-y max-x max-y))
(defmethod map-sheet-rectangle*-to-parent ((sheet sheet) min-x min-y max-x max-y)
  (transform-rectangle*
    (sheet-transformation sheet)
    min-x min-y max-x max-y))

(defgeneric map-sheet-rectangle*-to-child (sheet min-x min-y max-x max-y))
(defmethod map-sheet-rectangle*-to-child ((sheet sheet) min-x min-y max-x max-y)
  (untransform-rectangle*
    (sheet-transformation sheet)
    min-x min-y max-x max-y))

(defgeneric child-containing-position (sheet x y))
(defmethod child-containing-position ((sheet sheet) x y)
  (find-if #'(lambda (child)
	       (and (sheet-enabled-p child)
		    (multiple-value-bind (x y)
			(untransform-position (sheet-transformation child) x y)
		      (region-contains-position-p (sheet-region child) x y))))
	   (sheet-children sheet)))

(defgeneric children-overlapping-region (sheet region))
(defmethod children-overlapping-region ((sheet sheet) region)
  (if (or (null region)				;--- kludge
	  (eq region +everywhere+))
      (remove-if-not #'sheet-enabled-p (sheet-children sheet))
      (with-bounding-rectangle* (left top right bottom) region
	(remove-if-not
	  #'(lambda (child)
	      (and (sheet-enabled-p child)
		   (multiple-value-call #'ltrb-overlaps-ltrb-p
		     (bounding-rectangle* child)
		     (untransform-rectangle* 
		       (sheet-transformation child) left top right bottom))))
	  (sheet-children sheet)))))

(defgeneric map-over-sheets-containing-position (function sheet x y)
  (declare (dynamic-extent function)))
(defmethod map-over-sheets-containing-position (function (sheet sheet) x y)
  (declare (dynamic-extent function))
  (dolist (child (sheet-children sheet))
    (when (and (sheet-enabled-p child)
	       (multiple-value-bind (x y)
		   (untransform-position (sheet-transformation child) x y)
		 (region-contains-position-p (sheet-region child) x y)))
      (funcall function child))))

(defgeneric map-over-sheets-overlapping-region (function sheet region)
  (declare (dynamic-extent function)))
(defmethod map-over-sheets-overlapping-region (function (sheet sheet) region)
  (declare (dynamic-extent function))
  (if (or (null region)				;--- kludge
	  (eq region +everywhere+))
      (dolist (child (sheet-children sheet))
	(when (sheet-enabled-p child)
	  (funcall function child)))
      (with-bounding-rectangle* (left top right bottom) region
	(dolist (child (sheet-children sheet))
	  (when (and (sheet-enabled-p child)
		     (multiple-value-call #'ltrb-overlaps-ltrb-p
		       (bounding-rectangle* child)
		       (untransform-rectangle* 
			 (sheet-transformation child) left top right bottom)))
	    (funcall function child))))))

(defgeneric children-overlapping-rectangle* (sheet min-x min-y max-x max-y))

(defgeneric delta-transformation (sheet ancestor))
(defmethod delta-transformation ((sheet sheet) ancestor)
  (let ((parent (sheet-parent sheet)))
    (cond
      ((eq parent ancestor)
       (sheet-transformation sheet))
      ((null parent) 
       (error "in delta transformation: ~S,~S"
	      sheet parent))
      (t
       (compose-transformations 
	 (sheet-transformation sheet)
	 (delta-transformation parent ancestor))))))

(defgeneric allocated-region (sheet child))

;;;; 

(defclass sheet-identity-transformation-mixin () ())

(defmethod sheet-transformation ((sheet sheet-identity-transformation-mixin))
  +identity-transformation+)

(defclass sheet-transformation-mixin ()
    ((transformation 
       :initarg :transformation :initform +identity-transformation+
       :accessor sheet-transformation)
     (cached-device-transformation :initform nil
				   :accessor sheet-cached-device-transformation)
     ;; This next is here for lack of a better place, and because the accessor
     ;; sheet-device-region can only work on a sheet that is of this class.
     (cached-device-region :initform nil
			   :accessor sheet-cached-device-region)))

(defclass sheet-translation-mixin (sheet-transformation-mixin) ())

(defclass sheet-y-inverting-transformation-mixin (sheet-transformation-mixin) ())


;;; Notification

(defgeneric note-sheet-adopted (sheet))
(defmethod note-sheet-adopted ((sheet sheet)) nil)

(defgeneric note-sheet-disowned (sheet))
(defmethod note-sheet-disowned ((sheet sheet)) nil)

(defgeneric note-sheet-grafted (sheet))
(defmethod note-sheet-grafted ((sheet sheet)) nil)

(defgeneric note-sheet-degrafted (sheet))
(defmethod note-sheet-degrafted ((sheet sheet)) nil)

(defgeneric note-sheet-enabled (sheet))
(defmethod note-sheet-enabled ((sheet sheet)) nil)

(defgeneric note-sheet-disabled (sheet))
(defmethod note-sheet-disabled ((sheet sheet)) nil)

(defgeneric sheet-engrafted-p (sheet))
(defmethod sheet-engrafted-p ((sheet sheet))
  (let ((parent (sheet-parent sheet)))
    (or (graftp parent)
	(sheet-engrafted-p parent))))

(defmethod (setf sheet-region) :after (region (sheet sheet))
  (declare (ignore region))
  (note-sheet-region-changed sheet))

(defgeneric note-sheet-region-changed (sheet &key port-did-it))
(defmethod note-sheet-region-changed ((sheet sheet) &key port-did-it)
  (declare (ignore port-did-it))
  nil)

(defmethod (setf sheet-transformation) :after (transformation (sheet sheet))
  (declare (ignore transformation))
  (note-sheet-transformation-changed sheet))

(defgeneric note-sheet-transformation-changed (sheet &key port-did-it))
(defmethod note-sheet-transformation-changed ((sheet sheet) &key port-did-it)
  (declare (ignore port-did-it)) 
  nil)

(defgeneric invalidate-cached-regions (sheet))

(defmethod invalidate-cached-regions ((sheet sheet)) nil)

(defmethod invalidate-cached-regions ((sheet sheet-transformation-mixin)) 
  (let ((region (sheet-cached-device-region sheet)))
    (when region
      (if (eq region +nowhere+)			;it can happen...
	  (setf (sheet-cached-device-region sheet) nil)
	  (setf (slot-value (sheet-cached-device-region sheet) 'left) nil)))))

(defmethod invalidate-cached-regions :after ((sheet sheet-parent-mixin))
  ;;--- In theory if this sheet has a mirror we don't need to do any more
  (unless (sheet-direct-mirror sheet)
    (mapc #'invalidate-cached-regions (sheet-children sheet))))

(defmethod note-sheet-region-changed :before ((sheet sheet) &key port-did-it)
  (declare (ignore port-did-it))
  (invalidate-cached-regions sheet))

(defgeneric invalidate-cached-transformations (sheet))

(defmethod invalidate-cached-transformations ((sheet sheet)) nil)

(defmethod invalidate-cached-transformations ((sheet sheet-transformation-mixin)) 
  (let ((region (sheet-cached-device-region sheet)))
    (when region
      (if (eq region +nowhere+)			;it can happen...
	  (setf (sheet-cached-device-region sheet) nil)
	  (setf (slot-value (sheet-cached-device-region sheet) 'left) nil))))
  (setf (sheet-cached-device-transformation sheet) nil))

(defmethod invalidate-cached-transformations :after ((sheet sheet-parent-mixin))
  ;;--- In theory if this sheet has a mirror we don't need to do any more
  (unless (sheet-direct-mirror sheet)
    (mapc #'invalidate-cached-transformations (sheet-children sheet))))
 
;;--- Check to see if the call to invalidate-cached-regions is really necessary.
;;--- CER thinks we do because regions depend on transformations.
(defmethod note-sheet-transformation-changed :before ((sheet sheet) &key port-did-it)
  (declare (ignore port-did-it))
  (invalidate-cached-transformations sheet)
  (invalidate-cached-regions sheet))

(defgeneric update-native-transformation (port sheet))

(defmethod (setf sheet-enabled-p) :after (enabled (sheet sheet))
  (if enabled
      (note-sheet-enabled sheet)
      (note-sheet-disabled sheet)))

(defmethod sheet-enabled-children ((sheet sheet-parent-mixin))
  (remove-if-not #'sheet-enabled-p (sheet-children sheet)))


;;; Making sheets

(defmethod initialize-instance :after ((sheet sheet) &key parent children)
  (when parent
    (sheet-adopt-child parent sheet))
  (dolist (child children)
    (sheet-adopt-child sheet child)))


;;; Output

(defclass standard-sheet-output-mixin () ())

(defclass primitive-sheet-output-mixin () ())

(defclass mute-sheet-output-mixin () ())

(defclass sheet-with-medium-mixin (standard-sheet-output-mixin)
    ((medium :initform nil :accessor sheet-medium)
     (medium-type :initarg :medium :initform t :accessor sheet-medium-type)))

(defmethod invalidate-cached-regions :before ((sheet sheet-with-medium-mixin))
  (let ((medium (sheet-medium sheet)))
    (when medium 
      (invalidate-cached-regions medium))))

(defmethod invalidate-cached-transformations :before ((sheet sheet-with-medium-mixin))
  (let ((medium (sheet-medium sheet)))
    (when medium
      (invalidate-cached-transformations medium))))


(defclass permanent-medium-sheet-output-mixin (sheet-with-medium-mixin) ())

(defmethod note-sheet-grafted :around ((sheet permanent-medium-sheet-output-mixin))
  ;; By making this an :AROUND method we make sure that the mirror has
  ;; been realized at this point, if it's a mirrored sheet.  This is pretty
  ;; horrible but it makes sure that things happen in the right order.
  (call-next-method)
  (let ((medium-type (sheet-medium-type sheet)))
    (when medium-type
      (setf (sheet-medium sheet)
	    (if (mediump medium-type)
		medium-type
		(make-medium (port sheet) sheet)))
      (when (port sheet)
	(engraft-medium (sheet-medium sheet) (port sheet) sheet)))))

(defmethod note-sheet-degrafted ((sheet permanent-medium-sheet-output-mixin))
  (when (sheet-medium sheet)
    (degraft-medium (sheet-medium sheet) (port sheet) sheet)
    (setf (sheet-medium sheet) nil)))


(defclass temporary-medium-sheet-output-mixin (sheet-with-medium-mixin) ())

;; This is badly named since it merely specifies the default

(defclass sheet-permanently-enabled-mixin () ()
  (:default-initargs :enabled t))

(defmethod initialize-instance :after ((sheet sheet-permanently-enabled-mixin) 
				       &key enabled)
  (setf (sheet-enabled-p sheet) enabled))
