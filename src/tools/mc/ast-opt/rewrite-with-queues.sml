(* rewrite-with-queues.sml
 *
 * COPYRIGHT (c) 2007 The Manticore Project (http://manticore.cs.uchicago.edu)
 * All rights reserved.
 *
 * Some operations in Manticore require a work queue which is not immediately
 * visible in the surface program. This module provides a pass to rewrite 
 * those operations with a queue as needed.
 *)

structure RewriteWithQueues : sig

    val transform : AST.exp -> AST.var * AST.ty list -> AST.exp option

  end = struct

    structure A = AST
    structure B = Basis
    structure T = Types
    structure U = UnseenBasis
 		
  (* FIXME This obviously wants to be developed into a more general mechanism. *)

  (* sumP : A.exp * A.ty list -> A.exp *)				  
    fun sumP (q, ts) = 
	let val t = TypeOf.exp (A.VarExp (B.sumP, ts))
	in
	    A.ApplyExp (A.VarExp (U.sumPQ, []), q, t)
	end

  (* reduceP : A.exp * A.ty list => A.exp *)
    fun reduceP (q, ts) = 
      (case ts
	 of [alpha, beta] => 
	      let val t = TypeOf.exp (A.VarExp (B.reduceP, ts))
	      in
		  A.ApplyExp (A.VarExp (U.reducePQ, ts), q, t)
	      end
	  | _ => raise Fail "reduceP: expected two type args"
        (* end case *))

  (* transform : A.exp -> A.var * A.ty list -> A.exp option *)
    fun transform q (x, ts) =
	  if Var.same (x, B.sumP) then 
	      SOME (sumP (q, ts))
	  else if Var.same (x, B.reduceP) then
	      SOME (reduceP (q, ts))
	  else 
	      NONE
	
  end
