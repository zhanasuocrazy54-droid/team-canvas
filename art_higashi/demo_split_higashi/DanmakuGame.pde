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
  size(640, 800);
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
