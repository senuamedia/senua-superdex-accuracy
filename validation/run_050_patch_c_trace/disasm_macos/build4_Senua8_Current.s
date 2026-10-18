
~/code/superdex-build-f64/bin_build4/libmochi_physics_double.dylib:	file format mach-o 64-bit x86-64

Disassembly of section __TEXT,__text:

:
               	pushq	%rbp
               	movq	%rsp, %rbp
               	pushq	%r15
               	pushq	%r14
               	pushq	%r13
               	pushq	%r12
               	pushq	%rbx
               	andq	$-ADDR, %rsp
               	subq	$ADDR, %rsp            ## imm = ADDRC0
               	vmovsd	%xmm0, ADDR(%rsp)
               	movq	%r8, %rbx
               	movq	ADDR(%rbp), %r15
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movq	(%rax), %rax
               	movq	%rax, ADDR(%rsp)
               	movq	ADDR(%rbp), %rax
               	vmovupd	(%rax), %ymm0
               	vmovupd	ADDR(%rax), %ymm1
               	vmovupd	ADDR(%rax), %ymm2
               	vmovupd	ADDR(%rax), %ymm3
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm4 ## ymm4 = ymm0[0,1],ymm1[2],ymm0[3]
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm5 ## ymm5 = ymm0[2,3],ymm2[0,1]
               	vblendpd	$ADDR, %ymm5, %ymm4, %ymm6 ## ymm6 = ymm4[0],ymm5[1],ymm4[2],ymm5[3]
               	vblendpd	$ADDR, %ymm0, %ymm1, %ymm0 ## ymm0 = ymm1[0],ymm0[1],ymm1[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2,3]
               	vshufpd	$ADDR, %ymm1, %ymm0, %ymm8 ## ymm8 = ymm0[1],ymm1[0],ymm0[3],ymm1[2]
               	vblendpd	$ADDR, %ymm1, %ymm5, %ymm5 ## ymm5 = ymm5[0],ymm1[1],ymm5[2],ymm1[3]
               	vmovupd	ADDR(%rax), %ymm0
               	vmovupd	ADDR(%rax), %ymm1
               	vblendpd	$ADDR, %ymm0, %ymm3, %ymm2 ## ymm2 = ymm3[0,1],ymm0[2],ymm3[3]
               	vperm2f128	$ADDR, %ymm1, %ymm3, %ymm4 ## ymm4 = ymm3[2,3],ymm1[0,1]
               	vblendpd	$ADDR, %ymm4, %ymm2, %ymm7 ## ymm7 = ymm2[0],ymm4[1],ymm2[2],ymm4[3]
               	vblendpd	$ADDR, %ymm3, %ymm0, %ymm2 ## ymm2 = ymm0[0],ymm3[1],ymm0[2,3]
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[0,1],ymm1[2,3]
               	vshufpd	$ADDR, %ymm0, %ymm2, %ymm1 ## ymm1 = ymm2[1],ymm0[0],ymm2[3],ymm0[2]
               	vblendpd	$ADDR, %ymm0, %ymm4, %ymm0 ## ymm0 = ymm4[0],ymm0[1],ymm4[2],ymm0[3]
               	cmpb	$ADDR, ADDR(%r15)
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm5, ADDR(%rsp)
               	vmovapd	%ymm5, ADDR(%rsp)
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	%ymm8, ADDR(%rsp)
               	vmovapd	%ymm8, ADDR(%rsp)
               	vmovapd	%ymm7, ADDR(%rsp)
               	vmovapd	%ymm7, ADDR(%rsp)
               	vmovapd	%ymm6, ADDR(%rsp)
               	vmovapd	%ymm6, ADDR(%rsp)
               	jne	ADDR 
               	leaq	ADDR(%rbp), %rax
               	movq	(%rax), %rax
               	vmovupd	(%rax), %ymm0
               	vmovupd	ADDR(%rax), %ymm1
               	vmovupd	ADDR(%rax), %ymm2
               	vmovupd	ADDR(%rax), %ymm3
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm4 ## ymm4 = ymm0[0,1],ymm1[2],ymm0[3]
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm5 ## ymm5 = ymm0[2,3],ymm2[0,1]
               	vblendpd	$ADDR, %ymm5, %ymm4, %ymm4 ## ymm4 = ymm4[0],ymm5[1],ymm4[2],ymm5[3]
               	vmovapd	%ymm4, ADDR(%rsp)
               	vblendpd	$ADDR, %ymm0, %ymm1, %ymm0 ## ymm0 = ymm1[0],ymm0[1],ymm1[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2,3]
               	vshufpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[1],ymm1[0],ymm0[3],ymm1[2]
               	vmovapd	%ymm0, ADDR(%rsp)
               	vblendpd	$ADDR, %ymm1, %ymm5, %ymm0 ## ymm0 = ymm5[0],ymm1[1],ymm5[2],ymm1[3]
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovupd	ADDR(%rax), %ymm0
               	vmovupd	ADDR(%rax), %ymm1
               	vblendpd	$ADDR, %ymm0, %ymm3, %ymm2 ## ymm2 = ymm3[0,1],ymm0[2],ymm3[3]
               	vperm2f128	$ADDR, %ymm1, %ymm3, %ymm4 ## ymm4 = ymm3[2,3],ymm1[0,1]
               	vblendpd	$ADDR, %ymm4, %ymm2, %ymm2 ## ymm2 = ymm2[0],ymm4[1],ymm2[2],ymm4[3]
               	vmovapd	%ymm2, ADDR(%rsp)
               	vblendpd	$ADDR, %ymm3, %ymm0, %ymm2 ## ymm2 = ymm0[0],ymm3[1],ymm0[2,3]
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[0,1],ymm1[2,3]
               	vshufpd	$ADDR, %ymm0, %ymm2, %ymm1 ## ymm1 = ymm2[1],ymm0[0],ymm2[3],ymm0[2]
               	vmovapd	%ymm1, ADDR(%rsp)
               	vblendpd	$ADDR, %ymm0, %ymm4, %ymm0 ## ymm0 = ymm4[0],ymm0[1],ymm4[2],ymm0[3]
               	vmovapd	%ymm0, ADDR(%rsp)
               	movq	ADDR(%rbp), %r13
               	movzbl	ADDR(%r15), %eax
               	cmpb	$ADDR, %al
               	jne	ADDR 
               	leaq	ADDR(%rbp), %rcx
               	movq	(%rcx), %rcx
               	vmovupd	(%rcx), %ymm0
               	vmovupd	ADDR(%rcx), %ymm1
               	vmovupd	ADDR(%rcx), %ymm2
               	vmovupd	ADDR(%rcx), %ymm3
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm4 ## ymm4 = ymm0[0,1],ymm1[2],ymm0[3]
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm5 ## ymm5 = ymm0[2,3],ymm2[0,1]
               	vblendpd	$ADDR, %ymm5, %ymm4, %ymm7 ## ymm7 = ymm4[0],ymm5[1],ymm4[2],ymm5[3]
               	vblendpd	$ADDR, %ymm0, %ymm1, %ymm0 ## ymm0 = ymm1[0],ymm0[1],ymm1[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2,3]
               	vshufpd	$ADDR, %ymm1, %ymm0, %ymm6 ## ymm6 = ymm0[1],ymm1[0],ymm0[3],ymm1[2]
               	vblendpd	$ADDR, %ymm1, %ymm5, %ymm5 ## ymm5 = ymm5[0],ymm1[1],ymm5[2],ymm1[3]
               	vmovupd	ADDR(%rcx), %ymm0
               	vmovupd	ADDR(%rcx), %ymm1
               	vblendpd	$ADDR, %ymm0, %ymm3, %ymm2 ## ymm2 = ymm3[0,1],ymm0[2],ymm3[3]
               	vperm2f128	$ADDR, %ymm1, %ymm3, %ymm4 ## ymm4 = ymm3[2,3],ymm1[0,1]
               	vblendpd	$ADDR, %ymm4, %ymm2, %ymm8 ## ymm8 = ymm2[0],ymm4[1],ymm2[2],ymm4[3]
               	vblendpd	$ADDR, %ymm3, %ymm0, %ymm2 ## ymm2 = ymm0[0],ymm3[1],ymm0[2,3]
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[0,1],ymm1[2,3]
               	vshufpd	$ADDR, %ymm0, %ymm2, %ymm3 ## ymm3 = ymm2[1],ymm0[0],ymm2[3],ymm0[2]
               	vblendpd	$ADDR, %ymm0, %ymm4, %ymm2 ## ymm2 = ymm4[0],ymm0[1],ymm4[2],ymm0[3]
               	vmovapd	%ymm6, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm6, %ymm1
               	vmovapd	%ymm3, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm3, %ymm0
               	vmovapd	%ymm7, ADDR(%rsp)
               	vfmadd231pd	ADDR(%rsp), %ymm7, %ymm1 ## ymm1 = (ymm7 * mem) + ymm1
               	vmovapd	%ymm8, ADDR(%rsp)
               	vfmadd231pd	ADDR(%rsp), %ymm8, %ymm0 ## ymm0 = (ymm8 * mem) + ymm0
               	vmovapd	%ymm5, ADDR(%rsp)
               	vfmadd231pd	ADDR(%rsp), %ymm5, %ymm1 ## ymm1 = (ymm5 * mem) + ymm1
               	vmovapd	%ymm2, ADDR(%rsp)
               	vfmadd231pd	ADDR(%rsp), %ymm2, %ymm0 ## ymm0 = (ymm2 * mem) + ymm0
               	jmp	ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm0 ## ADDR 
               	vmovapd	%ymm0, %ymm1
               	vbroadcastsd	ADDR(%r13), %ymm2
               	vbroadcastsd	ADDR(%rip), %ymm3 ## ADDR 
               	testb	%al, ADDR(%r15)
               	vmovapd	%ymm3, ADDR(%rsp)
               	je	ADDR 
               	vucomisd	ADDR(%rip), %xmm2   ## ADDR 
               	vmovapd	%ymm3, ADDR(%rsp)
               	jbe	ADDR 
               	vsubpd	%ymm1, %ymm2, %ymm3
               	vbroadcastsd	ADDR(%rip), %ymm4 ## ADDR 
               	vaddpd	%ymm4, %ymm2, %ymm4
               	vdivpd	%ymm4, %ymm3, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vsubpd	%ymm0, %ymm2, %ymm3
               	vdivpd	%ymm4, %ymm3, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	jmp	ADDR 
               	vmovapd	%ymm3, ADDR(%rsp)
               	movq	ADDR(%rbp), %rcx
               	vmovsd	ADDR(%r13), %xmm3
               	vxorpd	%xmm4, %xmm4, %xmm4
               	vucomisd	%xmm4, %xmm3
               	movb	$ADDR, %al
               	ja	ADDR 
               	vmovsd	ADDR(%r13), %xmm3
               	vucomisd	%xmm4, %xmm3
               	ja	ADDR 
               	vmovsd	ADDR(%r13), %xmm3
               	vxorpd	%xmm5, %xmm5, %xmm5
               	vucomisd	%xmm5, %xmm3
               	seta	%al
               	movzbl	ADDR(%rbp), %r9d
               	vmovupd	(%rcx), %ymm5
               	vmovupd	ADDR(%rcx), %ymm6
               	vcmplepd	%ymm2, %ymm0, %ymm0
               	vmovapd	%ymm0, (%rsp)
               	vcmplepd	%ymm2, %ymm1, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovsd	ADDR(%r13), %xmm3
               	cmpb	$ADDR, ADDR(%r15)
               	je	ADDR 
               	vmovsd	ADDR(%r13), %xmm4
               	vaddsd	ADDR(%r13), %xmm4, %xmm1
               	vbroadcastsd	ADDR(%r13), %ymm0
               	vbroadcastsd	ADDR(%rip), %ymm2 ## ADDR 
               	vmovapd	%ymm5, ADDR(%rsp)
               	vxorpd	%ymm2, %ymm5, %ymm4
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	%ymm6, ADDR(%rsp)
               	vxorpd	%ymm2, %ymm6, %ymm2
               	vsubsd	%xmm1, %xmm3, %xmm1
               	vbroadcastsd	%xmm1, %ymm1
               	vmovapd	%ymm4, ADDR(%rsp)
               	vsubpd	%ymm1, %ymm4, %ymm8
               	vdivpd	%ymm0, %ymm8, %ymm9
               	vmovapd	%ymm2, ADDR(%rsp)
               	vsubpd	%ymm1, %ymm2, %ymm7
               	vdivpd	%ymm0, %ymm7, %ymm6
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vbroadcastsd	ADDR(%rip), %ymm5 ## ADDR 
               	vcmplepd	%ymm1, %ymm0, %ymm4
               	vandpd	%ymm5, %ymm8, %ymm2
               	vmovapd	%ymm5, ADDR(%rsp)
               	vandpd	%ymm5, %ymm7, %ymm5
               	vcmpltpd	%ymm2, %ymm0, %ymm2
               	vcmpltpd	%ymm5, %ymm0, %ymm5
               	vorpd	%ymm2, %ymm4, %ymm2
               	vmulsd	ADDR(%rip), %xmm3, %xmm10 ## ADDR 
               	vorpd	%ymm5, %ymm4, %ymm3
               	vbroadcastsd	%xmm10, %ymm12
               	vbroadcastsd	ADDR(%rip), %ymm10 ## ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm15 ## ADDR 
               	vmovapd	%ymm10, %ymm11
               	vfmadd213pd	%ymm15, %ymm9, %ymm11 ## ymm11 = (ymm9 * ymm11) + ymm15
               	vfmadd213pd	%ymm15, %ymm6, %ymm10 ## ymm10 = (ymm6 * ymm10) + ymm15
               	vmulpd	%ymm9, %ymm9, %ymm4
               	vmovapd	%ymm4, ADDR(%rsp)
               	vmulpd	%ymm4, %ymm9, %ymm13
               	vbroadcastsd	ADDR(%rip), %ymm4 ## ADDR 
               	vfnmadd231pd	%ymm4, %ymm13, %ymm11 ## ymm11 = -(ymm13 * ymm4) + ymm11
               	vmulpd	%ymm6, %ymm6, %ymm5
               	vmulpd	%ymm5, %ymm6, %ymm14
               	vfnmadd231pd	%ymm4, %ymm14, %ymm10 ## ymm10 = -(ymm14 * ymm4) + ymm10
               	vfmadd213pd	%ymm12, %ymm8, %ymm11 ## ymm11 = (ymm8 * ymm11) + ymm12
               	vfmadd213pd	%ymm12, %ymm7, %ymm10 ## ymm10 = (ymm7 * ymm10) + ymm12
               	vbroadcastsd	ADDR(%rip), %ymm4 ## ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm12 ## ADDR 
               	vfmadd213pd	%ymm15, %ymm4, %ymm9 ## ymm9 = (ymm4 * ymm9) + ymm15
               	vfnmadd231pd	%ymm13, %ymm12, %ymm9 ## ymm9 = -(ymm12 * ymm13) + ymm9
               	vfmadd213pd	%ymm15, %ymm4, %ymm6 ## ymm6 = (ymm4 * ymm6) + ymm15
               	vfnmadd231pd	%ymm14, %ymm12, %ymm6 ## ymm6 = -(ymm12 * ymm14) + ymm6
               	vblendvpd	%ymm2, %ymm8, %ymm11, %ymm11
               	vbroadcastsd	ADDR(%rip), %ymm12 ## ADDR 
               	vcmpnltpd	%ymm1, %ymm8, %ymm8
               	vandpd	%ymm12, %ymm8, %ymm8
               	vblendvpd	%ymm2, %ymm8, %ymm9, %ymm8
               	vblendvpd	%ymm3, %ymm7, %ymm10, %ymm9
               	vcmpnltpd	%ymm1, %ymm7, %ymm7
               	vandpd	%ymm7, %ymm12, %ymm7
               	vblendvpd	%ymm3, %ymm7, %ymm6, %ymm6
               	movzbl	ADDR(%rbp), %esi
               	movzbl	ADDR(%r15), %r14d
               	andb	%al, %r14b
               	vmaxpd	%ymm11, %ymm1, %ymm7
               	vmaxpd	%ymm9, %ymm1, %ymm11
               	vmaxpd	%ymm8, %ymm1, %ymm8
               	vmaxpd	%ymm6, %ymm1, %ymm6
               	vminpd	%ymm8, %ymm12, %ymm9
               	vmovapd	%ymm12, ADDR(%rsp)
               	vminpd	%ymm6, %ymm12, %ymm10
               	vandpd	ADDR(%rsp), %ymm7, %ymm6
               	vandpd	(%rsp), %ymm11, %ymm7
               	vbroadcastsd	(%r13), %ymm8
               	testb	%r9b, %r9b
               	je	ADDR 
               	vmulsd	ADDR(%rip), %xmm8, %xmm11 ## ADDR 
               	vmulpd	%ymm6, %ymm6, %ymm12
               	vmulpd	%ymm7, %ymm7, %ymm13
               	vbroadcastsd	%xmm11, %ymm11
               	vmulpd	%ymm12, %ymm11, %ymm12
               	vmovapd	%ymm12, ADDR(%rsp)
               	vmulpd	%ymm13, %ymm11, %ymm11
               	vmovapd	%ymm11, ADDR(%rsp)
               	movzbl	ADDR(%rbp), %r8d
               	vandpd	ADDR(%rsp), %ymm9, %ymm9
               	vandpd	(%rsp), %ymm10, %ymm10
               	movl	%esi, %ecx
               	orb	%r14b, %cl
               	cmpb	$ADDR, %cl
               	jne	ADDR 
               	vmulpd	%ymm6, %ymm8, %ymm11
               	vmulpd	%ymm7, %ymm8, %ymm12
               	vmulpd	%ymm9, %ymm11, %ymm11
               	vmulpd	%ymm10, %ymm12, %ymm12
               	testb	%sil, %sil
               	je	ADDR 
               	vmulpd	ADDR(%rsp), %ymm11, %ymm13
               	vmovapd	%ymm13, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm12, %ymm13
               	vmovapd	%ymm13, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm11, %ymm13
               	vmovapd	%ymm13, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm12, %ymm13
               	vmovapd	%ymm13, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm11, %ymm13
               	vmovapd	%ymm13, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm12, %ymm13
               	vmovapd	%ymm13, ADDR(%rsp)
               	testb	%r14b, %r14b
               	je	ADDR 
               	vmulpd	ADDR(%rsp), %ymm11, %ymm11
               	vmovapd	%ymm11, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm12, %ymm11
               	vmovapd	%ymm11, ADDR(%rsp)
               	testb	%r8b, %r8b
               	je	ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm11 ## ADDR 
               	vsubpd	ADDR(%rsp), %ymm11, %ymm4
               	vsubpd	%ymm5, %ymm11, %ymm5
               	vbroadcastsd	ADDR(%rip), %ymm11 ## ADDR 
               	vmulpd	%ymm4, %ymm11, %ymm4
               	vdivpd	%ymm0, %ymm4, %ymm4
               	vmulpd	%ymm5, %ymm11, %ymm5
               	vdivpd	%ymm0, %ymm5, %ymm0
               	vandnpd	%ymm4, %ymm2, %ymm2
               	vandnpd	%ymm0, %ymm3, %ymm0
               	vmaxpd	%ymm2, %ymm1, %ymm2
               	vmaxpd	%ymm0, %ymm1, %ymm0
               	vandpd	ADDR(%rsp), %ymm2, %ymm1
               	vandpd	(%rsp), %ymm0, %ymm0
               	vxorpd	ADDR(%rsp), %ymm8, %ymm2
               	vmulpd	%ymm1, %ymm6, %ymm1
               	vmulpd	%ymm0, %ymm7, %ymm0
               	vfmadd213pd	%ymm1, %ymm9, %ymm9 ## ymm9 = (ymm9 * ymm9) + ymm1
               	vfmadd213pd	%ymm0, %ymm10, %ymm10 ## ymm10 = (ymm10 * ymm10) + ymm0
               	vmulpd	%ymm2, %ymm9, %ymm0
               	vmulpd	%ymm2, %ymm10, %ymm1
               	vmovapd	ADDR(%rsp), %ymm6
               	vmulpd	%ymm0, %ymm6, %ymm2
               	vmovapd	ADDR(%rsp), %ymm8
               	vmulpd	%ymm1, %ymm8, %ymm3
               	vmovapd	ADDR(%rsp), %ymm10
               	vmulpd	%ymm0, %ymm10, %ymm4
               	vmovapd	ADDR(%rsp), %ymm11
               	vmulpd	%ymm1, %ymm11, %ymm5
               	vmovapd	ADDR(%rsp), %ymm7
               	vmulpd	%ymm0, %ymm7, %ymm0
               	vmovapd	ADDR(%rsp), %ymm9
               	vmulpd	%ymm1, %ymm9, %ymm1
               	vmulpd	%ymm2, %ymm6, %ymm6
               	vmovapd	%ymm6, ADDR(%rsp)
               	vmulpd	%ymm3, %ymm8, %ymm6
               	vmovapd	%ymm6, ADDR(%rsp)
               	vmulpd	%ymm4, %ymm10, %ymm6
               	vmovapd	%ymm6, ADDR(%rsp)
               	vmulpd	%ymm5, %ymm11, %ymm6
               	vmovapd	%ymm6, ADDR(%rsp)
               	vmulpd	%ymm0, %ymm7, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	%ymm1, %ymm9, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	%ymm2, %ymm10, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	%ymm3, %ymm11, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	%ymm2, %ymm7, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	%ymm3, %ymm9, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	%ymm4, %ymm7, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	%ymm5, %ymm9, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	testb	%al, %al
               	jne	ADDR 
               	testb	%r9b, %r9b
               	jne	ADDR 
               	testb	%sil, %sil
               	je	ADDR 
               	vmovaps	ADDR(%rsp), %ymm2
               	vmovaps	ADDR(%rsp), %ymm1
               	vblendps	$ADDR, %ymm1, %ymm2, %ymm0 ## ymm0 = ymm2[0,1],ymm1[2,3],ymm2[4,5],ymm1[6,7]
               	vmovaps	ADDR(%rsp), %ymm3
               	vunpcklpd	%ymm3, %ymm1, %ymm1 ## ymm1 = ymm1[0],ymm3[0],ymm1[2],ymm3[2]
               	vunpckhpd	%ymm2, %ymm3, %ymm2 ## ymm2 = ymm3[1],ymm2[1],ymm3[3],ymm2[3]
               	vperm2f128	$ADDR, %ymm0, %ymm1, %ymm3 ## ymm3 = ymm1[0,1],ymm0[0,1]
               	vmovups	%ymm3, (%rdx)
               	vblendps	$ADDR, %ymm1, %ymm2, %ymm1 ## ymm1 = ymm2[0,1,2,3],ymm1[4,5,6,7]
               	vmovups	%ymm1, ADDR(%rdx)
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm0 ## ymm0 = ymm0[2,3],ymm2[2,3]
               	vmovups	%ymm0, ADDR(%rdx)
               	vmovapd	ADDR(%rsp), %ymm2
               	vmovapd	ADDR(%rsp), %ymm1
               	vblendpd	$ADDR, %ymm1, %ymm2, %ymm0 ## ymm0 = ymm2[0],ymm1[1],ymm2[2],ymm1[3]
               	vmovapd	ADDR(%rsp), %ymm3
               	vunpcklpd	%ymm3, %ymm1, %ymm1 ## ymm1 = ymm1[0],ymm3[0],ymm1[2],ymm3[2]
               	vunpckhpd	%ymm2, %ymm3, %ymm2 ## ymm2 = ymm3[1],ymm2[1],ymm3[3],ymm2[3]
               	vperm2f128	$ADDR, %ymm0, %ymm1, %ymm3 ## ymm3 = ymm1[0,1],ymm0[0,1]
               	vmovupd	%ymm3, ADDR(%rdx)
               	vblendpd	$ADDR, %ymm1, %ymm2, %ymm1 ## ymm1 = ymm2[0,1],ymm1[2,3]
               	vmovupd	%ymm1, ADDR(%rdx)
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm0 ## ymm0 = ymm0[2,3],ymm2[2,3]
               	vmovupd	%ymm0, ADDR(%rdx)
               	testb	%r8b, %r8b
               	jne	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movq	(%rax), %rax
               	cmpq	ADDR(%rsp), %rax
               	jne	ADDR 
               	leaq	-ADDR(%rbp), %rsp
               	popq	%rbx
               	popq	%r12
               	popq	%r13
               	popq	%r14
               	popq	%r15
               	popq	%rbp
               	vzeroupper
               	retq
               	testb	%r8b, %r8b
               	jne	ADDR 
               	testb	%al, %al
               	je	ADDR 
               	movq	%rdi, ADDR(%rsp)
               	movq	%rdx, ADDR(%rsp)
               	leaq	ADDR(%rbp), %r12
               	leaq	ADDR(%rbp), %rax
               	leaq	ADDR(%rbp), %rcx
               	movq	(%rcx), %rcx
               	vmovupd	(%rcx), %ymm0
               	vmovupd	ADDR(%rcx), %ymm1
               	vmovupd	ADDR(%rcx), %ymm2
               	vmovupd	ADDR(%rcx), %ymm3
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm4 ## ymm4 = ymm0[0,1],ymm1[2],ymm0[3]
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm5 ## ymm5 = ymm0[2,3],ymm2[0,1]
               	vblendpd	$ADDR, %ymm5, %ymm4, %ymm12 ## ymm12 = ymm4[0],ymm5[1],ymm4[2],ymm5[3]
               	vblendpd	$ADDR, %ymm0, %ymm1, %ymm0 ## ymm0 = ymm1[0],ymm0[1],ymm1[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm0, %ymm0 ## ymm0 = ymm0[0,1],ymm2[2],ymm0[3]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2,3]
               	vblendpd	$ADDR, %ymm1, %ymm5, %ymm11 ## ymm11 = ymm5[0],ymm1[1],ymm5[2],ymm1[3]
               	vmovupd	ADDR(%rcx), %ymm1
               	vmovupd	ADDR(%rcx), %ymm2
               	vblendpd	$ADDR, %ymm1, %ymm3, %ymm4 ## ymm4 = ymm3[0,1],ymm1[2],ymm3[3]
               	vperm2f128	$ADDR, %ymm2, %ymm3, %ymm5 ## ymm5 = ymm3[2,3],ymm2[0,1]
               	vblendpd	$ADDR, %ymm5, %ymm4, %ymm14 ## ymm14 = ymm4[0],ymm5[1],ymm4[2],ymm5[3]
               	vblendpd	$ADDR, %ymm3, %ymm1, %ymm3 ## ymm3 = ymm1[0],ymm3[1],ymm1[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm3, %ymm3 ## ymm3 = ymm3[0,1],ymm2[2],ymm3[3]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2,3]
               	vblendpd	$ADDR, %ymm1, %ymm5, %ymm13 ## ymm13 = ymm5[0],ymm1[1],ymm5[2],ymm1[3]
               	movq	(%rax), %rax
               	vmovupd	(%rax), %ymm1
               	vmovupd	ADDR(%rax), %ymm2
               	vmovupd	ADDR(%rax), %ymm4
               	vmovupd	ADDR(%rax), %ymm5
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm6 ## ymm6 = ymm1[0,1],ymm2[2],ymm1[3]
               	vperm2f128	$ADDR, %ymm4, %ymm1, %ymm7 ## ymm7 = ymm1[2,3],ymm4[0,1]
               	vblendpd	$ADDR, %ymm7, %ymm6, %ymm6 ## ymm6 = ymm6[0],ymm7[1],ymm6[2],ymm7[3]
               	vblendpd	$ADDR, %ymm1, %ymm2, %ymm1 ## ymm1 = ymm2[0],ymm1[1],ymm2[2,3]
               	vblendpd	$ADDR, %ymm4, %ymm2, %ymm2 ## ymm2 = ymm2[0,1],ymm4[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm7, %ymm4 ## ymm4 = ymm7[0],ymm2[1],ymm7[2],ymm2[3]
               	vmovupd	ADDR(%rax), %ymm7
               	vmovupd	ADDR(%rax), %ymm8
               	vblendpd	$ADDR, %ymm7, %ymm5, %ymm9 ## ymm9 = ymm5[0,1],ymm7[2],ymm5[3]
               	vperm2f128	$ADDR, %ymm8, %ymm5, %ymm10 ## ymm10 = ymm5[2,3],ymm8[0,1]
               	vblendpd	$ADDR, %ymm10, %ymm9, %ymm9 ## ymm9 = ymm9[0],ymm10[1],ymm9[2],ymm10[3]
               	vblendpd	$ADDR, %ymm5, %ymm7, %ymm5 ## ymm5 = ymm7[0],ymm5[1],ymm7[2,3]
               	vblendpd	$ADDR, %ymm8, %ymm7, %ymm7 ## ymm7 = ymm7[0,1],ymm8[2,3]
               	vblendpd	$ADDR, %ymm7, %ymm10, %ymm8 ## ymm8 = ymm10[0],ymm7[1],ymm10[2],ymm7[3]
               	vmovapd	%ymm12, ADDR(%rsp)
               	vsubpd	%ymm6, %ymm12, %ymm12
               	vmovapd	%ymm14, ADDR(%rsp)
               	vsubpd	%ymm9, %ymm14, %ymm6
               	vshufpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[1],ymm2[0],ymm1[3],ymm2[2]
               	vshufpd	$ADDR, %ymm0, %ymm0, %ymm0 ## ymm0 = ymm0[1,0,3,2]
               	vmovapd	%ymm0, ADDR(%rsp)
               	vsubpd	%ymm1, %ymm0, %ymm14
               	vshufpd	$ADDR, %ymm7, %ymm5, %ymm0 ## ymm0 = ymm5[1],ymm7[0],ymm5[3],ymm7[2]
               	vshufpd	$ADDR, %ymm3, %ymm3, %ymm1 ## ymm1 = ymm3[1,0,3,2]
               	vmovapd	%ymm1, ADDR(%rsp)
               	vsubpd	%ymm0, %ymm1, %ymm2
               	vmovapd	%ymm11, ADDR(%rsp)
               	vsubpd	%ymm4, %ymm11, %ymm1
               	vmovapd	%ymm13, ADDR(%rsp)
               	vsubpd	%ymm8, %ymm13, %ymm0
               	cmpq	$ADDR, ADDR(%r12)
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	%ymm2, %ymm13
               	vmovapd	%ymm14, ADDR(%rsp)
               	vmovapd	%ymm6, ADDR(%rsp)
               	vmovapd	%ymm6, %ymm11
               	vmovapd	%ymm12, ADDR(%rsp)
               	jne	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movzbl	(%rax), %eax
               	testb	%al, %al
               	je	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	vmovsd	(%rax), %xmm0
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vucomisd	%xmm1, %xmm0
               	vmovaps	ADDR(%rsp), %ymm0
               	vmovaps	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm13
               	vmovapd	ADDR(%rsp), %ymm14
               	vmovapd	ADDR(%rsp), %ymm11
               	vmovapd	ADDR(%rsp), %ymm12
               	jbe	ADDR 
               	movq	(%r12), %rax
               	vmovupd	(%rax), %ymm0
               	vmovupd	ADDR(%rax), %ymm1
               	vmovupd	ADDR(%rax), %ymm2
               	vmovupd	ADDR(%rax), %ymm3
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm4 ## ymm4 = ymm0[0,1],ymm1[2],ymm0[3]
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm5 ## ymm5 = ymm0[2,3],ymm2[0,1]
               	vblendpd	$ADDR, %ymm5, %ymm4, %ymm4 ## ymm4 = ymm4[0],ymm5[1],ymm4[2],ymm5[3]
               	vblendpd	$ADDR, %ymm0, %ymm1, %ymm0 ## ymm0 = ymm1[0],ymm0[1],ymm1[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2,3]
               	vblendpd	$ADDR, %ymm1, %ymm5, %ymm2 ## ymm2 = ymm5[0],ymm1[1],ymm5[2],ymm1[3]
               	vmovupd	ADDR(%rax), %ymm5
               	vmovupd	ADDR(%rax), %ymm6
               	vblendpd	$ADDR, %ymm5, %ymm3, %ymm7 ## ymm7 = ymm3[0,1],ymm5[2],ymm3[3]
               	vperm2f128	$ADDR, %ymm6, %ymm3, %ymm8 ## ymm8 = ymm3[2,3],ymm6[0,1]
               	vblendpd	$ADDR, %ymm8, %ymm7, %ymm7 ## ymm7 = ymm7[0],ymm8[1],ymm7[2],ymm8[3]
               	vblendpd	$ADDR, %ymm3, %ymm5, %ymm3 ## ymm3 = ymm5[0],ymm3[1],ymm5[2,3]
               	vblendpd	$ADDR, %ymm6, %ymm5, %ymm5 ## ymm5 = ymm5[0,1],ymm6[2,3]
               	vblendpd	$ADDR, %ymm5, %ymm8, %ymm6 ## ymm6 = ymm8[0],ymm5[1],ymm8[2],ymm5[3]
               	vmovapd	ADDR(%rsp), %ymm8
               	vsubpd	%ymm4, %ymm8, %ymm12
               	vmovapd	ADDR(%rsp), %ymm4
               	vsubpd	%ymm7, %ymm4, %ymm11
               	vshufpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[1],ymm1[0],ymm0[3],ymm1[2]
               	vmovapd	ADDR(%rsp), %ymm1
               	vsubpd	%ymm0, %ymm1, %ymm14
               	vshufpd	$ADDR, %ymm5, %ymm3, %ymm0 ## ymm0 = ymm3[1],ymm5[0],ymm3[3],ymm5[2]
               	vmovapd	ADDR(%rsp), %ymm1
               	vsubpd	%ymm0, %ymm1, %ymm13
               	vmovapd	ADDR(%rsp), %ymm0
               	vsubpd	%ymm2, %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vsubpd	%ymm6, %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	testb	%r14b, %r14b
               	vmovapd	%ymm11, ADDR(%rsp)
               	vmovapd	%ymm12, ADDR(%rsp)
               	vmovapd	%ymm13, ADDR(%rsp)
               	vmovapd	%ymm14, ADDR(%rsp)
               	jne	ADDR 
               	cmpb	$ADDR, ADDR(%r15)
               	jne	ADDR 
               	leaq	ADDR(%rbp), %rax
               	movq	(%rax), %rax
               	vmovupd	(%rax), %ymm3
               	vmovupd	ADDR(%rax), %ymm2
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm0
               	vmulpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	ADDR(%rsp), %ymm1
               	vmulpd	ADDR(%rsp), %ymm1, %ymm1
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd132pd	ADDR(%rsp), %ymm0, %ymm2 ## ymm2 = (ymm2 * mem) + ymm0
               	vmovapd	ADDR(%rsp), %ymm3
               	vfmadd132pd	ADDR(%rsp), %ymm1, %ymm3 ## ymm3 = (ymm3 * mem) + ymm1
               	vmovapd	ADDR(%rsp), %ymm0
               	vfmadd132pd	ADDR(%rsp), %ymm2, %ymm0 ## ymm0 = (ymm0 * mem) + ymm2
               	vmovapd	ADDR(%rsp), %ymm1
               	vfmadd132pd	ADDR(%rsp), %ymm3, %ymm1 ## ymm1 = (ymm1 * mem) + ymm3
               	vmovapd	ADDR(%rsp), %ymm2
               	vsubpd	%ymm0, %ymm2, %ymm3
               	vmovapd	ADDR(%rsp), %ymm0
               	vsubpd	%ymm1, %ymm0, %ymm2
               	vbroadcastsd	(%r13), %ymm0
               	vmovaps	%ymm0, ADDR(%rsp)
               	vmovsd	ADDR(%r13), %xmm1
               	cmpb	$ADDR, ADDR(%r15)
               	jne	ADDR 
               	vxorpd	%xmm4, %xmm4, %xmm4
               	jmp	ADDR 
               	vmovsd	ADDR(%r13), %xmm4
               	vaddsd	ADDR(%r13), %xmm4, %xmm5
               	vbroadcastsd	ADDR(%r13), %ymm4
               	vmovapd	ADDR(%rsp), %ymm8
               	vxorpd	%ymm3, %ymm8, %ymm3
               	vsubsd	%xmm5, %xmm1, %xmm5
               	vbroadcastsd	%xmm5, %ymm7
               	vsubpd	%ymm7, %ymm3, %ymm6
               	vdivpd	%ymm4, %ymm6, %ymm5
               	vxorpd	%ymm2, %ymm8, %ymm2
               	vsubpd	%ymm7, %ymm2, %ymm2
               	vmulpd	%ymm5, %ymm5, %ymm3
               	vmulpd	%ymm3, %ymm5, %ymm8
               	vxorpd	%xmm3, %xmm3, %xmm3
               	vcmplepd	%ymm3, %ymm4, %ymm7
               	vbroadcastsd	ADDR(%rip), %ymm13 ## ADDR 
               	vmovapd	%ymm13, %ymm9
               	vbroadcastsd	ADDR(%rip), %ymm10 ## ADDR 
               	vfmadd213pd	%ymm10, %ymm5, %ymm9 ## ymm9 = (ymm5 * ymm9) + ymm10
               	vbroadcastsd	ADDR(%rip), %ymm15 ## ADDR 
               	vfnmadd231pd	%ymm15, %ymm8, %ymm9 ## ymm9 = -(ymm8 * ymm15) + ymm9
               	vbroadcastsd	ADDR(%rip), %ymm14 ## ADDR 
               	vfmadd213pd	%ymm10, %ymm14, %ymm5 ## ymm5 = (ymm14 * ymm5) + ymm10
               	vbroadcastsd	ADDR(%rip), %ymm12 ## ADDR 
               	vfnmadd231pd	%ymm8, %ymm12, %ymm5 ## ymm5 = -(ymm12 * ymm8) + ymm5
               	vmovapd	ADDR(%rsp), %ymm0
               	vandpd	%ymm0, %ymm6, %ymm8
               	vcmpltpd	%ymm8, %ymm4, %ymm8
               	vorpd	%ymm7, %ymm8, %ymm8
               	vmulsd	ADDR(%rip), %xmm1, %xmm1 ## ADDR 
               	vbroadcastsd	%xmm1, %ymm1
               	vfmadd213pd	%ymm1, %ymm6, %ymm9 ## ymm9 = (ymm6 * ymm9) + ymm1
               	vblendvpd	%ymm8, %ymm6, %ymm9, %ymm9
               	vcmpnltpd	%ymm3, %ymm6, %ymm6
               	vbroadcastsd	ADDR(%rip), %ymm11 ## ADDR 
               	vandpd	%ymm6, %ymm11, %ymm6
               	vblendvpd	%ymm8, %ymm6, %ymm5, %ymm5
               	vdivpd	%ymm4, %ymm2, %ymm6
               	vandpd	%ymm0, %ymm2, %ymm8
               	vcmpltpd	%ymm8, %ymm4, %ymm4
               	vmulpd	%ymm6, %ymm6, %ymm8
               	vmulpd	%ymm6, %ymm8, %ymm8
               	vorpd	%ymm4, %ymm7, %ymm4
               	vmovapd	%ymm13, %ymm7
               	vfmadd213pd	%ymm10, %ymm6, %ymm7 ## ymm7 = (ymm6 * ymm7) + ymm10
               	vfnmadd231pd	%ymm15, %ymm8, %ymm7 ## ymm7 = -(ymm8 * ymm15) + ymm7
               	vfmadd213pd	%ymm1, %ymm2, %ymm7 ## ymm7 = (ymm2 * ymm7) + ymm1
               	vfmadd213pd	%ymm10, %ymm14, %ymm6 ## ymm6 = (ymm14 * ymm6) + ymm10
               	vfnmadd231pd	%ymm8, %ymm12, %ymm6 ## ymm6 = -(ymm12 * ymm8) + ymm6
               	vblendvpd	%ymm4, %ymm2, %ymm7, %ymm1
               	vcmpnltpd	%ymm3, %ymm2, %ymm2
               	vandpd	%ymm2, %ymm11, %ymm2
               	vblendvpd	%ymm4, %ymm2, %ymm6, %ymm2
               	vmaxpd	%ymm9, %ymm3, %ymm4
               	vmaxpd	%ymm1, %ymm3, %ymm1
               	vmaxpd	%ymm5, %ymm3, %ymm5
               	vmaxpd	%ymm2, %ymm3, %ymm2
               	vminpd	%ymm5, %ymm11, %ymm3
               	vmovapd	ADDR(%rsp), %ymm5
               	vandpd	%ymm4, %ymm5, %ymm4
               	vandpd	%ymm3, %ymm5, %ymm3
               	vmovapd	ADDR(%rsp), %ymm0
               	vmulpd	%ymm4, %ymm0, %ymm4
               	vmulpd	%ymm3, %ymm4, %ymm3
               	vmovapd	(%rsp), %ymm4
               	vandpd	%ymm1, %ymm4, %ymm1
               	vmulpd	%ymm1, %ymm0, %ymm0
               	vminpd	%ymm2, %ymm11, %ymm1
               	vandpd	%ymm1, %ymm4, %ymm1
               	vmulpd	%ymm1, %ymm0, %ymm0
               	vmulpd	ADDR(%rsp), %ymm3, %ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm11
               	vmovapd	ADDR(%rsp), %ymm12
               	vmovapd	ADDR(%rsp), %ymm13
               	vmovapd	ADDR(%rsp), %ymm14
               	movq	ADDR(%rip), %r14    ## ADDR 
               	movzbl	(%r14), %eax
               	testb	%al, %al
               	je	ADDR 
               	movq	ADDR(%rip), %r12    ## ADDR 
               	cmpb	$ADDR, (%r12)
               	jne	ADDR 
               	vmovsd	ADDR(%r13), %xmm0
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vucomisd	%xmm1, %xmm0
               	jbe	ADDR 
               	vbroadcastsd	(%r13), %ymm0
               	vmovaps	%ymm0, ADDR(%rsp)
               	vmovsd	ADDR(%r13), %xmm7
               	cmpb	$ADDR, ADDR(%r15)
               	je	ADDR 
               	vmovsd	ADDR(%r13), %xmm1
               	vaddsd	ADDR(%r13), %xmm1, %xmm2
               	vbroadcastsd	ADDR(%r13), %ymm1
               	vsubsd	%xmm2, %xmm7, %xmm2
               	vbroadcastsd	%xmm2, %ymm2
               	vmovapd	ADDR(%rsp), %ymm0
               	vsubpd	%ymm2, %ymm0, %ymm6
               	vmovapd	ADDR(%rsp), %ymm0
               	vsubpd	%ymm2, %ymm0, %ymm3
               	vxorpd	%xmm2, %xmm2, %xmm2
               	vcmplepd	%ymm2, %ymm1, %ymm5
               	vmovapd	ADDR(%rsp), %ymm0
               	vandpd	%ymm0, %ymm6, %ymm4
               	vandpd	%ymm0, %ymm3, %ymm8
               	vcmpltpd	%ymm4, %ymm1, %ymm4
               	vcmpltpd	%ymm8, %ymm1, %ymm8
               	vorpd	%ymm4, %ymm5, %ymm11
               	vdivpd	%ymm1, %ymm6, %ymm10
               	vorpd	%ymm5, %ymm8, %ymm5
               	vdivpd	%ymm1, %ymm3, %ymm8
               	vbroadcastsd	ADDR(%rip), %ymm12 ## ADDR 
               	vmovapd	%ymm12, %ymm0
               	vbroadcastsd	ADDR(%rip), %ymm15 ## ADDR 
               	vfmadd213pd	%ymm15, %ymm10, %ymm0 ## ymm0 = (ymm10 * ymm0) + ymm15
               	vfmadd213pd	%ymm15, %ymm8, %ymm12 ## ymm12 = (ymm8 * ymm12) + ymm15
               	vmulpd	%ymm10, %ymm10, %ymm4
               	vmovapd	%ymm4, ADDR(%rsp)
               	vmulpd	%ymm4, %ymm10, %ymm13
               	vbroadcastsd	ADDR(%rip), %ymm4 ## ADDR 
               	vfnmadd231pd	%ymm4, %ymm13, %ymm0 ## ymm0 = -(ymm13 * ymm4) + ymm0
               	vmulpd	%ymm8, %ymm8, %ymm9
               	vmulpd	%ymm9, %ymm8, %ymm14
               	vfnmadd231pd	%ymm4, %ymm14, %ymm12 ## ymm12 = -(ymm14 * ymm4) + ymm12
               	vmulsd	ADDR(%rip), %xmm7, %xmm7 ## ADDR 
               	vbroadcastsd	%xmm7, %ymm7
               	vfmadd213pd	%ymm7, %ymm6, %ymm0 ## ymm0 = (ymm6 * ymm0) + ymm7
               	vfmadd213pd	%ymm7, %ymm3, %ymm12 ## ymm12 = (ymm3 * ymm12) + ymm7
               	vbroadcastsd	ADDR(%rip), %ymm4 ## ADDR 
               	vfmadd213pd	%ymm15, %ymm4, %ymm10 ## ymm10 = (ymm4 * ymm10) + ymm15
               	vbroadcastsd	ADDR(%rip), %ymm7 ## ADDR 
               	vfnmadd231pd	%ymm13, %ymm7, %ymm10 ## ymm10 = -(ymm7 * ymm13) + ymm10
               	vfmadd213pd	%ymm15, %ymm4, %ymm8 ## ymm8 = (ymm4 * ymm8) + ymm15
               	vfnmadd231pd	%ymm14, %ymm7, %ymm8 ## ymm8 = -(ymm7 * ymm14) + ymm8
               	vblendvpd	%ymm11, %ymm6, %ymm0, %ymm7
               	vcmpnltpd	%ymm2, %ymm6, %ymm6
               	vbroadcastsd	ADDR(%rip), %ymm0 ## ADDR 
               	vandpd	%ymm0, %ymm6, %ymm6
               	vblendvpd	%ymm11, %ymm6, %ymm10, %ymm6
               	vblendvpd	%ymm5, %ymm3, %ymm12, %ymm10
               	vcmpnltpd	%ymm2, %ymm3, %ymm3
               	vandpd	%ymm0, %ymm3, %ymm3
               	vblendvpd	%ymm5, %ymm3, %ymm8, %ymm3
               	vmaxpd	%ymm6, %ymm2, %ymm6
               	vmaxpd	%ymm3, %ymm2, %ymm3
               	vminpd	%ymm6, %ymm0, %ymm6
               	vminpd	%ymm3, %ymm0, %ymm3
               	vsubpd	ADDR(%rsp), %ymm0, %ymm8
               	vsubpd	%ymm9, %ymm0, %ymm9
               	vmulpd	%ymm4, %ymm8, %ymm8
               	vmulpd	%ymm4, %ymm9, %ymm9
               	vdivpd	%ymm1, %ymm8, %ymm8
               	vdivpd	%ymm1, %ymm9, %ymm1
               	vandnpd	%ymm8, %ymm11, %ymm4
               	vandnpd	%ymm1, %ymm5, %ymm1
               	vmaxpd	%ymm7, %ymm2, %ymm5
               	vmaxpd	%ymm10, %ymm2, %ymm7
               	vmaxpd	%ymm4, %ymm2, %ymm4
               	vmaxpd	%ymm1, %ymm2, %ymm1
               	vmovapd	ADDR(%rsp), %ymm8
               	vandpd	%ymm5, %ymm8, %ymm2
               	vandpd	%ymm6, %ymm8, %ymm5
               	vandpd	%ymm4, %ymm8, %ymm4
               	vmovapd	(%rsp), %ymm8
               	vandpd	%ymm7, %ymm8, %ymm6
               	vandpd	%ymm3, %ymm8, %ymm3
               	vandpd	%ymm1, %ymm8, %ymm1
               	vmulpd	%ymm4, %ymm2, %ymm4
               	vmovapd	ADDR(%rsp), %ymm0
               	vmulpd	%ymm2, %ymm0, %ymm2
               	vmulpd	%ymm5, %ymm2, %ymm2
               	vfmadd231pd	%ymm5, %ymm5, %ymm4 ## ymm4 = (ymm5 * ymm5) + ymm4
               	vmulpd	%ymm1, %ymm6, %ymm1
               	vmulpd	%ymm6, %ymm0, %ymm5
               	vmulpd	%ymm3, %ymm5, %ymm5
               	vfmadd231pd	%ymm3, %ymm3, %ymm1 ## ymm1 = (ymm3 * ymm3) + ymm1
               	vmulpd	%ymm0, %ymm4, %ymm3
               	vmulpd	%ymm0, %ymm1, %ymm0
               	vmovapd	ADDR(%rsp), %ymm1
               	vmulpd	%ymm2, %ymm1, %ymm10
               	vmulpd	%ymm1, %ymm3, %ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm1
               	vmulpd	%ymm5, %ymm1, %ymm15
               	vmulpd	%ymm1, %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovdqu	ADDR(%r13), %xmm0
               	vpextrb	$ADDR, %xmm0, %ecx
               	vmovapd	ADDR(%rsp), %ymm11
               	vmovapd	ADDR(%rsp), %ymm12
               	vmovapd	ADDR(%rsp), %ymm13
               	vmovapd	ADDR(%rsp), %ymm14
               	jmp	ADDR 
               	movzbl	ADDR(%r13), %ecx
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm15
               	vmovapd	ADDR(%rsp), %ymm10
               	movzbl	ADDR(%r15), %eax
               	movl	%eax, %edx
               	notb	%dl
               	orb	%cl, %dl
               	testb	$ADDR, %dl
               	je	ADDR 
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm4
               	vmovapd	ADDR(%rsp), %ymm5
               	vmovapd	ADDR(%rsp), %ymm6
               	vmovapd	ADDR(%rsp), %ymm1
               	vmovapd	ADDR(%rsp), %ymm8
               	vmovapd	ADDR(%rsp), %ymm9
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm0
               	vxorpd	ADDR(%rsp), %ymm0, %ymm4
               	vxorpd	ADDR(%rsp), %ymm0, %ymm5
               	vxorpd	ADDR(%rsp), %ymm0, %ymm9
               	vxorpd	ADDR(%rsp), %ymm0, %ymm6
               	vxorpd	ADDR(%rsp), %ymm0, %ymm8
               	vxorpd	ADDR(%rsp), %ymm0, %ymm1
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm9
               	vmulpd	%ymm9, %ymm9, %ymm0
               	vmovapd	ADDR(%rsp), %ymm6
               	vmulpd	%ymm6, %ymm6, %ymm1
               	vmovapd	ADDR(%rsp), %ymm4
               	vfmadd231pd	%ymm4, %ymm4, %ymm0 ## ymm0 = (ymm4 * ymm4) + ymm0
               	vmovapd	ADDR(%rsp), %ymm5
               	vfmadd231pd	%ymm5, %ymm5, %ymm1 ## ymm1 = (ymm5 * ymm5) + ymm1
               	vmovapd	ADDR(%rsp), %ymm8
               	vfmadd231pd	%ymm8, %ymm8, %ymm0 ## ymm0 = (ymm8 * ymm8) + ymm0
               	vsqrtpd	%ymm0, %ymm0
               	vmovapd	ADDR(%rsp), %ymm7
               	vfmadd231pd	%ymm7, %ymm7, %ymm1 ## ymm1 = (ymm7 * ymm7) + ymm1
               	vsqrtpd	%ymm1, %ymm2
               	vbroadcastsd	ADDR(%rip), %ymm1 ## ADDR 
               	vdivpd	%ymm0, %ymm1, %ymm3
               	vdivpd	%ymm2, %ymm1, %ymm1
               	vmulpd	%ymm3, %ymm4, %ymm4
               	vmulpd	%ymm1, %ymm5, %ymm5
               	vmulpd	%ymm3, %ymm9, %ymm9
               	vmulpd	%ymm6, %ymm1, %ymm6
               	vmulpd	%ymm3, %ymm8, %ymm8
               	vmulpd	%ymm7, %ymm1, %ymm7
               	vbroadcastsd	ADDR(%rip), %ymm3 ## ADDR 
               	vcmpltpd	%ymm3, %ymm0, %ymm1
               	vcmpltpd	%ymm3, %ymm2, %ymm0
               	vorpd	%ymm0, %ymm1, %ymm2
               	vtestpd	%ymm2, %ymm2
               	jne	ADDR 
               	vmovapd	%ymm7, %ymm1
               	vmulpd	%ymm14, %ymm9, %ymm3
               	vmulpd	%ymm6, %ymm13, %ymm2
               	vfmadd231pd	%ymm12, %ymm4, %ymm3 ## ymm3 = (ymm4 * ymm12) + ymm3
               	vfmadd231pd	%ymm11, %ymm5, %ymm2 ## ymm2 = (ymm5 * ymm11) + ymm2
               	vmovapd	%ymm8, ADDR(%rsp)
               	vfmadd231pd	ADDR(%rsp), %ymm8, %ymm3 ## ymm3 = (ymm8 * mem) + ymm3
               	vmovapd	%ymm1, ADDR(%rsp)
               	vfmadd231pd	ADDR(%rsp), %ymm1, %ymm2 ## ymm2 = (ymm1 * mem) + ymm2
               	vmovapd	%ymm4, ADDR(%rsp)
               	vmulpd	%ymm3, %ymm4, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm5, ADDR(%rsp)
               	vmulpd	%ymm2, %ymm5, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovsd	ADDR(%r13), %xmm0
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vucomisd	%xmm1, %xmm0
               	vmovapd	%ymm9, ADDR(%rsp)
               	vmovapd	%ymm3, ADDR(%rsp)
               	vmulpd	%ymm3, %ymm9, %ymm0
               	vmovapd	%ymm6, ADDR(%rsp)
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmulpd	%ymm6, %ymm2, %ymm1
               	vmovapd	%ymm0, ADDR(%rsp)
               	vsubpd	%ymm0, %ymm14, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm1, ADDR(%rsp)
               	vsubpd	%ymm1, %ymm13, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	jbe	ADDR 
               	movzbl	(%r14), %eax
               	testb	%al, %al
               	vmovapd	ADDR(%rsp), %ymm0
               	je	ADDR 
               	movzbl	(%r12), %r12d
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movzbl	(%rax), %eax
               	testb	%al, %al
               	je	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movzbl	(%rax), %r14d
               	jmp	ADDR 
               	xorl	%r12d, %r12d
               	xorl	%r14d, %r14d
               	vmovapd	ADDR(%rsp), %ymm0
               	vmovapd	ADDR(%rsp), %ymm1
               	vmulpd	ADDR(%rsp), %ymm1, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vsubpd	ADDR(%rsp), %ymm12, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vsubpd	ADDR(%rsp), %ymm11, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vmulpd	%ymm0, %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vmulpd	%ymm0, %ymm0, %ymm0
               	vmovapd	%ymm0, (%rsp)
               	movl	%r12d, %eax
               	orb	%r14b, %al
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vbroadcastsd	ADDR(%rip), %ymm0 ## ADDR 
               	vmovaps	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	testb	$ADDR, %al
               	je	ADDR 
               	vmovsd	ADDR(%r13), %xmm1
               	vmovsd	ADDR(%rsp), %xmm0
               	vdivsd	%xmm1, %xmm0, %xmm3
               	vmovapd	ADDR(%rsp), %ymm6
               	vdivpd	%ymm6, %ymm10, %ymm4
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vmovapd	ADDR(%rsp), %ymm2
               	vdivpd	%ymm2, %ymm15, %ymm5
               	vcmpltpd	%ymm6, %ymm0, %ymm6
               	vcmpltpd	%ymm2, %ymm0, %ymm7
               	vbroadcastsd	ADDR(%rip), %ymm2 ## ADDR 
               	vblendvpd	%ymm6, %ymm4, %ymm2, %ymm4
               	vblendvpd	%ymm7, %ymm5, %ymm2, %ymm5
               	vbroadcastsd	%xmm3, %ymm6
               	vmulpd	%ymm6, %ymm4, %ymm3
               	vmulpd	%ymm6, %ymm5, %ymm4
               	testb	%r12b, %r12b
               	jne	ADDR 
               	vmovapd	ADDR(%rsp), %ymm6
               	vmovapd	%ymm6, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm5
               	vmovapd	%ymm5, ADDR(%rsp)
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm6
               	vminpd	%ymm3, %ymm6, %ymm5
               	vmovapd	%ymm5, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm5
               	vminpd	%ymm4, %ymm5, %ymm7
               	vmovapd	%ymm7, ADDR(%rsp)
               	vcmpltpd	%ymm3, %ymm6, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vcmpltpd	%ymm4, %ymm5, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vdivsd	ADDR(%rsp), %xmm1, %xmm1
               	vbroadcastsd	%xmm1, %ymm1
               	vmovapd	%ymm1, %ymm3
               	vfnmadd213pd	%ymm2, %ymm6, %ymm3 ## ymm3 = -(ymm6 * ymm3) + ymm2
               	vfnmadd213pd	%ymm2, %ymm5, %ymm1 ## ymm1 = -(ymm5 * ymm1) + ymm2
               	vmaxpd	%ymm3, %ymm0, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmaxpd	%ymm1, %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vsubpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vsubpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vmovapd	ADDR(%rsp), %ymm1
               	vfmadd231pd	%ymm0, %ymm0, %ymm1 ## ymm1 = (ymm0 * ymm0) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vmovapd	(%rsp), %ymm1
               	vfmadd231pd	%ymm0, %ymm0, %ymm1 ## ymm1 = (ymm0 * ymm0) + ymm1
               	vmovapd	%ymm1, (%rsp)
               	testb	%r14b, %r14b
               	jne	ADDR 
               	vmovaps	ADDR(%rsp), %ymm0
               	vmovaps	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm0
               	vmulpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vmulpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vmovapd	ADDR(%rsp), %ymm1
               	vfmadd231pd	%ymm0, %ymm0, %ymm1 ## ymm1 = (ymm0 * ymm0) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vmovapd	(%rsp), %ymm1
               	vfmadd231pd	%ymm0, %ymm0, %ymm1 ## ymm1 = (ymm0 * ymm0) + ymm1
               	vmovapd	%ymm1, (%rsp)
               	testb	%r12b, %r12b
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm1
               	vmulpd	ADDR(%rsp), %ymm1, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vmulpd	ADDR(%rsp), %ymm2, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm1, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm2, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm1, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm2, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vsqrtpd	ADDR(%rsp), %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vsqrtpd	(%rsp), %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovsd	ADDR(%r13), %xmm1
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vmovapd	%xmm1, ADDR(%rsp)
               	vucomisd	%xmm0, %xmm1
               	jbe	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movzbl	(%rax), %eax
               	testb	%al, %al
               	je	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	vmovsd	(%rax), %xmm0
               	vmovsd	ADDR(%rsp), %xmm1
               	vmulsd	ADDR(%r13), %xmm1, %xmm1
               	vxorpd	%xmm2, %xmm2, %xmm2
               	vcmpltsd	%xmm0, %xmm2, %xmm2
               	vblendvpd	%xmm2, %xmm0, %xmm1, %xmm0
               	vbroadcastsd	%xmm0, %ymm3
               	movl	ADDR(%r15), %eax
               	testl	%eax, %eax
               	je	ADDR 
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm0, ADDR(%rsp)
               	vxorpd	%xmm4, %xmm4, %xmm4
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vxorpd	%xmm2, %xmm2, %xmm2
               	cmpl	$ADDR, %eax
               	jne	ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm0 ## ADDR 
               	vmaxpd	%ymm0, %ymm3, %ymm1
               	vmulpd	%ymm1, %ymm1, %ymm0
               	vbroadcastsd	ADDR(%rip), %ymm2 ## ADDR 
               	vmulpd	%ymm2, %ymm0, %ymm3
               	vmovapd	ADDR(%rsp), %ymm0
               	vfmadd213pd	%ymm3, %ymm0, %ymm0 ## ymm0 = (ymm0 * ymm0) + ymm3
               	vmovapd	ADDR(%rsp), %ymm2
               	vsqrtpd	%ymm0, %ymm5
               	vfmadd213pd	%ymm3, %ymm2, %ymm2 ## ymm2 = (ymm2 * ymm2) + ymm3
               	vsqrtpd	%ymm2, %ymm2
               	vbroadcastsd	ADDR(%rip), %ymm4 ## ADDR 
               	vdivpd	%ymm5, %ymm4, %ymm0
               	vdivpd	%ymm2, %ymm4, %ymm4
               	vbroadcastsd	ADDR(%rip), %ymm6 ## ADDR 
               	vmulpd	%ymm6, %ymm1, %ymm6
               	vsubpd	%ymm6, %ymm5, %ymm1
               	vsubpd	%ymm6, %ymm2, %ymm2
               	vmulpd	%ymm0, %ymm0, %ymm5
               	vmulpd	%ymm4, %ymm4, %ymm6
               	vmulpd	%ymm5, %ymm0, %ymm5
               	vmulpd	%ymm6, %ymm4, %ymm6
               	vmulpd	%ymm5, %ymm3, %ymm5
               	vmovapd	%ymm5, ADDR(%rsp)
               	vmulpd	%ymm6, %ymm3, %ymm3
               	jmp	ADDR 
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovsd	ADDR(%r13), %xmm0
               	vxorpd	%xmm2, %xmm2, %xmm2
               	vucomisd	%xmm2, %xmm0
               	jbe	ADDR 
               	vdivsd	ADDR(%rsp), %xmm0, %xmm0
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vmovapd	%ymm1, %ymm5
               	vmulsd	ADDR(%rip), %xmm0, %xmm1 ## ADDR 
               	vmovapd	ADDR(%rsp), %ymm2
               	vmulpd	%ymm2, %ymm2, %ymm2
               	vmovapd	ADDR(%rsp), %ymm3
               	vmulpd	%ymm3, %ymm3, %ymm3
               	vbroadcastsd	%xmm1, %ymm4
               	vmulpd	%ymm4, %ymm2, %ymm1
               	vmulpd	%ymm4, %ymm3, %ymm2
               	testb	%r14b, %r14b
               	je	ADDR 
               	vmulpd	ADDR(%rsp), %ymm1, %ymm1
               	vmulpd	ADDR(%rsp), %ymm2, %ymm2
               	vaddpd	%ymm1, %ymm5, %ymm1
               	vmovapd	ADDR(%rsp), %ymm3
               	vaddpd	%ymm2, %ymm3, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	movzbl	ADDR(%rbp), %ecx
               	movl	%ecx, %eax
               	orb	ADDR(%rbp), %al
               	cmpb	$ADDR, %al
               	vmovapd	%ymm1, (%rsp)
               	jne	ADDR 
               	vbroadcastsd	%xmm0, %ymm1
               	vmulpd	ADDR(%rsp), %ymm1, %ymm0
               	vmulpd	ADDR(%rsp), %ymm1, %ymm1
               	testb	%cl, %cl
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm2
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm2 ## ymm2 = -(ymm0 * mem) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfnmadd231pd	ADDR(%rsp), %ymm1, %ymm2 ## ymm2 = -(ymm1 * mem) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm2 ## ymm2 = -(ymm0 * mem) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfnmadd231pd	ADDR(%rsp), %ymm1, %ymm2 ## ymm2 = -(ymm1 * mem) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm2 ## ymm2 = -(ymm0 * mem) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfnmadd231pd	ADDR(%rsp), %ymm1, %ymm2 ## ymm2 = -(ymm1 * mem) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm2
               	vsubpd	%ymm0, %ymm2, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vsubpd	%ymm1, %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovsd	ADDR(%r13), %xmm1
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vxorpd	%xmm2, %xmm2, %xmm2
               	vucomisd	%xmm2, %xmm1
               	vxorpd	%xmm2, %xmm2, %xmm2
               	ja	ADDR 
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm11
               	vdivpd	%ymm3, %ymm11, %ymm0
               	vmovapd	ADDR(%rsp), %ymm12
               	vdivpd	%ymm3, %ymm12, %ymm4
               	vcmplepd	%ymm11, %ymm3, %ymm7
               	vcmplepd	%ymm12, %ymm3, %ymm5
               	vxorpd	%xmm6, %xmm6, %xmm6
               	vbroadcastsd	ADDR(%rip), %ymm1 ## ADDR 
               	vmulpd	%ymm1, %ymm3, %ymm2
               	vmulpd	%ymm0, %ymm11, %ymm9
               	vbroadcastsd	ADDR(%rip), %ymm8 ## ADDR 
               	vmovapd	%ymm1, %ymm10
               	vfnmadd213pd	%ymm8, %ymm0, %ymm10 ## ymm10 = -(ymm0 * ymm10) + ymm8
               	vmulpd	%ymm10, %ymm9, %ymm9
               	vmulpd	%ymm4, %ymm12, %ymm10
               	vfnmadd213pd	%ymm8, %ymm4, %ymm1 ## ymm1 = -(ymm4 * ymm1) + ymm8
               	vmulpd	%ymm1, %ymm10, %ymm10
               	vsubpd	%ymm2, %ymm11, %ymm1
               	vsubpd	%ymm2, %ymm12, %ymm2
               	vblendvpd	%ymm7, %ymm1, %ymm9, %ymm1
               	vblendvpd	%ymm5, %ymm2, %ymm10, %ymm2
               	vsubpd	%ymm0, %ymm8, %ymm9
               	vdivpd	%ymm11, %ymm8, %ymm10
               	vcmpneqpd	ADDR(%rsp), %ymm6, %ymm11
               	vandpd	%ymm10, %ymm11, %ymm10
               	vbroadcastsd	ADDR(%rip), %ymm11 ## ADDR 
               	vaddpd	%ymm9, %ymm9, %ymm9
               	vdivpd	%ymm3, %ymm9, %ymm9
               	vsubpd	%ymm0, %ymm11, %ymm0
               	vdivpd	%ymm3, %ymm0, %ymm0
               	vblendvpd	%ymm7, %ymm10, %ymm0, %ymm0
               	vandnpd	%ymm9, %ymm7, %ymm7
               	vmovapd	%ymm7, ADDR(%rsp)
               	vsubpd	%ymm4, %ymm8, %ymm7
               	vaddpd	%ymm7, %ymm7, %ymm7
               	vdivpd	%ymm3, %ymm7, %ymm7
               	vsubpd	%ymm4, %ymm11, %ymm4
               	vdivpd	%ymm3, %ymm4, %ymm3
               	vcmpneqpd	(%rsp), %ymm6, %ymm4
               	vdivpd	%ymm12, %ymm8, %ymm6
               	vandpd	%ymm6, %ymm4, %ymm4
               	vblendvpd	%ymm5, %ymm4, %ymm3, %ymm4
               	vandnpd	%ymm7, %ymm5, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vbroadcastsd	ADDR(%rsp), %ymm3
               	vmulpd	%ymm1, %ymm3, %ymm1
               	vmulpd	%ymm2, %ymm3, %ymm2
               	testb	%r14b, %r14b
               	je	ADDR 
               	vmulpd	ADDR(%rsp), %ymm1, %ymm1
               	vmovapd	%ymm1, (%rsp)
               	vmulpd	ADDR(%rsp), %ymm2, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	jmp	ADDR 
               	vmovsd	ADDR(%r13), %xmm1
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vucomisd	%xmm0, %xmm1
               	ja	ADDR 
               	jmp	ADDR 
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	%ymm1, (%rsp)
               	movzbl	ADDR(%rbp), %ecx
               	movl	%ecx, %eax
               	orb	ADDR(%rbp), %al
               	cmpb	$ADDR, %al
               	jne	ADDR 
               	vbroadcastsd	ADDR(%rsp), %ymm1
               	vmulpd	ADDR(%rsp), %ymm1, %ymm2
               	vmulpd	ADDR(%rsp), %ymm1, %ymm1
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmulpd	%ymm0, %ymm2, %ymm0
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmulpd	%ymm4, %ymm1, %ymm1
               	testb	%cl, %cl
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	%ymm0, ADDR(%rsp)
               	je	ADDR 
               	vmovapd	%ymm0, %ymm2
               	vmovapd	ADDR(%rsp), %ymm0
               	vfnmadd231pd	ADDR(%rsp), %ymm2, %ymm0 ## ymm0 = -(ymm2 * mem) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vfnmadd231pd	ADDR(%rsp), %ymm1, %ymm0 ## ymm0 = -(ymm1 * mem) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vfnmadd231pd	ADDR(%rsp), %ymm2, %ymm0 ## ymm0 = -(ymm2 * mem) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vfnmadd231pd	ADDR(%rsp), %ymm1, %ymm0 ## ymm0 = -(ymm1 * mem) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vfnmadd231pd	ADDR(%rsp), %ymm2, %ymm0 ## ymm0 = -(ymm2 * mem) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vfnmadd231pd	ADDR(%rsp), %ymm1, %ymm0 ## ymm0 = -(ymm1 * mem) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%rbp)
               	vmovapd	(%rsp), %ymm1
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm0
               	vxorpd	ADDR(%rsp), %ymm0, %ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vxorpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%r15)
               	jne	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movzbl	(%rax), %eax
               	testb	%al, %al
               	je	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	vmovsd	(%rax), %xmm0
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vucomisd	%xmm1, %xmm0
               	jbe	ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm0 ## ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm1 ## ADDR 
               	vmovapd	ADDR(%rsp), %ymm3
               	vaddpd	%ymm0, %ymm3, %ymm2
               	vdivpd	%ymm2, %ymm1, %ymm2
               	vmovapd	ADDR(%rsp), %ymm4
               	vaddpd	%ymm0, %ymm4, %ymm0
               	vdivpd	%ymm0, %ymm1, %ymm0
               	vbroadcastsd	ADDR(%rip), %ymm1 ## ADDR 
               	vmovapd	ADDR(%rsp), %ymm5
               	vmovapd	ADDR(%rsp), %ymm6
               	vfnmadd132pd	ADDR(%rsp), %ymm6, %ymm5 ## ymm5 = -(ymm5 * mem) + ymm6
               	vcmpltpd	%ymm3, %ymm1, %ymm3
               	vcmpltpd	%ymm4, %ymm1, %ymm1
               	vmovapd	ADDR(%rsp), %ymm6
               	vmovapd	ADDR(%rsp), %ymm4
               	vfnmadd132pd	ADDR(%rsp), %ymm4, %ymm6 ## ymm6 = -(ymm6 * mem) + ymm4
               	vmulpd	ADDR(%rsp), %ymm2, %ymm4
               	vmovapd	%ymm4, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm0, %ymm4
               	vmovapd	%ymm4, ADDR(%rsp)
               	vandpd	%ymm5, %ymm3, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm2, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vandpd	%ymm6, %ymm1, %ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm0, %ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm2, %ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	jmp	ADDR 
               	vmovapd	(%rsp), %ymm1
               	vmovsd	ADDR(%r13), %xmm0
               	vxorpd	%xmm2, %xmm2, %xmm2
               	vucomisd	%xmm2, %xmm0
               	ja	ADDR 
               	vmovapd	%ymm1, (%rsp)
               	vmovsd	ADDR(%r13), %xmm1
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vucomisd	%xmm0, %xmm1
               	jbe	ADDR 
               	vdivsd	ADDR(%rsp), %xmm1, %xmm0
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	testb	%r12b, %r12b
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm5
               	vmulpd	%ymm5, %ymm5, %ymm1
               	vmovapd	ADDR(%rsp), %ymm6
               	vmulpd	%ymm6, %ymm6, %ymm2
               	vmovapd	ADDR(%rsp), %ymm3
               	vsubpd	%ymm5, %ymm3, %ymm3
               	vmovapd	ADDR(%rsp), %ymm4
               	vsubpd	%ymm6, %ymm4, %ymm4
               	vmulpd	%ymm3, %ymm5, %ymm3
               	vmulpd	%ymm4, %ymm6, %ymm4
               	vbroadcastsd	ADDR(%rip), %ymm5 ## ADDR 
               	vfmadd231pd	%ymm1, %ymm5, %ymm3 ## ymm3 = (ymm5 * ymm1) + ymm3
               	vfmadd231pd	%ymm2, %ymm5, %ymm4 ## ymm4 = (ymm5 * ymm2) + ymm4
               	vbroadcastsd	%xmm0, %ymm1
               	vmovapd	(%rsp), %ymm2
               	vfmadd231pd	%ymm3, %ymm1, %ymm2 ## ymm2 = (ymm1 * ymm3) + ymm2
               	vmovapd	%ymm2, (%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm4, %ymm1, %ymm2 ## ymm2 = (ymm1 * ymm4) + ymm2
               	jmp	ADDR 
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vxorpd	%xmm2, %xmm2, %xmm2
               	cmpb	$ADDR, ADDR(%rbp)
               	jne	ADDR 
               	movq	ADDR(%rsp), %rdx
               	movq	ADDR(%rsp), %rdi
               	movzbl	ADDR(%rbp), %esi
               	movzbl	ADDR(%rbp), %r14d
               	jmp	ADDR 
               	vmulsd	ADDR(%rip), %xmm0, %xmm1 ## ADDR 
               	vmovapd	ADDR(%rsp), %ymm2
               	vmulpd	%ymm2, %ymm2, %ymm2
               	vmovapd	ADDR(%rsp), %ymm3
               	vmulpd	%ymm3, %ymm3, %ymm3
               	vbroadcastsd	%xmm1, %ymm1
               	vmovapd	(%rsp), %ymm4
               	vfmadd231pd	%ymm2, %ymm1, %ymm4 ## ymm4 = (ymm1 * ymm2) + ymm4
               	vmovapd	%ymm4, (%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm3, %ymm1, %ymm2 ## ymm2 = (ymm1 * ymm3) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	movzbl	ADDR(%rbp), %esi
               	movl	%esi, %eax
               	orb	ADDR(%rbp), %al
               	cmpb	$ADDR, %al
               	jne	ADDR 
               	vbroadcastsd	%xmm0, %ymm1
               	vmulpd	ADDR(%rsp), %ymm1, %ymm0
               	vmulpd	ADDR(%rsp), %ymm1, %ymm1
               	testb	%sil, %sil
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm2
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm2 ## ymm2 = -(ymm0 * mem) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfnmadd231pd	ADDR(%rsp), %ymm1, %ymm2 ## ymm2 = -(ymm1 * mem) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm2 ## ymm2 = -(ymm0 * mem) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfnmadd231pd	ADDR(%rsp), %ymm1, %ymm2 ## ymm2 = -(ymm1 * mem) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm2 ## ymm2 = -(ymm0 * mem) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfnmadd231pd	ADDR(%rsp), %ymm1, %ymm2 ## ymm2 = -(ymm1 * mem) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm3
               	vxorpd	%ymm3, %ymm0, %ymm2
               	vxorpd	%ymm3, %ymm1, %ymm0
               	testb	%r12b, %r12b
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm1
               	vmovapd	ADDR(%rsp), %ymm3
               	vblendvpd	%ymm3, %ymm2, %ymm1, %ymm2
               	vmovapd	ADDR(%rsp), %ymm1
               	vmovapd	ADDR(%rsp), %ymm3
               	vblendvpd	%ymm3, %ymm0, %ymm1, %ymm0
               	vmovapd	ADDR(%rsp), %ymm8
               	vsubpd	%ymm8, %ymm2, %ymm1
               	vmovapd	ADDR(%rsp), %ymm6
               	vmulpd	%ymm6, %ymm1, %ymm2
               	vmovapd	ADDR(%rsp), %ymm7
               	vmulpd	%ymm7, %ymm1, %ymm3
               	vmovapd	ADDR(%rsp), %ymm5
               	vmulpd	%ymm5, %ymm1, %ymm1
               	vfmadd213pd	%ymm8, %ymm2, %ymm6 ## ymm6 = (ymm2 * ymm6) + ymm8
               	vmovapd	ADDR(%rsp), %ymm4
               	vfmadd231pd	%ymm5, %ymm3, %ymm4 ## ymm4 = (ymm3 * ymm5) + ymm4
               	vmovapd	%ymm4, ADDR(%rsp)
               	vfmadd213pd	%ymm8, %ymm7, %ymm3 ## ymm3 = (ymm7 * ymm3) + ymm8
               	vfmadd213pd	%ymm8, %ymm5, %ymm1 ## ymm1 = (ymm5 * ymm1) + ymm8
               	vmovapd	ADDR(%rsp), %ymm4
               	vfmadd231pd	%ymm7, %ymm2, %ymm4 ## ymm4 = (ymm2 * ymm7) + ymm4
               	vmovapd	%ymm4, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm10
               	vsubpd	%ymm10, %ymm0, %ymm0
               	vmovapd	ADDR(%rsp), %ymm4
               	vfmadd231pd	%ymm2, %ymm5, %ymm4 ## ymm4 = (ymm5 * ymm2) + ymm4
               	vmovapd	%ymm4, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm7
               	vmulpd	%ymm7, %ymm0, %ymm2
               	vmovapd	ADDR(%rsp), %ymm8
               	vmulpd	%ymm0, %ymm8, %ymm4
               	vmovapd	ADDR(%rsp), %ymm9
               	vmulpd	%ymm0, %ymm9, %ymm0
               	vfmadd213pd	%ymm10, %ymm2, %ymm7 ## ymm7 = (ymm2 * ymm7) + ymm10
               	vmovapd	ADDR(%rsp), %ymm5
               	vfmadd231pd	%ymm9, %ymm4, %ymm5 ## ymm5 = (ymm4 * ymm9) + ymm5
               	vmovapd	%ymm5, ADDR(%rsp)
               	vfmadd213pd	%ymm10, %ymm8, %ymm4 ## ymm4 = (ymm8 * ymm4) + ymm10
               	vfmadd213pd	%ymm10, %ymm9, %ymm0 ## ymm0 = (ymm9 * ymm0) + ymm10
               	vmovapd	ADDR(%rsp), %ymm5
               	vfmadd231pd	%ymm8, %ymm2, %ymm5 ## ymm5 = (ymm2 * ymm8) + ymm5
               	vmovapd	%ymm5, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm5
               	vfmadd231pd	%ymm2, %ymm9, %ymm5 ## ymm5 = (ymm9 * ymm2) + ymm5
               	vmovapd	%ymm5, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vaddpd	%ymm6, %ymm2, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vaddpd	%ymm7, %ymm2, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vaddpd	%ymm3, %ymm2, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vaddpd	%ymm4, %ymm2, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vaddpd	%ymm1, %ymm2, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm1
               	vaddpd	%ymm0, %ymm1, %ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%r15)
               	jne	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movzbl	(%rax), %eax
               	testb	%al, %al
               	movzbl	ADDR(%rbp), %r14d
               	je	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	vmovsd	(%rax), %xmm1
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vucomisd	%xmm0, %xmm1
               	movq	ADDR(%rsp), %rdx
               	movq	ADDR(%rsp), %rdi
               	movzbl	ADDR(%rbp), %esi
               	jbe	ADDR 
               	vmovsd	ADDR(%r13), %xmm1
               	vucomisd	%xmm0, %xmm1
               	ja	ADDR 
               	jmp	ADDR 
               	movq	ADDR(%rsp), %rdx
               	movq	ADDR(%rsp), %rdi
               	movzbl	ADDR(%rbp), %r14d
               	jmp	ADDR 
               	vmovsd	ADDR(%r13), %xmm0
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vucomisd	%xmm1, %xmm0
               	movq	ADDR(%rsp), %rdx
               	movq	ADDR(%rsp), %rdi
               	movzbl	ADDR(%rbp), %esi
               	movzbl	ADDR(%rbp), %r14d
               	jbe	ADDR 
               	vmovapd	ADDR(%rsp), %ymm2
               	vmovapd	ADDR(%rsp), %ymm5
               	vmulpd	%ymm5, %ymm2, %ymm0
               	vmovapd	ADDR(%rsp), %ymm1
               	vfmadd231pd	%ymm2, %ymm0, %ymm1 ## ymm1 = (ymm0 * ymm2) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm3
               	vmulpd	%ymm5, %ymm3, %ymm1
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm1, %ymm3, %ymm2 ## ymm2 = (ymm3 * ymm1) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm4
               	vmulpd	%ymm5, %ymm4, %ymm1
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm1, %ymm4, %ymm2 ## ymm2 = (ymm4 * ymm1) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm4, %ymm0, %ymm2 ## ymm2 = (ymm0 * ymm4) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm0, %ymm3, %ymm2 ## ymm2 = (ymm3 * ymm0) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vfmadd231pd	%ymm1, %ymm3, %ymm0 ## ymm0 = (ymm3 * ymm1) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vmovapd	ADDR(%rsp), %ymm5
               	vmulpd	%ymm5, %ymm2, %ymm0
               	vmovapd	ADDR(%rsp), %ymm1
               	vfmadd231pd	%ymm2, %ymm0, %ymm1 ## ymm1 = (ymm0 * ymm2) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm3
               	vmulpd	%ymm5, %ymm3, %ymm1
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm1, %ymm3, %ymm2 ## ymm2 = (ymm3 * ymm1) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm4
               	vmulpd	%ymm5, %ymm4, %ymm1
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm1, %ymm4, %ymm2 ## ymm2 = (ymm4 * ymm1) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm4, %ymm0, %ymm2 ## ymm2 = (ymm0 * ymm4) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm0, %ymm3, %ymm2 ## ymm2 = (ymm3 * ymm0) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vfmadd231pd	%ymm1, %ymm3, %ymm0 ## ymm0 = (ymm3 * ymm1) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	(%rsp), %ymm1
               	testb	%r14b, %r14b
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm0
               	vfmadd231pd	ADDR(%rsp), %ymm1, %ymm0 ## ymm0 = (ymm1 * mem) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vmovapd	ADDR(%rsp), %ymm1
               	vfmadd231pd	ADDR(%rsp), %ymm1, %ymm0 ## ymm0 = (ymm1 * mem) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	movzbl	ADDR(%rbp), %r8d
               	vmovaps	ADDR(%rsp), %ymm0
               	vmovups	%ymm0, (%rdi)
               	vmovapd	ADDR(%rsp), %ymm0
               	vmovupd	%ymm0, ADDR(%rdi)
               	testb	%sil, %sil
               	jne	ADDR 
               	testb	%r8b, %r8b
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm9
               	vpermpd	$ADDR, %ymm9, %ymm0     ## ymm0 = ymm9[3,3,3,3]
               	vmovapd	ADDR(%rsp), %ymm7
               	vextractf128	$ADDR, %ymm7, %xmm2
               	vblendpd	$ADDR, %ymm0, %ymm2, %ymm0 ## ymm0 = ymm0[0],ymm2[1,2,3]
               	vmovapd	ADDR(%rsp), %ymm11
               	vshufpd	$ADDR, %ymm11, %ymm11, %ymm1 ## ymm1 = ymm11[0,0,3,2]
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[0,1],ymm1[2],ymm0[3]
               	vpermpd	$ADDR, %ymm7, %ymm1     ## ymm1 = ymm7[3,3,3,3]
               	vmovapd	ADDR(%rsp), %ymm8
               	vextractf128	$ADDR, %ymm8, %xmm4
               	vblendpd	$ADDR, %ymm1, %ymm4, %ymm1 ## ymm1 = ymm1[0],ymm4[1,2,3]
               	vmovapd	ADDR(%rsp), %ymm12
               	vshufpd	$ADDR, %ymm12, %ymm12, %ymm3 ## ymm3 = ymm12[0,0,3,2]
               	vblendpd	$ADDR, %ymm3, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm3[2],ymm1[3]
               	vextractf128	$ADDR, %ymm9, %xmm3
               	vshufpd	$ADDR, %ymm2, %ymm3, %ymm3 ## ymm3 = ymm3[0],ymm2[0],ymm3[2],ymm2[3]
               	vshufpd	$ADDR, %ymm4, %ymm2, %ymm2 ## ymm2 = ymm2[0],ymm4[0],ymm2[2],ymm4[3]
               	vshufpd	$ADDR, %xmm7, %xmm7, %xmm4 ## xmm4 = xmm7[1,0]
               	vinsertf128	$ADDR, %xmm12, %ymm4, %ymm4
               	vmovapd	%xmm8, %xmm5
               	vshufpd	$ADDR, %ymm5, %ymm4, %ymm4 ## ymm4 = ymm4[0],ymm5[1],ymm4[3],ymm5[3]
               	vmovapd	%xmm9, %xmm5
               	vmovddup	%xmm7, %xmm6            ## xmm6 = xmm7[0,0]
               	vblendpd	$ADDR, %ymm6, %ymm5, %ymm5 ## ymm5 = ymm5[0],ymm6[1],ymm5[2,3]
               	vbroadcastsd	%xmm11, %ymm6
               	vblendpd	$ADDR, %ymm6, %ymm5, %ymm5 ## ymm5 = ymm5[0,1],ymm6[2],ymm5[3]
               	vshufpd	$ADDR, %xmm9, %xmm9, %xmm6 ## xmm6 = xmm9[1,0]
               	vinsertf128	$ADDR, %xmm11, %ymm6, %ymm6
               	vmovapd	%xmm7, %xmm7
               	vshufpd	$ADDR, %ymm7, %ymm6, %ymm6 ## ymm6 = ymm6[0],ymm7[1],ymm6[3],ymm7[3]
               	vmovddup	%xmm8, %xmm8            ## xmm8 = xmm8[0,0]
               	vblendpd	$ADDR, %ymm8, %ymm7, %ymm7 ## ymm7 = ymm7[0],ymm8[1],ymm7[2,3]
               	vbroadcastsd	%xmm12, %ymm8
               	vblendpd	$ADDR, %ymm8, %ymm7, %ymm7 ## ymm7 = ymm7[0,1],ymm8[2],ymm7[3]
               	vmovapd	%xmm11, %xmm9
               	vblendpd	$ADDR, %ymm8, %ymm9, %ymm8 ## ymm8 = ymm9[0],ymm8[1],ymm9[2,3]
               	vmovapd	ADDR(%rsp), %ymm10
               	vbroadcastsd	%xmm10, %ymm9
               	vblendpd	$ADDR, %ymm9, %ymm8, %ymm8 ## ymm8 = ymm8[0,1],ymm9[2],ymm8[3]
               	vmovupd	%ymm5, (%rbx)
               	vmovupd	%ymm7, ADDR(%rbx)
               	vmovupd	%ymm8, ADDR(%rbx)
               	vshufpd	$ADDR, %xmm11, %xmm11, %xmm5 ## xmm5 = xmm11[1,0]
               	vinsertf128	$ADDR, %xmm10, %ymm5, %ymm5
               	vmovapd	%xmm12, %xmm7
               	vshufpd	$ADDR, %ymm7, %ymm5, %ymm5 ## ymm5 = ymm5[0],ymm7[1],ymm5[3],ymm7[3]
               	vmovupd	%ymm6, ADDR(%rbx)
               	vmovupd	%ymm4, ADDR(%rbx)
               	vmovupd	%ymm5, ADDR(%rbx)
               	vblendpd	$ADDR, %ymm11, %ymm3, %ymm3 ## ymm3 = ymm3[0,1],ymm11[2],ymm3[3]
               	vmovupd	%ymm3, ADDR(%rbx)
               	vblendpd	$ADDR, %ymm12, %ymm2, %ymm2 ## ymm2 = ymm2[0,1],ymm12[2],ymm2[3]
               	vmovupd	%ymm2, ADDR(%rbx)
               	vextractf128	$ADDR, %ymm11, %xmm2
               	vextractf128	$ADDR, %ymm12, %xmm3
               	vshufpd	$ADDR, %ymm3, %ymm2, %ymm2 ## ymm2 = ymm2[0],ymm3[0],ymm2[2],ymm3[3]
               	vblendpd	$ADDR, %ymm10, %ymm2, %ymm2 ## ymm2 = ymm2[0,1],ymm10[2],ymm2[3]
               	vmovupd	%ymm2, ADDR(%rbx)
               	vpermpd	$ADDR, %ymm11, %ymm2    ## ymm2 = ymm11[3,3,3,3]
               	vblendpd	$ADDR, %ymm2, %ymm3, %ymm2 ## ymm2 = ymm2[0],ymm3[1,2,3]
               	vshufpd	$ADDR, %ymm10, %ymm10, %ymm3 ## ymm3 = ymm10[0,0,3,2]
               	vblendpd	$ADDR, %ymm3, %ymm2, %ymm2 ## ymm2 = ymm2[0,1],ymm3[2],ymm2[3]
               	vmovupd	%ymm0, ADDR(%rbx)
               	vmovupd	%ymm1, ADDR(%rbx)
               	vmovupd	%ymm2, ADDR(%rbx)
               	vmovapd	ADDR(%rsp), %ymm9
               	vmovapd	%xmm9, %xmm0
               	vmovapd	ADDR(%rsp), %ymm8
               	vmovddup	%xmm8, %xmm1            ## xmm1 = xmm8[0,0]
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[0],ymm1[1],ymm0[2,3]
               	vmovapd	ADDR(%rsp), %ymm6
               	vbroadcastsd	%xmm6, %ymm1
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[0,1],ymm1[2],ymm0[3]
               	vmovapd	%xmm8, %xmm1
               	vmovapd	ADDR(%rsp), %ymm10
               	vmovddup	%xmm10, %xmm2           ## xmm2 = xmm10[0,0]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm2 ## ymm2 = ymm1[0],ymm2[1],ymm1[2,3]
               	vmovapd	ADDR(%rsp), %ymm7
               	vbroadcastsd	%xmm7, %ymm3
               	vblendpd	$ADDR, %ymm3, %ymm2, %ymm2 ## ymm2 = ymm2[0,1],ymm3[2],ymm2[3]
               	vmovapd	%xmm6, %xmm4
               	vblendpd	$ADDR, %ymm3, %ymm4, %ymm3 ## ymm3 = ymm4[0],ymm3[1],ymm4[2,3]
               	vmovapd	ADDR(%rsp), %ymm5
               	vbroadcastsd	%xmm5, %ymm4
               	vblendpd	$ADDR, %ymm4, %ymm3, %ymm3 ## ymm3 = ymm3[0,1],ymm4[2],ymm3[3]
               	vmovupd	%ymm0, ADDR(%rbx)
               	vmovupd	%ymm2, ADDR(%rbx)
               	vmovupd	%ymm3, ADDR(%rbx)
               	vshufpd	$ADDR, %xmm9, %xmm9, %xmm0 ## xmm0 = xmm9[1,0]
               	vinsertf128	$ADDR, %xmm6, %ymm0, %ymm0
               	vshufpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[0],ymm1[1],ymm0[3],ymm1[3]
               	vshufpd	$ADDR, %xmm8, %xmm8, %xmm1 ## xmm1 = xmm8[1,0]
               	vmovapd	%xmm10, %xmm2
               	vinsertf128	$ADDR, %xmm7, %ymm1, %ymm1
               	vshufpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0],ymm2[1],ymm1[3],ymm2[3]
               	vshufpd	$ADDR, %xmm6, %xmm6, %xmm2 ## xmm2 = xmm6[1,0]
               	vmovapd	%xmm7, %xmm3
               	vinsertf128	$ADDR, %xmm5, %ymm2, %ymm2
               	vshufpd	$ADDR, %ymm3, %ymm2, %ymm2 ## ymm2 = ymm2[0],ymm3[1],ymm2[3],ymm3[3]
               	vmovupd	%ymm0, ADDR(%rbx)
               	vmovupd	%ymm1, ADDR(%rbx)
               	vmovupd	%ymm2, ADDR(%rbx)
               	vextractf128	$ADDR, %ymm9, %xmm0
               	vextractf128	$ADDR, %ymm8, %xmm1
               	vshufpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[0],ymm1[0],ymm0[2],ymm1[3]
               	vblendpd	$ADDR, %ymm6, %ymm0, %ymm0 ## ymm0 = ymm0[0,1],ymm6[2],ymm0[3]
               	vextractf128	$ADDR, %ymm10, %xmm2
               	vshufpd	$ADDR, %ymm2, %ymm1, %ymm3 ## ymm3 = ymm1[0],ymm2[0],ymm1[2],ymm2[3]
               	vblendpd	$ADDR, %ymm7, %ymm3, %ymm3 ## ymm3 = ymm3[0,1],ymm7[2],ymm3[3]
               	vmovupd	%ymm0, ADDR(%rbx)
               	vextractf128	$ADDR, %ymm6, %xmm0
               	vmovupd	%ymm3, ADDR(%rbx)
               	vextractf128	$ADDR, %ymm7, %xmm3
               	vshufpd	$ADDR, %ymm3, %ymm0, %ymm0 ## ymm0 = ymm0[0],ymm3[0],ymm0[2],ymm3[3]
               	vblendpd	$ADDR, %ymm5, %ymm0, %ymm0 ## ymm0 = ymm0[0,1],ymm5[2],ymm0[3]
               	vmovupd	%ymm0, ADDR(%rbx)
               	vpermpd	$ADDR, %ymm9, %ymm0     ## ymm0 = ymm9[3,3,3,3]
               	vblendpd	$ADDR, %ymm0, %ymm1, %ymm0 ## ymm0 = ymm0[0],ymm1[1,2,3]
               	vshufpd	$ADDR, %ymm6, %ymm6, %ymm1 ## ymm1 = ymm6[0,0,3,2]
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[0,1],ymm1[2],ymm0[3]
               	vpermpd	$ADDR, %ymm8, %ymm1     ## ymm1 = ymm8[3,3,3,3]
               	vblendpd	$ADDR, %ymm1, %ymm2, %ymm1 ## ymm1 = ymm1[0],ymm2[1,2,3]
               	vshufpd	$ADDR, %ymm7, %ymm7, %ymm2 ## ymm2 = ymm7[0,0,3,2]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2],ymm1[3]
               	vpermpd	$ADDR, %ymm6, %ymm2     ## ymm2 = ymm6[3,3,3,3]
               	vblendpd	$ADDR, %ymm2, %ymm3, %ymm2 ## ymm2 = ymm2[0],ymm3[1,2,3]
               	vshufpd	$ADDR, %ymm5, %ymm5, %ymm3 ## ymm3 = ymm5[0,0,3,2]
               	vblendpd	$ADDR, %ymm3, %ymm2, %ymm2 ## ymm2 = ymm2[0,1],ymm3[2],ymm2[3]
               	vmovupd	%ymm0, ADDR(%rbx)
               	vmovupd	%ymm1, ADDR(%rbx)
               	vmovupd	%ymm2, ADDR(%rbx)
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movq	(%rax), %rax
               	cmpq	ADDR(%rsp), %rax
               	je	ADDR 
               	vzeroupper
               	callq	ADDR 
               	movzbl	ADDR(%rbp), %r8d
               	testb	%sil, %sil
               	je	ADDR 
               	jmp	ADDR 
               	vmovsd	ADDR(%r13), %xmm0
               	vxorpd	%xmm2, %xmm2, %xmm2
               	vucomisd	%xmm2, %xmm0
               	ja	ADDR 
               	jmp	ADDR 
               	vmovapd	%ymm10, (%rsp)
               	testb	$ADDR, %al
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm10
               	vxorpd	ADDR(%rsp), %ymm10, %ymm2
               	vxorpd	ADDR(%rsp), %ymm10, %ymm3
               	vblendvpd	%ymm1, %ymm2, %ymm4, %ymm4
               	vblendvpd	%ymm0, %ymm3, %ymm5, %ymm5
               	vxorpd	ADDR(%rsp), %ymm10, %ymm2
               	vxorpd	ADDR(%rsp), %ymm10, %ymm3
               	vblendvpd	%ymm1, %ymm2, %ymm9, %ymm9
               	vblendvpd	%ymm0, %ymm3, %ymm6, %ymm6
               	vxorpd	ADDR(%rsp), %ymm10, %ymm2
               	vxorpd	ADDR(%rsp), %ymm10, %ymm3
               	vblendvpd	%ymm1, %ymm2, %ymm8, %ymm8
               	vblendvpd	%ymm0, %ymm3, %ymm7, %ymm1
               	vmovapd	(%rsp), %ymm10
               	jmp	ADDR 
               	vandnpd	%ymm4, %ymm1, %ymm4
               	vandnpd	%ymm5, %ymm0, %ymm5
               	vandnpd	%ymm9, %ymm1, %ymm9
               	vandnpd	%ymm6, %ymm0, %ymm6
               	vandnpd	%ymm8, %ymm1, %ymm8
               	vandnpd	%ymm7, %ymm0, %ymm1
               	vmovapd	(%rsp), %ymm10
               	jmp	ADDR 
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	vzeroupper
               	callq	ADDR 
               	vmovapd	ADDR(%rsp), %ymm14
               	vmovapd	ADDR(%rsp), %ymm13
               	vmovapd	ADDR(%rsp), %ymm12
               	vmovapd	ADDR(%rsp), %ymm11
               	testl	%eax, %eax
               	je	ADDR 
               	leaq	ADDR(%rip), %rdi    ## ADDR 
               	vzeroupper
               	callq	ADDR 
               	testq	%rax, %rax
               	movq	ADDR(%rip), %rax    ## ADDR 
               	setne	(%rax)
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	callq	ADDR 
               	vmovapd	ADDR(%rsp), %ymm14
               	vmovapd	ADDR(%rsp), %ymm13
               	vmovapd	ADDR(%rsp), %ymm12
               	vmovapd	ADDR(%rsp), %ymm11
               	jmp	ADDR 
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	vzeroupper
               	callq	ADDR 
               	testl	%eax, %eax
               	je	ADDR 
               	leaq	ADDR(%rsp), %rdi
               	callq	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	vmovsd	%xmm0, (%rax)
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	callq	ADDR 
               	jmp	ADDR 
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	vmovapd	%ymm15, ADDR(%rsp)
               	vmovapd	%ymm10, (%rsp)
               	vzeroupper
               	callq	ADDR 
               	vmovapd	(%rsp), %ymm10
               	vmovapd	ADDR(%rsp), %ymm15
               	vmovapd	ADDR(%rsp), %ymm12
               	vmovapd	ADDR(%rsp), %ymm11
               	vmovapd	ADDR(%rsp), %ymm0
               	testl	%eax, %eax
               	je	ADDR 
               	leaq	ADDR(%rip), %rdi    ## ADDR 
               	vzeroupper
               	callq	ADDR 
               	testq	%rax, %rax
               	setne	(%r12)
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	callq	ADDR 
               	vmovapd	(%rsp), %ymm10
               	vmovapd	ADDR(%rsp), %ymm15
               	vmovapd	ADDR(%rsp), %ymm12
               	vmovapd	ADDR(%rsp), %ymm11
               	vmovapd	ADDR(%rsp), %ymm0
               	jmp	ADDR 
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	vmovapd	%ymm15, ADDR(%rsp)
               	vmovapd	%ymm10, (%rsp)
               	vzeroupper
               	callq	ADDR 
               	vmovapd	(%rsp), %ymm10
               	vmovapd	ADDR(%rsp), %ymm15
               	vmovapd	ADDR(%rsp), %ymm12
               	vmovapd	ADDR(%rsp), %ymm11
               	vmovapd	ADDR(%rsp), %ymm0
               	testl	%eax, %eax
               	je	ADDR 
               	leaq	ADDR(%rip), %rdi    ## ADDR 
               	vzeroupper
               	callq	ADDR 
               	testq	%rax, %rax
               	movq	ADDR(%rip), %rax    ## ADDR 
               	setne	(%rax)
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	callq	ADDR 
               	vmovapd	(%rsp), %ymm10
               	vmovapd	ADDR(%rsp), %ymm15
               	vmovapd	ADDR(%rsp), %ymm12
               	vmovapd	ADDR(%rsp), %ymm11
               	vmovapd	ADDR(%rsp), %ymm0
               	jmp	ADDR 
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	vzeroupper
               	callq	ADDR 
               	testl	%eax, %eax
               	je	ADDR 
               	leaq	ADDR(%rsp), %rdi
               	callq	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	vmovsd	%xmm0, (%rax)
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	callq	ADDR 
               	jmp	ADDR 
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	vzeroupper
               	callq	ADDR 
               	testl	%eax, %eax
               	je	ADDR 
               	leaq	ADDR(%rsp), %rdi
               	callq	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	vmovsd	%xmm0, (%rax)
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	callq	ADDR 
               	jmp	ADDR 
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	vzeroupper
               	callq	ADDR 
               	testl	%eax, %eax
               	je	ADDR 
               	leaq	ADDR(%rsp), %rdi
               	callq	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	vmovsd	%xmm0, (%rax)
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	callq	ADDR 
               	jmp	ADDR 
               	jmp	ADDR 
               	jmp	ADDR 
               	jmp	ADDR 
               	movq	%rax, %rbx
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	callq	ADDR 
               	movq	%rbx, %rdi
               	callq	ADDR 
               	nopw	%cs:(%rax,%rax)
