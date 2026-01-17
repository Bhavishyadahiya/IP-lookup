# 🔍 Proxy IP Intelligence Checker (TUI • Pure Bash)

![License](https://img.shields.io/badge/license-MIT-green.svg)
![Shell](https://img.shields.io/badge/shell-bash-blue.svg)
![Platform](https://img.shields.io/badge/platform-linux%20%7C%20macOS-lightgrey)

> 🚀 Fast terminal-based IP intelligence checker for proxy lists —  
> extracts IPs from **any format**, queries **free APIs**, and displays results in a live **TUI table**.

---

## ✨ Features

- ✅ Accepts **any proxy format**
  - `ip:port:user:pass`
  - `socks5://user:pass@ip:port`
  - `http://user:pass@ip:port`
  - raw IPs
- ✅ Auto-extracts IPv4 from each line
- ✅ Ignores comments & empty lines
- ✅ Keeps original order (no sorting)
- ✅ Removes duplicate IPs
- ✅ Parallel scanning (much faster)
- ✅ Live updating **terminal UI**
- ✅ **No dependencies** (no jq, no dialog, no ncurses)

---

## 📊 Data Sources

### 🌍 ip-api.com (Free, No API Key)

Used for:
- Country
- City
- ISP
- ASN

Example:
http://ip-api.com/json/8.8.8.8
Ping0 (RapidAPI)
Used for:
- Risk score (0–100)
- Datacenter detection
- Abuser flag
- Bogon flag
- Crawler flag

Requires free RapidAPI key.

============================================================

OUTPUT COLUMNS
--------------

IP        - Extracted IPv4 address
Country   - From ip-api
City      - From ip-api
ISP       - Internet provider
ASN       - Autonomous system
Risk      - Abuse risk score
Type      - Residential / Datacenter / Abusive / Bogon
Abuser    - Y / N
Bogon     - Y / N
Crawler   - Y / N

============================================================

PROJECT FILES
-------------

IPchecker_tui.sh
IPS.txt
config.conf
README.txt

============================================================

IPS.txt INPUT FORMAT
--------------------

You can put anything. The script extracts the first IPv4 found on each line.

# Any format works

1.1.1.1

5.151.150.1:11631:user:pass

socks5://user:pass@137.155.23.15:10880

http://login:pw@8.8.8.8:8080

random text 202.173.127.254 more text

Comments ignored
Blank lines ignored
Duplicate IPs removed
Original order preserved

============================================================

config.conf
-----------

TIMEOUT=10

MAX_JOBS=4
JOB_DELAY=0.3

PING0_HOST="ping0-api.p.rapidapi.com"
PING0_KEY="PUT_YOUR_API_KEY_HERE"

Never commit real API keys to GitHub.

============================================================

USAGE
-----

chmod +x IPchecker_tui.sh
./IPchecker_tui.sh

or

bash IPchecker_tui.sh

============================================================

RATE LIMITS
-----------

ip-api.com free tier:
~45 requests per minute per IP

For large lists use:

MAX_JOBS=2
JOB_DELAY=0.6

If ISP or Country shows -- you are rate limited.

============================================================

SECURITY
--------

Rotate RapidAPI key if leaked.
Do NOT upload config.conf to GitHub.
Add to .gitignore:

config.conf

============================================================

LICENSE
-------

MIT License.

============================================================

ROADMAP
-------

- Color-coded rows
- Proxy connection tests (SOCKS5 / HTTP)
- Export to CSV / JSON
- Smarter rate control
- IPv6 support
- Auto proxy scoring

============================================================

WHY THIS EXISTS
---------------

Most proxy checkers are paid, bloated, and GUI-only.
This tool is fast, scriptable, SSH-friendly, and easy to extend.
