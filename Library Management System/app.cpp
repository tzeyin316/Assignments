#include	<iostream>
#include	<cstdlib>
#include	<cstdio>
#include    <fstream>
#include    <string>
#include	<iomanip>
#include	"List.h"
#include    "LibStudent.h"
#include    "LibBook.h"

using namespace std;

bool ReadFile(string, List *);
bool DeleteRecord(List *, char *);
bool SearchStudent(List *, char *id, LibStudent &);
bool Display(List* , int, int);
bool InsertBook(string, List *);
string replaceUnderscores(string&);
int toJulianDay(int, int, int);
bool computeAndDisplayStatistics(List *);
bool printStuWithSameBook(List *, char *);
bool displayWarnedStudent(List *, List *, List *);
int menu();


int main() {

	int choice;
	List studentList;
	List type1, type2;

	do
	{
		choice = menu();

		if (choice == 1)
		{

			cout << "READ FILE\n\n\n";

			if (ReadFile("student.txt", &studentList))
			{
				cout << studentList.size() << " records have been successfully read." << endl;
			}
			else
				cout << "No records shown." << endl;
		}

		else if (choice == 2)
		{
			char delete_id[10];
			cout << "DELETE RECORD\n\n\n";
			cout << "Enter Student ID: ";
			cin >> delete_id;

			if (DeleteRecord(&studentList, delete_id))
				cout << "\nRecord of student " << delete_id << " is deleted sucessfully." << endl;

			else
				cout << "\nStudent not found." << endl;
		}

		else if (choice == 3)
		{
			char id[10];
			LibStudent stu;

			cout << "SEARCH STUDENT\n\n\n";
			cout << "Enter Student ID: ";
			cin >> id;

			if (SearchStudent(&studentList, id, stu))
			{
				cout << "\nStudent found and information printed above." << endl;
			}
			else {
				cout << "\nStudent not found." << endl;
			}
		}

		else if (choice == 4)
		{
			cout << "INSERT BOOK\n\n\n";

			if (InsertBook("book.txt", &studentList)) {
				cout << "Books inserted successfully to student list." << endl;
			}
			else {
				cout << "Books inserted failed to student list." << endl;
			}
		}

		else if (choice == 5)
		{
			int source, details;
			bool input = true;
			cout << "DISPLAY OUTPUT\n\n\n";

			//get source and details input
			do {
				cout << "Where do you want to display the output(1 - File / 2 - Screen) : ";
				cin >> source;
				cout << endl;

				//if input is out of range
				if (source > 2 || source < 0)
				{
					cout << "Invalid input. Please input 1 or 2." << endl;
					input = false;
				}
				else
					input = true;

			} while (input == false);

			input = true;
			do {
				cout << "Do you want to display book list for every student(1 - YES / 2 - NO) : ";
				cin >> details;
				cout << endl;

				if (details > 2 || details < 0)
				{
					cout << "Invalid input. Please input 1 or 2." << endl;
					input = false;
				}
				else
					input = true;

			} while (input == false);

			Display(&studentList, source, details);
		}

		else if (choice == 6)
		{
			cout << "COMPUTE AND DISPLAY STATISTICS\n\n" << endl;

			if (computeAndDisplayStatistics(&studentList))
				cout << "\nStatistics computed and displayed successfully!\n";
			else
				cout << "\nStatistics failed to compute.\n";
		}

		else if (choice == 7)
		{
			char callNum[20];
			cout << "STUDENTS WITH SAME BOOK\n\n" << endl;
			cout << "Enter book call number: ";
			cin >> callNum;
			cout << endl;

			if (printStuWithSameBook(&studentList, callNum))
				cout << "\n\nList of student borrowed the same book displayed successfully!\n";
			else
				cout << "\n\nList of student borrowed the same book failed to displayed.\n";
		}

		else if (choice == 8)
		{
			cout << "DISPLAY WARNED STUDENTS\n\n";

			if (displayWarnedStudent(&studentList, &type1, &type2))
				cout << "\n\nWarned students list displayed successfully!\n";
			else
				cout << "\n\nWarned students list failed to display.\n";
		}

		else if (choice < 1 || choice >9)
			cout << "Please input choices from 1 to 9." << endl;
		cout << "\n\n";
	} while (choice != 9);

	system("pause");
	return 0;
}

int menu() 
{
	int choice;
	cout << "Menu\n\n";
	cout << "1. Read file.\n2. Delete record.\n3. Search student.\n4. Insert book.\n5. Display output\n6. Compute and Display Statistics\n"
		<< "7. Student with Same Book\n8. Display Warned Student\n9. Exit." << endl;
		
	cout << "Enter your choice : ";
	cin >> choice;
	cout << endl << endl;
	return choice;
}

bool ReadFile(string filename, List* list) {

	ifstream inFile(filename);
	if (!inFile.is_open()) //if student.txt not exist
	{
		return false;
	}

	string line;
	LibStudent student;

	while (!inFile.eof()) //read student info
	{
		getline(inFile, line);
		strncpy(student.id, line.substr(line.find('=') + 2).c_str(), 10); //strncpy copies characters of string

		getline(inFile, line); 
		strncpy(student.name, line.substr(line.find('=') + 2).c_str(), 30);

		getline(inFile, line); 
		strncpy(student.course, line.substr(line.find('=') + 2).c_str(), 3);

		getline(inFile, line); 
		strncpy(student.phone_no, line.substr(line.find('=') + 2).c_str(), 9);

		getline(inFile, line); // Skip blank line
		getline(inFile, line); // Skip blank line

		bool duplicate = false;
		for (int i = 1; i <= list->size(); i++) 
		{
			LibStudent existingStudent;
			if (list->get(i, existingStudent) && strcmp(existingStudent.id, student.id) == 0)  //check for duplicate student id
			{
				duplicate = true;
			}
		}

		if (!duplicate) //if no duplicate student id
		{
			list->insert(student); //store student info into the list
		}
	}
	inFile.close();
	return true;
}

bool DeleteRecord(List* list, char* id) 
{
	LibStudent student;
	Node* cur;
	int num = 1;
	
	if (list->empty()) //if the list is empty
	{
		cout << "\nCannot find student from an empty list!\n";
		return false;
	}

	for (int i = 1; i <= list->size(); i++) {
		if (list->get(i, student) && strcmp(student.id, id) == 0) //retrieve student id from list and compare with the input id
		{
			list->remove(i); //remove student info from the list
			
			ifstream infile("student_info.txt");
			if (infile.is_open())
			{
				//update student info text file
				ofstream outfile("student_info.txt");

				if (!outfile.is_open())
				{
					cout << "\nstudent_info.txt is not open!\n";
					return false;
				}

				cur = list->head; // Start from the head of the list

				while (cur != NULL)
				{
					outfile << "\nSTUDENT " << num;
					cur->item.print(outfile); //Write student info
					cur = cur->next; //Move to the next node
					num++;
					outfile << "\n***********************************************************************************\n";
				}
				outfile.close();
			}
			infile.close();

			ifstream inFile("student_booklist.txt");
			if (inFile.is_open())
			{
				//update student book list text file
				ofstream outFile("student_booklist.txt");

				if (!outFile.is_open())
				{
					cout << "\nstudent_booklist.txt is not open!\n";
					return false;
				}

				cur = list->head; // Start from the head of the list

				num = 1;
				while (cur != NULL)
				{
					outFile << "\nSTUDENT " << num;
					cur->item.print(outFile); //Write student info

					outFile << "\nBOOK LIST: \n";

					if (cur->item.totalbook == 0) //if no book record 
						outFile << "\nNo book record shown for this student.\n";

					for (int i = 0; i < cur->item.totalbook; ++i) {
						outFile << "\nBook " << i + 1 << endl;
						cur->item.book[i].print(outFile); //Write student book record
					}
					cur = cur->next; //Move to the next node
					num++;
					outFile << "\n***********************************************************************************\n";
				}
				outFile.close();
			}
			inFile.close();
			return true;
		}
	}
	return false;
}

bool SearchStudent(List* list, char* id, LibStudent& stu) {
	
	if (list->empty()) //if the list is empty
	{
		cout << "\nCannot search from an empty list!\n";
		return false;
	}
	
	Node* cur = list->head; // Start from the head of the list

	while (cur != NULL)
	{
		if (strcmp(cur->item.id, id) == 0) {

			cur->item.print(cout); // Print the student information
			return true;
		}
		cur = cur->next; // Move to the next node in the list
	}
	return false; // Return false if student not found
}

bool InsertBook(string filename, List* list) {
	
	if (list->empty()) //if the list is empty
	{
		cout << "\nCannot input record to an empty list!\n\n";
		return false;
	}

	ifstream inFile(filename);
	if (!inFile.is_open()) //if book.txt does not exist
	{
		return false;
	}

	string line;
	while (!inFile.eof())
	{
		LibBook book;
		string student_id, authors, title, publisher, date_b, date_d;

		inFile >> student_id >> authors >> title >> publisher >> book.ISBN >> book.yearPublished >> book.callNum >> date_b
			>> date_d; //read the book info 

		getline(inFile, line); // Skip blank line
		getline(inFile, line); // Skip blank line

		//---------------------- replace '_' with spaces -----------------------------------------

		authors = replaceUnderscores(authors);

		title = replaceUnderscores(title);
		strcpy(book.title, title.c_str());

		publisher = replaceUnderscores(publisher);
		strcpy(book.publisher, publisher.c_str());

		//--------------------------------- authors name -----------------------------------------
		int i = 0;
		while (authors.find("/") != string::npos) {
			string cur_authors;

			cur_authors = authors.substr(0, authors.find("/")); //cut the authors name

			book.author[i] = new char[cur_authors.size() + 1];//make sure is it not out of memory
			strcpy(book.author[i], cur_authors.c_str());//copy the author name into the author array

			authors = authors.substr(authors.find("/") + 1, authors.size());//delete the recorded author from the string
			i++;
		}
		book.author[i] = new char[authors.size() + 1];
		strcpy(book.author[i], authors.c_str());//copy the last author name or the only author's name

		//----------------------------------- date -----------------------------------------------

		//borrow
		book.borrow.day = stoi(date_b.substr(0, date_b.find("/")));
		date_b = date_b.substr(date_b.find("/") + 1, date_b.size());
		book.borrow.month = stoi(date_b.substr(0, date_b.find("/")));
		book.borrow.year= stoi(date_b.substr(date_b.find("/") + 1, date_b.size()));

		//due
		book.due.day = stoi(date_d.substr(0, date_d.find("/")));
		date_d = date_d.substr(date_d.find("/") + 1, date_d.size());
		book.due.month = stoi(date_d.substr(0, date_d.find("/")));
		book.due.year = stoi(date_d.substr(date_d.find("/") + 1, date_d.size()));

		//------------------------------- calculate fine ----------------------------------------

		//current date
		int currentDay = 29, currentMonth = 3, currentYear = 2020;

		int julianDue = toJulianDay(book.due.day, book.due.month, book.due.year); //convert date to Julian day
		int julianCurrent = toJulianDay(currentDay, currentMonth, currentYear);
		int daysOverdue = julianCurrent - julianDue;

		if (daysOverdue > 0) 
		{
			book.fine = daysOverdue * 0.5; //calculate book fine 
		}
		//-------------------------------- search student id -------------------------------------

		bool studentFound = false;
		LibStudent student;

		for (int i = 1; i <= list->size(); i++) {

			if (list->get(i, student) && strcmp(student.id, student_id.c_str()) == 0) {
				
				if (student.totalbook < 15) {
					student.book[student.totalbook++] = book;
					student.calculateTotalFine();
					list->set(i, student); // Update the student information in the list
					studentFound = true;
				}
			}
		}

		if (!studentFound) //if student not in the list
		{
			cout << "Student " << student_id <<" does not exist in the record.\n\n";
			return false;
		}
	}
	inFile.close();
	return true;
}

string replaceUnderscores(string& input) //replace '_' to space
{
	for (int i = 0; i < input.size(); i++)
	{
		if (input[i] == '_')
		{
			input[i] = ' ';
		}
	}
	return input;
}

int toJulianDay(int day, int month, int year) //calculate normal date to Julian day
{
	int julianDay; 
	if (month <= 2) {
		year--;
		month += 12;
	}

	int A = year / 100;
	int B = 2 - A + (A / 4);

	julianDay = int(365.25 * (year + 4716)) + int(30.6001 * (month + 1)) + day + B - 1524.5;

	return julianDay;
}

bool Display(List* list, int source, int detail) {
	
	string filename;
	Node* cur;


	if (list->empty()) //if the list is empty
	{
		cout << "\nCannot display from an empty list!\n";
		return false;
	}

	if (source == 1) {
		if (detail == 1)
			filename = "student_booklist.txt";

		else if (detail == 2)
			filename = "student_info.txt";

		ofstream outfile(filename);

		if (!outfile.is_open())
		{
			cout << endl << filename << " is not open!\n";
			return false;
		}

		cur = list->head; // Start from the head of the list

		int num = 1;
		while (cur != NULL)
		{
			outfile << "\nSTUDENT " << num;
			cur->item.print(outfile); //Write student info

			if (detail == 1)
			{
				outfile << "\nBOOK LIST: \n";

				if (cur->item.totalbook == 0) //if no book record 
					outfile << "\nNo book record shown for this student.\n";

				for (int i = 0; i < cur->item.totalbook; ++i) {
					outfile << "\nBook " << i + 1 << endl;
					cur->item.book[i].print(outfile); //Write student book record
				}
			}
			cur = cur->next; //Move to the next node
			num++;
			outfile << "\n***********************************************************************************\n";
		}
		cout << "Successfully display output to " << filename << endl << endl;
	}

	else if (source == 2) {

		cur = list->head;

		int num = 1;
		while (cur != NULL)
		{
			cout << "\nSTUDENT " << num;
			cur->item.print(cout); //Print student info

			if (detail == 1)
			{
				cout << "\nBOOK LIST: \n";
				
				if (cur->item.totalbook == 0) //if no book record 
					cout << "\nNo book record shown for this student.\n";

				for (int i = 0; i < cur->item.totalbook; ++i) {
					cout << "\nBook " << i+1 << endl;
					cur->item.book[i].print(cout); // Print student book record
				}
			}
			cur = cur->next; //move to the next node in the list
			num++;
			cout << "\n***********************************************************************************\n";
		}
	}
	cout << "\nSuccessfully display output.\n";
	return true;
}

bool computeAndDisplayStatistics(List* list)
{
	struct Course
	{
		string courseName;
		int numStudent = 0;
		int totalBooks = 0;
		int totalOverdue = 0;
		double totalFine = 0.0;
	};

	Course course[30];
	int numCourses = 0; //the total number of course exist in the struct


	if (list->empty()) //if list is empty
	{
		cout << "\nCannot display from an empty list!\n";
		return false;
	}

	for (int i = 1; i <= list->size(); i++)
	{
		LibStudent student;
		list->get(i, student);

		bool courseFound = false;

		for (int j = 0; j < numCourses; j++) //check whether the course exist in the struct
		{
			if (course[j].courseName == student.course) //if the course exist in the struct
			{
				course[j].numStudent += 1;
				course[j].totalBooks += student.totalbook;
				course[j].totalFine += student.total_fine;

				for (int k = 0; k < student.totalbook; k++) //count the total overdue of books borrowed
				{
					if (student.book[k].fine != 0.0)
						course[j].totalOverdue += 1; 
				}
				courseFound = true;
			}
		}

		if ((courseFound == false) && (numCourses < 30)) //add course info if course name the do not exist in the course struct
		{
			course[numCourses].courseName = student.course;
			course[numCourses].numStudent += 1;
			course[numCourses].totalBooks += student.totalbook;
			course[numCourses].totalFine += student.total_fine;

			for (int k = 0; k < student.totalbook; k++) //count the total overdue of books borrowed
			{
				if (student.book[k].fine != 0.0)
					course[numCourses].totalOverdue += 1;
			}
			numCourses++;
		}
	}

	//display the table
	cout << "Course\tNumber of Students\tTotal Books Borrowed\tTotal Overdue Books\tTotal Overdue Fine (RM)\n";
	for (int i = 0; i < numCourses; i++)
	{
		cout << setw(4) << course[i].courseName;
		cout << setw(13) << course[i].numStudent;
		cout << setw(25) << course[i].totalBooks;
		cout << setw(25) << course[i].totalOverdue;
		cout << setw(25) << showpoint << fixed << setprecision(2) << course[i].totalFine << endl;
	}
	return true;
}

bool printStuWithSameBook(List* list, char* callNum)
{
	Node* cur;
	int num = 0; //number of students borrow the selected book

	if (list->empty()) //if list is empty
	{
		cout << "\nCannot display from an empty list!\n";
		return false;
	}

	cur = list->head;

	//count num of students borrowed
	while (cur != NULL) 
	{		
		for (int i = 0; i < cur->item.totalbook; i++) 
		{
			if (strcmp(cur->item.book[i].callNum, callNum) == 0) //compare the book callNumber 
				num++; //increase number of students borrowed
		}
		cur = cur->next; //move to the next node
	}

	if (num == 0)
	{
		cout << "There are no student that borrow the book with call number " << callNum << ".\n\n";
		return true;
	}
	else
		cout << "There are " << num << " students that borrow the book with call number " << callNum << " as shown below: \n\n";
	
	cur = list->head; //move to the head of node

	//Print student that borrow the selected book
	while (cur != NULL)
	{
		for (int i = 0; i < cur->item.totalbook; i++) 
		{
			if (strcmp(cur->item.book[i].callNum, callNum) == 0) 
			{
				cout << "Student Id = " << cur->item.id << endl;
				cout << "Name = " << cur->item.name << endl;
				cout << "Course = " << cur->item.course << endl;
				cout << "Phone Number = " << cur->item.phone_no << endl;
				cout << "Borrow Date: ";
				cur->item.book[i].borrow.print(cout);
				cout << "\nDue Date: ";
				cur->item.book[i].due.print(cout);
				cout << endl << endl;
			}
		}
		cur = cur->next; //move to the next node
	}
	return true;
}

bool displayWarnedStudent(List* list, List* type1, List* type2) 
{
	if (list->empty()) //if list is empty
	{
		cout << "\nCannot display from an empty list!\n";
		return false;
	}

	Node* cur = list->head; //move to the head of node 

	while (cur != NULL)
	{
		int totalOverdue = 0;
		int overdueDays = 0;

		for (int i = 0; i < cur->item.totalbook; i++) 
		{
			if (cur->item.book[i].fine / 0.5 >= 10) //if overdue is more than or equal to 10 days
				overdueDays++;

			if (cur->item.book[i].fine > 0.0) //if the book is overdue 
				totalOverdue++;
		}

		//student has more than 2 books that are overdue for >= 10 days
		if (overdueDays > 2)  
			type1->insert(cur->item); 

		//the total fine for a student is more than RM50.00 and every book in the student’s book list are overdue
		if ((cur->item.total_fine > 50.0) && (totalOverdue == cur->item.totalbook)) 
			type2->insert(cur->item); 

		cur = cur->next;
	}

	//display type 1
	cur = type1->head; //move node to the head of list type1
	int num = 1;

	if (type1->empty())
		cout << "\nNo record of students that has more than 2 books overdue >= 10 days.\n";

	else
	{
		cout << "\nRecord of students that has more than 2 books overdue >= 10 days:\n";
		while (cur != NULL)
		{
			cout << "\n\nSTUDENT " << num;
			cur->item.print(cout); //print student info

			cout << "\nBOOK LIST: \n";

			for (int i = 0; i < cur->item.totalbook; ++i) {
				cout << "\nBook " << i + 1 << endl;
				cur->item.book[i].print(cout); //print book info
			}
			cur = cur->next; // move to the next node
			num++;
		}
	}

	//display type 2
	cur = type2->head; //move node to the head of list type 2
	num = 1;

	if (type2->empty())
		cout << "\nNo record of students that has total fine more than RM50.00 and all book borrowed are overdue.\n";

	else
	{
		cout << "\n\n\nRecord of students that has total fine more than RM50.00 and all book borrowed are overdue:\n\n";
		while (cur != NULL)
		{
			cout << "\nSTUDENT " << num;
			cur->item.print(cout); //print student info

			cout << "\nBOOK LIST: \n";

			for (int i = 0; i < cur->item.totalbook; ++i) {
				cout << "\nBook " << i + 1 << endl;
				cur->item.book[i].print(cout); //print book info
			}
			cur = cur->next; //move to the next node in the list
			num++;
		}
	}
	return true;
}

