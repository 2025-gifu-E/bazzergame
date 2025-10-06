# ゲームオーバーオーバレイ(開発者: rangea)
ゲームオーバーしたときのオーバーレイテンプレイートです。
## 使用方法
`CanvasLayer`ノードにこのシーンをインスタンス化して使用します。  
スクリプトにこのシーンをCtrlボタンを押しながらドラック&ドロップをしてノード取得を行います。
```gdscript:main.gd
@onready var gameoveroverlay = $CanvasLayer/gameoveroverlay
```
このようなコードが出てきます。
そしたらゲームオーバーしたときの処理(timeoutなど)にgameover_view()関数を呼び出すとオーバレイが出てきます。あとは、
```gdscript:main.gd
await get_tree().create_timer(任意の数).timeout
SceneManager.change_scene("res://TitleMenu/title.tscn",{"skip_fade_out":true,"skip_fade_in":true})
```
などを下に書いてタイトルに戻しましょう。簡単だね。