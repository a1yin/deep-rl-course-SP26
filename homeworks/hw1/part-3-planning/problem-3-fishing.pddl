
(define (problem go-fish)
   (:domain action-castle)

   (:objects
      npc - player
      cottage gardenpath fishingpond windingpath talltree drawbridge courtyard towerstairs tower dungeonstairs dungeon greatfeastinghall throneroom - location
      in out north south east west up down - direction
      pole - fishingpole
      rose - miscitem
      fish - food
   )

   (:init
      (connected cottage out gardenpath)
      (connected gardenpath in cottage)
      (connected gardenpath south fishingpond)
      (connected fishingpond north gardenpath)
      (connected gardenpath north windingpath)
      (connected windingpath south gardenpath)
      (connected windingpath up talltree)
      (connected talltree down windingpath)
      (connected windingpath east drawbridge)
      (connected drawbridge west windingpath)
      (connected drawbridge east courtyard)
      (connected courtyard west drawbridge)
      (connected courtyard up towerstairs)
      (connected towerstairs down courtyard)
      (connected towerstairs up tower)
      (connected tower down towerstairs)
      (connected courtyard down dungeonstairs)
      (connected dungeonstairs up courtyard)
      (connected dungeonstairs down dungeon)
      (connected dungeon up dungeonstairs)
      (connected courtyard east greatfeastinghall)
      (connected greatfeastinghall west courtyard)
      (connected greatfeastinghall east throneroom)
      (connected throneroom west greatfeastinghall)
      (haslake fishingpond)
      (at npc cottage)
      (hand-empty npc)
      (at pole cottage)
      (at rose windingpath)
   )

   (:goal (and (inventory npc fish)))
)
