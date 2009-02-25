;;;; Basic refs

(def current-class (ref "CS 430: Algorithms"))

;; current-class

;; (deref current-class)
;; @current-class

(ref-set current-class "CS 440: Programming Languages and Translators")

(dosync (ref-set current-class "CS 440: Programming Languages and Translators"))

;;;; Commute

(def homework (ref ()))

(defn add-assignment [new-hwk]
  (dosync (commute homework conj new-hwk)))

;; Alter

(defn add-assignment-preserve-order [new-hwk]
  (dosync (alter homework conj new-hwk)))