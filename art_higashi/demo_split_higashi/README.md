# 弾幕ゲーム デモ（拡張用土台）

Processing (Java モード) で作成した弾幕ゲームの土台です。
機能追加を前提とした構造になっています。フォルダ名とメインファイル名
（`DanmakuGame`）を変更しないよう、フォルダごとProcessingで開いてください。

## 動かし方

1. Processing IDE で `DanmakuGame` フォルダを開く（`DanmakuGame.pde` がメインファイル）
2. 実行（▶ボタン）
3. WASDで移動、Shift押しっぱなしで低速移動、攻撃は自動

## ファイル構成と責務

| ファイル | 責務 |
|---|---|
| `DanmakuGame.pde` | `setup()`/`draw()`、キー入力イベントの受付のみ |
| `Config.pde` | ゲームバランス値（速度・弾速・間隔など）を一元管理 |
| `GameState.pde` | ゲーム状態（PLAYING / WIN / LOSE）を表すenum |
| `GameManager.pde` | ゲームループの制御・各オブジェクトの生成・勝敗判定 |
| `CollisionManager.pde` | 当たり判定・相殺処理を一元管理 |
| `Player.pde` | プレイヤーの入力・移動・ライフ管理 |
| `Enemy.pde` | 敵の位置管理・弾幕パターンの保持 |
| `Bullet.pde` | 弾の基底クラス（位置・速度・半径・更新・描画・当たり判定） |
| `PlayerBullet.pde` / `EnemyBullet.pde` | Bulletを継承した具体的な弾 |
| `Weapon.pde` | 武器の基底クラス（発動間隔の管理） |
| `StraightShot.pde` / `MeleeAttack.pde` | 具体的な武器 |
| `BulletPattern.pde` | 弾幕パターンの基底クラス（発射間隔の管理） |
| `RadialPattern.pde` / `AimPattern.pde` | 具体的な弾幕パターン |
| `Effect.pde` | 相殺演出の呼び出し口（現状は空実装） |
| `DrawUtils.pde` | 円描画などの共通描画処理 |

## 拡張方法

### 新しい敵弾パターンを追加する（例：SpiralPattern）

`BulletPattern` を継承し、`fire()` だけを実装します。

```java
class SpiralPattern extends BulletPattern {
  float angleOffset = 0;

  SpiralPattern() {
    super(Config.ENEMY_SPIRAL_INTERVAL); // Configに間隔を追加
  }

  @Override
  void fire(Enemy enemy, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    // angleOffsetを毎回少しずつ回転させることで渦状に見せる
    angleOffset += 0.2;
    PVector vel = new PVector(cos(angleOffset), sin(angleOffset));
    vel.mult(Config.ENEMY_SPIRAL_SPEED);
    enemyBullets.add(new EnemyBullet(enemy.pos, vel, Config.ENEMY_SPIRAL_RADIUS));
  }
}
```

`GameManager.setupEnemy()` で `enemy.patterns.add(new SpiralPattern());` を追加するだけで有効になります。

### 新しい武器を追加する（例：レーザー）

`Weapon` を継承し、`activate()`（と必要なら`draw()`）を実装します。
弾を生成しない武器（近接攻撃と同様のパターン）にする場合は
`MeleeAttack` を参考にしてください。

### 武器アンロック・複数ステージなど

`GameManager.setupPlayer()` / `setupEnemy()` を外部（セーブデータやステージ設定）
からのパラメータを受け取る形に拡張すれば対応できます。
`GameState` にステートを追加し `GameManager.draw()`/`update()` の分岐を増やすことで
タイトル画面・ポーズ画面・リザルト画面にも対応できます。

### 画像・アニメーションへの置き換え

現在の描画はすべて `DrawUtils.pde` の `drawCircle()` を経由しています。
この関数の中身を画像描画（`image()`）やコマ送りアニメーションに差し替えるだけで、
全オブジェクトの見た目を一括変更できます。

### エフェクトの実装

`Effect` クラスの `update()` / `draw()` に実処理を追加してください。
呼び出し側（`CollisionManager`）は変更不要です。
