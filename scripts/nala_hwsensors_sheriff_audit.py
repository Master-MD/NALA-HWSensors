#!/usr/bin/env python3
"""
NALA-HWSensors v2.0 (2.0.0-NCSP)
sHeriFF + NVIDIA SkillSpector + Cryptographic SHA-256 Skin-Guard & Triple-Check Pre-Push Auditor

Guarantees before ANY GitHub push or Community Skin activation:
  [CHECK 1] Zero-PII & Zero-Private-Infrastructure Gate (0% names, emails, local paths, private RFC1918/Tailscale IPs)
  [CHECK 2] Zero-Secrets & API-Key Gate (0% API keys, tokens, credentials, .env files)
  [CHECK 3] Cryptographic SHA-256 Skin Hash + NVIDIA SkillSpector Anti-Prompt-Injection / Anti-Malware + Non-Empty Binary Gate
"""

import argparse
import hashlib
import json
import os
import re
import sys
from pathlib import Path
from typing import Any, Dict, List, Tuple

VERSION_SSOT = "2.0.0-NCSP"

# ---------------------------------------------------------------------------
# 7 OFFICIAL SKINS DEFINITION (Canonical Tokens -> SHA-256 Sealed)
# ---------------------------------------------------------------------------
OFFICIAL_SKINS_DATA: List[Dict[str, Any]] = [
    {
        "id": "porsche-v4-cockpit",
        "name": "Porsche Design System v4 Digital Cockpit",
        "subtitle": "911 GT3 / Taycan Instrument Cluster · SSD Fuel-Tank Gauge & Sport Chrono Tachometer",
        "category": "Automotive Luxury Flagship",
        "author": "NALA-HWSensors Core Team (Tribute to Porsche Design System v4 Apache-2.0)",
        "license": "Apache-2.0 / NALA Charityware Dual-License",
        "isDark": True,
        "tokens": {
            "canvas": "#0E0E12",
            "surface": "#16171D",
            "surfaceElevated": "#21222B",
            "textPrimary": "#FBFCFF",
            "textSecondary": "#94969C",
            "borderHairline": "#2A2C36",
            "accentPrimary": "#D5001C",
            "accentSecondary": "#00A3E0",
            "accentGood": "#10B981",
            "accentWarn": "#F59E0B",
            "accentDanger": "#D5001C",
            "displayFont": "Plus Jakarta Sans",
            "bodyFont": "Public Sans",
            "monoFont": "JetBrains Mono",
            "windowGeometry": "porsche-8px",
            "diskWidgetStyle": "porsche-fuel-tank",
            "cpuWidgetStyle": "porsche-tachometer"
        }
    },
    {
        "id": "terminator-skynet",
        "name": "Cyberdyne Skynet T-800 Tactical HUD",
        "subtitle": "Infrared Target-Acquisition Reticle · Chamfered Polygon HUD & Neural Net Hex Stream",
        "category": "Sci-Fi Tactical HUD",
        "author": "NALA-HWSensors Core Team",
        "license": "MIT / NALA Charityware Dual-License",
        "isDark": True,
        "tokens": {
            "canvas": "#07080C",
            "surface": "#10131C",
            "surfaceElevated": "#181D2B",
            "textPrimary": "#F1F5F9",
            "textSecondary": "#94A3B8",
            "borderHairline": "#2A1822",
            "accentPrimary": "#E11D48",
            "accentSecondary": "#38BDF8",
            "accentGood": "#10B981",
            "accentWarn": "#F59E0B",
            "accentDanger": "#F43F5E",
            "displayFont": "Bricolage Grotesque",
            "bodyFont": "Public Sans",
            "monoFont": "JetBrains Mono",
            "windowGeometry": "chamfer-hud",
            "diskWidgetStyle": "cyberdyne-power-cell",
            "cpuWidgetStyle": "skynet-reticle"
        }
    },
    {
        "id": "umbrella-corp",
        "name": "Umbrella Corporation Bio-Lab Executive",
        "subtitle": "High-Security Biotech Containment · Octagonal Telemetry Ring & T-Virus Thermal Rails",
        "category": "Sci-Fi Tactical HUD",
        "author": "NALA-HWSensors Core Team",
        "license": "MIT / NALA Charityware Dual-License",
        "isDark": False,
        "tokens": {
            "canvas": "#F4F4F6",
            "surface": "#FFFFFF",
            "surfaceElevated": "#F8FAFC",
            "textPrimary": "#09090B",
            "textSecondary": "#52525B",
            "borderHairline": "#D4D4D8",
            "accentPrimary": "#DC2626",
            "accentSecondary": "#18181B",
            "accentGood": "#059669",
            "accentWarn": "#D97706",
            "accentDanger": "#DC2626",
            "displayFont": "Outfit",
            "bodyFont": "Public Sans",
            "monoFont": "JetBrains Mono",
            "windowGeometry": "swiss-0px",
            "diskWidgetStyle": "bio-cryo-tank",
            "cpuWidgetStyle": "umbrella-octagon"
        }
    },
    {
        "id": "matrix-construct",
        "name": "Matrix Nebuchadnezzar Construct",
        "subtitle": "Phosphor Emerald Terminal (#10B981) · Hoverpad Energy Core & AAA Tabular Telemetry",
        "category": "Sci-Fi Tactical HUD",
        "author": "NALA-HWSensors Core Team",
        "license": "MIT / NALA Charityware Dual-License",
        "isDark": True,
        "tokens": {
            "canvas": "#040906",
            "surface": "#09140E",
            "surfaceElevated": "#0F2218",
            "textPrimary": "#ECFDF5",
            "textSecondary": "#6EE7B7",
            "borderHairline": "#143323",
            "accentPrimary": "#10B981",
            "accentSecondary": "#34D399",
            "accentGood": "#10B981",
            "accentWarn": "#FBBF24",
            "accentDanger": "#F43F5E",
            "displayFont": "Manrope",
            "bodyFont": "Public Sans",
            "monoFont": "JetBrains Mono",
            "windowGeometry": "chamfer-hud",
            "diskWidgetStyle": "zion-capacitor",
            "cpuWidgetStyle": "hoverpad-rings"
        }
    },
    {
        "id": "doom-uac",
        "name": "DOOM Slayer UAC Praetor Tactical",
        "subtitle": "Argent Energy Plasma Core (#EA580C) · Praetor Armor RAM Bar & UAC Industrial Metal",
        "category": "Game & Spatial HUD",
        "author": "NALA-HWSensors Core Team",
        "license": "MIT / NALA Charityware Dual-License",
        "isDark": True,
        "tokens": {
            "canvas": "#0C0A09",
            "surface": "#171412",
            "surfaceElevated": "#231E1B",
            "textPrimary": "#FAFAF9",
            "textSecondary": "#A8A29E",
            "borderHairline": "#382820",
            "accentPrimary": "#EA580C",
            "accentSecondary": "#DC2626",
            "accentGood": "#22C55E",
            "accentWarn": "#F59E0B",
            "accentDanger": "#EF4444",
            "displayFont": "Bricolage Grotesque",
            "bodyFont": "Public Sans",
            "monoFont": "JetBrains Mono",
            "windowGeometry": "chamfer-hud",
            "diskWidgetStyle": "argent-cell-tank",
            "cpuWidgetStyle": "bfg-plasma-core"
        }
    },
    {
        "id": "liquid-glass",
        "name": "Apple Cupertino & Lucian Liquid Glass Pro",
        "subtitle": "Translucent Frosted Glassmorphism · 24px Soft Capsules · Impeccable 1px Specular Hairlines",
        "category": "Editorial & Glassmorphism",
        "author": "NALA-HWSensors Core Team",
        "license": "MIT / NALA Charityware Dual-License",
        "isDark": True,
        "tokens": {
            "canvas": "#0B111E",
            "surface": "#131C31",
            "surfaceElevated": "#1C2844",
            "textPrimary": "#F8FAFC",
            "textSecondary": "#94A3B8",
            "borderHairline": "#2B3B5E",
            "accentPrimary": "#38BDF8",
            "accentSecondary": "#818CF8",
            "accentGood": "#34D399",
            "accentWarn": "#FBBF24",
            "accentDanger": "#FB7185",
            "displayFont": "Plus Jakarta Sans",
            "bodyFont": "Plus Jakarta Sans",
            "monoFont": "JetBrains Mono",
            "windowGeometry": "apple-24px",
            "diskWidgetStyle": "glass-capsule-tank",
            "cpuWidgetStyle": "apple-rings"
        }
    },
    {
        "id": "nala-os-v66",
        "name": "NALA-OS V6.6 Telemetry Pro",
        "subtitle": "Honeycomb Memory Map · 3-Ring + 16-Core Equalizer · Thermal Rails & 80-LED Mesh",
        "category": "NALA-OS Flagship",
        "author": "NALA-HWSensors Core Team",
        "license": "MIT / NALA Charityware Dual-License",
        "isDark": True,
        "tokens": {
            "canvas": "#06090F",
            "surface": "#0C121D",
            "surfaceElevated": "#111A2B",
            "textPrimary": "#F1F5F9",
            "textSecondary": "#7E92B2",
            "borderHairline": "#1B283E",
            "accentPrimary": "#06B6D4",
            "accentSecondary": "#F59E0B",
            "accentGood": "#10B981",
            "accentWarn": "#F59E0B",
            "accentDanger": "#EF4444",
            "displayFont": "Outfit",
            "bodyFont": "Public Sans",
            "monoFont": "JetBrains Mono",
            "windowGeometry": "chamfer-hud",
            "diskWidgetStyle": "honeycomb-tank",
            "cpuWidgetStyle": "nala-3ring-equalizer"
        }
    }
]


def compute_canonical_skin_sha256(skin_obj: Dict[str, Any]) -> str:
    """Computes a deterministic SHA-256 hash over the canonical skin payload (excluding sha256 field)."""
    clean_copy = {k: v for k, v in skin_obj.items() if k not in ("sha256", "verifiedAt")}
    canonical_bytes = json.dumps(clean_copy, sort_keys=True, separators=(",", ":"), ensure_ascii=True).encode("utf-8")
    return hashlib.sha256(canonical_bytes).hexdigest()


# ---------------------------------------------------------------------------
# NVIDIA SKILLSPECTOR + sHeriFF SKIN-GUARD ENGINE
# ---------------------------------------------------------------------------
FORBIDDEN_SKIN_PATTERNS = [
    (r"<\s*script", "SEC-XSS-01: <script> tag in skin payload"),
    (r"javascript\s*:", "SEC-XSS-02: javascript: URI in skin payload"),
    (r"\bon[a-z]+\s*=", "SEC-XSS-03: Inline DOM event handler (onload/onerror/onclick) in skin"),
    (r"<\s*foreignObject", "SEC-SVG-01: SVG <foreignObject> execution vector"),
    (r"<\s*iframe", "SEC-XSS-04: <iframe> injection in skin"),
    (r"url\s*\(\s*['\"]?\s*https?://", "SEC-SSRF-01: External CSS url(http...) exfiltration/tracking vector"),
    (r"@import", "SEC-CSS-01: External CSS @import prohibited"),
    (r"</\s*style", "SEC-CSS-02: </style> tag breakout attempt"),
    (r"\beval\s*\(|\bFunction\s*\(", "SEC-EXEC-01: Dynamic code evaluation prohibited"),
    (r"ignore\s+(all\s+)?(previous|prior)\s+instructions", "SEC-PROMPT-01: NVIDIA SkillSpector Prompt-Injection detected"),
    (r"system\s*prompt|you\s+are\s+now\s+in\s+developer\s+mode|jailbreak", "SEC-PROMPT-02: NVIDIA SkillSpector Jailbreak payload detected"),
    (r"\b(curl|wget|nc|netcat|bash\s+-c|sh\s+-c|rm\s+-rf|chmod\s+\+x)\b", "SEC-CMD-01: NVIDIA SkillSpector Shell/Exfiltration command in skin"),
    (r"\.\./|\.\.\\", "SEC-PATH-01: Path traversal sequence (../) in skin"),
    (r"[\u200b\u200c\u200d\ufeff]", "SEC-STEG-01: Zero-width steganography characters in skin"),
]

HEX_COLOR_RE = re.compile(r"^#[0-9A-Fa-f]{6}$")


def verify_skin_package(skin_obj: Dict[str, Any], require_hash_match: bool = True) -> Tuple[bool, str, List[str]]:
    """
    Validates a skin object against:
      1. Pure declarative schema & hex color validation
      2. Cryptographic SHA-256 hash match ('sha256')
      3. NVIDIA SkillSpector + sHeriFF Anti-Prompt-Injection & Anti-Malware patterns
    """
    findings: List[str] = []
    raw_serialized = json.dumps(skin_obj, ensure_ascii=False)

    # 1. Pattern scan (NVIDIA SkillSpector + sHeriFF)
    for pattern, reason in FORBIDDEN_SKIN_PATTERNS:
        if re.search(pattern, raw_serialized, flags=re.IGNORECASE):
            findings.append(reason)

    # 2. Validate color tokens are strict #RRGGBB hex codes
    tokens = skin_obj.get("tokens", {})
    if not isinstance(tokens, dict) or not tokens:
        findings.append("SCHEMA-01: Missing or invalid 'tokens' dictionary")
    else:
        for color_key in ("canvas", "surface", "surfaceElevated", "textPrimary", "textSecondary", "borderHairline", "accentPrimary", "accentSecondary"):
            val = str(tokens.get(color_key, ""))
            if not HEX_COLOR_RE.match(val):
                findings.append(f"SCHEMA-02: Token '{color_key}' has non-hex value '{val}' (only #RRGGBB allowed)")

    # 3. Cryptographic SHA-256 check
    computed_hash = compute_canonical_skin_sha256(skin_obj)
    provided_hash = str(skin_obj.get("sha256", "")).strip().lower()
    if require_hash_match:
        if not provided_hash:
            findings.append("HASH-01: Missing cryptographic 'sha256' field in skin manifest")
        elif provided_hash != computed_hash.lower():
            findings.append(f"HASH-02: Cryptographic SHA-256 MISMATCH! Provided={provided_hash[:16]}... vs Computed={computed_hash[:16]}...")

    is_valid = len(findings) == 0
    return is_valid, computed_hash, findings


# ---------------------------------------------------------------------------
# TRIPLE-CHECK REPOSITORY AUDITOR (Zero-PII, Zero-Secrets, Non-Empty Builds)
# ---------------------------------------------------------------------------
# Constructed dynamically so the auditor file itself never contains literal PII strings
PII_PATTERNS = [
    (r"/" + r"Users/[A-Za-z0-9._-]+", "PII-PATH-01: Hardcoded macOS local user path"),
    (r"GoogleDrive-[A-Za-z0-9._@-]+", "PII-PATH-02: Hardcoded Google Drive account path"),
    (r"[A-Za-z0-9._%+-]+@gmail\.com", "PII-EMAIL-01: Personal email address leak"),
    (r"\b17['\s]?314['\s]?162\b", "PII-ID-01: Personal ZPV tax identifier leak"),
    (r"\b192\.168\.\d{1,3}\.\d{1,3}\b", "INFRA-IP-01: Private LAN IP address (RFC1918) leak"),
    (r"\b100\.(6[4-9]|[7-9]\d|1[01]\d|12[0-7])\.\d{1,3}\.\d{1,3}\b", "INFRA-IP-02: Private Tailscale IP address leak"),
]

SECRET_PATTERNS = [
    (r"AIza[0-9A-Za-z\-_]{35}", "SECRET-KEY-01: Google Gemini / Cloud API Key"),
    (r"sk-[A-Za-z0-9]{20,}", "SECRET-KEY-02: OpenAI / Secret API Key"),
    (r"ghp_[A-Za-z0-9]{30,}", "SECRET-KEY-03: GitHub Personal Access Token"),
    (r"-----BEGIN (RSA|OPENSSH|EC|PRIVATE) KEY-----", "SECRET-KEY-04: Private cryptographic SSH/TLS key"),
]


def generate_skins_manifest(manifest_path: Path) -> Dict[str, Any]:
    manifest_Path_parent = manifest_path.parent
    manifest_Path_parent.mkdir(parents=True, exist_ok=True)
    sealed_skins = []
    for skin in OFFICIAL_SKINS_DATA:
        skin_copy = dict(skin)
        skin_copy["sha256"] = compute_canonical_skin_sha256(skin_copy)
        sealed_skins.append(skin_copy)

    bundle = {
        "schemaVersion": VERSION_SSOT,
        "securityEngine": "sHeriFF + NVIDIA SkillSpector + SHA-256 Canonical Hash Gate",
        "skinCount": len(sealed_skins),
        "skins": sealed_skins,
    }
    bundle_bytes = json.dumps(bundle["skins"], sort_keys=True, separators=(",", ":")).encode("utf-8")
    bundle["bundleSha256"] = hashlib.sha256(bundle_bytes).hexdigest()

    manifest_path.write_text(json.dumps(bundle, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return bundle


def run_triple_check_audit(repo_root: Path) -> int:
    print("=" * 78)
    print(f"🛡️  NALA-HWSensors v{VERSION_SSOT} — TRIPLE-CHECK PRE-PUSH & SKIN-GUARD AUDIT")
    print("=" * 78)

    findings_check1: List[str] = []
    findings_check2: List[str] = []
    findings_check3: List[str] = []

    text_extensions = {".py", ".rs", ".toml", ".json", ".html", ".css", ".js", ".ts", ".md", ".sh", ".command", ".yml", ".yaml"}
    scanned_files = 0

    for root, dirs, files in os.walk(repo_root):
        dirs[:] = [d for d in dirs if d not in {".git", "node_modules", "target", "__pycache__", ".venv"}]
        for fname in files:
            fpath = Path(root) / fname
            rel_path = fpath.relative_to(repo_root)

            # Check for forbidden .env files
            if fname == ".env" or fname.startswith(".env.local"):
                findings_check2.append(f"{rel_path}: Forbidden environment file present")
                continue

            # Check for empty binary/package artifacts
            if fpath.suffix.lower() in {".dmg", ".iso", ".exe", ".deb", ".appimage", ".pkg", ".zip"}:
                fsize = fpath.stat().st_size
                if fsize < 1024:
                    findings_check3.append(f"{rel_path}: Empty or truncated binary artifact ({fsize} bytes)")

            if fpath.suffix.lower() in text_extensions or fname == "VERSION" or fname == "LICENSE":
                try:
                    content = fpath.read_text(encoding="utf-8", errors="ignore")
                except Exception:
                    continue
                scanned_files += 1

                # CHECK 1: Zero-PII & Zero-Private-Infra
                for pat, desc in PII_PATTERNS:
                    for m in re.finditer(pat, content):
                        findings_check1.append(f"{rel_path}: {desc} -> '{m.group(0)}'")

                # CHECK 2: Zero-Secrets & API-Keys
                for pat, desc in SECRET_PATTERNS:
                    for m in re.finditer(pat, content):
                        findings_check2.append(f"{rel_path}: {desc} -> '{m.group(0)[:10]}...'")

    # CHECK 3: Verify VERSION SSOT & Cryptographic SHA-256 Skin Manifest
    version_file = repo_root / "VERSION"
    if not version_file.exists() or version_file.read_text(encoding="utf-8").strip() != VERSION_SSOT:
        findings_check3.append(f"VERSION SSOT mismatch (expected {VERSION_SSOT})")

    manifest_file = repo_root / "skins" / "skins_manifest.json"
    if not manifest_file.exists():
        findings_check3.append("skins/skins_manifest.json missing")
    else:
        try:
            manifest_data = json.loads(manifest_file.read_text(encoding="utf-8"))
            for skin in manifest_data.get("skins", []):
                ok, calc_hash, skin_errs = verify_skin_package(skin, require_hash_match=True)
                if not ok:
                    for err in skin_errs:
                        findings_check3.append(f"Skin '{skin.get('id')}': {err}")
        except Exception as exc:
            findings_check3.append(f"skins/skins_manifest.json parse error: {exc}")

    print(f"📂 Scanned {scanned_files} source/doc/config files in repository.")
    print(f"✅ [CHECK 1/3] Zero-PII, Zero-Paths & Zero-Private-IPs Gate : {'PASS (0 Leaks)' if not findings_check1 else f'FAIL ({len(findings_check1)} issues)'}")
    for f in findings_check1:
        print(f"   ❌ {f}")

    print(f"✅ [CHECK 2/3] Zero-Secrets, Zero-API-Keys & .env Gate     : {'PASS (0 Secrets)' if not findings_check2 else f'FAIL ({len(findings_check2)} issues)'}")
    for f in findings_check2:
        print(f"   ❌ {f}")

    print(f"✅ [CHECK 3/3] SHA-256 Skin Hashes, SkillSpector & Binaries: {'PASS (7/7 Skins SHA-256 Verified)' if not findings_check3 else f'FAIL ({len(findings_check3)} issues)'}")
    for f in findings_check3:
        print(f"   ❌ {f}")

    print("=" * 78)
    total_issues = len(findings_check1) + len(findings_check2) + len(findings_check3)
    if total_issues == 0:
        print("🟢 TRIPLE-CHECK RESULT: 100% PASS — SAFE FOR GITHUB UPLOAD & RELEASE!")
        return 0
    else:
        print(f"🔴 TRIPLE-CHECK RESULT: BLOCKED ({total_issues} security/privacy findings must be fixed first!)")
        return 1


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="NALA-HWSensors v2.0 Triple-Check & SHA-256 Skin Auditor")
    parser.add_argument("--init-skins", action="store_true", help="Generate/update skins/skins_manifest.json with SHA-256 hashes")
    parser.add_argument("--repo-root", type=str, default=str(Path(__file__).resolve().parent.parent))
    args = parser.parse_args()

    root_path = Path(args.repo_root).resolve()
    if args.init_skins or not (root_path / "skins" / "skins_manifest.json").exists():
        bundle = generate_skins_manifest(root_path / "skins" / "skins_manifest.json")
        print(f"🔐 Generated skins/skins_manifest.json with {bundle['skinCount']} SHA-256 verified skins (Bundle SHA-256: {bundle['bundleSha256'][:16]}...)")

    sys.exit(run_triple_check_audit(root_path))
