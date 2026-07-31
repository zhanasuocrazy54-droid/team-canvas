// ==============================
// レベルアップ時の3択選択を管理するクラス
// 一定時間ごとにGameManagerから呼び出され、選択肢の提示・入力受付・適用を行う
// ==============================
class LevelUpManager {
  ArrayList<Upgrade> pool;           // 全アップグレードの候補
  ArrayList<Upgrade> currentChoices; // 現在提示中の選択肢（最大3つ）
  boolean waitingForChoice;

  LevelUpManager() {
    pool = new ArrayList<Upgrade>();
    pool.add(new AddShotgunUpgrade());
    pool.add(new AddMeleeUpgrade());
    pool.add(new IncreaseLifeUpgrade());
    pool.add(new IncreaseSpeedUpgrade());
    pool.add(new AttackSpeedUpgrade());
    // 新しいアップグレードを追加したい場合はここに1行足すだけでよい

    currentChoices = new ArrayList<Upgrade>();
    waitingForChoice = false;
  }

  // ---------- レベルアップ開始 ----------
  // 選択可能なアップグレードの中からランダムに最大3つを選び、ゲームを一時停止する
  void startLevelUp(GameManager gm) {
    ArrayList<Upgrade> available = new ArrayList<Upgrade>();
    for (Upgrade u : pool) {
      if (u.isAvailable(gm)) available.add(u);
    }

    java.util.Collections.shuffle(available);

    currentChoices.clear();
    int count = min(3, available.size());
    for (int i = 0; i < count; i++) {
      currentChoices.add(available.get(i));
    }

    waitingForChoice = true;
    gm.state = GameState.LEVEL_UP;
  }

  // ---------- 入力受付 ----------
  // 1〜3キーで選択肢を選ぶ。選択したらプレイヤー強化と敵強化を同時に行う
  void handleInput(GameManager gm) {
    if (!waitingForChoice) return;

    for (int i = 0; i < currentChoices.size(); i++) {
      char key = (char) ('1' + i);
      if (keysHeld[key]) {
        currentChoices.get(i).apply(gm); // プレイヤー強化
        gm.enemy.levelUp();              // 敵も同時に強化（フェアにするため）
        waitingForChoice = false;
        gm.state = GameState.PLAYING;
        break;
      }
    }
  }

  // ---------- 描画 ----------
  // 選択中はゲーム画面の上に半透明のオーバーレイと選択肢を重ねて表示する
  void draw() {
    if (!waitingForChoice) return;

    pushStyle();

    fill(0, 200);
    rect(0, 0, width, height);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(22);
    text("LEVEL UP！ 数字キーで選択", width / 2, height / 2 - 100);

    textSize(16);
    for (int i = 0; i < currentChoices.size(); i++) {
      Upgrade u = currentChoices.get(i);
      String line = (i + 1) + ". " + u.name + " - " + u.description;
      text(line, width / 2, height / 2 - 20 + i * 40);
    }

    popStyle();
  }
}
