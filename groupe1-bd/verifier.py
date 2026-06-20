import sqlite3

def lire(f):
    return open(f, encoding="utf-8").read()

con = sqlite3.connect(":memory:")
con.execute("PRAGMA foreign_keys=ON")
for f in ["SGE_cre.sql", "SGE_inv.sql", "SGE_req.sql", "SGE_jdd_01.sql"]:
    con.executescript(lire(f))
print("Base construite :",
      con.execute("SELECT COUNT(*) FROM sqlite_master WHERE type='table'").fetchone()[0], "tables")

# Tests positifs : tout doit passer
try:
    con.executescript(lire("SGE_test-pos.sql"))
    print("Tests POSITIFS : OK (aucune erreur)")
except Exception as e:
    print("Tests POSITIFS : ECHEC ->", e)

# Tests negatifs : chaque ligne doit echouer
txt = lire("SGE_test-neg.sql")
txt = "\n".join(l for l in txt.splitlines() if not l.strip().startswith("--"))
instr = [s.strip() for s in txt.split(";") if s.strip() and "PRAGMA" not in s]
print("Tests NEGATIFS :", len(instr), "scenarios a bloquer")
for i, s in enumerate(instr, 1):
    try:
        con.execute(s)
        print("  N%d PROBLEME : accepte alors qu'il devrait echouer !" % i)
    except Exception:
        print("  N%d bloque OK" % i)