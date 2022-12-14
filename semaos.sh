#!/bin/bash

# while-menu-dialog: a menu driven system information program

DIALOG_CANCEL=1
DIALOG_ESC=255
HEIGHT=0
WIDTH=0

display_result() {
  dialog --title "$1" \
    --no-collapse \
    --msgbox "$result" 0 0
}

while true; do
  exec 3>&1
  selection=$(dialog \
    --backtitle "Bienvenue dans SemaOS" \
    --title "Menu" \
    --clear \
    --cancel-label "Exit" \
    --menu "Please select:" $HEIGHT $WIDTH 4 \
    "1" "Mon IP privé" \
    "2" "Mon IP publique" \
    "3" "Scan de réseau" \
    "4" "Test de connexion" \
    "5" "Test de débit" \
    "6" "Version" \
    "7" "Mise à jour" \
    2>&1 1>&3)
  exit_status=$?
  exec 3>&-
  case $exit_status in
    $DIALOG_CANCEL)
      clear
      echo "Program terminated."
      exit
      ;;
    $DIALOG_ESC)
      clear
      echo "Program aborted." >&2
      exit 1
      ;;
  esac
  case $selection in
    1 )
      result=$(ip a)
      display_result "Détail par interfaces"
      ;;
    2 )
      result=$(curl ifconfig.me)
      display_result "IP Publique"
      ;;
    3 )
      $(ip route | grep src | grep eth0 | awk '{print $1}' > tmp)
      result=$(nmap -sn -iL tmp)
      display_result "Scan du réseau"
      ;;
    4 )
      result=$(less ./networkinfo.log)
      display_result "Santé de la connexion"
      ;;
    5 )
      $(fast -u > debit.txt)
      result=$(tail -n 3 debit.txt)
      display_result "Speedtest"
      ;;
    6 )
      result=$(git log -1)
      display_result "Version"
      ;;
    7 ) 
      result=$(git stash && git pull origin main)
      display_result "Mise à jour"
  esac
done
# $(ip route | grep src | grep eth0 | awk '{print $1}' > tmp)
