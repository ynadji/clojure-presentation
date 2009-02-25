;;;; Agents

(def num-visitors (agent 0))

;; (deref num-visitors)
;; @num-visitors

(defn increment-by [n]
  (send num-visitors (fn [x] (+ x n))))