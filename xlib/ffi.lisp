;; -*- mode: common-lisp; package: x11 -*-
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
;; 52.227-19 or DOD FAR Suppplement 252.227-7013 (c) (1) (ii), as
;; applicable.
;;
;; $fiHeader: ffi.cl,v 1.3 92/01/08 15:22:08 cer Exp $

(in-package :x11)


(defmacro def-exported-constant (name value)
  ;; define the constant and export it from :x11
  `(progn
     (export ',name :x11)
     (defconstant ,name ,value)))

(eval-when (compile load eval)
	   (defun transmogrify-ff-type (type)
	     (if (consp type)
		 (case (car type)
		   (:pointer
		    `(* ,@(transmogrify-ff-type (second type))))
		   (:array
		    `(,@(third type) ,(second type)))
		   (t (list type)))
	       (list type))))


(defmacro def-exported-foreign-synonym-type (new-name old-name)
  `(progn
     (export ',new-name :x11)
     (ff::def-c-typedef ,new-name ,@(transmogrify-ff-type old-name))))

(defun fintern (control &rest args)
  (intern (apply #'format nil control args)))

(defmacro def-exported-foreign-struct (name &rest slots)
  `(progn
     (export '(,name
	       ,(fintern "~A~A" 'make- name)
	       ,@(mapcar #'(lambda (x)
			     (fintern "~A-~A"  name (car x)))
			 slots))
	     :x11)
     ,(flet ((foo-slot (slot)
		       (destructuring-bind
			(name &key type) slot
			`(,name ,@(trans-slot-type type)))))
	    (if (notany #'(lambda (s) (member :overlays (cdr s))) slots)
		`(ff::def-c-type (,name :in-foreign-space) :struct
				 ,@(mapcar #'foo-slot slots))
	      (destructuring-bind
	       ((first-slot-name . first-options) . other-slots) slots
	       (if (and (null (member :overlays first-options))
			(every #'(lambda (slot)
				   t
				   #+ignore
				   (eq (getf (cdr slot) :overlays)
				       first-slot-name))
			       other-slots))
		   `(ff::def-c-type (,name :in-foreign-space) :union
				    ,@(mapcar #'(lambda (slot)
						  (setq slot (copy-list slot))
						  (remf (cdr slot) :overlays)
						  (foo-slot slot))
					      slots))
		 (error ":overlays used in a way we cannot handle")))))))
	  

(defun trans-slot-type (type)
  (if (atom type)
      (transmogrify-ff-type type)
    (ecase (car type)
      (:pointer `(* ,(second type)))
      (:array
       (destructuring-bind
	(ignore type indicies) type
	`(,@indicies ,type))))))

#+ignore
(defmacro def-exported-foreign-function ((name &rest options) &rest args)
  `(progn
     (export ',name :x11)
     (foreign-functions:defforeign 
	 ',name 
	 :arguments ',(mapcar #'(lambda (x) x t) args)
	 :entry-point ,(second (assoc :name options)))))


;; delay version

(defmacro def-exported-foreign-function ((name &rest options) &rest args)
  `(progn
     (export ',name :x11)
     (eval-when (compile eval)
       (delayed-defforeign
	',name 
	:arguments ',(mapcar #'(lambda (x) x t) args)
	:entry-point ,(second (assoc :name options))))))

(defparameter *defforeigned-functions* nil
  "A list of name and defforeign arguments")

(defun delayed-defforeign (name &rest arguments)
  (setf *defforeigned-functions*
    (delete name *defforeigned-functions* :key #'car))
  (push (cons name arguments) *defforeigned-functions*))
  

(defmacro defforeign-functions-now ()
  `(ff:defforeign-list ',*defforeigned-functions*))

;;; End of delay version

(defmacro def-exported-foreign-macro ((name &rest options) &rest args)
  `(def-exported-foreign-function (,name  ,@options) ,@args))

(def-exported-foreign-synonym-type char :char)
(def-exported-foreign-synonym-type unsigned-char :unsigned-char)
(def-exported-foreign-synonym-type short  :short)
(def-exported-foreign-synonym-type unsigned-short :unsigned-short)
(def-exported-foreign-synonym-type int :int)
(def-exported-foreign-synonym-type unsigned-int :unsigned-int)
(def-exported-foreign-synonym-type long :int)
(def-exported-foreign-synonym-type unsigned-long :unsigned-int)
(def-exported-foreign-synonym-type float :single-float)
(def-exported-foreign-synonym-type double  :double-float)
(def-exported-foreign-synonym-type void :int)
(def-exported-foreign-synonym-type short-int short)
(def-exported-foreign-synonym-type long-int long)
(def-exported-foreign-synonym-type unsigned unsigned-int)
(def-exported-foreign-synonym-type long-float double)
(foreign-functions:def-c-typedef :fixnum :int)
(foreign-functions:def-c-typedef :signed-32bit :int)
(foreign-functions:def-c-typedef :pointer * :char)

(foreign-functions:def-c-typedef :signed-8bit :char)

(def-exported-foreign-synonym-type caddr-t int)
(def-exported-foreign-synonym-type u-char unsigned-char)
(def-exported-foreign-synonym-type u-short unsigned-short)
(def-exported-foreign-synonym-type u-int unsigned-int)
(def-exported-foreign-synonym-type u-long unsigned-long)
(def-exported-foreign-synonym-type fd-mask long)
