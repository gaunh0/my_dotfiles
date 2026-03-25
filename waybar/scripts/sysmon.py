#!/usr/bin/env python3
import json
import os
import time

import psutil

BAR_ICON = "󰍛"


# =====================
# HELPERS
# =====================
def read(path, scale=1):
    try:
        with open(path) as f:
            return int(f.read().strip()) / scale
    except:
        return None


def read_hex(path):
    try:
        with open(path, "r") as f:
            return int(f.read().strip(), 16)
    except (FileNotFoundError, ValueError, OSError):
        return None


def find_amd_gpu():
    base = "/sys/class/drm"
    for entry in os.listdir(base):
        if entry.startswith("card") and "-" not in entry:
            dev_path = os.path.join(base, entry, "device")
            vendor_id = read_hex(os.path.join(dev_path, "vendor"))
            if vendor_id == 0x1002:
                return dev_path
    return None


# =====================
# CPU
# =====================
def cpu_info():
    freq = psutil.cpu_freq()
    load = psutil.cpu_percent(interval=0.1)

    temp = None
    temps = psutil.sensors_temperatures()
    for k in ("k10temp", "coretemp"):
        if k in temps:
            temp = int(temps[k][0].current)
            break

    return {
        "usage": load,
        "freq": int(freq.current) if freq else None,
        "cores": psutil.cpu_count(logical=True),
        "temp": temp,
        "loadavg": os.getloadavg()[0],
    }


# =====================
# GPU (AMD ONLY)
# =====================
def gpu_info():
    dev = find_amd_gpu()
    if not dev:
        return None

    util = read(os.path.join(dev, "gpu_busy_percent"))
    vram_used = read(os.path.join(dev, "mem_info_vram_used"), 1024**2)
    vram_total = read(os.path.join(dev, "mem_info_vram_total"), 1024**2)

    temp = None
    power = None

    hwmon = os.path.join(dev, "hwmon")
    if os.path.exists(hwmon):
        for h in os.listdir(hwmon):
            temp = read(os.path.join(hwmon, h, "temp1_input"), 1000)
            power = read(os.path.join(hwmon, h, "power1_average"), 1_000_000)

    return {
        "usage": util,
        "temp": temp,
        "power": power,
        "vram_used": vram_used,
        "vram_total": vram_total,
    }


# =====================
# MEMORY
# =====================
def mem_info():
    m = psutil.virtual_memory()
    return {
        "used": m.used / (1024**3),
        "total": m.total / (1024**3),
        "percent": m.percent,
        "swap": psutil.swap_memory().used / (1024**3),
    }


# =====================
# DISK
# =====================
def disk_info():
    d = psutil.disk_usage("/")
    io = psutil.disk_io_counters()
    return {
        "used": d.used / (1024**3),
        "total": d.total / (1024**3),
        "percent": d.percent,
        "read": io.read_bytes / (1024**2),
        "write": io.write_bytes / (1024**2),
    }


# =====================
# COLLECT
# =====================
cpu = cpu_info()
gpu = gpu_info()
mem = mem_info()
disk = disk_info()

# =====================
# TOOLTIP
# =====================
tooltip = []

tooltip += [
    "<b>CPU</b>",
    f"Usage: {cpu['usage']:.1f}%",
    f"Freq: {cpu['freq']} MHz" if cpu["freq"] else "Freq: N/A",
    f"Cores: {cpu['cores']}",
    f"Temp: {cpu['temp']}°C" if cpu["temp"] else "Temp: N/A",
    f"Load (1m): {cpu['loadavg']:.2f}",
    "",
]

if gpu:
    tooltip += [
        "<b>GPU (AMD)</b>",
        f"Usage: {gpu['usage']}%" if gpu["usage"] is not None else "Usage: N/A",
        f"Temp: {gpu['temp']}°C" if gpu["temp"] else "Temp: N/A",
        f"Power: {gpu['power']:.1f} W" if gpu["power"] else "Power: N/A",
        f"VRAM: {gpu['vram_used']:.0f} / {gpu['vram_total']:.0f} MB"
        if gpu["vram_total"]
        else "VRAM: N/A",
        "",
    ]

tooltip += [
    "<b>Memory</b>",
    f"RAM: {mem['used']:.1f} / {mem['total']:.1f} GB ({mem['percent']:.0f}%)",
    f"Swap: {mem['swap']:.1f} GB",
    "",
    "<b>Disk (/)</b>",
    f"Usage: {disk['used']:.1f} / {disk['total']:.1f} GB ({disk['percent']:.0f}%)",
    f"IO: R {disk['read']:.0f} MB | W {disk['write']:.0f} MB",
]


# =====================
# OUTPUT
# =====================
print(
    json.dumps(
        {
            "text": BAR_ICON,
            "tooltip": "\n".join(tooltip),
            "markup": "pango",
        }
    )
)
