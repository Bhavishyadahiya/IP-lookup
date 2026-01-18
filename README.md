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
---

---

## 📥 Installation

### 🔹 Clone from GitHub

`git clone https://github.com/Bhavishyadahiya/IP-lookup.git
cd IP-lookup`


USAGE GUIDE
===========

Step 1 — Add proxy list
-----------------------

Put your proxies or IPs into IPS.txt

Any format is accepted, for example:

`1.1.1.1
5.151.150.1:11631:user:pass
socks5://user:pass@137.155.23.15:10880
http://login:pw@8.8.8.8:8080`

The script automatically extracts the IP address.


Step 2 — Configure API key
--------------------------

Open config.conf and add your RapidAPI key:

`PING0_KEY="YOUR_RAPIDAPI_KEY_HERE"`

Optional performance tuning:

`MAX_JOBS=4
JOB_DELAY=0.3`


Step 3 — Make script executable
-------------------------------

`chmod +x check.sh`


Step 4 — Run the checker
-----------------------

`./check.sh`

or

`bash check.sh`

The terminal UI will update live while scanning.




## 🧾 Output Columns
| Column | Source | Description |
|--------|--------|------------|
| IP | Extracted | IPv4 address |
| Country | ip-api | Country name |
| City | ip-api | City |
| ISP | ip-api | Internet provider |
| ASN | ip-api | Autonomous system |
| Risk | Ping0 | Abuse risk score (0–100) |
| Type | Calculated | Residential / Datacenter / Abusive / Bogon |
| Abuser | Ping0 | Y = flagged |
| Bogon | Ping0 | Y = invalid / reserved |
| Crawler | Ping0 | Y = known crawler |

---

## 📁 Project Structure

```text
.
├── check.sh
├── IPS.txt
├── config.conf
└── README.md
