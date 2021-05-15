extends KinematicBody2D

var hit = preload("res://cenas/hit/Hit.tscn")

var gravidade = 20
const VELOCIDADE = 200
const PULO = -400
const RESISTENCIA = Vector2(0, -1)
const DANO = 10
var vida = 100
var movimento = Vector2()
var atacando = false
var pulando = false
var som_ataque = true
var recebendo_dano = false


func _physics_process(delta):
	movimento.y += gravidade
	
	if !is_morto(vida):
		if Input.is_action_pressed("direitaJ1") \
		and atacando == false and pulando == false \
		and recebendo_dano == false:
			movimento.x = VELOCIDADE
			$AnimatedSprite.flip_h = false
			$AnimatedSprite.play("correndo")
		elif Input.is_action_pressed("esquerdaJ1") \
		and atacando == false and pulando == false \
		and recebendo_dano == false:
			movimento.x = -VELOCIDADE
			$AnimatedSprite.flip_h = true
			$AnimatedSprite.play("correndo")
		else:
			movimento.x = 0
			
			if atacando == false and pulando == false \
			and recebendo_dano == false:
				$AnimatedSprite.play("idle")
				
		if Input.is_action_just_pressed("ataqueJ1") \
		and recebendo_dano == false:
			$AnimatedSprite.play("atacando")
			$AtaqueJ1/CollisionShape2D.disabled = false
			
			if som_ataque:
				$AudioAtaqueJ1.play()
				som_ataque = false
				
			z_index = 1
			atacando = true
			
		if is_on_floor():
			if Input.is_action_just_pressed("puloJ1") \
			and atacando == false:
				$AnimatedSprite.play("pulando")
				movimento.y = PULO
				pulando = true
				
		if $AnimatedSprite.flip_h == true:
			$AtaqueJ1/CollisionShape2D.disabled = true
	else:
		$AtaqueJ1/CollisionShape2D.disabled = true
		$AnimatedSprite.play("morrendo")
			
	movimento = move_and_slide(movimento, RESISTENCIA)


func receber_dano():
	recebendo_dano = true	
	$Timer.start()


func is_morto(vida):
	if vida <= 0:
		 return true


func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "atacando" \
	or $AnimatedSprite.animation == "pulando" \
	or $AnimatedSprite.animation == "recebendo_dano":
		if !is_morto(vida):
			$AtaqueJ1/CollisionShape2D.disabled = true
			z_index = 0
			atacando = false
			pulando = false
			som_ataque = true
			recebendo_dano = false


func _on_AtaqueJ1_body_entered(body):
	if body.name == "Jogador2":
		body.receber_dano()


func _on_Timer_timeout():
	vida -= DANO
	
	if !is_morto(vida):
		$AnimatedSprite.play("recebendo_dano")

		var instancia_hit = hit.instance()
		instancia_hit.global_position = global_position
		instancia_hit.global_position.x += 20
		get_tree().get_current_scene().add_child(instancia_hit)
	
	get_node("../HUD/VidaJ1").value -= DANO
