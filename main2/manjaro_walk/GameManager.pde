// ==============================
// ゲーム全体を統括するクラス
// 責務：各オブジェクトの生成・ゲームループの制御・クリア/敗北判定
// ==============================
class GameManager {
  Player player;
  Camera camera;
  Goal goal;
  AttackDirector attackDirector;

  ArrayList<EnemyBullet> enemyBullets;
  ArrayList<Effect> effects;

  CollisionManager collisionManager;

  float playerStartY; // 進行度（%）計算用に、開始時のワールドY座標を覚えておく
  int elapsedFrames;
  GameState state;

  GameManager() {
    setupGame();
  }

  // ---------- 初期化 ----------
  void setupGame() {
    setupPlayer();
    setupCamera();
    setupGoal();
    setupAttacks();
    setupLists();
    setupState();
  }

  // プレイヤーを画面下部中央に生成する
  void setupPlayer() {
    player = new Player(new PVector(width / 2, height - 60));
    playerStartY = player.pos.y;
  }

  // カメラはプレイヤーの初期位置を基準に生成する
  void setupCamera() {
    camera = new Camera();
    camera.follow(player.pos);
  }

  // ゴールは開始位置からCLEAR_DISTANCEだけ上（ワールドYが小さい方向）に設置する
  void setupGoal() {
    goal = new Goal(playerStartY - Config.CLEAR_DISTANCE);
  }

  // 敵本体を持たない攻撃管理クラスを生成する
  void setupAttacks() {
    attackDirector = new AttackDirector();
  }

  // 弾・エフェクトの管理リストと当たり判定処理を初期化する
  void setupLists() {
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
  // 入力→移動→カメラ追従→敵弾生成→移動更新→当たり判定→Effect生成→不要オブジェクト削除
  void update() {
    if (state != GameState.PLAYING) return;

    // スペースキーでのマンジャロ消費（1回の押下につき1回だけ消費する）
    if (spaceJustPressed) {
      player.useManjaro();
      spaceJustPressed = false;
    }

    // 入力・移動（プレイヤー）
    player.move();

    // カメラをプレイヤーのYに追従させる（Xには追従しない）
    camera.follow(player.pos);

    // 敵弾生成（画面上部の画面外から生成される）
    attackDirector.update(camera, player.pos, enemyBullets);

    // 移動更新（既存の弾を動かす）
    for (EnemyBullet b : enemyBullets) b.update();

    // 当たり判定（内部でEffect生成も行う）
    collisionManager.checkAll(player, enemyBullets, effects);

    // Effect更新
    for (Effect e : effects) e.update();

    // 不要オブジェクト削除
    removeOffscreenBullets();

    // 経過時間・クリア判定・敗北判定
    elapsedFrames++;
    checkClear();
    checkGameEnd();
  }

  // 画面外（カメラ基準で下へ落ちきった／左右に外れた）に出た弾をリストから取り除く
  void removeOffscreenBullets() {
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      if (enemyBullets.get(i).isOffscreen(camera)) {
        enemyBullets.remove(i);
      }
    }
  }

  // クリア判定：プレイヤーがゴールのワールドY座標に到達したか
  void checkClear() {
    if (goal.isReachedBy(player.pos)) {
      state = GameState.CLEAR;
    }
  }

  // 敗北判定：ライフが尽きたか
  void checkGameEnd() {
    if (player.isDead()) {
      state = GameState.LOSE;
    }
  }

  // ---------- 描画 ----------
  void draw() {
    background(20);

    // ワールド座標系のオブジェクトはカメラ変換をかけてまとめて描画する
    pushMatrix();
    translate(0, -camera.y);

    goal.draw();
    player.draw();
    for (EnemyBullet b : enemyBullets) b.draw();
    for (Effect e : effects) e.draw();

    popMatrix();

    // UIは画面固定表示のため、カメラ変換の外側で描画する
    drawUI();
  }

  // 簡易UI（本格的なUIは将来実装予定）
  void drawUI() {
    pushStyle();

    fill(255);
    textAlign(LEFT, TOP);
    textSize(16);
    text("LIFE: " + player.life, 10, 10);
    text("マンジャロ: " + player.manjaroCount, 10, 30);

    int elapsedSeconds = elapsedFrames / 60;
    text("TIME: " + elapsedSeconds, 10, 50);

    float progress = constrain((playerStartY - player.pos.y) / Config.CLEAR_DISTANCE, 0, 1);
    text("PROGRESS: " + int(progress * 100) + "%", 10, 70);

    if (state == GameState.CLEAR) {
      textAlign(CENTER, CENTER);
      textSize(32);
      fill(255, 220, 80);
      text("CLEAR!", width / 2, height / 2);
    } else if (state == GameState.LOSE) {
      textAlign(CENTER, CENTER);
      textSize(32);
      fill(255);
      text("LOSE", width / 2, height / 2);
    }

    popStyle();
  }
}
