
~/code/superdex-build-f64/bin_build5/libmochi_physics_double.dylib:	file format mach-o 64-bit x86-64

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
               	subq	$ADDR, %rsp            ## imm = ADDR
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
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm3 ## ymm3 = ymm0[0,1],ymm1[2],ymm0[3]
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm4 ## ymm4 = ymm0[2,3],ymm2[0,1]
               	vblendpd	$ADDR, %ymm4, %ymm3, %ymm3 ## ymm3 = ymm3[0],ymm4[1],ymm3[2],ymm4[3]
               	vblendpd	$ADDR, %ymm0, %ymm1, %ymm0 ## ymm0 = ymm1[0],ymm0[1],ymm1[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2,3]
               	vshufpd	$ADDR, %ymm1, %ymm0, %ymm2 ## ymm2 = ymm0[1],ymm1[0],ymm0[3],ymm1[2]
               	cmpb	$ADDR, ADDR(%r15)
               	vblendpd	$ADDR, %ymm1, %ymm4, %ymm0 ## ymm0 = ymm4[0],ymm1[1],ymm4[2],ymm1[3]
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	%ymm3, ADDR(%rsp)
               	vmovapd	%ymm3, ADDR(%rsp)
               	jne	ADDR 
               	leaq	ADDR(%rbp), %rax
               	movq	(%rax), %rax
               	vmovupd	(%rax), %ymm0
               	vmovupd	ADDR(%rax), %ymm1
               	vmovupd	ADDR(%rax), %ymm2
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm3 ## ymm3 = ymm0[0,1],ymm1[2],ymm0[3]
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm4 ## ymm4 = ymm0[2,3],ymm2[0,1]
               	vblendpd	$ADDR, %ymm4, %ymm3, %ymm3 ## ymm3 = ymm3[0],ymm4[1],ymm3[2],ymm4[3]
               	vmovapd	%ymm3, ADDR(%rsp)
               	vblendpd	$ADDR, %ymm0, %ymm1, %ymm0 ## ymm0 = ymm1[0],ymm0[1],ymm1[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2,3]
               	vshufpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[1],ymm1[0],ymm0[3],ymm1[2]
               	vmovapd	%ymm0, ADDR(%rsp)
               	vblendpd	$ADDR, %ymm1, %ymm4, %ymm0 ## ymm0 = ymm4[0],ymm1[1],ymm4[2],ymm1[3]
               	vmovapd	%ymm0, ADDR(%rsp)
               	movq	ADDR(%rbp), %r12
               	cmpb	$ADDR, ADDR(%r15)
               	je	ADDR 
               	leaq	ADDR(%rbp), %rax
               	movq	(%rax), %rax
               	vmovupd	(%rax), %ymm0
               	vmovupd	ADDR(%rax), %ymm1
               	vmovupd	ADDR(%rax), %ymm2
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm3 ## ymm3 = ymm0[0,1],ymm1[2],ymm0[3]
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm4 ## ymm4 = ymm0[2,3],ymm2[0,1]
               	vblendpd	$ADDR, %ymm4, %ymm3, %ymm3 ## ymm3 = ymm3[0],ymm4[1],ymm3[2],ymm4[3]
               	vblendpd	$ADDR, %ymm0, %ymm1, %ymm0 ## ymm0 = ymm1[0],ymm0[1],ymm1[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2,3]
               	vshufpd	$ADDR, %ymm1, %ymm0, %ymm2 ## ymm2 = ymm0[1],ymm1[0],ymm0[3],ymm1[2]
               	vblendpd	$ADDR, %ymm1, %ymm4, %ymm0 ## ymm0 = ymm4[0],ymm1[1],ymm4[2],ymm1[3]
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm2, %ymm1
               	vmovapd	%ymm3, ADDR(%rsp)
               	vfmadd231pd	ADDR(%rsp), %ymm3, %ymm1 ## ymm1 = (ymm3 * mem) + ymm1
               	vbroadcastsd	ADDR(%r12), %ymm2
               	vmovapd	%ymm0, ADDR(%rsp)
               	vfmadd231pd	ADDR(%rsp), %ymm0, %ymm1 ## ymm1 = (ymm0 * mem) + ymm1
               	vcmplepd	%ymm2, %ymm1, %ymm0
               	vextractf128	$ADDR, %ymm0, %xmm3
               	vpackssdw	%xmm3, %xmm0, %xmm0
               	vbroadcastsd	ADDR(%rip), %ymm3 ## ADDR 
               	vmovapd	%ymm3, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%r15)
               	jne	ADDR 
               	vucomisd	ADDR(%rip), %xmm2   ## ADDR 
               	jbe	ADDR 
               	vsubpd	%ymm1, %ymm2, %ymm1
               	vbroadcastsd	ADDR(%rip), %ymm3 ## ADDR 
               	vaddpd	%ymm3, %ymm2, %ymm2
               	vdivpd	%ymm2, %ymm1, %ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	jmp	ADDR 
               	vmovsd	ADDR(%rip), %xmm0   ## ADDR 
               	vcmplesd	ADDR(%r12), %xmm0, %xmm0
               	vpackssdw	%xmm0, %xmm0, %xmm0
               	vpbroadcastd	%xmm0, %xmm0
               	vbroadcastsd	ADDR(%rip), %ymm1 ## ADDR 
               	vmovaps	%ymm1, ADDR(%rsp)
               	movq	ADDR(%rbp), %rcx
               	vmovsd	ADDR(%r12), %xmm2
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vucomisd	%xmm1, %xmm2
               	movb	$ADDR, %al
               	ja	ADDR 
               	vmovsd	ADDR(%r12), %xmm2
               	vucomisd	%xmm1, %xmm2
               	ja	ADDR 
               	vmovsd	ADDR(%r12), %xmm2
               	vxorpd	%xmm3, %xmm3, %xmm3
               	vucomisd	%xmm3, %xmm2
               	seta	%al
               	movzbl	ADDR(%rbp), %r13d
               	vmovupd	(%rcx), %ymm12
               	vmovsd	ADDR(%r12), %xmm2
               	cmpb	$ADDR, ADDR(%r15)
               	je	ADDR 
               	vmovsd	ADDR(%r12), %xmm1
               	vaddsd	ADDR(%r12), %xmm1, %xmm3
               	vbroadcastsd	ADDR(%r12), %ymm1
               	vbroadcastsd	ADDR(%rip), %ymm4 ## ADDR 
               	vmovapd	%ymm4, ADDR(%rsp)
               	vxorpd	%ymm4, %ymm12, %ymm4
               	vsubsd	%xmm3, %xmm2, %xmm2
               	vbroadcastsd	%xmm2, %ymm2
               	vmovapd	%ymm4, ADDR(%rsp)
               	vsubpd	%ymm2, %ymm4, %ymm6
               	vdivpd	%ymm1, %ymm6, %ymm5
               	vmulpd	%ymm5, %ymm5, %ymm3
               	vmulpd	%ymm3, %ymm5, %ymm7
               	vxorpd	%xmm2, %xmm2, %xmm2
               	vcmplepd	%ymm2, %ymm1, %ymm4
               	vbroadcastsd	ADDR(%rip), %ymm8 ## ADDR 
               	vmovapd	%ymm8, ADDR(%rsp)
               	vandpd	%ymm6, %ymm8, %ymm8
               	vcmpltpd	%ymm8, %ymm1, %ymm8
               	vbroadcastsd	ADDR(%rip), %ymm10 ## ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm11 ## ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm9 ## ADDR 
               	vorpd	%ymm4, %ymm8, %ymm4
               	vmovapd	%ymm11, %ymm8
               	vbroadcastsd	ADDR(%rip), %ymm11 ## ADDR 
               	vfmadd213pd	%ymm9, %ymm5, %ymm8 ## ymm8 = (ymm5 * ymm8) + ymm9
               	vfmadd231pd	%ymm11, %ymm7, %ymm8 ## ymm8 = (ymm7 * ymm11) + ymm8
               	vmulpd	%ymm6, %ymm8, %ymm8
               	vfmadd231pd	%ymm10, %ymm1, %ymm8 ## ymm8 = (ymm1 * ymm10) + ymm8
               	vblendvpd	%ymm4, %ymm6, %ymm8, %ymm8
               	vbroadcastsd	ADDR(%rip), %ymm10 ## ADDR 
               	vfmadd213pd	%ymm9, %ymm10, %ymm5 ## ymm5 = (ymm10 * ymm5) + ymm9
               	vbroadcastsd	ADDR(%rip), %ymm9 ## ADDR 
               	vfmadd231pd	%ymm7, %ymm9, %ymm5 ## ymm5 = (ymm9 * ymm7) + ymm5
               	vcmpnltpd	%ymm2, %ymm6, %ymm6
               	vbroadcastsd	ADDR(%rip), %ymm9 ## ADDR 
               	vandpd	%ymm6, %ymm9, %ymm6
               	vblendvpd	%ymm4, %ymm6, %ymm5, %ymm5
               	movzbl	ADDR(%r15), %r14d
               	andb	%al, %r14b
               	vmaxpd	%ymm8, %ymm2, %ymm7
               	vmaxpd	%ymm5, %ymm2, %ymm5
               	vmovapd	%ymm9, ADDR(%rsp)
               	vminpd	%ymm5, %ymm9, %ymm6
               	vpslld	$ADDR, %xmm0, %xmm0
               	vpsrad	$ADDR, %xmm0, %xmm0
               	vpmovsxdq	%xmm0, %ymm0
               	vmovdqa	%ymm0, ADDR(%rsp)
               	vpand	%ymm7, %ymm0, %ymm0
               	vbroadcastsd	(%r12), %ymm5
               	testb	%r13b, %r13b
               	je	ADDR 
               	vmulsd	ADDR(%rip), %xmm5, %xmm7 ## ADDR 
               	vmulpd	%ymm0, %ymm0, %ymm8
               	vbroadcastsd	%xmm7, %ymm7
               	vmulpd	%ymm7, %ymm8, %ymm7
               	vmovapd	%ymm7, ADDR(%rsp)
               	vandpd	ADDR(%rsp), %ymm6, %ymm6
               	movzbl	ADDR(%rbp), %ecx
               	orb	%r14b, %cl
               	cmpb	$ADDR, %cl
               	jne	ADDR 
               	vmulpd	%ymm0, %ymm5, %ymm7
               	vmulpd	%ymm6, %ymm7, %ymm7
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vmulpd	ADDR(%rsp), %ymm7, %ymm8
               	vmovapd	%ymm8, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm7, %ymm8
               	vmovapd	%ymm8, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm7, %ymm8
               	vmovapd	%ymm8, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm7, %ymm7
               	vmovapd	%ymm7, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm7 ## ADDR 
               	vsubpd	%ymm3, %ymm7, %ymm3
               	vbroadcastsd	ADDR(%rip), %ymm7 ## ADDR 
               	vmulpd	%ymm7, %ymm3, %ymm3
               	vdivpd	%ymm1, %ymm3, %ymm1
               	vandnpd	%ymm1, %ymm4, %ymm1
               	vmaxpd	%ymm1, %ymm2, %ymm1
               	vandpd	ADDR(%rsp), %ymm1, %ymm1
               	vxorpd	ADDR(%rsp), %ymm5, %ymm2
               	vmulpd	%ymm1, %ymm0, %ymm0
               	vfmadd213pd	%ymm0, %ymm6, %ymm6 ## ymm6 = (ymm6 * ymm6) + ymm0
               	vmulpd	%ymm2, %ymm6, %ymm0
               	vmovapd	ADDR(%rsp), %ymm3
               	vmulpd	%ymm0, %ymm3, %ymm1
               	vmovapd	ADDR(%rsp), %ymm5
               	vmulpd	%ymm0, %ymm5, %ymm2
               	vmovapd	ADDR(%rsp), %ymm4
               	vmulpd	%ymm0, %ymm4, %ymm0
               	vmulpd	%ymm1, %ymm3, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vmulpd	%ymm2, %ymm5, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vmulpd	%ymm0, %ymm4, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	%ymm1, %ymm5, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	%ymm1, %ymm4, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	%ymm2, %ymm4, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	testb	%al, %al
               	jne	ADDR 
               	movzbl	ADDR(%rbp), %ecx
               	testb	%r13b, %r13b
               	jne	ADDR 
               	testb	%cl, %cl
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm2
               	vmovapd	ADDR(%rsp), %ymm1
               	vblendpd	$ADDR, %ymm1, %ymm2, %ymm0 ## ymm0 = ymm2[0],ymm1[1],ymm2[2],ymm1[3]
               	vmovapd	ADDR(%rsp), %ymm3
               	vunpcklpd	%ymm3, %ymm1, %ymm1 ## ymm1 = ymm1[0],ymm3[0],ymm1[2],ymm3[2]
               	vunpckhpd	%ymm2, %ymm3, %ymm2 ## ymm2 = ymm3[1],ymm2[1],ymm3[3],ymm2[3]
               	vperm2f128	$ADDR, %ymm0, %ymm1, %ymm3 ## ymm3 = ymm1[0,1],ymm0[0,1]
               	vmovupd	%ymm3, (%rdx)
               	vblendpd	$ADDR, %ymm1, %ymm2, %ymm1 ## ymm1 = ymm2[0,1],ymm1[2,3]
               	vmovupd	%ymm1, ADDR(%rdx)
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm0 ## ymm0 = ymm0[2,3],ymm2[2,3]
               	vmovupd	%ymm0, ADDR(%rdx)
               	cmpb	$ADDR, ADDR(%rbp)
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
               	testb	%al, %al
               	je	ADDR 
               	vmovapd	%ymm12, ADDR(%rsp)
               	movq	%rdi, ADDR(%rsp)
               	movq	%rdx, ADDR(%rsp)
               	leaq	ADDR(%rbp), %r13
               	leaq	ADDR(%rbp), %rax
               	leaq	ADDR(%rbp), %rcx
               	movq	(%rcx), %rcx
               	vmovupd	(%rcx), %ymm0
               	vmovupd	ADDR(%rcx), %ymm1
               	vmovupd	ADDR(%rcx), %ymm2
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm3 ## ymm3 = ymm0[0,1],ymm1[2],ymm0[3]
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm4 ## ymm4 = ymm0[2,3],ymm2[0,1]
               	vblendpd	$ADDR, %ymm4, %ymm3, %ymm6 ## ymm6 = ymm3[0],ymm4[1],ymm3[2],ymm4[3]
               	vblendpd	$ADDR, %ymm0, %ymm1, %ymm0 ## ymm0 = ymm1[0],ymm0[1],ymm1[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm0, %ymm0 ## ymm0 = ymm0[0,1],ymm2[2],ymm0[3]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2,3]
               	vblendpd	$ADDR, %ymm1, %ymm4, %ymm7 ## ymm7 = ymm4[0],ymm1[1],ymm4[2],ymm1[3]
               	movq	(%rax), %rax
               	vmovupd	(%rax), %ymm1
               	vmovupd	ADDR(%rax), %ymm2
               	vmovupd	ADDR(%rax), %ymm3
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm4 ## ymm4 = ymm1[0,1],ymm2[2],ymm1[3]
               	vperm2f128	$ADDR, %ymm3, %ymm1, %ymm5 ## ymm5 = ymm1[2,3],ymm3[0,1]
               	vblendpd	$ADDR, %ymm5, %ymm4, %ymm4 ## ymm4 = ymm4[0],ymm5[1],ymm4[2],ymm5[3]
               	vblendpd	$ADDR, %ymm1, %ymm2, %ymm1 ## ymm1 = ymm2[0],ymm1[1],ymm2[2,3]
               	vblendpd	$ADDR, %ymm3, %ymm2, %ymm2 ## ymm2 = ymm2[0,1],ymm3[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm5, %ymm3 ## ymm3 = ymm5[0],ymm2[1],ymm5[2],ymm2[3]
               	vmovapd	%ymm6, ADDR(%rsp)
               	vsubpd	%ymm4, %ymm6, %ymm12
               	vshufpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[1],ymm2[0],ymm1[3],ymm2[2]
               	vshufpd	$ADDR, %ymm0, %ymm0, %ymm0 ## ymm0 = ymm0[1,0,3,2]
               	vmovapd	%ymm0, ADDR(%rsp)
               	vsubpd	%ymm1, %ymm0, %ymm11
               	cmpq	$ADDR, ADDR(%r13)
               	vmovapd	%ymm7, ADDR(%rsp)
               	vsubpd	%ymm3, %ymm7, %ymm10
               	vmovapd	%ymm10, ADDR(%rsp)
               	vmovapd	%ymm11, ADDR(%rsp)
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
               	vmovapd	ADDR(%rsp), %ymm10
               	vmovapd	ADDR(%rsp), %ymm11
               	vmovapd	ADDR(%rsp), %ymm12
               	jbe	ADDR 
               	movq	(%r13), %rax
               	vmovupd	(%rax), %ymm0
               	vmovupd	ADDR(%rax), %ymm1
               	vmovupd	ADDR(%rax), %ymm2
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm3 ## ymm3 = ymm0[0,1],ymm1[2],ymm0[3]
               	vperm2f128	$ADDR, %ymm2, %ymm0, %ymm4 ## ymm4 = ymm0[2,3],ymm2[0,1]
               	vblendpd	$ADDR, %ymm4, %ymm3, %ymm3 ## ymm3 = ymm3[0],ymm4[1],ymm3[2],ymm4[3]
               	vblendpd	$ADDR, %ymm0, %ymm1, %ymm0 ## ymm0 = ymm1[0],ymm0[1],ymm1[2,3]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2,3]
               	vblendpd	$ADDR, %ymm1, %ymm4, %ymm2 ## ymm2 = ymm4[0],ymm1[1],ymm4[2],ymm1[3]
               	vmovapd	ADDR(%rsp), %ymm4
               	vsubpd	%ymm3, %ymm4, %ymm12
               	vshufpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[1],ymm1[0],ymm0[3],ymm1[2]
               	vmovapd	ADDR(%rsp), %ymm1
               	vsubpd	%ymm0, %ymm1, %ymm11
               	vmovapd	ADDR(%rsp), %ymm0
               	vsubpd	%ymm2, %ymm0, %ymm10
               	testb	%r14b, %r14b
               	jne	ADDR 
               	cmpb	$ADDR, ADDR(%r15)
               	jne	ADDR 
               	leaq	ADDR(%rbp), %rax
               	movq	(%rax), %rax
               	vmovupd	(%rax), %ymm1
               	vbroadcastsd	(%r12), %ymm0
               	vmovsd	ADDR(%r12), %xmm2
               	cmpb	$ADDR, ADDR(%r15)
               	je	ADDR 
               	vmovsd	ADDR(%r12), %xmm3
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm0
               	vmulpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	ADDR(%rsp), %ymm1
               	vfmadd132pd	ADDR(%rsp), %ymm0, %ymm1 ## ymm1 = (ymm1 * mem) + ymm0
               	vmovapd	ADDR(%rsp), %ymm0
               	vfmadd132pd	ADDR(%rsp), %ymm1, %ymm0 ## ymm0 = (ymm0 * mem) + ymm1
               	vmovapd	ADDR(%rsp), %ymm1
               	vsubpd	%ymm0, %ymm1, %ymm1
               	vbroadcastsd	(%r12), %ymm0
               	vmovsd	ADDR(%r12), %xmm2
               	cmpb	$ADDR, ADDR(%r15)
               	jne	ADDR 
               	vxorpd	%xmm3, %xmm3, %xmm3
               	vaddsd	ADDR(%r12), %xmm3, %xmm3
               	vbroadcastsd	ADDR(%r12), %ymm4
               	vxorpd	ADDR(%rsp), %ymm1, %ymm1
               	vsubsd	%xmm3, %xmm2, %xmm2
               	vbroadcastsd	%xmm2, %ymm2
               	vsubpd	%ymm2, %ymm1, %ymm1
               	vdivpd	%ymm4, %ymm1, %ymm2
               	vmulpd	%ymm2, %ymm2, %ymm3
               	vmulpd	%ymm3, %ymm2, %ymm3
               	vxorpd	%xmm5, %xmm5, %xmm5
               	vcmplepd	%ymm5, %ymm4, %ymm6
               	vandpd	ADDR(%rsp), %ymm1, %ymm7
               	vcmpltpd	%ymm7, %ymm4, %ymm7
               	vorpd	%ymm7, %ymm6, %ymm6
               	vbroadcastsd	ADDR(%rip), %ymm7 ## ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm8 ## ADDR 
               	vfmadd213pd	%ymm8, %ymm2, %ymm7 ## ymm7 = (ymm2 * ymm7) + ymm8
               	vbroadcastsd	ADDR(%rip), %ymm9 ## ADDR 
               	vfmadd231pd	%ymm9, %ymm3, %ymm7 ## ymm7 = (ymm3 * ymm9) + ymm7
               	vmulpd	%ymm7, %ymm1, %ymm7
               	vbroadcastsd	ADDR(%rip), %ymm9 ## ADDR 
               	vfmadd231pd	%ymm4, %ymm9, %ymm7 ## ymm7 = (ymm9 * ymm4) + ymm7
               	vbroadcastsd	ADDR(%rip), %ymm4 ## ADDR 
               	vfmadd213pd	%ymm8, %ymm4, %ymm2 ## ymm2 = (ymm4 * ymm2) + ymm8
               	vbroadcastsd	ADDR(%rip), %ymm4 ## ADDR 
               	vfmadd231pd	%ymm3, %ymm4, %ymm2 ## ymm2 = (ymm4 * ymm3) + ymm2
               	vblendvpd	%ymm6, %ymm1, %ymm7, %ymm3
               	vcmpnltpd	%ymm5, %ymm1, %ymm1
               	vbroadcastsd	ADDR(%rip), %ymm4 ## ADDR 
               	vandpd	%ymm4, %ymm1, %ymm1
               	vblendvpd	%ymm6, %ymm1, %ymm2, %ymm1
               	vmaxpd	%ymm3, %ymm5, %ymm2
               	vmaxpd	%ymm1, %ymm5, %ymm1
               	vmovapd	ADDR(%rsp), %ymm3
               	vandpd	%ymm2, %ymm3, %ymm2
               	vmulpd	%ymm2, %ymm0, %ymm0
               	vminpd	%ymm1, %ymm4, %ymm1
               	vandpd	%ymm1, %ymm3, %ymm1
               	vmulpd	%ymm1, %ymm0, %ymm0
               	vmulpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	movq	ADDR(%rip), %r14    ## ADDR 
               	movzbl	(%r14), %eax
               	testb	%al, %al
               	je	ADDR 
               	movq	ADDR(%rip), %r13    ## ADDR 
               	cmpb	$ADDR, (%r13)
               	jne	ADDR 
               	vmovsd	ADDR(%r12), %xmm0
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vucomisd	%xmm1, %xmm0
               	jbe	ADDR 
               	vbroadcastsd	(%r12), %ymm0
               	vmovsd	ADDR(%r12), %xmm2
               	cmpb	$ADDR, ADDR(%r15)
               	je	ADDR 
               	vmovsd	ADDR(%r12), %xmm1
               	vaddsd	ADDR(%r12), %xmm1, %xmm3
               	vbroadcastsd	ADDR(%r12), %ymm1
               	vsubsd	%xmm3, %xmm2, %xmm2
               	vbroadcastsd	%xmm2, %ymm2
               	vmovapd	ADDR(%rsp), %ymm3
               	vsubpd	%ymm2, %ymm3, %ymm3
               	vdivpd	%ymm1, %ymm3, %ymm4
               	vmulpd	%ymm4, %ymm4, %ymm2
               	vmulpd	%ymm2, %ymm4, %ymm5
               	vbroadcastsd	ADDR(%rip), %ymm6 ## ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm8 ## ADDR 
               	vfmadd213pd	%ymm6, %ymm4, %ymm8 ## ymm8 = (ymm4 * ymm8) + ymm6
               	vbroadcastsd	ADDR(%rip), %ymm7 ## ADDR 
               	vfmadd213pd	%ymm8, %ymm5, %ymm7 ## ymm7 = (ymm5 * ymm7) + ymm8
               	vbroadcastsd	ADDR(%rip), %ymm8 ## ADDR 
               	vfmadd213pd	%ymm6, %ymm8, %ymm4 ## ymm4 = (ymm8 * ymm4) + ymm6
               	vbroadcastsd	ADDR(%rip), %ymm9 ## ADDR 
               	vfmadd213pd	%ymm4, %ymm5, %ymm9 ## ymm9 = (ymm5 * ymm9) + ymm4
               	vxorpd	%xmm4, %xmm4, %xmm4
               	vcmplepd	%ymm4, %ymm1, %ymm5
               	vandpd	ADDR(%rsp), %ymm3, %ymm6
               	vcmpltpd	%ymm6, %ymm1, %ymm6
               	vorpd	%ymm6, %ymm5, %ymm5
               	vmulpd	%ymm7, %ymm3, %ymm6
               	vbroadcastsd	ADDR(%rip), %ymm7 ## ADDR 
               	vfmadd213pd	%ymm6, %ymm1, %ymm7 ## ymm7 = (ymm1 * ymm7) + ymm6
               	vblendvpd	%ymm5, %ymm3, %ymm7, %ymm6
               	vbroadcastsd	ADDR(%rip), %ymm7 ## ADDR 
               	vcmpnltpd	%ymm4, %ymm3, %ymm3
               	vandpd	%ymm7, %ymm3, %ymm3
               	vblendvpd	%ymm5, %ymm3, %ymm9, %ymm3
               	vmaxpd	%ymm3, %ymm4, %ymm3
               	vminpd	%ymm3, %ymm7, %ymm3
               	vsubpd	%ymm2, %ymm7, %ymm2
               	vmulpd	%ymm2, %ymm8, %ymm2
               	vdivpd	%ymm1, %ymm2, %ymm1
               	vandnpd	%ymm1, %ymm5, %ymm1
               	vmaxpd	%ymm6, %ymm4, %ymm2
               	vmaxpd	%ymm1, %ymm4, %ymm1
               	vmovapd	ADDR(%rsp), %ymm4
               	vandpd	%ymm2, %ymm4, %ymm2
               	vandpd	%ymm3, %ymm4, %ymm3
               	vandpd	%ymm1, %ymm4, %ymm1
               	vmulpd	%ymm1, %ymm2, %ymm1
               	vmulpd	%ymm2, %ymm0, %ymm2
               	vmulpd	%ymm3, %ymm2, %ymm2
               	vfmadd231pd	%ymm3, %ymm3, %ymm1 ## ymm1 = (ymm3 * ymm3) + ymm1
               	vmulpd	%ymm0, %ymm1, %ymm0
               	vmovapd	ADDR(%rsp), %ymm1
               	vmulpd	%ymm2, %ymm1, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmulpd	%ymm1, %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovdqu	ADDR(%r12), %xmm0
               	vpextrb	$ADDR, %xmm0, %ecx
               	jmp	ADDR 
               	movzbl	ADDR(%r12), %ecx
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovdqa	ADDR(%rsp), %ymm0
               	vmovdqa	%ymm0, ADDR(%rsp)
               	movzbl	ADDR(%r15), %eax
               	movl	%eax, %edx
               	notb	%dl
               	orb	%cl, %dl
               	testb	$ADDR, %dl
               	vmovapd	ADDR(%rsp), %ymm1
               	je	ADDR 
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm6
               	vmovapd	ADDR(%rsp), %ymm5
               	vmovapd	ADDR(%rsp), %ymm4
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm0
               	vxorpd	ADDR(%rsp), %ymm0, %ymm4
               	vxorpd	ADDR(%rsp), %ymm0, %ymm6
               	vxorpd	%ymm0, %ymm1, %ymm5
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm2
               	vmulpd	%ymm2, %ymm2, %ymm0
               	vmovapd	ADDR(%rsp), %ymm4
               	vfmadd231pd	%ymm4, %ymm4, %ymm0 ## ymm0 = (ymm4 * ymm4) + ymm0
               	vmovapd	ADDR(%rsp), %ymm3
               	vfmadd231pd	%ymm3, %ymm3, %ymm0 ## ymm0 = (ymm3 * ymm3) + ymm0
               	vsqrtpd	%ymm0, %ymm0
               	vbroadcastsd	ADDR(%rip), %ymm1 ## ADDR 
               	vdivpd	%ymm0, %ymm1, %ymm1
               	vmulpd	%ymm1, %ymm4, %ymm4
               	vmulpd	%ymm2, %ymm1, %ymm2
               	vmulpd	%ymm3, %ymm1, %ymm3
               	vbroadcastsd	ADDR(%rip), %ymm1 ## ADDR 
               	vcmpltpd	%ymm1, %ymm0, %ymm0
               	vtestpd	%ymm0, %ymm0
               	jne	ADDR 
               	vmovapd	%ymm2, %ymm6
               	vmovapd	%ymm3, %ymm5
               	vmulpd	%ymm6, %ymm11, %ymm2
               	vfmadd231pd	%ymm12, %ymm4, %ymm2 ## ymm2 = (ymm4 * ymm12) + ymm2
               	vfmadd231pd	%ymm10, %ymm5, %ymm2 ## ymm2 = (ymm5 * ymm10) + ymm2
               	vmulpd	%ymm2, %ymm4, %ymm0
               	vmulpd	%ymm6, %ymm2, %ymm1
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmulpd	%ymm5, %ymm2, %ymm2
               	vmovapd	%ymm0, ADDR(%rsp)
               	vsubpd	%ymm0, %ymm12, %ymm3
               	vmovapd	%ymm1, ADDR(%rsp)
               	vsubpd	%ymm1, %ymm11, %ymm0
               	vmovapd	%ymm2, ADDR(%rsp)
               	vsubpd	%ymm2, %ymm10, %ymm1
               	vmovapd	ADDR(%rsp), %ymm9
               	vmulpd	%ymm6, %ymm9, %ymm2
               	vmovapd	ADDR(%rsp), %ymm8
               	vfmadd231pd	%ymm8, %ymm4, %ymm2 ## ymm2 = (ymm4 * ymm8) + ymm2
               	vmovapd	ADDR(%rsp), %ymm7
               	vfmadd231pd	%ymm7, %ymm5, %ymm2 ## ymm2 = (ymm5 * ymm7) + ymm2
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	%ymm0, %ymm0, %ymm10
               	vmovapd	%ymm3, ADDR(%rsp)
               	vfmadd231pd	%ymm3, %ymm3, %ymm10 ## ymm10 = (ymm3 * ymm3) + ymm10
               	vmovsd	ADDR(%rsp), %xmm0
               	vmulsd	ADDR(%r12), %xmm0, %xmm0
               	vmovsd	%xmm0, ADDR(%rsp)
               	vmovapd	%ymm1, ADDR(%rsp)
               	vfmadd231pd	%ymm1, %ymm1, %ymm10 ## ymm10 = (ymm1 * ymm1) + ymm10
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movzbl	(%rax), %eax
               	testb	%al, %al
               	vmovapd	%ymm6, ADDR(%rsp)
               	vmovapd	%ymm5, ADDR(%rsp)
               	vmovapd	%ymm4, ADDR(%rsp)
               	je	ADDR 
               	vfnmadd231pd	%ymm2, %ymm6, %ymm9 ## ymm9 = -(ymm6 * ymm2) + ymm9
               	vmovapd	%ymm9, ADDR(%rsp)
               	vfnmadd231pd	%ymm2, %ymm4, %ymm8 ## ymm8 = -(ymm4 * ymm2) + ymm8
               	vmovapd	%ymm8, ADDR(%rsp)
               	vfnmadd231pd	%ymm2, %ymm5, %ymm7 ## ymm7 = -(ymm5 * ymm2) + ymm7
               	vmovapd	%ymm7, ADDR(%rsp)
               	vsqrtpd	%ymm10, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	movq	ADDR(%rip), %rax    ## ADDR 
               	vmovsd	ADDR(%rip), %xmm0   ## ADDR 
               	vmovapd	%xmm0, ADDR(%rsp)
               	cmpb	$ADDR, (%rax)
               	jne	ADDR 
               	movq	ADDR(%rip), %r13    ## ADDR 
               	movzbl	(%r13), %eax
               	testb	%al, %al
               	je	ADDR 
               	movq	ADDR(%rip), %r14    ## ADDR 
               	vmovsd	(%r14), %xmm1
               	movl	$ADDR, ADDR(%rsp)
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vucomisd	%xmm0, %xmm1
               	jbe	ADDR 
               	vmovsd	ADDR(%rsp), %xmm1
               	vucomisd	%xmm0, %xmm1
               	jbe	ADDR 
               	movzbl	(%r13), %eax
               	testb	%al, %al
               	je	ADDR 
               	vmovsd	(%r14), %xmm0
               	vdivsd	ADDR(%rsp), %xmm0, %xmm0
               	vaddsd	ADDR(%rip), %xmm0, %xmm1 ## ADDR 
               	vmovapd	%xmm1, ADDR(%rsp)
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vucomisd	%xmm1, %xmm0
               	movq	ADDR(%rip), %r13    ## ADDR 
               	jbe	ADDR 
               	vbroadcastsd	%xmm0, %ymm0
               	vmovapd	ADDR(%rsp), %ymm3
               	vfmadd231pd	ADDR(%rsp), %ymm0, %ymm3 ## ymm3 = (ymm0 * mem) + ymm3
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	ADDR(%rsp), %ymm0, %ymm2 ## ymm2 = (ymm0 * mem) + ymm2
               	vmovapd	ADDR(%rsp), %ymm1
               	vfmadd231pd	ADDR(%rsp), %ymm0, %ymm1 ## ymm1 = (ymm0 * mem) + ymm1
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmulpd	%ymm2, %ymm2, %ymm0
               	vmovapd	%ymm3, ADDR(%rsp)
               	vfmadd231pd	%ymm3, %ymm3, %ymm0 ## ymm0 = (ymm3 * ymm3) + ymm0
               	vmovapd	%ymm1, ADDR(%rsp)
               	vfmadd231pd	%ymm1, %ymm1, %ymm0 ## ymm0 = (ymm1 * ymm1) + ymm0
               	vsqrtpd	%ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	movb	$ADDR, %al
               	movl	%eax, ADDR(%rsp)
               	jmp	ADDR 
               	movl	$ADDR, ADDR(%rsp)
               	vmovsd	ADDR(%r12), %xmm0
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vucomisd	%xmm1, %xmm0
               	jbe	ADDR 
               	movzbl	(%r14), %eax
               	testb	%al, %al
               	vmovapd	ADDR(%rsp), %ymm0
               	je	ADDR 
               	movzbl	(%r13), %r14d
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movzbl	(%rax), %eax
               	testb	%al, %al
               	je	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movzbl	(%rax), %r13d
               	jmp	ADDR 
               	movq	ADDR(%rip), %r14    ## ADDR 
               	movq	ADDR(%rip), %r13    ## ADDR 
               	vmovsd	ADDR(%r12), %xmm0
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vucomisd	%xmm1, %xmm0
               	ja	ADDR 
               	xorl	%r14d, %r14d
               	xorl	%r13d, %r13d
               	vmovapd	ADDR(%rsp), %ymm0
               	movl	%r14d, %eax
               	orb	%r13b, %al
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	%ymm0, ADDR(%rsp)
               	testb	$ADDR, %al
               	je	ADDR 
               	vmovsd	ADDR(%r12), %xmm1
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vmovapd	ADDR(%rsp), %ymm2
               	vcmpltpd	%ymm2, %ymm0, %ymm3
               	vmovapd	ADDR(%rsp), %ymm4
               	vdivpd	%ymm2, %ymm4, %ymm4
               	vbroadcastsd	ADDR(%rip), %ymm2 ## ADDR 
               	vblendvpd	%ymm3, %ymm4, %ymm2, %ymm3
               	vmovsd	ADDR(%rsp), %xmm4
               	vdivsd	%xmm1, %xmm4, %xmm4
               	vbroadcastsd	%xmm4, %ymm4
               	vmulpd	%ymm4, %ymm3, %ymm3
               	testb	%r14b, %r14b
               	jne	ADDR 
               	vmovapd	ADDR(%rsp), %ymm4
               	vmovapd	%ymm4, ADDR(%rsp)
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm4
               	vminpd	%ymm3, %ymm4, %ymm5
               	vmovapd	%ymm5, ADDR(%rsp)
               	vcmpltpd	%ymm3, %ymm4, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vdivsd	ADDR(%rsp), %xmm1, %xmm1
               	vbroadcastsd	%xmm1, %ymm1
               	vfnmadd213pd	%ymm2, %ymm4, %ymm1 ## ymm1 = -(ymm4 * ymm1) + ymm2
               	vmaxpd	%ymm1, %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	testb	%r13b, %r13b
               	jne	ADDR 
               	vmovapd	ADDR(%rsp), %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	testb	%r14b, %r14b
               	jne	ADDR 
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm0
               	vmulpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	testb	%r14b, %r14b
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm1
               	vmulpd	ADDR(%rsp), %ymm1, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm1, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm1, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovsd	ADDR(%r12), %xmm1
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
               	vmulsd	ADDR(%r12), %xmm1, %xmm1
               	vxorpd	%xmm2, %xmm2, %xmm2
               	vcmpltsd	%xmm0, %xmm2, %xmm2
               	vblendvpd	%xmm2, %xmm0, %xmm1, %xmm0
               	vbroadcastsd	%xmm0, %ymm2
               	movl	ADDR(%r15), %eax
               	testl	%eax, %eax
               	je	ADDR 
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	cmpl	$ADDR, %eax
               	jne	ADDR 
               	vbroadcastsd	ADDR(%rip), %ymm0 ## ADDR 
               	vmaxpd	%ymm0, %ymm2, %ymm2
               	vmulpd	%ymm2, %ymm2, %ymm0
               	vbroadcastsd	ADDR(%rip), %ymm1 ## ADDR 
               	vmulpd	%ymm1, %ymm0, %ymm3
               	vmovapd	ADDR(%rsp), %ymm0
               	vfmadd213pd	%ymm3, %ymm0, %ymm0 ## ymm0 = (ymm0 * ymm0) + ymm3
               	vsqrtpd	%ymm0, %ymm4
               	vbroadcastsd	ADDR(%rip), %ymm0 ## ADDR 
               	vdivpd	%ymm4, %ymm0, %ymm0
               	vbroadcastsd	ADDR(%rip), %ymm1 ## ADDR 
               	vfmadd213pd	%ymm4, %ymm2, %ymm1 ## ymm1 = (ymm2 * ymm1) + ymm4
               	vmulpd	%ymm0, %ymm0, %ymm2
               	vmulpd	%ymm2, %ymm0, %ymm2
               	vmulpd	%ymm2, %ymm3, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%rbp)
               	jne	ADDR 
               	jmp	ADDR 
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vxorps	%xmm0, %xmm0, %xmm0
               	vmovaps	%ymm0, ADDR(%rsp)
               	vmovsd	ADDR(%r12), %xmm0
               	vxorpd	%xmm2, %xmm2, %xmm2
               	vucomisd	%xmm2, %xmm0
               	jbe	ADDR 
               	vdivsd	ADDR(%rsp), %xmm0, %xmm0
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vmovapd	%ymm1, %ymm3
               	vmovapd	ADDR(%rsp), %ymm1
               	vmulpd	%ymm1, %ymm1, %ymm1
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm2, %ymm2, %ymm1 ## ymm1 = (ymm2 * ymm2) + ymm1
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm2, %ymm2, %ymm1 ## ymm1 = (ymm2 * ymm2) + ymm1
               	vsqrtpd	%ymm1, %ymm1
               	vmulsd	ADDR(%rip), %xmm0, %xmm2 ## ADDR 
               	vmulpd	%ymm1, %ymm1, %ymm1
               	vbroadcastsd	%xmm2, %ymm2
               	vmulpd	%ymm2, %ymm1, %ymm1
               	testb	%r13b, %r13b
               	je	ADDR 
               	vmulpd	ADDR(%rsp), %ymm1, %ymm1
               	movq	ADDR(%rsp), %rdx
               	movq	ADDR(%rsp), %rdi
               	movzbl	ADDR(%rbp), %r13d
               	vaddpd	%ymm1, %ymm3, %ymm1
               	jmp	ADDR 
               	movq	ADDR(%rsp), %rdx
               	movq	ADDR(%rsp), %rdi
               	movzbl	ADDR(%rbp), %r13d
               	movzbl	ADDR(%rbp), %ecx
               	movl	%ecx, %eax
               	orb	ADDR(%rbp), %al
               	cmpb	$ADDR, %al
               	vmovapd	%ymm1, ADDR(%rsp)
               	jne	ADDR 
               	vbroadcastsd	%xmm0, %ymm0
               	vmulpd	ADDR(%rsp), %ymm0, %ymm0
               	testb	%cl, %cl
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm1
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm1 ## ymm1 = -(ymm0 * mem) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm1
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm1 ## ymm1 = -(ymm0 * mem) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm1
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm1 ## ymm1 = -(ymm0 * mem) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm1
               	vsubpd	%ymm0, %ymm1, %ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovsd	ADDR(%r12), %xmm1
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vxorpd	%xmm2, %xmm2, %xmm2
               	vucomisd	%xmm2, %xmm1
               	ja	ADDR 
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm8
               	vdivpd	%ymm2, %ymm8, %ymm0
               	vcmplepd	%ymm8, %ymm2, %ymm3
               	vbroadcastsd	ADDR(%rip), %ymm1 ## ADDR 
               	vmovapd	%ymm1, %ymm4
               	vfnmadd213pd	%ymm8, %ymm2, %ymm4 ## ymm4 = -(ymm2 * ymm4) + ymm8
               	vmulpd	%ymm0, %ymm8, %ymm5
               	vbroadcastsd	ADDR(%rip), %ymm6 ## ADDR 
               	vfnmadd213pd	%ymm6, %ymm0, %ymm1 ## ymm1 = -(ymm0 * ymm1) + ymm6
               	vmulpd	%ymm1, %ymm5, %ymm1
               	vblendvpd	%ymm3, %ymm4, %ymm1, %ymm1
               	vxorpd	%xmm4, %xmm4, %xmm4
               	vsubpd	%ymm0, %ymm6, %ymm5
               	vbroadcastsd	ADDR(%rip), %ymm7 ## ADDR 
               	vaddpd	%ymm5, %ymm5, %ymm5
               	vdivpd	%ymm2, %ymm5, %ymm5
               	vandnpd	%ymm5, %ymm3, %ymm5
               	vmovapd	%ymm5, ADDR(%rsp)
               	vdivpd	%ymm8, %ymm6, %ymm5
               	vsubpd	%ymm0, %ymm7, %ymm0
               	vdivpd	%ymm2, %ymm0, %ymm0
               	vcmpneqpd	%ymm4, %ymm8, %ymm2
               	vandpd	%ymm5, %ymm2, %ymm2
               	vblendvpd	%ymm3, %ymm2, %ymm0, %ymm0
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vbroadcastsd	ADDR(%rsp), %ymm2
               	vmulpd	%ymm1, %ymm2, %ymm1
               	testb	%r13b, %r13b
               	je	ADDR 
               	vmulpd	ADDR(%rsp), %ymm1, %ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%rsp)
               	je	ADDR 
               	vmovsd	ADDR(%rip), %xmm1   ## ADDR 
               	vdivsd	ADDR(%rsp), %xmm1, %xmm1
               	vbroadcastsd	%xmm1, %ymm1
               	vmovapd	ADDR(%rsp), %ymm2
               	vmulpd	%ymm2, %ymm1, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	movzbl	ADDR(%rbp), %ecx
               	movl	%ecx, %eax
               	orb	ADDR(%rbp), %al
               	cmpb	$ADDR, %al
               	jne	ADDR 
               	vbroadcastsd	ADDR(%rsp), %ymm1
               	vmulpd	ADDR(%rsp), %ymm1, %ymm1
               	vmulpd	%ymm0, %ymm1, %ymm0
               	testb	%cl, %cl
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm1
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm1 ## ymm1 = -(ymm0 * mem) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm1
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm1 ## ymm1 = -(ymm0 * mem) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm1
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm1 ## ymm1 = -(ymm0 * mem) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%rbp)
               	vmovapd	ADDR(%rsp), %ymm1
               	je	ADDR 
               	vxorpd	ADDR(%rsp), %ymm0, %ymm0
               	vbroadcastsd	ADDR(%rsp), %ymm1
               	cmpb	$ADDR, ADDR(%rsp)
               	vmovapd	%ymm1, ADDR(%rsp)
               	je	ADDR 
               	vmulpd	%ymm0, %ymm1, %ymm0
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
               	vcmpltpd	ADDR(%rsp), %ymm0, %ymm0
               	vmovapd	ADDR(%rsp), %xmm1
               	vxorpd	ADDR(%rip), %xmm1, %xmm1 ## ADDR 
               	vbroadcastsd	%xmm1, %ymm1
               	vmulpd	ADDR(%rsp), %ymm1, %ymm1
               	vmulpd	ADDR(%rsp), %ymm1, %ymm1
               	cmpb	$ADDR, ADDR(%rsp)
               	je	ADDR 
               	vmulpd	ADDR(%rsp), %ymm1, %ymm1
               	vbroadcastsd	ADDR(%rip), %ymm2 ## ADDR 
               	vaddpd	ADDR(%rsp), %ymm2, %ymm2
               	vbroadcastsd	ADDR(%rip), %ymm3 ## ADDR 
               	vdivpd	%ymm2, %ymm3, %ymm2
               	vmulpd	ADDR(%rsp), %ymm2, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm2, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vmulpd	ADDR(%rsp), %ymm2, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vsubpd	ADDR(%rsp), %ymm1, %ymm1
               	vandpd	%ymm1, %ymm0, %ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm1
               	vmovsd	ADDR(%r12), %xmm0
               	vxorpd	%xmm2, %xmm2, %xmm2
               	vucomisd	%xmm2, %xmm0
               	ja	ADDR 
               	vmovapd	%ymm1, ADDR(%rsp)
               	movq	ADDR(%rsp), %rdx
               	movq	ADDR(%rsp), %rdi
               	movzbl	ADDR(%rbp), %r13d
               	vmovsd	ADDR(%r12), %xmm1
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vucomisd	%xmm0, %xmm1
               	jbe	ADDR 
               	vdivsd	ADDR(%rsp), %xmm1, %xmm0
               	testb	%r13b, %r13b
               	je	ADDR 
               	testb	%r14b, %r14b
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm3
               	vmulpd	%ymm3, %ymm3, %ymm1
               	vmovapd	ADDR(%rsp), %ymm2
               	vsubpd	%ymm3, %ymm2, %ymm2
               	vmulpd	%ymm2, %ymm3, %ymm2
               	vbroadcastsd	ADDR(%rip), %ymm3 ## ADDR 
               	vfmadd213pd	%ymm2, %ymm1, %ymm3 ## ymm3 = (ymm1 * ymm3) + ymm2
               	vbroadcastsd	%xmm0, %ymm1
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm1, %ymm3, %ymm2 ## ymm2 = (ymm3 * ymm1) + ymm2
               	vmovapd	%ymm2, %ymm1
               	jmp	ADDR 
               	vxorpd	%xmm0, %xmm0, %xmm0
               	cmpb	$ADDR, ADDR(%rbp)
               	jne	ADDR 
               	jmp	ADDR 
               	vmovapd	ADDR(%rsp), %ymm1
               	jmp	ADDR 
               	vmovsd	ADDR(%r12), %xmm1
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vucomisd	%xmm0, %xmm1
               	ja	ADDR 
               	jmp	ADDR 
               	vmulsd	ADDR(%rip), %xmm0, %xmm1 ## ADDR 
               	vmovapd	ADDR(%rsp), %ymm2
               	vmulpd	%ymm2, %ymm2, %ymm2
               	vbroadcastsd	%xmm1, %ymm1
               	vmovapd	ADDR(%rsp), %ymm3
               	vfmadd231pd	%ymm1, %ymm2, %ymm3 ## ymm3 = (ymm2 * ymm1) + ymm3
               	vmovapd	%ymm3, %ymm1
               	movzbl	ADDR(%rbp), %ecx
               	movl	%ecx, %eax
               	orb	ADDR(%rbp), %al
               	cmpb	$ADDR, %al
               	jne	ADDR 
               	vbroadcastsd	%xmm0, %ymm0
               	vmulpd	ADDR(%rsp), %ymm0, %ymm0
               	testb	%cl, %cl
               	je	ADDR 
               	vmovapd	%ymm1, %ymm2
               	vmovapd	ADDR(%rsp), %ymm1
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm1 ## ymm1 = -(ymm0 * mem) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm1
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm1 ## ymm1 = -(ymm0 * mem) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm1
               	vfnmadd231pd	ADDR(%rsp), %ymm0, %ymm1 ## ymm1 = -(ymm0 * mem) + ymm1
               	vmovapd	%ymm1, ADDR(%rsp)
               	vmovapd	%ymm2, %ymm1
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vmovapd	%ymm1, ADDR(%rsp)
               	vxorpd	ADDR(%rsp), %ymm0, %ymm0
               	testb	%r14b, %r14b
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm1
               	vmovapd	ADDR(%rsp), %ymm2
               	vblendvpd	%ymm2, %ymm0, %ymm1, %ymm0
               	vmovapd	ADDR(%rsp), %ymm7
               	vsubpd	%ymm7, %ymm0, %ymm0
               	vmovapd	ADDR(%rsp), %ymm6
               	vmulpd	%ymm6, %ymm0, %ymm1
               	vmovapd	ADDR(%rsp), %ymm4
               	vmulpd	%ymm4, %ymm0, %ymm2
               	vmovapd	ADDR(%rsp), %ymm5
               	vmulpd	%ymm5, %ymm0, %ymm0
               	vfmadd213pd	%ymm7, %ymm1, %ymm6 ## ymm6 = (ymm1 * ymm6) + ymm7
               	vmovapd	ADDR(%rsp), %ymm3
               	vaddpd	%ymm6, %ymm3, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm3
               	vfmadd231pd	%ymm5, %ymm2, %ymm3 ## ymm3 = (ymm2 * ymm5) + ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vfmadd213pd	%ymm7, %ymm4, %ymm2 ## ymm2 = (ymm4 * ymm2) + ymm7
               	vmovapd	ADDR(%rsp), %ymm3
               	vaddpd	%ymm2, %ymm3, %ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vfmadd213pd	%ymm7, %ymm5, %ymm0 ## ymm0 = (ymm5 * ymm0) + ymm7
               	vmovapd	ADDR(%rsp), %ymm2
               	vaddpd	%ymm0, %ymm2, %ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vfmadd231pd	%ymm4, %ymm1, %ymm0 ## ymm0 = (ymm1 * ymm4) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vfmadd231pd	%ymm1, %ymm5, %ymm0 ## ymm0 = (ymm5 * ymm1) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	cmpb	$ADDR, ADDR(%r15)
               	jne	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	movzbl	(%rax), %eax
               	testb	%al, %al
               	je	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	vmovsd	(%rax), %xmm1
               	vxorpd	%xmm0, %xmm0, %xmm0
               	vucomisd	%xmm0, %xmm1
               	jbe	ADDR 
               	vmovsd	ADDR(%r12), %xmm1
               	vucomisd	%xmm0, %xmm1
               	ja	ADDR 
               	jmp	ADDR 
               	vmovsd	ADDR(%r12), %xmm0
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vucomisd	%xmm1, %xmm0
               	jbe	ADDR 
               	vmovapd	ADDR(%rsp), %ymm5
               	vmovapd	ADDR(%rsp), %ymm2
               	vmulpd	%ymm2, %ymm5, %ymm0
               	vmovapd	ADDR(%rsp), %ymm4
               	vmulpd	%ymm2, %ymm4, %ymm1
               	vmovapd	ADDR(%rsp), %ymm6
               	vmulpd	%ymm2, %ymm6, %ymm2
               	vmovapd	ADDR(%rsp), %ymm3
               	vfmadd231pd	%ymm5, %ymm0, %ymm3 ## ymm3 = (ymm0 * ymm5) + ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm3
               	vfmadd231pd	%ymm1, %ymm4, %ymm3 ## ymm3 = (ymm4 * ymm1) + ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm3
               	vfmadd231pd	%ymm2, %ymm6, %ymm3 ## ymm3 = (ymm6 * ymm2) + ymm3
               	vmovapd	%ymm3, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm4, %ymm0, %ymm2 ## ymm2 = (ymm0 * ymm4) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm2
               	vfmadd231pd	%ymm0, %ymm6, %ymm2 ## ymm2 = (ymm6 * ymm0) + ymm2
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	ADDR(%rsp), %ymm0
               	vfmadd231pd	%ymm1, %ymm6, %ymm0 ## ymm0 = (ymm6 * ymm1) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	movzbl	ADDR(%rbp), %ecx
               	vmovapd	ADDR(%rsp), %ymm1
               	testb	%r13b, %r13b
               	jne	ADDR 
               	testb	%r13b, %r13b
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm0
               	vmovupd	%ymm0, (%rdi)
               	testb	%cl, %cl
               	jne	ADDR 
               	cmpb	$ADDR, ADDR(%rbp)
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm8
               	vpermpd	$ADDR, %ymm8, %ymm0     ## ymm0 = ymm8[3,3,3,3]
               	vmovapd	ADDR(%rsp), %ymm9
               	vextractf128	$ADDR, %ymm9, %xmm3
               	vblendpd	$ADDR, %ymm0, %ymm3, %ymm0 ## ymm0 = ymm0[0],ymm3[1,2,3]
               	vmovapd	ADDR(%rsp), %ymm11
               	vshufpd	$ADDR, %ymm11, %ymm11, %ymm1 ## ymm1 = ymm11[0,0,3,2]
               	vblendpd	$ADDR, %ymm1, %ymm0, %ymm0 ## ymm0 = ymm0[0,1],ymm1[2],ymm0[3]
               	vpermpd	$ADDR, %ymm9, %ymm1     ## ymm1 = ymm9[3,3,3,3]
               	vmovapd	ADDR(%rsp), %ymm10
               	vextractf128	$ADDR, %ymm10, %xmm4
               	vblendpd	$ADDR, %ymm1, %ymm4, %ymm1 ## ymm1 = ymm1[0],ymm4[1,2,3]
               	vmovapd	ADDR(%rsp), %ymm12
               	vshufpd	$ADDR, %ymm12, %ymm12, %ymm2 ## ymm2 = ymm12[0,0,3,2]
               	vblendpd	$ADDR, %ymm2, %ymm1, %ymm1 ## ymm1 = ymm1[0,1],ymm2[2],ymm1[3]
               	vextractf128	$ADDR, %ymm8, %xmm2
               	vshufpd	$ADDR, %ymm3, %ymm2, %ymm2 ## ymm2 = ymm2[0],ymm3[0],ymm2[2],ymm3[3]
               	vblendpd	$ADDR, %ymm11, %ymm2, %ymm2 ## ymm2 = ymm2[0,1],ymm11[2],ymm2[3]
               	vshufpd	$ADDR, %ymm4, %ymm3, %ymm3 ## ymm3 = ymm3[0],ymm4[0],ymm3[2],ymm4[3]
               	vblendpd	$ADDR, %ymm12, %ymm3, %ymm3 ## ymm3 = ymm3[0,1],ymm12[2],ymm3[3]
               	vshufpd	$ADDR, %xmm8, %xmm8, %xmm4 ## xmm4 = xmm8[1,0]
               	vinsertf128	$ADDR, %xmm11, %ymm4, %ymm4
               	vmovapd	%xmm9, %xmm5
               	vshufpd	$ADDR, %ymm5, %ymm4, %ymm4 ## ymm4 = ymm4[0],ymm5[1],ymm4[3],ymm5[3]
               	vshufpd	$ADDR, %xmm9, %xmm9, %xmm6 ## xmm6 = xmm9[1,0]
               	vmovapd	%xmm10, %xmm7
               	vinsertf128	$ADDR, %xmm12, %ymm6, %ymm6
               	vshufpd	$ADDR, %ymm7, %ymm6, %ymm6 ## ymm6 = ymm6[0],ymm7[1],ymm6[3],ymm7[3]
               	vmovddup	%xmm10, %xmm7           ## xmm7 = xmm10[0,0]
               	vblendpd	$ADDR, %ymm7, %ymm5, %ymm5 ## ymm5 = ymm5[0],ymm7[1],ymm5[2,3]
               	vbroadcastsd	%xmm12, %ymm7
               	vblendpd	$ADDR, %ymm7, %ymm5, %ymm5 ## ymm5 = ymm5[0,1],ymm7[2],ymm5[3]
               	vmovapd	%xmm8, %xmm8
               	vmovddup	%xmm9, %xmm9            ## xmm9 = xmm9[0,0]
               	vblendpd	$ADDR, %ymm9, %ymm8, %ymm8 ## ymm8 = ymm8[0],ymm9[1],ymm8[2,3]
               	vbroadcastsd	%xmm11, %ymm9
               	vblendpd	$ADDR, %ymm9, %ymm8, %ymm8 ## ymm8 = ymm8[0,1],ymm9[2],ymm8[3]
               	vmovapd	%xmm11, %xmm9
               	vblendpd	$ADDR, %ymm7, %ymm9, %ymm7 ## ymm7 = ymm9[0],ymm7[1],ymm9[2,3]
               	vmovapd	ADDR(%rsp), %ymm10
               	vbroadcastsd	%xmm10, %ymm9
               	vblendpd	$ADDR, %ymm9, %ymm7, %ymm7 ## ymm7 = ymm7[0,1],ymm9[2],ymm7[3]
               	vmovupd	%ymm8, (%rbx)
               	vmovupd	%ymm5, ADDR(%rbx)
               	vmovupd	%ymm7, ADDR(%rbx)
               	vshufpd	$ADDR, %xmm11, %xmm11, %xmm5 ## xmm5 = xmm11[1,0]
               	vmovapd	%xmm12, %xmm7
               	vinsertf128	$ADDR, %xmm10, %ymm5, %ymm5
               	vshufpd	$ADDR, %ymm7, %ymm5, %ymm5 ## ymm5 = ymm5[0],ymm7[1],ymm5[3],ymm7[3]
               	vmovupd	%ymm4, ADDR(%rbx)
               	vmovupd	%ymm6, ADDR(%rbx)
               	vmovupd	%ymm5, ADDR(%rbx)
               	vextractf128	$ADDR, %ymm11, %xmm4
               	vextractf128	$ADDR, %ymm12, %xmm5
               	vshufpd	$ADDR, %ymm5, %ymm4, %ymm4 ## ymm4 = ymm4[0],ymm5[0],ymm4[2],ymm5[3]
               	vblendpd	$ADDR, %ymm10, %ymm4, %ymm4 ## ymm4 = ymm4[0,1],ymm10[2],ymm4[3]
               	vmovupd	%ymm2, ADDR(%rbx)
               	vmovupd	%ymm3, ADDR(%rbx)
               	vmovupd	%ymm4, ADDR(%rbx)
               	vpermpd	$ADDR, %ymm11, %ymm2    ## ymm2 = ymm11[3,3,3,3]
               	vblendpd	$ADDR, %ymm2, %ymm5, %ymm2 ## ymm2 = ymm2[0],ymm5[1,2,3]
               	vshufpd	$ADDR, %ymm10, %ymm10, %ymm3 ## ymm3 = ymm10[0,0,3,2]
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
               	vmovapd	ADDR(%rsp), %ymm0
               	vfmadd231pd	ADDR(%rsp), %ymm1, %ymm0 ## ymm0 = (ymm1 * mem) + ymm0
               	vmovapd	%ymm0, ADDR(%rsp)
               	testb	%r13b, %r13b
               	je	ADDR 
               	jmp	ADDR 
               	vmovsd	ADDR(%r12), %xmm0
               	vxorpd	%xmm2, %xmm2, %xmm2
               	vucomisd	%xmm2, %xmm0
               	ja	ADDR 
               	jmp	ADDR 
               	movl	$ADDR, ADDR(%rsp)
               	movq	ADDR(%rip), %r14    ## ADDR 
               	vmovsd	ADDR(%r12), %xmm0
               	vxorpd	%xmm1, %xmm1, %xmm1
               	vucomisd	%xmm1, %xmm0
               	ja	ADDR 
               	jmp	ADDR 
               	testb	$ADDR, %al
               	je	ADDR 
               	vmovapd	ADDR(%rsp), %ymm5
               	vxorpd	ADDR(%rsp), %ymm5, %ymm1
               	vblendvpd	%ymm0, %ymm1, %ymm4, %ymm4
               	vxorpd	ADDR(%rsp), %ymm5, %ymm1
               	vblendvpd	%ymm0, %ymm1, %ymm2, %ymm6
               	vxorpd	ADDR(%rsp), %ymm5, %ymm1
               	vblendvpd	%ymm0, %ymm1, %ymm3, %ymm5
               	jmp	ADDR 
               	vandnpd	%ymm4, %ymm0, %ymm4
               	vandnpd	%ymm2, %ymm0, %ymm6
               	vandnpd	%ymm3, %ymm0, %ymm5
               	jmp	ADDR 
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	vmovapd	%ymm10, ADDR(%rsp)
               	vmovapd	%ymm11, ADDR(%rsp)
               	vmovapd	%ymm12, ADDR(%rsp)
               	vzeroupper
               	callq	ADDR 
               	vmovapd	ADDR(%rsp), %ymm12
               	vmovapd	ADDR(%rsp), %ymm11
               	vmovapd	ADDR(%rsp), %ymm10
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
               	vmovapd	ADDR(%rsp), %ymm12
               	vmovapd	ADDR(%rsp), %ymm11
               	vmovapd	ADDR(%rsp), %ymm10
               	jmp	ADDR 
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	vmovapd	%ymm2, ADDR(%rsp)
               	vmovapd	%ymm10, ADDR(%rsp)
               	vzeroupper
               	callq	ADDR 
               	vmovapd	ADDR(%rsp), %ymm10
               	vmovapd	ADDR(%rsp), %ymm9
               	vmovapd	ADDR(%rsp), %ymm8
               	vmovapd	ADDR(%rsp), %ymm7
               	vmovapd	ADDR(%rsp), %ymm2
               	vmovapd	ADDR(%rsp), %ymm5
               	vmovapd	ADDR(%rsp), %ymm6
               	vmovapd	ADDR(%rsp), %ymm4
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
               	vmovapd	ADDR(%rsp), %ymm10
               	vmovapd	ADDR(%rsp), %ymm9
               	vmovapd	ADDR(%rsp), %ymm8
               	vmovapd	ADDR(%rsp), %ymm7
               	vmovapd	ADDR(%rsp), %ymm2
               	vmovapd	ADDR(%rsp), %ymm5
               	vmovapd	ADDR(%rsp), %ymm6
               	vmovapd	ADDR(%rsp), %ymm4
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
               	vmovapd	ADDR(%rsp), %ymm0
               	testl	%eax, %eax
               	je	ADDR 
               	leaq	ADDR(%rip), %rdi    ## ADDR 
               	vzeroupper
               	callq	ADDR 
               	testq	%rax, %rax
               	setne	(%r13)
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	callq	ADDR 
               	vmovapd	ADDR(%rsp), %ymm0
               	jmp	ADDR 
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	vzeroupper
               	callq	ADDR 
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
               	vmovsd	%xmm0, (%r14)
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	callq	ADDR 
               	jmp	ADDR 
               	movq	%rdi, %r15
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	movq	%rdx, %r14
               	vzeroupper
               	callq	ADDR 
               	movq	%r15, %rdi
               	movq	%r14, %rdx
               	testl	%eax, %eax
               	je	ADDR 
               	leaq	ADDR(%rsp), %rdi
               	callq	ADDR 
               	movq	ADDR(%rip), %rax    ## ADDR 
               	vmovsd	%xmm0, (%rax)
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	callq	ADDR 
               	movq	ADDR(%rsp), %rdx
               	movq	ADDR(%rsp), %rdi
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
               	jmp	ADDR 
               	jmp	ADDR 
               	movq	%rax, %rbx
               	movq	ADDR(%rip), %rdi    ## ADDR 
               	callq	ADDR 
               	movq	%rbx, %rdi
               	callq	ADDR 
               	nopl	(%rax)
