#!/usr/bin/env python3
"""
Mirrors StripKnownTags / tag application from GenerateQuestMarkers.pas and
proves the properties the design brief asks for in section 14.

Run: python build/test_tagging.py
"""
import json
import sys
from pathlib import Path

_DIR = Path(__file__).resolve().parent
ROOT = _DIR if (_DIR / "Database").exists() else _DIR.parent
A = json.loads((ROOT / "Database" / "aliases.json").read_text(encoding="utf-8"))
DESC, COMP = A["styles"]["descriptive"], A["styles"]["compact"]

# same construction as LoadStrip in the Pascal: both styles, longest first
STRIP = sorted(set(DESC.values()) | set(COMP.values()), key=len, reverse=True)


def strip_known(name):
    out = name.strip()
    while True:
        for t in STRIP:
            if out.lower().startswith(t.lower()):
                out = out[len(t):].strip()
                break
        else:
            return out


def apply_tag(name, key, style):
    table = DESC if style == "descriptive" else COMP
    return f"{table[key]} {strip_known(name)}"


FAILS = []


def check(label, got, want):
    if got != want:
        FAILS.append(f"{label}\n    got  {got!r}\n    want {want!r}")


print("Tag vocabulary:", len(STRIP), "strippable tokens")
print("Longest-first head:", STRIP[:3])
print()

# 1. basic application
check("apply descriptive",
      apply_tag("Cleansing the Commonwealth", "brotherhood_radiant", "descriptive"),
      "[Brotherhood - Radiant] Cleansing the Commonwealth")
check("apply compact",
      apply_tag("Blood Tide", "farharbor_radiant", "compact"),
      "[R-FH] Blood Tide")

# 2. idempotency: running the generator repeatedly must not stack
n = "Cleansing the Commonwealth"
for i in range(5):
    n = apply_tag(n, "brotherhood_radiant", "descriptive")
check("idempotent x5", n, "[Brotherhood - Radiant] Cleansing the Commonwealth")

# 3. style switching must not stack either
n = apply_tag("Quartermastery", "brotherhood_radiant", "descriptive")
n = apply_tag(n, "brotherhood_radiant", "compact")
check("desc -> compact", n, "[R-BOS] Quartermastery")
n = apply_tag(n, "brotherhood_radiant", "descriptive")
check("compact -> desc", n, "[Brotherhood - Radiant] Quartermastery")

# 4. recategorisation: a quest reclassified in the database
n = apply_tag("Kidnapping", "minutemen_radiant", "descriptive")
n = apply_tag(n, "settlement_defense", "descriptive")
check("reclassify", n, "[Minutemen - Settlement Defense] Kidnapping")

# 5. longest-first: the establishment tag must not be half-eaten
check("prefix shadowing",
      strip_known("[Settlement - Establishment] Sanctuary Hills"),
      "Sanctuary Hills")
check("compact S vs SET",
      strip_known("[R-SET] Somewhere"),
      "Somewhere")

# 6. already-stacked names from a bad earlier build must self-heal
check("unstack double",
      strip_known("[Brotherhood - Radiant] [Brotherhood - Radiant] Cleansing the Commonwealth"),
      "Cleansing the Commonwealth")
check("unstack mixed",
      strip_known("[R] [Timed - Radiant] Kidnapping"),
      "Kidnapping")

# 7. unrelated leading brackets must survive untouched
for name in ("[Prototype] Widget Retrieval", "[FO4] Something", "[Z] Not a tag"):
    check(f"leave alone {name}", strip_known(name), name)

# 8. text-replacement tokens must survive intact
tok = "Raider Troubles at <Alias=Workshop>"
out = apply_tag(tok, "settlement_defense", "descriptive")
check("alias token preserved", out,
      "[Minutemen - Settlement Defense] Raider Troubles at <Alias=Workshop>")
check("alias token round trip", strip_known(out), tok)

# 9. every tag key exists in both styles
for k in DESC:
    if k not in COMP:
        FAILS.append(f"tag key {k!r} missing from compact style")
for k in COMP:
    if k not in DESC:
        FAILS.append(f"tag key {k!r} missing from descriptive style")

# 10. no tag is a strict prefix of another in a way longest-first cannot fix
for a in STRIP:
    for b in STRIP:
        if a != b and b.startswith(a) and STRIP.index(a) < STRIP.index(b):
            FAILS.append(f"ordering bug: {a!r} sorted before its extension {b!r}")

# 11. database integrity: every tag used must exist, every module must be known
DB = json.loads((ROOT / "Database" / "quests.json").read_text(encoding="utf-8"))
MODULES = set(A["modules"])
for q in DB["quests"]:
    if q["tag"] and q["tag"] not in DESC:
        FAILS.append(f"{q['originalName']}: unknown tag key {q['tag']!r}")
    if q["module"] and q["module"] not in MODULES:
        FAILS.append(f"{q['originalName']}: unknown module {q['module']!r}")
    if q["confidence"] == "excluded" and q["tag"]:
        FAILS.append(f"{q['originalName']}: excluded but carries a tag")
    if q["confidence"] != "excluded" and not q["tag"]:
        FAILS.append(f"{q['originalName']}: taggable state but no tag")
    if q["confidence"] not in ("verified", "likely", "unverified", "excluded"):
        FAILS.append(f"{q['originalName']}: invalid confidence state {q['confidence']!r}")
    if "|" in q["originalName"]:
        FAILS.append(f"{q['originalName']}: pipe character breaks the TSV")

print(f"{len(DB['quests'])} database entries checked")
print()

if FAILS:
    print(f"FAIL ({len(FAILS)})")
    for f in FAILS:
        print("  -", f)
    sys.exit(1)
print("All checks passed.")
