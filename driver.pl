%Author := Darshit Nagar 180101018

:- dynamic faultynode/1,start/1,finish/1,pred/2.

append_lists( [], X, X).                              
append_lists( [X | Y], Z, [X | W]) :- append_lists( Y, Z, W).  

con_sym(Locx,Locy) :- mazelink(Locx,Locy).
con_sym(Locx,Locy) :- mazelink(Locy,Locx).

print_list([]).
print_list([H|T]):-
    write(H),nl,print_list(T).

fillsolution(X,Path,Path) :- start(X),print_list(Path),!.
fillsolution(X,Path,Solution) :- \+start(X),pred(Y,X),fillsolution(Y,[Y|Path],Solution).

travelling(_,[],[]) :- write('No Path Exists from Source to Destination'),nl,!.

travelling(Visitedlist,[HQ|TQ],Solution) :-
    (  
        finish(HQ) -> 
        fillsolution(HQ,[HQ],Solution),!;

        findall(Neighbor,(mazelink(HQ,Neighbor),\+member(Neighbor,Visitedlist),assert(pred(HQ,Neighbor))), Bag),
        append_lists(Visitedlist,Bag,NewVis),
        append_lists(TQ,Bag,NewQueue),
        travelling([HQ|NewVis],NewQueue,Solution)
        ).

shortest_path(X,Y,Solution) :- (
    
    faultynode(X) -> write('Source cant be a faulty node!'),nl,!;
    faultynode(Y) -> write('Destination cant be a faulty node'),nl,!;
    assert(start(X)),
    assert(finish(Y)),
    findall(Z,faultynode(Z),Vis),
    travelling(Vis,[X],Solution),
    retract(start(X)),
    retract(finish(Y)),
    retractall(pred(_,_)),!
    ).

add_faulty(X) :- (  
    faultynode(X) -> write('Already added as Faulty Node'),nl,!;
    assert(faultynode(X))  
    ).

remove_faulty(X) :- (   
    faultynode(X) -> retract(faultynode(X));
    write(X),write(' is not a faulty node!'),nl
    ).

