#!/usr/bin/env bash

watch -n 1 '
echo "=== TOP CPU (aggregate) ==="
ps -eo pid,comm,%cpu --no-headers |
awk '\''$2 !~ /^(ps|watch|awk)$/ { cpu[$2] += $3 }
     END { for (c in cpu) printf "%7.2f%% %s\n", cpu[c], c }'\'' |
sort -nr | head -n 12

echo
echo "=== TOP MEM (aggregate) ==="
ps -eo pid,comm,%mem --no-headers |
awk '\''$2 !~ /^(ps|watch|awk)$/ { mem[$2] += $3 }
     END { for (c in mem) printf "%7.2f%% %s\n", mem[c], c }'\'' |
sort -nr | head -n 12
'
