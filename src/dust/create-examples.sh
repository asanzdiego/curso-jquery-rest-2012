#! /bin/bash

GLOBAL_DIRECTORY=`pwd`
GLOBAL_DIRECTORY_LENGTH=${#GLOBAL_DIRECTORY}
GLOBAL_LOG=$GLOBAL_DIRECTORY/create-examples.log

echo "" > $GLOBAL_LOG

function listDirectory() {

  local HTML=" "
  local LEVEL=$1
  local HEADER_LEVEL=$(($LEVEL+1))
  local SPACES="\b"
  local HTML_SPACES=""

  for i in `seq 1 $LEVEL` ; do
    SPACES="$SPACES\b"
    HTML_SPACES="$HTML_SPACES&nbsp;"
  done

  local LOCAL_DIRECTORY=`pwd`
  local LOCAL_DIRECTORY_LENGTH=${#LOCAL_DIRECTORY}
  local DIRECTORY=${LOCAL_DIRECTORY:$GLOBAL_DIRECTORY_LENGTH}
  local DIRECTORY_NAME=${DIRECTORY##*/}

  echo -e "$SPACES$DIRECTORY_NAME" >> $GLOBAL_LOG

  HTML="$HTML$SPACES<h$HEADER_LEVEL>$HTML_SPACES$DIRECTORY_NAME</h$HEADER_LEVEL>"
  HTML="$HTML\n$SPACES<div>"

  for FILE in *; do

    # is a directory
    if [ -d $FILE ]; then

      cd $FILE
      HTML="$HTML\n`listDirectory $(($LEVEL+1))`"
      cd - >> /dev/null

    elif [ "${FILE#*.}" == "html" ]; then

        echo -e "$SPACES $FILE" >> $GLOBAL_LOG

        FILE_WITHOUT_EXTENSION=${FILE%%.*}

        HTML="$HTML\n$SPACES\b<br/>$HTML_SPACES&nbsp;&nbsp;<a href=\"show-example.html?url="
        HTML="$HTML$DIRECTORY/$FILE_WITHOUT_EXTENSION\""
        HTML="$HTML target=\"show-example\">"
        HTML="$HTML$FILE_WITHOUT_EXTENSION</a>"
    fi

  done

  HTML="$HTML\n$SPACES</div>"

  echo $HTML
}

HTML=$(cat <<EOF
<html>
 <head>
  <title>Examples</title>
  <script src="../jquery.js"></script>
  <script>
    \$(document).ready(function(){
      \$(":header").css("margin", "0px");
      \$(":header").click(function(){
        \$(this).next("div").toggle("fast");
      });
      \$("#show").click(function(){
        \$("div").show("fast");
      });
      \$("#hide").click(function(){
        \$("div").hide("fast");
      });
    });
  </script>
  <style>
    div {
      display: none;
    }
    h2 {
      background-color: grey;
    }
  </style>
 </head>
 <body>
  <a id="show" href="#">show all</a> | <a id="hide" href="#">hide all</a> <br />
EOF
)

for FILE in *; do
  # is a directory
  if [ -d $FILE -a "$FILE" != "exclude" ]; then
    cd $FILE
    HTML="$HTML\n`listDirectory 1`"
    cd - >> /dev/null
  fi
done

HTML="$HTML\n </body>"
HTML="$HTML\n</html>"

echo -e "$HTML" > examples.html
