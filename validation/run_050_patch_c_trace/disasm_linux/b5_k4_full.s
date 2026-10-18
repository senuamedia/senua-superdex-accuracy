
lib/b5/libmochi_physics_double.so:     file format elf64-x86-64


Disassembly of section .init:

Disassembly of section .plt:

Disassembly of section .plt.got:

Disassembly of section .text:

000000000124b6d0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_>:
124b6d0 push   %rbp
124b6d1 mov    %rsp,%rbp
124b6d4 push   %r15
124b6d6 push   %r14
124b6d8 push   %r13
124b6da push   %r12
124b6dc push   %rbx
124b6dd and    $0xffffffffffffffe0,%rsp
124b6e1 sub    $0x560,%rsp
124b6e8 vmovsd %xmm0,0x18(%rsp)
124b6ee mov    %r8,%rbx
124b6f1 mov    %rdx,0x338(%rsp)
124b6f9 mov    %rdi,0x330(%rsp)
124b701 mov    0x88(%rbp),%r15
124b708 mov    %fs:0x28,%rax
124b711 mov    %rax,0x540(%rsp)
124b719 mov    0x20(%rbp),%rax
124b71d vmovupd (%rax),%ymm0
124b721 vmovupd 0x20(%rax),%ymm1
124b726 vmovupd 0x40(%rax),%ymm2
124b72b vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b731 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b737 vblendpd $0xa,%ymm4,%ymm3,%ymm3
124b73d vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b743 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b749 vshufpd $0x5,%ymm1,%ymm0,%ymm2
124b74e cmpb   $0x0,0x3(%r15)
124b753 vblendpd $0xa,%ymm1,%ymm4,%ymm0
124b759 vmovapd %ymm0,0x140(%rsp)
124b762 vmovapd %ymm0,0x220(%rsp)
124b76b vmovapd %ymm2,0x120(%rsp)
124b774 vmovapd %ymm2,0x200(%rsp)
124b77d vmovapd %ymm3,0x40(%rsp)
124b783 vmovapd %ymm3,0x1e0(%rsp)
124b78c je     124b7e7 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x117>
124b78e lea    0x40(%rbp),%rax
124b792 mov    (%rax),%rax
124b795 vmovupd (%rax),%ymm0
124b799 vmovupd 0x20(%rax),%ymm1
124b79e vmovupd 0x40(%rax),%ymm2
124b7a3 vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b7a9 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b7af vblendpd $0xa,%ymm4,%ymm3,%ymm3
124b7b5 vmovapd %ymm3,0x1e0(%rsp)
124b7be vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b7c4 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b7ca vshufpd $0x5,%ymm1,%ymm0,%ymm0
124b7cf vmovapd %ymm0,0x200(%rsp)
124b7d8 vblendpd $0xa,%ymm1,%ymm4,%ymm0
124b7de vmovapd %ymm0,0x220(%rsp)
124b7e7 mov    0x80(%rbp),%r12
124b7ee movzbl 0x2(%r15),%eax
124b7f3 test   %al,%al
124b7f5 je     124b86f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x19f>
124b7f7 lea    0x50(%rbp),%rcx
124b7fb mov    (%rcx),%rcx
124b7fe vmovupd (%rcx),%ymm0
124b802 vmovupd 0x20(%rcx),%ymm1
124b807 vmovupd 0x40(%rcx),%ymm2
124b80c vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b812 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b818 vblendpd $0xa,%ymm4,%ymm3,%ymm3
124b81e vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b824 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b82a vshufpd $0x5,%ymm1,%ymm0,%ymm0
124b82f vblendpd $0xa,%ymm1,%ymm4,%ymm1
124b835 vmovapd %ymm0,0x260(%rsp)
124b83e vmulpd 0x200(%rsp),%ymm0,%ymm0
124b847 vmovapd %ymm3,0x380(%rsp)
124b850 vfmadd231pd 0x1e0(%rsp),%ymm3,%ymm0
124b85a vmovapd %ymm1,0x280(%rsp)
124b863 vfmadd231pd 0x220(%rsp),%ymm1,%ymm0
124b86d jmp    124b878 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1a8>
124b86f vbroadcastsd 0x830090(%rip),%ymm0        # 1a7b908 <_fini+0x1434>
124b878 vbroadcastsd 0x28(%r12),%ymm1
124b87f vbroadcastsd 0x830000(%rip),%ymm2        # 1a7b888 <_fini+0x13b4>
124b888 vmovapd %ymm2,0x20(%rsp)
124b88e test   %al,%al
124b890 je     124b8be <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1ee>
124b892 cmpb   $0x0,0x4(%r15)
124b897 je     124b8be <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1ee>
124b899 vucomisd 0x830067(%rip),%xmm1        # 1a7b908 <_fini+0x1434>
124b8a1 jbe    124b8be <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1ee>
124b8a3 vsubpd %ymm0,%ymm1,%ymm2
124b8a7 vbroadcastsd 0x82ffd8(%rip),%ymm3        # 1a7b888 <_fini+0x13b4>
124b8b0 vaddpd %ymm3,%ymm1,%ymm3
124b8b4 vdivpd %ymm3,%ymm2,%ymm2
124b8b8 vmovapd %ymm2,0x20(%rsp)
124b8be mov    0x10(%rbp),%rcx
124b8c2 vmovsd 0x38(%r12),%xmm3
124b8c9 vxorpd %xmm2,%xmm2,%xmm2
124b8cd vucomisd %xmm2,%xmm3
124b8d1 mov    $0x1,%al
124b8d3 ja     124b8f4 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x224>
124b8d5 vmovsd 0x30(%r12),%xmm3
124b8dc vucomisd %xmm2,%xmm3
124b8e0 ja     124b8f4 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x224>
124b8e2 vmovsd 0x48(%r12),%xmm3
124b8e9 vxorpd %xmm4,%xmm4,%xmm4
124b8ed vucomisd %xmm4,%xmm3
124b8f1 seta   %al
124b8f4 movzbl 0x90(%rbp),%r13d
124b8fc vmovupd (%rcx),%ymm11
124b900 vcmplepd %ymm1,%ymm0,%ymm0
124b905 vmovapd %ymm0,0x60(%rsp)
124b90b cmpb   $0x0,0x5(%r15)
124b910 setne  %r14b
124b914 cmpb   $0x0,0x1(%r15)
124b919 vmovsd 0x8(%r12),%xmm1
124b920 je     124b929 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x259>
124b922 vmovsd 0x18(%r12),%xmm2
124b929 vaddsd 0x10(%r12),%xmm2,%xmm2
124b930 vbroadcastsd 0x8(%r12),%ymm0
124b937 vbroadcastsd 0x82ff40(%rip),%ymm3        # 1a7b880 <_fini+0x13ac>
124b940 vmovapd %ymm3,0x360(%rsp)
124b949 vxorpd %ymm3,%ymm11,%ymm3
124b94d vsubsd %xmm2,%xmm1,%xmm1
124b951 vbroadcastsd %xmm1,%ymm1
124b956 vmovapd %ymm3,0x80(%rsp)
124b95f vsubpd %ymm1,%ymm3,%ymm5
124b963 vdivpd %ymm0,%ymm5,%ymm4
124b967 vmulpd %ymm4,%ymm4,%ymm2
124b96b vmulpd %ymm2,%ymm4,%ymm6
124b96f vxorpd %xmm1,%xmm1,%xmm1
124b973 vcmplepd %ymm1,%ymm0,%ymm3
124b978 vbroadcastsd 0x82ff27(%rip),%ymm7        # 1a7b8a8 <_fini+0x13d4>
124b981 vmovapd %ymm7,0x100(%rsp)
124b98a vandpd %ymm7,%ymm5,%ymm7
124b98e vcmpltpd %ymm7,%ymm0,%ymm7
124b993 vbroadcastsd 0x830314(%rip),%ymm9        # 1a7bcb0 <_fini+0x17dc>
124b99c vbroadcastsd 0x830313(%rip),%ymm10        # 1a7bcb8 <_fini+0x17e4>
124b9a5 vbroadcastsd 0x82ff0a(%rip),%ymm8        # 1a7b8b8 <_fini+0x13e4>
124b9ae vorpd  %ymm3,%ymm7,%ymm3
124b9b2 vmovapd %ymm10,0xa0(%rsp)
124b9bb vmovapd %ymm10,%ymm7
124b9bf vbroadcastsd 0x830318(%rip),%ymm10        # 1a7bce0 <_fini+0x180c>
124b9c8 vfmadd213pd %ymm8,%ymm4,%ymm7
124b9cd vmovapd %ymm10,0xe0(%rsp)
124b9d6 vfmadd231pd %ymm10,%ymm6,%ymm7
124b9db vmulpd %ymm7,%ymm5,%ymm7
124b9df vmovapd %ymm9,0x3a0(%rsp)
124b9e8 vfmadd231pd %ymm9,%ymm0,%ymm7
124b9ed vblendvpd %ymm3,%ymm5,%ymm7,%ymm7
124b9f3 vbroadcastsd 0x8302cc(%rip),%ymm9        # 1a7bcc8 <_fini+0x17f4>
124b9fc vmovapd %ymm8,0x4a0(%rsp)
124ba05 vmovapd %ymm9,0x160(%rsp)
124ba0e vfmadd213pd %ymm8,%ymm9,%ymm4
124ba13 vbroadcastsd 0x8302cc(%rip),%ymm8        # 1a7bce8 <_fini+0x1814>
124ba1c vmovapd %ymm8,0xc0(%rsp)
124ba25 vfmadd231pd %ymm6,%ymm8,%ymm4
124ba2a vcmpnltpd %ymm1,%ymm5,%ymm5
124ba2f vbroadcastsd 0x82fe50(%rip),%ymm6        # 1a7b888 <_fini+0x13b4>
124ba38 vandpd %ymm6,%ymm5,%ymm5
124ba3c vblendvpd %ymm3,%ymm5,%ymm4,%ymm4
124ba42 and    %al,%r14b
124ba45 vmaxpd %ymm7,%ymm1,%ymm5
124ba49 vmaxpd %ymm4,%ymm1,%ymm4
124ba4d vmovapd %ymm6,0x300(%rsp)
124ba56 vminpd %ymm4,%ymm6,%ymm6
124ba5a vandpd 0x60(%rsp),%ymm5,%ymm4
124ba60 vbroadcastsd (%r12),%ymm5
124ba66 test   %r13b,%r13b
124ba69 je     124ba89 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x3b9>
124ba6b vmulsd 0x82fe45(%rip),%xmm5,%xmm7        # 1a7b8b8 <_fini+0x13e4>
124ba73 vmulpd %ymm4,%ymm4,%ymm8
124ba77 vbroadcastsd %xmm7,%ymm7
124ba7c vmulpd %ymm7,%ymm8,%ymm7
124ba80 vmovapd %ymm7,0x4c0(%rsp)
124ba89 vandpd 0x60(%rsp),%ymm6,%ymm6
124ba8f mov    %r14d,%ecx
124ba92 or     0x98(%rbp),%cl
124ba98 cmp    $0x1,%cl
124ba9b jne    124baf0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x420>
124ba9d vmulpd %ymm4,%ymm5,%ymm7
124baa1 vmulpd %ymm6,%ymm7,%ymm7
124baa5 cmpb   $0x0,0x98(%rbp)
124baac je     124bae1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x411>
124baae vmulpd 0x40(%rsp),%ymm7,%ymm8
124bab4 vmovapd %ymm8,0x2a0(%rsp)
124babd vmulpd 0x120(%rsp),%ymm7,%ymm8
124bac6 vmovapd %ymm8,0x2c0(%rsp)
124bacf vmulpd 0x140(%rsp),%ymm7,%ymm8
124bad8 vmovapd %ymm8,0x2e0(%rsp)
124bae1 vmulpd 0x20(%rsp),%ymm7,%ymm7
124bae7 vmovapd %ymm7,0x340(%rsp)
124baf0 cmpb   $0x0,0xa0(%rbp)
124baf7 je     124bc62 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x592>
124bafd vmovapd 0x300(%rsp),%ymm7
124bb06 vsubpd %ymm2,%ymm7,%ymm2
124bb0a vmulpd 0x160(%rsp),%ymm2,%ymm2
124bb13 vdivpd %ymm0,%ymm2,%ymm0
124bb17 vandnpd %ymm0,%ymm3,%ymm0
124bb1b vmaxpd %ymm0,%ymm1,%ymm0
124bb1f vandpd 0x60(%rsp),%ymm0,%ymm0
124bb25 vxorpd 0x360(%rsp),%ymm5,%ymm1
124bb2e vmulpd %ymm0,%ymm4,%ymm0
124bb32 vfmadd213pd %ymm0,%ymm6,%ymm6
124bb37 vmulpd %ymm1,%ymm6,%ymm0
124bb3b vmovapd 0x40(%rsp),%ymm3
124bb41 vmulpd %ymm0,%ymm3,%ymm1
124bb45 vmovapd 0x120(%rsp),%ymm5
124bb4e vmulpd %ymm0,%ymm5,%ymm2
124bb52 vmovapd 0x140(%rsp),%ymm4
124bb5b vmulpd %ymm0,%ymm4,%ymm0
124bb5f vmulpd %ymm1,%ymm3,%ymm3
124bb63 vmovapd %ymm3,0x3c0(%rsp)
124bb6c vmulpd %ymm2,%ymm5,%ymm3
124bb70 vmovapd %ymm3,0x3e0(%rsp)
124bb79 vmulpd %ymm0,%ymm4,%ymm0
124bb7d vmovapd %ymm0,0x460(%rsp)
124bb86 vmulpd %ymm1,%ymm5,%ymm0
124bb8a vmovapd %ymm0,0x400(%rsp)
124bb93 vmulpd %ymm1,%ymm4,%ymm0
124bb97 vmovapd %ymm0,0x440(%rsp)
124bba0 vmulpd %ymm2,%ymm4,%ymm0
124bba4 vmovapd %ymm0,0x420(%rsp)
124bbad test   %al,%al
124bbaf jne    124bc6a <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x59a>
124bbb5 vmovapd 0x4c0(%rsp),%ymm0
124bbbe test   %r13b,%r13b
124bbc1 je     124bbcf <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4ff>
124bbc3 mov    0x330(%rsp),%rax
124bbcb vmovupd %ymm0,(%rax)
124bbcf cmpb   $0x0,0x98(%rbp)
124bbd6 je     124be25 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x755>
124bbdc vmovapd 0x2a0(%rsp),%ymm4
124bbe5 vpermpd $0x6c,%ymm4,%ymm0
124bbeb vmovapd 0x2e0(%rsp),%ymm2
124bbf4 vpermpd $0xc6,%ymm2,%ymm1
124bbfa vblendpd $0xa,%ymm0,%ymm1,%ymm0
124bc00 vmovapd 0x2c0(%rsp),%ymm3
124bc09 vunpcklpd %ymm3,%ymm4,%ymm1
124bc0d vunpckhpd %ymm2,%ymm3,%ymm2
124bc11 vblendpd $0xc,%ymm0,%ymm1,%ymm3
124bc17 mov    0x338(%rsp),%rax
124bc1f vmovupd %ymm3,(%rax)
124bc23 vblendpd $0xc,%ymm1,%ymm2,%ymm1
124bc29 vmovupd %ymm1,0x20(%rax)
124bc2e vblendpd $0xc,%ymm2,%ymm0,%ymm0
124bc34 vmovupd %ymm0,0x40(%rax)
124bc39 cmpb   $0x0,0xa0(%rbp)
124bc40 jne    124be32 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x762>
124bc46 mov    %fs:0x28,%rax
124bc4f cmp    0x540(%rsp),%rax
124bc57 je     124bfca <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x8fa>
124bc5d jmp    124d412 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d42>
124bc62 test   %al,%al
124bc64 je     124bbb5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4e5>
124bc6a vmovapd %ymm11,0x4e0(%rsp)
124bc73 lea    0xb0(%rbp),%r13
124bc7a lea    0x70(%rbp),%rax
124bc7e lea    0x60(%rbp),%rcx
124bc82 mov    (%rcx),%rcx
124bc85 vmovupd (%rcx),%ymm0
124bc89 vmovupd 0x20(%rcx),%ymm1
124bc8e vmovupd 0x40(%rcx),%ymm2
124bc93 vblendpd $0x4,%ymm1,%ymm0,%ymm3
124bc99 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124bc9f vblendpd $0xa,%ymm4,%ymm3,%ymm6
124bca5 vblendpd $0x2,%ymm0,%ymm1,%ymm0
124bcab vblendpd $0x4,%ymm2,%ymm0,%ymm0
124bcb1 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124bcb7 vblendpd $0xa,%ymm1,%ymm4,%ymm7
124bcbd mov    (%rax),%rax
124bcc0 vmovupd (%rax),%ymm1
124bcc4 vmovupd 0x20(%rax),%ymm2
124bcc9 vmovupd 0x40(%rax),%ymm3
124bcce vblendpd $0x4,%ymm2,%ymm1,%ymm4
124bcd4 vperm2f128 $0x21,%ymm3,%ymm1,%ymm5
124bcda vblendpd $0xa,%ymm5,%ymm4,%ymm4
124bce0 vblendpd $0x2,%ymm1,%ymm2,%ymm1
124bce6 vblendpd $0xc,%ymm3,%ymm2,%ymm2
124bcec vblendpd $0xa,%ymm2,%ymm5,%ymm3
124bcf2 vmovapd %ymm6,0x240(%rsp)
124bcfb vsubpd %ymm4,%ymm6,%ymm4
124bcff vshufpd $0x5,%ymm2,%ymm1,%ymm1
124bd04 vshufpd $0x5,%ymm0,%ymm0,%ymm0
124bd09 vmovapd %ymm0,0x500(%rsp)
124bd12 vsubpd %ymm1,%ymm0,%ymm0
124bd16 cmpq   $0x4,0x8(%r13)
124bd1b vmovapd %ymm7,0x480(%rsp)
124bd24 vsubpd %ymm3,%ymm7,%ymm1
124bd28 vmovapd %ymm1,0x180(%rsp)
124bd31 vmovapd %ymm1,%ymm10
124bd35 vmovapd %ymm0,0x1a0(%rsp)
124bd3e vmovapd %ymm0,%ymm11
124bd42 vmovapd %ymm4,0x1c0(%rsp)
124bd4b vmovapd %ymm4,%ymm12
124bd4f jne    124bdf9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x729>
124bd55 mov    0xbbe4ac(%rip),%rax        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124bd5c movzbl (%rax),%eax
124bd5f test   %al,%al
124bd61 je     124d221 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1b51>
124bd67 mov    0xbcdaa2(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124bd6e vmovsd (%rax),%xmm0
124bd72 vxorpd %xmm1,%xmm1,%xmm1
124bd76 vucomisd %xmm1,%xmm0
124bd7a vmovapd 0x180(%rsp),%ymm10
124bd83 vmovapd 0x1a0(%rsp),%ymm11
124bd8c vmovapd 0x1c0(%rsp),%ymm12
124bd95 jbe    124bdf9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x729>
124bd97 mov    0x0(%r13),%rax
124bd9b vmovupd (%rax),%ymm0
124bd9f vmovupd 0x20(%rax),%ymm1
124bda4 vmovupd 0x40(%rax),%ymm2
124bda9 vblendpd $0x4,%ymm1,%ymm0,%ymm3
124bdaf vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124bdb5 vblendpd $0xa,%ymm4,%ymm3,%ymm3
124bdbb vblendpd $0x2,%ymm0,%ymm1,%ymm0
124bdc1 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124bdc7 vblendpd $0xa,%ymm1,%ymm4,%ymm2
124bdcd vmovapd 0x240(%rsp),%ymm4
124bdd6 vsubpd %ymm3,%ymm4,%ymm12
124bdda vshufpd $0x5,%ymm1,%ymm0,%ymm0
124bddf vmovapd 0x500(%rsp),%ymm1
124bde8 vsubpd %ymm0,%ymm1,%ymm11
124bdec vmovapd 0x480(%rsp),%ymm0
124bdf5 vsubpd %ymm2,%ymm0,%ymm10
124bdf9 test   %r14b,%r14b
124bdfc movzbl 0x90(%rbp),%r13d
124be04 jne    124c11a <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa4a>
124be0a cmpb   $0x0,0x3(%r15)
124be0f je     124bfdc <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x90c>
124be15 lea    0x30(%rbp),%rax
124be19 mov    (%rax),%rax
124be1c vmovupd (%rax),%ymm1
124be20 jmp    124c01e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x94e>
124be25 cmpb   $0x0,0xa0(%rbp)
124be2c je     124bc46 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x576>
124be32 vmovapd 0x3c0(%rsp),%ymm7
124be3b vpermpd $0xff,%ymm7,%ymm0
124be41 vmovapd 0x400(%rsp),%ymm8
124be4a vextractf128 $0x1,%ymm8,%xmm3
124be50 vblendpd $0x1,%ymm0,%ymm3,%ymm0
124be56 vmovapd 0x440(%rsp),%ymm11
124be5f vshufpd $0x4,%ymm11,%ymm11,%ymm1
124be65 vblendpd $0x4,%ymm1,%ymm0,%ymm0
124be6b vpermpd $0xff,%ymm8,%ymm1
124be71 vmovapd 0x3e0(%rsp),%ymm9
124be7a vextractf128 $0x1,%ymm9,%xmm4
124be80 vblendpd $0x1,%ymm1,%ymm4,%ymm1
124be86 vmovapd 0x420(%rsp),%ymm12
124be8f vshufpd $0x4,%ymm12,%ymm12,%ymm2
124be95 vblendpd $0x4,%ymm2,%ymm1,%ymm1
124be9b vextractf128 $0x1,%ymm7,%xmm2
124bea1 vshufpd $0x8,%ymm3,%ymm2,%ymm2
124bea6 vblendpd $0x4,%ymm11,%ymm2,%ymm2
124beac vshufpd $0x8,%ymm4,%ymm3,%ymm3
124beb1 vblendpd $0x4,%ymm12,%ymm3,%ymm3
124beb7 vshufpd $0x1,%xmm7,%xmm7,%xmm4
124bebc vmovapd %xmm8,%xmm5
124bec0 vinsertf128 $0x1,%xmm11,%ymm4,%ymm4
124bec6 vshufpd $0xe,%ymm5,%ymm4,%ymm4
124becb vshufpd $0x1,%xmm8,%xmm8,%xmm5
124bed1 vmovapd %xmm9,%xmm6
124bed5 vinsertf128 $0x1,%xmm12,%ymm5,%ymm5
124bedb vshufpd $0xe,%ymm6,%ymm5,%ymm5
124bee0 vmovddup %xmm8,%xmm6
124bee5 vinsertf128 $0x1,%xmm11,%ymm7,%ymm7
124beeb vblendpd $0xa,%ymm6,%ymm7,%ymm6
124bef1 vmovddup %xmm9,%xmm7
124bef6 vinsertf128 $0x1,%xmm12,%ymm8,%ymm8
124befc vblendpd $0xa,%ymm7,%ymm8,%ymm7
124bf02 vmovddup %xmm12,%xmm8
124bf07 vmovapd 0x460(%rsp),%ymm10
124bf10 vinsertf128 $0x1,%xmm10,%ymm11,%ymm9
124bf16 vblendpd $0xa,%ymm8,%ymm9,%ymm8
124bf1c vmovapd %ymm6,(%rbx)
124bf20 vmovapd %ymm7,0x20(%rbx)
124bf25 vmovapd %ymm8,0x40(%rbx)
124bf2a vshufpd $0x1,%xmm11,%xmm11,%xmm6
124bf30 vmovapd %xmm12,%xmm7
124bf34 vinsertf128 $0x1,%xmm10,%ymm6,%ymm6
124bf3a vshufpd $0xe,%ymm7,%ymm6,%ymm6
124bf3f vmovapd %ymm4,0x60(%rbx)
124bf44 vmovapd %ymm5,0x80(%rbx)
124bf4c vmovapd %ymm6,0xa0(%rbx)
124bf54 vextractf128 $0x1,%ymm11,%xmm4
124bf5a vextractf128 $0x1,%ymm12,%xmm5
124bf60 vshufpd $0x8,%ymm5,%ymm4,%ymm4
124bf65 vblendpd $0x4,%ymm10,%ymm4,%ymm4
124bf6b vmovapd %ymm2,0xc0(%rbx)
124bf73 vmovapd %ymm3,0xe0(%rbx)
124bf7b vmovapd %ymm4,0x100(%rbx)
124bf83 vpermpd $0xff,%ymm11,%ymm2
124bf89 vblendpd $0x1,%ymm2,%ymm5,%ymm2
124bf8f vshufpd $0x4,%ymm10,%ymm10,%ymm3
124bf95 vblendpd $0x4,%ymm3,%ymm2,%ymm2
124bf9b vmovapd %ymm0,0x120(%rbx)
124bfa3 vmovapd %ymm1,0x140(%rbx)
124bfab vmovapd %ymm2,0x160(%rbx)
124bfb3 mov    %fs:0x28,%rax
124bfbc cmp    0x540(%rsp),%rax
124bfc4 jne    124d412 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d42>
124bfca lea    -0x28(%rbp),%rsp
124bfce pop    %rbx
124bfcf pop    %r12
124bfd1 pop    %r13
124bfd3 pop    %r14
124bfd5 pop    %r15
124bfd7 pop    %rbp
124bfd8 vzeroupper
124bfdb ret
124bfdc vmovapd 0x120(%rsp),%ymm0
124bfe5 vmulpd 0x1a0(%rsp),%ymm0,%ymm0
124bfee vmovapd 0x40(%rsp),%ymm1
124bff4 vfmadd132pd 0x1c0(%rsp),%ymm0,%ymm1
124bffe vmovapd 0x140(%rsp),%ymm0
124c007 vfmadd132pd 0x180(%rsp),%ymm1,%ymm0
124c011 vmovapd 0x4e0(%rsp),%ymm1
124c01a vsubpd %ymm0,%ymm1,%ymm1
124c01e vbroadcastsd (%r12),%ymm0
124c024 cmpb   $0x0,0x1(%r15)
124c029 vmovsd 0x8(%r12),%xmm2
124c030 vxorpd %xmm3,%xmm3,%xmm3
124c034 je     124c03d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x96d>
124c036 vmovsd 0x18(%r12),%xmm3
124c03d vaddsd 0x10(%r12),%xmm3,%xmm3
124c044 vbroadcastsd 0x8(%r12),%ymm4
124c04b vxorpd 0x360(%rsp),%ymm1,%ymm1
124c054 vsubsd %xmm3,%xmm2,%xmm2
124c058 vbroadcastsd %xmm2,%ymm2
124c05d vsubpd %ymm2,%ymm1,%ymm1
124c061 vdivpd %ymm4,%ymm1,%ymm2
124c065 vmulpd %ymm2,%ymm2,%ymm3
124c069 vmulpd %ymm3,%ymm2,%ymm3
124c06d vxorpd %xmm5,%xmm5,%xmm5
124c071 vcmplepd %ymm5,%ymm4,%ymm6
124c076 vandpd 0x100(%rsp),%ymm1,%ymm7
124c07f vcmpltpd %ymm7,%ymm4,%ymm7
124c084 vorpd  %ymm6,%ymm7,%ymm6
124c088 vmovapd 0xa0(%rsp),%ymm7
124c091 vmovapd 0x4a0(%rsp),%ymm8
124c09a vfmadd213pd %ymm8,%ymm2,%ymm7
124c09f vfmadd231pd 0xe0(%rsp),%ymm3,%ymm7
124c0a9 vmulpd %ymm7,%ymm1,%ymm7
124c0ad vfmadd231pd 0x3a0(%rsp),%ymm4,%ymm7
124c0b7 vfmadd132pd 0x160(%rsp),%ymm8,%ymm2
124c0c1 vfmadd231pd 0xc0(%rsp),%ymm3,%ymm2
124c0cb vblendvpd %ymm6,%ymm1,%ymm7,%ymm3
124c0d1 vcmpnltpd %ymm5,%ymm1,%ymm1
124c0d6 vmovapd 0x300(%rsp),%ymm4
124c0df vandpd %ymm4,%ymm1,%ymm1
124c0e3 vblendvpd %ymm6,%ymm1,%ymm2,%ymm1
124c0e9 vmaxpd %ymm3,%ymm5,%ymm2
124c0ed vmaxpd %ymm1,%ymm5,%ymm1
124c0f1 vmovapd 0x60(%rsp),%ymm3
124c0f7 vandpd %ymm3,%ymm2,%ymm2
124c0fb vmulpd %ymm2,%ymm0,%ymm0
124c0ff vminpd %ymm1,%ymm4,%ymm1
124c103 vandpd %ymm3,%ymm1,%ymm1
124c107 vmulpd %ymm1,%ymm0,%ymm0
124c10b vmulpd 0x20(%rsp),%ymm0,%ymm0
124c111 vmovapd %ymm0,0x340(%rsp)
124c11a mov    0xbc35e7(%rip),%r14        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124c121 movzbl (%r14),%eax
124c125 test   %al,%al
124c127 je     124d081 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x19b1>
124c12d mov    0xbc7d44(%rip),%rax        # 1e13e78 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f48>
124c134 cmpb   $0x0,(%rax)
124c137 je     124c2a8 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xbd8>
124c13d vmovsd 0x48(%r12),%xmm0
124c144 vxorpd %xmm1,%xmm1,%xmm1
124c148 vucomisd %xmm1,%xmm0
124c14c jbe    124c2a8 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xbd8>
124c152 vbroadcastsd (%r12),%ymm0
124c158 cmpb   $0x0,0x1(%r15)
124c15d vmovsd 0x8(%r12),%xmm2
124c164 je     124c16d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa9d>
124c166 vmovsd 0x18(%r12),%xmm1
124c16d vaddsd 0x10(%r12),%xmm1,%xmm3
124c174 vbroadcastsd 0x8(%r12),%ymm1
124c17b vsubsd %xmm3,%xmm2,%xmm2
124c17f vbroadcastsd %xmm2,%ymm2
124c184 vmovapd 0x80(%rsp),%ymm3
124c18d vsubpd %ymm2,%ymm3,%ymm3
124c191 vdivpd %ymm1,%ymm3,%ymm4
124c195 vmulpd %ymm4,%ymm4,%ymm2
124c199 vmulpd %ymm2,%ymm4,%ymm5
124c19d vmovapd 0x4a0(%rsp),%ymm6
124c1a6 vmovapd 0xa0(%rsp),%ymm8
124c1af vfmadd213pd %ymm6,%ymm4,%ymm8
124c1b4 vmovapd 0xe0(%rsp),%ymm7
124c1bd vfmadd213pd %ymm8,%ymm5,%ymm7
124c1c2 vmovapd 0x160(%rsp),%ymm8
124c1cb vfmadd213pd %ymm6,%ymm8,%ymm4
124c1d0 vmovapd 0xc0(%rsp),%ymm9
124c1d9 vfmadd213pd %ymm4,%ymm5,%ymm9
124c1de vxorpd %xmm4,%xmm4,%xmm4
124c1e2 vcmplepd %ymm4,%ymm1,%ymm5
124c1e7 vandpd 0x100(%rsp),%ymm3,%ymm6
124c1f0 vcmpltpd %ymm6,%ymm1,%ymm6
124c1f5 vorpd  %ymm5,%ymm6,%ymm5
124c1f9 vmulpd %ymm7,%ymm3,%ymm6
124c1fd vmovapd 0x3a0(%rsp),%ymm7
124c206 vfmadd213pd %ymm6,%ymm1,%ymm7
124c20b vblendvpd %ymm5,%ymm3,%ymm7,%ymm6
124c211 vbroadcastsd 0x82f66e(%rip),%ymm7        # 1a7b888 <_fini+0x13b4>
124c21a vcmpnltpd %ymm4,%ymm3,%ymm3
124c21f vandpd %ymm7,%ymm3,%ymm3
124c223 vblendvpd %ymm5,%ymm3,%ymm9,%ymm3
124c229 vmaxpd %ymm3,%ymm4,%ymm3
124c22d vminpd %ymm3,%ymm7,%ymm3
124c231 vsubpd %ymm2,%ymm7,%ymm2
124c235 vmulpd %ymm2,%ymm8,%ymm2
124c239 vdivpd %ymm1,%ymm2,%ymm1
124c23d vandnpd %ymm1,%ymm5,%ymm1
124c241 vmaxpd %ymm6,%ymm4,%ymm2
124c245 vmaxpd %ymm1,%ymm4,%ymm1
124c249 vmovapd 0x60(%rsp),%ymm4
124c24f vandpd %ymm4,%ymm2,%ymm2
124c253 vandpd %ymm4,%ymm3,%ymm3
124c257 vandpd %ymm4,%ymm1,%ymm1
124c25b vmulpd %ymm1,%ymm2,%ymm1
124c25f vmulpd %ymm2,%ymm0,%ymm2
124c263 vmulpd %ymm3,%ymm2,%ymm2
124c267 vfmadd231pd %ymm3,%ymm3,%ymm1
124c26c vmulpd %ymm0,%ymm1,%ymm0
124c270 vmovapd 0x20(%rsp),%ymm1
124c276 vmulpd %ymm2,%ymm1,%ymm2
124c27a vmovapd %ymm2,0x240(%rsp)
124c283 vmulpd %ymm1,%ymm0,%ymm0
124c287 vmovapd %ymm0,0x480(%rsp)
124c290 vmovdqu 0x18(%r12),%xmm0
124c297 vpextrb $0x8,%xmm0,%ecx
124c29d movzbl 0x2(%r15),%eax
124c2a2 test   %cl,%cl
124c2a4 je     124c2d6 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc06>
124c2a6 jmp    124c303 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc33>
124c2a8 movzbl 0x20(%r12),%ecx
124c2ae vxorpd %xmm0,%xmm0,%xmm0
124c2b2 vmovapd %ymm0,0x480(%rsp)
124c2bb vmovdqa 0x340(%rsp),%ymm0
124c2c4 vmovdqa %ymm0,0x240(%rsp)
124c2cd movzbl 0x2(%r15),%eax
124c2d2 test   %cl,%cl
124c2d4 jne    124c303 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc33>
124c2d6 test   %al,%al
124c2d8 je     124c303 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc33>
124c2da vmovapd 0x360(%rsp),%ymm0
124c2e3 vxorpd 0x380(%rsp),%ymm0,%ymm4
124c2ec vxorpd 0x260(%rsp),%ymm0,%ymm6
124c2f5 vxorpd 0x280(%rsp),%ymm0,%ymm5
124c2fe jmp    124c390 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xcc0>
124c303 cmpb   $0x0,0xa8(%rbp)
124c30a je     124c329 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc59>
124c30c vmovapd 0x220(%rsp),%ymm5
124c315 vmovapd 0x200(%rsp),%ymm6
124c31e vmovapd 0x1e0(%rsp),%ymm4
124c327 jmp    124c390 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xcc0>
124c329 vmovapd 0x200(%rsp),%ymm3
124c332 vmulpd %ymm3,%ymm3,%ymm0
124c336 vmovapd 0x1e0(%rsp),%ymm4
124c33f vfmadd231pd %ymm4,%ymm4,%ymm0
124c344 vmovapd 0x220(%rsp),%ymm2
124c34d vfmadd231pd %ymm2,%ymm2,%ymm0
124c352 vsqrtpd %ymm0,%ymm0
124c356 vbroadcastsd 0x82f529(%rip),%ymm1        # 1a7b888 <_fini+0x13b4>
124c35f vdivpd %ymm0,%ymm1,%ymm1
124c363 vmulpd %ymm1,%ymm4,%ymm4
124c367 vmulpd %ymm3,%ymm1,%ymm3
124c36b vmulpd %ymm2,%ymm1,%ymm2
124c36f vbroadcastsd 0x82f958(%rip),%ymm1        # 1a7bcd0 <_fini+0x17fc>
124c378 vcmpltpd %ymm1,%ymm0,%ymm0
124c37d vtestpd %ymm0,%ymm0
124c382 jne    124d021 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1951>
124c388 vmovapd %ymm2,%ymm5
124c38c vmovapd %ymm3,%ymm6
124c390 vmulpd %ymm6,%ymm11,%ymm2
124c394 vfmadd231pd %ymm4,%ymm12,%ymm2
124c399 vfmadd231pd %ymm5,%ymm10,%ymm2
124c39e vmulpd %ymm4,%ymm2,%ymm0
124c3a2 vmulpd %ymm6,%ymm2,%ymm1
124c3a6 vmovapd %ymm2,0x160(%rsp)
124c3af vmulpd %ymm5,%ymm2,%ymm2
124c3b3 vmovapd %ymm0,0x140(%rsp)
124c3bc vsubpd %ymm0,%ymm12,%ymm3
124c3c0 vmovapd %ymm1,0x120(%rsp)
124c3c9 vsubpd %ymm1,%ymm11,%ymm1
124c3cd vmovapd %ymm2,0x3a0(%rsp)
124c3d6 vsubpd %ymm2,%ymm10,%ymm0
124c3da vmovapd %ymm1,0xc0(%rsp)
124c3e3 vmulpd %ymm1,%ymm1,%ymm1
124c3e7 vmovapd %ymm3,0xa0(%rsp)
124c3f0 vfmadd231pd %ymm3,%ymm3,%ymm1
124c3f5 vmovapd %ymm0,0xe0(%rsp)
124c3fe vfmadd231pd %ymm0,%ymm0,%ymm1
124c403 vmovapd 0x1a0(%rsp),%ymm7
124c40c vmulpd %ymm6,%ymm7,%ymm2
124c410 vmovapd 0x1c0(%rsp),%ymm3
124c419 vfmadd231pd %ymm4,%ymm3,%ymm2
124c41e vmovsd 0x18(%rsp),%xmm0
124c424 vmulsd 0x40(%r12),%xmm0,%xmm0
124c42b vmovsd %xmm0,0x60(%rsp)
124c431 vmovapd 0x180(%rsp),%ymm0
124c43a vfmadd231pd %ymm5,%ymm0,%ymm2
124c43f mov    0xbcd632(%rip),%rax        # 1e19a78 <_ZGVZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x34370>
124c446 movzbl (%rax),%eax
124c449 test   %al,%al
124c44b vmovapd %ymm5,0x220(%rsp)
124c454 vmovapd %ymm6,0x200(%rsp)
124c45d vmovapd %ymm4,0x1e0(%rsp)
124c466 je     124d10d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1a3d>
124c46c vfnmadd231pd %ymm6,%ymm2,%ymm7
124c471 vmovapd %ymm7,0x1a0(%rsp)
124c47a vfnmadd231pd %ymm4,%ymm2,%ymm3
124c47f vmovapd %ymm3,0x1c0(%rsp)
124c488 vfnmadd231pd %ymm2,%ymm5,%ymm0
124c48d vmovapd %ymm0,0x180(%rsp)
124c496 vsqrtpd %ymm1,%ymm0
124c49a vmovapd %ymm0,0x100(%rsp)
124c4a3 mov    0xbcf5a6(%rip),%rax        # 1e1ba50 <_ZZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x32390>
124c4aa vmovsd 0x82f3d6(%rip),%xmm0        # 1a7b888 <_fini+0x13b4>
124c4b2 vmovapd %xmm0,0x80(%rsp)
124c4bb cmpb   $0x0,(%rax)
124c4be je     124c5ba <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xeea>
124c4c4 mov    0xbbdd3d(%rip),%r14        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124c4cb movzbl (%r14),%eax
124c4cf test   %al,%al
124c4d1 je     124d1e1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1b11>
124c4d7 mov    0xbcd332(%rip),%r13        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124c4de vmovsd 0x0(%r13),%xmm1
124c4e4 xor    %eax,%eax
124c4e6 vxorpd %xmm0,%xmm0,%xmm0
124c4ea vucomisd %xmm0,%xmm1
124c4ee jbe    124c5be <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xeee>
124c4f4 vmovsd 0x60(%rsp),%xmm1
124c4fa vucomisd %xmm0,%xmm1
124c4fe jbe    124c5be <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xeee>
124c504 movzbl (%r14),%eax
124c508 test   %al,%al
124c50a je     124d323 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1c53>
124c510 vmovsd 0x0(%r13),%xmm0
124c516 vdivsd 0x60(%rsp),%xmm0,%xmm0
124c51c vaddsd 0x82f364(%rip),%xmm0,%xmm1        # 1a7b888 <_fini+0x13b4>
124c524 vmovapd %xmm1,0x80(%rsp)
124c52d vxorpd %xmm1,%xmm1,%xmm1
124c531 vucomisd %xmm1,%xmm0
124c535 mov    0xbc31cc(%rip),%r14        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124c53c jbe    124c5cf <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xeff>
124c542 vbroadcastsd %xmm0,%ymm0
124c547 vmovapd 0xa0(%rsp),%ymm3
124c550 vfmadd231pd 0x1c0(%rsp),%ymm0,%ymm3
124c55a vmovapd 0xc0(%rsp),%ymm2
124c563 vfmadd231pd 0x1a0(%rsp),%ymm0,%ymm2
124c56d vmovapd 0xe0(%rsp),%ymm1
124c576 vfmadd231pd 0x180(%rsp),%ymm0,%ymm1
124c580 vmovapd %ymm2,0xc0(%rsp)
124c589 vmulpd %ymm2,%ymm2,%ymm0
124c58d vmovapd %ymm3,0xa0(%rsp)
124c596 vfmadd231pd %ymm3,%ymm3,%ymm0
124c59b vmovapd %ymm1,0xe0(%rsp)
124c5a4 vfmadd231pd %ymm1,%ymm1,%ymm0
124c5a9 vsqrtpd %ymm0,%ymm0
124c5ad vmovapd %ymm0,0x100(%rsp)
124c5b6 mov    $0x1,%al
124c5b8 jmp    124c5d1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf01>
124c5ba xor    %eax,%eax
124c5bc jmp    124c5d9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf09>
124c5be movzbl 0x90(%rbp),%r13d
124c5c6 mov    0xbc313b(%rip),%r14        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124c5cd jmp    124c5d9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf09>
124c5cf xor    %eax,%eax
124c5d1 movzbl 0x90(%rbp),%r13d
124c5d9 mov    %eax,0x280(%rsp)
124c5e0 vmovsd 0x48(%r12),%xmm0
124c5e7 vxorpd %xmm1,%xmm1,%xmm1
124c5eb vucomisd %xmm1,%xmm0
124c5ef jbe    124c631 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf61>
124c5f1 movzbl (%r14),%eax
124c5f5 test   %al,%al
124c5f7 je     124d261 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1b91>
124c5fd mov    0xbc7874(%rip),%rax        # 1e13e78 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f48>
124c604 cmpb   $0x0,(%rax)
124c607 setne  %r14b
124c60b mov    0xbca7c6(%rip),%rax        # 1e16dd8 <_ZGVZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x37000>
124c612 movzbl (%rax),%eax
124c615 test   %al,%al
124c617 je     124d2a2 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1bd2>
124c61d mov    0xbbf4a4(%rip),%rax        # 1e0bac8 <_ZZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x42308>
124c624 cmpb   $0x0,(%rax)
124c627 setne  %al
124c62a test   %r14b,%r14b
124c62d je     124c63b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf6b>
124c62f jmp    124c68f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfbf>
124c631 xor    %r14d,%r14d
124c634 xor    %eax,%eax
124c636 test   %r14b,%r14b
124c639 jne    124c68f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfbf>
124c63b vxorpd %xmm0,%xmm0,%xmm0
124c63f vmovapd %ymm0,0x380(%rsp)
124c648 vmovaps 0x300(%rsp),%ymm0
124c651 vmovaps %ymm0,0x60(%rsp)
124c657 vmovapd 0x160(%rsp),%ymm0
124c660 vmovapd %ymm0,0x40(%rsp)
124c666 test   %al,%al
124c668 jne    124c68f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfbf>
124c66a test   %al,%al
124c66c jne    124c730 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1060>
124c672 vmovapd 0x300(%rsp),%ymm0
124c67b vmovapd %ymm0,0x60(%rsp)
124c681 test   %r14b,%r14b
124c684 jne    124c735 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1065>
124c68a jmp    124c771 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x10a1>
124c68f vmovsd 0x48(%r12),%xmm1
124c696 vxorpd %xmm0,%xmm0,%xmm0
124c69a vmovapd 0x340(%rsp),%ymm2
124c6a3 vcmpltpd %ymm2,%ymm0,%ymm3
124c6a8 vmovapd 0x240(%rsp),%ymm4
124c6b1 vdivpd %ymm2,%ymm4,%ymm4
124c6b5 vbroadcastsd 0x82f1ca(%rip),%ymm2        # 1a7b888 <_fini+0x13b4>
124c6be vblendvpd %ymm3,%ymm4,%ymm2,%ymm3
124c6c4 vmovsd 0x18(%rsp),%xmm4
124c6ca vdivsd %xmm1,%xmm4,%xmm4
124c6ce vbroadcastsd %xmm4,%ymm4
124c6d3 vmulpd %ymm4,%ymm3,%ymm3
124c6d7 test   %r14b,%r14b
124c6da jne    124c6ed <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x101d>
124c6dc vmovapd 0x160(%rsp),%ymm4
124c6e5 vmovapd %ymm4,0x40(%rsp)
124c6eb jmp    124c700 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1030>
124c6ed vmovapd 0x160(%rsp),%ymm4
124c6f6 vminpd %ymm3,%ymm4,%ymm5
124c6fa vmovapd %ymm5,0x40(%rsp)
124c700 vcmpltpd %ymm3,%ymm4,%ymm3
124c705 vmovapd %ymm3,0x380(%rsp)
124c70e vdivsd 0x18(%rsp),%xmm1,%xmm1
124c714 vbroadcastsd %xmm1,%ymm1
124c719 vfnmadd213pd %ymm2,%ymm4,%ymm1
124c71e vmaxpd %ymm1,%ymm0,%ymm0
124c722 vmovapd %ymm0,0x60(%rsp)
124c728 test   %al,%al
124c72a je     124c672 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfa2>
124c730 test   %r14b,%r14b
124c733 je     124c771 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x10a1>
124c735 vmovapd 0x40(%rsp),%ymm1
124c73b vmulpd 0x1e0(%rsp),%ymm1,%ymm0
124c744 vmovapd %ymm0,0x140(%rsp)
124c74d vmulpd 0x200(%rsp),%ymm1,%ymm0
124c756 vmovapd %ymm0,0x120(%rsp)
124c75f vmulpd 0x220(%rsp),%ymm1,%ymm0
124c768 vmovapd %ymm0,0x3a0(%rsp)
124c771 vmovapd 0x60(%rsp),%ymm0
124c777 vmulpd 0x340(%rsp),%ymm0,%ymm0
124c780 vmovapd %ymm0,0x300(%rsp)
124c789 vmovsd 0x38(%r12),%xmm1
124c790 vxorpd %xmm0,%xmm0,%xmm0
124c794 vmovapd %xmm1,0x260(%rsp)
124c79d vucomisd %xmm0,%xmm1
124c7a1 jbe    124c8c1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x11f1>
124c7a7 mov    0xbbda5a(%rip),%rax        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124c7ae movzbl (%rax),%eax
124c7b1 test   %al,%al
124c7b3 je     124d2e3 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1c13>
124c7b9 mov    0xbcd050(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124c7c0 vmovsd (%rax),%xmm0
124c7c4 vmovsd 0x18(%rsp),%xmm1
124c7ca vmulsd 0x40(%r12),%xmm1,%xmm1
124c7d1 vxorpd %xmm2,%xmm2,%xmm2
124c7d5 vcmpltsd %xmm0,%xmm2,%xmm2
124c7da vblendvpd %xmm2,%xmm0,%xmm1,%xmm0
124c7e0 vbroadcastsd %xmm0,%ymm2
124c7e5 mov    0x8(%r15),%eax
124c7e9 test   %eax,%eax
124c7eb je     124c8f2 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1222>
124c7f1 vxorpd %xmm0,%xmm0,%xmm0
124c7f5 vxorpd %xmm1,%xmm1,%xmm1
124c7f9 vmovapd %ymm1,0x240(%rsp)
124c802 cmp    $0x1,%eax
124c805 mov    0x280(%rsp),%eax
124c80c jne    124c86e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x119e>
124c80e vbroadcastsd 0x82f0c1(%rip),%ymm0        # 1a7b8d8 <_fini+0x1404>
124c817 vmaxpd %ymm0,%ymm2,%ymm2
124c81b vmulpd %ymm2,%ymm2,%ymm0
124c81f vbroadcastsd 0x82f1c0(%rip),%ymm1        # 1a7b9e8 <_fini+0x1514>
124c828 vmulpd %ymm1,%ymm0,%ymm3
124c82c vmovapd 0x100(%rsp),%ymm0
124c835 vfmadd213pd %ymm3,%ymm0,%ymm0
124c83a vsqrtpd %ymm0,%ymm4
124c83e vbroadcastsd 0x82f041(%rip),%ymm0        # 1a7b888 <_fini+0x13b4>
124c847 vdivpd %ymm4,%ymm0,%ymm0
124c84b vbroadcastsd 0x82f06c(%rip),%ymm1        # 1a7b8c0 <_fini+0x13ec>
124c854 vfmadd213pd %ymm4,%ymm2,%ymm1
124c859 vmulpd %ymm0,%ymm0,%ymm2
124c85d vmulpd %ymm2,%ymm0,%ymm2
124c861 vmulpd %ymm2,%ymm3,%ymm2
124c865 vmovapd %ymm2,0x240(%rsp)
124c86e test   %r13b,%r13b
124c871 je     124c985 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12b5>
124c877 vbroadcastsd 0x260(%rsp),%ymm2
124c881 vmulpd %ymm1,%ymm2,%ymm1
124c885 vmulpd 0x60(%rsp),%ymm1,%ymm2
124c88b test   %al,%al
124c88d je     124c8a9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x11d9>
124c88f vmovsd 0x82eff1(%rip),%xmm1        # 1a7b888 <_fini+0x13b4>
124c897 vdivsd 0x80(%rsp),%xmm1,%xmm1
124c8a0 vbroadcastsd %xmm1,%ymm1
124c8a5 vmulpd %ymm2,%ymm1,%ymm2
124c8a9 vmovapd %ymm2,0x20(%rsp)
124c8af cmpb   $0x0,0x98(%rbp)
124c8b6 je     124c98e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12be>
124c8bc jmp    124c99b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12cb>
124c8c1 vxorpd %xmm0,%xmm0,%xmm0
124c8c5 vmovapd %ymm0,0x20(%rsp)
124c8cb vxorps %xmm0,%xmm0,%xmm0
124c8cf vmovaps %ymm0,0x80(%rsp)
124c8d8 vmovsd 0x30(%r12),%xmm0
124c8df vucomisd 0x82f001(%rip),%xmm0        # 1a7b8e8 <_fini+0x1414>
124c8e7 jbe    124cacb <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x13fb>
124c8ed jmp    124ca51 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1381>
124c8f2 vmovapd 0x100(%rsp),%ymm8
124c8fb vdivpd %ymm2,%ymm8,%ymm0
124c8ff vcmplepd %ymm8,%ymm2,%ymm3
124c905 vbroadcastsd 0x82f0aa(%rip),%ymm1        # 1a7b9b8 <_fini+0x14e4>
124c90e vmovapd %ymm1,%ymm4
124c912 vfnmadd213pd %ymm8,%ymm2,%ymm4
124c917 vmulpd %ymm0,%ymm8,%ymm5
124c91b vbroadcastsd 0x82ef64(%rip),%ymm6        # 1a7b888 <_fini+0x13b4>
124c924 vfnmadd213pd %ymm6,%ymm0,%ymm1
124c929 vmulpd %ymm1,%ymm5,%ymm1
124c92d vblendvpd %ymm3,%ymm4,%ymm1,%ymm1
124c933 vxorpd %xmm4,%xmm4,%xmm4
124c937 vsubpd %ymm0,%ymm6,%ymm5
124c93b vbroadcastsd 0x82f004(%rip),%ymm7        # 1a7b948 <_fini+0x1474>
124c944 vaddpd %ymm5,%ymm5,%ymm5
124c948 vdivpd %ymm2,%ymm5,%ymm5
124c94c vandnpd %ymm5,%ymm3,%ymm5
124c950 vmovapd %ymm5,0x240(%rsp)
124c959 vdivpd %ymm8,%ymm6,%ymm5
124c95e vsubpd %ymm0,%ymm7,%ymm0
124c962 vdivpd %ymm2,%ymm0,%ymm0
124c966 vcmpneqpd %ymm4,%ymm8,%ymm2
124c96b vandpd %ymm5,%ymm2,%ymm2
124c96f vblendvpd %ymm3,%ymm2,%ymm0,%ymm0
124c975 mov    0x280(%rsp),%eax
124c97c test   %r13b,%r13b
124c97f jne    124c877 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x11a7>
124c985 cmpb   $0x0,0x98(%rbp)
124c98c jne    124c99b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12cb>
124c98e cmpb   $0x0,0xa0(%rbp)
124c995 je     124ca40 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1370>
124c99b vbroadcastsd 0x260(%rsp),%ymm1
124c9a5 vmulpd 0x300(%rsp),%ymm1,%ymm1
124c9ae vmovapd %ymm1,0x260(%rsp)
124c9b7 vmulpd %ymm0,%ymm1,%ymm0
124c9bb cmpb   $0x0,0x98(%rbp)
124c9c2 je     124ca18 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1348>
124c9c4 vmovapd 0x2a0(%rsp),%ymm1
124c9cd vfnmadd231pd 0xa0(%rsp),%ymm0,%ymm1
124c9d7 vmovapd %ymm1,0x2a0(%rsp)
124c9e0 vmovapd 0x2c0(%rsp),%ymm1
124c9e9 vfnmadd231pd 0xc0(%rsp),%ymm0,%ymm1
124c9f3 vmovapd %ymm1,0x2c0(%rsp)
124c9fc vmovapd 0x2e0(%rsp),%ymm1
124ca05 vfnmadd231pd 0xe0(%rsp),%ymm0,%ymm1
124ca0f vmovapd %ymm1,0x2e0(%rsp)
124ca18 cmpb   $0x0,0xa0(%rbp)
124ca1f je     124ca40 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1370>
124ca21 vxorpd 0x360(%rsp),%ymm0,%ymm0
124ca2a test   %al,%al
124ca2c jne    124cf1c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x184c>
124ca32 vbroadcastsd 0x82ee4d(%rip),%ymm1        # 1a7b888 <_fini+0x13b4>
124ca3b jmp    124cf26 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1856>
124ca40 vmovsd 0x30(%r12),%xmm0
124ca47 vucomisd 0x82ee99(%rip),%xmm0        # 1a7b8e8 <_fini+0x1414>
124ca4f jbe    124cacb <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x13fb>
124ca51 vdivsd 0x18(%rsp),%xmm0,%xmm0
124ca57 test   %r13b,%r13b
124ca5a je     124cab1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x13e1>
124ca5c vmovapd 0x1a0(%rsp),%ymm1
124ca65 vmulpd %ymm1,%ymm1,%ymm1
124ca69 vmovapd 0x1c0(%rsp),%ymm2
124ca72 vfmadd231pd %ymm2,%ymm2,%ymm1
124ca77 vmovapd 0x180(%rsp),%ymm2
124ca80 vfmadd231pd %ymm2,%ymm2,%ymm1
124ca85 vsqrtpd %ymm1,%ymm1
124ca89 vmulsd 0x82ee27(%rip),%xmm0,%xmm2        # 1a7b8b8 <_fini+0x13e4>
124ca91 vmulpd %ymm1,%ymm1,%ymm1
124ca95 vbroadcastsd %xmm2,%ymm2
124ca9a vmulpd %ymm2,%ymm1,%ymm1
124ca9e vmovapd 0x20(%rsp),%ymm2
124caa4 vfmadd231pd 0x60(%rsp),%ymm1,%ymm2
124caab vmovapd %ymm2,0x20(%rsp)
124cab1 cmpb   $0x0,0x98(%rbp)
124cab8 jne    124cc06 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1536>
124cabe cmpb   $0x0,0xa0(%rbp)
124cac5 jne    124cc06 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1536>
124cacb vmovsd 0x48(%r12),%xmm1
124cad2 vxorpd %xmm0,%xmm0,%xmm0
124cad6 vucomisd %xmm0,%xmm1
124cada jbe    124cbf0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1520>
124cae0 vdivsd 0x18(%rsp),%xmm1,%xmm0
124cae6 test   %r13b,%r13b
124cae9 je     124cb33 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1463>
124caeb test   %r14b,%r14b
124caee je     124cedf <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x180f>
124caf4 vmovapd 0x40(%rsp),%ymm3
124cafa vmulpd %ymm3,%ymm3,%ymm1
124cafe vmovapd 0x160(%rsp),%ymm2
124cb07 vsubpd %ymm3,%ymm2,%ymm2
124cb0b vmulpd %ymm2,%ymm3,%ymm2
124cb0f vmovapd 0x4a0(%rsp),%ymm3
124cb18 vfmadd213pd %ymm2,%ymm1,%ymm3
124cb1d vbroadcastsd %xmm0,%ymm1
124cb22 vmovapd 0x20(%rsp),%ymm2
124cb28 vfmadd231pd %ymm1,%ymm3,%ymm2
124cb2d vmovapd %ymm2,0x20(%rsp)
124cb33 cmpb   $0x0,0x98(%rbp)
124cb3a jne    124cb49 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1479>
124cb3c cmpb   $0x0,0xa0(%rbp)
124cb43 je     124cea5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17d5>
124cb49 vbroadcastsd %xmm0,%ymm0
124cb4e vmulpd 0x340(%rsp),%ymm0,%ymm0
124cb57 cmpb   $0x0,0x98(%rbp)
124cb5e je     124cbb4 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x14e4>
124cb60 vmovapd 0x2a0(%rsp),%ymm1
124cb69 vfnmadd231pd 0x140(%rsp),%ymm0,%ymm1
124cb73 vmovapd %ymm1,0x2a0(%rsp)
124cb7c vmovapd 0x2c0(%rsp),%ymm1
124cb85 vfnmadd231pd 0x120(%rsp),%ymm0,%ymm1
124cb8f vmovapd %ymm1,0x2c0(%rsp)
124cb98 vmovapd 0x2e0(%rsp),%ymm1
124cba1 vfnmadd231pd 0x3a0(%rsp),%ymm0,%ymm1
124cbab vmovapd %ymm1,0x2e0(%rsp)
124cbb4 cmpb   $0x0,0xa0(%rbp)
124cbbb je     124cea5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17d5>
124cbc1 vxorpd 0x360(%rsp),%ymm0,%ymm0
124cbca test   %r14b,%r14b
124cbcd je     124ccad <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x15dd>
124cbd3 vmovapd 0x480(%rsp),%ymm1
124cbdc vmovapd 0x380(%rsp),%ymm2
124cbe5 vblendvpd %ymm2,%ymm0,%ymm1,%ymm0
124cbeb jmp    124ccad <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x15dd>
124cbf0 vxorpd %xmm0,%xmm0,%xmm0
124cbf4 cmpb   $0x0,0xa0(%rbp)
124cbfb jne    124ccad <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x15dd>
124cc01 jmp    124cea5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17d5>
124cc06 vbroadcastsd %xmm0,%ymm0
124cc0b vmulpd 0x300(%rsp),%ymm0,%ymm0
124cc14 cmpb   $0x0,0x98(%rbp)
124cc1b je     124cc71 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x15a1>
124cc1d vmovapd 0x2a0(%rsp),%ymm1
124cc26 vfnmadd231pd 0x1c0(%rsp),%ymm0,%ymm1
124cc30 vmovapd %ymm1,0x2a0(%rsp)
124cc39 vmovapd 0x2c0(%rsp),%ymm1
124cc42 vfnmadd231pd 0x1a0(%rsp),%ymm0,%ymm1
124cc4c vmovapd %ymm1,0x2c0(%rsp)
124cc55 vmovapd 0x2e0(%rsp),%ymm1
124cc5e vfnmadd231pd 0x180(%rsp),%ymm0,%ymm1
124cc68 vmovapd %ymm1,0x2e0(%rsp)
124cc71 cmpb   $0x0,0xa0(%rbp)
124cc78 je     124ce90 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17c0>
124cc7e vmovapd 0x80(%rsp),%ymm1
124cc87 vsubpd %ymm0,%ymm1,%ymm1
124cc8b vmovapd %ymm1,0x80(%rsp)
124cc94 vmovsd 0x48(%r12),%xmm1
124cc9b vxorpd %xmm0,%xmm0,%xmm0
124cc9f vxorpd %xmm2,%xmm2,%xmm2
124cca3 vucomisd %xmm2,%xmm1
124cca7 ja     124cae0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1410>
124ccad vmovapd 0x80(%rsp),%ymm7
124ccb6 vsubpd %ymm7,%ymm0,%ymm0
124ccba vmovapd 0x1e0(%rsp),%ymm4
124ccc3 vmulpd %ymm4,%ymm0,%ymm1
124ccc7 vmovapd 0x200(%rsp),%ymm6
124ccd0 vmulpd %ymm6,%ymm0,%ymm2
124ccd4 vmovapd 0x220(%rsp),%ymm5
124ccdd vmulpd %ymm5,%ymm0,%ymm0
124cce1 vfmadd213pd %ymm7,%ymm1,%ymm4
124cce6 vmovapd 0x3c0(%rsp),%ymm3
124ccef vaddpd %ymm4,%ymm3,%ymm3
124ccf3 vmovapd %ymm3,0x3c0(%rsp)
124ccfc vmovapd %ymm6,%ymm3
124cd00 vfmadd213pd %ymm7,%ymm2,%ymm3
124cd05 vmovapd 0x3e0(%rsp),%ymm4
124cd0e vaddpd %ymm3,%ymm4,%ymm4
124cd12 vmovapd %ymm4,0x3e0(%rsp)
124cd1b vfmadd213pd %ymm7,%ymm5,%ymm0
124cd20 vmovapd 0x460(%rsp),%ymm3
124cd29 vaddpd %ymm0,%ymm3,%ymm3
124cd2d vmovapd %ymm3,0x460(%rsp)
124cd36 vmovapd 0x400(%rsp),%ymm0
124cd3f vfmadd231pd %ymm6,%ymm1,%ymm0
124cd44 vmovapd %ymm0,0x400(%rsp)
124cd4d vmovapd 0x440(%rsp),%ymm0
124cd56 vfmadd231pd %ymm1,%ymm5,%ymm0
124cd5b vmovapd %ymm0,0x440(%rsp)
124cd64 vmovapd 0x420(%rsp),%ymm0
124cd6d vfmadd231pd %ymm5,%ymm2,%ymm0
124cd72 vmovapd %ymm0,0x420(%rsp)
124cd7b cmpb   $0x0,0x6(%r15)
124cd80 je     124cdbf <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x16ef>
124cd82 mov    0xbbd47f(%rip),%rax        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124cd89 movzbl (%rax),%eax
124cd8c test   %al,%al
124cd8e je     124d35e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1c8e>
124cd94 mov    0xbcca75(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124cd9b vmovsd (%rax),%xmm1
124cd9f vxorpd %xmm0,%xmm0,%xmm0
124cda3 vucomisd %xmm0,%xmm1
124cda7 jbe    124cea5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17d5>
124cdad vmovsd 0x38(%r12),%xmm1
124cdb4 vucomisd %xmm0,%xmm1
124cdb8 ja     124cdd4 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1704>
124cdba jmp    124cea5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17d5>
124cdbf vmovsd 0x38(%r12),%xmm0
124cdc6 vxorpd %xmm1,%xmm1,%xmm1
124cdca vucomisd %xmm1,%xmm0
124cdce jbe    124cea5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17d5>
124cdd4 vmovapd 0xa0(%rsp),%ymm5
124cddd vmovapd 0xc0(%rsp),%ymm2
124cde6 vmulpd %ymm2,%ymm5,%ymm0
124cdea vmovapd 0x100(%rsp),%ymm4
124cdf3 vmulpd %ymm2,%ymm4,%ymm1
124cdf7 vmovapd 0xe0(%rsp),%ymm6
124ce00 vmulpd %ymm2,%ymm6,%ymm2
124ce04 vmovapd 0x3c0(%rsp),%ymm3
124ce0d vfmadd231pd %ymm5,%ymm0,%ymm3
124ce12 vmovapd %ymm3,0x3c0(%rsp)
124ce1b vmovapd 0x3e0(%rsp),%ymm3
124ce24 vfmadd231pd %ymm1,%ymm4,%ymm3
124ce29 vmovapd %ymm3,0x3e0(%rsp)
124ce32 vmovapd 0x460(%rsp),%ymm3
124ce3b vfmadd231pd %ymm2,%ymm6,%ymm3
124ce40 vmovapd %ymm3,0x460(%rsp)
124ce49 vmovapd 0x400(%rsp),%ymm2
124ce52 vfmadd231pd %ymm4,%ymm0,%ymm2
124ce57 vmovapd %ymm2,0x400(%rsp)
124ce60 vmovapd 0x440(%rsp),%ymm2
124ce69 vfmadd231pd %ymm0,%ymm6,%ymm2
124ce6e vmovapd %ymm2,0x440(%rsp)
124ce77 vmovapd 0x420(%rsp),%ymm0
124ce80 vfmadd231pd %ymm1,%ymm6,%ymm0
124ce85 vmovapd %ymm0,0x420(%rsp)
124ce8e jmp    124cea5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17d5>
124ce90 vmovsd 0x48(%r12),%xmm1
124ce97 vxorpd %xmm0,%xmm0,%xmm0
124ce9b vucomisd %xmm0,%xmm1
124ce9f ja     124cae0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1410>
124cea5 test   %r13b,%r13b
124cea8 vmovapd 0x20(%rsp),%ymm0
124ceae jne    124cebb <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17eb>
124ceb0 vbroadcastsd 0x82e9c7(%rip),%ymm0        # 1a7b880 <_fini+0x13ac>
124ceb9 jmp    124cec4 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17f4>
124cebb vmulpd 0x340(%rsp),%ymm0,%ymm0
124cec4 vmovapd 0x4c0(%rsp),%ymm1
124cecd vaddpd %ymm0,%ymm1,%ymm0
124ced1 test   %r13b,%r13b
124ced4 jne    124bbc3 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4f3>
124ceda jmp    124bbcf <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4ff>
124cedf vmulsd 0x82e9d1(%rip),%xmm0,%xmm1        # 1a7b8b8 <_fini+0x13e4>
124cee7 vmovapd 0x160(%rsp),%ymm2
124cef0 vmulpd %ymm2,%ymm2,%ymm2
124cef4 vbroadcastsd %xmm1,%ymm1
124cef9 vmovapd 0x20(%rsp),%ymm3
124ceff vfmadd231pd %ymm1,%ymm2,%ymm3
124cf04 vmovapd %ymm3,0x20(%rsp)
124cf0a cmpb   $0x0,0x98(%rbp)
124cf11 je     124cb3c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x146c>
124cf17 jmp    124cb49 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1479>
124cf1c vbroadcastsd 0x80(%rsp),%ymm1
124cf26 vmovapd %ymm1,0x280(%rsp)
124cf2f vmulpd %ymm0,%ymm1,%ymm0
124cf33 vmovapd %ymm0,0x80(%rsp)
124cf3c cmpb   $0x0,0x6(%r15)
124cf41 je     124cf6e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x189e>
124cf43 mov    0xbbd2be(%rip),%rax        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124cf4a movzbl (%rax),%eax
124cf4d test   %al,%al
124cf4f je     124d39e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1cce>
124cf55 mov    0xbcc8b4(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124cf5c vmovsd (%rax),%xmm0
124cf60 vxorpd %xmm1,%xmm1,%xmm1
124cf64 vucomisd %xmm1,%xmm0
124cf68 jbe    124ca40 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1370>
124cf6e vbroadcastsd 0x82ed61(%rip),%ymm0        # 1a7bcd8 <_fini+0x1804>
124cf77 vmovapd 0x260(%rsp),%ymm1
124cf80 vmulpd 0x240(%rsp),%ymm1,%ymm1
124cf89 vbroadcastsd 0x82e936(%rip),%ymm2        # 1a7b8c8 <_fini+0x13f4>
124cf92 vmovapd 0x100(%rsp),%ymm3
124cf9b vcmpltpd %ymm3,%ymm0,%ymm0
124cfa0 vaddpd %ymm2,%ymm3,%ymm2
124cfa4 vbroadcastsd 0x82e8db(%rip),%ymm3        # 1a7b888 <_fini+0x13b4>
124cfad vdivpd %ymm2,%ymm3,%ymm2
124cfb1 vmulpd 0xa0(%rsp),%ymm2,%ymm3
124cfba vmovapd %ymm3,0xa0(%rsp)
124cfc3 vmulpd 0xc0(%rsp),%ymm2,%ymm3
124cfcc vmovapd %ymm3,0x100(%rsp)
124cfd5 vmulpd 0xe0(%rsp),%ymm2,%ymm2
124cfde vmovapd %ymm2,0xe0(%rsp)
124cfe7 vmovapd 0x280(%rsp),%ymm2
124cff0 vfnmsub213pd 0x80(%rsp),%ymm2,%ymm1
124cffa vandpd %ymm1,%ymm0,%ymm0
124cffe vmovapd %ymm0,0xc0(%rsp)
124d007 vmovsd 0x30(%r12),%xmm0
124d00e vucomisd 0x82e8d2(%rip),%xmm0        # 1a7b8e8 <_fini+0x1414>
124d016 jbe    124cacb <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x13fb>
124d01c jmp    124ca51 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1381>
124d021 test   %al,%al
124d023 je     124d068 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1998>
124d025 vmovapd 0x360(%rsp),%ymm5
124d02e vxorpd 0x380(%rsp),%ymm5,%ymm1
124d037 vblendvpd %ymm0,%ymm1,%ymm4,%ymm4
124d03d vxorpd 0x260(%rsp),%ymm5,%ymm1
124d046 vmovapd %ymm3,%ymm6
124d04a vblendvpd %ymm0,%ymm1,%ymm3,%ymm6
124d050 vxorpd 0x280(%rsp),%ymm5,%ymm1
124d059 vmovapd %ymm2,%ymm5
124d05d vblendvpd %ymm0,%ymm1,%ymm2,%ymm5
124d063 jmp    124c390 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xcc0>
124d068 vandnpd %ymm4,%ymm0,%ymm4
124d06c vmovapd %ymm3,%ymm6
124d070 vandnpd %ymm3,%ymm0,%ymm6
124d074 vmovapd %ymm2,%ymm5
124d078 vandnpd %ymm2,%ymm0,%ymm5
124d07c jmp    124c390 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xcc0>
124d081 mov    0xbc2680(%rip),%rdi        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124d088 vmovapd %ymm10,0x40(%rsp)
124d08e vmovapd %ymm11,0x140(%rsp)
124d097 vmovapd %ymm12,0x120(%rsp)
124d0a0 vzeroupper
124d0a3 call   7b7240 <__cxa_guard_acquire@plt>
124d0a8 vmovapd 0x120(%rsp),%ymm12
124d0b1 vmovapd 0x140(%rsp),%ymm11
124d0ba vmovapd 0x40(%rsp),%ymm10
124d0c0 test   %eax,%eax
124d0c2 je     124c12d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa5d>
124d0c8 lea    0x84a74a(%rip),%rdi        # 1a97819 <_fini+0x1d345>
124d0cf vzeroupper
124d0d2 call   7c87b0 <getenv@plt>
124d0d7 test   %rax,%rax
124d0da mov    0xbc6d97(%rip),%rax        # 1e13e78 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f48>
124d0e1 setne  (%rax)
124d0e4 mov    0xbc261d(%rip),%rdi        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124d0eb call   7bef10 <__cxa_guard_release@plt>
124d0f0 vmovapd 0x120(%rsp),%ymm12
124d0f9 vmovapd 0x140(%rsp),%ymm11
124d102 vmovapd 0x40(%rsp),%ymm10
124d108 jmp    124c12d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa5d>
124d10d mov    0xbcc964(%rip),%rdi        # 1e19a78 <_ZGVZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x34370>
124d114 vmovapd %ymm1,0x20(%rsp)
124d11a vmovapd %ymm2,0x40(%rsp)
124d120 vzeroupper
124d123 call   7b7240 <__cxa_guard_acquire@plt>
124d128 vmovapd 0x180(%rsp),%ymm0
124d131 vmovapd 0x1a0(%rsp),%ymm7
124d13a vmovapd 0x1c0(%rsp),%ymm3
124d143 vmovapd 0x40(%rsp),%ymm2
124d149 vmovapd 0x20(%rsp),%ymm1
124d14f vmovapd 0x200(%rsp),%ymm6
124d158 vmovapd 0x220(%rsp),%ymm5
124d161 vmovapd 0x1e0(%rsp),%ymm4
124d16a test   %eax,%eax
124d16c je     124c46c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd9c>
124d172 lea    0x84a6da(%rip),%rdi        # 1a97853 <_fini+0x1d37f>
124d179 vzeroupper
124d17c call   7c87b0 <getenv@plt>
124d181 test   %rax,%rax
124d184 mov    0xbce8c5(%rip),%rax        # 1e1ba50 <_ZZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x32390>
124d18b setne  (%rax)
124d18e mov    0xbcc8e3(%rip),%rdi        # 1e19a78 <_ZGVZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x34370>
124d195 call   7bef10 <__cxa_guard_release@plt>
124d19a vmovapd 0x180(%rsp),%ymm0
124d1a3 vmovapd 0x1a0(%rsp),%ymm7
124d1ac vmovapd 0x1c0(%rsp),%ymm3
124d1b5 vmovapd 0x40(%rsp),%ymm2
124d1bb vmovapd 0x20(%rsp),%ymm1
124d1c1 vmovapd 0x200(%rsp),%ymm6
124d1ca vmovapd 0x220(%rsp),%ymm5
124d1d3 vmovapd 0x1e0(%rsp),%ymm4
124d1dc jmp    124c46c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd9c>
124d1e1 mov    0xbbd020(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d1e8 vzeroupper
124d1eb call   7b7240 <__cxa_guard_acquire@plt>
124d1f0 test   %eax,%eax
124d1f2 je     124c4d7 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe07>
124d1f8 lea    0x53b(%rsp),%rdi
124d200 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124d205 mov    0xbcc604(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124d20c vmovsd %xmm0,(%rax)
124d210 mov    0xbbcff1(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d217 call   7bef10 <__cxa_guard_release@plt>
124d21c jmp    124c4d7 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe07>
124d221 mov    0xbbcfe0(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d228 vzeroupper
124d22b call   7b7240 <__cxa_guard_acquire@plt>
124d230 test   %eax,%eax
124d232 je     124bd67 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x697>
124d238 lea    0x53a(%rsp),%rdi
124d240 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124d245 mov    0xbcc5c4(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124d24c vmovsd %xmm0,(%rax)
124d250 mov    0xbbcfb1(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d257 call   7bef10 <__cxa_guard_release@plt>
124d25c jmp    124bd67 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x697>
124d261 mov    0xbc24a0(%rip),%rdi        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124d268 vzeroupper
124d26b call   7b7240 <__cxa_guard_acquire@plt>
124d270 test   %eax,%eax
124d272 je     124c5fd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf2d>
124d278 lea    0x84a59a(%rip),%rdi        # 1a97819 <_fini+0x1d345>
124d27f call   7c87b0 <getenv@plt>
124d284 test   %rax,%rax
124d287 mov    0xbc6bea(%rip),%rax        # 1e13e78 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f48>
124d28e setne  (%rax)
124d291 mov    0xbc2470(%rip),%rdi        # 1e0f708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124d298 call   7bef10 <__cxa_guard_release@plt>
124d29d jmp    124c5fd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf2d>
124d2a2 mov    0xbc9b2f(%rip),%rdi        # 1e16dd8 <_ZGVZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x37000>
124d2a9 vzeroupper
124d2ac call   7b7240 <__cxa_guard_acquire@plt>
124d2b1 test   %eax,%eax
124d2b3 je     124c61d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf4d>
124d2b9 lea    0x84a575(%rip),%rdi        # 1a97835 <_fini+0x1d361>
124d2c0 call   7c87b0 <getenv@plt>
124d2c5 test   %rax,%rax
124d2c8 mov    0xbbe7f9(%rip),%rax        # 1e0bac8 <_ZZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x42308>
124d2cf setne  (%rax)
124d2d2 mov    0xbc9aff(%rip),%rdi        # 1e16dd8 <_ZGVZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x37000>
124d2d9 call   7bef10 <__cxa_guard_release@plt>
124d2de jmp    124c61d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf4d>
124d2e3 mov    0xbbcf1e(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d2ea vzeroupper
124d2ed call   7b7240 <__cxa_guard_acquire@plt>
124d2f2 test   %eax,%eax
124d2f4 je     124c7b9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x10e9>
124d2fa lea    0x53d(%rsp),%rdi
124d302 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124d307 mov    0xbcc502(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124d30e vmovsd %xmm0,(%rax)
124d312 mov    0xbbceef(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d319 call   7bef10 <__cxa_guard_release@plt>
124d31e jmp    124c7b9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x10e9>
124d323 mov    0xbbcede(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d32a vzeroupper
124d32d call   7b7240 <__cxa_guard_acquire@plt>
124d332 test   %eax,%eax
124d334 je     124c510 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe40>
124d33a lea    0x53c(%rsp),%rdi
124d342 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124d347 vmovsd %xmm0,0x0(%r13)
124d34d mov    0xbbceb4(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d354 call   7bef10 <__cxa_guard_release@plt>
124d359 jmp    124c510 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe40>
124d35e mov    0xbbcea3(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d365 vzeroupper
124d368 call   7b7240 <__cxa_guard_acquire@plt>
124d36d test   %eax,%eax
124d36f je     124cd94 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x16c4>
124d375 lea    0x53f(%rsp),%rdi
124d37d call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124d382 mov    0xbcc487(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124d389 vmovsd %xmm0,(%rax)
124d38d mov    0xbbce74(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d394 call   7bef10 <__cxa_guard_release@plt>
124d399 jmp    124cd94 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x16c4>
124d39e mov    0xbbce63(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d3a5 vzeroupper
124d3a8 call   7b7240 <__cxa_guard_acquire@plt>
124d3ad test   %eax,%eax
124d3af je     124cf55 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1885>
124d3b5 lea    0x53e(%rsp),%rdi
124d3bd call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124d3c2 mov    0xbcc447(%rip),%rax        # 1e19810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124d3c9 vmovsd %xmm0,(%rax)
124d3cd mov    0xbbce34(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d3d4 call   7bef10 <__cxa_guard_release@plt>
124d3d9 jmp    124cf55 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1885>
124d3de jmp    124d3e8 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d18>
124d3e0 jmp    124d3e8 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d18>
124d3e2 jmp    124d3e8 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d18>
124d3e4 jmp    124d3e8 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d18>
124d3e6 jmp    124d3e8 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d18>
124d3e8 mov    %rax,%rbx
124d3eb mov    0xbbce16(%rip),%rdi        # 1e0a208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124d3f2 call   7b9b70 <__cxa_guard_abort@plt>
124d3f7 mov    %fs:0x28,%rax
124d400 cmp    0x540(%rsp),%rax
124d408 jne    124d412 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1d42>
124d40a mov    %rbx,%rdi
124d40d call   7c3330 <_Unwind_Resume@plt>
124d412 vzeroupper
124d415 call   7b4ef0 <__stack_chk_fail@plt>

Disassembly of section .fini:
