// ==============================
// プレイヤーが発射する弾
// 現時点では通常弾（StraightShot）が生成する
// ==============================
class PlayerBullet extends Bullet {

  PlayerBullet(PVector pos, PVector vel, float radius) {
    super(pos, vel, radius);
  }

  @Override
  color getColor() {
    return color(100, 200, 255); // 水色
  }
}
