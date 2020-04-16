#include "sd_io.h"

static FIL fil;		/* File object */
static FATFS fatfs;
/*
 * To test logical drive 0, FileName should be "0:/<File name>" or
 * "<file_name>". For logical drive 1, FileName should be "1:/<file_name>"
 */

const u32 param_file_size = (8*1024);
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

int init_sdcard () {
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

		return XST_SUCCESS;
}



char * get_param(char * param_name) {
	FRESULT Res;
	FIL file;
	Res = f_open(&file, param_name, FA_CREATE_ALWAYS | FA_WRITE | FA_READ);
	if (Res) {
		return 1;
	}
	Res = f_lseek(&file, 0);
	if (Res) {
		return 2;
	}

	unsigned int NumBytesRead;
	char * param = calloc(sizeof(char), 10*1024);
	printf("Read Before (max %d bytes): %s\n", param_file_size, DestinationAddress);
	Res = f_read(&file, (void*)DestinationAddress, param_file_size, &NumBytesRead);
	if (Res) {
		return "Error";
	}
	Res = f_close(&file);
	if (Res) {
		return 4;
	}

	printf("Read After (read %d bytes): %s\n", NumBytesRead, DestinationAddress);
	return param;
}

int set_param(char * param_name, char * param_val) {
	FRESULT Res;
	FIL file;
	Res = f_open(&file, param_name, FA_CREATE_ALWAYS | FA_WRITE | FA_READ);
	if (Res) {
		return 1;
	}
	Res = f_lseek(&file, 0);
	if (Res) {
		return 2;
	}

	/*
	 * Write data to file.
	 */

	printf("Setting (before): %s\n", param_val);
	u32 NumBytesWritten;
	Res = f_write(&file, (const void*)SourceAddress, param_file_size,
			&NumBytesWritten);
	printf("Wrote (%d bytes, status %d): %s\n", NumBytesWritten, Res, param_val);
	if (Res) {
		return 3;
	}
	Res = f_close(&file);
	if (Res) {
		return Res;
	}
	return NumBytesWritten;
}
