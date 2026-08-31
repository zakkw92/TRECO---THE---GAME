import sys
import os

print("=== VERIFICANDO ARQUIVOS DA FASE 1 DO PROJETO TRECO (GODOT 4) ===")

project_dir = r"C:\Users\Guilherme\.gemini\antigravity\scratch\TrecoGame"
required_files = [
    "project.godot",
    "scripts/core/CardData.gd",
    "scripts/core/TrucoRules.gd",
    "scripts/core/Deck.gd",
    "scripts/core/MatchManager.gd",
    "scripts/effects/TrecoEffect.gd",
    "scripts/effects/OlhoDeLinceEffect.gd",
    "scripts/effects/FumacaDeTavernaEffect.gd",
    "scripts/ui/CandleLight.gd"
]

missing = []
for rel_path in required_files:
    full_path = os.path.join(project_dir, rel_path)
    if os.path.exists(full_path):
        size = os.path.getsize(full_path)
        print(f"[OK] {rel_path} ({size} bytes)")
    else:
        print(f"[ERRO] Faltando: {rel_path}")
        missing.append(rel_path)

if not missing:
    print("\nTODOS OS ARQUIVOS DA FASE 1 FORAM CRIADOS COM SUCESSO!")
else:
    print(f"\n{len(missing)} arquivo(s) faltando.")
    sys.exit(1)
