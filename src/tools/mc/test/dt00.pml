(* dt00.pml -- testing the handling of datatypes *)

datatype pt = PT of (float * float);

val zero = PT(0.0, 0.0);

fun add (p1, p2) = let
      val PT(x1, y1) = p1
      val PT(x2, y2) = p2
      in
	PT(x1+x2, y1+y2)
      end;

add (zero, zero)