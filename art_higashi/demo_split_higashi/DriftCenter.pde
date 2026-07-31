// ==============================
// 漂う中心1つ分の状態を管理するクラス
// DriftingRadialPatternは複数のDriftCenterをArrayListで持つことで、
// 中心が同時に複数存在できるようにする
// ==============================
class DriftCenter {
  PVector pos;
  PVector vel;
  int lifeTimer;   // 残り生存フレーム数（0以下で消滅）
  int burstTimer;  // この中心専用の放射タイミング用サブタイマー

  DriftCenter(PVector startPos, PVector vel, int lifetime) {
    this.pos = startPos.copy();
    this.vel = vel.copy();
    this.lifeTimer = lifetime;
    this.burstTimer = 0;
  }

  // ---------- 更新 ----------
  // 移動と生存時間のカウントダウンのみを行う
  void update() {
    pos.add(vel);
    lifeTimer--;
  }

  // まだ生きているか
  boolean isAlive() {
    return lifeTimer > 0;
  }
}
