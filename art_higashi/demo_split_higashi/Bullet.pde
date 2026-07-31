// ==============================
// 弾の基底クラス
// 「位置・速度・半径・更新・描画・当たり判定」のみを責務とする
// PlayerBullet / EnemyBullet はこのクラスを継承する
// ==============================
abstract class Bullet {
  PVector pos;
  PVector vel;
  float radius;

  Bullet(PVector pos, PVector vel, float radius) {
    this.pos = pos.copy();
    this.vel = vel.copy();
    this.radius = radius;
  }

  // ---------- 更新 ----------
  // 速度に応じて位置を更新するだけの共通処理
  void update() {
    pos.add(vel);
  }

  // ---------- 描画 ----------
  // 形は円で統一し、色のみ継承先で切り替える
  // 将来的に画像や2〜3コマアニメーションへ置き換える場合はこのメソッドを差し替える
  void draw() {
    drawCircle(pos, radius, getColor());
  }

  // 継承先で色を指定させる
  abstract color getColor();

  // ---------- 当たり判定 ----------
  // 円形判定：中心間の距離が半径の合計より小さければ衝突
  boolean isHit(PVector otherPos, float otherRadius) {
    float d = PVector.dist(this.pos, otherPos);
    return d < (this.radius + otherRadius);
  }

  // ---------- 削除判定 ----------
  // 画面外に十分出た弾は不要オブジェクトとして削除対象にする
  boolean isOffscreen() {
    float margin = 50;
    return pos.x < -margin || pos.x > width + margin ||
           pos.y < -margin || pos.y > height + margin;
  }
}
