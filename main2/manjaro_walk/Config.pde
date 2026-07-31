// ==============================
// ゲームバランスに関する定数をまとめるクラス
// 数値をコード中に直接書かず、ここを変更するだけで調整できるようにする
// ==============================
class Config {

  // ---------- プレイヤー関連 ----------
  static final float PLAYER_SPEED       = 5.0;  // 通常移動速度
  static final float PLAYER_SLOW_SPEED  = 3.0;  // Shift押下時の低速移動速度
  static final int   PLAYER_LIFE_MAX    = 10;   // 初期ライフ

  // ---------- プレイヤーの当たり判定（可変）関連 ----------
  static final float PLAYER_RADIUS_BASE          = 8.0;  // 初期の当たり判定半径
  static final float PLAYER_RADIUS_MIN           = 4.0;  // マンジャロ使用時でも下回らない最小半径
  static final float PLAYER_RADIUS_MAX           = 50.0; // 被弾による拡大の上限
  static final float PLAYER_RADIUS_GROWTH_PER_HIT = 10.0; // 被弾1回あたりの半径増加量

  // ---------- ダメージ関連 ----------
  static final int ENEMY_BULLET_DAMAGE = 0; // 敵弾がプレイヤーに当たった時のダメージ量

  // ---------- マンジャロ（当たり判定リセットアイテム）関連 ----------
  static final int   MANJARO_START_COUNT           = 3;   // 開始時の所持数
  static final float MANJARO_RADIUS_SHRINK         = 8.0; // 使用時に半径から減らす量
  static final int   MANJARO_DEBUFF_DURATION_FRAMES = 180; // デバフの持続時間（3秒 @60FPS）
  static final float MANJARO_DEBUFF_SPEED_MULTIPLIER = 0.5; // デバフ中の移動速度倍率

  // ---------- カメラ関連 ----------
  // プレイヤーを画面のどの高さ（比率）に固定表示するか（0=最上部, 1=最下部）
  static final float CAMERA_PLAYER_SCREEN_Y_RATIO = 0.75;

  // ---------- クリア条件関連 ----------
  static final float CLEAR_DISTANCE = 8000; // スタート地点からゴールまでのワールド距離（上方向）

  // ---------- 敵弾の出現・削除関連 ----------
  static final float SPAWN_MARGIN_ABOVE_SCREEN  = 60;  // 画面上端よりどれだけ上（画面外）で生成するか
  static final float REMOVE_MARGIN_BELOW_SCREEN = 100; // 画面下端よりどれだけ下に出たら削除するか

  // ---------- 敵弾（まっすぐ落下）関連 ----------
  static final int   STRAIGHT_FALL_INTERVAL = 10;  // 生成間隔（フレーム数）
  static final float STRAIGHT_FALL_SPEED    = 4.0;
  static final float STRAIGHT_FALL_RADIUS   = 15.0;

  // ---------- 敵弾（自機狙い落下）関連 ----------
  static final int   AIMED_FALL_INTERVAL        = 70;
  static final float AIMED_FALL_SPEED           = 5.0;
  static final float AIMED_FALL_RADIUS          = 15.0;
  static final float AIMED_FALL_AIM_DISTANCE    = 800; // この距離分下に落ちる間に自機のX位置へ寄せる（緩やかに狙う）

  // ---------- 敵弾（横一列＋隙間の壁）関連 ----------
  static final int   WAVE_FALL_INTERVAL      = 150;
  static final float WAVE_FALL_SPEED         = 3.0;
  static final float WAVE_FALL_RADIUS        = 12.0;
  static final float WAVE_FALL_GAP_WIDTH     = 110; // 通り抜けられる隙間の幅
  static final float WAVE_FALL_BULLET_SPACING = 40; // 壁を構成する弾同士の間隔
}
