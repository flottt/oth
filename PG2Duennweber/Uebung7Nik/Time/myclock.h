#ifndef CLOCK_H
#define CLOCK_H
#include "mytime.h"

class myclock
{
	mytime* time;
public:
	myclock();
	~myclock();

	mytime* operator ->();
};

#endif // !CLOCK_H