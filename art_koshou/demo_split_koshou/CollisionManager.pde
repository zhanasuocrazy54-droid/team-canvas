// ==============================
// 当たり判定・相殺処理を一元管理するクラス
// Bullet/Weapon自身に衝突相手を知らせないことでクラス間の依存を減らす
// ==============================
class CollisionManager {

  // ---------- プレイヤー通常弾 vs 敵弾 ----------
  // 衝突したら両方を削除し、Effectを生成する
  void checkPlayerBulletsVsEnemyBullets(ArrayList<PlayerBullet> playerBullets,
                                         ArrayList<EnemyBullet> enemyBullets,
                                         ArrayList<Effect> effects) {
    for (int i = playerBullets.size() - 1; i >= 0; i--) {
      PlayerBullet pb = playerBullets.get(i);
      boolean hit = false;

      for (int j = enemyBullets.size() - 1; j >= 0; j--) {
        EnemyBullet eb = enemyBullets.get(j);
        if (pb.isHit(eb.pos, eb.radius)) {
          effects.add(new Effect(eb.pos, "cancel"));
          enemyBullets.remove(j);
          hit = true;
          break; // 通常弾は1発につき1つの敵弾と相殺する
        }
      }

      if (hit) {
        playerBullets.remove(i);
      }
    }
  }

  // ---------- 近接攻撃 vs 敵弾 ----------
  // 近接攻撃自体は消えず、範囲内の敵弾のみを削除する
  void checkMeleeVsEnemyBullets(Player player,
                                 ArrayList<EnemyBullet> enemyBullets,
                                 ArrayList<Effect> effects) {
    for (Weapon w : player.weapons) {
      if (!(w instanceof MeleeAttack)) continue;

      MeleeAttack melee = (MeleeAttack) w;
      if (!melee.isActive()) continue;

      for (int j = enemyBullets.size() - 1; j >= 0; j--) {
        EnemyBullet eb = enemyBullets.get(j);
        float d = PVector.dist(player.pos, eb.pos);
        if (d < melee.radius + eb.radius) {
          effects.add(new Effect(eb.pos, "cancel"));
          enemyBullets.remove(j);
        }
      }
    }
  }

  // ---------- 敵弾 vs プレイヤー本体 ----------
  // 被弾したらダメージを与え、敵弾を削除する
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
                ArrayList<PlayerBullet> playerBullets,
                ArrayList<EnemyBullet> enemyBullets,
                ArrayList<Effect> effects) {
    checkPlayerBulletsVsEnemyBullets(playerBullets, enemyBullets, effects);
    checkMeleeVsEnemyBullets(player, enemyBullets, effects);
    checkEnemyBulletsVsPlayer(player, enemyBullets, effects);
  }
}
