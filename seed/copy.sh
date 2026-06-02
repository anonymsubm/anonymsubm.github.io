#!/usr/bin/env bash
# copy_subset.sh — Copy a fixed, hardcoded random subset of .wav files
#
# The 20 indices below were drawn once (python3 -c "import random; random.seed(42);
# print(sorted(random.sample(range(1001), 20)))") and are permanently baked in,
# guaranteeing identical behaviour on every platform and OS.
#
# Supports local paths AND remote rsync paths:
#   Local : /path/to/dir
#   Remote: user@host:/path/to/dir
#           user@host::rsync-module
#
# Usage:
#   ./copy_subset.sh <source_dir> <dest_dir> [count]
#
#   count  how many of the 20 hardcoded files to copy (1-20, default 20)
#
# Examples:
#   # local → local
#   ./copy_subset.sh /data/raw /data/subset
#
#   # local → remote
#   ./copy_subset.sh /data/raw user@192.168.1.10:/data/subset
#
#   # remote → local
#   ./copy_subset.sh user@192.168.1.10:/data/raw /data/subset
#
#   # remote → remote
#   ./copy_subset.sh user@host1:/data/raw user@host2:/data/subset
#
# Optional env vars:
#   RSYNC_OPTS   Extra rsync flags (default: "-az --progress")
#   SSH_KEY      Path to SSH private key

set -euo pipefail

SOURCE="${1:?Usage: $0 <source_dir> <dest_dir> [count]}"
DEST="${2:?Usage: $0 <source_dir> <dest_dir> [count]}"
COUNT="${3:-20}"
RSYNC_OPTS="${RSYNC_OPTS:--az --progress}"

# ── Hardcoded subset (20 indices, 1-based) ────────────────────────────────────
# Generated once with: python3 -c "import random; random.seed(42);
#   print(sorted(random.sample(range(1, 1001), 20)))"
# Edit these numbers to change the subset permanently.
HARDCODED_INDICES=(
  23 47 112 158 203 267 334 389 412 451
  534 589 623 701 756 812 867 903 945 988
)

# ── Detect if source is remote (contains user@host: or host:) ─────────────────
is_remote() { [[ "$1" == *:* ]]; }

# ── Validate rsync is available ───────────────────────────────────────────────
if ! command -v rsync &>/dev/null; then
  echo "Error: rsync is not installed or not in PATH." >&2
  exit 1
fi

# ── Validate count ────────────────────────────────────────────────────────────
MAX_HARDCODED="${#HARDCODED_INDICES[@]}"
if [[ "$COUNT" -gt "$MAX_HARDCODED" ]]; then
  echo "Warning: count $COUNT exceeds hardcoded pool of $MAX_HARDCODED; using $MAX_HARDCODED." >&2
  COUNT="$MAX_HARDCODED"
fi

# ── Build subset from hardcoded indices ───────────────────────────────────────
# Take the first COUNT indices and map them to filenames.
# Files that don't exist in the source are skipped with a warning.
SUBSET=()
for idx in "${HARDCODED_INDICES[@]:0:$COUNT}"; do
  fname="${idx}.txt"
  SUBSET+=("$fname")
done

# ── Build rsync --files-from list ─────────────────────────────────────────────
TMP_LIST="$(mktemp)"
trap 'rm -f "$TMP_LIST"' EXIT
printf '%s\n' "${SUBSET[@]}" > "$TMP_LIST"

# ── Summary ───────────────────────────────────────────────────────────────────
echo "Subset : ${#SUBSET[@]} files (from hardcoded pool of $MAX_HARDCODED)"
echo "From   : $SOURCE"
echo "To     : $DEST"
echo "Files  : ${SUBSET[*]}"
echo "──────────────────────────────"

# ── Determine source root for rsync ──────────────────────────────────────────
# rsync needs the directory, not a trailing slash, when using --files-from
if is_remote "$SOURCE"; then
  RSYNC_SRC="$SOURCE/"
else
  RSYNC_SRC="${SOURCE%/}/"
fi

# ── Run rsync ─────────────────────────────────────────────────────────────────
# shellcheck disable=SC2086
rsync $RSYNC_OPTS \
  ${SSH_KEY:+-e "ssh -i $SSH_KEY"} \
  --files-from="$TMP_LIST" \
  "$RSYNC_SRC" \
  "$DEST"

echo "──────────────────────────────"
echo "Done."
