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

  // ---------- 拡散弾（ShotgunShot）関連 ----------
  static final int   SHOTGUN_INTERVAL         = 20; // 発射間隔（フレーム数）
  static final int   SHOTGUN_BULLET_COUNT     = 5;  // 1回に発射する弾数
  static final float SHOTGUN_SPREAD_ANGLE_DEG = 45; // 扇の広がり角度（度数指定。非staticな内部クラスでは
                                                      // radians()のような関数呼び出しをstatic finalの初期値に
                                                      // 使えないため、度数のまま持っておき使用側でradians()変換する）

  // ---------- 近接攻撃関連 ----------
  static final float MELEE_RADIUS   = 40.0; // 近接攻撃の有効半径
  static final int   MELEE_DURATION = 12;   // 1回の攻撃が有効なフレーム数
  static final int   MELEE_INTERVAL = 30;   // 発動間隔（フレーム数）

  // ---------- 敵関連 ----------
  static final float ENEMY_RADIUS = 20.0; // 敵の描画半径（当たり判定は持たない）

  // ---------- 敵の移動（サイン波）関連 ----------
  static final float ENEMY_SWAY_AMPLITUDE = 100.0; // 左右に振れる幅（中心からの最大距離）
  static final float ENEMY_SWAY_SPEED     = 0.03;  // サイン波の進む速さ（角度の増加量/フレーム）
  static final int   ENEMY_DIR_CHANGE_MIN = 60;    // 方向反転までの最短フレーム数
  static final int   ENEMY_DIR_CHANGE_MAX = 180;   // 方向反転までの最長フレーム数

  // ---------- 敵の移動（円軌道）関連 ----------
  static final float ENEMY_CIRCLE_RADIUS = 120.0; // 周回半径（横方向）
  static final float ENEMY_CIRCLE_SPEED  = 0.02;  // 周回の速さ（角度の増加量/フレーム）

  // ---------- 敵弾（放射弾）関連 ----------
  static final float ENEMY_RADIAL_BULLET_RADIUS = 6.0;
  static final float ENEMY_RADIAL_BULLET_SPEED  = 3.0;
  static final int   ENEMY_RADIAL_INTERVAL      = 40; // 発射間隔（フレーム数）
  static final int   ENEMY_RADIAL_COUNT         = 12; // 一度に放射する弾数

  // ---------- 敵弾（自機狙い弾）関連 ----------
  static final float ENEMY_AIM_BULLET_RADIUS = 6.0;
  static final float ENEMY_AIM_BULLET_SPEED  = 4.0;
  static final int   ENEMY_AIM_INTERVAL      = 50; // 発射間隔（フレーム数）
  
  // ---------- 敵弾（らせん弾）関連 ----------
static final float ENEMY_SPIRAL_BULLET_RADIUS  = 5.0;
static final float ENEMY_SPIRAL_BULLET_SPEED   = 3.5;
static final int   ENEMY_SPIRAL_INTERVAL       = 6;  // 短い間隔で1発ずつ撃ち続けて渦を作る
static final float ENEMY_SPIRAL_ANGLE_STEP_DEG = 12; // 1発ごとに回転させる角度（度数）

  // ---------- ダメージ関連 ----------
  static final int ENEMY_BULLET_DAMAGE = 1; // 敵弾がプレイヤーに当たった時のダメージ量

  // ---------- レベルアップ（ローグライク強化）関連 ----------
  static final int LEVEL_UP_INTERVAL_FRAMES = 20 * 60; // 20秒（60FPS）ごとにレベルアップ
}
