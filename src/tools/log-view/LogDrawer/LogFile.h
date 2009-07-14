/** \file LogFile.h
 * \author Korei Klein
 * \date 7/10/09
 
 Define the internal representation of a logfile.
 */

#import <Cocoa/Cocoa.h>
#import "LogView.h"
struct _LogFileHeader_t;

// union _LogTS_t;


/// Represents the data in a logfile
@interface LogFile : NSObject {
    NSString *filename; ///< Name of the represented log file
    struct _LogFileHeader_t *header; ///< the header of the log file, as defined in log-file.h
    NSMutableArray *vProcs; ///< an array containing header.nVProcs VProcs

    // These variables are to provide more convinient representations of some
    // things already found in the header
    // They must therefore be properly initialized when file is read

    NSString *date; ///< Cache of header.date is string format as reported by ctime(3)
    NSString *clockName; ///< Cache of header.clockName
    
}


/// Initialize using a file and a description of it
/** Initialize
 * \param filename name of the log file to represent
 * \param desc the description of the log file format and semantics
 * \return the initialized LogView
 */
- (LogFile *)initWithFilename:(NSString *)filename andLogFileDesc:(void *)desc;

/// Initialize using only filenames
/** Initialize
 * \param filename name of the log file to represent
 * \param eventDesc the jason file describing the format of events in the log
 * \param logDesc the jason file describing the semantics of events in the log
 * \return the initialized LogView
 */
- (LogFile *)initWithFilename:(NSString *)filename
	 andEventDescFilename:(NSString *)eventDesc
	   andLogDescFilename:(NSString *)logDesc;

@property (readonly) NSString	*filename;
@property (readonly) NSMutableArray *vProcs;

@property (readonly) NSString *date;
@property (readonly) NSString *clockName;


@property (readonly) uint64_t	magic;		///< to identify log files
@property (readonly) uint32_t	majorVersion;   ///< version info
@property (readonly) uint32_t	minorVersion;   ///< version info
@property (readonly) uint32_t	patchVersion;   ///< version info
@property (readonly) uint32_t	hdrSzB;		///< size of the header struct
@property (readonly) uint32_t	bufSzB;		///< buffer size (usually == sizeof(struct_logbuf))
//@property (readonly) char *		date;		///< the date of the run (as reported by ctime(3))
@property (readonly) uint32_t	tsKind;		///< timestamp format
// @property (readonly) union _LogTS_t	startTime;	///< start time for run
// @property (readonly) char *		clockName;	///< a string describing the clock
@property (readonly) uint32_t	resolution;	///< clock resolution in nanoseconds
@property (readonly) uint32_t	nVProcs;	///< number of vprocs in system
@property (readonly) uint32_t	nCPUs;		///< number of CPUs in system

@end

