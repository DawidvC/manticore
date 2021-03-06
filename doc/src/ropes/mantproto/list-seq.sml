(* list-seq.sml
 *
 * COPYRIGHT (c) 2008 The Manticore Project (http://manticore.cs.uchicago.edu)
 * All rights reserved.
 *
 * List sequences.
 * 
 * Authors:
 *   Mike Rainey (mrainey@cs.uchicago.edu)
 *   Adam Shaw (ams@cs.uchicago.edu)
 *
 *)

structure ListSeq : SEQ = 
  struct
    type 'a seq = 'a list
    val empty = List.nil
    fun singleton s = s :: List.nil
    val isEmpty = List.null
    val length = List.length
    val sub = List.nth
    fun concat (x, y) = x @ y
    fun splitAt (ls, i) = (List.take(ls, i+1), List.drop(ls, i+1))
    fun fromList x = x
    fun toList x = x 
    val rev = List.rev
    val map = List.map
    val foldl = List.foldl
    val foldr = List.foldr
    val take = List.take
    val drop = List.drop
    fun cut (s, n) = (List.take (s, n), List.drop (s, n))
    val filter = List.filter
  end
