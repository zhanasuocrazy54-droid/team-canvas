// ==============================
// 自機狙い落下パターン
// 画面上部の画面外にランダムなX座標で弾を生成し、
// 「一定距離落ちる間に自機の現在X座標へ緩やかに寄っていく」向きで落とす
// （発射後は追尾しない＝方向は生成時点で固定）
// ==============================
class AimedFallPattern extends FallPattern {
  float bulletSpeed;
  float bulletRadius;

  AimedFallPattern() {
    super(Config.AIMED_FALL_INTERVAL);
    bulletSpeed = Config.AIMED_FALL_SPEED;
    bulletRadius = Config.AIMED_FALL_RADIUS;
  }

  @Override
  void fire(Camera camera, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    float x = random(0, width);
    PVector pos = new PVector(x, spawnWorldY(camera));

    // 「AIMED_FALL_AIM_DISTANCEだけ下に落ちる間にプレイヤーのXへ到達する」向きを計算する
    // 単純に自機座標を直接狙うと角度がきつくなりすぎるため、緩やかな斜め落下にする
    PVector dir = new PVector(playerPos.x - x, Config.AIMED_FALL_AIM_DISTANCE);
    dir.normalize();
    dir.mult(bulletSpeed);

    enemyBullets.add(new EnemyBullet(pos, dir, bulletRadius, assets.bulletAimed));
  }
}
