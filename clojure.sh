#!/bin/bash

BREAK_CHARS="(){}[],^%$#@\"\";:''|\\"
CLOJURE_DIR=/Users/ynadji/Code/Lisp/clojure/trunk
CLOJURE_JAR=$CLOJURE_DIR/clojure.jar:/Users/ynadji/Code/Lisp/clojure-contrib/clojure-contrib.jar:$CLOJURE_DIR/classes:/Users/ynadji/.clojure:$CLASSPATH
if [ $# -eq 0 ]; then 
	rlwrap --remember -c -b $BREAK_CHARS -f $HOME/.clj_completions \
	java -server -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8888 -cp $CLOJURE_JAR clojure.lang.Repl
else
	java -server -Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=8888 -cp $CLOJURE_JAR clojure.lang.Script "$@"
fi
