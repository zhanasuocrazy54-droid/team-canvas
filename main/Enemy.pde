// ==============================
// 敵クラス
// 画面上部中央に固定され、プレイヤーからダメージを受けない
// 責務：位置の保持・弾幕パターンの管理
// 弾の生成は行わない（BulletPatternに委譲する）
// ==============================
class Enemy {
  PVector pos;
  float radius; // 描画用の半径（当たり判定には使用しない＝攻撃対象ではないため）

  // ---------- 移動関連 ----------
  EnemyMovement currentMovement;
  ArrayList<EnemyMovement> unlockedMovements; // これまでに習得した移動パターン
  PVector homePos; // 移動パターンの中心座標として使う固定の基準点

  // ---------- 難易度関連 ----------
  int difficultyStage; // levelUp()が呼ばれた回数（＝プレイヤーが強化を選んだ回数）
  int maxBulletHp;      // 敵弾の最大HP。大きいほどプレイヤー弾を複数発耐える

  // 使用する弾幕パターンのリスト（既に有効なもの）
  ArrayList<BulletPattern> patterns;

  // まだ有効化されていない弾幕パターンの候補（レベルアップで段階的に解放される）
  ArrayList<BulletPattern> lockedPatterns;

  Enemy(PVector fixedPos) {
    pos = fixedPos.copy();
    homePos = fixedPos.copy();
    radius = Config.ENEMY_RADIUS;
    patterns = new ArrayList<BulletPattern>();
    lockedPatterns = new ArrayList<BulletPattern>(); // ← 追加

    difficultyStage = 0;
    maxBulletHp = 1;

    unlockedMovements = new ArrayList<EnemyMovement>();
    currentMovement = new SwayMovement(homePos.x);
    unlockedMovements.add(currentMovement);
  }
  // GameManagerからまだ有効化していないパターンを登録するための入口
  void addLockedPattern(BulletPattern p) {
    lockedPatterns.add(p);
  }

  // ---------- 移動 ----------
  // 実際の移動計算は現在選択中のEnemyMovementに委譲する
  void move() {
    currentMovement.move(this);
  }

  // ---------- 敵弾生成 ----------
  // 各パターンを更新し、発射タイミングが来ていれば敵弾リストへ弾を追加させる
  void updatePatterns(PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    for (BulletPattern p : patterns) {
      p.update(this, playerPos, enemyBullets);
    }
  }

  // 敵弾1発ごとのhpをランダムに決める（1〜maxBulletHp）。BulletPatternのfire()から呼ばれる
  int rollBulletHp() {
    return int(random(1, maxBulletHp + 1));
  }

  // ---------- レベルアップ ----------
  // プレイヤーが強化を選ぶたびにGameManager経由で呼ばれ、敵側も同時に強くなる
  void levelUp() {
    difficultyStage++;

    // 2段階ごとに敵弾の最大hpを1増やす（弾がだんだん硬くなる）
    if (difficultyStage % 2 == 0) {
      maxBulletHp++;
    }

    // 段階が進むごとに、既に有効な全パターンの発射間隔を少しずつ縮める
    // （ランダムに1つだけでなく全体を縮めることで、確実に密度が上がっていく）
    for (BulletPattern p : patterns) {
      p.interval = max(8, int(p.interval * 0.92));
    }

    // 3段階ごとに、新しい弾幕パターンを1つ解禁する
    if (difficultyStage % 3 == 0 && !lockedPatterns.isEmpty()) {
      patterns.add(lockedPatterns.remove(0));
    }

    // まだ習得していない移動パターンがあれば新しく習得して切り替える
    if (unlockedMovements.size() < 2) {
      CircleMovement circle = new CircleMovement(homePos.x, homePos.y);
      unlockedMovements.add(circle);
      currentMovement = circle;
    } else {
      currentMovement = unlockedMovements.get(int(random(unlockedMovements.size())));
    }
  }

  // ---------- 描画 ----------
  void draw() {
    drawShape();

    // 各パターンが専用の描画を持っていれば、それも呼び出す
    // （例：本体から離脱して漂う攻撃の中心を可視化するなど）
    for (BulletPattern p : patterns) {
      p.draw();
    }
  }

  void drawShape() {
    drawCircle(pos, radius, color(255, 60, 60)); // 赤
  }
}
