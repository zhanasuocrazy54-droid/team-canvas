// ==============================
// アップグレードの基底クラス
// 責務：名前と説明を持ち、apply()で実際の強化効果をプレイヤーに適用する
// LevelUpManagerが「今出せる候補（isAvailable）」を判定してから提示する
// ==============================
abstract class Upgrade {
  String name;
  String description;

  Upgrade(String name, String description) {
    this.name = name;
    this.description = description;
  }

  // このアップグレードを今、選択肢として出してよいか
  // デフォルトは常に出せる。武器追加系のみオーバーライドして重複取得を防ぐ
  boolean isAvailable(GameManager gm) {
    return true;
  }

  abstract void apply(GameManager gm);
}

// ---------- 拡散弾を追加装備 ----------
class AddShotgunUpgrade extends Upgrade {
  AddShotgunUpgrade() {
    super("拡散弾", "拡散弾を追加装備する");
  }

  @Override
  boolean isAvailable(GameManager gm) {
    return !hasWeapon(gm, ShotgunShot.class);
  }

  @Override
  void apply(GameManager gm) {
    gm.player.weapons.add(new ShotgunShot());
  }
}

// ---------- 近接攻撃を追加装備 ----------
class AddMeleeUpgrade extends Upgrade {
  AddMeleeUpgrade() {
    super("近接攻撃", "近接攻撃を追加装備する");
  }

  @Override
  boolean isAvailable(GameManager gm) {
    return !hasWeapon(gm, MeleeAttack.class);
  }

  @Override
  void apply(GameManager gm) {
    gm.player.weapons.add(new MeleeAttack());
  }
}

// ---------- ライフ増加 ----------
class IncreaseLifeUpgrade extends Upgrade {
  IncreaseLifeUpgrade() {
    super("ライフ増加", "ライフ+3");
  }

  @Override
  void apply(GameManager gm) {
    gm.player.life += 3;
  }
}

// ---------- 移動速度アップ ----------
class IncreaseSpeedUpgrade extends Upgrade {
  IncreaseSpeedUpgrade() {
    super("移動速度UP", "移動速度が上がる");
  }

  @Override
  void apply(GameManager gm) {
    gm.player.speedMultiplier += 0.2;
  }
}

// ---------- 連射速度アップ ----------
class AttackSpeedUpgrade extends Upgrade {
  AttackSpeedUpgrade() {
    super("連射速度UP", "所持している全武器の発動間隔を短縮する");
  }

  @Override
  void apply(GameManager gm) {
    for (Weapon w : gm.player.weapons) {
      w.interval = max(3, int(w.interval * 0.85));
    }
  }
}

// ---------- 共通ヘルパー ----------
// 指定した型の武器をプレイヤーが既に持っているか調べる
// DrawUtilsのdrawCircle()と同様、トップレベル関数として定義する
boolean hasWeapon(GameManager gm, Class<?> weaponClass) {
  for (Weapon w : gm.player.weapons) {
    if (weaponClass.isInstance(w)) return true;
  }
  return false;
}
