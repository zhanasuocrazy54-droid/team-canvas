// ==============================
// ゲームバランスに関する定数をまとめるクラス
// 数値をコード中に直接書かず、ここを変更するだけで調整できるようにする
// ==============================
class Config {

  // ---------- プレイヤー関連 ----------
  static final float PLAYER_SPEED       = 5.0;  // 通常移動速度
  static final float PLAYER_SLOW_SPEED  = 3.0;  // Shift押下時の低速移動速度
  static final float PLAYER_RADIUS      = 8.0;  // プレイヤーの当たり判定半径（円形）
  static final int   PLAYER_LIFE_MAX    = 10;   // 初期ライフ

  // ---------- プレイヤー弾（通常弾）関連 ----------
  static final float PLAYER_BULLET_RADIUS   = 6.0; // 弾の半径
  static final float PLAYER_BULLET_SPEED    = 10.0; // 弾速（上方向へ飛ぶ）
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
  static final float ENEMY_RADIUS = 30.0; // 敵の描画半径（当たり判定は持たない）
  
    // ---------- 敵の移動（サイン波）関連 ----------
  static final float ENEMY_SWAY_AMPLITUDE = 100.0; // 左右に振れる幅（中心からの最大距離）
  static final float ENEMY_SWAY_SPEED     = 0.03;  // サイン波の進む速さ（角度の増加量/フレーム）
  static final int   ENEMY_DIR_CHANGE_MIN = 60;    // 方向反転までの最短フレーム数
  static final int   ENEMY_DIR_CHANGE_MAX = 180;   // 方向反転までの最長フレーム数

  // ---------- 敵の移動（円軌道）関連 ----------
  static final float ENEMY_CIRCLE_RADIUS = 120.0; // 周回半径（横方向）
  static final float ENEMY_CIRCLE_SPEED  = 0.02;  // 周回の速さ（角度の増加量/フレーム）


  // ---------- 敵弾（放射弾）関連 ----------
  static final float ENEMY_RADIAL_BULLET_RADIUS = 8.0;
  static final float ENEMY_RADIAL_BULLET_SPEED  = 4.0;
  static final int   ENEMY_RADIAL_INTERVAL      = 15; // 発射間隔（フレーム数）
  static final int   ENEMY_RADIAL_COUNT         = 12; // 一度に放射する弾数

  // ---------- 敵弾（螺旋放射弾）関連 ----------
  static final float ENEMY_SPIRALRADIAL_BULLET_RADIUS = 8.0;
  static final float ENEMY_SPIRALRADIAL_BULLET_SPEED  = 4.0;
  static final int   ENEMY_SPIRALRADIAL_INTERVAL      = 15; // 発射間隔（フレーム数）
  static final int   ENEMY_SPIRALRADIAL_COUNT         = 12; // 一度に放射する弾数

  // ---------- 敵弾の耐久値関連 ----------
  static final int ENEMY_BULLET_HP = 3; // 敵弾が消えるまでに耐えられる被弾回数（通常弾のみ対象）

  // ---------- 敵弾（移動放射弾）関連 ----------
  static final int   ENEMY_DRIFT_SPAWN_INTERVAL = 200;  // 中心が離脱してから次に離脱するまでの間隔（フレーム数）
  static final int   ENEMY_DRIFT_LIFETIME       = 600; // 離脱した中心が消えるまでの生存時間（フレーム数）
  static final int   ENEMY_DRIFT_MAX_COUNT      = 3;   // 同時に存在できる中心の最大数
  static final float ENEMY_DRIFT_SPEED          = 1.2;   // 中心が漂う速さ
  static final int   ENEMY_DRIFT_BURST_INTERVAL = 100;  // 中心が生きている間、放射弾を撃つ間隔（フレーム数）
  static final int   ENEMY_DRIFT_BULLET_COUNT   = 10;  // 1回の放射で発射する弾数
  static final float ENEMY_DRIFT_BULLET_SPEED   = 1.5; // 弾速
  static final float ENEMY_DRIFT_BULLET_RADIUS  = 6.0; // 弾のサイズ

  // ---------- 敵弾（自機狙い弾）関連 ----------
  static final float ENEMY_AIM_BULLET_RADIUS = 6.0;
  static final float ENEMY_AIM_BULLET_SPEED  = 6.0;
  static final int   ENEMY_AIM_INTERVAL      = 80; // 発射間隔（フレーム数）
  
    // ---------- 敵弾（らせん弾）関連 ----------
static final float ENEMY_SPIRAL_BULLET_RADIUS  = 5.0;
static final float ENEMY_SPIRAL_BULLET_SPEED   = 3.5;
static final int   ENEMY_SPIRAL_INTERVAL       = 6;  // 短い間隔で1発ずつ撃ち続けて渦を作る
static final float ENEMY_SPIRAL_ANGLE_STEP_DEG = 12; // 1発ごとに回転させる角度（度数）

  // ---------- ダメージ関連 ----------
  static final int ENEMY_BULLET_DAMAGE = 1; // 敵弾がプレイヤーに当たった時のダメージ量

  // ---------- レベルアップ（ローグライク強化）関連 ----------
  static final int LEVEL_UP_INTERVAL_FRAMES = 5 * 60; // 20秒（60FPS）ごとにレベルアップ
}
