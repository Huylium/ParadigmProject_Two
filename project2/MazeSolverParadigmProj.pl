


get_cell(Maze, R, C, Cell) :-
    
    nth0(R, Maze, Row),
   
    nth0(C, Row, Cell).


get_maze_dimensions(Maze, MaxR, MaxC) :-
    length(Maze, NumRows),
    NumRows > 0,
    MaxR is NumRows - 1,
    nth0(0, Maze, FirstRow),
    length(FirstRow, NumCols),
    NumCols > 0,
    MaxC is NumCols - 1.


find_start(Maze, StartR, StartC) :-
    get_maze_dimensions(Maze, MaxR, MaxC),
    between(0, MaxR, StartR),  
    between(0, MaxC, StartC),  
    get_cell(Maze, StartR, StartC, s),

    !. 

move(up, Rin, Cin, Rout, Cin) :- Rout is Rin - 1.
move(down, Rin, Cin, Rout, Cin) :- Rout is Rin + 1.
move(left, Rin, Cin, Rin, Cout) :- Cout is Cin - 1.
move(right, Rin, Cin, Rin, Cout) :- Cout is Cin + 1.


find_path(Maze, R, C, _, []) :-
    get_cell(Maze, R, C, e),
    !.


find_path(Maze, R, C, Visited, [Action | PathTail]) :-
 
    move(Action, R, C, NextR, NextC),

  
    valid_move(Maze, NextR, NextC),

    
    \+ member((NextR, NextC), Visited),

    
    find_path(Maze, NextR, NextC, [(NextR, NextC) | Visited], PathTail).



valid_move(Maze, R, C) :-
    get_maze_dimensions(Maze, MaxR, MaxC),
    
    R >= 0, R =< MaxR,
    C >= 0, C =< MaxC,

    
    get_cell(Maze, R, C, Cell),
    Cell \= w.



verify_path(Maze, R, C, []) :-
    get_cell(Maze, R, C, e).


verify_path(Maze, R, C, [Action | ActionsTail]) :-
    
    move(Action, R, C, NextR, NextC),

    
    valid_move(Maze, NextR, NextC),

    
    verify_path(Maze, NextR, NextC, ActionsTail).




find_exit(Maze, Actions) :-
    
    find_start(Maze, StartR, StartC),

   
    (   var(Actions)
    -> 
        find_path(Maze, StartR, StartC, [(StartR, StartC)], Actions)
    ;
       
        verify_path(Maze, StartR, StartC, Actions)
    ).