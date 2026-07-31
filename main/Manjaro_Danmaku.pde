// ==============================
// メインスケッチ
// setup()/draw()のみを記述し、実際の処理はGameManagerに委譲する
// ==============================
GameManager gameManager;

// キーの押下状態を保持する配列（keyCodeをインデックスとして使用）
// Processing標準のkeyPressed/key変数は「直近の1キー」しか判定できず
// WASDの同時押し（斜め移動）に対応できないため、この配列で状態管理する
// Playerクラスは同一スケッチ内の内部クラスとして、この配列に直接アクセスする
boolean[] keysHeld = new boolean[256];

void setup() {
  size(480, 640);
  gameManager = new GameManager();
}

void draw() {
  gameManager.update();
  gameManager.draw();
}

// ---------- キー入力イベント ----------
void keyPressed() {
  if (keyCode >= 0 && keyCode < 256) {
    keysHeld[keyCode] = true;
  }
}

void keyReleased() {
  if (keyCode >= 0 && keyCode < 256) {
    keysHeld[keyCode] = false;
  }
}

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

// ==============================
// ゲームの状態を表すenum
// 将来的にTITLE, PAUSE, RESULTなどを追加していく想定
// ==============================
enum GameState {
  PLAYING,
  WIN,
  LOSE
}

// ==============================
// 描画に関する共通処理
// Processingのクラスはstaticメソッドを持てないため、
// クラスに包まずトップレベル関数として定義する（setup()/draw()と同じ形式）
// 全てのクラスから直接呼び出せる
// ==============================

// 指定した位置・半径・色で円を描画する共通処理
// Bullet, Player, Enemy, MeleeAttackの描画で共用する
// 将来的に画像/アニメーションへ差し替える場合は、この関数の中身だけを変更すればよい
void drawCircle(PVector pos, float radius, color c) {
  pushStyle();
  noStroke();
  fill(c);
  ellipse(pos.x, pos.y, radius * 2, radius * 2);
  popStyle();
}

// 半透明の円を描画する共通処理（近接攻撃の範囲表示などで使用）
void drawTranslucentCircle(PVector pos, float radius, color c, int alpha) {
  pushStyle();
  noStroke();
  fill(c, alpha);
  ellipse(pos.x, pos.y, radius * 2, radius * 2);
  popStyle();
}

// ==============================
// エフェクトクラス
// 今回は何も描画しない。相殺時に呼び出せる構造だけを用意する
// 将来的にパーティクルや画像アニメーションをここに実装する
// ==============================
class Effect {
  PVector pos;
  String type; // エフェクトの種類（"cancel"（相殺）、"hit"（被弾）など）

  Effect(PVector pos, String type) {
    this.pos = pos.copy();
    this.type = type;
    // 現時点では生成時に何もしない
  }

  // ---------- 更新 ----------
  // 今回は何もしない（将来的に寿命管理やアニメーション更新をここに追加）
  void update() {
  }

  // ---------- 描画 ----------
  // 今回は何も描画しない（将来的にパーティクル等をここに追加）
  void draw() {
  }
}

// ==============================
// 弾の基底クラス
// 「位置・速度・半径・更新・描画・当たり判定」のみを責務とする
// PlayerBullet / EnemyBullet はこのクラスを継承する
// ==============================
abstract class Bullet {
  PVector pos;
  PVector vel;
  float radius;

  Bullet(PVector pos, PVector vel, float radius) {
    this.pos = pos.copy();
    this.vel = vel.copy();
    this.radius = radius;
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

  // ---------- 削除判定 ----------
  // 画面外に十分出た弾は不要オブジェクトとして削除対象にする
  boolean isOffscreen() {
    float margin = 50;
    return pos.x < -margin || pos.x > width + margin ||
           pos.y < -margin || pos.y > height + margin;
  }
}

// ==============================
// プレイヤーが発射する弾
// 現時点では通常弾（StraightShot）が生成する
// ==============================
class PlayerBullet extends Bullet {

  PlayerBullet(PVector pos, PVector vel, float radius) {
    super(pos, vel, radius);
  }

  @Override
  color getColor() {
    return color(100, 200, 255); // 水色
  }
}

// ==============================
// 敵が発射する弾
// RadialPattern / AimPattern が生成する
// ==============================
class EnemyBullet extends Bullet {

  EnemyBullet(PVector pos, PVector vel, float radius) {
    super(pos, vel, radius);
  }

  @Override
  color getColor() {
    return color(255, 80, 80); // 赤
  }
}

// ==============================
// 武器の基底クラス
// 責務：発動間隔（interval）の管理とタイミング判定のみ
// 実際の効果（弾生成、範囲攻撃など）は継承先のactivate()に委譲する
// ==============================
abstract class Weapon {
  int interval; // 発動間隔（フレーム数）
  int timer;    // 経過フレーム数のカウンタ

  Weapon(int interval) {
    this.interval = interval;
    this.timer = 0;
  }

  // ---------- 更新 ----------
  // 毎フレーム呼ばれる。タイマーが間隔に達したら発動しリセットする
  void update(Player player, ArrayList<PlayerBullet> playerBullets) {
    timer++;
    if (timer >= interval) {
      timer = 0;
      activate(player, playerBullets);
    }
  }

  // ---------- 発動処理 ----------
  // 継承先で「発動時に何をするか」のみを実装する
  // 弾を生成しない武器（近接攻撃など）はplayerBulletsを使わなくてよい
  abstract void activate(Player player, ArrayList<PlayerBullet> playerBullets);

  // ---------- 描画 ----------
  // 多くの武器は専用の描画を持たないためデフォルトは空実装
  // 近接攻撃のように範囲を可視化したい武器のみオーバーライドする
  void draw(Player player) {
  }
}

// ==============================
// 通常弾（StraightShot）
// 一定間隔で、プレイヤーの真上方向へ弾を発射する
// ==============================
class StraightShot extends Weapon {
  float bulletSpeed;
  float bulletRadius;

  StraightShot() {
    super(Config.STRAIGHT_SHOT_INTERVAL);
    bulletSpeed = Config.PLAYER_BULLET_SPEED;
    bulletRadius = Config.PLAYER_BULLET_RADIUS;
  }

  @Override
  void activate(Player player, ArrayList<PlayerBullet> playerBullets) {
    // 真上方向（y軸マイナス方向）へ飛ばす
    PVector vel = new PVector(0, -1);
    vel.mult(bulletSpeed);
    playerBullets.add(new PlayerBullet(player.pos, vel, bulletRadius));
  }
}

// ==============================
// 近接攻撃（MeleeAttack）
// 弾は生成せず、プレイヤー周囲に一定時間だけ有効な範囲を発生させる
// 実際に「敵弾のみ消す」処理はCollisionManagerが行う
// （このクラスは「今アクティブかどうか」「有効範囲」だけを管理する）
// ==============================
class MeleeAttack extends Weapon {
  float radius;      // 近接攻撃の有効半径
  int duration;       // 有効時間（フレーム数）
  int activeTimer;    // 残り有効フレーム数（0のときは無効）

  MeleeAttack() {
    super(Config.MELEE_INTERVAL);
    radius = Config.MELEE_RADIUS;
    duration = Config.MELEE_DURATION;
    activeTimer = 0;
  }

  @Override
  void update(Player player, ArrayList<PlayerBullet> playerBullets) {
    // 発動タイミングの判定は基底クラスのupdate()に任せる
    super.update(player, playerBullets);

    // 有効時間のカウントダウン
    if (activeTimer > 0) {
      activeTimer--;
    }
  }

  @Override
  void activate(Player player, ArrayList<PlayerBullet> playerBullets) {
    // 弾は生成せず、有効時間をリセットするだけ
    activeTimer = duration;
  }

  // 現在、近接攻撃の判定が有効かどうか（CollisionManagerが参照する）
  boolean isActive() {
    return activeTimer > 0;
  }

  // ---------- 描画 ----------
  // 有効な間だけ半透明の円を表示する
  @Override
  void draw(Player player) {
    if (!isActive()) return;
    drawTranslucentCircle(player.pos, radius, color(255, 255, 255), 80);
  }
}

// ==============================
// 弾幕パターンの基底クラス
// 責務：発射間隔（interval）の管理とタイミング判定のみ
// 実際の弾生成ロジックは継承先のfire()に委譲する（テンプレートメソッド構造）
// ==============================
abstract class BulletPattern {
  int interval; // 発射間隔（フレーム数）
  int timer;    // 経過フレーム数のカウンタ

  BulletPattern(int interval) {
    this.interval = interval;
    this.timer = 0;
  }

  // ---------- 更新 ----------
  // 毎フレーム呼ばれる。タイマーが間隔に達したら発射しリセットする
  void update(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    timer++;
    if (timer >= interval) {
      timer = 0;
      fire(enemy, playerPos, enemyBullets);
    }
  }

  // ---------- 弾生成 ----------
  // 継承先で「どんな弾をどう配置するか」のみを実装する
  abstract void fire(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets);
}

// ==============================
// 放射弾パターン
// 一定間隔で、敵の位置を中心に円周方向へ複数の弾を放射する
// ==============================
class RadialPattern extends BulletPattern {
  int bulletCount;     // 一度に放射する弾数
  float bulletSpeed;   // 弾速
  float bulletRadius;  // 弾のサイズ（当たり判定半径）

  RadialPattern() {
    super(Config.ENEMY_RADIAL_INTERVAL);
    bulletCount = Config.ENEMY_RADIAL_COUNT;
    bulletSpeed = Config.ENEMY_RADIAL_BULLET_SPEED;
    bulletRadius = Config.ENEMY_RADIAL_BULLET_RADIUS;
  }

  @Override
  void fire(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    // 360度を弾数で等分し、各方向へ弾を生成する
    float angleStep = TWO_PI / bulletCount;
    for (int i = 0; i < bulletCount; i++) {
      float angle = angleStep * i;
      PVector vel = new PVector(cos(angle), sin(angle));
      vel.mult(bulletSpeed);
      enemyBullets.add(new EnemyBullet(enemy.pos, vel, bulletRadius));
    }
  }
}

// ==============================
// 自機狙い弾パターン
// 発射した瞬間のプレイヤー座標へ向かう方向で1発発射する
// 発射後は方向を変えない（ホーミングしない）
// ==============================
class AimPattern extends BulletPattern {
  float bulletSpeed;
  float bulletRadius;

  AimPattern() {
    super(Config.ENEMY_AIM_INTERVAL);
    bulletSpeed = Config.ENEMY_AIM_BULLET_SPEED;
    bulletRadius = Config.ENEMY_AIM_BULLET_RADIUS;
  }

  @Override
  void fire(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    // 発射時点でのプレイヤー方向を計算（以降は追尾しない）
    PVector dir = PVector.sub(playerPos, enemy.pos);
    dir.normalize();
    dir.mult(bulletSpeed);
    enemyBullets.add(new EnemyBullet(enemy.pos, dir, bulletRadius));
  }
}

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

// ==============================
// 敵クラス
// 画面上部中央に固定され、プレイヤーからダメージを受けない
// 責務：位置の保持・弾幕パターンの管理
// 弾の生成は行わない（BulletPatternに委譲する）
// ==============================
class Enemy {
  PVector pos;
  float radius; // 描画用の半径（当たり判定には使用しない＝攻撃対象ではないため）

  // 使用する弾幕パターンのリスト
  // 将来的に複数パターンの同時発動・切り替えに対応できるようArrayListで管理
  ArrayList<BulletPattern> patterns;

  Enemy(PVector fixedPos) {
    pos = fixedPos.copy();
    radius = Config.ENEMY_RADIUS;
    patterns = new ArrayList<BulletPattern>();
  }

  // ---------- 敵弾生成 ----------
  // 各パターンを更新し、発射タイミングが来ていれば敵弾リストへ弾を追加させる
  void updatePatterns(PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    for (BulletPattern p : patterns) {
      p.update(this, playerPos, enemyBullets);
    }
  }

  // ---------- 描画 ----------
  void draw() {
    drawShape();
  }

  void drawShape() {
    drawCircle(pos, radius, color(255, 60, 60)); // 赤
  }
}

// ==============================
// 当たり判定・相殺処理を一元管理するクラス
// Bullet/Weapon自身に衝突相手を知らせないことでクラス間の依存を減らす
// ==============================
class CollisionManager {

  // ---------- プレイヤー通常弾 vs 敵弾 ----------
  // 衝突したら両方を削除し、Effectを生成する
  void checkPlayerBulletsVsEnemyBullets(ArrayList<PlayerBullet> playerBullets,
                                         ArrayList<EnemyBullet> enemyBullets,
                                         ArrayList<Effect> effects) {
    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      PlayerBullet pb = playerBullets.get(i);
      boolean hit = false;

      for (int j = enemyBullets.size() - 1; j >= 0; j--) {
        EnemyBullet eb = enemyBullets.get(j);
        if (pb.isHit(eb.pos, eb.radius)) {
          effects.add(new Effect(eb.pos, "cancel"));
          enemyBullets.remove(j);
          hit = true;
          break; // 通常弾は1発につき1つの敵弾と相殺する
        }
      }

      if (hit) {
        playerBullets.remove(i);
      }
    }
  }

  // ---------- 近接攻撃 vs 敵弾 ----------
  // 近接攻撃自体は消えず、範囲内の敵弾のみを削除する
  void checkMeleeVsEnemyBullets(Player player,
                                 ArrayList<EnemyBullet> enemyBullets,
                                 ArrayList<Effect> effects) {
    for (Weapon w : player.weapons) {
      if (!(w instanceof MeleeAttack)) continue;

      MeleeAttack melee = (MeleeAttack) w;
      if (!melee.isActive()) continue;

      for (int j = enemyBullets.size() - 1; j >= 0; j--) {
        EnemyBullet eb = enemyBullets.get(j);
        float d = PVector.dist(player.pos, eb.pos);
        if (d < melee.radius + eb.radius) {
          effects.add(new Effect(eb.pos, "cancel"));
          enemyBullets.remove(j);
        }
      }
    }
  }

  // ---------- 敵弾 vs プレイヤー本体 ----------
  // 被弾したらダメージを与え、敵弾を削除する
  void checkEnemyBulletsVsPlayer(Player player,
                                  ArrayList<EnemyBullet> enemyBullets,
                                  ArrayList<Effect> effects) {
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      EnemyBullet eb = enemyBullets.get(i);
      float d = PVector.dist(player.pos, eb.pos);
      if (d < player.radius + eb.radius) {
        player.takeDamage(Config.ENEMY_BULLET_DAMAGE);
        effects.add(new Effect(eb.pos, "hit"));
        enemyBullets.remove(i);
      }
    }
  }

  // ---------- まとめて実行 ----------
  // GameManagerから呼ばれる唯一の入口
  void checkAll(Player player,
                ArrayList<PlayerBullet> playerBullets,
                ArrayList<EnemyBullet> enemyBullets,
                ArrayList<Effect> effects) {
    checkPlayerBulletsVsEnemyBullets(playerBullets, enemyBullets, effects);
    checkMeleeVsEnemyBullets(player, enemyBullets, effects);
    checkEnemyBulletsVsPlayer(player, enemyBullets, effects);
  }
}

// ==============================
// ゲーム全体を統括するクラス
// 責務：各オブジェクトの生成・ゲームループの制御・勝敗判定
// ==============================
class GameManager {
  Player player;
  Enemy enemy;

  ArrayList<PlayerBullet> playerBullets;
  ArrayList<EnemyBullet> enemyBullets;
  ArrayList<Effect> effects;

  CollisionManager collisionManager;

  int elapsedFrames;
  GameState state;

  GameManager() {
    setupGame();
  }

  // ---------- 初期化 ----------
  // タイトル画面/リザルト画面からの再スタート時にも呼び出せるよう
  // 「プレイヤー」「敵」「状態」の初期化を分離しておく
  void setupGame() {
    setupPlayer();
    setupEnemy();
    setupLists();
    setupState();
  }

  // プレイヤーと装備武器を生成する
  // 将来的な武器アンロックは、ここで所持武器リストを外部から渡す形に拡張できる
  void setupPlayer() {
    player = new Player(new PVector(width / 2, height - 60));
    player.weapons.add(new StraightShot());
    player.weapons.add(new MeleeAttack());
  }

  // 敵と使用する弾幕パターンを生成する
  // 将来的な複数ボス対応は、Enemyを複数生成しリストで管理する形に拡張できる
  void setupEnemy() {
    enemy = new Enemy(new PVector(width / 2, 80));
    enemy.patterns.add(new RadialPattern());
    enemy.patterns.add(new AimPattern());
  }

  // 弾・エフェクトの管理リストと当たり判定処理を初期化する
  void setupLists() {
    playerBullets = new ArrayList<PlayerBullet>();
    enemyBullets = new ArrayList<EnemyBullet>();
    effects = new ArrayList<Effect>();
    collisionManager = new CollisionManager();
  }

  // 経過時間・ゲーム状態を初期化する
  void setupState() {
    elapsedFrames = 0;
    state = GameState.PLAYING;
  }

  // ---------- 更新（ゲームループ本体） ----------
  // 入力→移動→攻撃生成→敵弾生成→移動更新→当たり判定→Effect生成→不要オブジェクト削除
  void update() {
    if (state != GameState.PLAYING) return;

    // 入力・移動（プレイヤー）
    player.move();

    // 攻撃生成（プレイヤー武器）
    player.updateWeapons(playerBullets);

    // 敵弾生成
    enemy.updatePatterns(player.pos, enemyBullets);

    // 移動更新（既存の弾を動かす）
    for (PlayerBullet b : playerBullets) b.update();
    for (EnemyBullet b : enemyBullets) b.update();

    // 当たり判定（内部でEffect生成も行う）
    collisionManager.checkAll(player, playerBullets, enemyBullets, effects);

    // Effect更新
    for (Effect e : effects) e.update();

    // 不要オブジェクト削除
    removeOffscreenBullets();

    // 経過時間・勝敗判定
    elapsedFrames++;
    checkGameEnd();
  }

  // 画面外に出た弾をリストから取り除く
  void removeOffscreenBullets() {
    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      if (playerBullets.get(i).isOffscreen()) {
        playerBullets.remove(i);
      }
    }
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      if (enemyBullets.get(i).isOffscreen()) {
        enemyBullets.remove(i);
      }
    }
  }

  // 勝敗判定
  void checkGameEnd() {
    if (player.isDead()) {
      state = GameState.LOSE;
    } else if (elapsedFrames >= Config.TIME_LIMIT_FRAMES) {
      state = GameState.WIN;
    }
  }

  // ---------- 描画 ----------
  void draw() {
    background(20);

    enemy.draw();
    player.draw();

    for (PlayerBullet b : playerBullets) b.draw();
    for (EnemyBullet b : enemyBullets) b.draw();
    for (Effect e : effects) e.draw();

    drawUI();
  }

  // 簡易UI（本格的なUIは将来実装予定）
  void drawUI() {
    pushStyle();

    fill(255);
    textAlign(LEFT, TOP);
    textSize(16);
    text("LIFE: " + player.life, 10, 10);

    int remainingFrames = max(0, Config.TIME_LIMIT_FRAMES - elapsedFrames);
    int remainingSeconds = remainingFrames / 60;
    text("TIME: " + remainingSeconds, 10, 30);

    if (state == GameState.WIN) {
      textAlign(CENTER, CENTER);
      textSize(32);
      text("WIN", width / 2, height / 2);
    } else if (state == GameState.LOSE) {
      textAlign(CENTER, CENTER);
      textSize(32);
      text("LOSE", width / 2, height / 2);
    }

    popStyle();
  }
}
