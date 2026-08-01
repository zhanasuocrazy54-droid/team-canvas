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
    // ゲームオーバー中はRキーでのリトライ受付のみ行う
    if (state == GameState.LOSE) {
      if (retryJustPressed) {
        retryJustPressed = false;
        setupGame(); // 全オブジェクトを初期状態に作り直す
      }
      return;
    }

    if (state != GameState.PLAYING) return; // CLEAR中はこれ以上何もしない

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

    // 移動更新（既存の弾を動かす。ホーミング弾はプレイヤー座標を使って横方向を補正する）
    for (EnemyBullet b : enemyBullets) b.updateWithPlayer(player.pos);

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
    drawManjaroFollowIcon(); // マンジャロ効果中のみ、プレイヤーの右上に注射器アイコンを追従表示する

    popMatrix();

    // UIは画面固定表示のため、カメラ変換の外側で描画する
    drawUI();
  }

  // マンジャロ効果が継続している間、プレイヤーのすぐ右上に注射器アイコンを追従表示する
  // ワールド座標系（pushMatrix/translate済み）の中で呼ばれる想定
  void drawManjaroFollowIcon() {
    if (!player.isManjaroDebuffed()) return;
    if (assets.syringe == null) return;

    PVector iconPos = new PVector(
      player.pos.x + Config.MANJARO_FOLLOW_OFFSET_X,
      player.pos.y - Config.MANJARO_FOLLOW_OFFSET_Y
    );
    drawImageCentered(assets.syringe, iconPos, Config.MANJARO_FOLLOW_ICON_WIDTH, Config.MANJARO_FOLLOW_ICON_HEIGHT);
  }

  // UI（画面固定表示）
  void drawUI() {
    pushStyle();

    drawHeartGauge();
    drawManjaroStock();

    fill(255);
    textAlign(LEFT, TOP);
    textSize(16);
    int elapsedSeconds = elapsedFrames / 60;
    text("TIME: " + elapsedSeconds, 10, 10);

    float progress = constrain((playerStartY - player.pos.y) / Config.CLEAR_DISTANCE, 0, 1);
    text("PROGRESS: " + int(progress * 100) + "%", 10, 30);

    if (state == GameState.CLEAR) {
      textAlign(CENTER, CENTER);
      textSize(32);
      fill(255, 220, 80);
      text("CLEAR!", width / 2, height / 2);
    } else if (state == GameState.LOSE) {
      textAlign(CENTER, CENTER);
      textSize(32);
      fill(255);
      text("LOSE", width / 2, height / 2 - 20);

      textSize(18);
      fill(255, 220, 80);
      text("press R to retry", width / 2, height / 2 + 20);
    }

    popStyle();
  }

  // ---------- UI：ライフ（ハート）ゲージ ----------
  // ハート1個＝ライフ2ポイント。画面左下に、左から右へ並べて表示する
  // ライフが奇数の場合、右端の1個だけ半分のハート画像にする
  void drawHeartGauge() {
    if (assets.heartFull == null || assets.heartHalf == null) return;

    int fullHearts = player.life / 2;
    boolean hasHalfHeart = (player.life % 2) != 0;

    float baseX = Config.HEART_MARGIN_X;
    float baseY = height - Config.HEART_MARGIN_Y;

    int index = 0;
    for (int i = 0; i < fullHearts; i++) {
      PVector p = new PVector(baseX + index * Config.HEART_SPACING, baseY);
      drawImageCentered(assets.heartFull, p, Config.HEART_WIDTH, Config.HEART_HEIGHT);
      index++;
    }
    if (hasHalfHeart) {
      PVector p = new PVector(baseX + index * Config.HEART_SPACING, baseY);
      drawImageCentered(assets.heartHalf, p, Config.HEART_WIDTH, Config.HEART_HEIGHT);
    }
  }

  // ---------- UI：マンジャロ在庫表示 ----------
  // 画面右下に、マンジャロの残数だけ注射器アイコンを並べる
  // 各アイコンの下には土台として丸い図形を描く
  void drawManjaroStock() {
    if (assets.syringe == null) return;

    float baseX = width - Config.MANJARO_MARGIN_X;
    float baseY = height - Config.MANJARO_MARGIN_Y ;

    for (int i = 0; i < player.manjaroCount; i++) {
      // 右端から左方向へ並べる
      float x = baseX - i * Config.MANJARO_ICON_SPACING;
      PVector roundPos = new PVector(x+5, baseY + Config.MANJARO_ICON_HEIGHT * 0.25 - 15);
      color roundColor = color(Config.MANJARO_ROUND_COLOR_R, Config.MANJARO_ROUND_COLOR_G,
                                Config.MANJARO_ROUND_COLOR_B, Config.MANJARO_ROUND_COLOR_A);
      drawCircle(roundPos, Config.MANJARO_ROUND_RADIUS, roundColor);

      PVector iconPos = new PVector(x, baseY);
      drawImageCentered(assets.syringe, iconPos, Config.MANJARO_ICON_WIDTH, Config.MANJARO_ICON_HEIGHT);
    }
  }
}
