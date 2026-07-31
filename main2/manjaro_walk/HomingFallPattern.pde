// ==============================
// ホーミング落下パターン
// 画面上部の画面外にランダムなX座標で弾を生成し、
// プレイヤーより上にいる間は横方向のみ追尾しながら落下する
// （HomingEnemyBullet側の挙動については同クラスのコメントを参照）
// ==============================
class HomingFallPattern extends FallPattern {
  float fallSpeed;
  float bulletRadius;
  float maxHorizontalSpeed;
  float turnRate;

  HomingFallPattern() {
    super(Config.HOMING_FALL_INTERVAL);
    fallSpeed = Config.HOMING_FALL_SPEED;
    bulletRadius = Config.HOMING_FALL_RADIUS;
    maxHorizontalSpeed = Config.HOMING_FALL_MAX_HORIZONTAL_SPEED;
    turnRate = Config.HOMING_FALL_TURN_RATE;
  }

  @Override
  void fire(Camera camera, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    float x = random(0, width);
    PVector pos = new PVector(x, spawnWorldY(camera));
    PVector vel = new PVector(0, fallSpeed); // 縦方向速度はここで固定し、以後変化しない

    enemyBullets.add(new HomingEnemyBullet(pos, vel, bulletRadius, maxHorizontalSpeed, turnRate));
  }
}
