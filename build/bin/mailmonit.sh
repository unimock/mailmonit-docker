#!/bin/bash



. /etc/mailmonit.dat

S_DIR=$VAR_DIR/echo

FI=`mktemp`
INC=`mktemp`

_exit()
{
  rm $FI $INC 
  exit 0
}

cat  > $FI
 
SENDER=`egrep "^From: " $FI | sed -1 | sed "s,^From: ,,"`
SUBJECT=`egrep "^Subject: " $FI | head -1 | sed "s,^Subject: ,,"`


PW=`echo ${SUBJECT} | cut -d" " -f1`
S=${SUBJECT#${PW} }
#
rm -f $INC
for i in $S ; do
  if [ "$i" = "cmd=echo" ] ; then
    echo "RECEIVE_pw=${PW}"               >> $INC
    for j in $S ; do
       echo "RECEIVE_$j"                  >> $INC
    done
    echo "RECEIVE_rs_receive=`date  +%s`" >> $INC
  fi
done
if [ ! -e $INC ] ; then
  _exit
fi
. $INC
if [ -e ${S_DIR}/${RECEIVE_id}.send ] ; then
  . ${S_DIR}/${RECEIVE_id}.send
  if [ "${SEND_pw}" = "${RECEIVE_pw}" ] ; then
     cat $INC >> ${S_DIR}/${RECEIVE_id}.send
     mv ${S_DIR}/${RECEIVE_id}.send ${R_DIR}/${S_DIR}/${RECEIVE_id}.receive
  fi
fi
_exit

