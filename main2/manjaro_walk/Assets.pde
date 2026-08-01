// ==============================
// 画像アセット（テクスチャ）を一元管理するクラス
// setup()内で一度だけ生成し、以後はどのクラスからも同じ画像インスタンスを
// 参照させることで、無駄なloadImage()の呼び出しを避ける
//
// 画像ファイルは data フォルダに配置する（Processingの規約）
// ファイルが見つからない場合、loadImage()はnullを返すだけでエラー落ちはしない。
// 各描画側もnullチェックのうえ円描画にフォールバックするため、
// 画像を用意していない種類があっても動作は継続する
// ==============================
class Assets {

  // ---------- プレイヤー（4方向 x 2フレーム x 4段階＝計32枚） ----------
  // 添字は [段階(0〜3)][アニメーションフレーム(0 or 1)]
  // 段階は当たり判定の半径（Player.radius）を4等分した区間に対応する
  PImage[][] playerUp    = new PImage[4][2];
  PImage[][] playerDown  = new PImage[4][2];
  PImage[][] playerLeft  = new PImage[4][2];
  PImage[][] playerRight = new PImage[4][2];

  // ---------- 敵の攻撃（1種類につき1枚） ----------
  PImage bulletStraight;
  PImage bulletAimed;
  PImage bulletWave;
  PImage bulletHoming;

  // ---------- UI：ライフ（ハート） ----------
  PImage heartFull; // ライフ2ポイント分（満タン）のハート
  PImage heartHalf; // ライフ1ポイント分（半分）のハート

  // ---------- UI：マンジャロ（注射器） ----------
  PImage syringe;

  // ---------- ゲームオーバー時のプレイヤー画像 ----------
  PImage playerDead;

  Assets() {
    // ファイル名は player_{方向}_{フレーム1or2}_stage{段階1〜4}.png の規則
    for (int stage = 1; stage <= 4; stage++) {
      for (int frame = 1; frame <= 2; frame++) {
        PImage img;

        img = loadImage("player_up_" + frame + "_stage" + stage + ".png");
        playerUp[stage - 1][frame - 1] = img;

        img = loadImage("player_down_" + frame + "_stage" + stage + ".png");
        playerDown[stage - 1][frame - 1] = img;

        img = loadImage("player_left_" + frame + "_stage" + stage + ".png");
        playerLeft[stage - 1][frame - 1] = img;

        img = loadImage("player_right_" + frame + "_stage" + stage + ".png");
        playerRight[stage - 1][frame - 1] = img;
      }
    }

    bulletStraight = loadImage("bullet_straight.png");
    bulletAimed    = loadImage("bullet_aimed.png");
    bulletWave     = loadImage("bullet_wave.png");
    bulletHoming   = loadImage("bullet_homing.png");

    heartFull = loadImage("heart_full.png");
    heartHalf = loadImage("heart_half.png");

    syringe = loadImage("syringe.png");

    playerDead = loadImage("player_dead.png");
  }

  // 向き・アニメーションフレーム（0 or 1）・当たり判定サイズ段階（0〜3）からプレイヤー画像を取得する
  PImage getPlayerImage(Direction dir, int frame, int sizeStage) {
    frame = constrain(frame, 0, 1);
    sizeStage = constrain(sizeStage, 0, 3);
    switch (dir) {
      case UP:    return playerUp[sizeStage][frame];
      case DOWN:  return playerDown[sizeStage][frame];
      case LEFT:  return playerLeft[sizeStage][frame];
      case RIGHT: return playerRight[sizeStage][frame];
    }
    return null;
  }
}
