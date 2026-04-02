# ❄️ NixOS on ThinkPad X1 Yoga (2nd Gen)

A modular, performance-tuned NixOS configuration designed for my personal ThinkPad X1 Yoga.

---

## 💻 Hardware Specifications

| Component | Detailed Specification |
| :--- | :--- |
| **Model** | Lenovo ThinkPad X1 Yoga 2nd Generation |
| **CPU** | Intel Core i5-7300U (4) @ 3.50GHz |
| **GPU** | Intel HD Graphics 620 |
| **Display** | 14" WQHD/FHD Touchscreen with Wacom Pen Support |
| **RAM** | 8GB LPDDR3 1866MHz (Soldered) |
| **Storage** | 512GB NVMe M.2 SSD |
| **Features** | 360° Hinge, 06cb:009a Fingerprint, Backlit Keyboard |

---

## 🔥 Key Configuration Features

* **Performance**: Powered by the **CachyOS Kernel** with the `scx_rustland` scheduler for better responsiveness under load.
* **Storage**: **Btrfs** with `zstd:3` compression, async discard, and **zRAM** (100% of RAM) for efficient memory management.
* **Desktop**: **KDE Plasma 6 (Wayland)** as primary, with a ready-to-use **COSMIC** module. Supports Bengali, Japanese, and Chinese characters.
* **Development**: Full-stack environments for Rust (Fenix), Python (uv), Go, .NET, Java, and Node.js. Includes Podman and Libvirt/QEMU.
* **Multimedia**: **PipeWire**-based audio with echo cancellation and high-quality dither settings.

---

## 🚀 Getting Started

### Installation
```bash
# Clone the repository to /etc/nixos or your preferred location
git clone https://github.com/THShafi170/nixos-config.git
cd nixos-config

# Apply the configuration for this specific host
sudo nixos-rebuild switch --flake .#X1-Yoga-2nd
```

### Maintenance
* `nix-switch`: Rebuild and apply current changes.
* `nix-upgrade`: Update flake inputs and rebuild the system.
* `nix-clean`: Deep clean old generations and optimize the Nix store.

---

## 🛠️ Repository Layout
* `hosts/`: Host-specific configuration and hardware definitions.
* `modules/`: Modular system components (Audio, Boot, Drivers, Programs).
* `home/`: Home Manager configurations for shell, git, and user environment.
* `users/`: User account and group management.

---

**Last Updated**: April 2, 2026
