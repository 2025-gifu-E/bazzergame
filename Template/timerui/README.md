# タイマーUI(開発者: rangea)
タイマーUIのシーンです。  
### 使用方法
シーンをインスタンス化して使用します。  
スクリプトにこのシーンをCtrlボタンを押しながらドラック&ドロップをしてノード取得を行います。
```gdscript:main.gd
@onready var time: Control = $time
```
このようなコードが出てきます。
そしたら  
`time_start()`でタイマーをスタート、  
`time_stop()`でタイマーをストップできます。  
`time_left()`で現在の時間を取得できます。  
シグナルの`time_out()`に接続してタイマー終了を検知できます。  
ここにゲームオーバーの処理などを書きましょう。  
### インスペクター設定
|インスペクター名|説明|
|---|---|
|Time Limit|残り時間|
|Change Value Color|残り時間の色が変化するか|
|Meter Color|メーターの色を変更します。|
|Meter Gradation|メーターの色が残り時間に応じて変化します。<br>オンの間はMeter Colorが無効になります。|
|Start Color|開始時の色|
|End Color|終了時の色|
