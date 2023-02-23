/* Formatted output to a stream.
   Copyright (C) 2007, 2009-2022 Free Software Foundation, Inc.

   This file is free software: you can redistribute it and/or modify
   it under the terms of the GNU Lesser General Public License as
   published by the Free Software Foundation, either version 3 of the
   License, or (at your option) any later version.

   This file is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU Lesser General Public License for more details.

   You should have received a copy of the GNU Lesser General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

#if 1
# include <config.h>
#endif

/* Specification.  */
#include <stdio.h>

#include <stdarg.h>

/* Print formatted output to standard output.
   Return string length of formatted string.  On error, return a negative
   value.  */
int
vprintf (const char *format, va_list args)
{
  return vfprintf (stdout, format, args);
}
