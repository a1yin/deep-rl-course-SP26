
(define (domain action-castle)
   (:requirements :strips :typing)
   (:types player location direction monster item)

   (:action go
      :parameters (?dir - direction ?p - player ?l1 - location ?l2 - location)
      :precondition (and (at ?p ?l1) (connected ?l1 ?dir ?l2) (not (blocked ?l1 ?dir ?l2)))
      :effect (and (at ?p ?l2) (not (at ?p ?l1)))
   )

   (:action get
      :parameters (?i - item ?p - player ?l - location)
      :precondition (and (at ?p ?l) (at ?i ?l) (hand-empty ?p))
      :effect (and (not (at ?i ?l)) (holding ?p ?i) (not (hand-empty ?p)))
   )

   (:action drop
      :parameters (?i - item ?p - player ?l - location)
      :precondition (and (at ?p ?l) (holding ?p ?i))
      :effect (and (at ?i ?l) (not (holding ?p ?i)) (hand-empty ?p))
   )
)
