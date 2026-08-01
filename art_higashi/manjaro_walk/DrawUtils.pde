// ==============================
// 描画に関する共通処理
// Processingのクラスはstaticメソッドを持てないため、
// クラスに包まずトップレベル関数として定義する（setup()/draw()と同じ形式）
// 全てのクラスから直接呼び出せる
// ==============================

// 指定した位置・半径・色で円を描画する共通処理
// Bullet, Player, Enemy, MeleeAttackの描画で共用する
// 将来的に画像/アニメーションへ差し替える場合は、この関数の中身だけを変更すればよい
void drawCircle(PVector pos, float radius, color c) {
  pushStyle();
  noStroke();
  fill(c);
  ellipse(pos.x, pos.y, radius * 2, radius * 2);
  popStyle();
}

// 半透明の円を描画する共通処理（近接攻撃の範囲表示などで使用）
void drawTranslucentCircle(PVector pos, float radius, color c, int alpha) {
  pushStyle();
  noStroke();
  fill(c, alpha);
  ellipse(pos.x, pos.y, radius * 2, radius * 2);
  popStyle();
}

// 指定した位置を中心に、画像をsize x sizeで描画する共通処理
// テクスチャ（Assets）を使った描画はすべてこの関数を経由する
// imageMode(CENTER)はsetup()で一度だけ設定済みの前提
void drawImageCentered(PImage img, PVector pos, float size) {
  image(img, pos.x, pos.y, size, size);
}

// 縦横比が正方形でない画像（ハート・注射器など）用に、幅と高さを個別指定できる版
void drawImageCentered(PImage img, PVector pos, float w, float h) {
  image(img, pos.x, pos.y, w, h);
}
