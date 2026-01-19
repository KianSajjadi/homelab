#!/usr/bin/env bash

RED="\033[31m"
YELLOW="\033[33m"
RESET="\033[0m"

while true; do
  ts=$(date '+%Y-%m-%d %H:%M:%S')

  line=$(curl -k -sS -m 2 -o /dev/null \
    -w "dns=%{time_namelookup} connect=%{time_connect} tls=%{time_appconnect} ttfb=%{time_starttransfer} total=%{time_total} code=%{http_code} ip=%{remote_ip}" \
    https://printer.syd.broc.ee/robots.txt 2>/dev/null || echo FAIL)

  # If curl totally failed
  if [[ "$line" == "FAIL" ]]; then
    echo -e "$ts ${RED}FAIL${RESET}"
    sleep 1
    continue
  fi

  # Extract numbers
  dns=$(echo "$line" | sed -n 's/.*dns=\([0-9.]*\).*/\1/p')
  conn=$(echo "$line" | sed -n 's/.*connect=\([0-9.]*\).*/\1/p')
  tls=$(echo "$line" | sed -n 's/.*tls=\([0-9.]*\).*/\1/p')
  ttfb=$(echo "$line" | sed -n 's/.*ttfb=\([0-9.]*\).*/\1/p')
  total=$(echo "$line" | sed -n 's/.*total=\([0-9.]*\).*/\1/p')

  colour() {
    local val=$1
    local warn=$2
    local crit=$3

    if (( $(echo "$val >= $crit" | bc -l) )); then
      echo -e "${RED}$val${RESET}"
    elif (( $(echo "$val >= $warn" | bc -l) )); then
      echo -e "${YELLOW}$val${RESET}"
    else
      echo "$val"
    fi
  }

  dns_c=$(colour "$dns" 0.2 0.5)
  conn_c=$(colour "$conn" 0.2 0.5)
  tls_c=$(colour "$tls" 0.2 0.5)
  ttfb_c=$(colour "$ttfb" 0.5 1.0)
  total_c=$(colour "$total" 0.5 1.0)

  echo -e "$ts dns=$dns_c connect=$conn_c tls=$tls_c ttfb=$ttfb_c total=$total_c $line"

  sleep 1
done
