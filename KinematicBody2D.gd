extends KinematicBody2D

var gravidade = 20
const VELOCIDADE = 200
const PULO = -400
const RESISTENCIA = Vector2(0, -1)
var movimento = Vector2()
var ataque_pulo = false
var som_ataque = true


func _physics_process(delta):
	movimento.y += gravidade
	
	if Input.is_action_pressed("direitaJ2") and ataque_pulo == false:
		movimento.x = VELOCIDADE
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("correndo")
	elif Input.is_action_pressed("esquerdaJ2") and ataque_pulo == false:
		movimento.x = -VELOCIDADE
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("correndo")
	else:
		movimento.x = 0
		
		if ataque_pulo == false:
			$AnimatedSprite.play("idle")
			
	if Input.is_action_just_pressed("ataqueJ2"):
		$AnimatedSprite.play("atacando")
		
		if $AudioAtaqueJ2.playing:
			som_ataque = false
		
		if som_ataque:
			$AudioAtaqueJ2.play()
		
		if $AnimatedSprite.flip_h == false:
			$AtaqueEsq/CollisionShape2D.disabled = false
		else:
			$AtaqueDir/CollisionShape2D.disabled = false
		
		ataque_pulo = true
		
	if is_on_floor():
		if Input.is_action_just_pressed("puloJ2"):
			$AnimatedSprite.play("pulando")
			movimento.y = PULO
			ataque_pulo = true
			
	movimento = move_and_slide(movimento, RESISTENCIA)


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "atacando" or \
	$AnimatedSprite.animation == "pulando":
		$AtaqueDir/CollisionShape2D.disabled = true
		$AtaqueEsq/CollisionShape2D.disabled = true
		ataque_pulo = false
		som_ataque = true
