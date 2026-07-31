// ==============================
// 自機狙い弾パターン
// 発射した瞬間のプレイヤー座標へ向かう方向で1発発射する
// 発射後は方向を変えない（ホーミングしない）
// ==============================
class AimPattern_Double extends BulletPattern {
  float bulletSpeed;
  float bulletRadius;

  AimPattern_Double() {
    super(Config.ENEMY_AIM_INTERVAL);
    bulletSpeed = Config.ENEMY_AIM_BULLET_SPEED;
    bulletRadius = Config.ENEMY_AIM_BULLET_RADIUS;
  }

  @Override
  void fire(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    // 発射時点でのプレイヤー方向を計算（以降は追尾しない）
    PVector dir = PVector.sub(playerPos, enemy.pos);
    dir.add(100,0);
    dir.normalize();
    dir.mult(bulletSpeed);
    enemyBullets.add(new EnemyBullet(enemy.pos, dir, bulletRadius));
    dir = PVector.sub(playerPos, enemy.pos);
    dir.add(-100,0);
    dir.normalize();
    dir.mult(bulletSpeed);
    enemyBullets.add(new EnemyBullet(enemy.pos, dir, bulletRadius));
  }
}
