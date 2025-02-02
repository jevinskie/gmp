## Process this file with automake to generate Makefile.in

# Copyright 2001-2003, 2012 Free Software Foundation, Inc.
#



AM_CPPFLAGS = -D__GMP_WITHIN_GMPXX -I$(top_srcdir)

if WANT_CXX
noinst_LTLIBRARIES = libcxx.la
endif

libcxx_la_SOURCES = \
  isfuns.cc ismpf.cc ismpq.cc ismpz.cc ismpznw.cc limits.cc \
  osdoprnti.cc osfuns.cc osmpf.cc osmpq.cc osmpz.cc
