// ==============================
// 拡散弾（ShotgunShot）
// 一定間隔で、プレイヤーの真上を中心に扇状に複数の弾を発射する
// ==============================
class ShotgunShot extends Weapon {
  float bulletSpeed;
  float bulletRadius;
  int   bulletCount;   // 一度に発射する弾数
  float spreadAngle;   // 扇の広がり角度（ラジアン）

  ShotgunShot() {
    super(Config.SHOTGUN_INTERVAL);
    bulletSpeed  = Config.PLAYER_BULLET_SPEED;
    bulletRadius = Config.PLAYER_BULLET_RADIUS;
    bulletCount  = Config.SHOTGUN_BULLET_COUNT;
    spreadAngle  = radians(Config.SHOTGUN_SPREAD_ANGLE_DEG); // 度数→ラジアンに変換
  }

  @Override
  void activate(Player player, ArrayList<PlayerBullet> playerBullets) {
    // 基準角度は真上（-90度 = -HALF_PI）
    float baseAngle = -HALF_PI;

    // 弾数に応じて扇状に等間隔で方向を割り振る
    for (int i = 0; i < bulletCount; i++) {
      float t = (bulletCount == 1) ? 0.5 : (float) i / (bulletCount - 1); // 0.0〜1.0
      float angle = baseAngle - spreadAngle / 2 + spreadAngle * t;

      PVector vel = new PVector(cos(angle), sin(angle));
      vel.mult(bulletSpeed);
      playerBullets.add(new PlayerBullet(player.pos, vel, bulletRadius));
    }
  }
}
