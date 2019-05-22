#ifndef STUDENT_H
#define STUDENT_H
#include <iostream>

class student {
	mutable int numberofcomp;
	float grade;
public:
	student();
	student(float grade);
	~student();

	void editGrade(float grade);

	bool operator< (student& stud2) const;
	friend std::ostream& operator<< (std::ostream& o,  const student& student);

	int getnubmerofcomp();
};

#endif // !STUDENT_H