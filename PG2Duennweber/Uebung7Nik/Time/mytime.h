#ifndef MYTIME_H
#define MYTIME_H
#include <iostream>
#include <ctime>

class mytime 
{
private:
	int hour, min, sec;
	friend std::ostream &operator <<(std::ostream &, const mytime &);
	friend bool operator <=(const mytime &, const mytime &);
	friend bool operator >=(const mytime &, const mytime &);
	friend bool operator !=(const mytime &, const mytime &);
	friend unsigned int operator -(const mytime &, const mytime &);

public:
	mytime();
	mytime(int h, int m = 0, int s = 0);
	~mytime();
	void setTime(int h, int m, int s);
	mytime operator +(unsigned int) const;
	mytime &operator +=(unsigned int);
	mytime &operator ++();   // prefix version
	mytime operator ++(int);  // postfix version
	mytime operator -(unsigned int) const;
	mytime &operator -=(unsigned int);
	mytime &operator --();   // prefix version
	mytime operator --(int);  // postfix version

	bool operator ==(const mytime &) const;
	bool operator <(const mytime &) const;
	bool operator >(const mytime &) const;


	//new operators
	int operator()()const;
	friend mytime operator, (const mytime& t1, const mytime& t2);

	//friend void* operator new(size_t size);
	//friend void operator delete (void* v);

	void print() {
		std::cout << hour << ":" << min << ":" << sec << "\n";
	}

};

#endif // !MYTIME_H