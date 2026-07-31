// ==============================
// 近接攻撃（MeleeAttack）
// 弾は生成せず、プレイヤー周囲に一定時間だけ有効な範囲を発生させる
// 実際に「敵弾のみ消す」処理はCollisionManagerが行う
// （このクラスは「今アクティブかどうか」「有効範囲」だけを管理する）
// ==============================
class MeleeAttack extends Weapon {
  float radius;      // 近接攻撃の有効半径
  int duration;       // 有効時間（フレーム数）
  int activeTimer;    // 残り有効フレーム数（0のときは無効）

  MeleeAttack() {
    super(Config.MELEE_INTERVAL);
    radius = Config.MELEE_RADIUS;
    duration = Config.MELEE_DURATION;
    activeTimer = 0;
  }

  @Override
  void update(Player player, ArrayList<PlayerBullet> playerBullets) {
    // 発動タイミングの判定は基底クラスのupdate()に任せる
    super.update(player, playerBullets);

    // 有効時間のカウントダウン
    if (activeTimer > 0) {
      activeTimer--;
    }
  }

  @Override
  void activate(Player player, ArrayList<PlayerBullet> playerBullets) {
    // 弾は生成せず、有効時間をリセットするだけ
    activeTimer = duration;
  }

  // 現在、近接攻撃の判定が有効かどうか（CollisionManagerが参照する）
  boolean isActive() {
    return activeTimer > 0;
  }

  // ---------- 描画 ----------
  // 有効な間だけ半透明の円を表示する
  @Override
  void draw(Player player) {
    if (!isActive()) return;
    drawTranslucentCircle(player.pos, radius, color(255, 255, 255), 80);
  }
}
