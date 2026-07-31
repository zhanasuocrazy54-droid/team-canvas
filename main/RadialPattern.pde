// ==============================
// 放射弾パターン
// 一定間隔で、敵の位置を中心に円周方向へ複数の弾を放射する
// ==============================
class RadialPattern extends BulletPattern {
  int bulletCount;     // 一度に放射する弾数
  float bulletSpeed;   // 弾速
  float bulletRadius;  // 弾のサイズ（当たり判定半径）

  RadialPattern() {
    super(Config.ENEMY_RADIAL_INTERVAL);
    bulletCount = Config.ENEMY_RADIAL_COUNT;
    bulletSpeed = Config.ENEMY_RADIAL_BULLET_SPEED;
    bulletRadius = Config.ENEMY_RADIAL_BULLET_RADIUS;
  }

  @Override
  void fire(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    // 360度を弾数で等分し、各方向へ弾を生成する
    float angleStep = TWO_PI / bulletCount;
    for (int i = 0; i < bulletCount; i++) {
      float angle = angleStep * i;
      PVector vel = new PVector(cos(angle), sin(angle));
      vel.mult(bulletSpeed);
      // 弾ごとのhpは敵の難易度（maxBulletHp）に応じてランダムに決まる
      enemyBullets.add(new EnemyBullet(enemy.pos, vel, bulletRadius, enemy.rollBulletHp()));
    }
  }
}
