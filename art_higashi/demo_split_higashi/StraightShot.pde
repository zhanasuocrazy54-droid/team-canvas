// ==============================
// 通常弾（StraightShot）
// 一定間隔で、プレイヤーの真上方向へ弾を発射する
// ==============================
class StraightShot extends Weapon {
  float bulletSpeed;
  float bulletRadius;

  StraightShot() {
    super(Config.STRAIGHT_SHOT_INTERVAL);
    bulletSpeed = Config.PLAYER_BULLET_SPEED;
    bulletRadius = Config.PLAYER_BULLET_RADIUS;
  }

  @Override
  void activate(Player player, ArrayList<PlayerBullet> playerBullets) {
    // 真上方向（y軸マイナス方向）へ飛ばす
    PVector vel = new PVector(0, -1);
    vel.mult(bulletSpeed);
    playerBullets.add(new PlayerBullet(player.pos, vel, bulletRadius));
  }
}
