# pthread_h.m4 serial 9
dnl Copyright (C) 2009-2023 Free Software Foundation, Inc.
dnl This file is free software; the Free Software Foundation
dnl gives unlimited permission to copy and/or distribute it,
dnl with or without modifications, as long as this notice is preserved.

AC_DEFUN_ONCE([gl_PTHREAD_H],
[
  dnl Ensure to expand the default settings once only, before all statements
  dnl that occur in other macros.
  AC_REQUIRE([gl_PTHREAD_H_DEFAULTS])

  AC_REQUIRE([AC_CANONICAL_HOST])
  AC_REQUIRE([gl_PTHREADLIB])

  gl_CHECK_NEXT_HEADERS([pthread.h])
  if test $ac_cv_header_pthread_h = yes; then
    HAVE_PTHREAD_H=1
    dnl On mingw, if --enable-threads=windows or gl_AVOID_WINPTHREAD is used,
    dnl ignore the <pthread.h> from the mingw-w64 winpthreads library.
    m4_ifdef([gl_][THREADLIB], [
      AC_REQUIRE([gl_][THREADLIB])
      if { case "$host_os" in mingw* | windows*) true;; *) false;; esac; } \
         && test $gl_threads_api = windows; then
        HAVE_PTHREAD_H=0
      fi
    ])
  else
    HAVE_PTHREAD_H=0
  fi
  AC_SUBST([HAVE_PTHREAD_H])

  AC_CHECK_TYPES([pthread_t, pthread_spinlock_t], [], [],
    [AC_INCLUDES_DEFAULT[
     #if HAVE_PTHREAD_H
      #include <pthread.h>
     #endif]])
  if test $ac_cv_type_pthread_t != yes; then
    HAVE_PTHREAD_T=0
  fi
  if test $ac_cv_type_pthread_spinlock_t != yes; then
    HAVE_PTHREAD_SPINLOCK_T=0
  fi

  dnl Constants may be defined as C preprocessor macros or as enum items.

  AC_CACHE_CHECK([for PTHREAD_CREATE_DETACHED],
    [gl_cv_const_PTHREAD_CREATE_DETACHED],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <pthread.h>
            int x = PTHREAD_CREATE_DETACHED;
          ]],
          [[]])],
       [gl_cv_const_PTHREAD_CREATE_DETACHED=yes],
       [gl_cv_const_PTHREAD_CREATE_DETACHED=no])
    ])
  if test $gl_cv_const_PTHREAD_CREATE_DETACHED != yes; then
    HAVE_PTHREAD_CREATE_DETACHED=0
  fi

  AC_CACHE_CHECK([for PTHREAD_MUTEX_RECURSIVE],
    [gl_cv_const_PTHREAD_MUTEX_RECURSIVE],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <pthread.h>
            int x = PTHREAD_MUTEX_RECURSIVE;
          ]],
          [[]])],
       [gl_cv_const_PTHREAD_MUTEX_RECURSIVE=yes],
       [gl_cv_const_PTHREAD_MUTEX_RECURSIVE=no])
    ])
  if test $gl_cv_const_PTHREAD_MUTEX_RECURSIVE != yes; then
    HAVE_PTHREAD_MUTEX_RECURSIVE=0
  fi

  AC_CACHE_CHECK([for PTHREAD_MUTEX_ROBUST],
    [gl_cv_const_PTHREAD_MUTEX_ROBUST],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <pthread.h>
            int x = PTHREAD_MUTEX_ROBUST;
          ]],
          [[]])],
       [gl_cv_const_PTHREAD_MUTEX_ROBUST=yes],
       [gl_cv_const_PTHREAD_MUTEX_ROBUST=no])
    ])
  if test $gl_cv_const_PTHREAD_MUTEX_ROBUST != yes; then
    HAVE_PTHREAD_MUTEX_ROBUST=0
  fi

  AC_CACHE_CHECK([for PTHREAD_PROCESS_SHARED],
    [gl_cv_const_PTHREAD_PROCESS_SHARED],
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
          [[#include <pthread.h>
            int x = PTHREAD_PROCESS_SHARED;
          ]],
          [[]])],
       [gl_cv_const_PTHREAD_PROCESS_SHARED=yes],
       [gl_cv_const_PTHREAD_PROCESS_SHARED=no])
    ])
  if test $gl_cv_const_PTHREAD_PROCESS_SHARED != yes; then
    HAVE_PTHREAD_PROCESS_SHARED=0
  fi

  dnl Check for declarations of anything we want to poison if the
  dnl corresponding gnulib module is not in use, if it is not common
  dnl enough to be declared everywhere.
  gl_WARN_ON_USE_PREPARE([[#include <pthread.h>
    ]], [
    pthread_create pthread_attr_init pthread_attr_getdetachstate
    pthread_attr_setdetachstate pthread_attr_destroy pthread_self pthread_equal
    pthread_detach pthread_join pthread_exit
    pthread_once
    pthread_mutex_init pthread_mutexattr_init pthread_mutexattr_gettype
    pthread_mutexattr_settype pthread_mutexattr_getrobust
    pthread_mutexattr_setrobust pthread_mutexattr_destroy pthread_mutex_lock
    pthread_mutex_trylock pthread_mutex_timedlock pthread_mutex_unlock
    pthread_mutex_destroy
    pthread_rwlock_init pthread_rwlockattr_init pthread_rwlockattr_destroy
    pthread_rwlock_rdlock pthread_rwlock_wrlock pthread_rwlock_tryrdlock
    pthread_rwlock_trywrlock pthread_rwlock_timedrdlock
    pthread_rwlock_timedwrlock pthread_rwlock_unlock pthread_rwlock_destroy
    pthread_cond_init pthread_condattr_init pthread_condattr_destroy
    pthread_cond_wait pthread_cond_timedwait pthread_cond_signal
    pthread_cond_broadcast pthread_cond_destroy
    pthread_key_create pthread_setspecific pthread_getspecific
    pthread_key_delete
    pthread_spin_init pthread_spin_lock pthread_spin_trylock pthread_spin_unlock
    pthread_spin_destroy])

  AC_REQUIRE([AC_C_RESTRICT])

  dnl For backward compatibility with gnulib versions <= 2019-07.
  LIB_PTHREAD="$LIBPMULTITHREAD"
  AC_SUBST([LIB_PTHREAD])
])

# gl_PTHREAD_MODULE_INDICATOR([modulename])
# sets the shell variable that indicates the presence of the given module
# to a C preprocessor expression that will evaluate to 1.
# This macro invocation must not occur in macros that are AC_REQUIREd.
AC_DEFUN([gl_PTHREAD_MODULE_INDICATOR],
[
  dnl Ensure to expand the default settings once only.
  gl_PTHREAD_H_REQUIRE_DEFAULTS
  gl_MODULE_INDICATOR_SET_VARIABLE([$1])
  dnl Define it also as a C macro, for the benefit of the unit tests.
  gl_MODULE_INDICATOR_FOR_TESTS([$1])
])

# Initializes the default values for AC_SUBSTed shell variables.
# This macro must not be AC_REQUIREd.  It must only be invoked, and only
# outside of macros or in macros that are not AC_REQUIREd.
AC_DEFUN([gl_PTHREAD_H_REQUIRE_DEFAULTS],
[
  m4_defun(GL_MODULE_INDICATOR_PREFIX[_PTHREAD_H_MODULE_INDICATOR_DEFAULTS], [
    gl_MODULE_INDICATOR_INIT_VARIABLE([GNULIB_PTHREAD_THREAD])
    gl_MODULE_INDICATOR_INIT_VARIABLE([GNULIB_PTHREAD_ONCE])
    gl_MODULE_INDICATOR_INIT_VARIABLE([GNULIB_PTHREAD_MUTEX])
    gl_MODULE_INDICATOR_INIT_VARIABLE([GNULIB_PTHREAD_RWLOCK])
    gl_MODULE_INDICATOR_INIT_VARIABLE([GNULIB_PTHREAD_COND])
    gl_MODULE_INDICATOR_INIT_VARIABLE([GNULIB_PTHREAD_TSS])
    gl_MODULE_INDICATOR_INIT_VARIABLE([GNULIB_PTHREAD_SPIN])
    gl_MODULE_INDICATOR_INIT_VARIABLE([GNULIB_PTHREAD_MUTEX_TIMEDLOCK])
  ])
  m4_require(GL_MODULE_INDICATOR_PREFIX[_PTHREAD_H_MODULE_INDICATOR_DEFAULTS])
  AC_REQUIRE([gl_PTHREAD_H_DEFAULTS])
])

AC_DEFUN([gl_PTHREAD_H_DEFAULTS],
[
  dnl Assume proper GNU behavior unless another module says otherwise.
  HAVE_PTHREAD_T=1;                      AC_SUBST([HAVE_PTHREAD_T])
  HAVE_PTHREAD_SPINLOCK_T=1;             AC_SUBST([HAVE_PTHREAD_SPINLOCK_T])
  HAVE_PTHREAD_CREATE_DETACHED=1;        AC_SUBST([HAVE_PTHREAD_CREATE_DETACHED])
  HAVE_PTHREAD_MUTEX_RECURSIVE=1;        AC_SUBST([HAVE_PTHREAD_MUTEX_RECURSIVE])
  HAVE_PTHREAD_MUTEX_ROBUST=1;           AC_SUBST([HAVE_PTHREAD_MUTEX_ROBUST])
  HAVE_PTHREAD_PROCESS_SHARED=1;         AC_SUBST([HAVE_PTHREAD_PROCESS_SHARED])
  HAVE_PTHREAD_CREATE=1;                 AC_SUBST([HAVE_PTHREAD_CREATE])
  HAVE_PTHREAD_ATTR_INIT=1;              AC_SUBST([HAVE_PTHREAD_ATTR_INIT])
  HAVE_PTHREAD_ATTR_GETDETACHSTATE=1;    AC_SUBST([HAVE_PTHREAD_ATTR_GETDETACHSTATE])
  HAVE_PTHREAD_ATTR_SETDETACHSTATE=1;    AC_SUBST([HAVE_PTHREAD_ATTR_SETDETACHSTATE])
  HAVE_PTHREAD_ATTR_DESTROY=1;           AC_SUBST([HAVE_PTHREAD_ATTR_DESTROY])
  HAVE_PTHREAD_SELF=1;                   AC_SUBST([HAVE_PTHREAD_SELF])
  HAVE_PTHREAD_EQUAL=1;                  AC_SUBST([HAVE_PTHREAD_EQUAL])
  HAVE_PTHREAD_DETACH=1;                 AC_SUBST([HAVE_PTHREAD_DETACH])
  HAVE_PTHREAD_JOIN=1;                   AC_SUBST([HAVE_PTHREAD_JOIN])
  HAVE_PTHREAD_EXIT=1;                   AC_SUBST([HAVE_PTHREAD_EXIT])
  HAVE_PTHREAD_ONCE=1;                   AC_SUBST([HAVE_PTHREAD_ONCE])
  HAVE_PTHREAD_MUTEX_INIT=1;             AC_SUBST([HAVE_PTHREAD_MUTEX_INIT])
  HAVE_PTHREAD_MUTEXATTR_INIT=1;         AC_SUBST([HAVE_PTHREAD_MUTEXATTR_INIT])
  HAVE_PTHREAD_MUTEXATTR_GETTYPE=1;      AC_SUBST([HAVE_PTHREAD_MUTEXATTR_GETTYPE])
  HAVE_PTHREAD_MUTEXATTR_SETTYPE=1;      AC_SUBST([HAVE_PTHREAD_MUTEXATTR_SETTYPE])
  HAVE_PTHREAD_MUTEXATTR_GETROBUST=1;    AC_SUBST([HAVE_PTHREAD_MUTEXATTR_GETROBUST])
  HAVE_PTHREAD_MUTEXATTR_SETROBUST=1;    AC_SUBST([HAVE_PTHREAD_MUTEXATTR_SETROBUST])
  HAVE_PTHREAD_MUTEXATTR_DESTROY=1;      AC_SUBST([HAVE_PTHREAD_MUTEXATTR_DESTROY])
  HAVE_PTHREAD_MUTEX_LOCK=1;             AC_SUBST([HAVE_PTHREAD_MUTEX_LOCK])
  HAVE_PTHREAD_MUTEX_TRYLOCK=1;          AC_SUBST([HAVE_PTHREAD_MUTEX_TRYLOCK])
  HAVE_PTHREAD_MUTEX_TIMEDLOCK=1;        AC_SUBST([HAVE_PTHREAD_MUTEX_TIMEDLOCK])
  HAVE_PTHREAD_MUTEX_UNLOCK=1;           AC_SUBST([HAVE_PTHREAD_MUTEX_UNLOCK])
  HAVE_PTHREAD_MUTEX_DESTROY=1;          AC_SUBST([HAVE_PTHREAD_MUTEX_DESTROY])
  HAVE_PTHREAD_RWLOCK_INIT=1;            AC_SUBST([HAVE_PTHREAD_RWLOCK_INIT])
  HAVE_PTHREAD_RWLOCKATTR_INIT=1;        AC_SUBST([HAVE_PTHREAD_RWLOCKATTR_INIT])
  HAVE_PTHREAD_RWLOCKATTR_DESTROY=1;     AC_SUBST([HAVE_PTHREAD_RWLOCKATTR_DESTROY])
  HAVE_PTHREAD_RWLOCK_RDLOCK=1;          AC_SUBST([HAVE_PTHREAD_RWLOCK_RDLOCK])
  HAVE_PTHREAD_RWLOCK_WRLOCK=1;          AC_SUBST([HAVE_PTHREAD_RWLOCK_WRLOCK])
  HAVE_PTHREAD_RWLOCK_TRYRDLOCK=1;       AC_SUBST([HAVE_PTHREAD_RWLOCK_TRYRDLOCK])
  HAVE_PTHREAD_RWLOCK_TRYWRLOCK=1;       AC_SUBST([HAVE_PTHREAD_RWLOCK_TRYWRLOCK])
  HAVE_PTHREAD_RWLOCK_TIMEDRDLOCK=1;     AC_SUBST([HAVE_PTHREAD_RWLOCK_TIMEDRDLOCK])
  HAVE_PTHREAD_RWLOCK_TIMEDWRLOCK=1;     AC_SUBST([HAVE_PTHREAD_RWLOCK_TIMEDWRLOCK])
  HAVE_PTHREAD_RWLOCK_UNLOCK=1;          AC_SUBST([HAVE_PTHREAD_RWLOCK_UNLOCK])
  HAVE_PTHREAD_RWLOCK_DESTROY=1;         AC_SUBST([HAVE_PTHREAD_RWLOCK_DESTROY])
  HAVE_PTHREAD_COND_INIT=1;              AC_SUBST([HAVE_PTHREAD_COND_INIT])
  HAVE_PTHREAD_CONDATTR_INIT=1;          AC_SUBST([HAVE_PTHREAD_CONDATTR_INIT])
  HAVE_PTHREAD_CONDATTR_DESTROY=1;       AC_SUBST([HAVE_PTHREAD_CONDATTR_DESTROY])
  HAVE_PTHREAD_COND_WAIT=1;              AC_SUBST([HAVE_PTHREAD_COND_WAIT])
  HAVE_PTHREAD_COND_TIMEDWAIT=1;         AC_SUBST([HAVE_PTHREAD_COND_TIMEDWAIT])
  HAVE_PTHREAD_COND_SIGNAL=1;            AC_SUBST([HAVE_PTHREAD_COND_SIGNAL])
  HAVE_PTHREAD_COND_BROADCAST=1;         AC_SUBST([HAVE_PTHREAD_COND_BROADCAST])
  HAVE_PTHREAD_COND_DESTROY=1;           AC_SUBST([HAVE_PTHREAD_COND_DESTROY])
  HAVE_PTHREAD_KEY_CREATE=1;             AC_SUBST([HAVE_PTHREAD_KEY_CREATE])
  HAVE_PTHREAD_SETSPECIFIC=1;            AC_SUBST([HAVE_PTHREAD_SETSPECIFIC])
  HAVE_PTHREAD_GETSPECIFIC=1;            AC_SUBST([HAVE_PTHREAD_GETSPECIFIC])
  HAVE_PTHREAD_KEY_DELETE=1;             AC_SUBST([HAVE_PTHREAD_KEY_DELETE])
  HAVE_PTHREAD_SPIN_INIT=1;              AC_SUBST([HAVE_PTHREAD_SPIN_INIT])
  HAVE_PTHREAD_SPIN_LOCK=1;              AC_SUBST([HAVE_PTHREAD_SPIN_LOCK])
  HAVE_PTHREAD_SPIN_TRYLOCK=1;           AC_SUBST([HAVE_PTHREAD_SPIN_TRYLOCK])
  HAVE_PTHREAD_SPIN_UNLOCK=1;            AC_SUBST([HAVE_PTHREAD_SPIN_UNLOCK])
  HAVE_PTHREAD_SPIN_DESTROY=1;           AC_SUBST([HAVE_PTHREAD_SPIN_DESTROY])
  REPLACE_PTHREAD_CREATE=0;              AC_SUBST([REPLACE_PTHREAD_CREATE])
  REPLACE_PTHREAD_ATTR_INIT=0;           AC_SUBST([REPLACE_PTHREAD_ATTR_INIT])
  REPLACE_PTHREAD_ATTR_GETDETACHSTATE=0; AC_SUBST([REPLACE_PTHREAD_ATTR_GETDETACHSTATE])
  REPLACE_PTHREAD_ATTR_SETDETACHSTATE=0; AC_SUBST([REPLACE_PTHREAD_ATTR_SETDETACHSTATE])
  REPLACE_PTHREAD_ATTR_DESTROY=0;        AC_SUBST([REPLACE_PTHREAD_ATTR_DESTROY])
  REPLACE_PTHREAD_SELF=0;                AC_SUBST([REPLACE_PTHREAD_SELF])
  REPLACE_PTHREAD_EQUAL=0;               AC_SUBST([REPLACE_PTHREAD_EQUAL])
  REPLACE_PTHREAD_DETACH=0;              AC_SUBST([REPLACE_PTHREAD_DETACH])
  REPLACE_PTHREAD_JOIN=0;                AC_SUBST([REPLACE_PTHREAD_JOIN])
  REPLACE_PTHREAD_EXIT=0;                AC_SUBST([REPLACE_PTHREAD_EXIT])
  REPLACE_PTHREAD_ONCE=0;                AC_SUBST([REPLACE_PTHREAD_ONCE])
  REPLACE_PTHREAD_MUTEX_INIT=0;          AC_SUBST([REPLACE_PTHREAD_MUTEX_INIT])
  REPLACE_PTHREAD_MUTEXATTR_INIT=0;      AC_SUBST([REPLACE_PTHREAD_MUTEXATTR_INIT])
  REPLACE_PTHREAD_MUTEXATTR_GETTYPE=0;   AC_SUBST([REPLACE_PTHREAD_MUTEXATTR_GETTYPE])
  REPLACE_PTHREAD_MUTEXATTR_SETTYPE=0;   AC_SUBST([REPLACE_PTHREAD_MUTEXATTR_SETTYPE])
  REPLACE_PTHREAD_MUTEXATTR_GETROBUST=0; AC_SUBST([REPLACE_PTHREAD_MUTEXATTR_GETROBUST])
  REPLACE_PTHREAD_MUTEXATTR_SETROBUST=0; AC_SUBST([REPLACE_PTHREAD_MUTEXATTR_SETROBUST])
  REPLACE_PTHREAD_MUTEXATTR_DESTROY=0;   AC_SUBST([REPLACE_PTHREAD_MUTEXATTR_DESTROY])
  REPLACE_PTHREAD_MUTEX_LOCK=0;          AC_SUBST([REPLACE_PTHREAD_MUTEX_LOCK])
  REPLACE_PTHREAD_MUTEX_TRYLOCK=0;       AC_SUBST([REPLACE_PTHREAD_MUTEX_TRYLOCK])
  REPLACE_PTHREAD_MUTEX_TIMEDLOCK=0;     AC_SUBST([REPLACE_PTHREAD_MUTEX_TIMEDLOCK])
  REPLACE_PTHREAD_MUTEX_UNLOCK=0;        AC_SUBST([REPLACE_PTHREAD_MUTEX_UNLOCK])
  REPLACE_PTHREAD_MUTEX_DESTROY=0;       AC_SUBST([REPLACE_PTHREAD_MUTEX_DESTROY])
  REPLACE_PTHREAD_RWLOCK_INIT=0;         AC_SUBST([REPLACE_PTHREAD_RWLOCK_INIT])
  REPLACE_PTHREAD_RWLOCKATTR_INIT=0;     AC_SUBST([REPLACE_PTHREAD_RWLOCKATTR_INIT])
  REPLACE_PTHREAD_RWLOCKATTR_DESTROY=0;  AC_SUBST([REPLACE_PTHREAD_RWLOCKATTR_DESTROY])
  REPLACE_PTHREAD_RWLOCK_RDLOCK=0;       AC_SUBST([REPLACE_PTHREAD_RWLOCK_RDLOCK])
  REPLACE_PTHREAD_RWLOCK_WRLOCK=0;       AC_SUBST([REPLACE_PTHREAD_RWLOCK_WRLOCK])
  REPLACE_PTHREAD_RWLOCK_TRYRDLOCK=0;    AC_SUBST([REPLACE_PTHREAD_RWLOCK_TRYRDLOCK])
  REPLACE_PTHREAD_RWLOCK_TRYWRLOCK=0;    AC_SUBST([REPLACE_PTHREAD_RWLOCK_TRYWRLOCK])
  REPLACE_PTHREAD_RWLOCK_TIMEDRDLOCK=0;  AC_SUBST([REPLACE_PTHREAD_RWLOCK_TIMEDRDLOCK])
  REPLACE_PTHREAD_RWLOCK_TIMEDWRLOCK=0;  AC_SUBST([REPLACE_PTHREAD_RWLOCK_TIMEDWRLOCK])
  REPLACE_PTHREAD_RWLOCK_UNLOCK=0;       AC_SUBST([REPLACE_PTHREAD_RWLOCK_UNLOCK])
  REPLACE_PTHREAD_RWLOCK_DESTROY=0;      AC_SUBST([REPLACE_PTHREAD_RWLOCK_DESTROY])
  REPLACE_PTHREAD_COND_INIT=0;           AC_SUBST([REPLACE_PTHREAD_COND_INIT])
  REPLACE_PTHREAD_CONDATTR_INIT=0;       AC_SUBST([REPLACE_PTHREAD_CONDATTR_INIT])
  REPLACE_PTHREAD_CONDATTR_DESTROY=0;    AC_SUBST([REPLACE_PTHREAD_CONDATTR_DESTROY])
  REPLACE_PTHREAD_COND_WAIT=0;           AC_SUBST([REPLACE_PTHREAD_COND_WAIT])
  REPLACE_PTHREAD_COND_TIMEDWAIT=0;      AC_SUBST([REPLACE_PTHREAD_COND_TIMEDWAIT])
  REPLACE_PTHREAD_COND_SIGNAL=0;         AC_SUBST([REPLACE_PTHREAD_COND_SIGNAL])
  REPLACE_PTHREAD_COND_BROADCAST=0;      AC_SUBST([REPLACE_PTHREAD_COND_BROADCAST])
  REPLACE_PTHREAD_COND_DESTROY=0;        AC_SUBST([REPLACE_PTHREAD_COND_DESTROY])
  REPLACE_PTHREAD_KEY_CREATE=0;          AC_SUBST([REPLACE_PTHREAD_KEY_CREATE])
  REPLACE_PTHREAD_SETSPECIFIC=0;         AC_SUBST([REPLACE_PTHREAD_SETSPECIFIC])
  REPLACE_PTHREAD_GETSPECIFIC=0;         AC_SUBST([REPLACE_PTHREAD_GETSPECIFIC])
  REPLACE_PTHREAD_KEY_DELETE=0;          AC_SUBST([REPLACE_PTHREAD_KEY_DELETE])
  REPLACE_PTHREAD_SPIN_INIT=0;           AC_SUBST([REPLACE_PTHREAD_SPIN_INIT])
  REPLACE_PTHREAD_SPIN_LOCK=0;           AC_SUBST([REPLACE_PTHREAD_SPIN_LOCK])
  REPLACE_PTHREAD_SPIN_TRYLOCK=0;        AC_SUBST([REPLACE_PTHREAD_SPIN_TRYLOCK])
  REPLACE_PTHREAD_SPIN_UNLOCK=0;         AC_SUBST([REPLACE_PTHREAD_SPIN_UNLOCK])
  REPLACE_PTHREAD_SPIN_DESTROY=0;        AC_SUBST([REPLACE_PTHREAD_SPIN_DESTROY])
])
