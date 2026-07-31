// ==============================
// 敵クラス
// 画面上部中央に固定され、プレイヤーからダメージを受けない
// 責務：位置の保持・弾幕パターンの管理
// 弾の生成は行わない（BulletPatternに委譲する）
// ==============================
class Enemy {
  PVector pos;
  float radius; // 描画用の半径（当たり判定には使用しない＝攻撃対象ではないため）

  // 使用する弾幕パターンのリスト
  // 将来的に複数パターンの同時発動・切り替えに対応できるようArrayListで管理
  ArrayList<BulletPattern> patterns;

  Enemy(PVector fixedPos) {
    pos = fixedPos.copy();
    radius = Config.ENEMY_RADIUS;
    patterns = new ArrayList<BulletPattern>();
  }

  // ---------- 敵弾生成 ----------
  // 各パターンを更新し、発射タイミングが来ていれば敵弾リストへ弾を追加させる
  void updatePatterns(PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    for (BulletPattern p : patterns) {
      p.update(this, playerPos, enemyBullets);
    }
  }

  // ---------- 描画 ----------
  void draw() {
    drawShape();
  }

  void drawShape() {
    drawCircle(pos, radius, color(255, 60, 60)); // 赤
  }
}
