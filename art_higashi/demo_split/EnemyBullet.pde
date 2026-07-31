// ==============================
// 敵が発射する弾
// RadialPattern / AimPattern が生成する
// ==============================
class EnemyBullet extends Bullet {

  EnemyBullet(PVector pos, PVector vel, float radius) {
    super(pos, vel, radius);
  }

  @Override
  color getColor() {
    return color(255, 80, 80); // 赤
  }
}
