#include <iostream>
#include <random>

const float schema[] = { 1.0, 1.3, 1.7, 2.0, 2.3, 2.7, 3.0, 3.3, 3.7, 4.0, 5.0 }; 
class scores 
{ 
private:
	std::mt19937 *gen; 
	std::uniform_int_distribution<int> *dist; 
	float *results;  
	int number; 
public: 
	explicit scores(int);
	scores(const scores& s);
	~scores();
	void print() const; 

	void operator =(scores& s);
};