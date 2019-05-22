#include "mytime.h"

mytime operator, (const mytime& t1, const mytime& t2) 
{
	mytime newt{};
	newt.setTime((t1.hour+t2.hour)/2, (t1.min + t2.min) / 2, (t1.sec + t2.sec) / 2);
	return newt;
}

std::ostream &operator <<(std::ostream &o, const mytime &t) 
{
	o << t.hour << ":" << t.min << ":" << t.sec << "\n";
	return o;
}


mytime::mytime() 
{
	this->hour = 0;
	this->min = 0;
	this->sec = 0;
}

mytime::mytime(int h, int m, int s) : hour(h), min(m), sec(s) 
{

}

mytime::~mytime() 
{

}

void mytime::setTime(int h, int m, int s) 
{
	this->hour = h;
	this->min = m;
	this->sec = s;
}

mytime mytime::operator +(unsigned int toadd) const 
{
	mytime t(toadd);
	return t;
}

int mytime::operator()()const 
{
	time_t rawtime= time(NULL);
	struct tm* timeinfo = 0;
	localtime_s(timeinfo, &rawtime);
	
	return ((timeinfo->tm_hour - this->hour) * 60 * 60) + ((timeinfo->tm_min - this->min) * 60) + (timeinfo->tm_sec - this->sec);
}

void* operator new(size_t size)
{
	std::cout << size << " bytes alloziert\n";
	void *p = malloc(size);
	return (p);

}

void operator delete(void* v) {
	std::cout << sizeof(v) << " bytes free\n";
	free (v);
}