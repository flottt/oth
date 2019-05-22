#include "student.h"

student::student() {

}

student::student(float grade){
	this->grade = grade;
	this->numberofcomp = 0;
}


student::~student(){

}

void student::editGrade(float grade) {
	this->grade = grade;
}

bool student::operator< (student& stud2) const{
	this->numberofcomp++;
	return this->grade < stud2.grade;
}

std::ostream& operator<< (std::ostream& o, const student& student) {
	o << student.grade;
	return o;
}

int student::getnubmerofcomp() {
	return this->numberofcomp;
}
