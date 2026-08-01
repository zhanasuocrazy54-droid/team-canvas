// ==============================
// 敵が発射する弾（画面上部の画面外から降ってくる弾）
// FallPatternの各実装（StraightFallPattern等）が生成する
// 以前あった被弾回数（hp）は廃止し、1回の接触で消滅する
//
// テクスチャ（image）は攻撃パターン1種類につき1枚を割り当てる想定で、
// 生成時にFallPattern側から渡す。画像が未設定（null）の場合は
// 従来通り円で描画する（フォールバック）
// ==============================
class EnemyBullet extends Bullet {
  PImage image; // このインスタンスに割り当てられたテクスチャ（未設定ならnull）

  EnemyBullet(PVector pos, PVector vel, float radius, PImage image) {
    super(pos, vel, radius);
    this.image = image;
  }

  @Override
  color getColor() {
    return color(255, 90, 90,100); // 赤（画像未設定時のフォールバック色）
  }

  // ---------- 描画 ----------
  // 画像が設定されていればテクスチャを、なければ基底クラスの円描画を使う
  @Override
  void draw() {
    if (image != null) {
      drawImageCentered(image, pos, radius * 2);
    } else {
      super.draw();
    }
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
