# 🚀 DDoS Test Launcher (Educational Use Only)

This is a super-optimized, interactive Bash-based DDoS launcher designed for **local, legal, and educational lab environments**. It supports multiple attack types, port cycling, intensity control, and emergency stop.

> ❗ **DISCLAIMER**: This tool is for testing in isolated environments only. Do NOT use it on public networks, unauthorized systems, or anything outside of your own test lab.

---

## ⚙️ Features

- ✅ Multi-attack simultaneous execution (SYN, UDP, Slowloris, HTTP Flood)
- ✅ Port cycling (attack multiple ports in a range)
- ✅ Adjustable attack intensity (Low, Medium, High)
- ✅ Emergency stop via `q` key
- ✅ Fully offline and self-contained
- ✅ No logging or data collection
- ✅ Auto-installs required tools if missing

---

## 📦 Setup

```bash
sudo apt update
sudo apt install git -y
git clone https://github.com/m1chtv/mich-ddos-launcher
cd mich-ddos-launcher
chmod +x mich-ddos-launcher.sh
./mich-ddos-launcher.sh
```

---

## 🧪 Usage Example

1. Enter your local target IP or domain (e.g., `192.168.1.100`)
2. Enter port range: `80 80` for single port, or `70 90` for a full range
3. Select intensity level:
   - Low: slow/lightweight testing
   - Medium: balanced
   - High: aggressive flood
4. Choose attack types (e.g. `1 2 4`)
5. Press `q` at any time to stop all attacks

---

## 🎯 Supported Attack Types

| ID | Type        | Layer | Description                        |
|----|-------------|-------|------------------------------------|
| 1  | SYN Flood   | L4    | TCP handshake flood                |
| 2  | UDP Flood   | L4    | Stateless UDP overload             |
| 3  | Slowloris   | L7    | Keep-alive header exhaustion       |
| 4  | HTTP Flood  | L7    | High-load threaded HTTP spam       |

---

## 🛑 Emergency Stop

While the attack is running, press **`q`** to:
- Kill all running attack processes
- Safely exit the script

---

## ❌ Do NOT Use This Tool On:

- Any production network
- Public IPs
- Websites or services you don’t own
- School or corporate networks

Violating these rules may result in **criminal charges** and **network bans**.

---

## 🧠 Educational Use Cases

- Network defense labs
- Firewall testing
- DDoS mitigation practice
- Cybersecurity training environments

---

## 🙏 Credits

- [`hping3`](http://www.hping.org/)
- [`slowloris`](https://github.com/gkbrk/slowloris)
- [`GoldenEye`](https://github.com/jseidl/GoldenEye)
