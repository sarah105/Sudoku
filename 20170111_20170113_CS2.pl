getAllEmptyCells(Board,Z):-
    %board(Board),
    findall([X,Y],member([x,X,Y],Board),Z).

getRow(Index,Board,Row):-
    %board(Board),
    findall(N,member([N,Index,_],Board),Row).
getCol(Index,Board,Colomn):-
    %board(Board),
    findall(N,member([N,_,Index],Board),Colomn).

getBox([X,Y],Board,Box):-
    %board(Board),
    getBoxRow([X,Y],Board,0,Row1),
    X1 is X + 1 ,
    getBoxRow([X1,Y],Board,0,Row2),
    X2 is X1 + 1 ,
    getBoxRow([X2,Y],Board,0,Row3),
    append(Row1,Row2,Tem),
    append(Tem,Row3,Box).


getBoxRow(_,_,3,[]):-!.
getBoxRow([X,Y],Board,Count,[Res|Box]):-
    Index is X * 9 + Y,
    nth0(Index,Board,[Res|_]),
    NewCount is Count + 1,
    NY is Y + 1,
    getBoxRow([X,NY],Board,NewCount,Box).

safe([N,X,Y],Board):-
    getRow(X,Board,Row),
    getCol(Y,Board,Col),
    X1 is truncate(X / 3) * 3,
    Y1 is truncate(Y / 3) * 3,
    getBox([X1,Y1],Board,Box),
    not(member(N,Row)),
    not(member(N,Col)),
    not(member(N,Box)).

replaceElement(_,[],[]):-!.
replaceElement([N,X,Y],[[_,X,Y]|T],[[N,X,Y]|T]):-!.
replaceElement([N,X,Y],[H|T],[H|T2]):-
    replaceElement([N,X,Y],T,T2).

avalibaleElement([X,Y],Board,[Num,X,Y]):-
    %board(Board),
    num(Num),
    %not(member([X,Y],Tem)),
    safe([Num,X,Y],Board).
getAllAvaliable([X,Y],Board,Res):-
    findall(Num,avalibaleElement([X,Y],Board,Num),Res).

%this for run the game
play(Res):-
    board(Board),
    dfs([Board],[],Res).
dfs([],_,[]):-
    write("no solution").
dfs([H|_],_,Res):-
    getAllEmptyCells(H,Z),
    length(Z,Len),
    Len is 0,
    printBoard(H,0,Res),
    !.
dfs([H|T],Closed,Res):-
    getAllchildren(H,[H|T],Closed,Children),
    append(Children,T,NewOpend),
    append(Closed,[H],NewClosed),
    dfs(NewOpend,NewClosed,Res).

getAllchildren(Board,Open,Closed,Children):-
    getAllEmptyCells(Board,[H|_]),
    getAllAvaliable(H,Board,Res),
    getChildren(Res,Board,Open,Closed,Children).

getChildren([],_,_,_,[]).
getChildren([H|T],Board,Open,Closed,[NewBoard|Children]):-
    replaceElement(H,Board,NewBoard),
    not(member(NewBoard,Closed)),
    not(member(NewBoard,Open)),
    getChildren(T,Board,Open,Closed,Children),!.
getChildren([_|T],Board,Open,Closed,Children):-
    getChildren(T,Board,Open,Closed,Children).

printBoard(_,9,[]):-!.
printBoard(Board,Index,[Row|T]):-
    getRow(Index,Board,Row),
    write(Row),nl,
    NextIndex is Index + 1,
    printBoard(Board,NextIndex,T).















