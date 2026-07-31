// ==============================
// プレイヤークラス
// 責務：入力の解釈・移動・ライフ管理・武器の保持
// 弾の生成は行わない（Weaponに委譲することでPlayerを軽量に保つ）
// ==============================
class Player {
  PVector pos;
  float radius;   // 当たり判定用の半径（円形）。サイズ変更しやすいよう変数化
  int life;

  // 装備している武器のリスト
  // 将来的に武器アンロック・複数武器の同時運用に対応できるようArrayListで管理
  ArrayList<Weapon> weapons;

  Player(PVector startPos) {
    pos = startPos.copy();
    radius = Config.PLAYER_RADIUS;
    life = Config.PLAYER_LIFE_MAX;
    weapons = new ArrayList<Weapon>();
  }

  // ---------- 入力 ----------
  // キー入力から移動方向ベクトルを求める（正規化前）
  // keysHeld配列（メインスケッチで管理）を参照することで、複数キーの同時押し（斜め移動）に対応する
  PVector getInputDirection() {
    PVector dir = new PVector(0, 0);
    if (keysHeld['W']) dir.y -= 1;
    if (keysHeld['S']) dir.y += 1;
    if (keysHeld['A']) dir.x -= 1;
    if (keysHeld['D']) dir.x += 1;
    return dir;
  }

  // Shiftが押されているか（低速移動の判定）
  boolean isSlowMode() {
    return keysHeld[SHIFT];
  }

  // ---------- 移動 ----------
  void move() {
    PVector dir = getInputDirection();
    if (dir.mag() > 0) {
      dir.normalize();
      float speed = isSlowMode() ? Config.PLAYER_SLOW_SPEED : Config.PLAYER_SPEED;
      dir.mult(speed);
      pos.add(dir);
      clampToScreen();
    }
  }

  // 画面外へ出ないよう位置を制限する
  void clampToScreen() {
    pos.x = constrain(pos.x, radius, width - radius);
    pos.y = constrain(pos.y, radius, height - radius);
  }

  // ---------- 攻撃生成 ----------
  // 各武器を更新し、発射タイミングが来ていれば弾リストへ弾を追加させる
  void updateWeapons(ArrayList<PlayerBullet> playerBullets) {
    for (Weapon w : weapons) {
      w.update(this, playerBullets);
    }
  }

  // ---------- ダメージ ----------
  void takeDamage(int amount) {
    life -= amount;
    if (life < 0) life = 0;
  }

  boolean isDead() {
    return life <= 0;
  }

  // ---------- 描画 ----------
  // 現在は青い円のみ。将来的に画像/アニメーションへ差し替えやすいようdrawShape()に分離
  void draw() {
    drawShape();
    // 武器側の描画（近接攻撃の範囲表示など）はWeaponに委譲
    for (Weapon w : weapons) {
      w.draw(this);
    }
  }

  void drawShape() {
    drawCircle(pos, radius, color(80, 120, 255)); // 青
  }
}
