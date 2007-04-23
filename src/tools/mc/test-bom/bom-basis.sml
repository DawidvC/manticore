(* bom-basis.sml
 *
 * COPYRIGHT (c) 2007 The Manticore Project (http://manticore.cs.uchicago.edu)
 * All rights reserved.
 *
 * Predefined high-level operations and datatypes.
 *)

signature BASIS =
  sig

  (* predefined datatypes *)
    val signalTyc : BOMTy.tyc
    val listTyc : BOMTy.tyc
    val rdyqItemTyc : BOMTy.tyc

  (* predefined data constructors *)
    val preemptDC : BOMTy.data_con
    val consDC : BOMTy.data_con
    val rdyqConsDC : BOMTy.data_con

(*
    val qItemAlloc : HLOp.hlop  	(* allocate a queue item *)
    val qEnqueue : HLOp.hlop		(* insert an item [nonatomic] *)
    val qDequeue : HLOp.hlop 		(* remove an item [nonatomic] *)
    val qEmpty : HLOp.hlop		(* return true if queue is empty [nonatomic] *)

  (* concurrent queue operations *)
    val atomicQEnqueue : HLOp.hlop	(* insert an item [atomic] *)
    val atomicQDequeue : HLOp.hlop	(* remove an item [atomic] *)
*)

  (* scheduler operations *)
    val runOp : HLOp.hlop
    val forwardOp : HLOp.hlop
    val dequeueOp : HLOp.hlop
    val enqueue : HLOp.hlop

  end

structure Basis =
  struct

    structure BTy = BOMTy
    structure H = HLOp

    fun new (name, params, res, attrs) =
	  H.new(Atom.atom name, {params= List.map HLOp.PARAM params, results=res}, attrs)

  (* some standard parameter types *)
    val vprocTy = BTy.T_Any	(* FIXME *)
    val fiberTy = BTy.T_Cont[]
    val sigTy = BTy.T_Any	(* FIXME: really either Enum(0) or fiberTy *)
    val sigActTy = BTy.T_Cont[sigTy]
    val tidTy = BTy.T_Any

  (* ready queue items *)
    val rdyqItemTyc = BOMTyCon.newDataTyc ("rdyq_item", 1)
    val rdyqItemTy = BTy.T_TyCon rdyqItemTyc
    val rdyqConsDC = BOMTyCon.newDataCon rdyqItemTyc
	  ("QITEM", BTy.Transparent, BTy.T_Tuple[tidTy, fiberTy, rdyqItemTy])

(*
    val qItemAlloc of var * var list	(* allocate a queue item *)
    val qEnqueue of (var * var) 	(* insert an item [nonatomic] *)
    val qDequeue of var 		(* remove an item [nonatomic] *)
    val qEmpty of var			(* return true if queue is empty [nonatomic] *)

  (* concurrent queue operations *)
    val atomicQEnqueue of (var * var)	(* insert an item [atomic] *)
    val atomicQDequeue of var		(* remove an item [atomic] *)
*)

  (* scheduler operations *)
    val runOp = new("run", [vprocTy, sigActTy, fiberTy], [], [H.NORETURN])
    val forwardOp = new("forward", [vprocTy, sigTy], [], [H.NORETURN])
    val dequeueOp = new("dequeue", [vprocTy], [rdyqItemTy], [])
    val enqueue = new("enqueue", [vprocTy, tidTy, fiberTy], [], [])

  (* other predefined datatypes *)
    val signalTyc = BOMTyCon.newDataTyc ("signal", 1)
    val preemptDCon = BOMTyCon.newDataCon signalTyc ("PREEMPT", BTy.Transparent, fiberTy)
    val listTyc = BOMTyCon.newDataTyc ("list", 1)
    val listTy = BTy.T_TyCon listTyc
    val consTyc = BOMTyCon.newDataCon listTyc
	  ("CONS", BTy.Transparent, BTy.T_Tuple[BTy.T_Any, listTy])

  end
