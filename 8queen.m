const
  SIZE: 8;

type
  foreground: 1..SIZE;
  background: -SIZE..2*SIZE;
  status: enum {Occupied, Unavailable, Empty};

var
  board: array [foreground] of array [foreground] of status;
  numOfQueens: 0..SIZE;

function x1(i, j, d: foreground): background;
begin
  return d + i - j;
end;

function x2(i, j, d: foreground): background;
begin
  return i + i - x1(i, j, d);
end;

function inRange(some: background): boolean;
begin
  return 1 <= some & some <= SIZE;
end;

procedure setUnavailable(i, j: foreground);
begin
  if board[i][j] != Occupied then
    board[i][j] := Unavailable;
  endif;
end;

procedure printBoard();
begin
    for i: foreground do
      for j: foreground do
        if (board[i][j]) = Occupied then
          put "X";
        endif;
        if (board[i][j] = Unavailable) then
          put "-"
        endif;
        if (board[i][j] = Empty) then
          put "O"
        endif;
        put "  ";
      endfor;
      put "\n";
    endfor;

    put "........................";
    put "\n";
end;

procedure setDiagnalUnavailable(i, j, d: foreground);
begin
  if inRange(x1(i, j, d)) then
    setUnavailable(x1(i, j, d), d);
  endif;
  if inRange(x2(i, j, d)) then
    setUnavailable(x2(i, j, d), d);
  endif;
end;

procedure setRowColumnUnavailable(i, j, d: foreground);
begin
  setUnavailable(i, d);
  setUnavailable(d, j)
end;

ruleset i: foreground; j: foreground do
  rule "Place Queen" board[i][j] = Empty ==>
  begin
    board[i][j] := Occupied;
    numOfQueens := numOfQueens + 1;
    for d: foreground do
      setRowColumnUnavailable(i, j, d);
      setDiagnalUnavailable(i, j, d);
    endfor;

    if numOfQueens >= SIZE then
      printBoard();
    endif;
  endrule;
endruleset;

startstate
  begin
    for i: foreground; j: foreground do
      board[i][j] := Empty;
    endfor;

    numOfQueens := 0;
  endstartstate;

-- invariant "As if there is no solution"
--  numOfQueens < SIZE
