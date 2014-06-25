#!/bin/bash

# Define colors
CBLACK=$'\[\033[0;30m\]'
CGRAY=$'\[\033[1;30m\]'
CBLUE=$'\[\033[0;34m\]'
CLTBLUE=$'\[\033[1;34m\]'
CGREEN=$'\[\033[0;32m\]'
CLTGREEN=$'\[\033[1;32m\]'
CCYAN=$'\[\033[0;36m\]'
CLTCYAN=$'\[\033[1;36m\]'
CRED=$'\[\033[0;31m\]'
CLTRED=$'\[\033[1;31m\]'
CPURPLE=$'\[\033[0;35m\]'
CLTPURPLE=$'\[\033[1;35m\]'
CBROWN=$'\[\033[0;33m\]'
CYELLOW=$'\[\033[1;33m\]'
CLTGRAY=$'\[\033[0;37m\]'
CWHITE=$'\[\033[1;37m\]'

# Define unicode characters
UCURVEDR=$'\xe2\x95\xad'
UCURVEUR=$'\xe2\x95\xb0'
UCURVEDL=$'\xe2\x95\xae'
UCURVEUL=$'\xe2\x95\xaf'
UVERT=$'\xe2\x94\x82'
UHORIZ=$'\xe2\x94\x80'
UVERTL=$'\xe2\x94\xa4'
UVERTR=$'\xe2\x94\x9c'
UBENDDR=$'\xe2\x94\x8c'
UBENDUR=$'\xe2\x94\x94'

function dont_panic
{
echo $CYELLOW

echo '                          oooo$$$$$$$$$$$$oooo                             '
echo '                      oo$$$$$$$$$$$$$$$$$$$$$$$$o                          '
echo '                   oo$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o         o$   $$ o$    '
echo '   o $ oo        o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$o       $$ $$ $$o$   '
echo 'oo $ $ "$      o$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$o       $$$o$$o$    '
echo '"$$$$$$o$     o$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$o    $$$$$$$$     '
echo '  $$$$$$$    $$$$$$$$$$$      $$$$$$$$$$$      $$$$$$$$$$$$$$$$$$$$$$$     '
echo '  $$$$$$$$$$$$$$$$$$$$$$$    $$$$$$$$$$$$$    $$$$$$$$$$$$$$  """$$$       '
echo '   "$$$""""$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     "$$$      '
echo '    $$$   o$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     "$$$o    '
echo '   o$$"   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$       $$$o   '
echo '   $$$    $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$""$$$$$$ooooo$$$$o  '
echo '  o$$$oooo$$$$$  $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$  o$$$$$$$$$$$$$$$$$ '
echo '  $$$$$$$$"$$$$   $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$     $$$$""""""""      '
echo ' """"       $$$$    "$$$$$$$$$$$$$$$$$$$$$$$$$$$$"      o$$$               '
echo '            "$$$o     """$$$$$$$$$$$$$$$$$$"$$"         $$$                '
echo '              $$$o          "$$""$$$$$$""""           o$$$                 '
echo '               $$$$o                                o$$$"                  '
echo '                "$$$$o      o$$$$$$o"$$$$o        o$$$$                    '
echo '                  "$$$$$oo     ""$$$$o$$$$$o   o$$$$""                     ' 
echo '                     ""$$$$$oooo  "$$$o$$$$$$$$$"""                        '
echo '                        ""$$$$$$$oo $$$$$$$$$$                             '
echo '                                """"$$$$$$$$$$$                            '
echo '                                    $$$$$$$$$$$$                           '
echo '                                     $$$$$$$$$$"                           '
echo '                                      "$$$""""                             '
}

function rpt_horiz
{
	for (( i=0; i<$1; i++ ))
	do
		echo -n "${UHORIZ}"
	done
}

function tiny_tree
{
	HTREE=$(tree -L 2 -d --filelimit 10 .)
}

PSINDEX=0
MAXPSINDEX=2
# tiny
PSARRAY[0]="${CBLUE} \$ ${CCYAN}"
# small
PSARRAY[1]="${CBLUE}[ ${CLTBLUE}${USER::1}${CGRAY}@${CLTBLUE}${HOSTNAME::5} \
${CBLUE}: ${CLTBLUE}\W${CBLUE} ] \$ ${CCYAN}"
# basic info
USERATHOST="$USER@$HOSTNAME"
let "UATHLEN=${#USERATHOST}-6"

PSARRAY[2]="\
${CBLUE}\
 ${UCURVEDR} $(rpt_horiz $UATHLEN)${UCURVEDL}   \
${UCURVEDR} $(rpt_horiz 19)${UCURVEDL}\n\
${UBENDDR}${UVERT} ${CLTBLUE}\u${CGRAY}@${CLTBLUE}\h ${CBLUE}${UVERTR}${UHORIZ}${UHORIZ}\
${UVERTL} ${CLTBLUE}\d \t ${CBLUE}${UVERT}\n\
${UVERT}${UCURVEUR} $(rpt_horiz $UATHLEN)${UCURVEUL}   \
${UCURVEUR} $(rpt_horiz 19)${UCURVEUL}\n\
${UBENDUR}( ${CLTBLUE}\w ${CBLUE}) \$ ${CCYAN}"

function vm
{
	let "PSINDEX=$PSINDEX+1"
	if [ "$PSINDEX" -ge "$MAXPSINDEX" ]; then
		PSINDEX=$MAXPSINDEX
	fi
	PS1=${PSARRAY[$PSINDEX]}
	PROMPT_COMMAND=
}

function vl
{
	let "PSINDEX=$PSINDEX-1"
	if [ "$PSINDEX" -le "0" ]; then
		PSINDEX=0
	fi
	PS1=${PSARRAY[$PSINDEX]}
	PROMPT_COMMAND=
}

DEFAULT_COMMAND="if [ -d .git ]; then INGITDIR=1; else INGITDIR=; fi"
VTREE_COMMAND="tree -d -L 2 --filelimit=10 ."

function vtree
{
	if [ "$VTREE_COMMAND" != "$PROMPT_COMMAND" ]; then
		PROMPT_COMMAND=$VTREE_COMMAND
	else
		PROMPT_COMMAND=$DEFAULT_COMMAND
	fi
}


PS1=${PSARRAY[$PSINDEX]}

dont_panic