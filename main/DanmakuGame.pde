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

PFont gameFont; // 日本語表示用フォント（setup()で読み込む）

void setup() {
  size(480, 640);
  // 日本語グリフを持つシステムフォントを読み込む
  // Windowsなら "Meiryo"（メイリオ）が入っていることが多い
  gameFont = createFont("Meiryo", 32, true);
  textFont(gameFont);
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
