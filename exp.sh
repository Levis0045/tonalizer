#! /bin/bash

set -vx

GIT_VERSION="$(git rev-parse HEAD)"
NOM=exp_$(date +%d_%H_%M)_"$GIT_VERSION"

BASIC_OPTIONS="-v -l $NOM"
SUPP_OPTIONS="--filtering"

KEYWORD="Seconds required for this iteration: |Error norm|Iteration #"
KEYWORD2="[^_]diacritic_only|chunkmode|filtering|no_coding|no_decomposition|r_E|accuracy|done|eval|total|[./]{3,}"
FP_PAT="[-+]?[0-9]+\.?[0-9]*"

touch "$NOM.log"

evalsize=99
VAR_OPTS="-e $evalsize -s "$NOM"_evalsize_"$evalsize".csv"
if hash stdbuf 2>/dev/null; then
stdbuf -oL python tonalizer.py $VAR_OPTS $SUPP_OPTIONS $BASIC_OPTIONS \
| gawk "BEGIN{IGNORECASE=1} /.*($KEYWORD2).*/ {print \$0} match(\$0, /.*($KEYWORD)[^.0-9+-]*($FP_PAT)/, ary) {print ary[2]}" \
>> "$NOM.log"
else
gstdbuf -oL python tonalizer.py $VAR_OPTS $SUPP_OPTIONS $BASIC_OPTIONS \
| gawk "BEGIN{IGNORECASE=1} /.*($KEYWORD2).*/ {print \$0} match(\$0, /.*($KEYWORD)[^.0-9+-]*($FP_PAT)/, ary) {print ary[2]}" \
>> "$NOM.log"
fi
