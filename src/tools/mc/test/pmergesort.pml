fun parrString a =
  let val len = plen a
      fun build (curr, acc) =
        if curr=len
        then rev acc
        else build (curr+1, (itos (a!curr)) :: acc)
  in
      "[" ^ (concatWith (",", build (0, nil))) ^ "]"
  end
;

fun valOf opt = (case opt
		  of NONE => fail "option"
		   | SOME v => v)
;

fun len (s1, s2) = s2-s1;

fun psub (arr,p = arr!p

(* assume that b>a. *)
fun binarySearch' (arr, a, b, x) = if (b = a)
        then a
        else let
          val p = (b+a) div 2
          val (a, b) = if (psub(arr,p) < x)
		          then (p+1, b)
		          else (a,   p)
          in
	      binarySearch'(arr, a, b, x)
          end

fun binarySearch (arr, a, b, x) = let
	val (a, b) = if (a < b) then (a, b) else (b, a)
        in
	    binarySearch' (arr, a, b, x)
        end

fun pMerge (lArr, rArr) = let
        fun loop ( l as (lArr, l1, l2), r as (rArr, r1, r2) ) =
	    if (len(l) < len(r))
  	       then loop(r, l)
	    else if (len(l) = 0 orelse len(r) = 0)
	       then pappend(psubseq(l), psubseq(r))
	    else if (len(l) = 1)
	       then if (psub(lArr,l1) < psub(rArr,r1))
	               then [| psub(lArr,l1), psub(rArr,r1) |]
		       else [| psub(rArr,r1), psub(lArr,l1) |]
	    else let
	       val lPvt = len(l) div 2 + l1
	       val j = binarySearch(rArr, r1, r2, psub(lArr,lPvt))
	       val c1 = loop( (lArr, l1, lPvt), (rArr, r1, j) )
	       val c2 = loop( (lArr, lPvt, l2), (rArr, j, r2) )
	       in
		    pappend(c1, c2)
	       end
        in
            loop( (lArr, 0, plen(lArr)), (rArr, 0, plen(rArr)) )
        end

fun pMergesort (arr) = if (plen(arr) = 1)
        then arr
        else let
	  val (lArr, rArr) = psplit(arr)
	  pval lArr = pMergesort(lArr)
	  val rArr = pMergesort(rArr)
	  in
	     pMerge(lArr, rArr)
	  end

val arr = [| 1, 3, 10, 15, 100 |];
val pOpts = [| valOf (binarySearch(arr, 0, plen arr-1, i)) | i in arr |];

()