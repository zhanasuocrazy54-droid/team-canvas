// ==============================
// 敵が発射する弾（画面上部の画面外から降ってくる弾）
// FallPatternの各実装（StraightFallPattern等）が生成する
// 以前あった被弾回数（hp）は廃止し、1回の接触で消滅する
// ==============================
class EnemyBullet extends Bullet {

  EnemyBullet(PVector pos, PVector vel, float radius) {
    super(pos, vel, radius);
  }

  @Override
  color getColor() {
    return color(255, 90, 90); // 赤
  }

  // ---------- 更新（プレイヤー座標つき） ----------
  // ホーミング弾など、更新時にプレイヤーの位置を必要とする弾のために用意した入口
  // 通常弾（このクラス自身）はプレイヤー座標を無視し、従来通りvelに従って直進する
  void updateWithPlayer(PVector playerPos) {
    update();
  }

  // ---------- 削除判定 ----------
  // ワールド座標系のため、画面外判定はカメラ位置を基準に行う
  // （X方向はカメラ追従がないため、スクリーンX=ワールドXのまま判定できる）
  boolean isOffscreen(Camera camera) {
    float margin = Config.REMOVE_MARGIN_BELOW_SCREEN;
    if (pos.y > camera.bottomWorldY() + margin) return true; // 画面下へ落ちきった
    if (pos.x < -margin || pos.x > width + margin) return true; // 左右に外れた
    return false;
  }
}
