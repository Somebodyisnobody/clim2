;; -*- mode: common-lisp; package: x11 -*-
;;; (c) Copyright  1990 Sun Microsystems, Inc.  All Rights Reserved.
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

;;      (c) Copyright 1989, 1990, 1991 Sun Microsystems, Inc. Sun design
;;      patents pending in the U.S. and foreign countries. OPEN LOOK is a
;;      registered trademark of USL. Used by written permission of the owners.
;;
;;      (c) Copyright Bigelow & Holmes 1986, 1985. Lucida is a registered
;;      trademark of Bigelow & Holmes. Permission to use the Lucida
;;      trademark is hereby granted only in association with the images
;;      and fonts described in this file.
;;
;;      SUN MICROSYSTEMS, INC., USL, AND BIGELOW & HOLMES
;;      MAKE NO REPRESENTATIONS ABOUT THE SUITABILITY OF
;;      THIS SOURCE OR OBJECT CODE FOR ANY PURPOSE. IT IS PROVIDED "AS IS"
;;      WITHOUT EXPRESS OR IMPLIED WARRANTY OF ANY KIND.
;;      SUN  MICROSYSTEMS, INC., USL AND BIGELOW  & HOLMES,
;;      SEVERALLY AND INDIVIDUALLY, DISCLAIM ALL WARRANTIES
;;      WITH REGARD TO THIS CODE, INCLUDING ALL IMPLIED
;;      WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
;;      PARTICULAR PURPOSE. IN NO EVENT SHALL SUN MICROSYSTEMS,
;;      INC., USL OR BIGELOW & HOLMES BE LIABLE FOR ANY
;;      SPECIAL, INDIRECT, INCIDENTAL, OR CONSEQUENTIAL DAMAGES,
;;      OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA
;;      OR PROFITS, WHETHER IN AN ACTION OF  CONTRACT, NEGLIGENCE
;;      OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
;;      WITH THE USE OR PERFORMANCE OF THIS OBJECT CODE.

;;;@(#)x11-keysym.lisp	1.3 11/29/90
;;; $fiHeader$

(in-package :x11)

;;; X11 Keysyms from include/X11/keysymdef.h.   At the moment all of the keysym
;;; definitions except for those in categories miscellaneous-keysyms and 
;;; latin-2-keysyms are ignored to save space.
;;; 
;;; The symbols defined here represent the corresponding X11 definitions literally,
;;; e.g. the X11 constant for XK_Return is "|XK-Return|".  This is because
;;; many of the keysym constant names are distinguished only by case, e.g. |XK-A|
;;; and |XK-a|.

;;; The exported special variables below are bound to lists of keysyms (real symbols).
;;; The variables are created in xlib.lisp (don't ask).


;; (exports moved to pkg.lisp -- jdi)


;;; KeySym Categoriy Lists from X11/kesymdef.h.  The lists are created in x11-keysym.lisp.

(defvar keyboard-keysyms nil)
(defvar latin-1-keysyms nil)
(defvar latin-2-keysyms nil)
(defvar latin-3-keysyms nil)
(defvar latin-4-keysyms nil)
(defvar kana-keysyms nil)
(defvar arabic-keysyms nil)
(defvar cyrillic-keysyms nil)
(defvar greek-keysyms nil)
(defvar technical-keysyms nil)
(defvar special-keysyms nil)
(defvar publishing-keysyms nil)
(defvar apl-keysyms nil)
(defvar hebrew-keysyms nil)


(defmacro def-x11-keysym (category name value)
  (let ((id (intern (substitute #\- #\_ name :start 1 :end (max 1 (1- (length name)))))))
    `(progn 
       (pushnew ',id ,category)
       (def-exported-constant ,id ,value))))


(progn 
  (def-x11-keysym keyboard-keysyms "XKG_VoidSymbol"          #xFFFFFF)       ;; void symbol 
  (def-x11-keysym keyboard-keysyms "XK_BackSpace"            #xFF08) ;; back space, back char 
  (def-x11-keysym keyboard-keysyms "XK_Tab"                  #xFF09)
  (def-x11-keysym keyboard-keysyms "XK_Linefeed"             #xFF0A) ;; Linefeed, LF 
  (def-x11-keysym keyboard-keysyms "XK_Clear"                #xFF0B)
  (def-x11-keysym keyboard-keysyms "XK_Return"               #xFF0D) ;; Return, enter 
  (def-x11-keysym keyboard-keysyms "XK_Pause"                #xFF13) ;; Pause, hold 
  (def-x11-keysym keyboard-keysyms "XK_Scroll_Lock"          #xFF14)
  (def-x11-keysym keyboard-keysyms "XK_Escape"               #xFF1B)
  (def-x11-keysym keyboard-keysyms "XK_Delete"               #xFFFF) ;; Delete, rubout 
  (def-x11-keysym keyboard-keysyms "XK_Multi_key"            #xFF20) ;; Multi-key character compose 
  (def-x11-keysym keyboard-keysyms "XK_Kanji"                #xFF21) ;; Kanji, Kanji convert 
  (def-x11-keysym keyboard-keysyms "XK_Muhenkan"             #xFF22) ;; Cancel Conversion 
  (def-x11-keysym keyboard-keysyms "XK_Henkan_Mode"          #xFF23) ;; Start/Stop Conversion 
  (def-x11-keysym keyboard-keysyms "XK_Henkan"               #xFF23) ;; Alias for Henkan_Mode 
  (def-x11-keysym keyboard-keysyms "XK_Romaji"               #xFF24) ;; to Romaji 
  (def-x11-keysym keyboard-keysyms "XK_Hiragana"             #xFF25) ;; to Hiragana 
  (def-x11-keysym keyboard-keysyms "XK_Katakana"             #xFF26) ;; to Katakana 
  (def-x11-keysym keyboard-keysyms "XK_Hiragana_Katakana"    #xFF27) ;; Hiragana/Katakana toggle 
  (def-x11-keysym keyboard-keysyms "XK_Zenkaku"              #xFF28) ;; to Zenkaku 
  (def-x11-keysym keyboard-keysyms "XK_Hankaku"              #xFF29) ;; to Hankaku 
  (def-x11-keysym keyboard-keysyms "XK_Zenkaku_Hankaku"      #xFF2A) ;; Zenkaku/Hankaku toggle 
  (def-x11-keysym keyboard-keysyms "XK_Touroku"              #xFF2B) ;; Add to Dictionary 
  (def-x11-keysym keyboard-keysyms "XK_Massyo"               #xFF2C) ;; Delete from Dictionary 
  (def-x11-keysym keyboard-keysyms "XK_Kana_Lock"            #xFF2D) ;; Kana Lock 
  (def-x11-keysym keyboard-keysyms "XK_Kana_Shift"           #xFF2E) ;; Kana Shift 
  (def-x11-keysym keyboard-keysyms "XK_Eisu_Shift"           #xFF2F) ;; Alphanumeric Shift 
  (def-x11-keysym keyboard-keysyms "XK_Eisu_toggle"          #xFF30) ;; Alphanumeric toggle 
  (def-x11-keysym keyboard-keysyms "XK_Home"                 #xFF50)
  (def-x11-keysym keyboard-keysyms "XK_Left"                 #xFF51) ;; Move left, left arrow 
  (def-x11-keysym keyboard-keysyms "XK_Up"                   #xFF52) ;; Move up, up arrow 
  (def-x11-keysym keyboard-keysyms "XK_Right"                #xFF53) ;; Move right, right arrow 
  (def-x11-keysym keyboard-keysyms "XK_Down"                 #xFF54) ;; Move down, down arrow 
  (def-x11-keysym keyboard-keysyms "XK_Prior"                #xFF55) ;; Prior, previous 
  (def-x11-keysym keyboard-keysyms "XK_Next"                 #xFF56) ;; Next 
  (def-x11-keysym keyboard-keysyms "XK_End"                  #xFF57) ;; EOL 
  (def-x11-keysym keyboard-keysyms "XK_Begin"                #xFF58) ;; BOL 
  (def-x11-keysym keyboard-keysyms "XK_Select"               #xFF60) ;; Select, mark 
  (def-x11-keysym keyboard-keysyms "XK_Print"                #xFF61)
  (def-x11-keysym keyboard-keysyms "XK_Execute"              #xFF62) ;; Execute, run, do 
  (def-x11-keysym keyboard-keysyms "XK_Insert"               #xFF63) ;; Insert, insert here 
  (def-x11-keysym keyboard-keysyms "XK_Undo"                 #xFF65) ;; Undo, oops 
  (def-x11-keysym keyboard-keysyms "XK_Redo"                 #xFF66) ;; redo, again 
  (def-x11-keysym keyboard-keysyms "XK_Menu"                 #xFF67)
  (def-x11-keysym keyboard-keysyms "XK_Find"                 #xFF68) ;; Find, search 
  (def-x11-keysym keyboard-keysyms "XK_Cancel"               #xFF69) ;; Cancel, stop, abort, exit 
  (def-x11-keysym keyboard-keysyms "XK_Help"                 #xFF6A) ;; Help, ? 
  (def-x11-keysym keyboard-keysyms "XK_Break"                #xFF6B)
  (def-x11-keysym keyboard-keysyms "XK_Mode_switch"          #xFF7E) ;; Character set switch 
  (def-x11-keysym keyboard-keysyms "XK_script_switch"        #xFF7E) ;; Alias for mode_switch 
  (def-x11-keysym keyboard-keysyms "XK_Num_Lock"             #xFF7F)
  (def-x11-keysym keyboard-keysyms "XK_KP_Space"             #xFF80) ;; space 
  (def-x11-keysym keyboard-keysyms "XK_KP_Tab"               #xFF89)
  (def-x11-keysym keyboard-keysyms "XK_KP_Enter"             #xFF8D) ;; enter 
  (def-x11-keysym keyboard-keysyms "XK_KP_F1"                #xFF91) ;; PF1, KP_A, ... 
  (def-x11-keysym keyboard-keysyms "XK_KP_F2"                #xFF92)
  (def-x11-keysym keyboard-keysyms "XK_KP_F3"                #xFF93)
  (def-x11-keysym keyboard-keysyms "XK_KP_F4"                #xFF94)
  (def-x11-keysym keyboard-keysyms "XK_KP_Equal"             #xFFBD) ;; equals 
  (def-x11-keysym keyboard-keysyms "XK_KP_Multiply"          #xFFAA)
  (def-x11-keysym keyboard-keysyms "XK_KP_Add"               #xFFAB)
  (def-x11-keysym keyboard-keysyms "XK_KP_Separator"         #xFFAC) ;; separator, often comma 
  (def-x11-keysym keyboard-keysyms "XK_KP_Subtract"          #xFFAD)
  (def-x11-keysym keyboard-keysyms "XK_KP_Decimal"           #xFFAE)
  (def-x11-keysym keyboard-keysyms "XK_KP_Divide"            #xFFAF)
  (def-x11-keysym keyboard-keysyms "XK_KP_0"                 #xFFB0)
  (def-x11-keysym keyboard-keysyms "XK_KP_1"                 #xFFB1)
  (def-x11-keysym keyboard-keysyms "XK_KP_2"                 #xFFB2)
  (def-x11-keysym keyboard-keysyms "XK_KP_3"                 #xFFB3)
  (def-x11-keysym keyboard-keysyms "XK_KP_4"                 #xFFB4)
  (def-x11-keysym keyboard-keysyms "XK_KP_5"                 #xFFB5)
  (def-x11-keysym keyboard-keysyms "XK_KP_6"                 #xFFB6)
  (def-x11-keysym keyboard-keysyms "XK_KP_7"                 #xFFB7)
  (def-x11-keysym keyboard-keysyms "XK_KP_8"                 #xFFB8)
  (def-x11-keysym keyboard-keysyms "XK_KP_9"                 #xFFB9)
  (def-x11-keysym keyboard-keysyms "XK_F1"                   #xFFBE)
  (def-x11-keysym keyboard-keysyms "XK_F2"                   #xFFBF)
  (def-x11-keysym keyboard-keysyms "XK_F3"                   #xFFC0)
  (def-x11-keysym keyboard-keysyms "XK_F4"                   #xFFC1)
  (def-x11-keysym keyboard-keysyms "XK_F5"                   #xFFC2)
  (def-x11-keysym keyboard-keysyms "XK_F6"                   #xFFC3)
  (def-x11-keysym keyboard-keysyms "XK_F7"                   #xFFC4)
  (def-x11-keysym keyboard-keysyms "XK_F8"                   #xFFC5)
  (def-x11-keysym keyboard-keysyms "XK_F9"                   #xFFC6)
  (def-x11-keysym keyboard-keysyms "XK_F10"                  #xFFC7)
  (def-x11-keysym keyboard-keysyms "XK_F11"                  #xFFC8)
  (def-x11-keysym keyboard-keysyms "XK_L1"                   #xFFC8)
  (def-x11-keysym keyboard-keysyms "XK_F12"                  #xFFC9)
  (def-x11-keysym keyboard-keysyms "XK_L2"                   #xFFC9)
  (def-x11-keysym keyboard-keysyms "XK_F13"                  #xFFCA)
  (def-x11-keysym keyboard-keysyms "XK_L3"                   #xFFCA)
  (def-x11-keysym keyboard-keysyms "XK_F14"                  #xFFCB)
  (def-x11-keysym keyboard-keysyms "XK_L4"                   #xFFCB)
  (def-x11-keysym keyboard-keysyms "XK_F15"                  #xFFCC)
  (def-x11-keysym keyboard-keysyms "XK_L5"                   #xFFCC)
  (def-x11-keysym keyboard-keysyms "XK_F16"                  #xFFCD)
  (def-x11-keysym keyboard-keysyms "XK_L6"                   #xFFCD)
  (def-x11-keysym keyboard-keysyms "XK_F17"                  #xFFCE)
  (def-x11-keysym keyboard-keysyms "XK_L7"                   #xFFCE)
  (def-x11-keysym keyboard-keysyms "XK_F18"                  #xFFCF)
  (def-x11-keysym keyboard-keysyms "XK_L8"                   #xFFCF)
  (def-x11-keysym keyboard-keysyms "XK_F19"                  #xFFD0)
  (def-x11-keysym keyboard-keysyms "XK_L9"                   #xFFD0)
  (def-x11-keysym keyboard-keysyms "XK_F20"                  #xFFD1)
  (def-x11-keysym keyboard-keysyms "XK_L10"                  #xFFD1)
  (def-x11-keysym keyboard-keysyms "XK_F21"                  #xFFD2)
  (def-x11-keysym keyboard-keysyms "XK_R1"                   #xFFD2)
  (def-x11-keysym keyboard-keysyms "XK_F22"                  #xFFD3)
  (def-x11-keysym keyboard-keysyms "XK_R2"                   #xFFD3)
  (def-x11-keysym keyboard-keysyms "XK_F23"                  #xFFD4)
  (def-x11-keysym keyboard-keysyms "XK_R3"                   #xFFD4)
  (def-x11-keysym keyboard-keysyms "XK_F24"                  #xFFD5)
  (def-x11-keysym keyboard-keysyms "XK_R4"                   #xFFD5)
  (def-x11-keysym keyboard-keysyms "XK_F25"                  #xFFD6)
  (def-x11-keysym keyboard-keysyms "XK_R5"                   #xFFD6)
  (def-x11-keysym keyboard-keysyms "XK_F26"                  #xFFD7)
  (def-x11-keysym keyboard-keysyms "XK_R6"                   #xFFD7)
  (def-x11-keysym keyboard-keysyms "XK_F27"                  #xFFD8)
  (def-x11-keysym keyboard-keysyms "XK_R7"                   #xFFD8)
  (def-x11-keysym keyboard-keysyms "XK_F28"                  #xFFD9)
  (def-x11-keysym keyboard-keysyms "XK_R8"                   #xFFD9)
  (def-x11-keysym keyboard-keysyms "XK_F29"                  #xFFDA)
  (def-x11-keysym keyboard-keysyms "XK_R9"                   #xFFDA)
  (def-x11-keysym keyboard-keysyms "XK_F30"                  #xFFDB)
  (def-x11-keysym keyboard-keysyms "XK_R10"                  #xFFDB)
  (def-x11-keysym keyboard-keysyms "XK_F31"                  #xFFDC)
  (def-x11-keysym keyboard-keysyms "XK_R11"                  #xFFDC)
  (def-x11-keysym keyboard-keysyms "XK_F32"                  #xFFDD)
  (def-x11-keysym keyboard-keysyms "XK_R12"                  #xFFDD)
  (def-x11-keysym keyboard-keysyms "XK_R13"                  #xFFDE)
  (def-x11-keysym keyboard-keysyms "XK_F33"                  #xFFDE)
  (def-x11-keysym keyboard-keysyms "XK_F34"                  #xFFDF)
  (def-x11-keysym keyboard-keysyms "XK_R14"                  #xFFDF)
  (def-x11-keysym keyboard-keysyms "XK_F35"                  #xFFE0)
  (def-x11-keysym keyboard-keysyms "XK_R15"                  #xFFE0)
  (def-x11-keysym keyboard-keysyms "XK_Shift_L"              #xFFE1) ;; Left shift 
  (def-x11-keysym keyboard-keysyms "XK_Shift_R"              #xFFE2) ;; Right shift 
  (def-x11-keysym keyboard-keysyms "XK_Control_L"            #xFFE3) ;; Left control 
  (def-x11-keysym keyboard-keysyms "XK_Control_R"            #xFFE4) ;; Right control 
  (def-x11-keysym keyboard-keysyms "XK_Caps_Lock"            #xFFE5) ;; Caps lock 
  (def-x11-keysym keyboard-keysyms "XK_Shift_Lock"           #xFFE6) ;; Shift lock 
  (def-x11-keysym keyboard-keysyms "XK_Meta_L"               #xFFE7) ;; Left meta 
  (def-x11-keysym keyboard-keysyms "XK_Meta_R"               #xFFE8) ;; Right meta 
  (def-x11-keysym keyboard-keysyms "XK_Alt_L"                #xFFE9) ;; Left alt 
  (def-x11-keysym keyboard-keysyms "XK_Alt_R"                #xFFEA) ;; Right alt 
  (def-x11-keysym keyboard-keysyms "XK_Super_L"              #xFFEB) ;; Left super 
  (def-x11-keysym keyboard-keysyms "XK_Super_R"              #xFFEC) ;; Right super 
  (def-x11-keysym keyboard-keysyms "XK_Hyper_L"              #xFFED) ;; Left hyper 
  (def-x11-keysym keyboard-keysyms "XK_Hyper_R"              #xFFEE) ;; Right hyper 
) 


(progn
  (def-x11-keysym latin-1-keysyms "XK_space"               #x020)
  (def-x11-keysym latin-1-keysyms "XK_exclam"              #x021)
  (def-x11-keysym latin-1-keysyms "XK_quotedbl"            #x022)
  (def-x11-keysym latin-1-keysyms "XK_numbersign"          #x023)
  (def-x11-keysym latin-1-keysyms "XK_dollar"              #x024)
  (def-x11-keysym latin-1-keysyms "XK_percent"             #x025)
  (def-x11-keysym latin-1-keysyms "XK_ampersand"           #x026)
  (def-x11-keysym latin-1-keysyms "XK_apostrophe"          #x027)
  (def-x11-keysym latin-1-keysyms "XK_quoteright"          #x027)   ;; deprecated 
  (def-x11-keysym latin-1-keysyms "XK_parenleft"           #x028)
  (def-x11-keysym latin-1-keysyms "XK_parenright"          #x029)
  (def-x11-keysym latin-1-keysyms "XK_asterisk"            #x02a)
  (def-x11-keysym latin-1-keysyms "XK_plus"                #x02b)
  (def-x11-keysym latin-1-keysyms "XK_comma"               #x02c)
  (def-x11-keysym latin-1-keysyms "XK_minus"               #x02d)
  (def-x11-keysym latin-1-keysyms "XK_period"              #x02e)
  (def-x11-keysym latin-1-keysyms "XK_slash"               #x02f)
  (def-x11-keysym latin-1-keysyms "XK_0"                   #x030)
  (def-x11-keysym latin-1-keysyms "XK_1"                   #x031)
  (def-x11-keysym latin-1-keysyms "XK_2"                   #x032)
  (def-x11-keysym latin-1-keysyms "XK_3"                   #x033)
  (def-x11-keysym latin-1-keysyms "XK_4"                   #x034)
  (def-x11-keysym latin-1-keysyms "XK_5"                   #x035)
  (def-x11-keysym latin-1-keysyms "XK_6"                   #x036)
  (def-x11-keysym latin-1-keysyms "XK_7"                   #x037)
  (def-x11-keysym latin-1-keysyms "XK_8"                   #x038)
  (def-x11-keysym latin-1-keysyms "XK_9"                   #x039)
  (def-x11-keysym latin-1-keysyms "XK_colon"               #x03a)
  (def-x11-keysym latin-1-keysyms "XK_semicolon"           #x03b)
  (def-x11-keysym latin-1-keysyms "XK_less"                #x03c)
  (def-x11-keysym latin-1-keysyms "XK_equal"               #x03d)
  (def-x11-keysym latin-1-keysyms "XK_greater"             #x03e)
  (def-x11-keysym latin-1-keysyms "XK_question"            #x03f)
  (def-x11-keysym latin-1-keysyms "XK_at"                  #x040)
  (def-x11-keysym latin-1-keysyms "XK_A"                   #x041)
  (def-x11-keysym latin-1-keysyms "XK_B"                   #x042)
  (def-x11-keysym latin-1-keysyms "XK_C"                   #x043)
  (def-x11-keysym latin-1-keysyms "XK_D"                   #x044)
  (def-x11-keysym latin-1-keysyms "XK_E"                   #x045)
  (def-x11-keysym latin-1-keysyms "XK_F"                   #x046)
  (def-x11-keysym latin-1-keysyms "XK_G"                   #x047)
  (def-x11-keysym latin-1-keysyms "XK_H"                   #x048)
  (def-x11-keysym latin-1-keysyms "XK_I"                   #x049)
  (def-x11-keysym latin-1-keysyms "XK_J"                   #x04a)
  (def-x11-keysym latin-1-keysyms "XK_K"                   #x04b)
  (def-x11-keysym latin-1-keysyms "XK_L"                   #x04c)
  (def-x11-keysym latin-1-keysyms "XK_M"                   #x04d)
  (def-x11-keysym latin-1-keysyms "XK_N"                   #x04e)
  (def-x11-keysym latin-1-keysyms "XK_O"                   #x04f)
  (def-x11-keysym latin-1-keysyms "XK_P"                   #x050)
  (def-x11-keysym latin-1-keysyms "XK_Q"                   #x051)
  (def-x11-keysym latin-1-keysyms "XK_R"                   #x052)
  (def-x11-keysym latin-1-keysyms "XK_S"                   #x053)
  (def-x11-keysym latin-1-keysyms "XK_T"                   #x054)
  (def-x11-keysym latin-1-keysyms "XK_U"                   #x055)
  (def-x11-keysym latin-1-keysyms "XK_V"                   #x056)
  (def-x11-keysym latin-1-keysyms "XK_W"                   #x057)
  (def-x11-keysym latin-1-keysyms "XK_X"                   #x058)
  (def-x11-keysym latin-1-keysyms "XK_Y"                   #x059)
  (def-x11-keysym latin-1-keysyms "XK_Z"                   #x05a)
  (def-x11-keysym latin-1-keysyms "XK_bracketleft"         #x05b)
  (def-x11-keysym latin-1-keysyms "XK_backslash"           #x05c)
  (def-x11-keysym latin-1-keysyms "XK_bracketright"        #x05d)
  (def-x11-keysym latin-1-keysyms "XK_asciicircum"         #x05e)
  (def-x11-keysym latin-1-keysyms "XK_underscore"          #x05f)
  (def-x11-keysym latin-1-keysyms "XK_grave"               #x060)
  (def-x11-keysym latin-1-keysyms "XK_quoteleft"           #x060)   ;; deprecated 
  (def-x11-keysym latin-1-keysyms "XK_a"                   #x061)
  (def-x11-keysym latin-1-keysyms "XK_b"                   #x062)
  (def-x11-keysym latin-1-keysyms "XK_c"                   #x063)
  (def-x11-keysym latin-1-keysyms "XK_d"                   #x064)
  (def-x11-keysym latin-1-keysyms "XK_e"                   #x065)
  (def-x11-keysym latin-1-keysyms "XK_f"                   #x066)
  (def-x11-keysym latin-1-keysyms "XK_g"                   #x067)
  (def-x11-keysym latin-1-keysyms "XK_h"                   #x068)
  (def-x11-keysym latin-1-keysyms "XK_i"                   #x069)
  (def-x11-keysym latin-1-keysyms "XK_j"                   #x06a)
  (def-x11-keysym latin-1-keysyms "XK_k"                   #x06b)
  (def-x11-keysym latin-1-keysyms "XK_l"                   #x06c)
  (def-x11-keysym latin-1-keysyms "XK_m"                   #x06d)
  (def-x11-keysym latin-1-keysyms "XK_n"                   #x06e)
  (def-x11-keysym latin-1-keysyms "XK_o"                   #x06f)
  (def-x11-keysym latin-1-keysyms "XK_p"                   #x070)
  (def-x11-keysym latin-1-keysyms "XK_q"                   #x071)
  (def-x11-keysym latin-1-keysyms "XK_r"                   #x072)
  (def-x11-keysym latin-1-keysyms "XK_s"                   #x073)
  (def-x11-keysym latin-1-keysyms "XK_t"                   #x074)
  (def-x11-keysym latin-1-keysyms "XK_u"                   #x075)
  (def-x11-keysym latin-1-keysyms "XK_v"                   #x076)
  (def-x11-keysym latin-1-keysyms "XK_w"                   #x077)
  (def-x11-keysym latin-1-keysyms "XK_x"                   #x078)
  (def-x11-keysym latin-1-keysyms "XK_y"                   #x079)
  (def-x11-keysym latin-1-keysyms "XK_z"                   #x07a)
  (def-x11-keysym latin-1-keysyms "XK_braceleft"           #x07b)
  (def-x11-keysym latin-1-keysyms "XK_bar"                 #x07c)
  (def-x11-keysym latin-1-keysyms "XK_braceright"          #x07d)
  (def-x11-keysym latin-1-keysyms "XK_asciitilde"          #x07e)
  (def-x11-keysym latin-1-keysyms "XK_nobreakspace"        #x0a0)
  (def-x11-keysym latin-1-keysyms "XK_exclamdown"          #x0a1)
  (def-x11-keysym latin-1-keysyms "XK_cent"                #x0a2)
  (def-x11-keysym latin-1-keysyms "XK_sterling"            #x0a3)
  (def-x11-keysym latin-1-keysyms "XK_currency"            #x0a4)
  (def-x11-keysym latin-1-keysyms "XK_yen"                 #x0a5)
  (def-x11-keysym latin-1-keysyms "XK_brokenbar"           #x0a6)
  (def-x11-keysym latin-1-keysyms "XK_section"             #x0a7)
  (def-x11-keysym latin-1-keysyms "XK_diaeresis"           #x0a8)
  (def-x11-keysym latin-1-keysyms "XK_copyright"           #x0a9)
  (def-x11-keysym latin-1-keysyms "XK_ordfeminine"         #x0aa)
  (def-x11-keysym latin-1-keysyms "XK_guillemotleft"       #x0ab)   ;; left angle quotation mark 
  (def-x11-keysym latin-1-keysyms "XK_notsign"             #x0ac)
  (def-x11-keysym latin-1-keysyms "XK_hyphen"              #x0ad)
  (def-x11-keysym latin-1-keysyms "XK_registered"          #x0ae)
  (def-x11-keysym latin-1-keysyms "XK_macron"              #x0af)
  (def-x11-keysym latin-1-keysyms "XK_degree"              #x0b0)
  (def-x11-keysym latin-1-keysyms "XK_plusminus"           #x0b1)
  (def-x11-keysym latin-1-keysyms "XK_twosuperior"         #x0b2)
  (def-x11-keysym latin-1-keysyms "XK_threesuperior"       #x0b3)
  (def-x11-keysym latin-1-keysyms "XK_acute"               #x0b4)
  (def-x11-keysym latin-1-keysyms "XK_mu"                  #x0b5)
  (def-x11-keysym latin-1-keysyms "XK_paragraph"           #x0b6)
  (def-x11-keysym latin-1-keysyms "XK_periodcentered"      #x0b7)
  (def-x11-keysym latin-1-keysyms "XK_cedilla"             #x0b8)
  (def-x11-keysym latin-1-keysyms "XK_onesuperior"         #x0b9)
  (def-x11-keysym latin-1-keysyms "XK_masculine"           #x0ba)
  (def-x11-keysym latin-1-keysyms "XK_guillemotright"      #x0bb)   ;; right angle quotation mark 
  (def-x11-keysym latin-1-keysyms "XK_onequarter"          #x0bc)
  (def-x11-keysym latin-1-keysyms "XK_onehalf"             #x0bd)
  (def-x11-keysym latin-1-keysyms "XK_threequarters"       #x0be)
  (def-x11-keysym latin-1-keysyms "XK_questiondown"        #x0bf)
  (def-x11-keysym latin-1-keysyms "XK_Agrave"              #x0c0)
  (def-x11-keysym latin-1-keysyms "XK_Aacute"              #x0c1)
  (def-x11-keysym latin-1-keysyms "XK_Acircumflex"         #x0c2)
  (def-x11-keysym latin-1-keysyms "XK_Atilde"              #x0c3)
  (def-x11-keysym latin-1-keysyms "XK_Adiaeresis"          #x0c4)
  (def-x11-keysym latin-1-keysyms "XK_Aring"               #x0c5)
  (def-x11-keysym latin-1-keysyms "XK_AE"                  #x0c6)
  (def-x11-keysym latin-1-keysyms "XK_Ccedilla"            #x0c7)
  (def-x11-keysym latin-1-keysyms "XK_Egrave"              #x0c8)
  (def-x11-keysym latin-1-keysyms "XK_Eacute"              #x0c9)
  (def-x11-keysym latin-1-keysyms "XK_Ecircumflex"         #x0ca)
  (def-x11-keysym latin-1-keysyms "XK_Ediaeresis"          #x0cb)
  (def-x11-keysym latin-1-keysyms "XK_Igrave"              #x0cc)
  (def-x11-keysym latin-1-keysyms "XK_Iacute"              #x0cd)
  (def-x11-keysym latin-1-keysyms "XK_Icircumflex"         #x0ce)
  (def-x11-keysym latin-1-keysyms "XK_Idiaeresis"          #x0cf)
  (def-x11-keysym latin-1-keysyms "XK_ETH"                 #x0d0)
  (def-x11-keysym latin-1-keysyms "XK_Eth"                 #x0d0)   ;; deprecated 
  (def-x11-keysym latin-1-keysyms "XK_Ntilde"              #x0d1)
  (def-x11-keysym latin-1-keysyms "XK_Ograve"              #x0d2)
  (def-x11-keysym latin-1-keysyms "XK_Oacute"              #x0d3)
  (def-x11-keysym latin-1-keysyms "XK_Ocircumflex"         #x0d4)
  (def-x11-keysym latin-1-keysyms "XK_Otilde"              #x0d5)
  (def-x11-keysym latin-1-keysyms "XK_Odiaeresis"          #x0d6)
  (def-x11-keysym latin-1-keysyms "XK_multiply"            #x0d7)
  (def-x11-keysym latin-1-keysyms "XK_Ooblique"            #x0d8)
  (def-x11-keysym latin-1-keysyms "XK_Ugrave"              #x0d9)
  (def-x11-keysym latin-1-keysyms "XK_Uacute"              #x0da)
  (def-x11-keysym latin-1-keysyms "XK_Ucircumflex"         #x0db)
  (def-x11-keysym latin-1-keysyms "XK_Udiaeresis"          #x0dc)
  (def-x11-keysym latin-1-keysyms "XK_Yacute"              #x0dd)
  (def-x11-keysym latin-1-keysyms "XK_THORN"               #x0de)
  (def-x11-keysym latin-1-keysyms "XK_Thorn"               #x0de)   ;; deprecated 
  (def-x11-keysym latin-1-keysyms "XK_ssharp"              #x0df)
  (def-x11-keysym latin-1-keysyms "XK_agrave"              #x0e0)
  (def-x11-keysym latin-1-keysyms "XK_aacute"              #x0e1)
  (def-x11-keysym latin-1-keysyms "XK_acircumflex"         #x0e2)
  (def-x11-keysym latin-1-keysyms "XK_atilde"              #x0e3)
  (def-x11-keysym latin-1-keysyms "XK_adiaeresis"          #x0e4)
  (def-x11-keysym latin-1-keysyms "XK_aring"               #x0e5)
  (def-x11-keysym latin-1-keysyms "XK_ae"                  #x0e6)
  (def-x11-keysym latin-1-keysyms "XK_ccedilla"            #x0e7)
  (def-x11-keysym latin-1-keysyms "XK_egrave"              #x0e8)
  (def-x11-keysym latin-1-keysyms "XK_eacute"              #x0e9)
  (def-x11-keysym latin-1-keysyms "XK_ecircumflex"         #x0ea)
  (def-x11-keysym latin-1-keysyms "XK_ediaeresis"          #x0eb)
  (def-x11-keysym latin-1-keysyms "XK_igrave"              #x0ec)
  (def-x11-keysym latin-1-keysyms "XK_iacute"              #x0ed)
  (def-x11-keysym latin-1-keysyms "XK_icircumflex"         #x0ee)
  (def-x11-keysym latin-1-keysyms "XK_idiaeresis"          #x0ef)
  (def-x11-keysym latin-1-keysyms "XK_eth"                 #x0f0)
  (def-x11-keysym latin-1-keysyms "XK_ntilde"              #x0f1)
  (def-x11-keysym latin-1-keysyms "XK_ograve"              #x0f2)
  (def-x11-keysym latin-1-keysyms "XK_oacute"              #x0f3)
  (def-x11-keysym latin-1-keysyms "XK_ocircumflex"         #x0f4)
  (def-x11-keysym latin-1-keysyms "XK_otilde"              #x0f5)
  (def-x11-keysym latin-1-keysyms "XK_odiaeresis"          #x0f6)
  (def-x11-keysym latin-1-keysyms "XK_division"            #x0f7)
  (def-x11-keysym latin-1-keysyms "XK_oslash"              #x0f8)
  (def-x11-keysym latin-1-keysyms "XK_ugrave"              #x0f9)
  (def-x11-keysym latin-1-keysyms "XK_uacute"              #x0fa)
  (def-x11-keysym latin-1-keysyms "XK_ucircumflex"         #x0fb)
  (def-x11-keysym latin-1-keysyms "XK_udiaeresis"          #x0fc)
  (def-x11-keysym latin-1-keysyms "XK_yacute"              #x0fd)
  (def-x11-keysym latin-1-keysyms "XK_thorn"               #x0fe)
  (def-x11-keysym latin-1-keysyms "XK_ydiaeresis"          #x0ff)

) 


#+ignore
(progn 
  (def-x11-keysym latin-2-keysyms "XK_Aogonek"             #x1a1)
  (def-x11-keysym latin-2-keysyms "XK_breve"               #x1a2)
  (def-x11-keysym latin-2-keysyms "XK_Lstroke"             #x1a3)
  (def-x11-keysym latin-2-keysyms "XK_Lcaron"              #x1a5)
  (def-x11-keysym latin-2-keysyms "XK_Sacute"              #x1a6)
  (def-x11-keysym latin-2-keysyms "XK_Scaron"              #x1a9)
  (def-x11-keysym latin-2-keysyms "XK_Scedilla"            #x1aa)
  (def-x11-keysym latin-2-keysyms "XK_Tcaron"              #x1ab)
  (def-x11-keysym latin-2-keysyms "XK_Zacute"              #x1ac)
  (def-x11-keysym latin-2-keysyms "XK_Zcaron"              #x1ae)
  (def-x11-keysym latin-2-keysyms "XK_Zabovedot"           #x1af)
  (def-x11-keysym latin-2-keysyms "XK_aogonek"             #x1b1)
  (def-x11-keysym latin-2-keysyms "XK_ogonek"              #x1b2)
  (def-x11-keysym latin-2-keysyms "XK_lstroke"             #x1b3)
  (def-x11-keysym latin-2-keysyms "XK_lcaron"              #x1b5)
  (def-x11-keysym latin-2-keysyms "XK_sacute"              #x1b6)
  (def-x11-keysym latin-2-keysyms "XK_caron"               #x1b7)
  (def-x11-keysym latin-2-keysyms "XK_scaron"              #x1b9)
  (def-x11-keysym latin-2-keysyms "XK_scedilla"            #x1ba)
  (def-x11-keysym latin-2-keysyms "XK_tcaron"              #x1bb)
  (def-x11-keysym latin-2-keysyms "XK_zacute"              #x1bc)
  (def-x11-keysym latin-2-keysyms "XK_doubleacute"         #x1bd)
  (def-x11-keysym latin-2-keysyms "XK_zcaron"              #x1be)
  (def-x11-keysym latin-2-keysyms "XK_zabovedot"           #x1bf)
  (def-x11-keysym latin-2-keysyms "XK_Racute"              #x1c0)
  (def-x11-keysym latin-2-keysyms "XK_Abreve"              #x1c3)
  (def-x11-keysym latin-2-keysyms "XK_Lacute"              #x1c5)
  (def-x11-keysym latin-2-keysyms "XK_Cacute"              #x1c6)
  (def-x11-keysym latin-2-keysyms "XK_Ccaron"              #x1c8)
  (def-x11-keysym latin-2-keysyms "XK_Eogonek"             #x1ca)
  (def-x11-keysym latin-2-keysyms "XK_Ecaron"              #x1cc)
  (def-x11-keysym latin-2-keysyms "XK_Dcaron"              #x1cf)
  (def-x11-keysym latin-2-keysyms "XK_Dstroke"             #x1d0)
  (def-x11-keysym latin-2-keysyms "XK_Nacute"              #x1d1)
  (def-x11-keysym latin-2-keysyms "XK_Ncaron"              #x1d2)
  (def-x11-keysym latin-2-keysyms "XK_Odoubleacute"        #x1d5)
  (def-x11-keysym latin-2-keysyms "XK_Rcaron"              #x1d8)
  (def-x11-keysym latin-2-keysyms "XK_Uring"               #x1d9)
  (def-x11-keysym latin-2-keysyms "XK_Udoubleacute"        #x1db)
  (def-x11-keysym latin-2-keysyms "XK_Tcedilla"            #x1de)
  (def-x11-keysym latin-2-keysyms "XK_racute"              #x1e0)
  (def-x11-keysym latin-2-keysyms "XK_abreve"              #x1e3)
  (def-x11-keysym latin-2-keysyms "XK_lacute"              #x1e5)
  (def-x11-keysym latin-2-keysyms "XK_cacute"              #x1e6)
  (def-x11-keysym latin-2-keysyms "XK_ccaron"              #x1e8)
  (def-x11-keysym latin-2-keysyms "XK_eogonek"             #x1ea)
  (def-x11-keysym latin-2-keysyms "XK_ecaron"              #x1ec)
  (def-x11-keysym latin-2-keysyms "XK_dcaron"              #x1ef)
  (def-x11-keysym latin-2-keysyms "XK_dstroke"             #x1f0)
  (def-x11-keysym latin-2-keysyms "XK_nacute"              #x1f1)
  (def-x11-keysym latin-2-keysyms "XK_ncaron"              #x1f2)
  (def-x11-keysym latin-2-keysyms "XK_odoubleacute"        #x1f5)
  (def-x11-keysym latin-2-keysyms "XK_udoubleacute"        #x1fb)
  (def-x11-keysym latin-2-keysyms "XK_rcaron"              #x1f8)
  (def-x11-keysym latin-2-keysyms "XK_uring"               #x1f9)
  (def-x11-keysym latin-2-keysyms "XK_tcedilla"            #x1fe)
  (def-x11-keysym latin-2-keysyms "XK_abovedot"            #x1ff)
) 


#+ignore
(progn 
  (def-x11-keysym latin-3-keysyms "XK_Hstroke"             #x2a1)
  (def-x11-keysym latin-3-keysyms "XK_Hcircumflex"         #x2a6)
  (def-x11-keysym latin-3-keysyms "XK_Iabovedot"           #x2a9)
  (def-x11-keysym latin-3-keysyms "XK_Gbreve"              #x2ab)
  (def-x11-keysym latin-3-keysyms "XK_Jcircumflex"         #x2ac)
  (def-x11-keysym latin-3-keysyms "XK_hstroke"             #x2b1)
  (def-x11-keysym latin-3-keysyms "XK_hcircumflex"         #x2b6)
  (def-x11-keysym latin-3-keysyms "XK_idotless"            #x2b9)
  (def-x11-keysym latin-3-keysyms "XK_gbreve"              #x2bb)
  (def-x11-keysym latin-3-keysyms "XK_jcircumflex"         #x2bc)
  (def-x11-keysym latin-3-keysyms "XK_Cabovedot"           #x2c5)
  (def-x11-keysym latin-3-keysyms "XK_Ccircumflex"         #x2c6)
  (def-x11-keysym latin-3-keysyms "XK_Gabovedot"           #x2d5)
  (def-x11-keysym latin-3-keysyms "XK_Gcircumflex"         #x2d8)
  (def-x11-keysym latin-3-keysyms "XK_Ubreve"              #x2dd)
  (def-x11-keysym latin-3-keysyms "XK_Scircumflex"         #x2de)
  (def-x11-keysym latin-3-keysyms "XK_cabovedot"           #x2e5)
  (def-x11-keysym latin-3-keysyms "XK_ccircumflex"         #x2e6)
  (def-x11-keysym latin-3-keysyms "XK_gabovedot"           #x2f5)
  (def-x11-keysym latin-3-keysyms "XK_gcircumflex"         #x2f8)
  (def-x11-keysym latin-3-keysyms "XK_ubreve"              #x2fd)
  (def-x11-keysym latin-3-keysyms "XK_scircumflex"         #x2fe)
) 


#+ignore
(progn 
  (def-x11-keysym latin-4-keysyms "XK_kra"                 #x3a2)
  (def-x11-keysym latin-4-keysyms "XK_kappa"               #x3a2)   ;; deprecated 
  (def-x11-keysym latin-4-keysyms "XK_Rcedilla"            #x3a3)
  (def-x11-keysym latin-4-keysyms "XK_Itilde"              #x3a5)
  (def-x11-keysym latin-4-keysyms "XK_Lcedilla"            #x3a6)
  (def-x11-keysym latin-4-keysyms "XK_Emacron"             #x3aa)
  (def-x11-keysym latin-4-keysyms "XK_Gcedilla"            #x3ab)
  (def-x11-keysym latin-4-keysyms "XK_Tslash"              #x3ac)
  (def-x11-keysym latin-4-keysyms "XK_rcedilla"            #x3b3)
  (def-x11-keysym latin-4-keysyms "XK_itilde"              #x3b5)
  (def-x11-keysym latin-4-keysyms "XK_lcedilla"            #x3b6)
  (def-x11-keysym latin-4-keysyms "XK_emacron"             #x3ba)
  (def-x11-keysym latin-4-keysyms "XK_gcedilla"            #x3bb)
  (def-x11-keysym latin-4-keysyms "XK_tslash"              #x3bc)
  (def-x11-keysym latin-4-keysyms "XK_ENG"                 #x3bd)
  (def-x11-keysym latin-4-keysyms "XK_eng"                 #x3bf)
  (def-x11-keysym latin-4-keysyms "XK_Amacron"             #x3c0)
  (def-x11-keysym latin-4-keysyms "XK_Iogonek"             #x3c7)
  (def-x11-keysym latin-4-keysyms "XK_Eabovedot"           #x3cc)
  (def-x11-keysym latin-4-keysyms "XK_Imacron"             #x3cf)
  (def-x11-keysym latin-4-keysyms "XK_Ncedilla"            #x3d1)
  (def-x11-keysym latin-4-keysyms "XK_Omacron"             #x3d2)
  (def-x11-keysym latin-4-keysyms "XK_Kcedilla"            #x3d3)
  (def-x11-keysym latin-4-keysyms "XK_Uogonek"             #x3d9)
  (def-x11-keysym latin-4-keysyms "XK_Utilde"              #x3dd)
  (def-x11-keysym latin-4-keysyms "XK_Umacron"             #x3de)
  (def-x11-keysym latin-4-keysyms "XK_amacron"             #x3e0)
  (def-x11-keysym latin-4-keysyms "XK_iogonek"             #x3e7)
  (def-x11-keysym latin-4-keysyms "XK_eabovedot"           #x3ec)
  (def-x11-keysym latin-4-keysyms "XK_imacron"             #x3ef)
  (def-x11-keysym latin-4-keysyms "XK_ncedilla"            #x3f1)
  (def-x11-keysym latin-4-keysyms "XK_omacron"             #x3f2)
  (def-x11-keysym latin-4-keysyms "XK_kcedilla"            #x3f3)
  (def-x11-keysym latin-4-keysyms "XK_uogonek"             #x3f9)
  (def-x11-keysym latin-4-keysyms "XK_utilde"              #x3fd)
  (def-x11-keysym latin-4-keysyms "XK_umacron"             #x3fe)
) 


#+ignore
(progn
  (def-x11-keysym kana-keysyms "XK_overline"                                   #x47e)
  (def-x11-keysym kana-keysyms "XK_kana_fullstop"                               #x4a1)
  (def-x11-keysym kana-keysyms "XK_kana_openingbracket"                         #x4a2)
  (def-x11-keysym kana-keysyms "XK_kana_closingbracket"                         #x4a3)
  (def-x11-keysym kana-keysyms "XK_kana_comma"                                  #x4a4)
  (def-x11-keysym kana-keysyms "XK_kana_conjunctive"                            #x4a5)
  (def-x11-keysym kana-keysyms "XK_kana_middledot"                              #x4a5)  ;; deprecated 
  (def-x11-keysym kana-keysyms "XK_kana_WO"                                     #x4a6)
  (def-x11-keysym kana-keysyms "XK_kana_a"                                      #x4a7)
  (def-x11-keysym kana-keysyms "XK_kana_i"                                      #x4a8)
  (def-x11-keysym kana-keysyms "XK_kana_u"                                      #x4a9)
  (def-x11-keysym kana-keysyms "XK_kana_e"                                      #x4aa)
  (def-x11-keysym kana-keysyms "XK_kana_o"                                      #x4ab)
  (def-x11-keysym kana-keysyms "XK_kana_ya"                                     #x4ac)
  (def-x11-keysym kana-keysyms "XK_kana_yu"                                     #x4ad)
  (def-x11-keysym kana-keysyms "XK_kana_yo"                                     #x4ae)
  (def-x11-keysym kana-keysyms "XK_kana_tsu"                                    #x4af)
  (def-x11-keysym kana-keysyms "XK_kana_tu"                                     #x4af)  ;; deprecated 
  (def-x11-keysym kana-keysyms "XK_prolongedsound"                              #x4b0)
  (def-x11-keysym kana-keysyms "XK_kana_A"                                      #x4b1)
  (def-x11-keysym kana-keysyms "XK_kana_I"                                      #x4b2)
  (def-x11-keysym kana-keysyms "XK_kana_U"                                      #x4b3)
  (def-x11-keysym kana-keysyms "XK_kana_E"                                      #x4b4)
  (def-x11-keysym kana-keysyms "XK_kana_O"                                      #x4b5)
  (def-x11-keysym kana-keysyms "XK_kana_KA"                                     #x4b6)
  (def-x11-keysym kana-keysyms "XK_kana_KI"                                     #x4b7)
  (def-x11-keysym kana-keysyms "XK_kana_KU"                                     #x4b8)
  (def-x11-keysym kana-keysyms "XK_kana_KE"                                     #x4b9)
  (def-x11-keysym kana-keysyms "XK_kana_KO"                                     #x4ba)
  (def-x11-keysym kana-keysyms "XK_kana_SA"                                     #x4bb)
  (def-x11-keysym kana-keysyms "XK_kana_SHI"                                    #x4bc)
  (def-x11-keysym kana-keysyms "XK_kana_SU"                                     #x4bd)
  (def-x11-keysym kana-keysyms "XK_kana_SE"                                     #x4be)
  (def-x11-keysym kana-keysyms "XK_kana_SO"                                     #x4bf)
  (def-x11-keysym kana-keysyms "XK_kana_TA"                                     #x4c0)
  (def-x11-keysym kana-keysyms "XK_kana_CHI"                                    #x4c1)
  (def-x11-keysym kana-keysyms "XK_kana_TI"                                     #x4c1)  ;; deprecated 
  (def-x11-keysym kana-keysyms "XK_kana_TSU"                                    #x4c2)
  (def-x11-keysym kana-keysyms "XK_kana_TU"                                     #x4c2)  ;; deprecated 
  (def-x11-keysym kana-keysyms "XK_kana_TE"                                     #x4c3)
  (def-x11-keysym kana-keysyms "XK_kana_TO"                                     #x4c4)
  (def-x11-keysym kana-keysyms "XK_kana_NA"                                     #x4c5)
  (def-x11-keysym kana-keysyms "XK_kana_NI"                                     #x4c6)
  (def-x11-keysym kana-keysyms "XK_kana_NU"                                     #x4c7)
  (def-x11-keysym kana-keysyms "XK_kana_NE"                                     #x4c8)
  (def-x11-keysym kana-keysyms "XK_kana_NO"                                     #x4c9)
  (def-x11-keysym kana-keysyms "XK_kana_HA"                                     #x4ca)
  (def-x11-keysym kana-keysyms "XK_kana_HI"                                     #x4cb)
  (def-x11-keysym kana-keysyms "XK_kana_FU"                                     #x4cc)
  (def-x11-keysym kana-keysyms "XK_kana_HU"                                     #x4cc)  ;; deprecated 
  (def-x11-keysym kana-keysyms "XK_kana_HE"                                     #x4cd)
  (def-x11-keysym kana-keysyms "XK_kana_HO"                                     #x4ce)
  (def-x11-keysym kana-keysyms "XK_kana_MA"                                     #x4cf)
  (def-x11-keysym kana-keysyms "XK_kana_MI"                                     #x4d0)
  (def-x11-keysym kana-keysyms "XK_kana_MU"                                     #x4d1)
  (def-x11-keysym kana-keysyms "XK_kana_ME"                                     #x4d2)
  (def-x11-keysym kana-keysyms "XK_kana_MO"                                     #x4d3)
  (def-x11-keysym kana-keysyms "XK_kana_YA"                                     #x4d4)
  (def-x11-keysym kana-keysyms "XK_kana_YU"                                     #x4d5)
  (def-x11-keysym kana-keysyms "XK_kana_YO"                                     #x4d6)
  (def-x11-keysym kana-keysyms "XK_kana_RA"                                     #x4d7)
  (def-x11-keysym kana-keysyms "XK_kana_RI"                                     #x4d8)
  (def-x11-keysym kana-keysyms "XK_kana_RU"                                     #x4d9)
  (def-x11-keysym kana-keysyms "XK_kana_RE"                                     #x4da)
  (def-x11-keysym kana-keysyms "XK_kana_RO"                                     #x4db)
  (def-x11-keysym kana-keysyms "XK_kana_WA"                                     #x4dc)
  (def-x11-keysym kana-keysyms "XK_kana_N"                                      #x4dd)
  (def-x11-keysym kana-keysyms "XK_voicedsound"                                 #x4de)
  (def-x11-keysym kana-keysyms "XK_semivoicedsound"                             #x4df)
  (def-x11-keysym kana-keysyms "XK_kana_switch"          #xFF7E)  ;; Alias for mode_switch 
) 


#+ignore
(progn 
  (def-x11-keysym arabic-keysyms "XK_Arabic_comma"                                #x5ac)
  (def-x11-keysym arabic-keysyms "XK_Arabic_semicolon"                            #x5bb)
  (def-x11-keysym arabic-keysyms "XK_Arabic_question_mark"                        #x5bf)
  (def-x11-keysym arabic-keysyms "XK_Arabic_hamza"                                #x5c1)
  (def-x11-keysym arabic-keysyms "XK_Arabic_maddaonalef"                          #x5c2)
  (def-x11-keysym arabic-keysyms "XK_Arabic_hamzaonalef"                          #x5c3)
  (def-x11-keysym arabic-keysyms "XK_Arabic_hamzaonwaw"                           #x5c4)
  (def-x11-keysym arabic-keysyms "XK_Arabic_hamzaunderalef"                       #x5c5)
  (def-x11-keysym arabic-keysyms "XK_Arabic_hamzaonyeh"                           #x5c6)
  (def-x11-keysym arabic-keysyms "XK_Arabic_alef"                                 #x5c7)
  (def-x11-keysym arabic-keysyms "XK_Arabic_beh"                                  #x5c8)
  (def-x11-keysym arabic-keysyms "XK_Arabic_tehmarbuta"                           #x5c9)
  (def-x11-keysym arabic-keysyms "XK_Arabic_teh"                                  #x5ca)
  (def-x11-keysym arabic-keysyms "XK_Arabic_theh"                                 #x5cb)
  (def-x11-keysym arabic-keysyms "XK_Arabic_jeem"                                 #x5cc)
  (def-x11-keysym arabic-keysyms "XK_Arabic_hah"                                  #x5cd)
  (def-x11-keysym arabic-keysyms "XK_Arabic_khah"                                 #x5ce)
  (def-x11-keysym arabic-keysyms "XK_Arabic_dal"                                  #x5cf)
  (def-x11-keysym arabic-keysyms "XK_Arabic_thal"                                 #x5d0)
  (def-x11-keysym arabic-keysyms "XK_Arabic_ra"                                   #x5d1)
  (def-x11-keysym arabic-keysyms "XK_Arabic_zain"                                 #x5d2)
  (def-x11-keysym arabic-keysyms "XK_Arabic_seen"                                 #x5d3)
  (def-x11-keysym arabic-keysyms "XK_Arabic_sheen"                                #x5d4)
  (def-x11-keysym arabic-keysyms "XK_Arabic_sad"                                  #x5d5)
  (def-x11-keysym arabic-keysyms "XK_Arabic_dad"                                  #x5d6)
  (def-x11-keysym arabic-keysyms "XK_Arabic_tah"                                  #x5d7)
  (def-x11-keysym arabic-keysyms "XK_Arabic_zah"                                  #x5d8)
  (def-x11-keysym arabic-keysyms "XK_Arabic_ain"                                  #x5d9)
  (def-x11-keysym arabic-keysyms "XK_Arabic_ghain"                                #x5da)
  (def-x11-keysym arabic-keysyms "XK_Arabic_tatweel"                              #x5e0)
  (def-x11-keysym arabic-keysyms "XK_Arabic_feh"                                  #x5e1)
  (def-x11-keysym arabic-keysyms "XK_Arabic_qaf"                                  #x5e2)
  (def-x11-keysym arabic-keysyms "XK_Arabic_kaf"                                  #x5e3)
  (def-x11-keysym arabic-keysyms "XK_Arabic_lam"                                  #x5e4)
  (def-x11-keysym arabic-keysyms "XK_Arabic_meem"                                 #x5e5)
  (def-x11-keysym arabic-keysyms "XK_Arabic_noon"                                 #x5e6)
  (def-x11-keysym arabic-keysyms "XK_Arabic_ha"                                   #x5e7)
  (def-x11-keysym arabic-keysyms "XK_Arabic_heh"                                  #x5e7)  ;; deprecated 
  (def-x11-keysym arabic-keysyms "XK_Arabic_waw"                                  #x5e8)
  (def-x11-keysym arabic-keysyms "XK_Arabic_alefmaksura"                          #x5e9)
  (def-x11-keysym arabic-keysyms "XK_Arabic_yeh"                                  #x5ea)
  (def-x11-keysym arabic-keysyms "XK_Arabic_fathatan"                             #x5eb)
  (def-x11-keysym arabic-keysyms "XK_Arabic_dammatan"                             #x5ec)
  (def-x11-keysym arabic-keysyms "XK_Arabic_kasratan"                             #x5ed)
  (def-x11-keysym arabic-keysyms "XK_Arabic_fatha"                                #x5ee)
  (def-x11-keysym arabic-keysyms "XK_Arabic_damma"                                #x5ef)
  (def-x11-keysym arabic-keysyms "XK_Arabic_kasra"                                #x5f0)
  (def-x11-keysym arabic-keysyms "XK_Arabic_shadda"                               #x5f1)
  (def-x11-keysym arabic-keysyms "XK_Arabic_sukun"                                #x5f2)
  (def-x11-keysym arabic-keysyms "XK_Arabic_switch"        #xFF7E)  ;; Alias for mode_switch 
) 


#+ignore
(progn 
  (def-x11-keysym cyrillic-keysyms "XK_Serbian_dje"                                 #x6a1)
  (def-x11-keysym cyrillic-keysyms "XK_Macedonia_gje"                               #x6a2)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_io"                                 #x6a3)
  (def-x11-keysym cyrillic-keysyms "XK_Ukrainian_ie"                                #x6a4)
  (def-x11-keysym cyrillic-keysyms "XK_Ukranian_je"                                 #x6a4)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Macedonia_dse"                               #x6a5)
  (def-x11-keysym cyrillic-keysyms "XK_Ukrainian_i"                                 #x6a6)
  (def-x11-keysym cyrillic-keysyms "XK_Ukranian_i"                                  #x6a6)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Ukrainian_yi"                                #x6a7)
  (def-x11-keysym cyrillic-keysyms "XK_Ukranian_yi"                                 #x6a7)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_je"                                 #x6a8)
  (def-x11-keysym cyrillic-keysyms "XK_Serbian_je"                                  #x6a8)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_lje"                                #x6a9)
  (def-x11-keysym cyrillic-keysyms "XK_Serbian_lje"                                 #x6a9)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_nje"                                #x6aa)
  (def-x11-keysym cyrillic-keysyms "XK_Serbian_nje"                                 #x6aa)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Serbian_tshe"                                #x6ab)
  (def-x11-keysym cyrillic-keysyms "XK_Macedonia_kje"                               #x6ac)
  (def-x11-keysym cyrillic-keysyms "XK_Byelorussian_shortu"                         #x6ae)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_dzhe"                               #x6af)
  (def-x11-keysym cyrillic-keysyms "XK_Serbian_dze"                                 #x6af)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_numerosign"                                  #x6b0)
  (def-x11-keysym cyrillic-keysyms "XK_Serbian_DJE"                                 #x6b1)
  (def-x11-keysym cyrillic-keysyms "XK_Macedonia_GJE"                               #x6b2)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_IO"                                 #x6b3)
  (def-x11-keysym cyrillic-keysyms "XK_Ukrainian_IE"                                #x6b4)
  (def-x11-keysym cyrillic-keysyms "XK_Ukranian_JE"                                 #x6b4)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Macedonia_DSE"                               #x6b5)
  (def-x11-keysym cyrillic-keysyms "XK_Ukrainian_I"                                 #x6b6)
  (def-x11-keysym cyrillic-keysyms "XK_Ukranian_I"                                  #x6b6)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Ukrainian_YI"                                #x6b7)
  (def-x11-keysym cyrillic-keysyms "XK_Ukranian_YI"                                 #x6b7)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_JE"                                 #x6b8)
  (def-x11-keysym cyrillic-keysyms "XK_Serbian_JE"                                  #x6b8)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_LJE"                                #x6b9)
  (def-x11-keysym cyrillic-keysyms "XK_Serbian_LJE"                                 #x6b9)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_NJE"                                #x6ba)
  (def-x11-keysym cyrillic-keysyms "XK_Serbian_NJE"                                 #x6ba)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Serbian_TSHE"                                #x6bb)
  (def-x11-keysym cyrillic-keysyms "XK_Macedonia_KJE"                               #x6bc)
  (def-x11-keysym cyrillic-keysyms "XK_Byelorussian_SHORTU"                         #x6be)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_DZHE"                               #x6bf)
  (def-x11-keysym cyrillic-keysyms "XK_Serbian_DZE"                                 #x6bf)  ;; deprecated 
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_yu"                                 #x6c0)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_a"                                  #x6c1)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_be"                                 #x6c2)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_tse"                                #x6c3)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_de"                                 #x6c4)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_ie"                                 #x6c5)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_ef"                                 #x6c6)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_ghe"                                #x6c7)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_ha"                                 #x6c8)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_i"                                  #x6c9)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_shorti"                             #x6ca)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_ka"                                 #x6cb)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_el"                                 #x6cc)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_em"                                 #x6cd)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_en"                                 #x6ce)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_o"                                  #x6cf)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_pe"                                 #x6d0)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_ya"                                 #x6d1)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_er"                                 #x6d2)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_es"                                 #x6d3)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_te"                                 #x6d4)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_u"                                  #x6d5)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_zhe"                                #x6d6)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_ve"                                 #x6d7)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_softsign"                           #x6d8)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_yeru"                               #x6d9)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_ze"                                 #x6da)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_sha"                                #x6db)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_e"                                  #x6dc)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_shcha"                              #x6dd)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_che"                                #x6de)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_hardsign"                           #x6df)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_YU"                                 #x6e0)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_A"                                  #x6e1)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_BE"                                 #x6e2)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_TSE"                                #x6e3)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_DE"                                 #x6e4)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_IE"                                 #x6e5)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_EF"                                 #x6e6)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_GHE"                                #x6e7)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_HA"                                 #x6e8)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_I"                                  #x6e9)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_SHORTI"                             #x6ea)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_KA"                                 #x6eb)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_EL"                                 #x6ec)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_EM"                                 #x6ed)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_EN"                                 #x6ee)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_O"                                  #x6ef)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_PE"                                 #x6f0)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_YA"                                 #x6f1)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_ER"                                 #x6f2)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_ES"                                 #x6f3)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_TE"                                 #x6f4)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_U"                                  #x6f5)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_ZHE"                                #x6f6)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_VE"                                 #x6f7)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_SOFTSIGN"                           #x6f8)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_YERU"                               #x6f9)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_ZE"                                 #x6fa)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_SHA"                                #x6fb)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_E"                                  #x6fc)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_SHCHA"                              #x6fd)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_CHE"                                #x6fe)
  (def-x11-keysym cyrillic-keysyms "XK_Cyrillic_HARDSIGN"                           #x6ff)
) 


#+ignore
(progn 
  (def-x11-keysym greek-keysyms "XK_Greek_ALPHAaccent"                           #x7a1)
  (def-x11-keysym greek-keysyms "XK_Greek_EPSILONaccent"                         #x7a2)
  (def-x11-keysym greek-keysyms "XK_Greek_ETAaccent"                             #x7a3)
  (def-x11-keysym greek-keysyms "XK_Greek_IOTAaccent"                            #x7a4)
  (def-x11-keysym greek-keysyms "XK_Greek_IOTAdiaeresis"                         #x7a5)
  (def-x11-keysym greek-keysyms "XK_Greek_OMICRONaccent"                         #x7a7)
  (def-x11-keysym greek-keysyms "XK_Greek_UPSILONaccent"                         #x7a8)
  (def-x11-keysym greek-keysyms "XK_Greek_UPSILONdieresis"                       #x7a9)
  (def-x11-keysym greek-keysyms "XK_Greek_OMEGAaccent"                           #x7ab)
  (def-x11-keysym greek-keysyms "XK_Greek_accentdieresis"                        #x7ae)
  (def-x11-keysym greek-keysyms "XK_Greek_horizbar"                              #x7af)
  (def-x11-keysym greek-keysyms "XK_Greek_alphaaccent"                           #x7b1)
  (def-x11-keysym greek-keysyms "XK_Greek_epsilonaccent"                         #x7b2)
  (def-x11-keysym greek-keysyms "XK_Greek_etaaccent"                             #x7b3)
  (def-x11-keysym greek-keysyms "XK_Greek_iotaaccent"                            #x7b4)
  (def-x11-keysym greek-keysyms "XK_Greek_iotadieresis"                          #x7b5)
  (def-x11-keysym greek-keysyms "XK_Greek_iotaaccentdieresis"                    #x7b6)
  (def-x11-keysym greek-keysyms "XK_Greek_omicronaccent"                         #x7b7)
  (def-x11-keysym greek-keysyms "XK_Greek_upsilonaccent"                         #x7b8)
  (def-x11-keysym greek-keysyms "XK_Greek_upsilondieresis"                       #x7b9)
  (def-x11-keysym greek-keysyms "XK_Greek_upsilonaccentdieresis"                 #x7ba)
  (def-x11-keysym greek-keysyms "XK_Greek_omegaaccent"                           #x7bb)
  (def-x11-keysym greek-keysyms "XK_Greek_ALPHA"                                 #x7c1)
  (def-x11-keysym greek-keysyms "XK_Greek_BETA"                                  #x7c2)
  (def-x11-keysym greek-keysyms "XK_Greek_GAMMA"                                 #x7c3)
  (def-x11-keysym greek-keysyms "XK_Greek_DELTA"                                 #x7c4)
  (def-x11-keysym greek-keysyms "XK_Greek_EPSILON"                               #x7c5)
  (def-x11-keysym greek-keysyms "XK_Greek_ZETA"                                  #x7c6)
  (def-x11-keysym greek-keysyms "XK_Greek_ETA"                                   #x7c7)
  (def-x11-keysym greek-keysyms "XK_Greek_THETA"                                 #x7c8)
  (def-x11-keysym greek-keysyms "XK_Greek_IOTA"                                  #x7c9)
  (def-x11-keysym greek-keysyms "XK_Greek_KAPPA"                                 #x7ca)
  (def-x11-keysym greek-keysyms "XK_Greek_LAMDA"                                 #x7cb)
  (def-x11-keysym greek-keysyms "XK_Greek_LAMBDA"                                #x7cb)
  (def-x11-keysym greek-keysyms "XK_Greek_MU"                                    #x7cc)
  (def-x11-keysym greek-keysyms "XK_Greek_NU"                                    #x7cd)
  (def-x11-keysym greek-keysyms "XK_Greek_XI"                                    #x7ce)
  (def-x11-keysym greek-keysyms "XK_Greek_OMICRON"                               #x7cf)
  (def-x11-keysym greek-keysyms "XK_Greek_PI"                                    #x7d0)
  (def-x11-keysym greek-keysyms "XK_Greek_RHO"                                   #x7d1)
  (def-x11-keysym greek-keysyms "XK_Greek_SIGMA"                                 #x7d2)
  (def-x11-keysym greek-keysyms "XK_Greek_TAU"                                   #x7d4)
  (def-x11-keysym greek-keysyms "XK_Greek_UPSILON"                               #x7d5)
  (def-x11-keysym greek-keysyms "XK_Greek_PHI"                                   #x7d6)
  (def-x11-keysym greek-keysyms "XK_Greek_CHI"                                   #x7d7)
  (def-x11-keysym greek-keysyms "XK_Greek_PSI"                                   #x7d8)
  (def-x11-keysym greek-keysyms "XK_Greek_OMEGA"                                 #x7d9)
  (def-x11-keysym greek-keysyms "XK_Greek_alpha"                                 #x7e1)
  (def-x11-keysym greek-keysyms "XK_Greek_beta"                                  #x7e2)
  (def-x11-keysym greek-keysyms "XK_Greek_gamma"                                 #x7e3)
  (def-x11-keysym greek-keysyms "XK_Greek_delta"                                 #x7e4)
  (def-x11-keysym greek-keysyms "XK_Greek_epsilon"                               #x7e5)
  (def-x11-keysym greek-keysyms "XK_Greek_zeta"                                  #x7e6)
  (def-x11-keysym greek-keysyms "XK_Greek_eta"                                   #x7e7)
  (def-x11-keysym greek-keysyms "XK_Greek_theta"                                 #x7e8)
  (def-x11-keysym greek-keysyms "XK_Greek_iota"                                  #x7e9)
  (def-x11-keysym greek-keysyms "XK_Greek_kappa"                                 #x7ea)
  (def-x11-keysym greek-keysyms "XK_Greek_lamda"                                 #x7eb)
  (def-x11-keysym greek-keysyms "XK_Greek_lambda"                                #x7eb)
  (def-x11-keysym greek-keysyms "XK_Greek_mu"                                    #x7ec)
  (def-x11-keysym greek-keysyms "XK_Greek_nu"                                    #x7ed)
  (def-x11-keysym greek-keysyms "XK_Greek_xi"                                    #x7ee)
  (def-x11-keysym greek-keysyms "XK_Greek_omicron"                               #x7ef)
  (def-x11-keysym greek-keysyms "XK_Greek_pi"                                    #x7f0)
  (def-x11-keysym greek-keysyms "XK_Greek_rho"                                   #x7f1)
  (def-x11-keysym greek-keysyms "XK_Greek_sigma"                                 #x7f2)
  (def-x11-keysym greek-keysyms "XK_Greek_finalsmallsigma"                       #x7f3)
  (def-x11-keysym greek-keysyms "XK_Greek_tau"                                   #x7f4)
  (def-x11-keysym greek-keysyms "XK_Greek_upsilon"                               #x7f5)
  (def-x11-keysym greek-keysyms "XK_Greek_phi"                                   #x7f6)
  (def-x11-keysym greek-keysyms "XK_Greek_chi"                                   #x7f7)
  (def-x11-keysym greek-keysyms "XK_Greek_psi"                                   #x7f8)
  (def-x11-keysym greek-keysyms "XK_Greek_omega"                                 #x7f9)
  (def-x11-keysym greek-keysyms "XK_Greek_switch"         #xFF7E)  ;; Alias for mode_switch 
) 


#+ignore
(progn 
  (def-x11-keysym technical-keysyms "XK_leftradical"                                 #x8a1)
  (def-x11-keysym technical-keysyms "XK_topleftradical"                              #x8a2)
  (def-x11-keysym technical-keysyms "XK_horizconnector"                              #x8a3)
  (def-x11-keysym technical-keysyms "XK_topintegral"                                 #x8a4)
  (def-x11-keysym technical-keysyms "XK_botintegral"                                 #x8a5)
  (def-x11-keysym technical-keysyms "XK_vertconnector"                               #x8a6)
  (def-x11-keysym technical-keysyms "XK_topleftsqbracket"                            #x8a7)
  (def-x11-keysym technical-keysyms "XK_botleftsqbracket"                            #x8a8)
  (def-x11-keysym technical-keysyms "XK_toprightsqbracket"                           #x8a9)
  (def-x11-keysym technical-keysyms "XK_botrightsqbracket"                           #x8aa)
  (def-x11-keysym technical-keysyms "XK_topleftparens"                               #x8ab)
  (def-x11-keysym technical-keysyms "XK_botleftparens"                               #x8ac)
  (def-x11-keysym technical-keysyms "XK_toprightparens"                              #x8ad)
  (def-x11-keysym technical-keysyms "XK_botrightparens"                              #x8ae)
  (def-x11-keysym technical-keysyms "XK_leftmiddlecurlybrace"                        #x8af)
  (def-x11-keysym technical-keysyms "XK_rightmiddlecurlybrace"                       #x8b0)
  (def-x11-keysym technical-keysyms "XK_topleftsummation"                            #x8b1)
  (def-x11-keysym technical-keysyms "XK_botleftsummation"                            #x8b2)
  (def-x11-keysym technical-keysyms "XK_topvertsummationconnector"                   #x8b3)
  (def-x11-keysym technical-keysyms "XK_botvertsummationconnector"                   #x8b4)
  (def-x11-keysym technical-keysyms "XK_toprightsummation"                           #x8b5)
  (def-x11-keysym technical-keysyms "XK_botrightsummation"                           #x8b6)
  (def-x11-keysym technical-keysyms "XK_rightmiddlesummation"                        #x8b7)
  (def-x11-keysym technical-keysyms "XK_lessthanequal"                               #x8bc)
  (def-x11-keysym technical-keysyms "XK_notequal"                                    #x8bd)
  (def-x11-keysym technical-keysyms "XK_greaterthanequal"                            #x8be)
  (def-x11-keysym technical-keysyms "XK_integral"                                    #x8bf)
  (def-x11-keysym technical-keysyms "XK_therefore"                                   #x8c0)
  (def-x11-keysym technical-keysyms "XK_variation"                                   #x8c1)
  (def-x11-keysym technical-keysyms "XK_infinity"                                    #x8c2)
  (def-x11-keysym technical-keysyms "XK_nabla"                                       #x8c5)
  (def-x11-keysym technical-keysyms "XK_approximate"                                 #x8c8)
  (def-x11-keysym technical-keysyms "XK_similarequal"                                #x8c9)
  (def-x11-keysym technical-keysyms "XK_ifonlyif"                                    #x8cd)
  (def-x11-keysym technical-keysyms "XK_implies"                                     #x8ce)
  (def-x11-keysym technical-keysyms "XK_identical"                                   #x8cf)
  (def-x11-keysym technical-keysyms "XK_radical"                                     #x8d6)
  (def-x11-keysym technical-keysyms "XK_includedin"                                  #x8da)
  (def-x11-keysym technical-keysyms "XK_includes"                                    #x8db)
  (def-x11-keysym technical-keysyms "XK_intersection"                                #x8dc)
  (def-x11-keysym technical-keysyms "XK_union"                                       #x8dd)
  (def-x11-keysym technical-keysyms "XK_logicaland"                                  #x8de)
  (def-x11-keysym technical-keysyms "XK_logicalor"                                   #x8df)
  (def-x11-keysym technical-keysyms "XK_partialderivative"                           #x8ef)
  (def-x11-keysym technical-keysyms "XK_function"                                    #x8f6)
  (def-x11-keysym technical-keysyms "XK_leftarrow"                                   #x8fb)
  (def-x11-keysym technical-keysyms "XK_uparrow"                                     #x8fc)
  (def-x11-keysym technical-keysyms "XK_rightarrow"                                  #x8fd)
  (def-x11-keysym technical-keysyms "XK_downarrow"                                   #x8fe)
) 


#+ignore 
(progn
  (def-x11-keysym special-keysyms "XK_blank"                                       #x9df)
  (def-x11-keysym special-keysyms "XK_soliddiamond"                                #x9e0)
  (def-x11-keysym special-keysyms "XK_checkerboard"                                #x9e1)
  (def-x11-keysym special-keysyms "XK_ht"                                          #x9e2)
  (def-x11-keysym special-keysyms "XK_ff"                                          #x9e3)
  (def-x11-keysym special-keysyms "XK_cr"                                          #x9e4)
  (def-x11-keysym special-keysyms "XK_lf"                                          #x9e5)
  (def-x11-keysym special-keysyms "XK_nl"                                          #x9e8)
  (def-x11-keysym special-keysyms "XK_vt"                                          #x9e9)
  (def-x11-keysym special-keysyms "XK_lowrightcorner"                              #x9ea)
  (def-x11-keysym special-keysyms "XK_uprightcorner"                               #x9eb)
  (def-x11-keysym special-keysyms "XK_upleftcorner"                                #x9ec)
  (def-x11-keysym special-keysyms "XK_lowleftcorner"                               #x9ed)
  (def-x11-keysym special-keysyms "XK_crossinglines"                               #x9ee)
  (def-x11-keysym special-keysyms "XK_horizlinescan1"                              #x9ef)
  (def-x11-keysym special-keysyms "XK_horizlinescan3"                              #x9f0)
  (def-x11-keysym special-keysyms "XK_horizlinescan5"                              #x9f1)
  (def-x11-keysym special-keysyms "XK_horizlinescan7"                              #x9f2)
  (def-x11-keysym special-keysyms "XK_horizlinescan9"                              #x9f3)
  (def-x11-keysym special-keysyms "XK_leftt"                                       #x9f4)
  (def-x11-keysym special-keysyms "XK_rightt"                                      #x9f5)
  (def-x11-keysym special-keysyms "XK_bott"                                        #x9f6)
  (def-x11-keysym special-keysyms "XK_topt"                                        #x9f7)
  (def-x11-keysym special-keysyms "XK_vertbar"                                     #x9f8)
) 



#+ignore
(progn
  (def-x11-keysym publishing-keysyms "XK_emspace"                                     #xaa1)
  (def-x11-keysym publishing-keysyms "XK_enspace"                                     #xaa2)
  (def-x11-keysym publishing-keysyms "XK_em3space"                                    #xaa3)
  (def-x11-keysym publishing-keysyms "XK_em4space"                                    #xaa4)
  (def-x11-keysym publishing-keysyms "XK_digitspace"                                  #xaa5)
  (def-x11-keysym publishing-keysyms "XK_punctspace"                                  #xaa6)
  (def-x11-keysym publishing-keysyms "XK_thinspace"                                   #xaa7)
  (def-x11-keysym publishing-keysyms "XK_hairspace"                                   #xaa8)
  (def-x11-keysym publishing-keysyms "XK_emdash"                                      #xaa9)
  (def-x11-keysym publishing-keysyms "XK_endash"                                      #xaaa)
  (def-x11-keysym publishing-keysyms "XK_signifblank"                                 #xaac)
  (def-x11-keysym publishing-keysyms "XK_ellipsis"                                    #xaae)
  (def-x11-keysym publishing-keysyms "XK_doubbaselinedot"                             #xaaf)
  (def-x11-keysym publishing-keysyms "XK_onethird"                                    #xab0)
  (def-x11-keysym publishing-keysyms "XK_twothirds"                                   #xab1)
  (def-x11-keysym publishing-keysyms "XK_onefifth"                                    #xab2)
  (def-x11-keysym publishing-keysyms "XK_twofifths"                                   #xab3)
  (def-x11-keysym publishing-keysyms "XK_threefifths"                                 #xab4)
  (def-x11-keysym publishing-keysyms "XK_fourfifths"                                  #xab5)
  (def-x11-keysym publishing-keysyms "XK_onesixth"                                    #xab6)
  (def-x11-keysym publishing-keysyms "XK_fivesixths"                                  #xab7)
  (def-x11-keysym publishing-keysyms "XK_careof"                                      #xab8)
  (def-x11-keysym publishing-keysyms "XK_figdash"                                     #xabb)
  (def-x11-keysym publishing-keysyms "XK_leftanglebracket"                            #xabc)
  (def-x11-keysym publishing-keysyms "XK_decimalpoint"                                #xabd)
  (def-x11-keysym publishing-keysyms "XK_rightanglebracket"                           #xabe)
  (def-x11-keysym publishing-keysyms "XK_marker"                                      #xabf)
  (def-x11-keysym publishing-keysyms "XK_oneeighth"                                   #xac3)
  (def-x11-keysym publishing-keysyms "XK_threeeighths"                                #xac4)
  (def-x11-keysym publishing-keysyms "XK_fiveeighths"                                 #xac5)
  (def-x11-keysym publishing-keysyms "XK_seveneighths"                                #xac6)
  (def-x11-keysym publishing-keysyms "XK_trademark"                                   #xac9)
  (def-x11-keysym publishing-keysyms "XK_signaturemark"                               #xaca)
  (def-x11-keysym publishing-keysyms "XK_trademarkincircle"                           #xacb)
  (def-x11-keysym publishing-keysyms "XK_leftopentriangle"                            #xacc)
  (def-x11-keysym publishing-keysyms "XK_rightopentriangle"                           #xacd)
  (def-x11-keysym publishing-keysyms "XK_emopencircle"                                #xace)
  (def-x11-keysym publishing-keysyms "XK_emopenrectangle"                             #xacf)
  (def-x11-keysym publishing-keysyms "XK_leftsinglequotemark"                         #xad0)
  (def-x11-keysym publishing-keysyms "XK_rightsinglequotemark"                        #xad1)
  (def-x11-keysym publishing-keysyms "XK_leftdoublequotemark"                         #xad2)
  (def-x11-keysym publishing-keysyms "XK_rightdoublequotemark"                        #xad3)
  (def-x11-keysym publishing-keysyms "XK_prescription"                                #xad4)
  (def-x11-keysym publishing-keysyms "XK_minutes"                                     #xad6)
  (def-x11-keysym publishing-keysyms "XK_seconds"                                     #xad7)
  (def-x11-keysym publishing-keysyms "XK_latincross"                                  #xad9)
  (def-x11-keysym publishing-keysyms "XK_hexagram"                                    #xada)
  (def-x11-keysym publishing-keysyms "XK_filledrectbullet"                            #xadb)
  (def-x11-keysym publishing-keysyms "XK_filledlefttribullet"                         #xadc)
  (def-x11-keysym publishing-keysyms "XK_filledrighttribullet"                        #xadd)
  (def-x11-keysym publishing-keysyms "XK_emfilledcircle"                              #xade)
  (def-x11-keysym publishing-keysyms "XK_emfilledrect"                                #xadf)
  (def-x11-keysym publishing-keysyms "XK_enopencircbullet"                            #xae0)
  (def-x11-keysym publishing-keysyms "XK_enopensquarebullet"                          #xae1)
  (def-x11-keysym publishing-keysyms "XK_openrectbullet"                              #xae2)
  (def-x11-keysym publishing-keysyms "XK_opentribulletup"                             #xae3)
  (def-x11-keysym publishing-keysyms "XK_opentribulletdown"                           #xae4)
  (def-x11-keysym publishing-keysyms "XK_openstar"                                    #xae5)
  (def-x11-keysym publishing-keysyms "XK_enfilledcircbullet"                          #xae6)
  (def-x11-keysym publishing-keysyms "XK_enfilledsqbullet"                            #xae7)
  (def-x11-keysym publishing-keysyms "XK_filledtribulletup"                           #xae8)
  (def-x11-keysym publishing-keysyms "XK_filledtribulletdown"                         #xae9)
  (def-x11-keysym publishing-keysyms "XK_leftpointer"                                 #xaea)
  (def-x11-keysym publishing-keysyms "XK_rightpointer"                                #xaeb)
  (def-x11-keysym publishing-keysyms "XK_club"                                        #xaec)
  (def-x11-keysym publishing-keysyms "XK_diamond"                                     #xaed)
  (def-x11-keysym publishing-keysyms "XK_heart"                                       #xaee)
  (def-x11-keysym publishing-keysyms "XK_maltesecross"                                #xaf0)
  (def-x11-keysym publishing-keysyms "XK_dagger"                                      #xaf1)
  (def-x11-keysym publishing-keysyms "XK_doubledagger"                                #xaf2)
  (def-x11-keysym publishing-keysyms "XK_checkmark"                                   #xaf3)
  (def-x11-keysym publishing-keysyms "XK_ballotcross"                                 #xaf4)
  (def-x11-keysym publishing-keysyms "XK_musicalsharp"                                #xaf5)
  (def-x11-keysym publishing-keysyms "XK_musicalflat"                                 #xaf6)
  (def-x11-keysym publishing-keysyms "XK_malesymbol"                                  #xaf7)
  (def-x11-keysym publishing-keysyms "XK_femalesymbol"                                #xaf8)
  (def-x11-keysym publishing-keysyms "XK_telephone"                                   #xaf9)
  (def-x11-keysym publishing-keysyms "XK_telephonerecorder"                           #xafa)
  (def-x11-keysym publishing-keysyms "XK_phonographcopyright"                         #xafb)
  (def-x11-keysym publishing-keysyms "XK_caret"                                       #xafc)
  (def-x11-keysym publishing-keysyms "XK_singlelowquotemark"                          #xafd)
  (def-x11-keysym publishing-keysyms "XK_doublelowquotemark"                          #xafe)
  (def-x11-keysym publishing-keysyms "XK_cursor"                                      #xaff)
) 


#+ignore
(progn 
  (def-x11-keysym apl-keysyms "XK_leftcaret"                                   #xba3)
  (def-x11-keysym apl-keysyms "XK_rightcaret"                                  #xba6)
  (def-x11-keysym apl-keysyms "XK_downcaret"                                   #xba8)
  (def-x11-keysym apl-keysyms "XK_upcaret"                                     #xba9)
  (def-x11-keysym apl-keysyms "XK_overbar"                                     #xbc0)
  (def-x11-keysym apl-keysyms "XK_downtack"                                    #xbc2)
  (def-x11-keysym apl-keysyms "XK_upshoe"                                      #xbc3)
  (def-x11-keysym apl-keysyms "XK_downstile"                                   #xbc4)
  (def-x11-keysym apl-keysyms "XK_underbar"                                    #xbc6)
  (def-x11-keysym apl-keysyms "XK_jot"                                         #xbca)
  (def-x11-keysym apl-keysyms "XK_quad"                                        #xbcc)
  (def-x11-keysym apl-keysyms "XK_uptack"                                      #xbce)
  (def-x11-keysym apl-keysyms "XK_circle"                                      #xbcf)
  (def-x11-keysym apl-keysyms "XK_upstile"                                     #xbd3)
  (def-x11-keysym apl-keysyms "XK_downshoe"                                    #xbd6)
  (def-x11-keysym apl-keysyms "XK_rightshoe"                                   #xbd8)
  (def-x11-keysym apl-keysyms "XK_leftshoe"                                    #xbda)
  (def-x11-keysym apl-keysyms "XK_lefttack"                                    #xbdc)
  (def-x11-keysym apl-keysyms "XK_righttack"                                   #xbfc)
) 



#+ignore
(progn
  (def-x11-keysym hebrew-keysyms "XK_hebrew_doublelowline"                        #xcdf)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_aleph"                                #xce0)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_bet"                                  #xce1)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_beth"                                 #xce1)  ;; deprecated 
  (def-x11-keysym hebrew-keysyms "XK_hebrew_gimel"                                #xce2)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_gimmel"                               #xce2)  ;; deprecated 
  (def-x11-keysym hebrew-keysyms "XK_hebrew_dalet"                                #xce3)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_daleth"                               #xce3)  ;; deprecated 
  (def-x11-keysym hebrew-keysyms "XK_hebrew_he"                                   #xce4)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_waw"                                  #xce5)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_zain"                                 #xce6)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_zayin"                                #xce6)  ;; deprecated 
  (def-x11-keysym hebrew-keysyms "XK_hebrew_chet"                                 #xce7)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_het"                                  #xce7)  ;; deprecated 
  (def-x11-keysym hebrew-keysyms "XK_hebrew_tet"                                  #xce8)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_teth"                                 #xce8)  ;; deprecated 
  (def-x11-keysym hebrew-keysyms "XK_hebrew_yod"                                  #xce9)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_finalkaph"                            #xcea)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_kaph"                                 #xceb)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_lamed"                                #xcec)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_finalmem"                             #xced)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_mem"                                  #xcee)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_finalnun"                             #xcef)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_nun"                                  #xcf0)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_samech"                               #xcf1)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_samekh"                               #xcf1)  ;; deprecated 
  (def-x11-keysym hebrew-keysyms "XK_hebrew_ayin"                                 #xcf2)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_finalpe"                              #xcf3)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_pe"                                   #xcf4)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_finalzade"                            #xcf5)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_finalzadi"                            #xcf5)  ;; deprecated 
  (def-x11-keysym hebrew-keysyms "XK_hebrew_zade"                                 #xcf6)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_zadi"                                 #xcf6)  ;; deprecated 
  (def-x11-keysym hebrew-keysyms "XK_hebrew_qoph"                                 #xcf7)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_kuf"                                  #xcf7)  ;; deprecated 
  (def-x11-keysym hebrew-keysyms "XK_hebrew_resh"                                 #xcf8)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_shin"                                 #xcf9)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_taw"                                  #xcfa)
  (def-x11-keysym hebrew-keysyms "XK_hebrew_taf"                                  #xcfa)  ;; deprecated 
  (def-x11-keysym hebrew-keysyms "XK_Hebrew_switch"        #xFF7E)  ;; Alias for mode_switch 
)

