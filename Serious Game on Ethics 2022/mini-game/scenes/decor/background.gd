extends Control

export(Array, Texture) var textures := []

var game_version := 0

func init(version: int):
	game_version = version
	if version < textures.size():
		$TextureRect.texture = textures[version]
	else:
		$TextureRect.texture = textures[0]
