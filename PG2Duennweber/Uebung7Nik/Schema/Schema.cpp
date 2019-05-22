#include <iostream>
#include "scores.h"
#include <conio.h>

int mainSchema()
{
	scores s1{ 10 };
	s1.print();
	scores s2{s1};
	s2.print();
	scores s3(1);
	s3 = s2; 
	s3.print();
	std::cout << "---" << std::endl;

	scores s4{ 12 }; 
	s4.print();

	//scores sExplicit = 13; //durch explicit verhindert

	return 0; 
}

int main(void) {
	int returnresult = mainSchema(); 
	char cc; 
	std::cout << "Ende - beliebige Eingabe zum Beenden: ";
	std::cin >> cc;
	return returnresult;
}