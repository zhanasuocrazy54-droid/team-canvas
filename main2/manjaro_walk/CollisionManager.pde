// ==============================
// 当たり判定を一元管理するクラス
// プレイヤーの攻撃手段が廃止されたため、判定は「敵弾 vs プレイヤー本体」のみ
// ==============================
class CollisionManager {

  // ---------- 敵弾 vs プレイヤー本体 ----------
  // 被弾したらダメージ（＋当たり判定拡大）を与え、敵弾を削除する
  void checkEnemyBulletsVsPlayer(Player player,
                                  ArrayList<EnemyBullet> enemyBullets,
                                  ArrayList<Effect> effects) {
    for (int i = enemyBullets.size() - 1; i >= 0; i--) {
      EnemyBullet eb = enemyBullets.get(i);
      float d = PVector.dist(player.pos, eb.pos);
      if (d < player.radius + eb.radius) {
        player.takeDamage(Config.ENEMY_BULLET_DAMAGE);
        effects.add(new Effect(eb.pos, "hit"));
        enemyBullets.remove(i);
      }
    }
  }

  // ---------- まとめて実行 ----------
  // GameManagerから呼ばれる唯一の入口
  void checkAll(Player player,
                ArrayList<EnemyBullet> enemyBullets,
                ArrayList<Effect> effects) {
    checkEnemyBulletsVsPlayer(player, enemyBullets, effects);
  }
}
