{
   *
   *  os_types.h
   *
   *      Original Copyright (C) Aaron Holtzman - May 1999
   *      Modifications Copyright (C) Stan Seibert - July 2000
   *
   *  This file is part of libao, a cross-platform audio output library.  See
   *  README for a history of this source code.
   *
   *  libao is free software; you can redistribute it and/or modify
   *  it under the terms of the GNU General Public License as published by
   *  the Free Software Foundation; either version 2, or (at your option)
   *  any later version.
   *
   *  libao is distributed in the hope that it will be useful,
   *  but WITHOUT ANY WARRANTY; without even the implied warranty of
   *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   *  GNU General Public License for more details.
   *
   *  You should have received a copy of the GNU General Public License
   *  along with GNU Make; see the file COPYING.  If not, write to
   *  the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
   *
}
{Traduzido por Elson Junio(elsonjunio@yahoo.com.br) de os_types.h}

unit os_types;
interface

{ Set type sizes for this platform (Requires Autoconf)  }
{$ifndef __OS_TYPES_H__}
{$define __OS_TYPES_H__}  

  type
    uint_8 = byte;
    uint_16 = word;
    uint_32 = dword;
    sint_8 = char;
    sint_16 = smallint;
    sint_32 = longint;
{$endif}
  { __OS_TYPES_H__  }

implementation


end.
