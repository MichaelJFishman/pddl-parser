
(define (domain taxi_grid)
;  (:requirements :strips :typing)
  (:requirements :strips :typing :conditional-effects)

  (:types  taxi location person fuel position)


  (:predicates
    (tlocation ?taxi1 - taxi ?x ?y - position)
    (tfull ?taxi1 - taxi)
    (plocation ?person1 - person ?x ?y - position)
    (insidetaxi ?person1 - person ?taxi1 - taxi)
    (outsidetaxi ?person1 - person)
    (eastwall ?x ?y - position)
    (northwall ?x ?y - position)
    (usefuel ?fuel1 - fuel ?fuel2 - fuel)
    (fillupfuel ?fuel1 - fuel)
    (tfuel ?taxi1 - taxi ?fuel1 - fuel)
    (inc ?a ?b - position)
    (dest ?p1 - person ?x ?y - position)
  )

  (:action
   getout
   :parameters (?omf - taxi ?person - person)
   :precondition (and (insidetaxi ?person ?omf)
                      (tfull ?omf)
		      (exists (?x ?y - position)
			      (and (plocation ?person ?x ?y)
				   (dest ?person ?x ?y))))
   :effect (and (not (insidetaxi ?person ?omf))
		(outsidetaxi ?person) (not (tfull ?omf)))
   )

  (:action
   getin
   :parameters (?omf - taxi ?person - person)
   :precondition (and (outsidetaxi ?person)
                      (not (tfull ?omf))
		      (exists (?x ?y - position)
			      (and (plocation ?person ?x ?y)
				   (tlocation ?omf ?x ?y))))
   :effect (and (not (outsidetaxi ?person))
		(insidetaxi ?person ?omf) (tfull ?omf))
   )

   (:action
    north
     :parameters (?omf - taxi)
     :precondition (exists (?currfuel ?nextfuel - fuel)
         (and (tfuel ?omf ?currfuel)
              (usefuel ?currfuel ?nextfuel)))
     :effect (and
        (forall (?x ?y ?yn - position ?person - person)
          (when (and (tlocation ?omf ?x ?y)
         (inc ?yn ?y)
         (not (northwall ?x ?y)))
            (and (not (tlocation ?omf ?x ?y))
           (tlocation ?omf ?x ?yn)
             (when (insidetaxi ?person ?omf)
               (and (not (plocation ?person ?x ?y))
              (plocation ?person ?x ?yn)))
           )
            )
          )
        (forall (?oldfuel ?newfuel - fuel)
          (when (and (tfuel ?omf ?oldfuel)
         (usefuel ?oldfuel ?newfuel))
            (and (not (tfuel ?omf ?oldfuel))
           (tfuel ?omf ?newfuel))
            )
          )
        )
     )

     (:action
       south
       :parameters (?omf - taxi)
       :precondition (exists (?currfuel ?nextfuel - fuel)
           (and (tfuel ?omf ?currfuel)
                (usefuel ?currfuel ?nextfuel)))
       :effect (and
          (forall (?x ?y ?yn - position ?person - person)
            (when (and (tlocation ?omf ?x ?y)
           (inc ?y ?yn)
           (not (northwall ?x ?yn)))
              (and (not (tlocation ?omf ?x ?y))
             (tlocation ?omf ?x ?yn)

               (when (insidetaxi ?person ?omf)
                 (and (not (plocation ?person ?x ?y))
                (plocation ?person ?x ?yn)))

             )
              )
            )
          (forall (?oldfuel ?newfuel - fuel)
            (when (and (tfuel ?omf ?oldfuel)
           (usefuel ?oldfuel ?newfuel))
              (and (not (tfuel ?omf ?oldfuel))
             (tfuel ?omf ?newfuel))
              )
            )
          )
       )

       (:action
         east
         :parameters (?omf - taxi)
         :precondition (exists (?currfuel ?nextfuel - fuel)
             (and (tfuel ?omf ?currfuel)
                  (usefuel ?currfuel ?nextfuel)))
         :effect (and
            (forall (?x ?y ?xn - position ?person - person)
              (when (and (tlocation ?omf ?x ?y)
             (inc ?x ?xn)
             (not (eastwall ?x ?y)))
                (and (not (tlocation ?omf ?x ?y))
               (tlocation ?omf ?xn ?y)
                 (when (insidetaxi ?person ?omf)
                   (and (not (plocation ?person ?x ?y))
                  (plocation ?person ?xn ?y)))
               )
                )
              )
            (forall (?oldfuel ?newfuel - fuel)
              (when (and (tfuel ?omf ?oldfuel)
             (usefuel ?oldfuel ?newfuel))
                (and (not (tfuel ?omf ?oldfuel))
               (tfuel ?omf ?newfuel))
                )
              )
            )
         )

     (:action
       west
       :parameters (?omf - taxi)
       :precondition (exists (?currfuel ?nextfuel - fuel)
           (and (tfuel ?omf ?currfuel)
                (usefuel ?currfuel ?nextfuel)))
       :effect (and
          (forall (?x ?y ?xn - position ?person - person)
            (when (and (tlocation ?omf ?x ?y)
           (inc ?xn ?x)
           (not (eastwall ?xn ?y)))
              (and (not (tlocation ?omf ?x ?y))
             (tlocation ?omf ?xn ?y)
               (when (insidetaxi ?person ?omf)
                 (and (not (plocation ?person ?x ?y))
                (plocation ?person ?xn ?y)))
             )
              )
            )
          (forall (?oldfuel ?newfuel - fuel)
            (when (and (tfuel ?omf ?oldfuel)
           (usefuel ?oldfuel ?newfuel))
              (and (not (tfuel ?omf ?oldfuel))
             (tfuel ?omf ?newfuel))
              )
            )
          )
       )

     (:action
      fillfuel
      :parameters ( ?omf - taxi )
      :precondition ( )
      :effect (and (forall (?oldfuel - fuel)
         (when (tfuel ?omf ?oldfuel)
           (not (tfuel ?omf ?oldfuel))))
       (forall (?fullfuel - fuel)
         (when (fillupfuel ?fullfuel)
           (tfuel ?omf ?fullfuel))))
      )

  )
