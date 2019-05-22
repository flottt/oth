#include "myclock.h"


myclock::myclock()
{
	this->time = new mytime;
}


myclock::~myclock()
{
	delete this->time; 
	this->time = nullptr; 
}

mytime* myclock::operator ->() {
	return this->time;
}
