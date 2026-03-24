#!/usr/bin/env bash

if [ "$(id -u)" -ne 0 ]; then
  echo "This script must be run as root"
  exit 1
fi

echo "Kernel updated at $(date)" >> /var/log/kernel-update.log

scaling_f="/sys/devices/system/cpu/cpu0/cpufreq/scaling_driver"
pstate_supported=false
driver=""
if [ -d /sys/devices/system/cpu/intel_pstate ]; then
  driver="intel_pstate"
  pstate_supported=true
elif [ -d /sys/devices/system/cpu/amd_pstate ] || [ -d /sys/devices/system/cpu/amd-pstate ]; then
  # kernel docs and kernels may expose amd_pstate/amd-pstate; accept either
  driver="amd_pstate"
  pstate_supported=true
elif [ -r "$scaling_f" ]; then
  # fallback: read scaling_driver and normalise
  rawdrv=$(cat "$scaling_f" 2>/dev/null || true)
  case "$rawdrv" in
  *intel*)
    driver="intel_pstate"
    pstate_supported=true
    ;;
  *amd*)
    driver="amd_pstate"
    pstate_supported=true
    ;;
  *) driver="$rawdrv" ;;
  esac
fi

pstate_param=""
if [ "$pstate_supported" = true ]; then
  if [ "$driver" = "intel_pstate" ]; then
    pstate_param="intel_pstate=active"
  elif [ "$driver" = "amd_pstate" ]; then
    pstate_param="amd_pstate=active"
  fi
fi

extra_params="fsck.repair=yes zswap.enabled=0"
[ -n "$pstate_param" ] && extra_params="$extra_params $pstate_param"

for f in /boot/efi/loader/entries/*; do
  opts=$(sed -n 's/^options[[:space:]]\+//p' "$f")

  for p in $extra_params; do
    echo "$opts" | grep -Fq "$p" ||
      sed -i "/^options[[:space:]]\+/ s/$/ $p/" "$f"
  done
done
