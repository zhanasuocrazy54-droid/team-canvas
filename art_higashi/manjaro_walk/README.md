# 弾幕ゲーム デモ（縦スクロール・登攀型）

Processing (Java モード) で作成した「敵弾を避けながら画面外上方のゴールを
目指す」縦スクロールゲームです。フォルダ名とメインファイル名
（`DanmakuGame`）を変更しないよう、フォルダごとProcessingで開いてください。

## 動かし方

1. Processing IDE で `DanmakuGame` フォルダを開く（`DanmakuGame.pde` がメインファイル）
2. 実行（▶ボタン）
3. WASDで移動、Shift押しっぱなしで低速移動
4. スペースキーで「マンジャロ」を消費（開始時3個）
   - 当たり判定（半径）が縮小する代わりに、一定時間 移動速度が低下するデバフを受ける
5. 敵弾に当たると当たり判定（半径）が拡大し、ライフが減る
6. 画面外上方のゴールに到達すればクリア、ライフが尽きればLOSE

## ゲームシステム概要

- **カメラ**：プレイヤーのY座標にのみ追従する（画面上の高さは常に一定）。
  X座標には追従しないため、プレイヤーは画面の左右に自由に寄れる。
  敵弾もすべてワールド座標で管理されているため、カメラの動きに連動して
  画面内での上下位置が変化する。
- **クリア条件**：スタート地点から`Config.CLEAR_DISTANCE`だけ上（画面外）に
  設置されたゴールにプレイヤーのワールドY座標が到達すること。
- **当たり判定の拡大**：敵弾に当たるたびに`Player.radius`が
  `Config.PLAYER_RADIUS_GROWTH_PER_HIT`ずつ拡大する（上限あり）。
- **マンジャロ**：スペースキーで消費するアイテム。当たり判定を縮小する
  代わりに一定時間の移動速度デバフを負う、ハイリスク・ハイリターンな
  救済アイテム。所持数は`Config.MANJARO_START_COUNT`。

## ファイル構成と責務

| ファイル | 責務 |
|---|---|
| `DanmakuGame.pde` | `setup()`/`draw()`、キー入力イベントの受付のみ |
| `Config.pde` | ゲームバランス値を一元管理 |
| `GameState.pde` | ゲーム状態（PLAYING / CLEAR / LOSE）を表すenum |
| `GameManager.pde` | ゲームループの制御・各オブジェクトの生成・クリア/敗北判定 |
| `Camera.pde` | プレイヤーのYに追従するカメラ（ワールド→スクリーン変換の基準） |
| `Goal.pde` | クリア地点（ワールド座標上の固定ライン） |
| `CollisionManager.pde` | 敵弾とプレイヤーの当たり判定を一元管理 |
| `Player.pde` | プレイヤーの入力・移動・ライフ・当たり判定・マンジャロ管理 |
| `AttackDirector.pde` | 敵本体を持たず、複数のFallPatternを管理する攻撃司令塔 |
| `Bullet.pde` | 弾の基底クラス（位置・速度・半径・更新・描画・当たり判定） |
| `EnemyBullet.pde` | Bulletを継承した敵弾（画面外へ落ちきったら削除） |
| `FallPattern.pde` | 落下型・敵弾パターンの基底クラス（生成間隔の管理） |
| `StraightFallPattern.pde` | まっすぐ落下する弾 |
| `AimedFallPattern.pde` | 自機のX座標へ緩やかに寄りながら落下する弾 |
| `WaveFallPattern.pde` | 隙間付きの横一列の壁として落下する弾 |
| `Effect.pde` | 被弾演出の呼び出し口（現状は空実装） |
| `DrawUtils.pde` | 円描画などの共通描画処理 |

## 拡張方法

### 新しい敵弾パターンを追加する

`FallPattern` を継承し、`fire()` だけを実装します。`spawnWorldY(camera)` を
使えば、常に現在の画面上端（カメラ基準）の画面外から生成できます。

```java
class MyFallPattern extends FallPattern {
  MyFallPattern() {
    super(60); // 生成間隔（フレーム数）
  }

  @Override
  void fire(Camera camera, PVector playerPos, ArrayList<EnemyBullet> enemyBullets) {
    PVector pos = new PVector(random(width), spawnWorldY(camera));
    PVector vel = new PVector(0, 4);
    enemyBullets.add(new EnemyBullet(pos, vel, 8));
  }
}
```

`AttackDirector`のコンストラクタで `patterns.add(new MyFallPattern());` を
追加するだけで有効になります。

### 画像・アニメーションへの置き換え

現在の描画はすべて `DrawUtils.pde` の `drawCircle()` を経由しています。
この関数の中身を画像描画（`image()`）に差し替えるだけで、全オブジェクトの
見た目を一括変更できます。
