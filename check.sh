#!/usr/bin/env bash

IP_FILE="IPS.txt"
CONF_FILE="config.conf"

[[ ! -f "$CONF_FILE" ]] && echo "config.conf missing" && exit 1
[[ ! -f "$IP_FILE" ]] && echo "IPS.txt missing" && exit 1

# SAFE CONFIG LOAD
eval "$(grep -E '^[A-Z0-9_]+=.*' "$CONF_FILE")"

# ---- Extract IPs from ANY line format, ignore comments, dedupe ----
mapfile -t IPS < <(
  grep -Ev '^\s*#|^\s*$' "$IP_FILE" \
  | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}'
)

COUNT=${#IPS[@]}
[[ "$COUNT" -eq 0 ]] && echo "No IPs found in IPS.txt" && exit 1

COUNTRY=() CITY=() ISP=() ASN=()
RISK=() TYPE=()
ABUSER=() BOGON=() CRAWLER=()
DEBUG_LINES=()

for ((i=0;i<COUNT;i++)); do
  COUNTRY[$i]="--"
  CITY[$i]="--"
  ISP[$i]="--"
  ASN[$i]="--"
  RISK[$i]="--"
  TYPE[$i]="WAIT"
  ABUSER[$i]="N"
  BOGON[$i]="N"
  CRAWLER[$i]="N"
done

# ---------- ANSI UI ----------
clear_screen(){ printf "\033[2J\033[H"; }
hide_cursor(){ printf "\033[?25l"; }
show_cursor(){ printf "\033[?25h"; }
bold(){ printf "\033[1m"; }
reset(){ printf "\033[0m"; }

add_debug() {
  DEBUG_LINES+=("$1")
  (( ${#DEBUG_LINES[@]} > 6 )) && DEBUG_LINES=("${DEBUG_LINES[@]:1}")
}

draw() {
  clear_screen
  bold
  printf "IPs: %d\n" "$COUNT"
  printf "%-15s %-10s %-12s %-14s %-12s %-6s %-12s %-7s %-7s %-8s\n" \
    "IP" "Country" "City" "ISP" "ASN" "Risk" "Type" "Abuser" "Bogon" "Crawler"
  printf "%s\n" "----------------------------------------------------------------------------------------------------------------"
  reset

  for ((j=0;j<COUNT;j++)); do
    printf "%-15s %-10s %-12s %-14s %-12s %-6s %-12s %-7s %-7s %-8s\n" \
      "${IPS[$j]}" \
      "${COUNTRY[$j]:0:10}" \
      "${CITY[$j]:0:12}" \
      "${ISP[$j]:0:14}" \
      "${ASN[$j]:0:12}" \
      "${RISK[$j]}" \
      "${TYPE[$j]}" \
      "${ABUSER[$j]}" \
      "${BOGON[$j]}" \
      "${CRAWLER[$j]}"
  done

  echo
  bold; echo "DEBUG:"; reset
  for l in "${DEBUG_LINES[@]}"; do echo "$l"; done
}

trap show_cursor EXIT
hide_cursor
draw

for ((i=0;i<COUNT;i++)); do
  ip="${IPS[$i]}"
  add_debug "[$((i+1))/$COUNT] Checking $ip"
  draw

  # ---------- ip-api.com (Country / City / ISP / ASN) ----------
  add_debug "ip-api lookup..."
  r=$(curl -m "${TIMEOUT:-10}" -s "http://ip-api.com/json/$ip")

  COUNTRY[$i]=$(echo "$r" | sed -n 's/.*"country":"\([^"]*\)".*/\1/p')
  CITY[$i]=$(echo "$r" | sed -n 's/.*"city":"\([^"]*\)".*/\1/p')
  ISP[$i]=$(echo "$r" | sed -n 's/.*"isp":"\([^"]*\)".*/\1/p')
  ASN[$i]=$(echo "$r" | sed -n 's/.*"as":"\([^"]*\)".*/\1/p')

  [[ -z "${COUNTRY[$i]}" ]] && COUNTRY[$i]="--"
  [[ -z "${CITY[$i]}" ]] && CITY[$i]="--"
  [[ -z "${ISP[$i]}" ]] && ISP[$i]="--"
  [[ -z "${ASN[$i]}" ]] && ASN[$i]="--"
  draw

  # ---------- PING0 (Risk + Flags) ----------
  add_debug "Ping0 lookup..."
  r=$(curl -m "${TIMEOUT:-10}" -s \
    "https://ping0-api.p.rapidapi.com/rapidapi/lookup?ip=$ip" \
    -H "x-rapidapi-host: $PING0_HOST" \
    -H "x-rapidapi-key: $PING0_KEY")

  RISK[$i]=$(echo "$r" | sed -n 's/.*"risk_score":\([0-9]\+\).*/\1/p')
  [[ -z "${RISK[$i]}" ]] && RISK[$i]="--"

  echo "$r" | grep -qi '"is_abuser":true'   && ABUSER[$i]="Y"   || ABUSER[$i]="N"
  echo "$r" | grep -qi '"is_bogon":true'    && BOGON[$i]="Y"    || BOGON[$i]="N"
  echo "$r" | grep -qi '"is_crawler":true'  && CRAWLER[$i]="Y"  || CRAWLER[$i]="N"

  if echo "$r" | grep -qi '"is_bogon":true'; then
    TYPE[$i]="Bogon"
  elif echo "$r" | grep -qi '"is_datacenter":true'; then
    TYPE[$i]="Datacenter"
  elif echo "$r" | grep -qi '"is_abuser":true'; then
    TYPE[$i]="Abusive"
  else
    TYPE[$i]="Residential"
  fi

  draw
done

echo
echo "Scan complete. Press Enter..."
read
