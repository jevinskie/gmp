dnl  PowerPC-64 mpn_divexact_by3 -- mpn by 3 exact division

dnl  Copyright 2002, 2003 Free Software Foundation, Inc.
dnl
dnl  This file is part of the GNU MP Library.
dnl
dnl  The GNU MP Library is free software; you can redistribute it and/or modify
dnl  it under the terms of the GNU Lesser General Public License as published
dnl  by the Free Software Foundation; either version 2.1 of the License, or (at
dnl  your option) any later version.
dnl
dnl  The GNU MP Library is distributed in the hope that it will be useful, but
dnl  WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
dnl  or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public
dnl  License for more details.
dnl
dnl  You should have received a copy of the GNU Lesser General Public License
dnl  along with the GNU MP Library; see the file COPYING.LIB.  If not, write to
dnl  the Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
dnl  MA 02111-1307, USA.

include(`../config.m4')

C		cycles/limb
C POWER3/PPC630:     13
C POWER4/PPC970:     17


C void mpn_divexact_by3 (mp_ptr dst, mp_srcptr src, mp_size_t size);
C
C mullw has the src[] limb in the second operand, since there's at least a
C chance of it giving an early-out on ppc630, which the inverse 0xAA..AB
C will never give.
C
C mulhwu has the "3" multiplier in the second operand, which is an early-out
C for ppc630.

ASM_START()
PROLOGUE(mpn_divexact_by3c)

	C r3	dst
	C r4	src
	C r5	size
	C r6	carry

	mtctr	r5		C size
	ld	r7, 0(r4)	C src[0]

	lis	r5, 0xAAAA	C Form the constant 0xAAAAAAAAAAAAAAAB.
	ori	r5, r5, 0xAAAA	C Could also use the toc, or find some
	rldimi	r5, r5, 32, 0	C more clever use of the rl* instructions
	addi	r5, r5, 1	C to save the addi

	subi	r3, r3, 8	C adjust dst for first stdu

	li	r0, 3		C multiplier 3

	subfc	r7, r6, r7	C l = src[0] - carry
	bdz	L(one)

L(top):
	C r0	3
	C r3	dst, incrementing
	C r4	src, incrementing
	C r5	inverse
	C r6	carry
	C r7	l

	mulld	r8, r5, r7	C q = l * inverse
	ldu	r7, 8(r4)	C src[i]

	C

	mulhdu	r6, r8, r0	C c = high(3*q)
	stdu	r8, 8(r3)	C dst[i-1] = q

	subfe	r7, r6, r7 	C l = s - carry
	bdnz	L(top)


L(one):
	subfe	r4, r4, r4	C ca 0 or -1

	mulld	r8, r7, r5	C q = l * inverse

	mulhdu	r6, r8, r0	C c = high(3*q)
	stdu	r8, 8(r3)	C dst[i] = q

	subf	r3, r4, r6	C carry + ca

	blr

EPILOGUE()
