#include "sd_io.h"

static FIL fil;		/* File object */
static FATFS fatfs;
/*
 * To test logical drive 0, FileName should be "0:/<File name>" or
 * "<file_name>". For logical drive 1, FileName should be "1:/<file_name>"
 */
static char FileName[32] = "Test.bin";
static char *SD_File;

#ifdef __ICCARM__
#pragma data_alignment = 32
u8 DestinationAddress[10*1024];
#pragma data_alignment = 32
u8 SourceAddress[10*1024];
#else
u8 DestinationAddress[10*1024] __attribute__ ((aligned(32)));
u8 SourceAddress[10*1024] __attribute__ ((aligned(32)));
#endif

void init_sdcard () {
	FRESULT Res;
	UINT NumBytesRead;
	UINT NumBytesWritten;
	u32 BuffCnt;
	BYTE work[FF_MAX_SS];
	u32 FileSize = (8*1024);

	/*
	 * To test logical drive 0, Path should be "0:/"
	 * For logical drive 1, Path should be "1:/"
	 */
	TCHAR *Path = "0:/";

	for(BuffCnt = 0; BuffCnt < FileSize; BuffCnt++){
		SourceAddress[BuffCnt] = 7 + BuffCnt;
	}

	/*
	 * Register volume work area, initialize device
	 */
	Res = f_mount(&fatfs, Path, 0);

	if (Res != FR_OK) {
		return XST_FAILURE;
	}

	/*
		 * Path - Path to logical driver, 0 - FDISK format.
		 * 0 - Cluster size is automatically determined based on Vol size.
		 */
		Res = f_mkfs(Path, FM_FAT32, 0, work, sizeof work);
		if (Res != FR_OK) {
			return XST_FAILURE;
		}

		/*
		 * Open file with required permissions.
		 * Here - Creating new file with read/write permissions. .
		 * To open file with write permissions, file system should not
		 * be in Read Only mode.
		 */
		SD_File = (char *)FileName;

		Res = f_open(&fil, SD_File, FA_CREATE_ALWAYS | FA_WRITE | FA_READ);
		if (Res) {
			return XST_FAILURE;
		}

		/*
		 * Pointer to beginning of file .
		 */
		Res = f_lseek(&fil, 0);
		if (Res) {
			return XST_FAILURE;
		}

		/*
		 * Write data to file.
		 */
		Res = f_write(&fil, (const void*)SourceAddress, FileSize,
				&NumBytesWritten);
		if (Res) {
			return XST_FAILURE;
		}

		/*
		 * Pointer to beginning of file .
		 */
		Res = f_lseek(&fil, 0);
		if (Res) {
			return XST_FAILURE;
		}

		/*
		 * Read data from file.
		 */
		Res = f_read(&fil, (void*)DestinationAddress, FileSize,
				&NumBytesRead);
		if (Res) {
			return XST_FAILURE;
		}

		/*
		 * Data verification
		 */
		for(BuffCnt = 0; BuffCnt < FileSize; BuffCnt++){
			if(SourceAddress[BuffCnt] != DestinationAddress[BuffCnt]){
				return XST_FAILURE;
			}
		}

		/*
		 * Close file.
		 */
		Res = f_close(&fil);
		if (Res) {
			return XST_FAILURE;
		}

		return XST_SUCCESS;
}