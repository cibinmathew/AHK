# http://anh.cs.luc.edu/331/notes/JavaVsPython.html	
# https://python.swaroopch.com

'''


if Statement

Java
if (x > 3) {
    x -= 2;
    System.out.println(x);
}
y = x;

Python
if x > 3:
    x -= 2
    print x
y = x

There are no parentheses needed around a condition, but there must be a colon afterward before the indented block.  The indentation that is good formatting in Java is REQUIRED in Python.

The indentation rule makes an extra keyword useful:  elif is like else if in Java. 

if x > 0:
   print 'positive'
elif x < 0:
   print 'negative'
else:
   print 'zero'

The elif construct avoids the the extra levels of indentation that would be needed in Python with
if x > 0:
   print 'positive'
else:
    if x < 0:
        print 'negative'
    else:
        print 'zero'

while
The syntax changes for while are like for if.
Java:
int x = 11;
while (x != 0) {
    System.out.println(x);
    x /= 2;
}

Python:
x = 11
while x != 0:
    print x
    x /= 2	
	
	
	
	
	Java:
for (int i = 2; i < 9; i +=3)
    System.out.println(i);

Python:
for i in range(2, 9, 3):
    print i


A Java for-loop with any other format, like
for (int i = 1; i < 17; i *= 2)
    System.out.println(i);

would need to be converted to a while loop in Python:
i = i
while i < 17:
    print i
    i *= 2
For-Loops
Suppose words is a Java or Python list containing  elements like "yes", "no", "maybe", then
Java:
for (String w: words) {
    w = w.toUppercase();
    System.out.println(w);
}

Python:
for w in words:
    w = w.upper()
    print w

	
The statements continue and break work as in Java.  Python has no switch statement or do while.


	
String Formatting
In both cases fs ends up as "Format with 3 and Hello embedded."
Java:
int x = 3;
String s = "Hello";
String fs = String.format("Format with %s and %s embedded.", x, s);
 
Python:
x = 3
s = "Hello"
fs = "Format with {0} and {1} embedded.".format(x, s); 


Indexing and slices
Java:
String s= "Compute";
char c = s.charAt(2); // 'm'
String sub1 = s.substring(1, 4);  // "omp"
String sub2 = s.substring(3);  // "pute"

Python:
s = "Compute"
c = s[2]   # "m"
sub1 = s[1:4] # "omp"
sub2 = s[3:] # "pute"



Dictionaries/Mappings
Java:
Map<String, String> map = new HashMap<String, String>();
map.put("Jose", "773-000-1234");
map.put("Mary", "312-555-9999");
System.out.println(map.get('Jose'));
for (String key : map.keySet()) {
     System.out.println(key);
     System.out.println(map.get(key));
}

Python:
map = dict() # untyped - does not require String and String
map['Jose'] = '773-000-1234' # only require immutable key
map['Mary'] = '312-555-9999'
print map['Jose'] 
for key in map:
    print key
    print map[key] 
'''

# Functions

'''

Java:
/** javadoc comments.... */
public static int square(int x) {
    return x*x;
}

'''
# Python:
def square(x):
    """ Python function documentation
    - string indented just inside heading
    """
    return x*x
square(2)
	
# Parameters
# def print_max(a, b):

# pass variables as arguments
# print_max(x, y)
	
# local vs global
x = 50


def func():
    global x

    print('x is', x)
    x = 2
    print('Changed global x to', x)


func()
print('Value of x is', x)

# keyword arguments
def func(a, b=5, c=10):
    print('a is', a, 'and b is', b, 'and c is', c)

func(3, 7)
func(25, c=24)
func(c=50, a=100)


# return
# multiple values



# data structures in Python - list, tuple, dictionary and set

# This is my shopping list
shoplist = ['apple', 'mango', 'carrot', 'banana']

print('I have', len(shoplist), 'items to purchase.')

print('These items are:', end=' ')
for item in shoplist:
    print(item, end=' ')

print('\nI also have to buy rice.')
shoplist.append('rice')
print('My shopping list is now', shoplist)

print('I will sort my list now')
shoplist.sort()
print('Sorted shopping list is', shoplist)

print('The first item I will buy is', shoplist[0])
olditem = shoplist[0]
del shoplist[0]
print('I bought the', olditem)
print('My shopping list is now', shoplist)



# TUPLES

zoo = ('python', 'elephant', 'penguin')
print('Number of animals in the zoo is', len(zoo))


ab = {
    'Swaroop': 'swaroop@swaroopch.com',
    'Larry': 'larry@wall.org',
    'Matsumoto': 'matz@ruby-lang.org',
    'Spammer': 'spammer@hotmail.com'
}

print("Swaroop's address is", ab['Swaroop'])

# Deleting a key-value pair
del ab['Spammer']


s = set(['brazil', 'russia', 'india'])
print('india' in s)

# Modules
# functions, classes and variables

import os
# import numpy as np
from math import *
from math import sqrt
print("Square root of 16 is", sqrt(16))


import time
print(time.time())


# pip 

'''
# Classes
Class Use
Java:
List stuff = new ArrayList();  // avoiding generics used in practice
stuff.add("Hello")
if (stuff instanceof List)
     System.out.println("right type")
'''

# Python:
stuff = list()  # no new
stuff.append("Hello")  # same dot syntax.
if isinstance(stuff, list):  # isinstance(object, class)
    print ('right type')
# if more than one type is OK in isinstance, give a tuple of types: isinstance(stuff, (list, tuple, set))




# Static Methods (advanced)
# Pure functions, not tied to object instances are generally just funtions outside a class in Python, whereas they must be static methods inside a class in Java.  If you want a function to be associated with a class, but not require instances in Python, you can use a decorator to turn a method into a static method.
''' 
Java:
class Foo {
    static int count = 0;  // one value for whole class

    static int incCount() {
        count++;
        return count;
    }
}
'''

# Python:
class Foo:
    count=0 # one value for whole class
   
    @staticmethod
    def incCount(): # no self parameter
         Foo.count += 1
         return Foo.count

		 

class Student:
    def __init__(self, name, age, major):
        self.name = name
        self.age = age
        self.major = major

    def is_old(self):
        return self.age > 100

        
# java

'''
public class Student {

        String name;
        int age;
        String major;

        public Student() {
                // TODO Auto-generated constructor stub
        }

        public Student(String name, int age, String major) {
                this.name = name;
                this.age = age;
                this.major = major;
        }
}



'''		

# A timed program run.

import time

class Student:
    def __init__(self, name, age, major):
        self.name = name
        self.age = age
        self.major = major

    def is_old(self):
        return self.age > 100

start = time.clock()

for x in range(5):
    s = Student('John', 23, 'Physics')
    print ('Student %s is %s years old and is studying %s' %(s.name, s.age, s.major))
    print ('Student is old? %d ' %(s.is_old()))

stop = time.clock()
print (stop - start)

# java

'''

public class Student {

        String name;
        int age;
        String major;

        public Student() {
                // TODO Auto-generated constructor stub
        }

        public Student(String name, int age, String major) {
                this.name = name;
                this.age = age;
                this.major = major;
        }

        public String getName() {
                return name;
        }

        public void setName(String name) {
                this.name = name;
        }

        public int getAge() {
                return age;
        }

        public void setAge(int age) {
                this.age = age;
        }

        public String getMajor() {
                return major;
        }

        public void setMajor(String major) {
                this.major = major;
        }

        public static void main(String[] args) {
                long startTime = System.currentTimeMillis();

                for (int i = 0; i < 5; i++) {
                        Student student = new Student("John", 23, "Physics");
                        System.out.println("Student " + student.getName() + " is "
                         + student.getAge() +  " years old and is studying " + student.getMajor());
                }

                long estimatedTime = System.currentTimeMillis() - startTime;
                System.out.println("Time estimate: " + estimatedTime/1000);
        }
}	




# In Python:
class MyClass(ParentClass) 

In Java:
class MyClass extends ParentClass

Keyword "this" in Java is "self" in Python. But that name is just a Python's convention.



Keyword "null" in Java is "None" in Python

Keyword "throw" in Java is "raise" in Python
	

	
    
    
Java 	Python

import java.io.*;
...

BufferedReader myFile =
    new BufferedReader(
        new FileReader(argFilename));

# open an input file
myFile = open(argFilename)		 
		 
'''

# no method overloading in python, but can use default args