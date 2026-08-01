// ==============================
// クリア地点（ゴール）クラス
// 画面外の上方に固定されたワールド座標を持つだけの単純なクラス
// プレイヤーのワールドY座標がこのY以下になったらクリアとする
// ==============================
class Goal {
  float y; // ゴールのワールドY座標（この値以下に到達したらクリア）

  Goal(float y) {
    this.y = y;
  }

  boolean isReachedBy(PVector playerPos) {
    return playerPos.y <= y;
  }

  // ---------- 描画 ----------
  // ワールド座標系のまま呼び出される想定（GameManager側でpushMatrix/translate済み）
  // 近づくと横一直線のラインとして見えるようにする
  void draw() {
    pushStyle();
    stroke(255, 220, 80);
    strokeWeight(4);
    line(0, y, width, y);

    noStroke();
    fill(255, 220, 80);
    textAlign(CENTER, BOTTOM);
    textSize(20);
    text("GOAL", width / 2, y - 10);
    popStyle();
  }
}
