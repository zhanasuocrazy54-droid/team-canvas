// ==============================
// 弾の基底クラス
// 「位置・速度・半径・更新・描画・当たり判定」のみを責務とする
// 座標はすべてワールド座標で保持する（画面表示はGameManagerのカメラ変換に委ねる）
//
// 以前存在した被弾回数（hp）システムは、プレイヤー側の攻撃手段が
// なくなったことに伴い廃止した（弾は当たり判定に触れたら即消滅する）
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
}
