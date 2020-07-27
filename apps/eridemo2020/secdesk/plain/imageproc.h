#ifndef _IMAGEPROC_H_
#define _IMAGEPROC_H_

#include <string.h>

#define __STUBBED 1

#ifndef __STUBBED
#define RECOGNIZER_MODULE "recognize_local"
#include <stdio.h>
#include <python3.7/Python.h>
#endif 

int start_imageprocessor(void);
int stop_imageprocessor(void);
int start_recognizer(void);
int stop_recognizer(void);

int get_features(char *imagefile, double embedding[static 128]);
int recognize(double embedding[static 128]);

#endif /* _IMAGEPROC_H_ */

