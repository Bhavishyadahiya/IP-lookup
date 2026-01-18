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
├── IPchecker_tui.sh
├── IPS.txt
├── config.conf
└── README.md
