#ifndef LISTELEMENT_H
#define LISTELEMENT_H

template <class T>
class listelement {
public:
	T element;
	listelement* next;
	listelement(T value);
	~listelement();
};

template <class T>
listelement<T>::listelement(T value) {
	this->next = nullptr;
	this->element = value;
}

template <class T>
listelement<T>::~listelement() {

}

#endif // !LISTELEMENT_H