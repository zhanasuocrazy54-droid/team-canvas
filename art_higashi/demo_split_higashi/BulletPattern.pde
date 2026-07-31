// ==============================
// 弾幕パターンの基底クラス
// 責務：発射間隔（interval）の管理とタイミング判定のみ
// 実際の弾生成ロジックは継承先のfire()に委譲する（テンプレートメソッド構造）
// ==============================
abstract class BulletPattern {
  int interval; // 発射間隔（フレーム数）
  int timer;    // 経過フレーム数のカウンタ

  BulletPattern(int interval) {
    this.interval = interval;
    this.timer = 0;
  }

  // ---------- 更新 ----------
  // 毎フレーム呼ばれる。タイマーが間隔に達したら発射しリセットする
  void update(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    timer++;
    if (timer >= interval) {
      timer = 0;
      fire(enemy, playerPos, enemyBullets);
    }
  }

  // ---------- 弾生成 ----------
  // 継承先で「どんな弾をどう配置するか」のみを実装する
  abstract void fire(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets);

  // ---------- 描画 ----------
  // 多くのパターンは専用の描画を持たないためデフォルトは空実装
  // 弾の発生源が敵本体と異なる位置になるパターンのみオーバーライドして可視化する
  void draw() {
  }
}
