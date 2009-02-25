;;;; Multimethods

(def good #{"Yacin" "Clojure" "JVM"})
(def bad #{"Java" "OOP"})

(defmulti opinion (fn [name] (contains? good name)))

(defmethod opinion true [name]
  (str name " totally rules!"))

(defmethod opinion false [name]
  (str name " totally sucks!"))