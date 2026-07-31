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
  LevelUpManager levelUpManager;

  int elapsedFrames;
  int nextLevelUpFrame; // 次にレベルアップ判定を行うフレーム数
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
    //player.weapons.add(new MeleeAttack());
  }

  // 敵と使用する弾幕パターンを生成する
  // 将来的な複数ボス対応は、Enemyを複数生成しリストで管理する形に拡張できる
  void setupEnemy() {
    enemy = new Enemy(new PVector(width / 2, 80));
    enemy.patterns.add(new RadialPattern());
    //enemy.patterns.add(new SpiralRadialPattern());
    enemy.patterns.add(new DriftingRadialPattern());
    enemy.patterns.add(new AimPattern());
    enemy.patterns.add(new AimPattern_Double());
  }

  // 弾・エフェクトの管理リストと当たり判定処理を初期化する
  void setupLists() {
    playerBullets = new ArrayList<PlayerBullet>();
    enemyBullets = new ArrayList<EnemyBullet>();
    effects = new ArrayList<Effect>();
    collisionManager = new CollisionManager();
      levelUpManager = new LevelUpManager();
  }

  // 経過時間・ゲーム状態を初期化する
  void setupState() {
    elapsedFrames = 0;
    nextLevelUpFrame = Config.LEVEL_UP_INTERVAL_FRAMES;
    state = GameState.PLAYING;
  }

  // ---------- 更新（ゲームループ本体） ----------
  // 入力→移動→攻撃生成→敵弾生成→移動更新→当たり判定→Effect生成→不要オブジェクト削除
  void update() {
    // レベルアップ選択中はゲーム進行を止め、入力受付のみ行う
    if (state == GameState.LEVEL_UP) {
      levelUpManager.handleInput(this);
      return;
    }
    if (state != GameState.PLAYING) return;

    // 入力・移動（プレイヤー）
    player.move();

    // 攻撃生成（プレイヤー武器）
    player.updateWeapons(playerBullets);

    // 敵の移動・敵弾生成
    enemy.move();
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

    // 経過時間・レベルアップ判定・敗北判定
    elapsedFrames++;
    checkLevelUp();
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

  // 一定時間（Config.LEVEL_UP_INTERVAL_FRAMES）ごとにレベルアップ（3択選択）を発生させる
  void checkLevelUp() {
    if (elapsedFrames >= nextLevelUpFrame) {
      nextLevelUpFrame += Config.LEVEL_UP_INTERVAL_FRAMES;

      levelUpManager.startLevelUp(this);
    }
  }

  // 敗北判定のみ（時間制限による勝利は撤廃し、エンドレスにする）
  void checkGameEnd() {
    if (player.isDead()) {
      state = GameState.LOSE;
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
    
    // レベルアップ選択中は最後に画面全体へ選択肢を重ねて表示する
    levelUpManager.draw();
  }

  // 簡易UI（本格的なUIは将来実装予定）
  void drawUI() {
    pushStyle();

    fill(255);
    textAlign(LEFT, TOP);
    textSize(16);
    text("LIFE: " + player.life, 10, 10);

    int elapsedSeconds = elapsedFrames / 60;
    text("TIME: " + elapsedSeconds, 10, 30);
    text("STAGE: " + enemy.difficultyStage, 10, 50);

    if (state == GameState.LOSE) {
      textAlign(CENTER, CENTER);
      textSize(32);
      text("LOSE", width / 2, height / 2);
    }

    popStyle();
  }
}
