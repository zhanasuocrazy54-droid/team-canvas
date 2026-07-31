// ==============================
// 弾の基底クラス
// 「位置・速度・半径・hp・更新・描画・当たり判定」のみを責務とする
// PlayerBullet / EnemyBullet はこのクラスを継承する
// ==============================
abstract class Bullet {
  PVector pos;
  PVector vel;
  float radius;
  int hp; // この弾が消えるまでに耐えられる被弾回数

  // hpを省略した場合は1（従来通り1発当たれば消える）として扱う
  Bullet(PVector pos, PVector vel, float radius) {
    this(pos, vel, radius, 1);
  }

  Bullet(PVector pos, PVector vel, float radius, int hp) {
    this.pos = pos.copy();
    this.vel = vel.copy();
    this.radius = radius;
    this.hp = hp;
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

  // ---------- ダメージ ----------
  // amount分だけhpを減らす。hpが0以下になったら削除してよい（true）ことを呼び出し元に伝える
  // hpが1のまま使えば「1発当たれば即消滅」という従来の挙動と完全に互換
  boolean damage(int amount) {
    hp -= amount;
    return hp <= 0;
  }

  // ---------- 削除判定 ----------
  // 画面外に十分出た弾は不要オブジェクトとして削除対象にする
  boolean isOffscreen() {
    float margin = 50;
    return pos.x < -margin || pos.x > width + margin ||
           pos.y < -margin || pos.y > height + margin;
  }
}
