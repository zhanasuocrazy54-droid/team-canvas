// ==============================
// ゲームバランスに関する定数をまとめるクラス
// 数値をコード中に直接書かず、ここを変更するだけで調整できるようにする
// ==============================
class Config {

  // ---------- プレイヤー関連 ----------
  static final float PLAYER_SPEED       = 4.0;  // 通常移動速度
  static final float PLAYER_SLOW_SPEED  = 2.0;  // Shift押下時の低速移動速度
  static final float PLAYER_RADIUS      = 6.0;  // プレイヤーの当たり判定半径（円形）
  static final int   PLAYER_LIFE_MAX    = 10;   // 初期ライフ

  // ---------- プレイヤー弾（通常弾）関連 ----------
  static final float PLAYER_BULLET_RADIUS   = 4.0; // 弾の半径
  static final float PLAYER_BULLET_SPEED    = 8.0; // 弾速（上方向へ飛ぶ）
  static final int   STRAIGHT_SHOT_INTERVAL = 10;  // 発射間隔（フレーム数）

  // ---------- 近接攻撃関連 ----------
  static final float MELEE_RADIUS   = 40.0; // 近接攻撃の有効半径
  static final int   MELEE_DURATION = 12;   // 1回の攻撃が有効なフレーム数
  static final int   MELEE_INTERVAL = 30;   // 発動間隔（フレーム数）

  // ---------- 敵関連 ----------
  static final float ENEMY_RADIUS = 20.0; // 敵の描画半径（当たり判定は持たない）

  // ---------- 敵弾（放射弾）関連 ----------
  static final float ENEMY_RADIAL_BULLET_RADIUS = 6.0;
  static final float ENEMY_RADIAL_BULLET_SPEED  = 3.0;
  static final int   ENEMY_RADIAL_INTERVAL      = 40; // 発射間隔（フレーム数）
  static final int   ENEMY_RADIAL_COUNT         = 12; // 一度に放射する弾数

  // ---------- 敵弾（自機狙い弾）関連 ----------
  static final float ENEMY_AIM_BULLET_RADIUS = 6.0;
  static final float ENEMY_AIM_BULLET_SPEED  = 4.0;
  static final int   ENEMY_AIM_INTERVAL      = 50; // 発射間隔（フレーム数）

  // ---------- ダメージ関連 ----------
  static final int ENEMY_BULLET_DAMAGE = 1; // 敵弾がプレイヤーに当たった時のダメージ量

  // ---------- ゲーム全体 ----------
  static final int TIME_LIMIT_FRAMES = 60 * 60; // 制限時間（60秒 × 60FPS）
}
