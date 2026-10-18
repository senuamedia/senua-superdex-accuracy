
lib/v_noEigT/libmochi_physics_double.so:     file format elf64-x86-64


Disassembly of section .init:

Disassembly of section .plt:

Disassembly of section .plt.got:

Disassembly of section .text:

000000000124b6e0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_>:
124b6e0 push   %rbp
124b6e1 mov    %rsp,%rbp
124b6e4 push   %r15
124b6e6 push   %r14
124b6e8 push   %r13
124b6ea push   %r12
124b6ec push   %rbx
124b6ed and    $0xffffffffffffffe0,%rsp
124b6f1 sub    $0x560,%rsp
124b6f8 vmovsd %xmm0,0x18(%rsp)
124b6fe mov    %r8,%rbx
124b701 mov    %rdx,0x318(%rsp)
124b709 mov    %rdi,0x310(%rsp)
124b711 mov    0x88(%rbp),%r15
124b718 mov    %fs:0x28,%rax
124b721 mov    %rax,0x540(%rsp)
124b729 mov    0x20(%rbp),%rax
124b72d vmovupd (%rax),%ymm0
124b731 vmovupd 0x20(%rax),%ymm1
124b736 vmovupd 0x40(%rax),%ymm2
124b73b vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b741 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b747 vblendpd $0xa,%ymm4,%ymm3,%ymm3
124b74d vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b753 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b759 vshufpd $0x5,%ymm1,%ymm0,%ymm2
124b75e cmpb   $0x0,0x3(%r15)
124b763 vblendpd $0xa,%ymm1,%ymm4,%ymm0
124b769 vmovapd %ymm0,0x140(%rsp)
124b772 vmovapd %ymm0,0x220(%rsp)
124b77b vmovapd %ymm2,0x120(%rsp)
124b784 vmovapd %ymm2,0x200(%rsp)
124b78d vmovapd %ymm3,0x40(%rsp)
124b793 vmovapd %ymm3,0x1e0(%rsp)
124b79c je     124b7f7 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x117>
124b79e lea    0x40(%rbp),%rax
124b7a2 mov    (%rax),%rax
124b7a5 vmovupd (%rax),%ymm0
124b7a9 vmovupd 0x20(%rax),%ymm1
124b7ae vmovupd 0x40(%rax),%ymm2
124b7b3 vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b7b9 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b7bf vblendpd $0xa,%ymm4,%ymm3,%ymm3
124b7c5 vmovapd %ymm3,0x1e0(%rsp)
124b7ce vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b7d4 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b7da vshufpd $0x5,%ymm1,%ymm0,%ymm0
124b7df vmovapd %ymm0,0x200(%rsp)
124b7e8 vblendpd $0xa,%ymm1,%ymm4,%ymm0
124b7ee vmovapd %ymm0,0x220(%rsp)
124b7f7 mov    0x80(%rbp),%r12
124b7fe movzbl 0x2(%r15),%eax
124b803 test   %al,%al
124b805 je     124b87f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x19f>
124b807 lea    0x50(%rbp),%rcx
124b80b mov    (%rcx),%rcx
124b80e vmovupd (%rcx),%ymm0
124b812 vmovupd 0x20(%rcx),%ymm1
124b817 vmovupd 0x40(%rcx),%ymm2
124b81c vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b822 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b828 vblendpd $0xa,%ymm4,%ymm3,%ymm3
124b82e vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b834 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b83a vshufpd $0x5,%ymm1,%ymm0,%ymm0
124b83f vblendpd $0xa,%ymm1,%ymm4,%ymm1
124b845 vmovapd %ymm0,0x260(%rsp)
124b84e vmulpd 0x200(%rsp),%ymm0,%ymm0
124b857 vmovapd %ymm3,0x360(%rsp)
124b860 vfmadd231pd 0x1e0(%rsp),%ymm3,%ymm0
124b86a vmovapd %ymm1,0x380(%rsp)
124b873 vfmadd231pd 0x220(%rsp),%ymm1,%ymm0
124b87d jmp    124b888 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1a8>
124b87f vbroadcastsd 0x830080(%rip),%ymm0        # 1a7b908 <_fini+0x14d4>
124b888 vbroadcastsd 0x28(%r12),%ymm1
124b88f vbroadcastsd 0x82fff0(%rip),%ymm2        # 1a7b888 <_fini+0x1454>
124b898 vmovapd %ymm2,0x20(%rsp)
124b89e test   %al,%al
124b8a0 je     124b8ce <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1ee>
124b8a2 cmpb   $0x0,0x4(%r15)
124b8a7 je     124b8ce <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1ee>
124b8a9 vucomisd 0x830057(%rip),%xmm1        # 1a7b908 <_fini+0x14d4>
124b8b1 jbe    124b8ce <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1ee>
124b8b3 vsubpd %ymm0,%ymm1,%ymm2
124b8b7 vbroadcastsd 0x82ffc8(%rip),%ymm3        # 1a7b888 <_fini+0x1454>
124b8c0 vaddpd %ymm3,%ymm1,%ymm3
124b8c4 vdivpd %ymm3,%ymm2,%ymm2
124b8c8 vmovapd %ymm2,0x20(%rsp)
124b8ce mov    0x10(%rbp),%rcx
124b8d2 vmovsd 0x38(%r12),%xmm3
124b8d9 vxorpd %xmm2,%xmm2,%xmm2
124b8dd vucomisd %xmm2,%xmm3
124b8e1 mov    $0x1,%al
124b8e3 ja     124b904 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x224>
124b8e5 vmovsd 0x30(%r12),%xmm3
124b8ec vucomisd %xmm2,%xmm3
124b8f0 ja     124b904 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x224>
124b8f2 vmovsd 0x48(%r12),%xmm3
124b8f9 vxorpd %xmm4,%xmm4,%xmm4
124b8fd vucomisd %xmm4,%xmm3
124b901 seta   %al
124b904 movzbl 0x90(%rbp),%r13d
124b90c vmovupd (%rcx),%ymm11
124b910 vcmplepd %ymm1,%ymm0,%ymm0
124b915 vmovapd %ymm0,0x60(%rsp)
124b91b cmpb   $0x0,0x5(%r15)
124b920 setne  %r14b
124b924 cmpb   $0x0,0x1(%r15)
124b929 vmovsd 0x8(%r12),%xmm1
124b930 je     124b939 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x259>
124b932 vmovsd 0x18(%r12),%xmm2
124b939 vaddsd 0x10(%r12),%xmm2,%xmm2
124b940 vbroadcastsd 0x8(%r12),%ymm0
124b947 vbroadcastsd 0x82ff30(%rip),%ymm3        # 1a7b880 <_fini+0x144c>
124b950 vmovapd %ymm3,0x340(%rsp)
124b959 vxorpd %ymm3,%ymm11,%ymm3
124b95d vsubsd %xmm2,%xmm1,%xmm1
124b961 vbroadcastsd %xmm1,%ymm1
124b966 vmovapd %ymm3,0x80(%rsp)
124b96f vsubpd %ymm1,%ymm3,%ymm5
124b973 vdivpd %ymm0,%ymm5,%ymm4
124b977 vmulpd %ymm4,%ymm4,%ymm2
124b97b vmulpd %ymm2,%ymm4,%ymm6
124b97f vxorpd %xmm1,%xmm1,%xmm1
124b983 vcmplepd %ymm1,%ymm0,%ymm3
124b988 vbroadcastsd 0x82ff17(%rip),%ymm7        # 1a7b8a8 <_fini+0x1474>
124b991 vmovapd %ymm7,0x100(%rsp)
124b99a vandpd %ymm7,%ymm5,%ymm7
124b99e vcmpltpd %ymm7,%ymm0,%ymm7
124b9a3 vbroadcastsd 0x830304(%rip),%ymm9        # 1a7bcb0 <_fini+0x187c>
124b9ac vbroadcastsd 0x830303(%rip),%ymm10        # 1a7bcb8 <_fini+0x1884>
124b9b5 vbroadcastsd 0x82fefa(%rip),%ymm8        # 1a7b8b8 <_fini+0x1484>
124b9be vorpd  %ymm3,%ymm7,%ymm3
124b9c2 vmovapd %ymm10,0xa0(%rsp)
124b9cb vmovapd %ymm10,%ymm7
124b9cf vbroadcastsd 0x830308(%rip),%ymm10        # 1a7bce0 <_fini+0x18ac>
124b9d8 vfmadd213pd %ymm8,%ymm4,%ymm7
124b9dd vmovapd %ymm10,0xe0(%rsp)
124b9e6 vfmadd231pd %ymm10,%ymm6,%ymm7
124b9eb vmulpd %ymm7,%ymm5,%ymm7
124b9ef vmovapd %ymm9,0x3a0(%rsp)
124b9f8 vfmadd231pd %ymm9,%ymm0,%ymm7
124b9fd vblendvpd %ymm3,%ymm5,%ymm7,%ymm7
124ba03 vbroadcastsd 0x8302bc(%rip),%ymm9        # 1a7bcc8 <_fini+0x1894>
124ba0c vmovapd %ymm8,0x4a0(%rsp)
124ba15 vmovapd %ymm9,0x160(%rsp)
124ba1e vfmadd213pd %ymm8,%ymm9,%ymm4
124ba23 vbroadcastsd 0x8302bc(%rip),%ymm8        # 1a7bce8 <_fini+0x18b4>
124ba2c vmovapd %ymm8,0xc0(%rsp)
124ba35 vfmadd231pd %ymm6,%ymm8,%ymm4
124ba3a vcmpnltpd %ymm1,%ymm5,%ymm5
124ba3f vbroadcastsd 0x82fe40(%rip),%ymm6        # 1a7b888 <_fini+0x1454>
124ba48 vandpd %ymm6,%ymm5,%ymm5
124ba4c vblendvpd %ymm3,%ymm5,%ymm4,%ymm4
124ba52 and    %al,%r14b
124ba55 vmaxpd %ymm7,%ymm1,%ymm5
124ba59 vmaxpd %ymm4,%ymm1,%ymm4
124ba5d vmovapd %ymm6,0x2e0(%rsp)
124ba66 vminpd %ymm4,%ymm6,%ymm6
124ba6a vandpd 0x60(%rsp),%ymm5,%ymm4
124ba70 vbroadcastsd (%r12),%ymm5
124ba76 test   %r13b,%r13b
124ba79 je     124ba99 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x3b9>
124ba7b vmulsd 0x82fe35(%rip),%xmm5,%xmm7        # 1a7b8b8 <_fini+0x1484>
124ba83 vmulpd %ymm4,%ymm4,%ymm8
124ba87 vbroadcastsd %xmm7,%ymm7
124ba8c vmulpd %ymm7,%ymm8,%ymm7
124ba90 vmovapd %ymm7,0x4c0(%rsp)
124ba99 vandpd 0x60(%rsp),%ymm6,%ymm6
124ba9f mov    %r14d,%ecx
124baa2 or     0x98(%rbp),%cl
124baa8 cmp    $0x1,%cl
124baab jne    124bb00 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x420>
124baad vmulpd %ymm4,%ymm5,%ymm7
124bab1 vmulpd %ymm6,%ymm7,%ymm7
124bab5 cmpb   $0x0,0x98(%rbp)
124babc je     124baf1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x411>
124babe vmulpd 0x40(%rsp),%ymm7,%ymm8
124bac4 vmovapd %ymm8,0x280(%rsp)
124bacd vmulpd 0x120(%rsp),%ymm7,%ymm8
124bad6 vmovapd %ymm8,0x2a0(%rsp)
124badf vmulpd 0x140(%rsp),%ymm7,%ymm8
124bae8 vmovapd %ymm8,0x2c0(%rsp)
124baf1 vmulpd 0x20(%rsp),%ymm7,%ymm7
124baf7 vmovapd %ymm7,0x320(%rsp)
124bb00 cmpb   $0x0,0xa0(%rbp)
124bb07 je     124bc72 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x592>
124bb0d vmovapd 0x2e0(%rsp),%ymm7
124bb16 vsubpd %ymm2,%ymm7,%ymm2
124bb1a vmulpd 0x160(%rsp),%ymm2,%ymm2
124bb23 vdivpd %ymm0,%ymm2,%ymm0
124bb27 vandnpd %ymm0,%ymm3,%ymm0
124bb2b vmaxpd %ymm0,%ymm1,%ymm0
124bb2f vandpd 0x60(%rsp),%ymm0,%ymm0
124bb35 vxorpd 0x340(%rsp),%ymm5,%ymm1
124bb3e vmulpd %ymm0,%ymm4,%ymm0
124bb42 vfmadd213pd %ymm0,%ymm6,%ymm6
124bb47 vmulpd %ymm1,%ymm6,%ymm0
124bb4b vmovapd 0x40(%rsp),%ymm3
124bb51 vmulpd %ymm0,%ymm3,%ymm1
124bb55 vmovapd 0x120(%rsp),%ymm5
124bb5e vmulpd %ymm0,%ymm5,%ymm2
124bb62 vmovapd 0x140(%rsp),%ymm4
124bb6b vmulpd %ymm0,%ymm4,%ymm0
124bb6f vmulpd %ymm1,%ymm3,%ymm3
124bb73 vmovapd %ymm3,0x3c0(%rsp)
124bb7c vmulpd %ymm2,%ymm5,%ymm3
124bb80 vmovapd %ymm3,0x3e0(%rsp)
124bb89 vmulpd %ymm0,%ymm4,%ymm0
124bb8d vmovapd %ymm0,0x460(%rsp)
124bb96 vmulpd %ymm1,%ymm5,%ymm0
124bb9a vmovapd %ymm0,0x400(%rsp)
124bba3 vmulpd %ymm1,%ymm4,%ymm0
124bba7 vmovapd %ymm0,0x440(%rsp)
124bbb0 vmulpd %ymm2,%ymm4,%ymm0
124bbb4 vmovapd %ymm0,0x420(%rsp)
124bbbd test   %al,%al
124bbbf jne    124bc7a <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x59a>
124bbc5 vmovapd 0x4c0(%rsp),%ymm0
124bbce test   %r13b,%r13b
124bbd1 je     124bbdf <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4ff>
124bbd3 mov    0x310(%rsp),%rax
124bbdb vmovupd %ymm0,(%rax)
124bbdf cmpb   $0x0,0x98(%rbp)
124bbe6 je     124be35 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x755>
124bbec vmovapd 0x280(%rsp),%ymm4
124bbf5 vpermpd $0x6c,%ymm4,%ymm0
124bbfb vmovapd 0x2c0(%rsp),%ymm2
124bc04 vpermpd $0xc6,%ymm2,%ymm1
124bc0a vblendpd $0xa,%ymm0,%ymm1,%ymm0
124bc10 vmovapd 0x2a0(%rsp),%ymm3
124bc19 vunpcklpd %ymm3,%ymm4,%ymm1
124bc1d vunpckhpd %ymm2,%ymm3,%ymm2
124bc21 vblendpd $0xc,%ymm0,%ymm1,%ymm3
124bc27 mov    0x318(%rsp),%rax
124bc2f vmovupd %ymm3,(%rax)
124bc33 vblendpd $0xc,%ymm1,%ymm2,%ymm1
124bc39 vmovupd %ymm1,0x20(%rax)
124bc3e vblendpd $0xc,%ymm2,%ymm0,%ymm0
124bc44 vmovupd %ymm0,0x40(%rax)
124bc49 cmpb   $0x0,0xa0(%rbp)
124bc50 jne    124be42 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x762>
124bc56 mov    %fs:0x28,%rax
124bc5f cmp    0x540(%rsp),%rax
124bc67 je     124bfda <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x8fa>
124bc6d jmp    124d428 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d48>
124bc72 test   %al,%al
124bc74 je     124bbc5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4e5>
124bc7a vmovapd %ymm11,0x4e0(%rsp)
124bc83 lea    0xb0(%rbp),%r13
124bc8a lea    0x70(%rbp),%rax
124bc8e lea    0x60(%rbp),%rcx
124bc92 mov    (%rcx),%rcx
124bc95 vmovupd (%rcx),%ymm0
124bc99 vmovupd 0x20(%rcx),%ymm1
124bc9e vmovupd 0x40(%rcx),%ymm2
124bca3 vblendpd $0x4,%ymm1,%ymm0,%ymm3
124bca9 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124bcaf vblendpd $0xa,%ymm4,%ymm3,%ymm6
124bcb5 vblendpd $0x2,%ymm0,%ymm1,%ymm0
124bcbb vblendpd $0x4,%ymm2,%ymm0,%ymm0
124bcc1 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124bcc7 vblendpd $0xa,%ymm1,%ymm4,%ymm7
124bccd mov    (%rax),%rax
124bcd0 vmovupd (%rax),%ymm1
124bcd4 vmovupd 0x20(%rax),%ymm2
124bcd9 vmovupd 0x40(%rax),%ymm3
124bcde vblendpd $0x4,%ymm2,%ymm1,%ymm4
124bce4 vperm2f128 $0x21,%ymm3,%ymm1,%ymm5
124bcea vblendpd $0xa,%ymm5,%ymm4,%ymm4
124bcf0 vblendpd $0x2,%ymm1,%ymm2,%ymm1
124bcf6 vblendpd $0xc,%ymm3,%ymm2,%ymm2
124bcfc vblendpd $0xa,%ymm2,%ymm5,%ymm3
124bd02 vmovapd %ymm6,0x240(%rsp)
124bd0b vsubpd %ymm4,%ymm6,%ymm4
124bd0f vshufpd $0x5,%ymm2,%ymm1,%ymm1
124bd14 vshufpd $0x5,%ymm0,%ymm0,%ymm0
124bd19 vmovapd %ymm0,0x500(%rsp)
124bd22 vsubpd %ymm1,%ymm0,%ymm0
124bd26 cmpq   $0x4,0x8(%r13)
124bd2b vmovapd %ymm7,0x480(%rsp)
124bd34 vsubpd %ymm3,%ymm7,%ymm1
124bd38 vmovapd %ymm1,0x180(%rsp)
124bd41 vmovapd %ymm1,%ymm10
124bd45 vmovapd %ymm0,0x1a0(%rsp)
124bd4e vmovapd %ymm0,%ymm11
124bd52 vmovapd %ymm4,0x1c0(%rsp)
124bd5b vmovapd %ymm4,%ymm12
124bd5f jne    124be09 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x729>
124bd65 mov    0xbbe49c(%rip),%rax        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124bd6c movzbl (%rax),%eax
124bd6f test   %al,%al
124bd71 je     124d237 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1b57>
124bd77 mov    0xbcda92(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124bd7e vmovsd (%rax),%xmm0
124bd82 vxorpd %xmm1,%xmm1,%xmm1
124bd86 vucomisd %xmm1,%xmm0
124bd8a vmovapd 0x180(%rsp),%ymm10
124bd93 vmovapd 0x1a0(%rsp),%ymm11
124bd9c vmovapd 0x1c0(%rsp),%ymm12
124bda5 jbe    124be09 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x729>
124bda7 mov    0x0(%r13),%rax
124bdab vmovupd (%rax),%ymm0
124bdaf vmovupd 0x20(%rax),%ymm1
124bdb4 vmovupd 0x40(%rax),%ymm2
124bdb9 vblendpd $0x4,%ymm1,%ymm0,%ymm3
124bdbf vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124bdc5 vblendpd $0xa,%ymm4,%ymm3,%ymm3
124bdcb vblendpd $0x2,%ymm0,%ymm1,%ymm0
124bdd1 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124bdd7 vblendpd $0xa,%ymm1,%ymm4,%ymm2
124bddd vmovapd 0x240(%rsp),%ymm4
124bde6 vsubpd %ymm3,%ymm4,%ymm12
124bdea vshufpd $0x5,%ymm1,%ymm0,%ymm0
124bdef vmovapd 0x500(%rsp),%ymm1
124bdf8 vsubpd %ymm0,%ymm1,%ymm11
124bdfc vmovapd 0x480(%rsp),%ymm0
124be05 vsubpd %ymm2,%ymm0,%ymm10
124be09 test   %r14b,%r14b
124be0c movzbl 0x90(%rbp),%r13d
124be14 jne    124c12a <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa4a>
124be1a cmpb   $0x0,0x3(%r15)
124be1f je     124bfec <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x90c>
124be25 lea    0x30(%rbp),%rax
124be29 mov    (%rax),%rax
124be2c vmovupd (%rax),%ymm1
124be30 jmp    124c02e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x94e>
124be35 cmpb   $0x0,0xa0(%rbp)
124be3c je     124bc56 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x576>
124be42 vmovapd 0x3c0(%rsp),%ymm7
124be4b vpermpd $0xff,%ymm7,%ymm0
124be51 vmovapd 0x400(%rsp),%ymm8
124be5a vextractf128 $0x1,%ymm8,%xmm3
124be60 vblendpd $0x1,%ymm0,%ymm3,%ymm0
124be66 vmovapd 0x440(%rsp),%ymm11
124be6f vshufpd $0x4,%ymm11,%ymm11,%ymm1
124be75 vblendpd $0x4,%ymm1,%ymm0,%ymm0
124be7b vpermpd $0xff,%ymm8,%ymm1
124be81 vmovapd 0x3e0(%rsp),%ymm9
124be8a vextractf128 $0x1,%ymm9,%xmm4
124be90 vblendpd $0x1,%ymm1,%ymm4,%ymm1
124be96 vmovapd 0x420(%rsp),%ymm12
124be9f vshufpd $0x4,%ymm12,%ymm12,%ymm2
124bea5 vblendpd $0x4,%ymm2,%ymm1,%ymm1
124beab vextractf128 $0x1,%ymm7,%xmm2
124beb1 vshufpd $0x8,%ymm3,%ymm2,%ymm2
124beb6 vblendpd $0x4,%ymm11,%ymm2,%ymm2
124bebc vshufpd $0x8,%ymm4,%ymm3,%ymm3
124bec1 vblendpd $0x4,%ymm12,%ymm3,%ymm3
124bec7 vshufpd $0x1,%xmm7,%xmm7,%xmm4
124becc vmovapd %xmm8,%xmm5
124bed0 vinsertf128 $0x1,%xmm11,%ymm4,%ymm4
124bed6 vshufpd $0xe,%ymm5,%ymm4,%ymm4
124bedb vshufpd $0x1,%xmm8,%xmm8,%xmm5
124bee1 vmovapd %xmm9,%xmm6
124bee5 vinsertf128 $0x1,%xmm12,%ymm5,%ymm5
124beeb vshufpd $0xe,%ymm6,%ymm5,%ymm5
124bef0 vmovddup %xmm8,%xmm6
124bef5 vinsertf128 $0x1,%xmm11,%ymm7,%ymm7
124befb vblendpd $0xa,%ymm6,%ymm7,%ymm6
124bf01 vmovddup %xmm9,%xmm7
124bf06 vinsertf128 $0x1,%xmm12,%ymm8,%ymm8
124bf0c vblendpd $0xa,%ymm7,%ymm8,%ymm7
124bf12 vmovddup %xmm12,%xmm8
124bf17 vmovapd 0x460(%rsp),%ymm10
124bf20 vinsertf128 $0x1,%xmm10,%ymm11,%ymm9
124bf26 vblendpd $0xa,%ymm8,%ymm9,%ymm8
124bf2c vmovapd %ymm6,(%rbx)
124bf30 vmovapd %ymm7,0x20(%rbx)
124bf35 vmovapd %ymm8,0x40(%rbx)
124bf3a vshufpd $0x1,%xmm11,%xmm11,%xmm6
124bf40 vmovapd %xmm12,%xmm7
124bf44 vinsertf128 $0x1,%xmm10,%ymm6,%ymm6
124bf4a vshufpd $0xe,%ymm7,%ymm6,%ymm6
124bf4f vmovapd %ymm4,0x60(%rbx)
124bf54 vmovapd %ymm5,0x80(%rbx)
124bf5c vmovapd %ymm6,0xa0(%rbx)
124bf64 vextractf128 $0x1,%ymm11,%xmm4
124bf6a vextractf128 $0x1,%ymm12,%xmm5
124bf70 vshufpd $0x8,%ymm5,%ymm4,%ymm4
124bf75 vblendpd $0x4,%ymm10,%ymm4,%ymm4
124bf7b vmovapd %ymm2,0xc0(%rbx)
124bf83 vmovapd %ymm3,0xe0(%rbx)
124bf8b vmovapd %ymm4,0x100(%rbx)
124bf93 vpermpd $0xff,%ymm11,%ymm2
124bf99 vblendpd $0x1,%ymm2,%ymm5,%ymm2
124bf9f vshufpd $0x4,%ymm10,%ymm10,%ymm3
124bfa5 vblendpd $0x4,%ymm3,%ymm2,%ymm2
124bfab vmovapd %ymm0,0x120(%rbx)
124bfb3 vmovapd %ymm1,0x140(%rbx)
124bfbb vmovapd %ymm2,0x160(%rbx)
124bfc3 mov    %fs:0x28,%rax
124bfcc cmp    0x540(%rsp),%rax
124bfd4 jne    124d428 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d48>
124bfda lea    -0x28(%rbp),%rsp
124bfde pop    %rbx
124bfdf pop    %r12
124bfe1 pop    %r13
124bfe3 pop    %r14
124bfe5 pop    %r15
124bfe7 pop    %rbp
124bfe8 vzeroupper
124bfeb ret
124bfec vmovapd 0x120(%rsp),%ymm0
124bff5 vmulpd 0x1a0(%rsp),%ymm0,%ymm0
124bffe vmovapd 0x40(%rsp),%ymm1
124c004 vfmadd132pd 0x1c0(%rsp),%ymm0,%ymm1
124c00e vmovapd 0x140(%rsp),%ymm0
124c017 vfmadd132pd 0x180(%rsp),%ymm1,%ymm0
124c021 vmovapd 0x4e0(%rsp),%ymm1
124c02a vsubpd %ymm0,%ymm1,%ymm1
124c02e vbroadcastsd (%r12),%ymm0
124c034 cmpb   $0x0,0x1(%r15)
124c039 vmovsd 0x8(%r12),%xmm2
124c040 vxorpd %xmm3,%xmm3,%xmm3
124c044 je     124c04d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x96d>
124c046 vmovsd 0x18(%r12),%xmm3
124c04d vaddsd 0x10(%r12),%xmm3,%xmm3
124c054 vbroadcastsd 0x8(%r12),%ymm4
124c05b vxorpd 0x340(%rsp),%ymm1,%ymm1
124c064 vsubsd %xmm3,%xmm2,%xmm2
124c068 vbroadcastsd %xmm2,%ymm2
124c06d vsubpd %ymm2,%ymm1,%ymm1
124c071 vdivpd %ymm4,%ymm1,%ymm2
124c075 vmulpd %ymm2,%ymm2,%ymm3
124c079 vmulpd %ymm3,%ymm2,%ymm3
124c07d vxorpd %xmm5,%xmm5,%xmm5
124c081 vcmplepd %ymm5,%ymm4,%ymm6
124c086 vandpd 0x100(%rsp),%ymm1,%ymm7
124c08f vcmpltpd %ymm7,%ymm4,%ymm7
124c094 vorpd  %ymm6,%ymm7,%ymm6
124c098 vmovapd 0xa0(%rsp),%ymm7
124c0a1 vmovapd 0x4a0(%rsp),%ymm8
124c0aa vfmadd213pd %ymm8,%ymm2,%ymm7
124c0af vfmadd231pd 0xe0(%rsp),%ymm3,%ymm7
124c0b9 vmulpd %ymm7,%ymm1,%ymm7
124c0bd vfmadd231pd 0x3a0(%rsp),%ymm4,%ymm7
124c0c7 vfmadd132pd 0x160(%rsp),%ymm8,%ymm2
124c0d1 vfmadd231pd 0xc0(%rsp),%ymm3,%ymm2
124c0db vblendvpd %ymm6,%ymm1,%ymm7,%ymm3
124c0e1 vcmpnltpd %ymm5,%ymm1,%ymm1
124c0e6 vmovapd 0x2e0(%rsp),%ymm4
124c0ef vandpd %ymm4,%ymm1,%ymm1
124c0f3 vblendvpd %ymm6,%ymm1,%ymm2,%ymm1
124c0f9 vmaxpd %ymm3,%ymm5,%ymm2
124c0fd vmaxpd %ymm1,%ymm5,%ymm1
124c101 vmovapd 0x60(%rsp),%ymm3
124c107 vandpd %ymm3,%ymm2,%ymm2
124c10b vmulpd %ymm2,%ymm0,%ymm0
124c10f vminpd %ymm1,%ymm4,%ymm1
124c113 vandpd %ymm3,%ymm1,%ymm1
124c117 vmulpd %ymm1,%ymm0,%ymm0
124c11b vmulpd 0x20(%rsp),%ymm0,%ymm0
124c121 vmovapd %ymm0,0x320(%rsp)
124c12a mov    0xbc35d7(%rip),%r14        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124c131 movzbl (%r14),%eax
124c135 test   %al,%al
124c137 je     124d097 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x19b7>
124c13d mov    0xbc7d34(%rip),%rax        # 1e13e78 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f48>
124c144 cmpb   $0x0,(%rax)
124c147 je     124c2b8 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xbd8>
124c14d vmovsd 0x48(%r12),%xmm0
124c154 vxorpd %xmm1,%xmm1,%xmm1
124c158 vucomisd %xmm1,%xmm0
124c15c jbe    124c2b8 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xbd8>
124c162 vbroadcastsd (%r12),%ymm0
124c168 cmpb   $0x0,0x1(%r15)
124c16d vmovsd 0x8(%r12),%xmm2
124c174 je     124c17d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa9d>
124c176 vmovsd 0x18(%r12),%xmm1
124c17d vaddsd 0x10(%r12),%xmm1,%xmm3
124c184 vbroadcastsd 0x8(%r12),%ymm1
124c18b vsubsd %xmm3,%xmm2,%xmm2
124c18f vbroadcastsd %xmm2,%ymm2
124c194 vmovapd 0x80(%rsp),%ymm3
124c19d vsubpd %ymm2,%ymm3,%ymm3
124c1a1 vdivpd %ymm1,%ymm3,%ymm4
124c1a5 vmulpd %ymm4,%ymm4,%ymm2
124c1a9 vmulpd %ymm2,%ymm4,%ymm5
124c1ad vmovapd 0x4a0(%rsp),%ymm6
124c1b6 vmovapd 0xa0(%rsp),%ymm8
124c1bf vfmadd213pd %ymm6,%ymm4,%ymm8
124c1c4 vmovapd 0xe0(%rsp),%ymm7
124c1cd vfmadd213pd %ymm8,%ymm5,%ymm7
124c1d2 vmovapd 0x160(%rsp),%ymm8
124c1db vfmadd213pd %ymm6,%ymm8,%ymm4
124c1e0 vmovapd 0xc0(%rsp),%ymm9
124c1e9 vfmadd213pd %ymm4,%ymm5,%ymm9
124c1ee vxorpd %xmm4,%xmm4,%xmm4
124c1f2 vcmplepd %ymm4,%ymm1,%ymm5
124c1f7 vandpd 0x100(%rsp),%ymm3,%ymm6
124c200 vcmpltpd %ymm6,%ymm1,%ymm6
124c205 vorpd  %ymm5,%ymm6,%ymm5
124c209 vmulpd %ymm7,%ymm3,%ymm6
124c20d vmovapd 0x3a0(%rsp),%ymm7
124c216 vfmadd213pd %ymm6,%ymm1,%ymm7
124c21b vblendvpd %ymm5,%ymm3,%ymm7,%ymm6
124c221 vbroadcastsd 0x82f65e(%rip),%ymm7        # 1a7b888 <_fini+0x1454>
124c22a vcmpnltpd %ymm4,%ymm3,%ymm3
124c22f vandpd %ymm7,%ymm3,%ymm3
124c233 vblendvpd %ymm5,%ymm3,%ymm9,%ymm3
124c239 vmaxpd %ymm3,%ymm4,%ymm3
124c23d vminpd %ymm3,%ymm7,%ymm3
124c241 vsubpd %ymm2,%ymm7,%ymm2
124c245 vmulpd %ymm2,%ymm8,%ymm2
124c249 vdivpd %ymm1,%ymm2,%ymm1
124c24d vandnpd %ymm1,%ymm5,%ymm1
124c251 vmaxpd %ymm6,%ymm4,%ymm2
124c255 vmaxpd %ymm1,%ymm4,%ymm1
124c259 vmovapd 0x60(%rsp),%ymm4
124c25f vandpd %ymm4,%ymm2,%ymm2
124c263 vandpd %ymm4,%ymm3,%ymm3
124c267 vandpd %ymm4,%ymm1,%ymm1
124c26b vmulpd %ymm1,%ymm2,%ymm1
124c26f vmulpd %ymm2,%ymm0,%ymm2
124c273 vmulpd %ymm3,%ymm2,%ymm2
124c277 vfmadd231pd %ymm3,%ymm3,%ymm1
124c27c vmulpd %ymm0,%ymm1,%ymm0
124c280 vmovapd 0x20(%rsp),%ymm1
124c286 vmulpd %ymm2,%ymm1,%ymm2
124c28a vmovapd %ymm2,0x240(%rsp)
124c293 vmulpd %ymm1,%ymm0,%ymm0
124c297 vmovapd %ymm0,0x480(%rsp)
124c2a0 vmovdqu 0x18(%r12),%xmm0
124c2a7 vpextrb $0x8,%xmm0,%ecx
124c2ad movzbl 0x2(%r15),%eax
124c2b2 test   %cl,%cl
124c2b4 je     124c2e6 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc06>
124c2b6 jmp    124c313 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc33>
124c2b8 movzbl 0x20(%r12),%ecx
124c2be vxorpd %xmm0,%xmm0,%xmm0
124c2c2 vmovapd %ymm0,0x480(%rsp)
124c2cb vmovdqa 0x320(%rsp),%ymm0
124c2d4 vmovdqa %ymm0,0x240(%rsp)
124c2dd movzbl 0x2(%r15),%eax
124c2e2 test   %cl,%cl
124c2e4 jne    124c313 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc33>
124c2e6 test   %al,%al
124c2e8 je     124c313 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc33>
124c2ea vmovapd 0x340(%rsp),%ymm0
124c2f3 vxorpd 0x360(%rsp),%ymm0,%ymm4
124c2fc vxorpd 0x260(%rsp),%ymm0,%ymm6
124c305 vxorpd 0x380(%rsp),%ymm0,%ymm5
124c30e jmp    124c3a0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xcc0>
124c313 cmpb   $0x0,0xa8(%rbp)
124c31a je     124c339 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc59>
124c31c vmovapd 0x220(%rsp),%ymm5
124c325 vmovapd 0x200(%rsp),%ymm6
124c32e vmovapd 0x1e0(%rsp),%ymm4
124c337 jmp    124c3a0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xcc0>
124c339 vmovapd 0x200(%rsp),%ymm3
124c342 vmulpd %ymm3,%ymm3,%ymm0
124c346 vmovapd 0x1e0(%rsp),%ymm4
124c34f vfmadd231pd %ymm4,%ymm4,%ymm0
124c354 vmovapd 0x220(%rsp),%ymm2
124c35d vfmadd231pd %ymm2,%ymm2,%ymm0
124c362 vsqrtpd %ymm0,%ymm0
124c366 vbroadcastsd 0x82f519(%rip),%ymm1        # 1a7b888 <_fini+0x1454>
124c36f vdivpd %ymm0,%ymm1,%ymm1
124c373 vmulpd %ymm1,%ymm4,%ymm4
124c377 vmulpd %ymm3,%ymm1,%ymm3
124c37b vmulpd %ymm2,%ymm1,%ymm2
124c37f vbroadcastsd 0x82f948(%rip),%ymm1        # 1a7bcd0 <_fini+0x189c>
124c388 vcmpltpd %ymm1,%ymm0,%ymm0
124c38d vtestpd %ymm0,%ymm0
124c392 jne    124d037 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1957>
124c398 vmovapd %ymm2,%ymm5
124c39c vmovapd %ymm3,%ymm6
124c3a0 vmulpd %ymm6,%ymm11,%ymm2
124c3a4 vfmadd231pd %ymm4,%ymm12,%ymm2
124c3a9 vfmadd231pd %ymm5,%ymm10,%ymm2
124c3ae vmulpd %ymm4,%ymm2,%ymm0
124c3b2 vmulpd %ymm6,%ymm2,%ymm1
124c3b6 vmovapd %ymm2,0x160(%rsp)
124c3bf vmulpd %ymm5,%ymm2,%ymm2
124c3c3 vmovapd %ymm0,0x140(%rsp)
124c3cc vsubpd %ymm0,%ymm12,%ymm3
124c3d0 vmovapd %ymm1,0x120(%rsp)
124c3d9 vsubpd %ymm1,%ymm11,%ymm1
124c3dd vmovapd %ymm2,0x3a0(%rsp)
124c3e6 vsubpd %ymm2,%ymm10,%ymm0
124c3ea vmovapd %ymm1,0xc0(%rsp)
124c3f3 vmulpd %ymm1,%ymm1,%ymm1
124c3f7 vmovapd %ymm3,0xa0(%rsp)
124c400 vfmadd231pd %ymm3,%ymm3,%ymm1
124c405 vmovapd %ymm0,0xe0(%rsp)
124c40e vfmadd231pd %ymm0,%ymm0,%ymm1
124c413 vmovapd 0x1a0(%rsp),%ymm7
124c41c vmulpd %ymm6,%ymm7,%ymm2
124c420 vmovapd 0x1c0(%rsp),%ymm3
124c429 vfmadd231pd %ymm4,%ymm3,%ymm2
124c42e vmovsd 0x18(%rsp),%xmm0
124c434 vmulsd 0x40(%r12),%xmm0,%xmm0
124c43b vmovsd %xmm0,0x60(%rsp)
124c441 vmovapd 0x180(%rsp),%ymm0
124c44a vfmadd231pd %ymm5,%ymm0,%ymm2
124c44f mov    0xbcd622(%rip),%rax        # 1e19a78 <_ZGVZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x34370>
124c456 movzbl (%rax),%eax
124c459 test   %al,%al
124c45b vmovapd %ymm5,0x220(%rsp)
124c464 vmovapd %ymm6,0x200(%rsp)
124c46d vmovapd %ymm4,0x1e0(%rsp)
124c476 je     124d123 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1a43>
124c47c vfnmadd231pd %ymm6,%ymm2,%ymm7
124c481 vmovapd %ymm7,0x1a0(%rsp)
124c48a vfnmadd231pd %ymm4,%ymm2,%ymm3
124c48f vmovapd %ymm3,0x1c0(%rsp)
124c498 vfnmadd231pd %ymm2,%ymm5,%ymm0
124c49d vmovapd %ymm0,0x180(%rsp)
124c4a6 vsqrtpd %ymm1,%ymm0
124c4aa vmovapd %ymm0,0x100(%rsp)
124c4b3 mov    0xbcf596(%rip),%rax        # 1e1ba50 <_ZZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x32390>
124c4ba vmovsd 0x82f3c6(%rip),%xmm0        # 1a7b888 <_fini+0x1454>
124c4c2 vmovapd %xmm0,0x80(%rsp)
124c4cb cmpb   $0x0,(%rax)
124c4ce je     124c5ca <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xeea>
124c4d4 mov    0xbbdd2d(%rip),%r14        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124c4db movzbl (%r14),%eax
124c4df test   %al,%al
124c4e1 je     124d1f7 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1b17>
124c4e7 mov    0xbcd322(%rip),%r13        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124c4ee vmovsd 0x0(%r13),%xmm1
124c4f4 xor    %eax,%eax
124c4f6 vxorpd %xmm0,%xmm0,%xmm0
124c4fa vucomisd %xmm0,%xmm1
124c4fe jbe    124c5ce <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xeee>
124c504 vmovsd 0x60(%rsp),%xmm1
124c50a vucomisd %xmm0,%xmm1
124c50e jbe    124c5ce <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xeee>
124c514 movzbl (%r14),%eax
124c518 test   %al,%al
124c51a je     124d339 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1c59>
124c520 vmovsd 0x0(%r13),%xmm0
124c526 vdivsd 0x60(%rsp),%xmm0,%xmm0
124c52c vaddsd 0x82f354(%rip),%xmm0,%xmm1        # 1a7b888 <_fini+0x1454>
124c534 vmovapd %xmm1,0x80(%rsp)
124c53d vxorpd %xmm1,%xmm1,%xmm1
124c541 vucomisd %xmm1,%xmm0
124c545 mov    0xbc31bc(%rip),%r14        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124c54c jbe    124c5df <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xeff>
124c552 vbroadcastsd %xmm0,%ymm0
124c557 vmovapd 0xa0(%rsp),%ymm3
124c560 vfmadd231pd 0x1c0(%rsp),%ymm0,%ymm3
124c56a vmovapd 0xc0(%rsp),%ymm2
124c573 vfmadd231pd 0x1a0(%rsp),%ymm0,%ymm2
124c57d vmovapd 0xe0(%rsp),%ymm1
124c586 vfmadd231pd 0x180(%rsp),%ymm0,%ymm1
124c590 vmovapd %ymm2,0xc0(%rsp)
124c599 vmulpd %ymm2,%ymm2,%ymm0
124c59d vmovapd %ymm3,0xa0(%rsp)
124c5a6 vfmadd231pd %ymm3,%ymm3,%ymm0
124c5ab vmovapd %ymm1,0xe0(%rsp)
124c5b4 vfmadd231pd %ymm1,%ymm1,%ymm0
124c5b9 vsqrtpd %ymm0,%ymm0
124c5bd vmovapd %ymm0,0x100(%rsp)
124c5c6 mov    $0x1,%al
124c5c8 jmp    124c5e1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf01>
124c5ca xor    %eax,%eax
124c5cc jmp    124c5e9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf09>
124c5ce movzbl 0x90(%rbp),%r13d
124c5d6 mov    0xbc312b(%rip),%r14        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124c5dd jmp    124c5e9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf09>
124c5df xor    %eax,%eax
124c5e1 movzbl 0x90(%rbp),%r13d
124c5e9 mov    %eax,0x380(%rsp)
124c5f0 vmovsd 0x48(%r12),%xmm0
124c5f7 vxorpd %xmm1,%xmm1,%xmm1
124c5fb vucomisd %xmm1,%xmm0
124c5ff jbe    124c641 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf61>
124c601 movzbl (%r14),%eax
124c605 test   %al,%al
124c607 je     124d277 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1b97>
124c60d mov    0xbc7864(%rip),%rax        # 1e13e78 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f48>
124c614 cmpb   $0x0,(%rax)
124c617 setne  %r14b
124c61b mov    0xbca7b6(%rip),%rax        # 1e16dd8 <_ZGVZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x37000>
124c622 movzbl (%rax),%eax
124c625 test   %al,%al
124c627 je     124d2b8 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1bd8>
124c62d mov    0xbbf494(%rip),%rax        # 1e0bac8 <_ZZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x42308>
124c634 cmpb   $0x0,(%rax)
124c637 setne  %al
124c63a test   %r14b,%r14b
124c63d je     124c64b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf6b>
124c63f jmp    124c69f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfbf>
124c641 xor    %r14d,%r14d
124c644 xor    %eax,%eax
124c646 test   %r14b,%r14b
124c649 jne    124c69f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfbf>
124c64b vxorpd %xmm0,%xmm0,%xmm0
124c64f vmovapd %ymm0,0x360(%rsp)
124c658 vmovaps 0x2e0(%rsp),%ymm0
124c661 vmovaps %ymm0,0x60(%rsp)
124c667 vmovapd 0x160(%rsp),%ymm0
124c670 vmovapd %ymm0,0x40(%rsp)
124c676 test   %al,%al
124c678 jne    124c69f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfbf>
124c67a test   %al,%al
124c67c jne    124c740 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1060>
124c682 vmovapd 0x2e0(%rsp),%ymm0
124c68b vmovapd %ymm0,0x60(%rsp)
124c691 test   %r14b,%r14b
124c694 jne    124c745 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1065>
124c69a jmp    124c781 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x10a1>
124c69f vmovsd 0x48(%r12),%xmm1
124c6a6 vxorpd %xmm0,%xmm0,%xmm0
124c6aa vmovapd 0x320(%rsp),%ymm2
124c6b3 vcmpltpd %ymm2,%ymm0,%ymm3
124c6b8 vmovapd 0x240(%rsp),%ymm4
124c6c1 vdivpd %ymm2,%ymm4,%ymm4
124c6c5 vbroadcastsd 0x82f1ba(%rip),%ymm2        # 1a7b888 <_fini+0x1454>
124c6ce vblendvpd %ymm3,%ymm4,%ymm2,%ymm3
124c6d4 vmovsd 0x18(%rsp),%xmm4
124c6da vdivsd %xmm1,%xmm4,%xmm4
124c6de vbroadcastsd %xmm4,%ymm4
124c6e3 vmulpd %ymm4,%ymm3,%ymm3
124c6e7 test   %r14b,%r14b
124c6ea jne    124c6fd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x101d>
124c6ec vmovapd 0x160(%rsp),%ymm4
124c6f5 vmovapd %ymm4,0x40(%rsp)
124c6fb jmp    124c710 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1030>
124c6fd vmovapd 0x160(%rsp),%ymm4
124c706 vminpd %ymm3,%ymm4,%ymm5
124c70a vmovapd %ymm5,0x40(%rsp)
124c710 vcmpltpd %ymm3,%ymm4,%ymm3
124c715 vmovapd %ymm3,0x360(%rsp)
124c71e vdivsd 0x18(%rsp),%xmm1,%xmm1
124c724 vbroadcastsd %xmm1,%ymm1
124c729 vfnmadd213pd %ymm2,%ymm4,%ymm1
124c72e vmaxpd %ymm1,%ymm0,%ymm0
124c732 vmovapd %ymm0,0x60(%rsp)
124c738 test   %al,%al
124c73a je     124c682 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfa2>
124c740 test   %r14b,%r14b
124c743 je     124c781 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x10a1>
124c745 vmovapd 0x40(%rsp),%ymm1
124c74b vmulpd 0x1e0(%rsp),%ymm1,%ymm0
124c754 vmovapd %ymm0,0x140(%rsp)
124c75d vmulpd 0x200(%rsp),%ymm1,%ymm0
124c766 vmovapd %ymm0,0x120(%rsp)
124c76f vmulpd 0x220(%rsp),%ymm1,%ymm0
124c778 vmovapd %ymm0,0x3a0(%rsp)
124c781 vmovapd 0x60(%rsp),%ymm0
124c787 vmulpd 0x320(%rsp),%ymm0,%ymm0
124c790 vmovapd %ymm0,0x2e0(%rsp)
124c799 vmovsd 0x38(%r12),%xmm1
124c7a0 vxorpd %xmm0,%xmm0,%xmm0
124c7a4 vmovapd %xmm1,0x260(%rsp)
124c7ad vucomisd %xmm0,%xmm1
124c7b1 jbe    124c8d1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x11f1>
124c7b7 mov    0xbbda4a(%rip),%rax        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124c7be movzbl (%rax),%eax
124c7c1 test   %al,%al
124c7c3 je     124d2f9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1c19>
124c7c9 mov    0xbcd040(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124c7d0 vmovsd (%rax),%xmm0
124c7d4 vmovsd 0x18(%rsp),%xmm1
124c7da vmulsd 0x40(%r12),%xmm1,%xmm1
124c7e1 vxorpd %xmm2,%xmm2,%xmm2
124c7e5 vcmpltsd %xmm0,%xmm2,%xmm2
124c7ea vblendvpd %xmm2,%xmm0,%xmm1,%xmm0
124c7f0 vbroadcastsd %xmm0,%ymm2
124c7f5 mov    0x8(%r15),%eax
124c7f9 test   %eax,%eax
124c7fb je     124c902 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1222>
124c801 vxorpd %xmm0,%xmm0,%xmm0
124c805 vxorpd %xmm1,%xmm1,%xmm1
124c809 vmovapd %ymm1,0x240(%rsp)
124c812 cmp    $0x1,%eax
124c815 mov    0x380(%rsp),%eax
124c81c jne    124c87e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x119e>
124c81e vbroadcastsd 0x82f0b1(%rip),%ymm0        # 1a7b8d8 <_fini+0x14a4>
124c827 vmaxpd %ymm0,%ymm2,%ymm2
124c82b vmulpd %ymm2,%ymm2,%ymm0
124c82f vbroadcastsd 0x82f1b0(%rip),%ymm1        # 1a7b9e8 <_fini+0x15b4>
124c838 vmulpd %ymm1,%ymm0,%ymm3
124c83c vmovapd 0x100(%rsp),%ymm0
124c845 vfmadd213pd %ymm3,%ymm0,%ymm0
124c84a vsqrtpd %ymm0,%ymm4
124c84e vbroadcastsd 0x82f031(%rip),%ymm0        # 1a7b888 <_fini+0x1454>
124c857 vdivpd %ymm4,%ymm0,%ymm0
124c85b vbroadcastsd 0x82f05c(%rip),%ymm1        # 1a7b8c0 <_fini+0x148c>
124c864 vfmadd213pd %ymm4,%ymm2,%ymm1
124c869 vmulpd %ymm0,%ymm0,%ymm2
124c86d vmulpd %ymm2,%ymm0,%ymm2
124c871 vmulpd %ymm2,%ymm3,%ymm2
124c875 vmovapd %ymm2,0x240(%rsp)
124c87e test   %r13b,%r13b
124c881 je     124c995 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12b5>
124c887 vbroadcastsd 0x260(%rsp),%ymm2
124c891 vmulpd %ymm1,%ymm2,%ymm1
124c895 vmulpd 0x60(%rsp),%ymm1,%ymm2
124c89b test   %al,%al
124c89d je     124c8b9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x11d9>
124c89f vmovsd 0x82efe1(%rip),%xmm1        # 1a7b888 <_fini+0x1454>
124c8a7 vdivsd 0x80(%rsp),%xmm1,%xmm1
124c8b0 vbroadcastsd %xmm1,%ymm1
124c8b5 vmulpd %ymm2,%ymm1,%ymm2
124c8b9 vmovapd %ymm2,0x20(%rsp)
124c8bf cmpb   $0x0,0x98(%rbp)
124c8c6 je     124c99e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12be>
124c8cc jmp    124c9ab <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12cb>
124c8d1 vxorpd %xmm0,%xmm0,%xmm0
124c8d5 vmovapd %ymm0,0x20(%rsp)
124c8db vxorps %xmm0,%xmm0,%xmm0
124c8df vmovaps %ymm0,0x80(%rsp)
124c8e8 vmovsd 0x30(%r12),%xmm0
124c8ef vucomisd 0x82eff1(%rip),%xmm0        # 1a7b8e8 <_fini+0x14b4>
124c8f7 jbe    124caf3 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1413>
124c8fd jmp    124ca79 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1399>
124c902 vmovapd 0x100(%rsp),%ymm8
124c90b vdivpd %ymm2,%ymm8,%ymm0
124c90f vcmplepd %ymm8,%ymm2,%ymm3
124c915 vbroadcastsd 0x82f09a(%rip),%ymm1        # 1a7b9b8 <_fini+0x1584>
124c91e vmovapd %ymm1,%ymm4
124c922 vfnmadd213pd %ymm8,%ymm2,%ymm4
124c927 vmulpd %ymm0,%ymm8,%ymm5
124c92b vbroadcastsd 0x82ef54(%rip),%ymm6        # 1a7b888 <_fini+0x1454>
124c934 vfnmadd213pd %ymm6,%ymm0,%ymm1
124c939 vmulpd %ymm1,%ymm5,%ymm1
124c93d vblendvpd %ymm3,%ymm4,%ymm1,%ymm1
124c943 vxorpd %xmm4,%xmm4,%xmm4
124c947 vsubpd %ymm0,%ymm6,%ymm5
124c94b vbroadcastsd 0x82eff4(%rip),%ymm7        # 1a7b948 <_fini+0x1514>
124c954 vaddpd %ymm5,%ymm5,%ymm5
124c958 vdivpd %ymm2,%ymm5,%ymm5
124c95c vandnpd %ymm5,%ymm3,%ymm5
124c960 vmovapd %ymm5,0x240(%rsp)
124c969 vdivpd %ymm8,%ymm6,%ymm5
124c96e vsubpd %ymm0,%ymm7,%ymm0
124c972 vdivpd %ymm2,%ymm0,%ymm0
124c976 vcmpneqpd %ymm4,%ymm8,%ymm2
124c97b vandpd %ymm5,%ymm2,%ymm2
124c97f vblendvpd %ymm3,%ymm2,%ymm0,%ymm0
124c985 mov    0x380(%rsp),%eax
124c98c test   %r13b,%r13b
124c98f jne    124c887 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x11a7>
124c995 cmpb   $0x0,0x98(%rbp)
124c99c jne    124c9ab <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12cb>
124c99e cmpb   $0x0,0xa0(%rbp)
124c9a5 je     124ca68 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1388>
124c9ab vbroadcastsd 0x260(%rsp),%ymm1
124c9b5 vmulpd 0x2e0(%rsp),%ymm1,%ymm1
124c9be vmovapd %ymm1,0x260(%rsp)
124c9c7 vmulpd %ymm0,%ymm1,%ymm0
124c9cb cmpb   $0x0,0x98(%rbp)
124c9d2 je     124ca28 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1348>
124c9d4 vmovapd 0x280(%rsp),%ymm1
124c9dd vfnmadd231pd 0xa0(%rsp),%ymm0,%ymm1
124c9e7 vmovapd %ymm1,0x280(%rsp)
124c9f0 vmovapd 0x2a0(%rsp),%ymm1
124c9f9 vfnmadd231pd 0xc0(%rsp),%ymm0,%ymm1
124ca03 vmovapd %ymm1,0x2a0(%rsp)
124ca0c vmovapd 0x2c0(%rsp),%ymm1
124ca15 vfnmadd231pd 0xe0(%rsp),%ymm0,%ymm1
124ca1f vmovapd %ymm1,0x2c0(%rsp)
124ca28 cmpb   $0x0,0xa0(%rbp)
124ca2f je     124ca68 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1388>
124ca31 vxorpd 0x340(%rsp),%ymm0,%ymm0
124ca3a test   %al,%al
124ca3c jne    124cf44 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1864>
124ca42 vbroadcastsd 0x82ee3d(%rip),%ymm1        # 1a7b888 <_fini+0x1454>
124ca4b vmulpd %ymm0,%ymm1,%ymm0
124ca4f vmovapd %ymm0,0x80(%rsp)
124ca58 cmpb   $0x0,0x6(%r15)
124ca5d jne    124cf62 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1882>
124ca63 jmp    124cf8d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x18ad>
124ca68 vmovsd 0x30(%r12),%xmm0
124ca6f vucomisd 0x82ee71(%rip),%xmm0        # 1a7b8e8 <_fini+0x14b4>
124ca77 jbe    124caf3 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1413>
124ca79 vdivsd 0x18(%rsp),%xmm0,%xmm0
124ca7f test   %r13b,%r13b
124ca82 je     124cad9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x13f9>
124ca84 vmovapd 0x1a0(%rsp),%ymm1
124ca8d vmulpd %ymm1,%ymm1,%ymm1
124ca91 vmovapd 0x1c0(%rsp),%ymm2
124ca9a vfmadd231pd %ymm2,%ymm2,%ymm1
124ca9f vmovapd 0x180(%rsp),%ymm2
124caa8 vfmadd231pd %ymm2,%ymm2,%ymm1
124caad vsqrtpd %ymm1,%ymm1
124cab1 vmulsd 0x82edff(%rip),%xmm0,%xmm2        # 1a7b8b8 <_fini+0x1484>
124cab9 vmulpd %ymm1,%ymm1,%ymm1
124cabd vbroadcastsd %xmm2,%ymm2
124cac2 vmulpd %ymm2,%ymm1,%ymm1
124cac6 vmovapd 0x20(%rsp),%ymm2
124cacc vfmadd231pd 0x60(%rsp),%ymm1,%ymm2
124cad3 vmovapd %ymm2,0x20(%rsp)
124cad9 cmpb   $0x0,0x98(%rbp)
124cae0 jne    124cc2e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x154e>
124cae6 cmpb   $0x0,0xa0(%rbp)
124caed jne    124cc2e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x154e>
124caf3 vmovsd 0x48(%r12),%xmm1
124cafa vxorpd %xmm0,%xmm0,%xmm0
124cafe vucomisd %xmm0,%xmm1
124cb02 jbe    124cc18 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1538>
124cb08 vdivsd 0x18(%rsp),%xmm1,%xmm0
124cb0e test   %r13b,%r13b
124cb11 je     124cb5b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x147b>
124cb13 test   %r14b,%r14b
124cb16 je     124cf07 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1827>
124cb1c vmovapd 0x40(%rsp),%ymm3
124cb22 vmulpd %ymm3,%ymm3,%ymm1
124cb26 vmovapd 0x160(%rsp),%ymm2
124cb2f vsubpd %ymm3,%ymm2,%ymm2
124cb33 vmulpd %ymm2,%ymm3,%ymm2
124cb37 vmovapd 0x4a0(%rsp),%ymm3
124cb40 vfmadd213pd %ymm2,%ymm1,%ymm3
124cb45 vbroadcastsd %xmm0,%ymm1
124cb4a vmovapd 0x20(%rsp),%ymm2
124cb50 vfmadd231pd %ymm1,%ymm3,%ymm2
124cb55 vmovapd %ymm2,0x20(%rsp)
124cb5b cmpb   $0x0,0x98(%rbp)
124cb62 jne    124cb71 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1491>
124cb64 cmpb   $0x0,0xa0(%rbp)
124cb6b je     124cecd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17ed>
124cb71 vbroadcastsd %xmm0,%ymm0
124cb76 vmulpd 0x320(%rsp),%ymm0,%ymm0
124cb7f cmpb   $0x0,0x98(%rbp)
124cb86 je     124cbdc <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x14fc>
124cb88 vmovapd 0x280(%rsp),%ymm1
124cb91 vfnmadd231pd 0x140(%rsp),%ymm0,%ymm1
124cb9b vmovapd %ymm1,0x280(%rsp)
124cba4 vmovapd 0x2a0(%rsp),%ymm1
124cbad vfnmadd231pd 0x120(%rsp),%ymm0,%ymm1
124cbb7 vmovapd %ymm1,0x2a0(%rsp)
124cbc0 vmovapd 0x2c0(%rsp),%ymm1
124cbc9 vfnmadd231pd 0x3a0(%rsp),%ymm0,%ymm1
124cbd3 vmovapd %ymm1,0x2c0(%rsp)
124cbdc cmpb   $0x0,0xa0(%rbp)
124cbe3 je     124cecd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17ed>
124cbe9 vxorpd 0x340(%rsp),%ymm0,%ymm0
124cbf2 test   %r14b,%r14b
124cbf5 je     124ccd5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x15f5>
124cbfb vmovapd 0x480(%rsp),%ymm1
124cc04 vmovapd 0x360(%rsp),%ymm2
124cc0d vblendvpd %ymm2,%ymm0,%ymm1,%ymm0
124cc13 jmp    124ccd5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x15f5>
124cc18 vxorpd %xmm0,%xmm0,%xmm0
124cc1c cmpb   $0x0,0xa0(%rbp)
124cc23 jne    124ccd5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x15f5>
124cc29 jmp    124cecd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17ed>
124cc2e vbroadcastsd %xmm0,%ymm0
124cc33 vmulpd 0x2e0(%rsp),%ymm0,%ymm0
124cc3c cmpb   $0x0,0x98(%rbp)
124cc43 je     124cc99 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x15b9>
124cc45 vmovapd 0x280(%rsp),%ymm1
124cc4e vfnmadd231pd 0x1c0(%rsp),%ymm0,%ymm1
124cc58 vmovapd %ymm1,0x280(%rsp)
124cc61 vmovapd 0x2a0(%rsp),%ymm1
124cc6a vfnmadd231pd 0x1a0(%rsp),%ymm0,%ymm1
124cc74 vmovapd %ymm1,0x2a0(%rsp)
124cc7d vmovapd 0x2c0(%rsp),%ymm1
124cc86 vfnmadd231pd 0x180(%rsp),%ymm0,%ymm1
124cc90 vmovapd %ymm1,0x2c0(%rsp)
124cc99 cmpb   $0x0,0xa0(%rbp)
124cca0 je     124ceb8 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17d8>
124cca6 vmovapd 0x80(%rsp),%ymm1
124ccaf vsubpd %ymm0,%ymm1,%ymm1
124ccb3 vmovapd %ymm1,0x80(%rsp)
124ccbc vmovsd 0x48(%r12),%xmm1
124ccc3 vxorpd %xmm0,%xmm0,%xmm0
124ccc7 vxorpd %xmm2,%xmm2,%xmm2
124cccb vucomisd %xmm2,%xmm1
124cccf ja     124cb08 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1428>
124ccd5 vmovapd 0x80(%rsp),%ymm7
124ccde vsubpd %ymm7,%ymm0,%ymm0
124cce2 vmovapd 0x1e0(%rsp),%ymm4
124cceb vmulpd %ymm4,%ymm0,%ymm1
124ccef vmovapd 0x200(%rsp),%ymm6
124ccf8 vmulpd %ymm6,%ymm0,%ymm2
124ccfc vmovapd 0x220(%rsp),%ymm5
124cd05 vmulpd %ymm5,%ymm0,%ymm0
124cd09 vfmadd213pd %ymm7,%ymm1,%ymm4
124cd0e vmovapd 0x3c0(%rsp),%ymm3
124cd17 vaddpd %ymm4,%ymm3,%ymm3
124cd1b vmovapd %ymm3,0x3c0(%rsp)
124cd24 vmovapd %ymm6,%ymm3
124cd28 vfmadd213pd %ymm7,%ymm2,%ymm3
124cd2d vmovapd 0x3e0(%rsp),%ymm4
124cd36 vaddpd %ymm3,%ymm4,%ymm4
124cd3a vmovapd %ymm4,0x3e0(%rsp)
124cd43 vfmadd213pd %ymm7,%ymm5,%ymm0
124cd48 vmovapd 0x460(%rsp),%ymm3
124cd51 vaddpd %ymm0,%ymm3,%ymm3
124cd55 vmovapd %ymm3,0x460(%rsp)
124cd5e vmovapd 0x400(%rsp),%ymm0
124cd67 vfmadd231pd %ymm6,%ymm1,%ymm0
124cd6c vmovapd %ymm0,0x400(%rsp)
124cd75 vmovapd 0x440(%rsp),%ymm0
124cd7e vfmadd231pd %ymm1,%ymm5,%ymm0
124cd83 vmovapd %ymm0,0x440(%rsp)
124cd8c vmovapd 0x420(%rsp),%ymm0
124cd95 vfmadd231pd %ymm5,%ymm2,%ymm0
124cd9a vmovapd %ymm0,0x420(%rsp)
124cda3 cmpb   $0x0,0x6(%r15)
124cda8 je     124cde7 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1707>
124cdaa mov    0xbbd457(%rip),%rax        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124cdb1 movzbl (%rax),%eax
124cdb4 test   %al,%al
124cdb6 je     124d374 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1c94>
124cdbc mov    0xbcca4d(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124cdc3 vmovsd (%rax),%xmm1
124cdc7 vxorpd %xmm0,%xmm0,%xmm0
124cdcb vucomisd %xmm0,%xmm1
124cdcf jbe    124cecd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17ed>
124cdd5 vmovsd 0x38(%r12),%xmm1
124cddc vucomisd %xmm0,%xmm1
124cde0 ja     124cdfc <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x171c>
124cde2 jmp    124cecd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17ed>
124cde7 vmovsd 0x38(%r12),%xmm0
124cdee vxorpd %xmm1,%xmm1,%xmm1
124cdf2 vucomisd %xmm1,%xmm0
124cdf6 jbe    124cecd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17ed>
124cdfc vmovapd 0xa0(%rsp),%ymm5
124ce05 vmovapd 0xc0(%rsp),%ymm2
124ce0e vmulpd %ymm2,%ymm5,%ymm0
124ce12 vmovapd 0x100(%rsp),%ymm4
124ce1b vmulpd %ymm2,%ymm4,%ymm1
124ce1f vmovapd 0xe0(%rsp),%ymm6
124ce28 vmulpd %ymm2,%ymm6,%ymm2
124ce2c vmovapd 0x3c0(%rsp),%ymm3
124ce35 vfmadd231pd %ymm5,%ymm0,%ymm3
124ce3a vmovapd %ymm3,0x3c0(%rsp)
124ce43 vmovapd 0x3e0(%rsp),%ymm3
124ce4c vfmadd231pd %ymm1,%ymm4,%ymm3
124ce51 vmovapd %ymm3,0x3e0(%rsp)
124ce5a vmovapd 0x460(%rsp),%ymm3
124ce63 vfmadd231pd %ymm2,%ymm6,%ymm3
124ce68 vmovapd %ymm3,0x460(%rsp)
124ce71 vmovapd 0x400(%rsp),%ymm2
124ce7a vfmadd231pd %ymm4,%ymm0,%ymm2
124ce7f vmovapd %ymm2,0x400(%rsp)
124ce88 vmovapd 0x440(%rsp),%ymm2
124ce91 vfmadd231pd %ymm0,%ymm6,%ymm2
124ce96 vmovapd %ymm2,0x440(%rsp)
124ce9f vmovapd 0x420(%rsp),%ymm0
124cea8 vfmadd231pd %ymm1,%ymm6,%ymm0
124cead vmovapd %ymm0,0x420(%rsp)
124ceb6 jmp    124cecd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17ed>
124ceb8 vmovsd 0x48(%r12),%xmm1
124cebf vxorpd %xmm0,%xmm0,%xmm0
124cec3 vucomisd %xmm0,%xmm1
124cec7 ja     124cb08 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1428>
124cecd test   %r13b,%r13b
124ced0 vmovapd 0x20(%rsp),%ymm0
124ced6 jne    124cee3 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1803>
124ced8 vbroadcastsd 0x82e99f(%rip),%ymm0        # 1a7b880 <_fini+0x144c>
124cee1 jmp    124ceec <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x180c>
124cee3 vmulpd 0x320(%rsp),%ymm0,%ymm0
124ceec vmovapd 0x4c0(%rsp),%ymm1
124cef5 vaddpd %ymm0,%ymm1,%ymm0
124cef9 test   %r13b,%r13b
124cefc jne    124bbd3 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4f3>
124cf02 jmp    124bbdf <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4ff>
124cf07 vmulsd 0x82e9a9(%rip),%xmm0,%xmm1        # 1a7b8b8 <_fini+0x1484>
124cf0f vmovapd 0x160(%rsp),%ymm2
124cf18 vmulpd %ymm2,%ymm2,%ymm2
124cf1c vbroadcastsd %xmm1,%ymm1
124cf21 vmovapd 0x20(%rsp),%ymm3
124cf27 vfmadd231pd %ymm1,%ymm2,%ymm3
124cf2c vmovapd %ymm3,0x20(%rsp)
124cf32 cmpb   $0x0,0x98(%rbp)
124cf39 je     124cb64 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1484>
124cf3f jmp    124cb71 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1491>
124cf44 vbroadcastsd 0x80(%rsp),%ymm1
124cf4e vmulpd %ymm0,%ymm1,%ymm0
124cf52 vmovapd %ymm0,0x80(%rsp)
124cf5b cmpb   $0x0,0x6(%r15)
124cf60 je     124cf8d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x18ad>
124cf62 mov    0xbbd29f(%rip),%rax        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124cf69 movzbl (%rax),%eax
124cf6c test   %al,%al
124cf6e je     124d3b4 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1cd4>
124cf74 mov    0xbcc895(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124cf7b vmovsd (%rax),%xmm0
124cf7f vxorpd %xmm1,%xmm1,%xmm1
124cf83 vucomisd %xmm1,%xmm0
124cf87 jbe    124ca68 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1388>
124cf8d vbroadcastsd 0x82ed42(%rip),%ymm0        # 1a7bcd8 <_fini+0x18a4>
124cf96 vbroadcastsd 0x82e929(%rip),%ymm1        # 1a7b8c8 <_fini+0x1494>
124cf9f vmovapd 0x100(%rsp),%ymm2
124cfa8 vcmpltpd %ymm2,%ymm0,%ymm0
124cfad vaddpd %ymm1,%ymm2,%ymm1
124cfb1 vbroadcastsd 0x82e8ce(%rip),%ymm2        # 1a7b888 <_fini+0x1454>
124cfba vdivpd %ymm1,%ymm2,%ymm1
124cfbe vmulpd 0xa0(%rsp),%ymm1,%ymm2
124cfc7 vmovapd %ymm2,0xa0(%rsp)
124cfd0 vmulpd 0xc0(%rsp),%ymm1,%ymm2
124cfd9 vmovapd %ymm2,0x100(%rsp)
124cfe2 vmulpd 0xe0(%rsp),%ymm1,%ymm1
124cfeb vmovapd %ymm1,0xe0(%rsp)
124cff4 vmovapd 0x240(%rsp),%ymm1
124cffd vmovapd 0x260(%rsp),%ymm2
124d006 vfnmsub213pd 0x80(%rsp),%ymm2,%ymm1
124d010 vandpd %ymm1,%ymm0,%ymm0
124d014 vmovapd %ymm0,0xc0(%rsp)
124d01d vmovsd 0x30(%r12),%xmm0
124d024 vucomisd 0x82e8bc(%rip),%xmm0        # 1a7b8e8 <_fini+0x14b4>
124d02c jbe    124caf3 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1413>
124d032 jmp    124ca79 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1399>
124d037 test   %al,%al
124d039 je     124d07e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x199e>
124d03b vmovapd 0x340(%rsp),%ymm5
124d044 vxorpd 0x360(%rsp),%ymm5,%ymm1
124d04d vblendvpd %ymm0,%ymm1,%ymm4,%ymm4
124d053 vxorpd 0x260(%rsp),%ymm5,%ymm1
124d05c vmovapd %ymm3,%ymm6
124d060 vblendvpd %ymm0,%ymm1,%ymm3,%ymm6
124d066 vxorpd 0x380(%rsp),%ymm5,%ymm1
124d06f vmovapd %ymm2,%ymm5
124d073 vblendvpd %ymm0,%ymm1,%ymm2,%ymm5
124d079 jmp    124c3a0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xcc0>
124d07e vandnpd %ymm4,%ymm0,%ymm4
124d082 vmovapd %ymm3,%ymm6
124d086 vandnpd %ymm3,%ymm0,%ymm6
124d08a vmovapd %ymm2,%ymm5
124d08e vandnpd %ymm2,%ymm0,%ymm5
124d092 jmp    124c3a0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xcc0>
124d097 mov    0xbc266a(%rip),%rdi        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124d09e vmovapd %ymm10,0x40(%rsp)
124d0a4 vmovapd %ymm11,0x140(%rsp)
124d0ad vmovapd %ymm12,0x120(%rsp)
124d0b6 vzeroupper
124d0b9 call   7b7240 <__cxa_guard_acquire@plt>
124d0be vmovapd 0x120(%rsp),%ymm12
124d0c7 vmovapd 0x140(%rsp),%ymm11
124d0d0 vmovapd 0x40(%rsp),%ymm10
124d0d6 test   %eax,%eax
124d0d8 je     124c13d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa5d>
124d0de lea    0x84a734(%rip),%rdi        # 1a97819 <_fini+0x1d3e5>
124d0e5 vzeroupper
124d0e8 call   7c87b0 <getenv@plt>
124d0ed test   %rax,%rax
124d0f0 mov    0xbc6d81(%rip),%rax        # 1e13e78 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f48>
124d0f7 setne  (%rax)
124d0fa mov    0xbc2607(%rip),%rdi        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124d101 call   7bef10 <__cxa_guard_release@plt>
124d106 vmovapd 0x120(%rsp),%ymm12
124d10f vmovapd 0x140(%rsp),%ymm11
124d118 vmovapd 0x40(%rsp),%ymm10
124d11e jmp    124c13d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa5d>
124d123 mov    0xbcc94e(%rip),%rdi        # 1e19a78 <_ZGVZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x34370>
124d12a vmovapd %ymm1,0x20(%rsp)
124d130 vmovapd %ymm2,0x40(%rsp)
124d136 vzeroupper
124d139 call   7b7240 <__cxa_guard_acquire@plt>
124d13e vmovapd 0x180(%rsp),%ymm0
124d147 vmovapd 0x1a0(%rsp),%ymm7
124d150 vmovapd 0x1c0(%rsp),%ymm3
124d159 vmovapd 0x40(%rsp),%ymm2
124d15f vmovapd 0x20(%rsp),%ymm1
124d165 vmovapd 0x200(%rsp),%ymm6
124d16e vmovapd 0x220(%rsp),%ymm5
124d177 vmovapd 0x1e0(%rsp),%ymm4
124d180 test   %eax,%eax
124d182 je     124c47c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd9c>
124d188 lea    0x84a6c4(%rip),%rdi        # 1a97853 <_fini+0x1d41f>
124d18f vzeroupper
124d192 call   7c87b0 <getenv@plt>
124d197 test   %rax,%rax
124d19a mov    0xbce8af(%rip),%rax        # 1e1ba50 <_ZZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x32390>
124d1a1 setne  (%rax)
124d1a4 mov    0xbcc8cd(%rip),%rdi        # 1e19a78 <_ZGVZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x34370>
124d1ab call   7bef10 <__cxa_guard_release@plt>
124d1b0 vmovapd 0x180(%rsp),%ymm0
124d1b9 vmovapd 0x1a0(%rsp),%ymm7
124d1c2 vmovapd 0x1c0(%rsp),%ymm3
124d1cb vmovapd 0x40(%rsp),%ymm2
124d1d1 vmovapd 0x20(%rsp),%ymm1
124d1d7 vmovapd 0x200(%rsp),%ymm6
124d1e0 vmovapd 0x220(%rsp),%ymm5
124d1e9 vmovapd 0x1e0(%rsp),%ymm4
124d1f2 jmp    124c47c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd9c>
124d1f7 mov    0xbbd00a(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d1fe vzeroupper
124d201 call   7b7240 <__cxa_guard_acquire@plt>
124d206 test   %eax,%eax
124d208 je     124c4e7 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe07>
124d20e lea    0x53b(%rsp),%rdi
124d216 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124d21b mov    0xbcc5ee(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124d222 vmovsd %xmm0,(%rax)
124d226 mov    0xbbcfdb(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d22d call   7bef10 <__cxa_guard_release@plt>
124d232 jmp    124c4e7 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe07>
124d237 mov    0xbbcfca(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d23e vzeroupper
124d241 call   7b7240 <__cxa_guard_acquire@plt>
124d246 test   %eax,%eax
124d248 je     124bd77 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x697>
124d24e lea    0x53a(%rsp),%rdi
124d256 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124d25b mov    0xbcc5ae(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124d262 vmovsd %xmm0,(%rax)
124d266 mov    0xbbcf9b(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d26d call   7bef10 <__cxa_guard_release@plt>
124d272 jmp    124bd77 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x697>
124d277 mov    0xbc248a(%rip),%rdi        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124d27e vzeroupper
124d281 call   7b7240 <__cxa_guard_acquire@plt>
124d286 test   %eax,%eax
124d288 je     124c60d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf2d>
124d28e lea    0x84a584(%rip),%rdi        # 1a97819 <_fini+0x1d3e5>
124d295 call   7c87b0 <getenv@plt>
124d29a test   %rax,%rax
124d29d mov    0xbc6bd4(%rip),%rax        # 1e13e78 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f48>
124d2a4 setne  (%rax)
124d2a7 mov    0xbc245a(%rip),%rdi        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124d2ae call   7bef10 <__cxa_guard_release@plt>
124d2b3 jmp    124c60d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf2d>
124d2b8 mov    0xbc9b19(%rip),%rdi        # 1e16dd8 <_ZGVZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x37000>
124d2bf vzeroupper
124d2c2 call   7b7240 <__cxa_guard_acquire@plt>
124d2c7 test   %eax,%eax
124d2c9 je     124c62d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf4d>
124d2cf lea    0x84a55f(%rip),%rdi        # 1a97835 <_fini+0x1d401>
124d2d6 call   7c87b0 <getenv@plt>
124d2db test   %rax,%rax
124d2de mov    0xbbe7e3(%rip),%rax        # 1e0bac8 <_ZZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x42308>
124d2e5 setne  (%rax)
124d2e8 mov    0xbc9ae9(%rip),%rdi        # 1e16dd8 <_ZGVZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x37000>
124d2ef call   7bef10 <__cxa_guard_release@plt>
124d2f4 jmp    124c62d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf4d>
124d2f9 mov    0xbbcf08(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d300 vzeroupper
124d303 call   7b7240 <__cxa_guard_acquire@plt>
124d308 test   %eax,%eax
124d30a je     124c7c9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x10e9>
124d310 lea    0x53d(%rsp),%rdi
124d318 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124d31d mov    0xbcc4ec(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124d324 vmovsd %xmm0,(%rax)
124d328 mov    0xbbced9(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d32f call   7bef10 <__cxa_guard_release@plt>
124d334 jmp    124c7c9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x10e9>
124d339 mov    0xbbcec8(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d340 vzeroupper
124d343 call   7b7240 <__cxa_guard_acquire@plt>
124d348 test   %eax,%eax
124d34a je     124c520 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe40>
124d350 lea    0x53c(%rsp),%rdi
124d358 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124d35d vmovsd %xmm0,0x0(%r13)
124d363 mov    0xbbce9e(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d36a call   7bef10 <__cxa_guard_release@plt>
124d36f jmp    124c520 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe40>
124d374 mov    0xbbce8d(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d37b vzeroupper
124d37e call   7b7240 <__cxa_guard_acquire@plt>
124d383 test   %eax,%eax
124d385 je     124cdbc <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x16dc>
124d38b lea    0x53f(%rsp),%rdi
124d393 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124d398 mov    0xbcc471(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124d39f vmovsd %xmm0,(%rax)
124d3a3 mov    0xbbce5e(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d3aa call   7bef10 <__cxa_guard_release@plt>
124d3af jmp    124cdbc <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x16dc>
124d3b4 mov    0xbbce4d(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d3bb vzeroupper
124d3be call   7b7240 <__cxa_guard_acquire@plt>
124d3c3 test   %eax,%eax
124d3c5 je     124cf74 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1894>
124d3cb lea    0x53e(%rsp),%rdi
124d3d3 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124d3d8 mov    0xbcc431(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124d3df vmovsd %xmm0,(%rax)
124d3e3 mov    0xbbce1e(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d3ea call   7bef10 <__cxa_guard_release@plt>
124d3ef jmp    124cf74 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1894>
124d3f4 jmp    124d3fe <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d1e>
124d3f6 jmp    124d3fe <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d1e>
124d3f8 jmp    124d3fe <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d1e>
124d3fa jmp    124d3fe <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d1e>
124d3fc jmp    124d3fe <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d1e>
124d3fe mov    %rax,%rbx
124d401 mov    0xbbce00(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d408 call   7b9b70 <__cxa_guard_abort@plt>
124d40d mov    %fs:0x28,%rax
124d416 cmp    0x540(%rsp),%rax
124d41e jne    124d428 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d48>
124d420 mov    %rbx,%rdi
124d423 call   7c3330 <_Unwind_Resume@plt>
124d428 vzeroupper
124d42b call   7b4ef0 <__stack_chk_fail@plt>

Disassembly of section .fini:
