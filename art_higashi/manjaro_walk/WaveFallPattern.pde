// ==============================
// 横一列＋隙間パターン（壁）
// 画面上部の画面外に、ランダムな1箇所だけ隙間を空けた横一列の弾幕を生成する
// プレイヤーは隙間の位置まで左右に移動して通り抜ける必要がある
// ==============================
class WaveFallPattern extends FallPattern {
  float bulletSpeed;
  float bulletRadius;
  float gapWidth;
  float spacing;

  WaveFallPattern() {
    super(Config.WAVE_FALL_INTERVAL);
    bulletSpeed = Config.WAVE_FALL_SPEED;
    bulletRadius = Config.WAVE_FALL_RADIUS;
    gapWidth = Config.WAVE_FALL_GAP_WIDTH;
    spacing = Config.WAVE_FALL_BULLET_SPACING;
  }

  @Override
  void fire(Camera camera, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    float gapCenterX = random(gapWidth / 2, width - gapWidth / 2);
    float y = spawnWorldY(camera);

    for (float x = 0; x <= width; x += spacing) {
      if (abs(x - gapCenterX) < gapWidth / 2) continue; // 隙間部分は生成しない

      PVector pos = new PVector(x, y);
      PVector vel = new PVector(0, bulletSpeed);
      enemyBullets.add(new EnemyBullet(pos, vel, bulletRadius, assets.bulletWave));
    }
  }
}
