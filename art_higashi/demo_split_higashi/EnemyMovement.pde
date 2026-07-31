// ==============================
// 敵の移動パターンの基底クラス
// 責務：Enemyの位置(pos)を毎フレーム更新することのみ
// BulletPattern / Weaponと同じ考え方で「動き方」を切り替え可能にする
// ==============================
abstract class EnemyMovement {
  abstract void move(Enemy enemy);
}

// ---------- 左右サイン波移動 ----------
// 中心位置を軸に、サイン波でなめらかに左右へ揺れながら移動する
// 一定間隔でランダムに位相の進む方向（dir）を反転させることで、動きに不規則さを出す
class SwayMovement extends EnemyMovement {
  float centerX;
  float angle;
  float swaySpeed;
  float swayAmplitude;
  int dir;             // +1 または -1（角度の進む方向）
  int dirChangeTimer;  // 次に反転するまでの残りフレーム数

  SwayMovement(float centerX) {
    this.centerX = centerX;
    angle = 0;
    swaySpeed = Config.ENEMY_SWAY_SPEED;
    swayAmplitude = Config.ENEMY_SWAY_AMPLITUDE;
    dir = 1;
    dirChangeTimer = nextInterval();
  }

  int nextInterval() {
    return int(random(Config.ENEMY_DIR_CHANGE_MIN, Config.ENEMY_DIR_CHANGE_MAX));
  }

  @Override
  void move(Enemy enemy) {
    angle += swaySpeed * dir;

    enemy.pos.x = centerX + sin(angle) * swayAmplitude;
    enemy.pos.x = constrain(enemy.pos.x, enemy.radius, width - enemy.radius);

    dirChangeTimer--;
    if (dirChangeTimer <= 0) {
      dir *= -1;
      dirChangeTimer = nextInterval();
    }
  }
}

// ---------- 円軌道移動 ----------
// 指定した中心点を軸に、横長の楕円軌道で周回する
class CircleMovement extends EnemyMovement {
  float centerX;
  float centerY;
  float r;
  float angle;
  float speed;

  CircleMovement(float centerX, float centerY) {
    this.centerX = centerX;
    this.centerY = centerY;
    r = Config.ENEMY_CIRCLE_RADIUS;
    angle = 0;
    speed = Config.ENEMY_CIRCLE_SPEED;
  }

  @Override
  void move(Enemy enemy) {
    angle += speed;
    enemy.pos.x = centerX + cos(angle) * r;
    enemy.pos.y = centerY + sin(angle) * r * 0.4; // 縦方向は控えめにして横長の軌道にする
  }
}
