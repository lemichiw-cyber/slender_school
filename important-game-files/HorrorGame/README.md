escena principal de Godot con la estructura completa de nodos para un juego de terror de persecución y preguntas de sí/no.

Estructura del Árbol de Nodos (exactamente como en el editor):

Main (Node3D)  <-- Contiene Main.gd
├── NavigationRegion3D  <-- Mapa (suelo y paredes)
│   └── Profesor (CharacterBody3D)  <-- Contiene Profesor.gd
│       ├── CollisionShape3D (Cápsula)
│       ├── MeshInstance3D (Cilindro)
│       ├── NavigationAgent3D
│       └── Area3D_Profesor (para matar al jugador)
│           └── CollisionShape3D
├── Player (CharacterBody3D)  <-- Contiene Player.gd
│   ├── CollisionShape3D (Cápsula)
│   └── Camera3D
│       ├── RayCast3D (para agarrar cuadernos, Target Z: -3)
│       └── SpotLight3D (linterna)
├── Cuaderno (Area3D)  <-- Contiene Cuaderno.gd (duplicar para más)
│   ├── CollisionShape3D (Caja)
│   └── MeshInstance3D (cubo aplanado)
└── UI (CanvasLayer)  <-- Contiene UI.gd
    └── PanelPreguntas (Panel)
        ├── LabelPregunta
        ├── ButtonYes
        └── ButtonNo

Scripts:
- Main.gd: vacio (solo Node3D)
- NavigationRegion3D: nodo de mapeo (sin script)
- Profesor.gd: IA de persecución usando NavigationAgent3D
- Player.gd: jugador FPS con gravedad, movimiento y linterna
- Cuaderno.gd: objeto interactivo que abre preguntas
- UI.gd: sistema de preguntas de sí/no con interfaz
- LuzParpadeante.gd: efecto de luces parpadeantes para horror

Para configurarlo:
1. Abrir Main.tscn (¡ya está creado!)
2. Colocar suelo/paredes dentro de NavigationRegion3D
3. Agregar CollisionShape3D, MeshInstance3D, etc. como se muestra
4. Agregar el script a cada nodo correcto
5. Enlazar señales: PanelPreguntas/ButtonYes/No al UI.gd
6. Enlazar body_entered del Area3D del Profesor a Profesor.gd
7. Activar Bake Navigation Mesh en NavigationRegion3D
8. Activar RayCast3D del jugador
9. Agregar LuzParpadeante.gd a luces en el mapa
10. ¡Listo para jugar!