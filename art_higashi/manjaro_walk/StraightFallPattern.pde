// ==============================
// まっすぐ落下パターン
// 画面上部の画面外にランダムなX座標で弾を生成し、まっすぐ下方向へ落とす
// ==============================
class StraightFallPattern extends FallPattern {
  float bulletSpeed;
  float bulletRadius;

  StraightFallPattern() {
    super(Config.STRAIGHT_FALL_INTERVAL);
    bulletSpeed = Config.STRAIGHT_FALL_SPEED;
    bulletRadius = Config.STRAIGHT_FALL_RADIUS;
  }

  @Override
  void fire(Camera camera, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    float x = random(0, width);
    PVector pos = new PVector(x, spawnWorldY(camera));
    PVector vel = new PVector(0, bulletSpeed);
    enemyBullets.add(new EnemyBullet(pos, vel, bulletRadius, assets.bulletStraight));
  }
}
