// ==============================
// 武器の基底クラス
// 責務：発動間隔（interval）の管理とタイミング判定のみ
// 実際の効果（弾生成、範囲攻撃など）は継承先のactivate()に委譲する
// ==============================
abstract class Weapon {
  int interval; // 発動間隔（フレーム数）
  int timer;    // 経過フレーム数のカウンタ

  Weapon(int interval) {
    this.interval = interval;
    this.timer = 0;
  }

  // ---------- 更新 ----------
  // 毎フレーム呼ばれる。タイマーが間隔に達したら発動しリセットする
  void update(Player player, ArrayList<PlayerBullet> playerBullets) {
    timer++;
    if (timer >= interval) {
      timer = 0;
      activate(player, playerBullets);
    }
  }

  // ---------- 発動処理 ----------
  // 継承先で「発動時に何をするか」のみを実装する
  // 弾を生成しない武器（近接攻撃など）はplayerBulletsを使わなくてよい
  abstract void activate(Player player, ArrayList<PlayerBullet> playerBullets);

  // ---------- 描画 ----------
  // 多くの武器は専用の描画を持たないためデフォルトは空実装
  // 近接攻撃のように範囲を可視化したい武器のみオーバーライドする
  void draw(Player player) {
  }
}
