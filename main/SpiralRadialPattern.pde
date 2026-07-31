// ==============================
// 螺旋放射弾パターン
// 放射弾を回転させて螺旋状にうつパターン
// ==============================
class SpiralRadialPattern extends BulletPattern {
  int bulletCount;     // 一度に放射する弾数
  float bulletSpeed;   // 弾速
  float bulletRadius;  // 弾のサイズ（当たり判定半径）
  float angleOffset;         // 回転中の角度

  SpiralRadialPattern() {
    super(Config.ENEMY_SPIRALRADIAL_INTERVAL);
    bulletCount = Config.ENEMY_SPIRALRADIAL_COUNT;
    bulletSpeed = Config.ENEMY_SPIRALRADIAL_BULLET_SPEED;
    bulletRadius = Config.ENEMY_SPIRALRADIAL_BULLET_RADIUS;
  }

  @Override
    void fire(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    // 360度を弾数で等分し、各方向へ弾を生成する
    float angleStep = TWO_PI / bulletCount;
    for (int i = 0; i < bulletCount; i++) {
      float angle = angleStep * i + angleOffset;
      PVector vel = new PVector(cos(angle), sin(angle));
      vel.mult(bulletSpeed);
      enemyBullets.add(new EnemyBullet(enemy.pos, vel, bulletRadius, enemy.rollBulletHp()));
      angleOffset+=0.01;
    }
  }
}
