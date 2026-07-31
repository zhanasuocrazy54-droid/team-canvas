// ==============================
// 敵が発射する弾
// RadialPattern / AimPattern が生成する
// ==============================
class EnemyBullet extends Bullet {

  // hpを指定しない場合は1（1発で消える通常の弾）
  EnemyBullet(PVector pos, PVector vel, float radius) {
    super(pos, vel, radius, 1);
  }

  // 難易度が上がると、複数発当てないと消えない硬い弾を生成できる
  EnemyBullet(PVector pos, PVector vel, float radius, int hp) {
    super(pos, vel, radius, hp);
  }

  @Override
  color getColor() {
    // hpが高いほど白っぽくして、耐久力が高いことが見た目で分かるようにする
    int extra = (hp - 1) * 60;
    return color(255, min(255, 80 + extra), min(255, 80 + extra));
  }
}
