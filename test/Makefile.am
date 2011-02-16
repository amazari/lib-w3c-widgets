AM_CPPFLAGS = $(DEPENDENCIES_CFLAGS) -I$(top_srcdir)/src

TESTS = \
	w3c-widgets-test

check_PROGRAMS = $(TESTS)

w3c_widgets_test_SOURCES = w3c_widgets_test.vala
w3c_widgets_test_LDADD = $(top_builddir)/src/libw3cwidgets.la $(CALCULATOR_LIBS)
w3c_widgets_test_VALAFLAGS = $(top_builddir)/src/w3cwidgets.vapi

CLEANFILES = *.c *.stamp test-report.xml test-report.html
