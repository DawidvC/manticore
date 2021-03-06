/* internal-heap.h
 *
 * COPYRIGHT (c) 2007 The Manticore Project (http://manticore.cs.uchicago.edu)
 * All rights reserved.
 *
 * Internal heap data structures.
 */

#ifndef _INTERNAL_HEAP_H_
#define _INTERNAL_HEAP_H_

#include "manticore-rt.h"
#include "heap.h"

typedef enum {
    FREE_CHUNK,			/*!< chunk that is available for allocation */
    TO_SP_CHUNK,		/*!< to-space chunk in the global heap */
    FROM_SP_CHUNK,		/*!< from-space chunk in the global heap */
    VPROC_CHUNK_TAG,		/*!< low four bits of VProc chunk (see #VPROC_CHUNK) */
    UNMAPPED_CHUNK		/*!< special status used for the dummy chunk that
				 *   represents unmapped regions of the memory space.
				 */
} Status_t;

#define VPROC_CHUNK(id)		((Status_t)((id) << 4) | VPROC_CHUNK_TAG)
#define IS_VPROC_CHUNK(sts)	(((sts)&0xF) == VPROC_CHUNK_TAG)

struct struct_chunk {
    void *  allocBase;  /*!< base address (unaligned!) of original allocation */
    Addr_t	baseAddr;	/*!< chunk base address */
    Addr_t	szB;		/*!< chunk size in bytes */
    Addr_t	usedTop;	/*!< [baseAddr..usedTop) is the part of the
				 *   chunk in use
				 */
    MemChunk_t	*next;		/*!< link field */
    Status_t	sts;		/*!< current status of chunk */
    int		where;		/*!< the node of the vproc that allocated
				 *   this chunk.
				 */
    Addr_t      scanProgress;  /*!< used only for the current alloc chunk
                     to track if it has been partially scanned */
};

typedef struct {
    Mutex_t lock;      //! lock to protect per-node data
    Cond_t   scanWait;    //! used to wait for a chunk to scan
    volatile int numWaiting;   //! number of vprocs waiting for a chunk to scan
    volatile bool completed;       //! no chunks remain
    MemChunk_t *scannedTo;   //! Chunks that have been scanned during global GC
    MemChunk_t *unscannedTo; //! Allocated chunks not yet scanned
    MemChunk_t *fromSpace;   //! Prior to-space chunks that will become free at
      //! the end of global GC
    MemChunk_t *freeChunks;  //!< free chunks allocated on this node
} NodeHeap_t;

/********** Global heap **********/

/* default global-heap-size constants */
#ifndef NDEBUG
#  define BASE_GLOBAL_HEAP_SZB	HEAP_CHUNK_SZB
#  define PER_VPROC_HEAP_SZB	HEAP_CHUNK_SZB
#else
#  define BASE_GLOBAL_HEAP_SZB	(ONE_K * ONE_MEG)
#  define PER_VPROC_HEAP_SZB	(32 * ONE_MEG)
#endif

extern Mutex_t		HeapLock;	/*!< lock for protecting heap data structures */
extern Addr_t		GlobalVM;	/*!< amount of memory allocated to Global heap
					 *  (including free chunks). */
extern Addr_t		FreeVM;		/*!< amount of free memory in free list */
extern Addr_t		ToSpaceSz;	/*!< amount of memory being used for to-space */
extern Addr_t		ToSpaceLimit;	/*!< if ToSpaceSz exceeds this value, then do a
					 * global GC */
extern Addr_t		TotalVM;	/*!< total memory used by heap (including vproc
					 * local heaps) */
extern NodeHeap_t   *NodeHeaps; /*!< list of per-node heap information */

extern Addr_t		HeapScaleNum;
extern Addr_t		HeapScaleDenom;
extern Addr_t		BaseHeapSzB;
extern Addr_t		PerVprocHeapSzb;

extern void UpdateBIBOP (MemChunk_t *chunk);

extern void FreeChunk (MemChunk_t *);

/* GC routines */
extern void InitGlobalGC ();
extern void StartGlobalGC (VProc_t *self, Value_t **roots);
extern MemChunk_t *PushToSpaceChunks (VProc_t *vp, MemChunk_t *scanChunk, bool inGlobal);

/* GC debugging support */
#ifndef NDEBUG
typedef enum {
    GC_DEBUG_ALL	= 4,		/* all debug messages (including promotions) */
    GC_DEBUG_MINOR	= 3,
    GC_DEBUG_MAJOR	= 2,
    GC_DEBUG_GLOBAL	= 1,
    GC_DEBUG_NONE	= 0
} GCDebugLevel_t;

extern GCDebugLevel_t	GCDebug;	//!\brief Flag that controls GC debugging output
extern GCDebugLevel_t	HeapCheck;	//!\brief Flag that controls heap checking

#define GC_DEBUG_DEFAULT "major"	/* default level */
#define HEAP_DEBUG_DEFAULT "global"	/* default level */
#endif

#endif /* !_INTERNAL_HEAP_H_ */
