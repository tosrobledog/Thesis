extensions [nw]

globals [
  list_s
  chosen gini avgutil
  totrep totim totsc totdel
  threshold-unsatisfied
  threshold-promoter
  net-size
  sales  ; total sales in the market - 
  network 
  market-sales-tick  ; Just for visualization
  promoters_tick
  promoters_day
  tick_event
  WoM_sales
  WoM_sales_tick
  WoM_promoters
  WoM_market
 ] 
breed [products product]
breed [agents agent] ;; decision makers
products-own [product-number attribute nrticks] ;; each product has a different quality 
agents-own [
  node-id
  share
  preference 
  utility 
  repertoire 
  repertoirelist
  productlist 
  choice-num
  choice 
  normative
  payoff-choice
  prev-payoff 
  prev-product-numb 
  prev-attribute ;; decision-makers variables
  typeofchoice
  uncertainty
  tipo
  diffusion-capacity
  negative-diffusion-capacity
  infected?
  infected-promoter?
  resistant?
  initial-satisfaction-energy
  satisfaction-energy  
  unsatisfaction-energy
  satisfaction
  unsatisfaction
  totalproductssold
  totalowner-product
  new?
  density
  betwenness
  marketsales  ; sum of sales without the intervention of the owner at the end of the simulation
  marketsalesday  ; It's a list []
  totalmarketsales
  list-contacts 
  market_process?
  ]


to setup1
  clear-all
  set WoM_promoters 0
  set WoM_sales_tick []
  set WoM_sales 0
  set promoters_tick []
  set sales 0
  set market-sales-tick 0
  let help 0
  set totrep 0
  set totim 0
  set totsc 0
  set totdel 0
  ask patches [ set pcolor white ]
  set chosen []
  import-products-attributes
  import-agents-attributes
  import-links
  ask agents with [ tipo = 1 ] 
  [
    let dummy-choice-num choice-num
    set choice one-of products with [product-number = dummy-choice-num]
    ]
  set threshold-promoter threshold-promoter1
  set threshold-unsatisfied threshold-unsatisfied1
  reset-ticks
end



to import-products-attributes
  ;clear-all
  file-open "products-attributes.txt"
   while [not file-at-end?]
  [
    ;; this reads a single line into a three-item list
    let items read-from-string (word "[" file-read-line "]")
    create-products 1 [
      set color                         item 0 items
      set heading                       item 1 items
      set xcor                          item 2 items
      set ycor                          item 3 items
      set shape                         item 4 items
      set label                         item 5 items 
      set label-color                   item 6 items
      set hidden?                       item 7 items
      set size                          item 8 items
      set pen-size                      item 9 items
      set pen-mode                      item 10 items
      set product-number                item 11 items
      set attribute                     item 12 items
      set nrticks                       item 13 items
       
    ]
  ]
  file-close
end


to import-agents-attributes
  ;clear-all
  file-open "agents-attributes.txt"
   while [not file-at-end?]
  [
    ;; this reads a single line into a three-item list
    let items read-from-string (word "[" file-read-line "]")
    create-agents 1 [
      set node-id                       item 0 items 
      set color                         item 1 items
      set heading                       item 2 items
      set xcor                          item 3 items
      set ycor                          item 4 items
      set shape                         item 5 items
      set label                         item 6 items
      set label-color                   item 7 items
      set hidden?                       item 8 items
      set size                          item 9 items
      set pen-size                      item 10 items
      set pen-mode                      item 11 items
      set share                         item 12 items
      set preference                    item 13 items
      set utility                       item 14 items
      set repertoire                    item 15 items
      set repertoirelist                item 16 items
      set productlist                   item 17 items
      set choice-num                    item 18 items
      set normative                     item 19 items
      set payoff-choice                 item 20 items
      set prev-payoff                   item 21 items
      set prev-product-numb             item 22 items
      set prev-attribute                item 23 items
      set typeofchoice                  item 24 items
      set uncertainty                   item 25 items
      set tipo                          item 26 items
      set diffusion-capacity            item 27 items
      set negative-diffusion-capacity   item 28 items
      set infected?                     item 29 items
      set infected-promoter?            item 30 items
      set resistant?                    item 31 items
      set initial-satisfaction-energy   item 32 items
      set satisfaction-energy           item 33 items
      set unsatisfaction-energy         item 34 items
      set satisfaction                  item 35 items
      set unsatisfaction                item 36 items
      set totalproductssold             item 37 items
      set totalowner-product            item 38 items
      set new?                          item 39 items
      set density                       item 40 items
      set betwenness                    item 41 items
      set marketsales                   item 42 items
      set marketsalesday                item 43 items
      set totalmarketsales              item 44 items
      set list-contacts                 item 45 items
      set market_process?               item 46 items
     
    ]
  ]
  file-close
end


to import-links
  ;; This opens the file, so we can use it.
  file-open "links.txt"
  ;; Read in all the data in the file
  while [not file-at-end?]
  [
    ;; this reads a single line into a three-item list
    let items read-from-string (word "[" file-read-line "]")
    ask get-node (item 0 items)
    [
      create-link-with get-node (item 1 items)
        
    ]
  ]
  file-close
end

;; Helper procedure for looking up a node by node-id.
to-report get-node [id]
  report one-of agents with [node-id =  id]
end
  
  
  
to setup
  ;if (file-exists? "MarketingNetworking.csv")
   ; [ carefully 
    ;    [file-delete "MarketingNetworking.csv"]
     ;   [print error-message]
    ;]
   
   ;file-open "MarketingNetworking.csv"
   ;file-type "Size,"
   ;file-print "Density,"
   ;file-close
  
   
    
  clear-all
  ;; (for this model to work with NetLogo's new plotting features,
  ;; __clear-all-and-reset-ticks should be replaced with clear-all at
  ;; the beginning of your setup procedure and reset-ticks at the end
  ;; of the procedure.)
  ;__clear-all-and-reset-ticks
  ;let numb 1  I removed it because we generate products in a different way
  
  set WoM_promoters 0
  set WoM_sales_tick []
  set WoM_sales 0
  set promoters_tick []
  set sales 0
  set market-sales-tick 0
  let help 0
  set totrep 0
  set totim 0
  set totsc 0
  set totdel 0
  ask patches [ set pcolor white ]
  generate-products
  setup-nodes
  setup-spatially-clustered-network
  let teller 0
  ask agents with [ tipo = 1 ] ;; 100 decision makers
  [
    set teller 0
    ifelse heterobeta [set normative random-float 1][set normative beta]
    set repertoire []
    set prev-product-numb 1 + random ( nrinitproducts - 1 )  ; Now the customers have 9 products
    set choice-num prev-product-numb
    let dummy-choice-num choice-num
    set choice one-of products with [product-number = dummy-choice-num]
    set utility []
    set productlist []
    set share []
    while [teller < nrproducts] 
    [  
      set repertoire lput 0 repertoire
      set repertoirelist []
      set repertoirelist lput (choice-num - 1) repertoirelist
      set share lput 1 share
      set utility lput 0 utility
      set productlist lput (teller + 1) productlist
      set teller teller + 1]
 
  ]
  set chosen []
  if fullknowledge [
    ask agents with [tipo = 1][
      set teller 0
      while [teller < nrproducts]
      [
        if count link-neighbors > 0 [set share replace-item teller share ((count link-neighbors with [(teller + 1) = choice-num])/ count link-neighbors)]
        
        set help (1 - abs (preference - [attribute] of turtle teller)) * normative + (1 - normative) * item teller share 
        set repertoire replace-item teller repertoire help
        set repertoirelist lput teller repertoirelist
        set teller teller + 1
      ]
    ]
  ]
  set threshold-unsatisfied threshold-unsatisfied1
  set threshold-promoter threshold-promoter1
 reset-ticks 
 
 export-links
 export-products-attributes
 export-agents-attributes
  
 end


to export-links
  if file-exists? "links.txt"
      [ file-delete "links.txt" ]
  file-open "links.txt" 
  ;file-print (word "*Vertices " (max [who] of turtles + 1) "\r") 
  ;file-print "*Edges\r" 
  foreach (sort links) [ 
    ask ? [ 
      file-write [who] of end1 
      file-write [who] of end2 
      file-print "\r"] 
    ] 
 file-close
end


to export-products-attributes
  if file-exists? "products-attributes.txt"
      [ file-delete "products-attributes.txt" ]
  file-open "products-attributes.txt"
  foreach (sort products) [ 
    ask ? [ 
      ;file-write who
      file-write color
      file-write heading
      file-write xcor
      file-write ycor
      file-write shape
      file-write label
      file-write label-color
      ;file-write breed
      file-write hidden?
      file-write size
      file-write pen-size
      file-write pen-mode
      file-write product-number
      file-write attribute
      file-write nrticks
      file-print "\r"
      ] 
    ] 
  
  file-close
end


to export-agents-attributes
  if file-exists? "agents-attributes.txt"
      [ file-delete "agents-attributes.txt" ]
  file-open "agents-attributes.txt"
  foreach (sort agents) [ 
    ask ? [ 
      file-write who
      file-write color
      file-write heading
      file-write xcor
      file-write ycor
      file-write shape
      file-write label
      file-write label-color
      ;file-write breed
      file-write hidden?
      file-write size
      file-write pen-size
      file-write pen-mode
      file-write share
      file-write preference
      file-write utility
      file-write repertoire
      file-write repertoirelist
      file-write productlist
      file-write choice-num
      ;file-write choice
      file-write normative
      file-write payoff-choice
      file-write prev-payoff
      file-write prev-product-numb
      file-write prev-attribute
      file-write typeofchoice
      file-write uncertainty
      file-write tipo
      file-write diffusion-capacity
      file-write negative-diffusion-capacity
      file-write infected?
      file-write infected-promoter?
      file-write resistant?
      file-write initial-satisfaction-energy
      file-write satisfaction-energy
      file-write unsatisfaction-energy
      file-write satisfaction
      file-write unsatisfaction
      file-write totalproductssold
      file-write totalowner-product
      file-write new?
      file-write density
      file-write betwenness
      file-write marketsales
      file-write marketsalesday
      file-write totalmarketsales
      file-write list-contacts
      file-write market_process?
      file-print "\r"
      ] 
    ] 
  
 file-close
end


to generate-products
  crt nrproducts
  [   
    set breed products 
    set hidden? true
    set product-number who + 1
    set attribute random-float 1             ;random-normal 0.5 0.5
    setxy 0 0
    set nrticks 0
   ]
end
  
 
to setup-nodes
  crt market
  [
    set breed agents
    set preference   random-float 1  ; random-float 1 It a normal distribution to control the market parameters because we don't need it 
    setxy random-xcor random-ycor
    set size 0.06
    set shape "dot"
    set tipo 1  ; market
    set infected? false
    set infected-promoter? false
    set resistant? false
    set satisfaction ( 1 - abs (preference -[attribute] of product (owner-product - 1))) ; the products turtles begin in 0 we need to check this after
    ;set initial-satisfaction-energy 1000
    set initial-satisfaction-energy (satisfaction) * satisfaction-force * 10
    set satisfaction-energy (satisfaction) * satisfaction-force * 10   ; ??  if satisfaction equal to 1 energy become 0?
    set diffusion-capacity ( satisfaction) * satisfaction-force * 100
    set new? false
    set unsatisfaction 1 - satisfaction
    set unsatisfaction-energy unsatisfaction * unsatisfaction-force * 10
    set negative-diffusion-capacity unsatisfaction * unsatisfaction-force * 100
    set market_process?  false
     
       became-susceptible
  ]
  crt nrowners 
  [
    set breed agents 
    set preference random-float 1
    setxy random-xcor random-ycor
    set size 0.06
    set shape "person"
    set tipo 2
    set choice-num owner-product
    set diffusion-capacity  100  ;; random-float
    set satisfaction-energy 1000
    set satisfaction 1
    became-promoter
    set color red
    set new? false
    set marketsales 0  ; sum of sales without the intervention of the owner at the end of the simulation
    set marketsalesday []  ; It's a list []
    set totalmarketsales 0
    set market_process? false
    
  ]
end

to setup-spatially-clustered-network
  let num-links (average-node-degree * (market + nrowners)) / 2
  while [ count links < num-links ]
  [
    ask one-of agents
    [
      ask other agents with [not link-neighbor? myself]
      [
        if random-float 1 < ( average-node-degree / ( 2 * pi * D ^ 2 ) ) * e ^ ( -1 * market * (distance myself) ^ 2 / (2 * D ^ 2) ) 
        [
          create-link-with myself
        ]
      ]
    ]
  ]
end

to step
   
  ask agents with [(choice-num = owner-product) and (satisfaction > 0.7 ) and (satisfaction-energy >= 1 ) and (resistant? = false)] [ 
    let promoter-cap diffusion-capacity
    let rand-numb random-float 100
    ask link-neighbors  with [ (choice-num != owner-product) and (resistant? = false)] [ 
      ;file-type ( word diffusion-capacity "," ) 
       if rand-numb  < promoter-cap [
         set choice-num owner-product
         if (( satisfaction > nrunsatisfied  ) and ( satisfaction < nrpromoter )) [set color blue set satisfaction-energy 0 set new? true ] ; customer average satisfaction
         if (satisfaction >= nrpromoter) [set color red]   ; promoter high satisfaction
         if ( satisfaction <= nrunsatisfied) [set color black set resistant?  true]] ; unsatisfied
    ]
    file-type (word rand-numb "," promoter-cap ","  )
    file-print promoter-cap
  ]
  
  ;file-print diffusion-capacity
  ;if ticks >= 1 [ file-close  stop  ]
  tick
  ;if ticks >= 1   [    file-close    stop  ]
  
       
end


to go
  ;lose-energy  ; make agents susceptible because energy = 0
  ;insatisfaction ; make agents infected resistant 
  ;became-susceptible-from-infected ; Convierte a los customers susceptibles
  run strategies
  if diffusion-process? [  ; This is a special diffusion-process because is just for the customers with high satisfaction
    ask agents with [ (tipo = 1 ) and (choice-num = owner-product) and (satisfaction > threshold-promoter ) and (satisfaction-energy >= 1 ) and (resistant? = false) and (new? = false)]
     [    ; ask promoters I think we don't need resistant
    ;file-type ( word who "," )
    diffusion-process 
    set satisfaction-energy satisfaction-energy - 1   ; this was a good idea
    ;set satisfaction-energy satisfaction-energy + count link-neighbors with [ new? = true ]
   
    if satisfaction-energy < 1 [ set color pink]
    
    ;set WoM_sales WoM_sales + count agents with [ (choice-num = owner-product) and (new? = true) and (tipo != 2) ]  ;; En qué parte exactamente debe ponerse? No podría ser en "go"??
    set WoM_promoters count agents with [ (choice-num = owner-product) and (new? = true) and (tipo != 2) ]
    ]
      
  ]
  
    
  if negative-process? [
    ask agents with [(choice-num != owner-product) and ( satisfaction < threshold-unsatisfied ) and (unsatisfaction-energy >= 1 ) and ( resistant? = true) and ( new? = false)]
     [  ; ask unsatisfied promoters. Check resistant? do we need it?
      negative-diffusion-process
      set unsatisfaction-energy unsatisfaction-energy - 1 
    ] 
    
  ]
  
  if market-process? [
    market-process ;; agents make decisions  we need to separate the last procedure
    set WoM_market count agents with [ (market_process? = true) and (choice-num = owner-product) and (tipo != 2) ]  ;; new? true -- se quitó para que la gráfica de WoM - Market Process se ajustara a la de T.M.S.
  ]
  
  
  set WoM_sales WoM_promoters + WoM_market
  
  ;lose-energy
  
  ask agents with [ tipo = 1] [   ; susceptibles that not be resistance
    set prev-product-numb choice-num
    set prev-payoff payoff-choice ;;save it for social learner next round
    set prev-attribute [attribute] of choice
    ;set color 7 + choice-num * 10
  ] 
  ask agents with [tipo = 1]  [  ; susceptibles that not be resistance
    if random-float 1 < advertisement2 [if not member? 1 repertoirelist [set repertoirelist lput 1 repertoirelist]]  ;  ?
    ]
  do-plot ;; plot numbers of majority and minority
  calgini
  let teller 0
  set chosen []
  ;ask agents with [(tipo = 1) and (infected? = true)]
   ;[ set infected?  false ]
  ask agents with [ tipo = 2 ] [
    set totalproductssold count (link-neighbors with [choice-num = owner-product ])
    set totalowner-product count (agents with [(tipo = 1) and  (choice-num = owner-product)])
  ]
  ask agents with [ tipo = 2 ] [
    let newsales count (agents with [(tipo = 1 ) and (choice-num = owner-product)] ) ; Do I need it.... We doesn't say anything to owner do
    set sales sales + newsales ; this is all the sales ego and market
  ]
  ;let market-sales0 count ( agents with [ (tipo = 1)  and ( choice-num = owner-product)    ] )
  ask agents with [ tipo = 2 ] [
      set market-sales-tick  count ( agents  with [( not link-neighbor? myself ) and (tipo != 2) and (choice-num = owner-product) and (resistant? = false ) ] ) 
      ;output-print market-sales-tick
      set marketsalesday lput market-sales-tick marketsalesday
      set totalmarketsales market-sales-tick + totalmarketsales
      ] 
  
  ask agents with [ tipo = 2 ] [
      set marketsales  count ( agents  with [( not link-neighbor? myself ) and (tipo != 2) and (choice-num = owner-product) and (resistant? = false )  ] ) 
  ]
  ask agents with [ tipo = 1 ]  [  set new? false set market_process? false]        ; all agents became new? = false so all agents are old
  set promoters_day count agents with [ (tipo = 1 ) and (choice-num = owner-product) and (satisfaction >= threshold-promoter ) and (satisfaction-energy >= 1) and (resistant? = false) ]
  set promoters_tick lput (count agents with [ (tipo = 1 ) and (choice-num = owner-product) and (satisfaction >= threshold-promoter ) and (satisfaction-energy >= 1) and (resistant? = false) ]) promoters_tick 
  tick
  
      
  ;file-open "MarketingNetworking.csv"
  ;ask agents with [ tipo = 2 ] [
    ;set net-size count link-neighbors
    ;let sales count agents with [ (tipo = 1 ) and (choice-num = owner-product)
    ;let egonetwork 1
    ;file-type (word net-size  ",")
    ;file-print choice-num
  ;]
  ;file-close
  
  ;nw:set-context (agents with [ tipo = 2 ] ) links  
  nw:set-context agents links
  
  ;nw:save-graphml "marketingnetworking.graphml"  
  set network nw:get-context
  

  ;set WoM_sales_tick lput Wom_sales WoM_sales_tick

  ;set WoM_sales WoM_promoters
  
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; STRATEGIES ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BROKERAGE-GROW-SIZE-ENERGIZE-PROMOTERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to brokerage-grow-size-energize-promoters ; we need to be careful because the owner can not spread to all his contacts the product
  ask agents [ set list-contacts link-neighbors with [tipo = 1]];;entrega la lista de referidos y no incluye al  microempresario
  ;;;;;; NORMAL PROMOTION ;;;;;;
  ask agents with [ (tipo = 2 ) and (choice-num = owner-product) and (satisfaction > threshold-promoter ) and (satisfaction-energy >= 1 ) and (resistant? = false)] [  ; owner maybe we can no ask all this, just owner
    let promoter-cap diffusion-capacity
    let rand-numb random-float 100
    let contacts-owner link-neighbors with [(choice-num != owner-product) and (resistant? = false)]
     ifelse (( count contacts-owner ) < max-contacts-day ) 
      [ask link-neighbors  with [(choice-num != owner-product) and (resistant? = false)]  ; all potential customers -> susceptible agents
         [ ;file-type ( word diffusion-capacity "," ) 
           if rand-numb < promoter-cap ; maybe is asking for the diffusion-capacity of his neighbors
            [set choice-num owner-product
             if (( satisfaction > threshold-unsatisfied  ) and ( satisfaction < threshold-promoter )) [set color blue set satisfaction-energy 0 set new? true ] ; customer average satisfaction
             if (satisfaction >= threshold-promoter) and (satisfaction-energy >= 1) [set color red set new? true]   ; promoter high satisfaction
             if (satisfaction >= threshold-promoter) and (satisfaction-energy < 1) [set color pink set new? true]
             if ( satisfaction <= threshold-unsatisfied) [set color black set resistant?  true set choice-num 1 + random 9 set new? true] ; Unsatisfied customer low satisfaction
       ]
     ]
     ]
      ;;;;;    ?????????   ;;;;;;;;
      [ask n-of max-contacts-day link-neighbors  with [(choice-num != owner-product) and (resistant? = false)]  ; all potential customers -> susceptible agents
         [ ;file-type ( word diffusion-capacity "," ) 
           if rand-numb < promoter-cap ; maybe is asking for the diffusion-capacity of his neighbors
            [set choice-num owner-product
              if (( satisfaction > threshold-unsatisfied  ) and ( satisfaction < threshold-promoter )) [set color blue set satisfaction-energy 0 set new? true ] ; customer average satisfaction
              if (satisfaction >= threshold-promoter) and (satisfaction-energy >= 1) [set color red set new? true]   ; promoter high satisfaction
              if (satisfaction >= threshold-promoter) and (satisfaction-energy < 1) [set color pink set new? true]
              if ( satisfaction <= threshold-unsatisfied) [set color black set resistant?  true set choice-num 1 + random 9 ] ; Unsatisfied customer low satisfaction
       ]
     ]
    ]
   ]
 ask agents with [ tipo = 2 ] [ ;; selecciona al microempresario
    let contact3 agents with [tipo = 2 ];; guarda al microempresario
    let promoter-cap ( diffusion-capacity / 2 );;capacidad de promocionar que tiene el agente puede ser alta o baja
    let owner-contacts link-neighbors ;; guarda los vecinos del microempresario
    let contact1 one-of owner-contacts  ; We can write here  with [(choice-num = owner-product) and (resistant? = false)];;escoge uno de los vecinos del microempresario al azar
    ask contact1 [ ;;selecciona al amigo del microempresario seleccionado al azar
      let contact1-contacts ( link-neighbors with [ tipo != 2 ] );;guarda los contactos (referidos) del agente seleccionado al azar diferentes al microempresario
     
      let union (turtle-set owner-contacts contact1-contacts ); une la lista de los amigos del empresario con la lista de los referidos
            let substract contact1-contacts with [not member? self owner-contacts]; entrega los referidos del agente seleccionado al azar que no son miembros de los contactos del microempresaio
     
       if  any? substract [
      let contact2-max-grado max-one-of substract [count link-neighbors with [tipo = 1]]  ;;guarda el vecino con mas grado
      show  contact2-max-grado;;let contact2 one-of contact1-contacts;; aleatoria ;;guarda un contacto de la lista de los vecinos del agente seleccionado al azar diferente al micorempresario
               ask contact2-max-grado [;; selecciona el contacto guardado
        if random-float 100 < promoter-cap [   ; ojo the capacity is high ;; comienza a promocionar el producto
          set choice-num owner-product;; escoge uno d elos productos 
          if (( satisfaction > threshold-unsatisfied  ) and ( satisfaction < threshold-promoter )) [set color blue set satisfaction-energy 0 set new? true ] ; customer average satisfaction
          if (satisfaction >= threshold-promoter) and (satisfaction-energy >= 1) [set color red set new? true]   ; promoter high satisfaction
          if (satisfaction >= threshold-promoter) and (satisfaction-energy < 1) [set color pink set new? true]
          if ( satisfaction <= threshold-unsatisfied) [set color black set resistant?  true set choice-num 1 + random 9 ] ; Unsatisfied customer low satisfaction
          ;;en las instrucciones anteriores define a que tipo del SIR pertenece el contacto
          create-link-with one-of contact3;; relaciona el contacto con el microempresario
      ]
     ]
    ]
  ]
 ]
 
 bgs-energize-promoters
 
end

to bgs-energize-promoters
  if diffusion-process? [  ; This is a special diffusion-process because is just for the customers with high satisfaction
    ask agents with [ (tipo = 1 ) and (choice-num = owner-product) and (satisfaction > threshold-promoter ) and (satisfaction-energy >= 1 ) and (resistant? = false) and (new? = false)]
     [    
    diffusion-process 
    set satisfaction-energy satisfaction-energy - 1   
    set satisfaction-energy satisfaction-energy + count link-neighbors with [new? = true ]
     ] 
  ]
end   


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BROKERAGE-GROW-SIZE-CONNECT-PROMOTERS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to brokerage-grow-size-connect-promoters ; we need to be careful because the owner can not spread to all his contacts the product
  ask agents [ set list-contacts link-neighbors with [tipo = 1]];;entrega la lista de referidos y no incluye al  microempresario
  ;;;;;; NORMAL PROMOTION ;;;;;;
  ask agents with [ (tipo = 2 ) and (choice-num = owner-product) and (satisfaction > threshold-promoter ) and (satisfaction-energy >= 1 ) and (resistant? = false)] [  ; owner maybe we can no ask all this, just owner
    let promoter-cap diffusion-capacity
    let rand-numb random-float 100
    let contacts-owner link-neighbors with [(choice-num != owner-product) and (resistant? = false)]
     ifelse (( count contacts-owner ) < max-contacts-day ) 
      [ask link-neighbors  with [(choice-num != owner-product) and (resistant? = false)]  ; all potential customers -> susceptible agents
         [ ;file-type ( word diffusion-capacity "," ) 
           if rand-numb < promoter-cap ; maybe is asking for the diffusion-capacity of his neighbors
            [set choice-num owner-product
             if (( satisfaction > threshold-unsatisfied  ) and ( satisfaction < threshold-promoter )) [set color blue set satisfaction-energy 0 set new? true ] ; customer average satisfaction
             if (satisfaction >= threshold-promoter) and (satisfaction-energy >= 1) [set color red set new? true]   ; promoter high satisfaction
             if (satisfaction >= threshold-promoter) and (satisfaction-energy < 1) [set color pink set new? true]
             if ( satisfaction <= threshold-unsatisfied) [set color black set resistant?  true set choice-num 1 + random 9 set new? true] ; Unsatisfied customer low satisfaction
       ]
     ]
     ]
      ;;;;;    ?????????   ;;;;;;;;
      [ask n-of max-contacts-day link-neighbors  with [(choice-num != owner-product) and (resistant? = false)]  ; all potential customers -> susceptible agents
         [ ;file-type ( word diffusion-capacity "," ) 
           if rand-numb < promoter-cap ; maybe is asking for the diffusion-capacity of his neighbors
            [set choice-num owner-product
              if (( satisfaction > threshold-unsatisfied  ) and ( satisfaction < threshold-promoter )) [set color blue set satisfaction-energy 0 set new? true ] ; customer average satisfaction
              if (satisfaction >= threshold-promoter) and (satisfaction-energy >= 1) [set color red set new? true]   ; promoter high satisfaction
              if (satisfaction >= threshold-promoter) and (satisfaction-energy < 1) [set color pink set new? true]
              if ( satisfaction <= threshold-unsatisfied) [set color black set resistant?  true set choice-num 1 + random 9 ] ; Unsatisfied customer low satisfaction
       ]
     ]
    ]
   ]
 ask agents with [ tipo = 2 ] [ ;; selecciona al microempresario
    let contact3 agents with [tipo = 2 ];; guarda al microempresario
    let promoter-cap ( diffusion-capacity / 2 );;capacidad de promocionar que tiene el agente puede ser alta o baja
    let owner-contacts link-neighbors ;; guarda los vecinos del microempresario
    let contact1 one-of owner-contacts  ; We can write here  with [(choice-num = owner-product) and (resistant? = false)];;escoge uno de los vecinos del microempresario al azar
    ask contact1 [ ;;selecciona al amigo del microempresario seleccionado al azar
      let contact1-contacts ( link-neighbors with [ tipo != 2 ] );;guarda los contactos (referidos) del agente seleccionado al azar diferentes al microempresario
     
      let union (turtle-set owner-contacts contact1-contacts ); une la lista de los amigos del empresario con la lista de los referidos
            let substract contact1-contacts with [not member? self owner-contacts]; entrega los referidos del agente seleccionado al azar que no son miembros de los contactos del microempresaio
     
       if  any? substract [
      let contact2-max-grado max-one-of substract [count link-neighbors with [tipo = 1]]  ;;guarda el vecino con mas grado
      show  contact2-max-grado;;let contact2 one-of contact1-contacts;; aleatoria ;;guarda un contacto de la lista de los vecinos del agente seleccionado al azar diferente al micorempresario
               ask contact2-max-grado [;; selecciona el contacto guardado
        if random-float 100 < promoter-cap [   ; ojo the capacity is high ;; comienza a promocionar el producto
          set choice-num owner-product;; escoge uno d elos productos 
          if (( satisfaction > threshold-unsatisfied  ) and ( satisfaction < threshold-promoter )) [set color blue set satisfaction-energy 0 set new? true ] ; customer average satisfaction
          if (satisfaction >= threshold-promoter) and (satisfaction-energy >= 1) [set color red set new? true]   ; promoter high satisfaction
          if (satisfaction >= threshold-promoter) and (satisfaction-energy < 1) [set color pink set new? true]
          if ( satisfaction <= threshold-unsatisfied) [set color black set resistant?  true set choice-num 1 + random 9 ] ; Unsatisfied customer low satisfaction
          ;;en las instrucciones anteriores define a que tipo del SIR pertenece el contacto
          create-link-with one-of contact3;; relaciona el contacto con el microempresario
      ]
     ]
    ]
  ]
 ]
 
 connect-and-energize-promoters
 
end

to connect-promoters
  if ticks = 250 [
  ask agents with [ tipo = 2 ] [ ;; selecciona al microempresario
   create-links-with agents with [ (tipo = 1 ) and (choice-num = owner-product) and (satisfaction >= threshold-promoter ) and (resistant? = false) ] ; red and pink ones
   [set color red]
   ;create-links-with agents with [ repertoirelist = 10 ]
  ]

  ask agents with [ (tipo = 1 ) and (choice-num = owner-product) and (satisfaction >= threshold-promoter ) and (resistant? = false) ][       ; red and pink ones
   create-links-with other agents with [ (tipo = 1 ) and (choice-num = owner-product) and (satisfaction >= threshold-promoter ) and (resistant? = false) ]
   [set color red]
   ;create-links-with agents with [ repertoirelist = 10 ]
  ]
  ]
end


to connect-and-energize-promoters
  if ticks = event [
  ask agents with [ tipo = 2 ] [ ;; selecciona al microempresario 
   create-links-with agents with [ (tipo = 1 ) and (choice-num = owner-product) and (satisfaction >= threshold-promoter ) and (resistant? = false) ]
   [set color red]
   create-links-with agents with [ (tipo = 1 ) and (member? (owner-product - 1) repertoirelist) and (satisfaction >= threshold-promoter ) and (resistant? = false) ]
   [set color black] 
     
   
  
  ask agents with [ (tipo = 1 ) and (choice-num = owner-product) and (satisfaction >= threshold-promoter ) and (resistant? = false) ][
    create-links-with other agents with [ (tipo = 1 ) and (choice-num = owner-product) and (satisfaction >= threshold-promoter ) and (resistant? = false) ]
    [set color pink]
    create-links-with other agents with [ (tipo = 1 ) and (member? (owner-product - 1) repertoirelist) and (satisfaction >= threshold-promoter ) and (resistant? = false) ]
    [set color black] 
    
    if (satisfaction-energy < initial-satisfaction-energy) [
    set satisfaction-energy initial-satisfaction-energy
    if (satisfaction >= threshold-promoter) and (satisfaction-energy >= 1) [set color red]
    ]
    ]
    ]
   ]

   
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BROKERAGE-GROW-SIZE-CP-EP-MIX ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to brokerage-grow-size-cp-ep-mix ; we need to be careful because the owner can not spread to all his contacts the product
  ask agents [ set list-contacts link-neighbors with [tipo = 1]];;entrega la lista de referidos y no incluye al  microempresario
  ;;;;;; NORMAL PROMOTION ;;;;;;
  ask agents with [ (tipo = 2 ) and (choice-num = owner-product) and (satisfaction > threshold-promoter ) and (satisfaction-energy >= 1 ) and (resistant? = false)] [  ; owner maybe we can no ask all this, just owner
    let promoter-cap diffusion-capacity
    let rand-numb random-float 100
    let contacts-owner link-neighbors with [(choice-num != owner-product) and (resistant? = false)]
     ifelse (( count contacts-owner ) < max-contacts-day ) 
      [ask link-neighbors  with [(choice-num != owner-product) and (resistant? = false)]  ; all potential customers -> susceptible agents
         [ ;file-type ( word diffusion-capacity "," ) 
           if rand-numb < promoter-cap ; maybe is asking for the diffusion-capacity of his neighbors
            [set choice-num owner-product
             if (( satisfaction > threshold-unsatisfied  ) and ( satisfaction < threshold-promoter )) [set color blue set satisfaction-energy 0 set new? true ] ; customer average satisfaction
             if (satisfaction >= threshold-promoter) and (satisfaction-energy >= 1) [set color red set new? true]   ; promoter high satisfaction
             if (satisfaction >= threshold-promoter) and (satisfaction-energy < 1) [set color pink set new? true]
             if ( satisfaction <= threshold-unsatisfied) [set color black set resistant?  true set choice-num 1 + random 9 set new? true] ; Unsatisfied customer low satisfaction
       ]
     ]
     ]
      ;;;;;    ?????????   ;;;;;;;;
      [ask n-of max-contacts-day link-neighbors  with [(choice-num != owner-product) and (resistant? = false)]  ; all potential customers -> susceptible agents
         [ ;file-type ( word diffusion-capacity "," ) 
           if rand-numb < promoter-cap ; maybe is asking for the diffusion-capacity of his neighbors
            [set choice-num owner-product
              if (( satisfaction > threshold-unsatisfied  ) and ( satisfaction < threshold-promoter )) [set color blue set satisfaction-energy 0 set new? true ] ; customer average satisfaction
              if (satisfaction >= threshold-promoter) and (satisfaction-energy >= 1) [set color red set new? true]   ; promoter high satisfaction
              if (satisfaction >= threshold-promoter) and (satisfaction-energy < 1) [set color pink set new? true]
              if ( satisfaction <= threshold-unsatisfied) [set color black set resistant?  true set choice-num 1 + random 9 ] ; Unsatisfied customer low satisfaction
       ]
     ]
    ]
   ]
 ask agents with [ tipo = 2 ] [ ;; selecciona al microempresario
    let contact3 agents with [tipo = 2 ];; guarda al microempresario
    let promoter-cap ( diffusion-capacity / 2 );;capacidad de promocionar que tiene el agente puede ser alta o baja
    let owner-contacts link-neighbors ;; guarda los vecinos del microempresario
    let contact1 one-of owner-contacts  ; We can write here  with [(choice-num = owner-product) and (resistant? = false)];;escoge uno de los vecinos del microempresario al azar
    ask contact1 [ ;;selecciona al amigo del microempresario seleccionado al azar
      let contact1-contacts ( link-neighbors with [ tipo != 2 ] );;guarda los contactos (referidos) del agente seleccionado al azar diferentes al microempresario
     
      let union (turtle-set owner-contacts contact1-contacts ); une la lista de los amigos del empresario con la lista de los referidos
            let substract contact1-contacts with [not member? self owner-contacts]; entrega los referidos del agente seleccionado al azar que no son miembros de los contactos del microempresaio
     
       if  any? substract [
      let contact2-max-grado max-one-of substract [count link-neighbors with [tipo = 1]]  ;;guarda el vecino con mas grado
      show  contact2-max-grado;;let contact2 one-of contact1-contacts;; aleatoria ;;guarda un contacto de la lista de los vecinos del agente seleccionado al azar diferente al micorempresario
               ask contact2-max-grado [;; selecciona el contacto guardado
        if random-float 100 < promoter-cap [   ; ojo the capacity is high ;; comienza a promocionar el producto
          set choice-num owner-product;; escoge uno d elos productos 
          if (( satisfaction > threshold-unsatisfied  ) and ( satisfaction < threshold-promoter )) [set color blue set satisfaction-energy 0 set new? true ] ; customer average satisfaction
          if (satisfaction >= threshold-promoter) and (satisfaction-energy >= 1) [set color red set new? true]   ; promoter high satisfaction
          if (satisfaction >= threshold-promoter) and (satisfaction-energy < 1) [set color pink set new? true]
          if ( satisfaction <= threshold-unsatisfied) [set color black set resistant?  true set choice-num 1 + random 9 ] ; Unsatisfied customer low satisfaction
          ;;en las instrucciones anteriores define a que tipo del SIR pertenece el contacto
          create-link-with one-of contact3;; relaciona el contacto con el microempresario
      ]
     ]
    ]
  ]
 ]
 
 connect-promoters
 connect-and-energize-promoters
 bgs-energize-promoters
 
end





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;; PROCESSES  ;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; DIFFUSION-PROCESS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to diffusion-process
  
  let promoter-cap diffusion-capacity
  let rand-numb random-float 100
  
  ask link-neighbors  with [(choice-num != owner-product) and (resistant? = false) and (new? = false) ]  ; all potential customers -> susceptible agents
    [ ;file-type ( word diffusion-capacity "," ) 
      if rand-numb < promoter-cap ; maybe is asking for the diffusion-capacity of his neighbors
      [
       set choice-num owner-product
       if (( satisfaction > threshold-unsatisfied  ) and ( satisfaction < threshold-promoter )) [set color blue set satisfaction-energy 0 set new? true ] ; customer average satisfaction
       if (satisfaction >= threshold-promoter ) [set color red set new? true]   ; promoter high satisfaction
       if ( satisfaction <= threshold-unsatisfied) [set color black set resistant?  true set choice-num 1 + random 9 set new? true] ; Unsatisfied customer low satisfaction
       if not member? (choice-num - 1) repertoirelist [set repertoirelist lput (choice-num - 1) repertoirelist]
            
    ]
   
   ;set WoM_sales WoM_sales + count agents with [ (choice-num = owner-product) and (new? = true) and (tipo != 2) ]  
   
    ]
   
   ;set WoM_sales WoM_sales + count agents with [ (choice-num = owner-product) and (new? = true) and (tipo != 2) ]  ;; En qué parte exactamente debe ponerse? No podría ser en "go"??
   ;set WoM_promoters WoM_promoters + count agents with [ (choice-num = owner-product) and (new? = true) and (tipo != 2) ]
    
end



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; NEGATIVE-DIFFUSION-PROCESS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to negative-diffusion-process
  
  let promoter-cap negative-diffusion-capacity
  let rand-numb random-float 100
  ask link-neighbors  with [ 
     ((choice-num = owner-product) and (satisfaction > threshold-unsatisfied and satisfaction < threshold-promoter ) and (resistant?  = false) and ( new? = false) ) or  ; Customer A old 
     ((choice-num = owner-product) and (satisfaction > threshold-promoter) and (satisfaction-energy < 0 ) and (resistant? = false))]  ; Customer B 
    [ ;file-type ( word negative-diffusion-capacity "," ) 
      if rand-numb < promoter-cap ; maybe is asking for the negative-diffusion-capacity of his neighbors
      [set choice-num 1 + random 9  ; it would be good if the agents could return to the last product bougth
       if (( satisfaction > threshold-unsatisfied  ) and ( satisfaction < threshold-promoter )) [set color blue set satisfaction-energy 0 set new? true ] ; customer average satisfaction
       if (satisfaction >= threshold-promoter) [set color red set new? true]   ; promoter high satisfaction
       if ( satisfaction <= threshold-unsatisfied) [set color black set resistant?  true set new? true] ; Unsatisfied customer low satisfaction
    ]
    ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; MARKET-PROCESS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to market-process ;; strategy should be written here
  
      
   ask agents  with [
     ((choice-num != owner-product) and (resistant? = false ) and (tipo != 2)) or ; potential customers. We have to be careful because this agents are making decisions two times in one tick
     ((choice-num = owner-product) and (satisfaction > threshold-unsatisfied and satisfaction < threshold-promoter ) and (resistant?  = false) and (new? = false) and (tipo != 2) ) or  ; Customer A old 
     ((choice-num = owner-product) and (satisfaction > threshold-promoter) and (satisfaction-energy < 1) and (resistant? = false) and (new? = false) and (tipo != 2) )  ; Old Promoters with Energy < 1
     ] 
     [
      let teller 0
      while [teller < nrproducts]
      [
        if member? teller repertoirelist [
          if count link-neighbors > 0 [set share replace-item teller share ((count link-neighbors with [(teller + 1) = choice-num])/ count link-neighbors)]
          let help (1 - abs (preference - [attribute] of turtle teller)) * normative + (1 - normative) * item teller share 
          set repertoire replace-item teller repertoire help
        ]
        set teller teller + 1
      ]
    ]
  
  ask agents with [
     ((choice-num != owner-product) and (resistant? = false ) and (tipo != 2)) or ; potential customers
     ((choice-num = owner-product) and (satisfaction > threshold-unsatisfied and satisfaction < threshold-promoter ) and (resistant?  = false)  and (new? = false) and (tipo != 2) ) or  ; Customer A
     ((choice-num = owner-product) and (satisfaction > threshold-promoter) and (satisfaction-energy < 0) and (resistant? = false) and (new? = false) and (tipo != 2))  ; Old Promoters with Energy < 1
      ] 
  [
    set utility replace-item (choice-num - 1) utility ((1 - abs (preference - [attribute] of choice)) * normative + (1 - normative) * item (choice-num - 1) share) ;; get the quality of the product]
    set uncertainty (1 - normative) * (1 - item (choice-num - 1) share)  ; Get the uncertainty of the product
  ]
  
  ask agents with [
     ((choice-num != owner-product) and (resistant? = false ) and (tipo != 2)) or ; potential customers
     ((choice-num = owner-product) and (satisfaction > threshold-unsatisfied and satisfaction < threshold-promoter ) and (resistant?  = false) and ( new? = false) and (tipo != 2) ) or  ; Customer A
     ((choice-num = owner-product) and (satisfaction > threshold-promoter) and (satisfaction-energy < 0) and (resistant? = false) and (new? = false) and (tipo != 2))  ; Old Promoters with Energy < 1
     ] 
  [
    ifelse random-float 1 < probbuying [
      ifelse sum repertoire != 0 [
        ifelse item (choice-num - 1) utility >= utilitymin [
          ifelse uncertainty >= uncertaintymax [imitation set typeofchoice 1][repetition set typeofchoice 2]
        ][
          ifelse uncertainty >= uncertaintymax [socialcomparison set typeofchoice 3][deliberation set typeofchoice 4]
        ]
      ]
      [innovate] ; it's a function below  
     ][
     set chosen lput (choice-num - 1) chosen
     set typeofchoice 5
     ] 
      ; It is just for visualization. Became Potential-Customers, customers A, customer B, promoters, unsatisfied-customers ( just the color) 
     if  (( choice-num != owner-product ) and (resistant? = false)) [set color green] ; market-process becames Potential-Customers
     if  (( choice-num = owner-product ) and (satisfaction >= threshold-promoter) and (satisfaction-energy >= 1)) [set color red]   ; market-process becames promoter high satisfaction
     if  (( choice-num = owner-product ) and (satisfaction >= threshold-promoter) and (satisfaction-energy < 1))  [set color pink]
     if  (( choice-num = owner-product ) and (satisfaction <= threshold-unsatisfied)) [set color black set resistant?  true set choice-num 1 + random 9] ; market-process becames Unsatisfied customer. low satisfaction   
     if  ((choice-num = owner-product) and (satisfaction > threshold-unsatisfied and satisfaction < threshold-promoter ) and (resistant?  = false) and ( new? = false)) [set color blue] ; market-process becames customers
      
  ]
  
  ;set WoM_sales WoM_sales + count agents with [ (choice-num = owner-product) and (new? = true) and (tipo != 2) ]
 
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;_____________________________________-


to-report threshold-promoter1
  let listX sort-by > ( [ satisfaction ] of agents with [ tipo = 1 ] )   ;  organize a list of satisfaction values of all agents tipo 1 from high to low
  let listy sublist listX 0 ( length listX - ( market - ( market * nrpromoter )))  ; remove the last (customers and unsatisfied) satisfaction
  let listZ min listY   ; choose the min satisfaction from all the highest 
report listZ  ; satisfaction promoter threshold
end

to-report threshold-unsatisfied1
  let listX sort-by < ( [ satisfaction ] of agents with [ tipo = 1 ] )
  let listy sublist listX 0 (length listX - ( market - ( market * nrunsatisfied )))
  let listZ max listY
report listZ 
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; LOSE-ENERGY ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

to lose-energy 
  ask agents with [ (infected-promoter? = true) and (infected? = true) and (satisfaction <= 0.2 ) and (resistant? = false)] ; promoters
  [
    ifelse (satisfaction-energy < 1 ) [became-susceptible-with-ownerproduct][set satisfaction-energy satisfaction-energy - 3]
  ]
   
end

to insatisfaction
  ask agents with [ ( infected? = true) and (infected-promoter? = false) and (resistant? = 0) and (satisfaction > 0.95)]
  [
  became-resistant
  set choice-num one-of products with [product-number != owner-product]
  ]
    
end


to repetition
 set chosen lput (choice-num - 1) chosen
end

to became-susceptible-from-infected
  ask agents with [(infected? = true) and (infected-promoter? = false) and (choice-num = owner-product) and (resistant? = false)][became-susceptible-with-ownerproduct]
end

to became-infected  ;; turtle procedure
  set infected? true
  set resistant? false
  set infected-promoter? false
  set color red
end

to became-promoter  ;; turtle procedure
  set infected? true
  set resistant? false
  set infected-promoter? true
  set color black
end

to became-susceptible  ;; turtle procedure
  set infected? false
  set resistant? false  
  set infected-promoter? false
  set color green
end

to became-resistant  ;; turtle procedure
  set infected? false
  set resistant? true
  set infected-promoter? false
  set color gray
end

to became-susceptible-with-ownerproduct  ;; turtle procedure
  set infected? false
  set resistant? false  
  set infected-promoter? false
  set color blue
end

;;;;;;;;;;  Cognitive process ;;;;;;;;;;

to innovate ;; 
  if not empty? productlist ;; productlist is a list that tells which productes are investigated yet
  [
    ; choose valid product (< nrproducts)
    let choose-product-numb one-of productlist ;; choose one of products that has not been investigated from each agent's list
    let target-product one-of products with [product-number = choose-product-numb] ;; choose a product 
    let target-product-number [product-number] of target-product ;; get the product number, which was given in the beginning 
    set productlist remove target-product-number productlist
    
    set choice-num target-product-number
    set choice target-product
    set chosen lput (target-product-number - 1) chosen
    
    if count link-neighbors > 0 [
    set share replace-item (choose-product-numb - 1) share ((count link-neighbors with [prev-product-numb = choose-product-numb])/ count link-neighbors)]
        
    set payoff-choice (1 - abs (preference - [attribute] of target-product)) * normative + (1 - normative) * item (choose-product-numb - 1) share ;; get the quality of the product]

    let target-product-attribute [attribute] of target-product
    set repertoire replace-item (target-product-number - 1) repertoire payoff-choice ;;place the expected payoff in the repertoire. the reason (target-product-number - 1) is that product-number starts from 1 whereas repertoire starts from 0.     
    set market_process? true
  ]
end

to imitation
  if count link-neighbors > 0
  [
    let drawn random-float 1
    let teller 0
    let cumshare item teller share
    while [teller < nrproducts]
    [
     ifelse drawn <= cumshare [set choice-num teller + 1 set teller nrproducts][set teller teller + 1 set cumshare cumshare + item teller share] 
    ]
    
    set repertoire replace-item (choice-num - 1)  repertoire 1 ;;place the expected payoff in the repertoire. the reason (target-product-number - 1) is that product-number starts from 1 whereas repertoire starts from 0.  
    set chosen lput (choice-num - 1) chosen
    set choice turtle (choice-num - 1) 
    if not member? (choice-num - 1) repertoirelist [set repertoirelist lput (choice-num - 1) repertoirelist]
    set market_process? true
  ]
end

to socialcomparison
  if count link-neighbors > 0
  [
    let drawn random-float 1
    let teller 0
    let cumshare item teller share
    let imchoice 0
    while [teller < nrproducts]
    [
     ifelse drawn <= cumshare [set imchoice teller + 1 set teller nrproducts][set teller teller + 1 set cumshare cumshare + item teller share] 
    ]
    let imutility (1 - abs (preference - [attribute] of choice)) * normative + (1 - normative) * item (imchoice - 1) share
    if imutility > item (choice-num - 1) utility [set choice-num imchoice]    
        
    set repertoire replace-item (choice-num - 1)  repertoire 1 ;;place the expected payoff in the repertoire. the reason (target-product-number - 1) is that product-number starts from 1 whereas repertoire starts from 0.  
    set chosen lput (choice-num - 1) chosen
    set choice turtle (choice-num - 1) 
    if not member? (choice-num - 1) repertoirelist [set repertoirelist lput (choice-num - 1) repertoirelist]
    set market_process? true
  ]
end

to deliberation
let listmax []
  if sum repertoire != 0 ;;if repertoire is empty, agents cannot exploit
  [
    let teller 1
    let payoffestimate 0
    while [teller <= nrproducts] 
    [
      if member? (teller - 1) repertoirelist [
        if count link-neighbors > 0 [
        set share replace-item (teller - 1) share ((count link-neighbors with [prev-product-numb = teller])/ count link-neighbors)]
      
        set payoffestimate (1 - abs (preference - [attribute] of turtle (teller - 1))) * normative + (1 - normative) * item (teller - 1) share ;; get the quality of the product]

        set repertoire replace-item (teller - 1) repertoire payoffestimate
      ]
      set teller teller + 1
    ] 
    
    set teller 0
    let maxrep max repertoire ;; choose a max in repertoire
    while [teller < nrproducts]
    [
      if member? teller repertoirelist [
         if item teller repertoire = maxrep [set listmax lput teller listmax]
      ]
      set teller teller + 1
    ]
    set choice-num 1 + one-of listmax
    set chosen lput (choice-num - 1) chosen
    let help choice-num
    set choice one-of products with [product-number = help] ;; choose the product
       
    set repertoire replace-item (choice-num - 1) repertoire payoff-choice ;;place it in repertoire. 
    if not member? (choice-num - 1) repertoirelist [set repertoirelist lput (choice-num - 1) repertoirelist]
    set market_process? true
  ]
end



to do-plot
  
 
  set-current-plot "share-products"
  histogram chosen
  
   
  set-current-plot "Choices"
  set-current-plot-pen "imitation"
  plot count agents with [typeofchoice = 1]
  set-current-plot-pen "repetition"
  plot count agents with [typeofchoice = 2]
  set-current-plot-pen "socialcomparison"
  plot count agents with [typeofchoice = 3]
  set-current-plot-pen "deliberation"
  plot count agents with [typeofchoice = 4]
  
  set totim totim + count agents with [typeofchoice = 1]
  set totrep totrep + count agents with [typeofchoice = 2]
  set totsc totsc + count agents with [typeofchoice = 3]
  set totdel totdel + count agents with [typeofchoice = 4]
  
  set-current-plot "utility/uncertainty"
  set-current-plot-pen "utility"
  set avgutil 0
  ask agents with [tipo = 1] [
    set avgutil avgutil + item (choice-num - 1) utility
  ]
  set avgutil avgutil / market
  plot avgutil
  

  
  set-current-plot-pen "uncertainty"
  plot sum [uncertainty] of agents / market
  
  set-current-plot "share-products-time"
  set-current-plot-pen "1"
  plot count agents with [choice-num = 1]
  set-current-plot-pen "2"
  plot count agents with [choice-num = 2]
  set-current-plot-pen "3"
  plot count agents with [choice-num = 3]
  set-current-plot-pen "4"
  plot count agents with [choice-num = 4]
  set-current-plot-pen "5"
  plot count agents with [choice-num = 5]
  set-current-plot-pen "6"
  plot count agents with [choice-num = 6]
  set-current-plot-pen "7"
  plot count agents with [choice-num = 7]
  set-current-plot-pen "8"
  plot count agents with [choice-num = 8]
  set-current-plot-pen "9"
  plot count agents with [choice-num = 9]
  set-current-plot-pen "10"
  plot count agents with [choice-num = 10]
end

to calgini
  let choices []
  let k 1
  while [k <= nrproducts]
  [
   set choices lput count agents with [choice-num = k] choices
   set k k + 1 
  ]
  set k 1
  let sumdif 0
  while [k <= nrproducts]
  [
    let k2 k + 1
    while [k2 < nrproducts]
    [
       set sumdif sumdif + abs (item k choices - item k2 choices)
       set k2 k2 + 1
    ]
    set k k + 1 
  ]
  set gini sumdif / (nrproducts * market)
end
@#$#@#$#@
GRAPHICS-WINDOW
380
19
784
444
0
0
394.0
1
10
1
1
1
0
0
0
1
0
0
0
0
0
0
1
ticks
30.0

BUTTON
139
16
223
50
setup
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
859
275
1165
510
share-products
type
number
0.0
25.0
0.0
10.0
true
false
"" ""
PENS
"minority" 1.0 1 -16777216 true "" ""

SLIDER
1635
323
1811
356
nrproducts
nrproducts
1
25
10
1
1
NIL
HORIZONTAL

SLIDER
10
17
133
50
market
market
1
1000
1000
1
1
NIL
HORIZONTAL

BUTTON
230
17
294
50
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
1273
100
1436
133
beta
beta
0
1
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
1274
141
1436
174
average-node-degree
average-node-degree
0
20
10
1
1
NIL
HORIZONTAL

SLIDER
1442
100
1628
133
D
D
2
10
2
1
1
NIL
HORIZONTAL

SWITCH
1272
60
1436
93
fullknowledge
fullknowledge
1
1
-1000

SLIDER
1636
100
1808
133
utilitymin
utilitymin
0
1
0.5
0.01
1
NIL
HORIZONTAL

SLIDER
1637
141
1810
174
uncertaintymax
uncertaintymax
0
1
0.25
0.01
1
NIL
HORIZONTAL

PLOT
859
19
1263
268
Choices
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"imitation" 1.0 0 -16777216 true "" ""
"repetition" 1.0 0 -13345367 true "" ""
"socialcomparison" 1.0 0 -10899396 true "" ""
"deliberation" 1.0 0 -2674135 true "" ""

PLOT
2242
20
2652
232
utility/uncertainty
NIL
NIL
0.0
10.0
0.0
1.0
true
true
"" ""
PENS
"utility" 1.0 0 -16777216 true "" ""
"uncertainty" 1.0 0 -13345367 true "" ""

SWITCH
1442
61
1628
94
homophily
homophily
0
1
-1000

SWITCH
1635
60
1807
93
heterobeta
heterobeta
0
1
-1000

SLIDER
1444
141
1628
174
probbuying
probbuying
0
1
0.1
0.01
1
NIL
HORIZONTAL

PLOT
380
630
744
877
share-products-time
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"1" 1.0 0 -16777216 true "" ""
"2" 1.0 0 -2064490 true "" ""
"3" 1.0 0 -8630108 true "" ""
"4" 1.0 0 -13345367 true "" ""
"5" 1.0 0 -11221820 true "" ""
"6" 1.0 0 -13840069 true "" ""
"7" 1.0 0 -1184463 true "" ""
"8" 1.0 0 -6459832 true "" ""
"9" 1.0 0 -955883 true "" ""
"10" 1.0 0 -2674135 true "" ""

SLIDER
1444
179
1628
212
advertisement2
advertisement2
0
1
1
0.01
1
NIL
HORIZONTAL

SLIDER
1275
180
1436
213
nrinitproducts
nrinitproducts
0
nrproducts
10
1
1
NIL
HORIZONTAL

SLIDER
1278
324
1435
357
nrowners
nrowners
1
10
1
1
1
NIL
HORIZONTAL

SLIDER
1444
323
1630
356
owner-product
owner-product
1
nrproducts
10
1
1
NIL
HORIZONTAL

MONITOR
379
579
467
624
Potential
(count agents with [ (choice-num != owner-product) and (resistant? = false)]) ;; / (count agents )
3
1
11

MONITOR
473
578
556
623
customers
count agents with [ (tipo = 1 ) and (choice-num = owner-product) and (resistant? = false) ] ;and (satisfaction-energy > 0.1 and  satisfaction-energy < 0.7  )  / (count agents )
17
1
11

BUTTON
667
450
755
483
interact
if (mouse-down? and mouse-inside?) [\n    let closest turtles with-min [distancexy mouse-xcor mouse-ycor]\n    ask closest [setxy mouse-xcor mouse-ycor]\n  ]
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1029
578
1152
623
Owner net size *
count  [link-neighbors] of agent 1010 ;with [tipo = 2 ] ); 1010 ;30 ;510
17
1
11

BUTTON
300
17
363
50
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

PLOT
1830
180
2233
342
MARKET-MODEL
time
Market
0.0
50.0
0.0
100.0
true
true
"" ""
PENS
"Potential Customer" 1.0 0 -10899396 true "" "plot (count agents with [(choice-num != owner-product) and (resistant? = false) ] )  ; / (count agents )"
"Customers" 1.0 0 -13345367 true "" "plot (count agents with [((choice-num = owner-product) and ((satisfaction > nrunsatisfied ) and (satisfaction < nrpromoter)) and (resistant? = false )) or ( (choice-num = owner-product) and (satisfaction >= nrpromoter) and ( satisfaction-energy  <  1 ) and (resistant? = false))] )"
"promoters" 1.0 0 -2674135 true "" "plot (count agents with [(choice-num = owner-product) and (satisfaction >= nrpromoter) and ( satisfaction-energy >= 1) and (resistant? = false)]); esto no quiere decir que hay promoters"
"Unsatisfied Customers" 1.0 0 -16777216 true "" "plot (count agents with [(choice-num = owner-product) and (satisfaction <= nrunsatisfied) and (resistant? = true)]);/ (count agents) * 100"

MONITOR
559
578
644
623
population
count agents
17
1
11

PLOT
2244
240
2508
360
SIR Status
time
% of nodes
0.0
52.0
0.0
100.0
true
true
"" ""
PENS
"susceptible" 1.0 0 -13345367 true "" "plot (count agents with [not infected? and not resistant? ]) / (count agents) * 100"
"infected" 1.0 0 -2674135 true "" "plot (count agents with [infected?]) / (count agents) * 100"
"resistant" 1.0 0 -7500403 true "" "plot (count agents with [resistant?]) / (count agents) * 100"
"promoters" 1.0 0 -16777216 true "" "plot (count agents with [infected? and infected-promoter? ] ) / ( count agents) * 100"

PLOT
1830
20
2234
178
Agents-Color
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"Potential Customers" 1.0 0 -10899396 true "" "plot (count agents with [color = green])"
"Customers" 1.0 0 -13345367 true "" "Plot (count agents with [color = blue])"
"Promoters" 1.0 0 -2674135 true "" "Plot (count agents with [color = red])"
"Unsatisfied Customers" 1.0 0 -16777216 true "" "Plot ( count agents with [color =  black])"

TEXTBOX
1280
222
1430
240
Satisfaction Threshold
12
15.0
1

SLIDER
1277
241
1434
274
nrpromoter
nrpromoter
nrunsatisfied
1
0.05
0.01
1
>
HORIZONTAL

SLIDER
1441
241
1628
274
nrunsatisfied
nrunsatisfied
0
nrpromoter
0.05
0.01
1
<
HORIZONTAL

MONITOR
650
578
744
623
Promoters%
((count agents with [satisfaction >= threshold-promoter]) / ( market + nrowners )) * 100\n; including owner
2
1
11

MONITOR
748
578
846
623
Unsatisfied%
((count agents with [satisfaction <= threshold-unsatisfied]) / ( market + nrowners )) * 100
2
1
11

SWITCH
1270
20
1436
53
market-process?
market-process?
0
1
-1000

SWITCH
1442
20
1628
53
diffusion-process?
diffusion-process?
0
1
-1000

MONITOR
939
577
1021
622
promoters
threshold-promoter
2
1
11

MONITOR
850
577
936
622
unsatisfied
threshold-unsatisfied
5
1
11

SWITCH
1634
20
1807
53
negative-process?
negative-process?
0
1
-1000

SLIDER
1277
281
1434
314
satisfaction-force
satisfaction-force
0
1
0.2
0.01
1
NIL
HORIZONTAL

SLIDER
1442
282
1629
315
unsatisfaction-force
unsatisfaction-force
0
1
1
0.01
1
NIL
HORIZONTAL

CHOOSER
379
526
655
571
strategies
strategies
"brokerage-grow-size-connect-promoters" "brokerage-grow-size-energize-promoters" "brokerage-grow-size-cp-ep-mix"
0

PLOT
1826
352
2234
512
size-customers
customers
net size
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plotxy   (count agents with [tipo = 1] ) (count agents) ; (count agents with [choice-num = owner-product]) (count neighbors of agent with [tipo = 1])"

PLOT
2660
22
2952
261
Degree distribution
degree
# of nodes
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 1 -16777216 true "" "let max-degree max [count link-neighbors] of turtles\nplot-pen-reset\nset-plot-x-range 1 (max-degree + 1 )\nhistogram [ count link-neighbors] of agents"

TEXTBOX
2757
491
2907
509
Network parameters
12
0.0
1

OUTPUT
305
65
377
265
12

MONITOR
1164
577
1283
622
NIL
sales
17
1
11

SLIDER
1278
379
1435
412
down-random
down-random
0.01
1
0.1
0.01
1
NIL
HORIZONTAL

PLOT
3
65
306
283
market-sales
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot   market-sales-tick"

SLIDER
1444
379
1628
412
max-contacts-day
max-contacts-day
1
50
15
1
1
NIL
HORIZONTAL

PLOT
2659
266
2953
473
Degree distribution (log-log)
log(degree)
log(# of nodes)
0.0
0.3
0.0
0.3
true
false
"" ""
PENS
"default" 1.0 2 -16777216 true "" "let max-degree max [count link-neighbors] of agents\n;; for this plot, the axes are logarithmic, so we can't\n;; use \"histogram-from\"; we have to plot the points\n;; ourselves one at a time\nplot-pen-reset  ;; erase what we plotted before\n;; the way we create the network there is never a zero degree node,\n;; so start plotting at degree one\nlet degree 1\nwhile [degree <= max-degree] [\n  let matches agents with [count link-neighbors = degree]\n  if any? matches\n    [ plotxy log degree 10\n             log (count matches) 10 ]\n  set degree degree + 1\n]"

BUTTON
461
450
563
483
mayor grado
;;ask agent 21 [ let max-grado  link-neighbors with-max[count link-neighbors] show max-grado show  max-one-of max-grado [count link-neighbors] ]\n\nask agent 21 [ let max-grado  link-neighbors with [tipo = 1] show  max-one-of max-grado [count link-neighbors with[tipo = 1]] ]\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
379
449
452
482
vecinos
ask patches [set pcolor black]\nask turtles [set label who]\n;show count [list-contacts]  of agent 21\nask agent 12 [ ask list-contacts [let grado count link-neighbors with [tipo = 1] show grado ] ]\n;ask agent 12 [ let max-grado  link-neighbors with-max[count link-neighbors] show max-grado show  max-one-of max-grado [count link-neighbors with[tipo = 1]] ]\n; with-max[count link-neighbors with [tipo = 1]] show max-grado show  max-one-of max-grado [count link-neighbors with[tipo = 1]]  ]\n\n\n\n\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

BUTTON
575
449
657
482
Densidad
\n;; densidad=numero de enlaces/numero de nodos(numero de nodos-1)/2\nask patches [set pcolor black]\n\n;ask agent 31[ask list-contacts[\n;set a 0\n;set b 0\n;set c 0\n;ask agent 31 [ask list-contacts [set a count link-neighbors]];; numero de enlaces de la red del agente 21\n;ask agent 31 [ask list-contacts [set b count list-contacts + 1]];; numero de nodos de la red del agente 21\n;ask agent 31 [ask list-contacts [set c count list-contacts ]];; numero de nodos de la red del agente 21 - 1 \n;;show \"numero de enlaces\"\n;;show a\n;;show \"numero de nodos de la red del agente\"\n;;show b\n;;show c\n;;show \"Densidad de la red del agente\"\n;show (a / ( b * c / 2))]] ;; densidad de la red del agente 21 no incluye al empresario\n\n;ask agents with [tipo = 2] [\n   ;ask list-contacts [\n    ask agents with [tipo = 2] [let list-contactosempresario  list-contacts ;show list-contactosempresario ; contactos del microempresario\n    Ask list-contactosempresario [let referidos list-contacts with [tipo = 1] ;show referidos\n    let union ( turtle-set list-contactosempresario referidos) ;show union \n    let substract referidos with [not member? self list-contactosempresario] ;show substract\n    ask substract [\n    let a count link-neighbors\n    let b count list-contacts + 1\n    let c count list-contacts\n    show a\n    show b\n    show c\n    show \"densidad\"\n    \n    show ( a / ((b * c )/ 2))\n    ]\n    ]]\n    \n    \n    ;ask agent 30 [;let list-contactosempresario  link-neighbors ;show list-contactosempresario ; contactos del microempresario\n    ;Ask list-contacts with [tipo = 1][let referidos link-neighbors with [tipo = 1] ;show referidos\n    ;let union ( turtle-set list-contacts with [tipo = 1] referidos) ;show union \n    ;let substract referidos with [not member? self list-contacts with [tipo = 1]] show substract\n    ;]]\n    \n    \n     ;let list-refered  link-neighbors of list-contactosempresario; vecinos de los contactos del microempresario\n        ;show list-refered\n        \n  ;join 2 agent sets\n  ;let joinset (turtle-set red-ones blue-ones)\n  ;show joinset\n  \n  ;let even-ones (turtles with [who mod 2 = 0])\n  ;subtract even-ones from red-ones\n  ;let subtractset red-ones with [not member? self even-ones]\n  ;show subtractset\n\n  \n      ; let subtractset list-refered [not member? self list-contactosempresario ];; muestre los vecinos que no son miembros de los contactos del microempresario\n       ;y a ese subtracteset sacarle el mayor grado.\n  ;show subtractset\n    \n   ; ask list-refered [\n      ;let a count link-neighbors\n      ;let b count list-contacts + 1\n     ; let c count list-contacts\n      ; show \"densidad\"\n      ;show (a / ( b * c / 2))\n       ; ]\n       ; ]\n   ;]\n\n\n\n;set a 0\n;set b 0\n;set c 0\n;ask agent 11 [set a count link-neighbors];; numero de enlaces de la red del agente 21\n;ask agent 11 [set b count list-contacts + 1];; numero de nodos de la red del agente 21\n;ask agent 11 [set c count list-contacts];; numero de nodos de la red del agente 21 - 1 \n;show \"numero de enlaces\"\n;show a\n;show \"numero de nodos de la red del agente\"\n;show b\n;show c\n;show \"Densidad de la red del agente\"\n;show (a / ( b * c / 2)) ;; densidad de la red del agente 21 no incluye al empresario\n
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
1172
423
1284
468
Promoters
promoters_tick
17
1
11

MONITOR
1172
278
1249
323
Promoters2
count agents with [(tipo = 1 ) and (color = red)]
17
1
11

MONITOR
1168
328
1274
373
NIL
market-sales-tick
17
1
11

BUTTON
379
487
515
520
NIL
connect-promoters
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
518
487
757
520
event
event
1
500
500
1
1
NIL
HORIZONTAL

PLOT
4
287
306
493
WoM_sales
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot WoM_sales"

PLOT
3
63
305
282
WoM_promoters
NIL
NIL
0.0
10.0
0.0
10.0
true
false
"" ""
PENS
"default" 1.0 0 -16777216 true "" "plot WoM_promoters"

BUTTON
786
85
856
118
NIL
setup1
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

@#$#@#$#@
- In this version we change market-sales to marketsales because there is a problem with R 
- The marketsales should be done at the end of the simulation. When stop 

Version 3

We changed market-sales-day to marketsalesday
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

link
true
0
Line -7500403 true 150 0 150 300

link direction
true
0
Line -7500403 true 150 150 30 225
Line -7500403 true 150 150 270 225

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.2.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
<experiments>
  <experiment name="Experiment II - Market4 vs Strategies referred" repetitions="500" runMetricsEveryStep="false">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>[totalmarketsales] of agent 510</metric>
    <enumeratedValueSet variable="market">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrowners">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="utilitymin">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertaintymax">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="brokerage-grow-random">
      <value value="&quot;brokerage-grow-size&quot;"/>
      <value value="&quot;brokerage-grow-density&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fullknowledge">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="heterobeta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="homophily">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-node-degree">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probbuying">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrinitproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="advertisement2">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrpromoter">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrunsatisfied">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diffusion-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="negative-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="satisfaction-force">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unsatisfaction-force">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owner-product">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-contacts-day">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="down-random">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="D">
      <value value="2"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Experiment I - Promoters vs TMS" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>[marketsales] of agent 510</metric>
    <metric>(promoters_day)</metric>
    <enumeratedValueSet variable="negative-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrunsatisfied">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="homophily">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertaintymax">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="D">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="down-random">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owner-product">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrpromoter">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrinitproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="utilitymin">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrowners">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-node-degree">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-contacts-day">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="strategies">
      <value value="&quot;brokerage-grow-size&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="satisfaction-force">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diffusion-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="advertisement2">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="heterobeta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fullknowledge">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probbuying">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market">
      <value value="500"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unsatisfaction-force">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="experiment" repetitions="1" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <metric>count turtles</metric>
    <enumeratedValueSet variable="nrunsatisfied">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="homophily">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unsatisfaction-force">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-contacts-day">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fullknowledge">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="heterobeta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owner-product">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-node-degree">
      <value value="4"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertaintymax">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="strategies">
      <value value="&quot;brokerage-grow-size-connect-promoters&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="utilitymin">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="down-random">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="negative-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="advertisement2">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market">
      <value value="20"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="D">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="satisfaction-force">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrinitproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrpromoter">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probbuying">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrowners">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diffusion-process?">
      <value value="true"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Correlation - Promoters vs WoM_sales" repetitions="10" runMetricsEveryStep="true">
    <setup>setup1</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>WoM_sales</metric>
    <metric>(promoters_day)</metric>
    <enumeratedValueSet variable="negative-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrunsatisfied">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="homophily">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertaintymax">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="D">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="down-random">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owner-product">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrpromoter">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrinitproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="utilitymin">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrowners">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-node-degree">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-contacts-day">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="strategies">
      <value value="&quot;brokerage-grow-size-connect-promoters&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="satisfaction-force">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diffusion-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="advertisement2">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="heterobeta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fullknowledge">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probbuying">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unsatisfaction-force">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Energize Promoters - Promoters vs WoM_sales" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="100"/>
    <metric>WoM_sales</metric>
    <metric>(promoters_day)</metric>
    <enumeratedValueSet variable="negative-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrunsatisfied">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="homophily">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertaintymax">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="D">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="down-random">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owner-product">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrpromoter">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrinitproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="utilitymin">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrowners">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-node-degree">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-contacts-day">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="strategies">
      <value value="&quot;brokerage-grow-size-connect-promoters&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="satisfaction-force">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diffusion-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="advertisement2">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="heterobeta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fullknowledge">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probbuying">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unsatisfaction-force">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
  <experiment name="Connect and Energize Promoters - Promoters vs WoM_sales" repetitions="10" runMetricsEveryStep="true">
    <setup>setup</setup>
    <go>go</go>
    <timeLimit steps="500"/>
    <metric>WoM_sales</metric>
    <metric>(promoters_day)</metric>
    <enumeratedValueSet variable="negative-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="beta">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrunsatisfied">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="homophily">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="uncertaintymax">
      <value value="0.25"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="D">
      <value value="2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="down-random">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="owner-product">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrpromoter">
      <value value="0.05"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrinitproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="utilitymin">
      <value value="0.5"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrowners">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="average-node-degree">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="max-contacts-day">
      <value value="15"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="strategies">
      <value value="&quot;brokerage-grow-size-connect-promoters&quot;"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="satisfaction-force">
      <value value="0.2"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="nrproducts">
      <value value="10"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="diffusion-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="advertisement2">
      <value value="1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="heterobeta">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="fullknowledge">
      <value value="false"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market-process?">
      <value value="true"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="probbuying">
      <value value="0.1"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="market">
      <value value="1000"/>
    </enumeratedValueSet>
    <enumeratedValueSet variable="unsatisfaction-force">
      <value value="1"/>
    </enumeratedValueSet>
  </experiment>
</experiments>
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

@#$#@#$#@
0
@#$#@#$#@
