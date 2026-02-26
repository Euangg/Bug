class_name Hurtbox
extends Area2D

signal hit

func porcess_collision():hit.emit()
