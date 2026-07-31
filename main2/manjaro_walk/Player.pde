// ==============================
// プレイヤークラス
// 責務：入力の解釈・移動・ライフ管理・当たり判定（可変半径）・マンジャロ管理
// 攻撃手段は持たない（弾の生成は行わない）
// ==============================
class Player {
  PVector pos;      // ワールド座標
  float radius;     // 当たり判定用の半径（円形）。被弾で拡大、マンジャロで縮小する
  int life;

  int manjaroCount;        // 残りマンジャロ所持数
  int manjaroDebuffTimer;  // マンジャロ使用後のデバフ残りフレーム数（0のときは無効）

  Player(PVector startPos) {
    pos = startPos.copy();
    radius = Config.PLAYER_RADIUS_BASE;
    life = Config.PLAYER_LIFE_MAX;
    manjaroCount = Config.MANJARO_START_COUNT;
    manjaroDebuffTimer = 0;
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

  boolean isManjaroDebuffed() {
    return manjaroDebuffTimer > 0;
  }

  // ---------- 移動 ----------
  // X軸方向は画面内に制限する（カメラがX追従しないため、これが実質の左右可動域になる）
  // Y軸方向は制限しない（上方向へ進み続けることでゴールを目指す）
  void move() {
    PVector dir = getInputDirection();
    if (dir.mag() > 0) {
      dir.normalize();
      float speed = isSlowMode() ? Config.PLAYER_SLOW_SPEED : Config.PLAYER_SPEED;
      if (isManjaroDebuffed()) {
        speed *= Config.MANJARO_DEBUFF_SPEED_MULTIPLIER; // マンジャロ使用直後のデバフ
      }
      dir.mult(speed);
      pos.add(dir);
      clampXToScreen();
    }

    if (manjaroDebuffTimer > 0) {
      manjaroDebuffTimer--;
    }
  }

  // 画面外（左右）へ出ないよう位置を制限する
  void clampXToScreen() {
    pos.x = constrain(pos.x, radius, width - radius);
  }

  // ---------- 被弾 ----------
  // ダメージを与えると同時に、当たり判定を一段階拡大させる
  void takeDamage(int amount) {
    life -= amount;
    if (life < 0) life = 0;

    radius = min(Config.PLAYER_RADIUS_MAX, radius + Config.PLAYER_RADIUS_GROWTH_PER_HIT);
  }

  boolean isDead() {
    return life <= 0;
  }

  // ---------- マンジャロ ----------
  // スペースキーで消費：当たり判定を縮小する代わりに、一定時間の移動速度デバフを負う
  void useManjaro() {
    if (manjaroCount <= 0) return;

    manjaroCount--;
    radius = max(Config.PLAYER_RADIUS_MIN, radius - Config.MANJARO_RADIUS_SHRINK);
    manjaroDebuffTimer = Config.MANJARO_DEBUFF_DURATION_FRAMES;
  }

  // ---------- 描画 ----------
  // ワールド座標系のまま呼び出される想定（GameManager側でpushMatrix/translate済み）
  void draw() {
    color c = isManjaroDebuffed() ? color(160, 160, 255) : color(80, 120, 255);
    drawCircle(pos, radius, c);
  }
}
