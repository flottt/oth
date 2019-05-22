#include <iostream>
#include "llist.h"
#include "student.h"

int mainLL() {
	llist<student> l{};
	student st1(1.4);
	l.insertAfter(0, st1);
	student st2(2.4);
	l.insertAfter(0, st2);
	student st3(3.4);
	l.insertAfter(2, st3);
	student st4(4.4);
	l.insertAfter(0, st4);
	l.print();
	l.deleteAt(1);
	l.print();
	std::cout << (l[2].element < l[1].element) << std::endl;
	std::cout << l[2].element.getnubmerofcomp() << std::endl;
	
	return 0; 
}

int main(void) {
	int returnresult = mainLL(); 
	char cc;
	std::cout << "Ende - beliebige Eingabe zum Beenden: ";
	std::cin >> cc;
	return returnresult;
}