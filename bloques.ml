(* ocamlc -o bloques bloques.ml *)

exception Accion_imposible of string;;
exception Mundo_imposible;;
exception Mundo_invalido of string;;

type mundo = int array * (int * int) * int;;

type accion =
    | Arriba
    | Abajo
    | Izquierda
    | Derecha
    | Coger
    | Soltar;;

type plan = accion list;;

let ejecutar_accion a (mundo,(x,y),bloque) = match a with
    | Arriba    -> if(y-1 >= 0) then (mundo,(x,y-1),bloque)
                   else raise(Accion_imposible "Arriba")
    | Abajo     -> (match y with
                       | 2 -> raise(Accion_imposible "Abajo")
                       | _ -> if(bloque = 0 && Array.get mundo (x*3+y) = 0) then (mundo,(x,y+1),bloque)
                              else if(Array.get mundo (x*3+y+1) = 0) then (mundo,(x,y+1),bloque)
                                   else raise(Accion_imposible "Abajo"))
    | Izquierda -> (try let bloqueado = Array.get mundo (x*3+y-3) in
                        if(bloqueado = 0) then (mundo,(x-1,y),bloque)
                        else if(bloque = 0) then match y with
                                 | 0 -> (mundo,(x-1,y),bloque)
                                 | _ -> let bloqueado = Array.get mundo (x*3+y-4) in
                                        if(bloqueado = 0) then (mundo,(x-1,y),bloque)
                                        else raise(Accion_imposible "Izquierda")
                             else raise(Accion_imposible "Izquierda")
                    with Invalid_argument _ -> raise(Accion_imposible "Izquierda"))
    | Derecha   -> (try let bloqueado = Array.get mundo (x*3+y+3) in
                        if(bloqueado = 0) then (mundo,(x+1,y),bloque)
                        else if(bloque = 0) then match y with
                                 | 0 -> (mundo,(x+1,y),bloque)
                                 | _ -> let bloqueado = Array.get mundo (x*3+y+2) in
                                        if(bloqueado = 0) then (mundo,(x+1,y),bloque)
                                        else raise(Accion_imposible "Derecha")
                             else raise(Accion_imposible "Derecha")
                    with Invalid_argument _ -> raise(Accion_imposible "Derecha"))
    | Coger     -> let pos = Array.get mundo (x*3+y) in
                   if(bloque = 0 && pos != 0) then (Array.set mundo (x*3+y) 0; (mundo,(x,y),pos))
                   else raise(Accion_imposible "Coger")
    | Soltar    -> if(bloque != 0 && Array.get mundo (x*3+y) = 0) then match y with
                       | 2 -> (Array.set mundo (x*3+y) bloque; (mundo,(x,y),0))
                       | _ -> if(Array.get mundo (x*3+y+1) != 0) then (Array.set mundo (x*3+y) bloque; (mundo,(x,y),0))
                              else raise(Accion_imposible "Soltar")
                   else raise(Accion_imposible "Soltar");;

let copiar_mundo (mundo,(x,y),bloque) = (Array.copy mundo,(x,y),bloque);;

let incluir_acciones mundo plan accion cola = match accion with
    | Arriba    -> (Queue.push (copiar_mundo mundo,plan,Arriba)    cola; Queue.push (copiar_mundo mundo,plan,Izquierda) cola;
                    Queue.push (copiar_mundo mundo,plan,Derecha)   cola; Queue.push (copiar_mundo mundo,plan,Coger)     cola;
                    Queue.push (copiar_mundo mundo,plan,Soltar)    cola; cola)
    | Abajo     -> (Queue.push (copiar_mundo mundo,plan,Abajo)     cola; Queue.push (copiar_mundo mundo,plan,Izquierda) cola;
                    Queue.push (copiar_mundo mundo,plan,Derecha)   cola; Queue.push (copiar_mundo mundo,plan,Coger)     cola;
                    Queue.push (copiar_mundo mundo,plan,Soltar)    cola; cola)
    | Izquierda -> (Queue.push (copiar_mundo mundo,plan,Arriba)    cola; Queue.push (copiar_mundo mundo,plan,Abajo)     cola;
                    Queue.push (copiar_mundo mundo,plan,Izquierda) cola; Queue.push (copiar_mundo mundo,plan,Coger)     cola;
                    Queue.push (copiar_mundo mundo,plan,Soltar)    cola; cola)
    | Derecha   -> (Queue.push (copiar_mundo mundo,plan,Arriba)    cola; Queue.push (copiar_mundo mundo,plan,Abajo)     cola;
                    Queue.push (copiar_mundo mundo,plan,Derecha)   cola; Queue.push (copiar_mundo mundo,plan,Coger)     cola;
                    Queue.push (copiar_mundo mundo,plan,Soltar)    cola; cola)
    | Coger     -> (Queue.push (copiar_mundo mundo,plan,Arriba)    cola; Queue.push (copiar_mundo mundo,plan,Abajo)     cola;
                    Queue.push (copiar_mundo mundo,plan,Izquierda) cola; Queue.push (copiar_mundo mundo,plan,Derecha)   cola; cola)
    | Soltar    -> (Queue.push (copiar_mundo mundo,plan,Arriba)    cola; Queue.push (copiar_mundo mundo,plan,Abajo)     cola;
                    Queue.push (copiar_mundo mundo,plan,Izquierda) cola; Queue.push (copiar_mundo mundo,plan,Derecha)   cola; cola)

let construir_plan inicial final =
    let rec intentar_por visitados cola =
        if Queue.is_empty cola then raise(Mundo_imposible)
        else let (mundo,plan,accion) = Queue.pop cola in
            if(mundo = final) then List.rev plan
            else let (mundo,cola) =
                try let mundo = ejecutar_accion accion mundo in
                    if(List.mem mundo visitados) then (None,cola)
                    else (Some mundo,incluir_acciones mundo (accion::plan) accion cola)
                with Accion_imposible _ -> (None,cola)
            in match mundo with
                | None       -> intentar_por visitados cola
                | Some mundo -> intentar_por (mundo::visitados) cola
    in intentar_por [inicial] (incluir_acciones inicial [] Abajo (Queue.create ()));;

let escribir_accion = function
    | Arriba    -> print_endline "Arriba"
    | Abajo     -> print_endline "Abajo"
    | Izquierda -> print_endline "Izquierda"
    | Derecha   -> print_endline "Derecha"
    | Coger     -> print_endline "Coger"
    | Soltar    -> print_endline "Soltar";;

let rec escribir_plan = function
    | []   -> ()
    | h::t -> escribir_accion h; escribir_plan t;;

let crear_mundo entrada mundo =
    if(String.length entrada != 9) then raise(Mundo_invalido entrada)
    else let rec aux i =
        if(i < 9) then
            let bloque = String.get entrada i in
            if bloque = '0' then aux (i+1)
            else let _ = Array.set mundo i ((int_of_char bloque)-48) in aux (i+1)
        else (mundo,(1,0),0)
    in aux 0;;

let print_list l = List.iter print_int l;;

let rec print_plan plan mundo = match plan with
    | []     -> ()
    | acc::t -> let (arr,(x,y),bl) = mundo in
                print_list (Array.to_list arr);
                print_string " x: "; print_int x;
                print_string " y: "; print_int y;
                print_string " bloque: "; print_int bl ;
                print_endline ""; print_plan t (ejecutar_accion acc mundo);;

let main () =
    try let inicial = crear_mundo (Sys.argv.(1)) (Array.make 9 0) in
        let final = crear_mundo (Sys.argv.(2)) (Array.make 9 0) in
        escribir_plan (construir_plan inicial final)
    with Mundo_invalido s -> print_endline ("Tamaño del mundo "^s^" invalido")
        | Mundo_imposible -> print_endline "Imposible";;

main ();;
