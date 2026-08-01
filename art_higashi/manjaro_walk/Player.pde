// ==============================
// プレイヤークラス
// 責務：入力の解釈・移動・ライフ管理・当たり判定（可変半径）・マンジャロ管理・
// 向き/歩行アニメーションの管理
// 攻撃手段は持たない（弾の生成は行わない）
// ==============================
class Player {
  PVector pos;      // ワールド座標
  float radius;     // 当たり判定用の半径（円形）。被弾で拡大、マンジャロで縮小する
  int life;

  int manjaroCount;        // 残りマンジャロ所持数
  int manjaroDebuffTimer;  // マンジャロ使用後のデバフ残りフレーム数（0のときは無効）

  Direction facing;  // 現在の向き（テクスチャ切り替えに使用）
  int animFrame;     // 歩行アニメーションのフレーム（0 or 1）
  int animTimer;     // フレーム切り替えまでのカウンタ

  Player(PVector startPos) {
    pos = startPos.copy();
    radius = Config.PLAYER_RADIUS_BASE;
    life = Config.PLAYER_LIFE_MAX;
    manjaroCount = Config.MANJARO_START_COUNT;
    manjaroDebuffTimer = 0;

    facing = Direction.DOWN; // 初期状態は画面手前（下）向き
    animFrame = 0;
    animTimer = 0;
  }

  // ---------- 入力 ----------
  // キー入力から移動方向ベクトルを求める（正規化前）
  // keysHeld配列（メインスケッチで管理）を参照することで、複数キーの同時押し（斜め移動）に対応する
  // WASDに加えて、矢印キー（Processing標準のUP/DOWN/LEFT/RIGHT定数＝keyCode）でも同様に操作できる
  PVector getInputDirection() {
    PVector dir = new PVector(0, 0);
    if (keysHeld['W'] || keysHeld[UP])    dir.y -= 1;
    if (keysHeld['S'] || keysHeld[DOWN])  dir.y += 1;
    if (keysHeld['A'] || keysHeld[LEFT])  dir.x -= 1;
    if (keysHeld['D'] || keysHeld[RIGHT]) dir.x += 1;
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
      updateFacing(dir); // 向きは移動入力の生ベクトルから決める（正規化前でも符号は同じ）

      dir.normalize();
      float speed = isSlowMode() ? Config.PLAYER_SLOW_SPEED : Config.PLAYER_SPEED;
      if (isManjaroDebuffed()) {
        speed *= Config.MANJARO_DEBUFF_SPEED_MULTIPLIER; // マンジャロ使用直後のデバフ
      }
      dir.mult(speed);
      pos.add(dir);
      clampXToScreen();

      updateWalkAnimation();
    } else {
      // 停止中は歩行アニメーションを止め、1枚目（静止ポーズ）に戻す
      animTimer = 0;
      animFrame = 0;
    }

    if (manjaroDebuffTimer > 0) {
      manjaroDebuffTimer--;
    }
  }

  // 移動方向の入力ベクトル（正規化前）から向きを決定する
  // 斜め入力時は、より大きい成分の軸を優先する（4方向のみのテクスチャのため）
  void updateFacing(PVector rawDir) {
    if (abs(rawDir.x) >= abs(rawDir.y)) {
      facing = (rawDir.x > 0) ? Direction.RIGHT : Direction.LEFT;
    } else {
      facing = (rawDir.y > 0) ? Direction.DOWN : Direction.UP;
    }
  }

  // 一定間隔ごとに歩行アニメーションのフレームを切り替える
  void updateWalkAnimation() {
    animTimer++;
    if (animTimer >= Config.PLAYER_ANIM_INTERVAL_FRAMES) {
      animTimer = 0;
      animFrame = 1 - animFrame; // 0と1を交互に切り替え
    }
  }

  // ---------- 見た目（当たり判定サイズ差分） ----------
  // radiusの定義域（PLAYER_RADIUS_MIN〜PLAYER_RADIUS_MAX）をPLAYER_SIZE_STAGE_COUNT等分し、
  // 現在のradiusがどの区間に属するかを 0〜(段階数-1) の整数で返す
  int getSizeStage() {
    float minR = Config.PLAYER_RADIUS_MIN;
    float maxR = Config.PLAYER_RADIUS_MAX;
    int stageCount = Config.PLAYER_SIZE_STAGE_COUNT;

    float t = (radius - minR) / (maxR - minR); // 0.0〜1.0に正規化
    int stage = floor(t * stageCount);
    return constrain(stage, 0, stageCount - 1);
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
    radius = max(Config.PLAYER_RADIUS_MIN, radius * Config.MANJARO_RADIUS_SHRINK);
    manjaroDebuffTimer = Config.MANJARO_DEBUFF_DURATION_FRAMES;
  }

  // ---------- 描画 ----------
  // ワールド座標系のまま呼び出される想定（GameManager側でpushMatrix/translate済み）
  // テクスチャが用意されていればそれを、なければ従来通り円で描画する（フォールバック）
  // ライフが尽きている（isDead）場合は専用のゲームオーバー画像を表示する
  void draw() {
    if (isDead()) {
      if (assets.playerDead != null) {
        drawImageCentered(assets.playerDead, pos, radius * 2);
      } else {
        drawCircle(pos, radius, color(120, 120, 130));
      }
      return;
    }

    PImage img = assets.getPlayerImage(facing, animFrame, getSizeStage());
    if (img != null) {
      if (isManjaroDebuffed()) tint(160, 160, 255); // デバフ中は青みがかった着色で表現
      drawImageCentered(img, pos, radius * 2);
      if (isManjaroDebuffed()) noTint();
    } else {
      color c = isManjaroDebuffed() ? color(160, 160, 255) : color(80, 120, 255);
      drawCircle(pos, radius, c);
    }
  }
}
