
(define (domain action-castle)
   (:requirements :strips :typing)
   (:types player location direction monster - object fishingpole miscitem food - item)

   (:action go
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location)
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action get
      :parameters (?i - item ?p - player ?l - location)
      :precondition (and (at ?p ?l) (at ?i ?l) (hand-empty ?p))
      :effect (and (not (at ?i ?l)) (holding ?p ?i) (not (hand-empty ?p)) (inventory ?p ?i))
   )

   (:action drop
      :parameters (?i - item ?p - player ?l - location)
      :precondition (and (at ?p ?l) (holding ?p ?i))
      :effect (and (at ?i ?l) (not (holding ?p ?i)) (hand-empty ?p))
   )

   (:action gofish
      :parameters (?pole - fishingpole ?p - player ?l - location ?catch - food)
      :precondition (and (at ?p ?l) (haslake ?l) (holding ?p ?pole) (not (at ?catch ?l)))
      :effect (and (not (holding ?p ?pole)) (at ?pole ?l) (at ?catch ?l) (hand-empty ?p))
   )
)
