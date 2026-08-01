// ==============================
// ゲームバランスに関する定数をまとめるクラス
// 数値をコード中に直接書かず、ここを変更するだけで調整できるようにする
// ==============================
class Config {

  // ---------- プレイヤー関連 ----------
  static final float PLAYER_SPEED       = 15.0;  // 通常移動速度
  static final float PLAYER_SLOW_SPEED  = 3.0;  // Shift押下時の低速移動速度
  static final int   PLAYER_LIFE_MAX    = 10;   // 初期ライフ

  // ---------- プレイヤーの当たり判定（可変）関連 ----------
  static final float PLAYER_RADIUS_BASE          = 30.0;  // 初期の当たり判定半径
  static final float PLAYER_RADIUS_MIN           = 20.0;  // マンジャロ使用時でも下回らない最小半径
  static final float PLAYER_RADIUS_MAX           = 100.0; // 被弾による拡大の上限
  static final float PLAYER_RADIUS_GROWTH_PER_HIT = 7.0; // 被弾1回あたりの半径増加量

  // ---------- プレイヤーの見た目（当たり判定サイズ差分）関連 ----------
  // Player.radiusの定義域（PLAYER_RADIUS_MIN 〜 PLAYER_RADIUS_MAX）を
  // 均等にPLAYER_SIZE_STAGE_COUNT分割し、現在の半径がどの区間にあるかで
  // 表示するテクスチャの段階（0〜PLAYER_SIZE_STAGE_COUNT-1）を切り替える
  static final int PLAYER_SIZE_STAGE_COUNT = 4;
 
  // ---------- プレイヤーの見た目（テクスチャ）関連 ----------
  static final int PLAYER_ANIM_INTERVAL_FRAMES = 10; // 歩行アニメーションのフレーム切り替え間隔

  // ---------- ダメージ関連 ----------
  static final int ENEMY_BULLET_DAMAGE = 1; // 敵弾がプレイヤーに当たった時のダメージ量

  // ---------- マンジャロ（当たり判定リセットアイテム）関連 ----------
  static final int   MANJARO_START_COUNT           = 3;   // 開始時の所持数
  static final float MANJARO_RADIUS_SHRINK         = 0.5; // 使用時に減少する割合
  static final int   MANJARO_DEBUFF_DURATION_FRAMES = 180; // デバフの持続時間（3秒 @60FPS）
  static final float MANJARO_DEBUFF_SPEED_MULTIPLIER = 0.3; // デバフ中の移動速度倍率

  // ---------- カメラ関連 ----------
  // プレイヤーを画面のどの高さ（比率）に固定表示するか（0=最上部, 1=最下部）
  static final float CAMERA_PLAYER_SCREEN_Y_RATIO = 0.75;

  // ---------- クリア条件関連 ----------
  static final float CLEAR_DISTANCE = 8000; // スタート地点からゴールまでのワールド距離（上方向）

  // ---------- 敵弾の出現・削除関連 ----------
  static final float SPAWN_MARGIN_ABOVE_SCREEN  = 60;  // 画面上端よりどれだけ上（画面外）で生成するか
  static final float REMOVE_MARGIN_BELOW_SCREEN = 100; // 画面下端よりどれだけ下に出たら削除するか

  // ---------- 敵弾（まっすぐ落下）関連 ----------
  static final int   STRAIGHT_FALL_INTERVAL = 20;  // 生成間隔（フレーム数）
  static final float STRAIGHT_FALL_SPEED    = 2.0;
  static final float STRAIGHT_FALL_RADIUS   = 30.0;

  // ---------- 敵弾（自機狙い落下）関連 ----------
  static final int   AIMED_FALL_INTERVAL        = 70;
  static final float AIMED_FALL_SPEED           = 3.0;
  static final float AIMED_FALL_RADIUS          = 30.0;
  static final float AIMED_FALL_AIM_DISTANCE    = 800; // この距離分下に落ちる間に自機のX位置へ寄せる（緩やかに狙う）

  // ---------- 敵弾（横一列＋隙間の壁）関連 ----------
  static final int   WAVE_FALL_INTERVAL      = 150;
  static final float WAVE_FALL_SPEED         = 1.0;
  static final float WAVE_FALL_RADIUS        = 30.0;
  static final float WAVE_FALL_GAP_WIDTH     = 110; // 通り抜けられる隙間の幅
  static final float WAVE_FALL_BULLET_SPACING = 80; // 壁を構成する弾同士の間隔

  // ---------- 敵弾（横方向ホーミング落下）関連 ----------
  static final int   HOMING_FALL_INTERVAL             = 300; // 生成間隔（フレーム数）
  static final float HOMING_FALL_SPEED                = 1.5; // 縦方向速度（生成後は不変）
  static final float HOMING_FALL_RADIUS               = 30.0;
  static final float HOMING_FALL_MAX_HORIZONTAL_SPEED = 3.0; // 横方向速度の上限
  static final float HOMING_FALL_TURN_RATE            = 0.04; // 1フレームあたりの横方向速度の補正割合（0〜1）

  // ---------- UI：ライフ（ハート）表示関連 ----------
  static final float HEART_WIDTH   = 40; // ハート1個の表示幅
  static final float HEART_HEIGHT  = 40; // ハート1個の表示高さ
  static final float HEART_SPACING = 30; // ハート同士の間隔（左端からのX方向オフセット幅）
  static final float HEART_MARGIN_X = 16; // 画面左端からの余白
  static final float HEART_MARGIN_Y = 36; // 画面下端からの余白
 
  // ---------- UI：マンジャロ（注射器）表示関連 ----------
  static final float MANJARO_ICON_WIDTH    = 52; // 注射器アイコンの表示幅
  static final float MANJARO_ICON_HEIGHT   = 52; // 注射器アイコンの表示高さ
  static final float MANJARO_ICON_SPACING  = 54; // アイコン同士の間隔
  static final float MANJARO_MARGIN_X      = 36; // 画面右端からの余白
  static final float MANJARO_MARGIN_Y      = 40; // 画面下端からの余白
  static final float MANJARO_ROUND_RADIUS  = 25; // 注射器の下に置く丸い図形の半径
  static final int MANJARO_ROUND_COLOR_R = 60;
  static final int MANJARO_ROUND_COLOR_G = 60;
  static final int MANJARO_ROUND_COLOR_B = 70;
  static final int MANJARO_ROUND_COLOR_A = 220;
 
  // ---------- UI：マンジャロ効果中のプレイヤー追従アイコン関連 ----------
  static final float MANJARO_FOLLOW_ICON_WIDTH  = 45;
  static final float MANJARO_FOLLOW_ICON_HEIGHT = 45;
  static final float MANJARO_FOLLOW_OFFSET_X    = 18; // プレイヤー中心からの右方向オフセット
  static final float MANJARO_FOLLOW_OFFSET_Y    = 22; // プレイヤー中心からの上方向オフセット
}
