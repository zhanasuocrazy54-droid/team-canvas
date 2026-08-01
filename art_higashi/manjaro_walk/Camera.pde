// ==============================
// カメラクラス
// 責務：プレイヤーのY座標にのみ追従し、ワールド座標→スクリーン座標の
// 変換基準（y）を管理する
//
// X軸方向には追従しない（プレイヤーは画面の左右に自由に寄れる＝
// ワールドX座標とスクリーンX座標は常に一致する）ため、
// このクラスはY方向のオフセットのみを保持する
//
// 描画側は pushMatrix(); translate(0, -camera.y); ... popMatrix();
// のように使うことで、ワールド座標のまま全オブジェクトを描画できる
// ==============================
class Camera {
  float y;             // ワールド座標において、現在のスクリーン最上部(y=0)が指す位置
  float playerScreenY;  // プレイヤーを画面上のどのY座標に固定表示するか

  Camera() {
    playerScreenY = height * Config.CAMERA_PLAYER_SCREEN_Y_RATIO;
    y = 0;
  }

  // 毎フレーム、プレイヤーのワールド座標を基準にカメラ位置を更新する
  // 「プレイヤーが画面上のplayerScreenYに常に固定されて見える」ようにyを逆算する
  void follow(PVector playerPos) {
    y = playerPos.y - playerScreenY;
  }

  // ワールドY座標をスクリーンY座標へ変換する（UI等、pushMatrixを使わない箇所向け）
  float worldToScreenY(float worldY) {
    return worldY - y;
  }

  // 現在の画面上端に相当するワールドY座標
  float topWorldY() {
    return y;
  }

  // 現在の画面下端に相当するワールドY座標
  float bottomWorldY() {
    return y + height;
  }
}
