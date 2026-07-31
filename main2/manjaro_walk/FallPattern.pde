// ==============================
// 落下型・敵弾パターンの基底クラス（旧BulletPatternを置き換え）
// 責務：生成間隔（interval）の管理とタイミング判定のみ
// 実際の弾生成ロジックは継承先のfire()に委譲する（テンプレートメソッド構造）
//
// 敵本体（Enemy）が廃止されたため、fire()は「現在のカメラ位置」と
// 「プレイヤーのワールド座標」のみを受け取り、画面上端（カメラ基準）の
// 画面外から弾を生成する
// ==============================
abstract class FallPattern {
  int interval; // 生成間隔（フレーム数）
  int timer;    // 経過フレーム数のカウンタ

  FallPattern(int interval) {
    this.interval = interval;
    this.timer = 0;
  }

  // ---------- 更新 ----------
  // 毎フレーム呼ばれる。タイマーが間隔に達したら発生させてリセットする
  void update(Camera camera, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    timer++;
    if (timer >= interval) {
      timer = 0;
      fire(camera, playerPos, enemyBullets);
    }
  }

  // ---------- 弾生成 ----------
  // 継承先で「どんな弾をどう配置するか」のみを実装する
  abstract void fire(Camera camera, PVector playerPos, ArrayList<EnemyBullet> enemyBullets);

  // 画面上端（カメラ基準）より少し上のワールドY座標を取得する共通ヘルパー
  float spawnWorldY(Camera camera) {
    return camera.topWorldY() - Config.SPAWN_MARGIN_ABOVE_SCREEN;
  }
}
