// ==============================
// メインスケッチ
// setup()/draw()のみを記述し、実際の処理はGameManagerに委譲する
// ==============================
GameManager gameManager;

// 画像アセット（テクスチャ）を一元管理するインスタンス
// GameManager内の各クラス（Player, EnemyBullet等）から共通で参照する
Assets assets;

// キーの押下状態を保持する配列（keyCodeをインデックスとして使用）
// Processing標準のkeyPressed/key変数は「直近の1キー」しか判定できず
// WASDの同時押し（斜め移動）に対応できないため、この配列で状態管理する
// Playerクラスは同一スケッチ内の内部クラスとして、この配列に直接アクセスする
boolean[] keysHeld = new boolean[256];

// スペースキー（マンジャロ消費）は「押しっぱなしで連続消費」を防ぐため、
// keysHeldの状態監視ではなく1回の押下イベントとして扱う
// GameManager.update()側で1回読み取ったらfalseに戻す
boolean spaceJustPressed = false;

// リトライ（Rキー）も同様に1回の押下イベントとして扱う
// ゲームオーバー中のみ有効になるよう、keyPressed側で状態をチェックしてからフラグを立てる
boolean retryJustPressed = false;

void setup() {
  size(640, 800);
  imageMode(CENTER); // 以後、image()はすべて中心座標基準で描画される
  assets = new Assets(); // GameManagerより先に読み込む（各オブジェクト生成時に参照するため）
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
  if (key == ' ') {
    spaceJustPressed = true;
  }
  // ゲームオーバー中のみ、Rキーでリトライを受け付ける
  if ((key == 'r' || key == 'R') && gameManager != null && gameManager.state == GameState.LOSE) {
    retryJustPressed = true;
  }
}

void keyReleased() {
  if (keyCode >= 0 && keyCode < 256) {
    keysHeld[keyCode] = false;
  }
}
