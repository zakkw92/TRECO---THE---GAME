extends SceneTree

func _init():
    print("[TEST] Iniciando teste de instanciação da TavernTable...")
    var scene = load("res://scenes/TavernTable.tscn")
    if scene == null:
        print("[FAIL] Não foi possível carregar res://scenes/TavernTable.tscn!")
        quit(1)
        return
    print("[OK] Cena TavernTable.tscn carregada com sucesso!")
    var instance = scene.instantiate()
    if instance == null:
        print("[FAIL] Falha ao instanciar TavernTable!")
        quit(1)
        return
    print("[OK] TavernTable instanciada com sucesso!")
    root.add_child(instance)
    print("[OK] TavernTable adicionada à árvore com sucesso! NENHUM ERRO!")
    quit(0)
