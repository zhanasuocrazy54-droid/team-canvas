// ==============================
// 攻撃管理クラス（旧Enemyクラスを置き換え）
// 敵本体という「見た目・位置」を持たず、複数のFallPatternを
// 保持して更新するだけの役割に専念する
//
// 攻撃はすべて画面上部の画面外（カメラ基準）から生成されるため、
// 敵本体の座標という概念そのものが不要になった
// ==============================
class AttackDirector {
  ArrayList<FallPattern> patterns;

  AttackDirector() {
    patterns = new ArrayList<FallPattern>();
    patterns.add(new StraightFallPattern());
    patterns.add(new HomingFallPattern());
    patterns.add(new AimedFallPattern());
    patterns.add(new WaveFallPattern());
  }

  // 各パターンを更新し、発生タイミングが来ていれば敵弾リストへ弾を追加させる
  void update(Camera camera, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    for (FallPattern p : patterns) {
      p.update(camera, playerPos, enemyBullets);
    }
  }
}
