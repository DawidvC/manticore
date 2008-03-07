(* pmergesort-ip.pml
 * 
 * COPYRIGHT (c) 2008 The Manticore Project (http://manticore.cs.uchicago.edu)
 * All rights reserved.
 *
 * Copying version of parallel mergesort using arrays.
 *)

    fun len (_, s1, s2) = s2-s1
;

    (* assume that b>a. *)
    fun binarySearch' (arr, a, b, x) = if (b = a)
        then a
        else let
          val p = (b+a) div 2
          val (a, b) = if (asub(arr,p) < x)
		          then (p+1, b)
		          else (a,   p)
          in
	      binarySearch'(arr, a, b, x)
          end
;

   (* find j such that arr[j] <= x <= arr[j+1] *)
    fun binarySearch (arr, a, b, x) = let
	val (a, b) = if (a < b) then (a, b) else (b, a)
        in
	    binarySearch' (arr, a, b, x)
        end
;

   (* copy l into d *)
    fun copy ( (dArr, d1, d2), (lArr, l1, l2) ) = let
	    val l = (lArr, l1, l2)
	    fun loop (i) = if (i >= 0)
                then (aupdate(dArr, d1+i, asub(lArr, l1+i));
		      loop(i-1))
                else ()
            in
	       loop(len(l)-1)
	    end
;

   (* merge sorted arrays arr[p..q] and arr[q..r] into the sorted array dArr[p..r] *)
    fun pMerge (dArr, arr, p, q, r) = let	
	fun loop (d, l, r) = (case (d, l, r)
			       of ((dArr, d1, d2), (lArr, l1, l2), (rArr, r1, r2)) =>
            if (len(l) < len(r))
	       then loop(d, r, l)
	    else if (len(l) = 0 orelse len(r) = 0)
	       then copy(d, l) 
	    else if (len(l) = 1)
	       then if (asub(lArr, l1) < asub(rArr, r1)) 
		       then (aupdate(dArr, d1,   asub(lArr, l1)); 
			     aupdate(dArr, d1+1, asub(rArr, r1))) 
		       else (aupdate(dArr, d1,   asub(rArr, r1)); 
			     aupdate(dArr, d1+1, asub(lArr, l1))) 
	    else let
               val lLen' = len(l) div 2
	       val j = binarySearch(rArr, r1, r2, asub(lArr, lLen' + l1)) 
	       val rLen' = j - r1
	       dval c1 = loop( (dArr, d1, lLen' + rLen' + d1), (lArr, l1, lLen' + l1), (rArr, r1, j) )
	       val c2 = loop( (dArr, lLen' + rLen'+ d1, d2), (lArr, lLen' + l1, l2), (rArr, j, r2) )
	       in
		    ()
	       end)
        in
	   loop( (dArr, p, r), (arr, p, q), (arr, q, r) )
	end
;

    fun pMergesort' (dArr, dArr', arr, p, r) = if (r-p > 1)
        then let
          val q = (p+r) div 2
          dval _ = pMergesort' (dArr', dArr, arr, p, q)
          val _ = pMergesort' (dArr', dArr, arr, q, r)
          in
             pMerge(dArr, dArr', p, q, r)
          end
        else aupdate(dArr, p, asub(arr, p)) 
;

   (* parallel merge sort *)
    fun pMergesort (arr) = let
	val dArr = array(alength(arr), asub(arr,0))
        val dArr' = array(alength(arr), asub(arr,0))
	in
	   pMergesort'(dArr, dArr', arr, 0, alength(arr));
	   dArr
        end
;

fun arr2s (elt2s, arr) = let
    val n = alength(arr)
    fun loop (i, str) = if (i >= 0)
        then loop(i-1, elt2s (asub(arr, i))^", "^str)
        else str
    in
        "["^loop(n-1, "")^"]"
    end
;

fun genRandomDoubleArr (n) = let
    val arr : double array = array(n, 0.0:double)
    fun loop (i) = if (i < n)
        then (aupdate(arr, i, drand(0.0:double, 100.0:double)); 
	      loop(i+1))
        else ()
    in
       loop(0);
       arr
    end
;

(* grab the input size x from stdin, generate a random array of length x, 
 * and sort it.
 *)
fun timeTest () = let
    val n = readint()

    val arr = genRandomDoubleArr(n)

(*    val _ = print (arr2s (dtos, arr)^"\n"); *)

    val b = gettimeofday ()
    val arr = pMergesort(arr)
    val e = gettimeofday ()
    in
(*        print (arr2s (dtos, arr)^"\n");*)
        print (dtos (e-b)^"\n")
    end
;

timeTest()