// ==============================
// 離脱型放射弾パターン
// 通常のRadialPatternと違い、放射の「中心」が敵本体から離れて独自に移動する
// 中心は一定間隔で敵本体から生まれ、しばらく漂いながら弾を放射し、
// 時間差で消える（また敵本体から新しい中心が生まれる）
//
// 生存時間より短い間隔で新しい中心を生成することで、複数の中心が
// 同時に存在できる（DriftCenterのArrayListとして管理する）
//
// 「離脱タイミングの管理」「複数中心の更新」という挙動が基底クラスの
// 単純なテンプレートに収まらないため、update()を丸ごとオーバーライドしている
// ==============================
class DriftingRadialPattern extends BulletPattern {

  // 現在存在している中心のリスト（0個〜maxCenters個）
  ArrayList<DriftCenter> centers;

  // ---------- パラメータ（Configから受け取る） ----------
  int driftLifetime;  // 中心1つあたりの生存時間（フレーム数）
  int burstInterval;  // 中心ごとの放射間隔（フレーム数）
  int maxCenters;      // 同時に存在できる中心の最大数
  float driftSpeed;   // 中心が漂う速さ
  int bulletCount;    // 1回の放射で発射する弾数
  float bulletSpeed;  // 弾速
  float bulletRadius; // 弾のサイズ

  DriftingRadialPattern() {
    // 基底クラスのintervalは「新しい中心を生成する間隔」として使う
    super(Config.ENEMY_DRIFT_SPAWN_INTERVAL);

    driftLifetime = Config.ENEMY_DRIFT_LIFETIME;
    burstInterval = Config.ENEMY_DRIFT_BURST_INTERVAL;
    maxCenters    = Config.ENEMY_DRIFT_MAX_COUNT;
    driftSpeed    = Config.ENEMY_DRIFT_SPEED;
    bulletCount   = Config.ENEMY_DRIFT_BULLET_COUNT;
    bulletSpeed   = Config.ENEMY_DRIFT_BULLET_SPEED;
    bulletRadius  = Config.ENEMY_DRIFT_BULLET_RADIUS;

    centers = new ArrayList<DriftCenter>();
  }

  // ---------- 更新 ----------
  @Override
  void update(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    // 新しい中心を生成するタイミングの判定（上限数を超えない範囲で）
    timer++;
    if (timer >= interval) {
      timer = 0;
      if (centers.size() < maxCenters) {
        spawnCenter(enemy);
      }
    }

    // 存在する中心をすべて更新する（移動・放射・生存判定）
    for (int i = centers.size() - 1; i >= 0; i--) {
      DriftCenter c = centers.get(i);
      c.update();

      // 中心ごとに独立したタイミングで放射する
      c.burstTimer++;
      if (c.burstTimer >= burstInterval) {
        c.burstTimer = 0;
        fireBurstFrom(c.pos, enemyBullets);
      }

      // 生存時間が尽きた中心は消す（時間差での消滅）
      if (!c.isAlive()) {
        centers.remove(i);
      }
    }
  }

  // 敵本体から新しい中心を1つ生成する
  void spawnCenter(Enemy enemy) {
    float angle = random(PI/4,PI/4*3);
    PVector vel = new PVector(cos(angle), sin(angle));
    vel.mult(driftSpeed);
    centers.add(new DriftCenter(enemy.pos, vel, driftLifetime));
  }

  // ---------- 弾生成 ----------
  // 指定した位置（中心）を基準に円周方向へ弾をばらまく
  // 中心の数だけこのメソッドが個別に呼ばれる
  void fireBurstFrom(PVector origin, ArrayList<EnemyBullet> enemyBullets) {
    float angleStep = TWO_PI / bulletCount;
    for (int i = 0; i < bulletCount; i++) {
      float angle = angleStep * i;
      PVector vel = new PVector(cos(angle), sin(angle));
      vel.mult(bulletSpeed);
      enemyBullets.add(new EnemyBullet(origin, vel, bulletRadius));
    }
  }

  // BulletPatternが要求する抽象メソッド（実装義務を満たすためのもの）
  // このクラスは中心ごとにfireBurstFrom()で個別に発射するため、
  // 単一originを前提とするこのメソッド自体は使用しない
  @Override
  void fire(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    // 使用しない（fireBurstFrom()を参照）
  }

  // ---------- 描画 ----------
  // 存在する中心すべてに、発生源がわかる薄い目印を表示する
  @Override
  void draw() {
    for (DriftCenter c : centers) {
      drawTranslucentCircle(c.pos, 10, color(255, 150, 60), 150);
    }
  }
}
