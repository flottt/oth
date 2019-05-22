#ifndef LLIST_H
#define LLIST_H
#include "listelement.h"
#include <iostream>

template <typename T>
class llist {
	listelement<T>* head;
	listelement<T>* tail;
	unsigned size;
public:
	llist();
	~llist();

	void insertAfter(unsigned pos, T value);
	void deleteAt(unsigned pos);

	void print();

	listelement<T>& operator[](unsigned pos);
};


template <typename T>
llist<T>::llist() {
	this->head = nullptr;
	this->tail = nullptr;
	this->size = 0;
}

template <typename T>
llist<T>::~llist() {
	listelement<T>* todelete = head;
	listelement<T>* next = head->next;
	while (next != nullptr) {
		delete todelete;
		todelete = next;
		next = next->next;
	}
	delete todelete;
}

template <typename T>
void llist<T>::insertAfter(unsigned pos, T value) {
	listelement<T>* newelement = new listelement<T>(value);

	if (this->size == 0) { // noch kein Element in der Liste
		this->head = newelement;
		this->tail = newelement;
		size++;
		return;
	}

	if (pos <= this->size) { //alle weitern Elemente
		if (pos == 0) { // Einfügen am Anfang
			newelement->next = this->head;
			this->head = newelement;
		}
		else if (pos == size) { //Einfügen am Ende
			this->tail->next = newelement;
			this->tail = newelement;
		}
		else { //Einfügen mittendrin
			listelement<T>* prev = this->head;
			for (unsigned i = 0; i < pos; i++)
				prev = prev->next;

			newelement->next = prev->next;
			prev->next = newelement;
		}
		size++;
	}
	else {
		std::cout << "pos invalid\n";
	}
	return;
}

template <typename T>
void llist<T>::deleteAt(unsigned pos) {
	if (this->size == 0) {
		std::cout << "llist already empty\n";
		return;
	}
	if (pos <= this->size) {
		if (pos == 0) { //erste Element löschen
			listelement<T>* todelete = this->head;
			this->head = this->head->next;
			delete todelete;
		}
		else if (pos == size - 1) { //letztes Element löschen
			listelement<T>* todelete = this->tail;
			listelement<T>* newtail = this->head;

			while (newtail->next != this->tail)
				newtail = newtail->next;

			this->tail = newtail;
			this->tail->next = nullptr;

			delete todelete;
		}
		else { //mittendrin löschen
			listelement<T>* todelete = this->head;
			listelement<T>* prev = this->head;

			for (unsigned i = 0; i < pos - 1; i++) {
				prev = prev->next;
			}
			todelete = prev->next;
			prev->next = todelete->next;

			delete todelete;
		}
	}
	else {
		std::cout << "pos invalid\n";
	}
	size--;
	return;
}

template <typename T>
void llist<T>::print() {
	listelement<T>* next = this->head;
	while (next != nullptr) {
		std::cout << next->element << " ";
		next = next->next;
	}
	std::cout << std::endl;
	return;
}

template <typename T>
listelement<T>& llist<T>::operator[] (unsigned pos) {
	listelement<T>* element = this->head;
	for (unsigned i = 0; i < pos; i++) {
		element = element->next;
	}
	return *element;
}

#endif // !LLIST_H