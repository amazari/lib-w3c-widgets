AC_PREREQ([2.65])
AC_INIT([lib-w3c-widgets],[1.0],[example@gnome.org])
AC_CONFIG_MACRO_DIR([m4])
AM_INIT_AUTOMAKE
AC_CONFIG_FILES([Makefile
		src/Makefile
		test/Makefile])

LT_INIT
AC_PROG_CC
AM_PROG_VALAC

pkg_modules="glib-2.0 >= 2.24.1
             gobject-2.0 >= 2.24.1
             gio-2.0
             libxml-2.0 >= 2.7.8
             gee-1.0 >= 0.6
             libsoup-2.4
             uuid >= 2.19"
PKG_CHECK_MODULES(DEPENDENCIES, [$pkg_modules])

AC_SUBST(DEPENDENCIES_CFLAGS)
AC_SUBST(DEPENDENCIES_LIBS)

AC_OUTPUT
