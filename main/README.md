# 弾幕ゲーム デモ（拡張用土台）

Processing (Java モード) で作成した弾幕ゲームの土台です。
機能追加を前提とした構造になっています。フォルダ名とメインファイル名
（`DanmakuGame`）を変更しないよう、フォルダごとProcessingで開いてください。

## 動かし方

1. Processing IDE で `DanmakuGame` フォルダを開く（`DanmakuGame.pde` がメインファイル）
2. 実行（▶ボタン）
3. WASDで移動、Shift押しっぱなしで低速移動、攻撃は自動
4. 20秒ごとに画面が一時停止し、強化の3択が出るので数字キー（1〜3）で選択する
   （このとき敵も同時に強化される）

## ファイル構成と責務

| ファイル | 責務 |
|---|---|
| `DanmakuGame.pde` | `setup()`/`draw()`、キー入力イベントの受付のみ |
| `Config.pde` | ゲームバランス値（速度・弾速・間隔など）を一元管理 |
| `GameState.pde` | ゲーム状態（PLAYING / LEVEL_UP / LOSE）を表すenum |
| `GameManager.pde` | ゲームループの制御・各オブジェクトの生成・レベルアップ進行・敗北判定 |
| `CollisionManager.pde` | 当たり判定・相殺処理を一元管理（敵弾はhpが尽きるまで消えない） |
| `Player.pde` | プレイヤーの入力・移動・ライフ管理・武器の保持 |
| `Enemy.pde` | 敵の位置管理・移動パターンの保持・弾幕パターンの保持・難易度管理(levelUp) |
| `EnemyMovement.pde` | 敵の移動パターンの基底クラスと具体的な移動（サイン波/円軌道） |
| `Bullet.pde` | 弾の基底クラス（位置・速度・半径・hp・更新・描画・当たり判定） |
| `PlayerBullet.pde` / `EnemyBullet.pde` | Bulletを継承した具体的な弾 |
| `Weapon.pde` | 武器の基底クラス（発動間隔の管理） |
| `StraightShot.pde` / `ShotgunShot.pde` / `MeleeAttack.pde` | 具体的な武器 |
| `BulletPattern.pde` | 弾幕パターンの基底クラス（発射間隔の管理） |
| `RadialPattern.pde` / `AimPattern.pde` | 具体的な弾幕パターン（敵弾はEnemy.rollBulletHp()でhpを決める） |
| `Upgrade.pde` | ローグライク風の強化選択肢（拡散弾追加、ライフ増加、速度UPなど） |
| `LevelUpManager.pde` | 一定間隔でのレベルアップ（3択選択UI・入力受付・適用） |
| `Effect.pde` | 相殺演出の呼び出し口（現状は空実装） |
| `DrawUtils.pde` | 円描画などの共通描画処理 |

## ローグライク要素（レベルアップシステム）

- `GameManager` が `Config.LEVEL_UP_INTERVAL_FRAMES`（デフォルト20秒）ごとに
  `LevelUpManager.startLevelUp()` を呼び、`GameState.LEVEL_UP` に遷移してゲームを一時停止する。
- `LevelUpManager` はプレイヤーがまだ選べる `Upgrade` の中からランダムに最大3つを提示する
  （すでに持っている武器を追加するアップグレードは `isAvailable()` で除外される）。
- プレイヤーが1〜3キーで選ぶと `Upgrade.apply()` でプレイヤー強化を適用し、
  同時に `Enemy.levelUp()` を呼んで敵側も強化する（フェアさを保つため）。
- `Enemy.levelUp()` では、敵弾の最大hp上昇・既存弾幕パターンの発射間隔短縮・
  移動パターンの追加習得/切り替え、を段階的に行う。

### 新しいアップグレードを追加する

`Upgrade.pde` に `Upgrade` を継承したクラスを追加し、`LevelUpManager` のコンストラクタで
`pool.add(new ○○Upgrade());` するだけで選択肢に加わる。

### 新しい敵の移動パターンを追加する

`EnemyMovement.pde` に `EnemyMovement` を継承したクラスを追加し、`move()` だけを実装する。
`Enemy.levelUp()` の中で `unlockedMovements` に追加すれば、レベルアップ時に習得されるようになる。

## 拡張方法

### 新しい敵弾パターンを追加する（例：SpiralPattern）

`BulletPattern` を継承し、`fire()` だけを実装します。敵弾にhpを持たせたい場合は
`new EnemyBullet(enemy.pos, vel, radius, enemy.rollBulletHp())` のように4引数版のコンストラクタを使います。

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
    enemyBullets.add(new EnemyBullet(enemy.pos, vel, Config.ENEMY_SPIRAL_RADIUS, enemy.rollBulletHp()));
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
