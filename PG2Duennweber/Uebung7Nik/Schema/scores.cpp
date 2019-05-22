#include "scores.h"

scores::scores(int number): gen(new std::mt19937{std::random_device()()}), dist(new std::uniform_int_distribution<int>{ 0, 10 }), results(new float[this->number = number])
{
	std::cout << "Simple Constructor scores(int " << number << ")" << std::endl;
	for (int i = 0;  i < number;  ++i)
		results[i] = schema[(*dist)(*gen)];
}

//Gleiche Zufaelle => scores::scores(const scores& s): gen(new std::mt19937(*s.gen)), dist(new std::uniform_int_distribution<int>(*s.dist)), results(nullptr)   
scores::scores(const scores& s): gen(new std::mt19937{ std::random_device()() }), dist(new std::uniform_int_distribution<int>{ s.dist->min(), s.dist->max() }), results(nullptr)
{
	std::cout << "Copy Constructor scores(scores [" << s.number << "])" << std::endl;
	this->results = new float[s.number];
	this->number = s.number;

	//this->gen = s.gen;
	//this->dist = s.dist;
	for (int i = 0; i < this->number; ++i)
	{
		results[i] = s.results[i];
	}
}

scores::~scores() 
{
	std::cout << "Destructor scores() ...";
	delete gen; 
	delete dist; 
	delete[] results;
	std::cout << " completed. " << std::endl;
}

void scores::print() const {
	for (int i = 0;  i < number;  ++i)
		std::cout << results[i] << " ";
	std::cout << std::endl; 
}

void scores::operator =(scores& s) {
	std::cout << "Assignment Operator" << std::endl;
	if (this == &s) {
		return; 
	} else if (this->number != s.number) {
		delete[] this->results; 
		this->results = new float[s.number]; 
		this->number = s.number; 
	}
	for (int i = 0; i < s.number; ++i) {
		this->results[i] = s.results[i]; 
	}
	//leave random generators untouched 
}