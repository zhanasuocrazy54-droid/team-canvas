// ==============================
// らせん弾パターン
// 一定間隔で1発ずつ発射しつつ、毎回少しずつ発射角度をずらすことで
// 弾の軌跡全体が渦（らせん）状に見えるようにする
// ==============================
class SpiralPattern extends BulletPattern {
  float bulletSpeed;
  float bulletRadius;
  float angleStep; // 1発ごとに進める角度（ラジアン）
  float angle;      // 現在の発射角度

  SpiralPattern() {
    super(Config.ENEMY_SPIRAL_INTERVAL);
    bulletSpeed  = Config.ENEMY_SPIRAL_BULLET_SPEED;
    bulletRadius = Config.ENEMY_SPIRAL_BULLET_RADIUS;
    angleStep    = radians(Config.ENEMY_SPIRAL_ANGLE_STEP_DEG);
    angle = 0;
  }

  @Override
  void fire(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    PVector vel = new PVector(cos(angle), sin(angle));
    vel.mult(bulletSpeed);
    enemyBullets.add(new EnemyBullet(enemy.pos, vel, bulletRadius, enemy.rollBulletHp()));

    angle += angleStep; // 次弾は少し回転させた角度で発射する
  }
}
