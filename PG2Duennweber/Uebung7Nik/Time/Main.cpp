#include <iostream>
#include "myclock.h"
#include <Windows.h>

int mainX()
{
	myclock c{};
	c->setTime(10,5,10);
	c->print();
	return 0; 
}

int main() {
	int returnresult = mainX(); 
	system("pause");
	return returnresult;
}