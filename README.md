# Heat-Equation-with-Python-and-Cython

In this repository the heat equation is used with Python and we use the Cython programming language to improve the efficiency of the algorithm execution.  There is a folder with several scripts:

Binary documents .dat
Documents with python: heat.py heat_main.py setup.py
Documents with cython: heat_cyt01.pyx

The following commands are used to compile and run the program:

> rm -rf build *.png *.c *.so *.html; python3 setup.py build_ext --inplace; cython heat_cyt01.pyx -a

Here it is necessary to point out several aspects, first of all you can create a Makefile file with the above instructions. secondly the commands are for Linux, thirdly, the first command deletes all the .png, .c, .so and .html files, the second command creates and downloads all the packages needed to use Cython and finally creates a .html file to parse the Cython code.

In the end it is only necessary to run the main program "heat_main.py"

> python3 heat_main.py

If we want to run the program with Python or Cython go to the following line and uncomment as required:

> lib_dict = {
> #  'heat': heat,
> #  'heat_cyt01': heat_cyt01,
> }
