AM_CPPFLAGS = $(DEPENDENCIES_CFLAGS) -I$(top_srcdir)/src

TESTS = \
	w3c-widgets-test

check_PROGRAMS = $(TESTS)

w3c_widgets_test_SOURCES = w3c_widgets_test.vala


w3c_widgets_test_LDADD = $(top_builddir)/src/libw3cwidgets.la $(DEPENDENCIES_LIBS)
w3c_widgets_test_VALAFLAGS = -g --pkg gio-2.0 --pkg libxml-2.0 --pkg gee-1.0 --pkg libsoup-2.4  --vapidir $(top_builddir)/src/util --vapidir $(top_builddir)/src/ --pkg w3c-widgets --pkg libuuid

CLEANFILES = *.c *.stamp test-report.xml test-report.html
