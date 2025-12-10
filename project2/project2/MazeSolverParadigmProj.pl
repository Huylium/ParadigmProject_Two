

%gets cell value from R,C
get_cell(Maze, R, C, Cell) :-
    
    nth0(R, Maze, Row),
   
    nth0(C, Row, Cell).


%grabs maze dimensions
get_maze_dimensions(Maze, MaxR, MaxC) :-
    length(Maze, NumRows),
    NumRows > 0,
    MaxR is NumRows - 1,
    nth0(0, Maze, FirstRow),
    length(FirstRow, NumCols),
    NumCols > 0,
    MaxC is NumCols - 1.

%find the start
find_start(Maze, StartRow, StartColumn) :-
    get_maze_dimensions(Maze, MaxR, MaxC),
    between(0, MaxR, StartRow),  
    between(0, MaxC, StartColumn),  
    get_cell(Maze, StartRow, StartColumn, s),

    !. 

%simple moving predicates
%left
move(up, Rin, Cin, Rout, Cin) :- Rout is Rin - 1. 
%right
move(down, Rin, Cin, Rout, Cin) :- Rout is Rin + 1.
%up
move(left, Rin, Cin, Rin, Cout) :- Cout is Cin - 1.
%down
move(right, Rin, Cin, Rin, Cout) :- Cout is Cin + 1.

%find the exit
find_path(Maze, R, C, _, []) :-
    get_cell(Maze, R, C, e),
    !.

%checker
find_path(Maze, R, C, Visited, [Action | PathTail]) :-
 
    move(Action, R, C, NextR, NextC),

  
    valid_move(Maze, NextR, NextC),

    
    \+ member((NextR, NextC), Visited),

    
    find_path(Maze, NextR, NextC, [(NextR, NextC) | Visited], PathTail).


%checks if R,C is empty
valid_move(Maze, R, C) :-
    get_maze_dimensions(Maze, MaxR, MaxC),
    
    R >= 0, R =< MaxR,
    C >= 0, C =< MaxC,

    
    get_cell(Maze, R, C, Cell),
    Cell \= w.


%rechecks if path is valid
verify_path(Maze, R, C, []) :-
    get_cell(Maze, R, C, e).

%recursion^
verify_path(Maze, R, C, [Action | ActionsTail]) :-
    
    move(Action, R, C, NextR, NextC),

    
    valid_move(Maze, NextR, NextC),

    
    verify_path(Maze, NextR, NextC, ActionsTail).



%start, 
find_exit(Maze, Actions) :-
    %go to start
    find_start(Maze, StartRow, StartColumn),

   %if no path given
    (   var(Actions)
    -> 
        find_path(Maze, StartRow, StartColumn, [(StartRow, StartColumn)], Actions)
    ;
       %if path is given
        verify_path(Maze, StartRow, StartColumn, Actions)
    ).