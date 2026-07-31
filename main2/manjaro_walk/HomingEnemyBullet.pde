// ==============================
// ホーミング弾（横方向のみ追尾）
// 縦方向速度（vel.y）は生成時から変化させない＝上下にはホーミングしない
// 横方向速度（vel.x）だけを毎フレーム、プレイヤーのX座標へ向けて少しずつ補正する
//
// 自分のワールドY座標がプレイヤーのワールドY座標を超えたら
// （＝プレイヤーより下に来たら）追尾をやめ、その時点のvelのまま直進落下する
// ==============================
class HomingEnemyBullet extends EnemyBullet {
  float maxHorizontalSpeed; // 横方向速度の上限
  float turnRate;           // 1フレームあたり、目標の横方向速度へ近づく割合（0〜1）

  HomingEnemyBullet(PVector pos, PVector vel, float radius, float maxHorizontalSpeed, float turnRate) {
    super(pos, vel, radius);
    this.maxHorizontalSpeed = maxHorizontalSpeed;
    this.turnRate = turnRate;
  }

  @Override
  color getColor() {
    return color(220, 100, 255); // 紫（通常弾と区別できる色）
  }

  @Override
  void updateWithPlayer(PVector playerPos) {
    // プレイヤーより上にいる間だけ、横方向速度をプレイヤー方向へ補正する
    if (pos.y < playerPos.y) {
      float targetVelX = (playerPos.x >= pos.x) ? maxHorizontalSpeed : -maxHorizontalSpeed;
      vel.x = lerp(vel.x, targetVelX, turnRate);
    }
    // プレイヤーより下に来た後は、この分岐に入らなくなるため
    // その時点のvelがそのまま維持され、直進落下する

    update(); // 縦方向速度は常に一定のまま、位置のみ更新する
  }
}
