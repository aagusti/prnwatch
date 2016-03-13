{
DblRect:
This unit defines point and rect types which store their boundaries as doubles, plus some routines
to work with these types.
Author: Dr. Peter Below
Version 1.0 created 22.02.1997
Version 1.01 created 04.12.2001, added InflateDoubleRect and modified comments for Time2Help.
Current revision: 1.01
Last modified: 4 Dezember 2001
}

{$BOOLEVAL OFF} {Unit depends on shortcut boolean evaluation}
unit DblRect;

interface

uses
  WinTypes;

type
  TDoublePoint = record
    X, Y: Double;
  end;
  TDoubleRect = record
    case Byte of
      0: (Left, Top, Right, Bottom: Double);
      1: (topleft, bottomright: TDoublePoint);
      2: (X1, Y1, X2, Y2: Double);
  end;

const
  EmptyDoubleRect: TDoubleRect = (Left: 0.0; Top: 0.0; Right: 0.0; Bottom: 0.0);
  EmptyPoint: TDoublePoint = (X: 0.0; Y: 0.0);
  DefaultEpsilon: Double = 1.0e-8;

//{$IFDEF WIN32}
//var
//{$ENDIF}

function DoublePoint(const aX, aY: Double): TDoublePoint;
function AreDoublePointsEqual(const P1, P2: TDoublePoint): Boolean;
procedure OffsetDoublePoint(var P: TDoublePoint; dx, dy: Double);
procedure ScaleDoublePoint(var P: TDoublePoint; factor: DOuble);
function DoublePointDistance(const P1, P2: TDoublePoint): Double;
function PointFromDoublePoint(const P: TDoublePoint): TPoint;
function DoublePointFromPoint(const P: TPoint): TDoublePoint;
function DoubleRect(const L, T, R, B: Double): TDoubleRect;
procedure VerifyDoubleRect(var R: TDoubleRect);
function AreDoubleRectsEqual(const R1, R2: TDoubleRect): Boolean;
procedure OffsetDoubleRect(var R: TDoubleRect; dx, dy: Double);
procedure ScaleDoubleRect(var R: TDoubleRect; cx, cy: Double);
procedure InflateDoubleRect(var R: TDoubleRect; dx, dy: Double);
procedure IntersectDoubleRect(const R1, R2: TDoubleRect; var isect: TDoubleRect);
function IsDoubleRectEmpty(const R: TDoubleRect): Boolean;
function RectFromDoubleRect(const R: TDoubleRect): TRect;
function DoubleRectFromRect(const R: TRect): TDoubleRect;
function DoublePointInRect(const P: TDOublePoint; const R: TDoubleRect): Boolean;
function ULeft(const R: TDoubleRect): TDoublePoint;
function URight(const R: TDoubleRect): TDoublePoint;
function LLeft(const R: TDoubleRect): TDoublePoint;
function LRight(const R: TDoubleRect): TDoublePoint;

implementation

{Returns a TDoublePoint constructed from the passed coordinates.}

function DoublePoint(const aX, aY: Double): TDoublePoint;
begin
  with Result do
  begin
    X := aX;
    Y := aY;
  end;
end;

{Compares the two passed points and returns true if they are considered equal, false otherwise.
The points are equal if their coordinates differ less than the DefaultEpsilon.}

function AreDoublePointsEqual(const P1, P2: TDoublePoint): Boolean;
begin
  Result := (Abs(P1.X - P2.X) < DefaultEpsilon) and (Abs(P1.Y - P2.Y) <
    DefaultEpsilon);
end;

{: Moves the passed point by the passed increments.}

procedure OffsetDoublePoint(var P: TDoublePoint; dx, dy: Double);
begin
  with P do
  begin
    X := X + dx;
    Y := Y + dy;
  end;
end;

{Multiplies the passed points coordinates by factor.}

procedure ScaleDoublePoint(var P: TDoublePoint; factor: DOuble);
begin
  with P do
  begin
    X := X * factor;
    Y := Y * factor;
  end;
end;

{Returns the distance between the passed points. This will always be a positive number.}

function DoublePointDistance(const P1, P2: TDoublePoint): Double;
begin
  Result := Sqrt(Sqr(P1.X - P2.X) + Sqr(P1.Y - P2.Y));
end;

{Converts the passed TDoublePoint to a TPoint and returns the result.}

function PointFromDoublePoint(const P: TDoublePoint): TPoint;
begin
  with Result do
  begin
    X := Round(P.X);
    Y := Round(P.Y);
  end;
end;

{Converts the passed TPoint to a TDoublePoint and returns the result.}

function DoublePointFromPoint(const P: TPoint): TDoublePoint;
begin
  with Result do
  begin
    X := P.X;
    Y := P.Y;
  end;
end;

{Returns a TDoubleRect made from the passed parameters. Makes certain that the resulting rect meets the criteria Left < Right and Top < Bottom, boundaries may be swapped to achieve this.}

function DoubleRect(const L, T, R, B: Double): TDoubleRect;
begin
  with Result do
  begin
    if L <= R then
    begin
      Left := L;
      Right := R;
    end
    else
    begin
      Left := R;
      Right := L;
    end;
    if T <= B then
    begin
      Top := T;
      Bottom := B;
    end
    else
    begin
      Top := B;
      Bottom := T;
    end;
  end;
end;

{Makes sure the passed rectangle meets the constraints Left < Right and Top < Bottom.
If needed, boundaries will be swapped.}

procedure VerifyDoubleRect(var R: TDoubleRect);
var
  temp: Double;
begin
  with R do
  begin
    if Left > Right then
    begin
      temp := Left;
      Left := right;
      Right := temp;
    end;
    if Top > Bottom then
    begin
      temp := Top;
      Top := Bottom;
      Bottom := temp;
    end;
  end;
end;

{Returns True if the two passed rects R1 and R2 are equal, false otherwise. Equal in this case means that each of the four coordinates of P1 has a difference of less than DefaultEpsilon from the corresponding coordinate of P2.}

function AreDoubleRectsEqual(const R1, R2: TDoubleRect): Boolean;
begin
  Result := (Abs(R1.X1 - R2.X1) < DefaultEpsilon) and (Abs(R1.Y1 - R2.Y1) <
    DefaultEpsilon) and
    (Abs(R1.X2 - R2.X2) < DefaultEpsilon) and (Abs(R1.Y2 - R2.Y2) < DefaultEpsilon);
end;

{Moves the passed rectangle by the given increments.}

procedure OffsetDoubleRect(var R: TDoubleRect; dx, dy: Double);
begin
  with R do
  begin
    X1 := X1 + dx;
    Y1 := Y1 + dy;
    X2 := X2 + dx;
    Y2 := Y2 + dy;
  end;
end;

{Scales the passed rectangle by the factors given. This changes only the size of the rectangle, the upper left corner coordinates stay fixed.}

procedure ScaleDoubleRect(var R: TDoubleRect; cx, cy: Double);
begin
  with R do
  begin
    X2 := (X2 - X1) * cx + X1;
    Y2 := (Y2 - Y1) * cy + Y1;
  end;
end;

{
InflateDoubleRect:
Change the size of a double rect.
Param R is the rect to change
Param dx is the horizontal size increment to apply
Param dy is the vertical size increment to apply
Like the API function InflateRect this procedure will subtract dx from the r.left, add dx to r.right, subtract dy
from r.top and add dy to r.bottom. So the rectangle width and height changes by 2 times the increment.
Created 04.12.2001 by P. Below
}

procedure InflateDoubleRect(var R: TDoubleRect; dx, dy: Double);
begin
  r.Left := r.Left - dx;
  r.Right := r.Right + dx;
  r.Top := r.Top - dy;
  r.Bottom := r.Bottom + dy;
end;

{Calculates the intersection of the two rectangles passed and returns the result in isect. The result will be empty if the rectangles are disjunct. Note that this procedure assumes that the rectangles obey the constraints Left <= Right and Top <= Bottom !}

procedure IntersectDoubleRect(const R1, R2: TDoubleRect; var isect: TDoubleRect);
begin
  if (R1.Left > R2.Right) or (R1.Right < R2.Left) or (R1.Top > R2.Bottom) or (R1.Bottom
    < R2.Top) then
  begin
    {The two rectangles do not intersect}
    isect := EmptyDoubleRect;
  end
  else
  begin
    {Figure out placement of left border of result rectangle, which is the rightmost of the two left borders of the source rectangles.}
    if R1.Left < R2.Left then
      isect.Left := R2.Left
    else
      isect.Left := R1.Left;
    {Figure out placement of top border of result rectangle, which is the bottommost of the two top borders of the source rectangles.}
    if R1.Top < R2.Top then
      isect.Top := R2.Top
    else
      isect.Top := R1.Top;
    {Figure out placement of right border of result rectangle, which is the leftmost of the two Right borders of the source rectangles.}
    if R1.Right > R2.Right then
      isect.Right := R2.Right
    else
      isect.Right := R1.Right;
    {Figure out placement of Bottom border of result rectangle, which is the topmost of the two Bottom borders of the source rectangles.}
    if R1.Bottom > R2.Bottom then
      isect.Bottom := R2.Bottom
    else
      isect.Bottom := R1.Bottom;
  end;
end;

{Returns True if the passed rect spans no area, meaning the TopLeft and BottomRight corners are equal inside the precision given by the default threshold value DefaultEpsilon}

function IsDoubleRectEmpty(const R: TDoubleRect): Boolean;
begin
  Result := AreDoublePointsEqual(R.TopLeft, R.BottomRight);
end;

{Constructs a TRect from the passed TDoubleRect and returns it. The standard Round function is used to convert floating point to integer.}

function RectFromDoubleRect(const R: TDoubleRect): TRect;
begin
  with Result do
  begin
    Left := Round(R.Left);
    Top := Round(R.Top);
    Right := Round(R.Right);
    Bottom := Round(R.Bottom);
  end;
end;

{Constructs a TDoubleRect from the passed rect, validates it and returns it.}

function DoubleRectFromRect(const R: TRect): TDoubleRect;
begin
  with Result do
  begin
    Left := R.Left;
    Top := R.Top;
    Right := R.Right;
    Bottom := R.Bottom;
  end;
  VerifyDoubleRect(Result);
end;

{Performs a point-in-rectangle test and returns True, if the passed point is inside the rectangle or on one of its borders, false otherwise. The rectangle must meet the constraints  Left <= Right and Top <= Bottom !}

function DoublePointInRect(const P: TDOublePoint; const R: TDoubleRect): Boolean;
begin
  with R, P do
  begin
    Result := (X >= Left) and (X <= Right) and (Y >= Top) and (Y <= Bottom);
  end;
end;

{Returns the upper left corner of the passed rectangle}

function ULeft(const R: TDoubleRect): TDoublePoint;
begin
  Result := R.TopLeft;
end;

{Returns the upper right corner of the passed rectangle}

function URight(const R: TDoubleRect): TDoublePoint;
begin
  with R, Result do
  begin
    X := Right;
    Y := Top;
  end;
end;

{Returns the lower left corner of the passed rectangle}

function LLeft(const R: TDoubleRect): TDoublePoint;
begin
  with R, Result do
  begin
    X := Left;
    Y := Bottom;
  end;
end;

{Returns the lower right corner of the passed rectangle}

function LRight(const R: TDoubleRect): TDoublePoint;
begin
  Result := R.BottomRight;
end;

end.
