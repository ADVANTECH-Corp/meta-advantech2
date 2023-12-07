#!/bin/sh
CMD=`which modelist 2> /dev/null` || {
  CMD=`realpath /tools/si/modelist.sh`
  [[ ! -x $CMD ]] && echo "cannot find utility, modelist" && exit 1
  echo $CMD
}

systemctl status weston &> /dev/null && WESTON=1 || WESTON=0

ALLKEYS=""
declare -A MODES
T=0
for M in `$CMD`; do
  MODES[$((T++))]=$M
done
KH="\e[1;37;40m"
KN="\e[0m"

function chr() {
  printf "\x$(printf %x $1)"
}

function ord() {
  printf '%d' "'$1"
}

function show_items_matrix() {
  COLS=${1:-3}
  ROWS=$(( T / COLS )); (( T % COLS > 0)) && ((ROWS++))
  i=0;
  for (( R=0; R < $ROWS; R++ )) do
    for (( C=0; C < COLS; C++ )) do
      i=$(( C * ROWS + R ));
      (( i >= T )) && break
      KEY=$i
      (( i >= 10 && i < 36 )) && KEY=`chr $((87 + i))`
      (( i >= 36 )) && KEY=`chr $((29 + i))`
      echo -en "$KH$KEY$KN ==> ${MODES[$i]}\t"
      ALLKEYS=${ALLKEYS}${KEY}
    done
    echo
    (( i >= T )) && continue
  done
  echo -e "${KH}Ctrl${KN} + ${KH}C${KN} ==> quit"
  echo -n "? "
}

function do_modetest() {
  A=$(( `ord $1` ))
  (( $A >=48 && $A <=57 )) && I=$(($A-48))
  (( $A >=97 && $A <=122 )) && I=$(($A-87))
  (( $A >=65 && $A <=90 )) && I=$(($A-29))

  echo -e "${MODES[$I]} is chosen\n"
  echo "While color bar appears, press Enter to return back to original desktop"
  trap "" INT
  [[ $WESTON == 1 ]] && systemctl stop weston
  modetest -s ${MODES[$I]} &> /dev/null
  [[ $WESTON == 1 ]] && {
    systemctl start weston
    echo -e ">>> \e[5;30;47mWaiting for original desktop back before next option\e[0m <<<"
  }
  trap to_exit INT
}

function to_exit() {
  echo
  echo "$OPK" > /proc/sys/kernel/printk
  trap - INT
  echo "display test finished"
  exit
}

trap to_exit INT
OPK=`cat /proc/sys/kernel/printk`
echo "0 0 0 0" > /proc/sys/kernel/printk

show_items_matrix
while :; do
  read -n1 -t1 KEY
  case "${KEY}" in
  [${ALLKEYS}])
    echo -e "\n"
    do_modetest $KEY
    ;;
  "") continue
    ;;
  esac
  echo; show_items_matrix
done
to_exit
