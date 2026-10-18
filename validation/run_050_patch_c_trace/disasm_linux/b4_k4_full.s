
lib/b4/libmochi_physics_double.so:     file format elf64-x86-64


Disassembly of section .init:

Disassembly of section .plt:

Disassembly of section .plt.got:

Disassembly of section .text:

000000000124ac70 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_>:
124ac70 push   %rbp
124ac71 mov    %rsp,%rbp
124ac74 push   %r15
124ac76 push   %r14
124ac78 push   %r13
124ac7a push   %r12
124ac7c push   %rbx
124ac7d and    $0xffffffffffffffe0,%rsp
124ac81 sub    $0x560,%rsp
124ac88 vmovsd %xmm0,0x18(%rsp)
124ac8e mov    %r8,%rbx
124ac91 mov    %rdx,0x298(%rsp)
124ac99 mov    %rdi,0x290(%rsp)
124aca1 mov    0x88(%rbp),%r15
124aca8 mov    %fs:0x28,%rax
124acb1 mov    %rax,0x540(%rsp)
124acb9 mov    0x20(%rbp),%rax
124acbd vmovupd (%rax),%ymm0
124acc1 vmovupd 0x20(%rax),%ymm1
124acc6 vmovupd 0x40(%rax),%ymm2
124accb vblendpd $0x4,%ymm1,%ymm0,%ymm3
124acd1 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124acd7 vblendpd $0xa,%ymm4,%ymm3,%ymm9
124acdd vblendpd $0x2,%ymm0,%ymm1,%ymm0
124ace3 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124ace9 vshufpd $0x5,%ymm1,%ymm0,%ymm2
124acee cmpb   $0x0,0x3(%r15)
124acf3 vblendpd $0xa,%ymm1,%ymm4,%ymm0
124acf9 vmovapd %ymm0,0x20(%rsp)
124acff vmovapd %ymm2,0xc0(%rsp)
124ad08 vmovapd %ymm2,0x260(%rsp)
124ad11 vmovapd %ymm9,0x240(%rsp)
124ad1a je     124ad6c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfc>
124ad1c lea    0x40(%rbp),%rax
124ad20 mov    (%rax),%rax
124ad23 vmovupd (%rax),%ymm0
124ad27 vmovupd 0x20(%rax),%ymm1
124ad2c vmovupd 0x40(%rax),%ymm2
124ad31 vblendpd $0x4,%ymm1,%ymm0,%ymm3
124ad37 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124ad3d vblendpd $0xa,%ymm4,%ymm3,%ymm3
124ad43 vmovapd %ymm3,0x240(%rsp)
124ad4c vblendpd $0x2,%ymm0,%ymm1,%ymm0
124ad52 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124ad58 vshufpd $0x5,%ymm1,%ymm0,%ymm0
124ad5d vmovapd %ymm0,0x260(%rsp)
124ad66 vblendpd $0xa,%ymm1,%ymm4,%ymm0
124ad6c vmovapd %ymm0,0x100(%rsp)
124ad75 mov    0x80(%rbp),%r12
124ad7c movzbl 0x2(%r15),%eax
124ad81 test   %al,%al
124ad83 je     124adfd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x18d>
124ad85 lea    0x50(%rbp),%rcx
124ad89 mov    (%rcx),%rcx
124ad8c vmovupd (%rcx),%ymm0
124ad90 vmovupd 0x20(%rcx),%ymm1
124ad95 vmovupd 0x40(%rcx),%ymm2
124ad9a vblendpd $0x4,%ymm1,%ymm0,%ymm3
124ada0 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124ada6 vblendpd $0xa,%ymm4,%ymm3,%ymm3
124adac vblendpd $0x2,%ymm0,%ymm1,%ymm0
124adb2 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124adb8 vshufpd $0x5,%ymm1,%ymm0,%ymm0
124adbd vblendpd $0xa,%ymm1,%ymm4,%ymm1
124adc3 vmovapd %ymm0,0x300(%rsp)
124adcc vmulpd 0x260(%rsp),%ymm0,%ymm0
124add5 vmovapd %ymm3,0x120(%rsp)
124adde vfmadd231pd 0x240(%rsp),%ymm3,%ymm0
124ade8 vmovapd %ymm1,0xe0(%rsp)
124adf1 vfmadd231pd 0x100(%rsp),%ymm1,%ymm0
124adfb jmp    124ae06 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x196>
124adfd vbroadcastsd 0x82cb02(%rip),%ymm0        # 1a77908 <_fini+0xdd4>
124ae06 vbroadcastsd 0x28(%r12),%ymm1
124ae0d vbroadcastsd 0x82ca72(%rip),%ymm2        # 1a77888 <_fini+0xd54>
124ae16 vmovapd %ymm2,0x40(%rsp)
124ae1c test   %al,%al
124ae1e je     124ae4c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1dc>
124ae20 cmpb   $0x0,0x4(%r15)
124ae25 je     124ae4c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1dc>
124ae27 vucomisd 0x82cad9(%rip),%xmm1        # 1a77908 <_fini+0xdd4>
124ae2f jbe    124ae4c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1dc>
124ae31 vsubpd %ymm0,%ymm1,%ymm2
124ae35 vbroadcastsd 0x82ca4a(%rip),%ymm3        # 1a77888 <_fini+0xd54>
124ae3e vaddpd %ymm3,%ymm1,%ymm3
124ae42 vdivpd %ymm3,%ymm2,%ymm2
124ae46 vmovapd %ymm2,0x40(%rsp)
124ae4c mov    0x10(%rbp),%rcx
124ae50 vmovsd 0x38(%r12),%xmm3
124ae57 vxorpd %xmm2,%xmm2,%xmm2
124ae5b vucomisd %xmm2,%xmm3
124ae5f mov    $0x1,%al
124ae61 ja     124ae82 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x212>
124ae63 vmovsd 0x30(%r12),%xmm3
124ae6a vucomisd %xmm2,%xmm3
124ae6e ja     124ae82 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x212>
124ae70 vmovsd 0x48(%r12),%xmm3
124ae77 vxorpd %xmm4,%xmm4,%xmm4
124ae7b vucomisd %xmm4,%xmm3
124ae7f seta   %al
124ae82 movzbl 0x90(%rbp),%r13d
124ae8a vmovupd (%rcx),%ymm13
124ae8e vcmplepd %ymm1,%ymm0,%ymm0
124ae93 vmovapd %ymm0,0xa0(%rsp)
124ae9c cmpb   $0x0,0x5(%r15)
124aea1 setne  %r14b
124aea5 cmpb   $0x0,0x1(%r15)
124aeaa vmovsd 0x8(%r12),%xmm1
124aeb1 je     124aeba <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x24a>
124aeb3 vmovsd 0x18(%r12),%xmm2
124aeba vaddsd 0x10(%r12),%xmm2,%xmm2
124aec1 vbroadcastsd 0x8(%r12),%ymm0
124aec8 vbroadcastsd 0x82c9af(%rip),%ymm3        # 1a77880 <_fini+0xd4c>
124aed1 vmovapd %ymm3,0x2c0(%rsp)
124aeda vxorpd %ymm3,%ymm13,%ymm3
124aede vsubsd %xmm2,%xmm1,%xmm1
124aee2 vbroadcastsd %xmm1,%ymm1
124aee7 vmovapd %ymm3,0x420(%rsp)
124aef0 vsubpd %ymm1,%ymm3,%ymm5
124aef4 vdivpd %ymm0,%ymm5,%ymm4
124aef8 vmulpd %ymm4,%ymm4,%ymm2
124aefc vmulpd %ymm2,%ymm4,%ymm6
124af00 vxorpd %xmm1,%xmm1,%xmm1
124af04 vcmplepd %ymm1,%ymm0,%ymm3
124af09 vbroadcastsd 0x82c996(%rip),%ymm7        # 1a778a8 <_fini+0xd74>
124af12 vmovapd %ymm7,0x1e0(%rsp)
124af1b vandpd %ymm7,%ymm5,%ymm7
124af1f vcmpltpd %ymm7,%ymm0,%ymm7
124af24 vbroadcastsd 0x82cd83(%rip),%ymm10        # 1a77cb0 <_fini+0x117c>
124af2d vbroadcastsd 0x82cd82(%rip),%ymm12        # 1a77cb8 <_fini+0x1184>
124af36 vbroadcastsd 0x82c979(%rip),%ymm8        # 1a778b8 <_fini+0xd84>
124af3f vorpd  %ymm3,%ymm7,%ymm3
124af43 vmovapd %ymm12,%ymm7
124af47 vbroadcastsd 0x82cd90(%rip),%ymm11        # 1a77ce0 <_fini+0x11ac>
124af50 vfmadd213pd %ymm8,%ymm4,%ymm7
124af55 vmovapd %ymm11,0x1c0(%rsp)
124af5e vfmadd231pd %ymm11,%ymm6,%ymm7
124af63 vmulpd %ymm7,%ymm5,%ymm7
124af67 vmovapd %ymm10,0x200(%rsp)
124af70 vfmadd231pd %ymm10,%ymm0,%ymm7
124af75 vblendvpd %ymm3,%ymm5,%ymm7,%ymm7
124af7b vbroadcastsd 0x82cd44(%rip),%ymm10        # 1a77cc8 <_fini+0x1194>
124af84 vmovapd %ymm8,0x4a0(%rsp)
124af8d vmovapd %ymm10,0x220(%rsp)
124af96 vfmadd213pd %ymm8,%ymm10,%ymm4
124af9b vbroadcastsd 0x82cd44(%rip),%ymm8        # 1a77ce8 <_fini+0x11b4>
124afa4 vmovapd %ymm8,0x1a0(%rsp)
124afad vfmadd231pd %ymm6,%ymm8,%ymm4
124afb2 vcmpnltpd %ymm1,%ymm5,%ymm5
124afb7 vbroadcastsd 0x82c8c8(%rip),%ymm6        # 1a77888 <_fini+0xd54>
124afc0 vandpd %ymm6,%ymm5,%ymm5
124afc4 vblendvpd %ymm3,%ymm5,%ymm4,%ymm4
124afca and    %al,%r14b
124afcd vmaxpd %ymm7,%ymm1,%ymm5
124afd1 vmaxpd %ymm4,%ymm1,%ymm4
124afd5 vmovapd %ymm6,0x80(%rsp)
124afde vminpd %ymm4,%ymm6,%ymm6
124afe2 vandpd 0xa0(%rsp),%ymm5,%ymm4
124afeb vbroadcastsd (%r12),%ymm5
124aff1 test   %r13b,%r13b
124aff4 je     124b014 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x3a4>
124aff6 vmulsd 0x82c8ba(%rip),%xmm5,%xmm7        # 1a778b8 <_fini+0xd84>
124affe vmulpd %ymm4,%ymm4,%ymm8
124b002 vbroadcastsd %xmm7,%ymm7
124b007 vmulpd %ymm7,%ymm8,%ymm7
124b00b vmovapd %ymm7,0x4c0(%rsp)
124b014 vandpd 0xa0(%rsp),%ymm6,%ymm6
124b01d mov    %r14d,%ecx
124b020 or     0x98(%rbp),%cl
124b026 cmp    $0x1,%cl
124b029 jne    124b079 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x409>
124b02b vmulpd %ymm4,%ymm5,%ymm7
124b02f vmulpd %ymm6,%ymm7,%ymm7
124b033 cmpb   $0x0,0x98(%rbp)
124b03a je     124b06a <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x3fa>
124b03c vmulpd %ymm7,%ymm9,%ymm8
124b040 vmovapd %ymm8,0x140(%rsp)
124b049 vmulpd 0xc0(%rsp),%ymm7,%ymm8
124b052 vmovapd %ymm8,0x160(%rsp)
124b05b vmulpd 0x20(%rsp),%ymm7,%ymm8
124b061 vmovapd %ymm8,0x180(%rsp)
124b06a vmulpd 0x40(%rsp),%ymm7,%ymm7
124b070 vmovapd %ymm7,0x2a0(%rsp)
124b079 cmpb   $0x0,0xa0(%rbp)
124b080 je     124b1e5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x575>
124b086 vmovapd 0x80(%rsp),%ymm7
124b08f vsubpd %ymm2,%ymm7,%ymm2
124b093 vmulpd 0x220(%rsp),%ymm2,%ymm2
124b09c vdivpd %ymm0,%ymm2,%ymm0
124b0a0 vandnpd %ymm0,%ymm3,%ymm0
124b0a4 vmaxpd %ymm0,%ymm1,%ymm0
124b0a8 vandpd 0xa0(%rsp),%ymm0,%ymm0
124b0b1 vxorpd 0x2c0(%rsp),%ymm5,%ymm1
124b0ba vmulpd %ymm0,%ymm4,%ymm0
124b0be vfmadd213pd %ymm0,%ymm6,%ymm6
124b0c3 vmulpd %ymm1,%ymm6,%ymm0
124b0c7 vmulpd %ymm0,%ymm9,%ymm1
124b0cb vmovapd 0xc0(%rsp),%ymm5
124b0d4 vmulpd %ymm0,%ymm5,%ymm2
124b0d8 vmovapd 0x20(%rsp),%ymm4
124b0de vmulpd %ymm0,%ymm4,%ymm0
124b0e2 vmulpd %ymm1,%ymm9,%ymm3
124b0e6 vmovapd %ymm3,0x340(%rsp)
124b0ef vmulpd %ymm2,%ymm5,%ymm3
124b0f3 vmovapd %ymm3,0x360(%rsp)
124b0fc vmulpd %ymm0,%ymm4,%ymm0
124b100 vmovapd %ymm0,0x3e0(%rsp)
124b109 vmulpd %ymm1,%ymm5,%ymm0
124b10d vmovapd %ymm0,0x380(%rsp)
124b116 vmulpd %ymm1,%ymm4,%ymm0
124b11a vmovapd %ymm0,0x3c0(%rsp)
124b123 vmulpd %ymm2,%ymm4,%ymm0
124b127 vmovapd %ymm0,0x3a0(%rsp)
124b130 test   %al,%al
124b132 jne    124b1ed <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x57d>
124b138 vmovapd 0x4c0(%rsp),%ymm0
124b141 test   %r13b,%r13b
124b144 je     124b152 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4e2>
124b146 mov    0x290(%rsp),%rax
124b14e vmovupd %ymm0,(%rax)
124b152 cmpb   $0x0,0x98(%rbp)
124b159 je     124b3b1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x741>
124b15f vmovapd 0x140(%rsp),%ymm4
124b168 vpermpd $0x6c,%ymm4,%ymm0
124b16e vmovapd 0x180(%rsp),%ymm2
124b177 vpermpd $0xc6,%ymm2,%ymm1
124b17d vblendpd $0xa,%ymm0,%ymm1,%ymm0
124b183 vmovapd 0x160(%rsp),%ymm3
124b18c vunpcklpd %ymm3,%ymm4,%ymm1
124b190 vunpckhpd %ymm2,%ymm3,%ymm2
124b194 vblendpd $0xc,%ymm0,%ymm1,%ymm3
124b19a mov    0x298(%rsp),%rax
124b1a2 vmovupd %ymm3,(%rax)
124b1a6 vblendpd $0xc,%ymm1,%ymm2,%ymm1
124b1ac vmovupd %ymm1,0x20(%rax)
124b1b1 vblendpd $0xc,%ymm2,%ymm0,%ymm0
124b1b7 vmovupd %ymm0,0x40(%rax)
124b1bc cmpb   $0x0,0xa0(%rbp)
124b1c3 jne    124b3be <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x74e>
124b1c9 mov    %fs:0x28,%rax
124b1d2 cmp    0x540(%rsp),%rax
124b1da je     124b556 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x8e6>
124b1e0 jmp    124c698 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1a28>
124b1e5 test   %al,%al
124b1e7 je     124b138 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4c8>
124b1ed vmovapd %ymm13,0x4e0(%rsp)
124b1f6 vmovapd %ymm12,0x320(%rsp)
124b1ff vmovapd %ymm9,0x500(%rsp)
124b208 lea    0xb0(%rbp),%r13
124b20f lea    0x70(%rbp),%rax
124b213 lea    0x60(%rbp),%rcx
124b217 mov    (%rcx),%rcx
124b21a vmovupd (%rcx),%ymm0
124b21e vmovupd 0x20(%rcx),%ymm1
124b223 vmovupd 0x40(%rcx),%ymm2
124b228 vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b22e vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b234 vblendpd $0xa,%ymm4,%ymm3,%ymm6
124b23a vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b240 vblendpd $0x4,%ymm2,%ymm0,%ymm0
124b246 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b24c vblendpd $0xa,%ymm1,%ymm4,%ymm7
124b252 mov    (%rax),%rax
124b255 vmovupd (%rax),%ymm1
124b259 vmovupd 0x20(%rax),%ymm2
124b25e vmovupd 0x40(%rax),%ymm3
124b263 vblendpd $0x4,%ymm2,%ymm1,%ymm4
124b269 vperm2f128 $0x21,%ymm3,%ymm1,%ymm5
124b26f vblendpd $0xa,%ymm5,%ymm4,%ymm4
124b275 vblendpd $0x2,%ymm1,%ymm2,%ymm1
124b27b vblendpd $0xc,%ymm3,%ymm2,%ymm2
124b281 vblendpd $0xa,%ymm2,%ymm5,%ymm3
124b287 vmovapd %ymm6,0x480(%rsp)
124b290 vsubpd %ymm4,%ymm6,%ymm12
124b294 vshufpd $0x5,%ymm2,%ymm1,%ymm1
124b299 vshufpd $0x5,%ymm0,%ymm0,%ymm0
124b29e vmovapd %ymm0,0x440(%rsp)
124b2a7 vsubpd %ymm1,%ymm0,%ymm0
124b2ab cmpq   $0x4,0x8(%r13)
124b2b0 vmovapd %ymm7,0x460(%rsp)
124b2b9 vsubpd %ymm3,%ymm7,%ymm9
124b2bd vmovapd %ymm9,0x60(%rsp)
124b2c3 vmovapd %ymm0,%ymm13
124b2c7 vmovapd %ymm12,0x2e0(%rsp)
124b2d0 jne    124b38d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x71d>
124b2d6 vmovapd %ymm0,0x400(%rsp)
124b2df mov    0xbbaf32(%rip),%rax        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124b2e6 movzbl (%rax),%eax
124b2e9 test   %al,%al
124b2eb je     124c45a <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17ea>
124b2f1 mov    0xbca528(%rip),%rax        # 1e15820 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2ead0>
124b2f8 vmovsd (%rax),%xmm0
124b2fc vxorpd %xmm1,%xmm1,%xmm1
124b300 vucomisd %xmm1,%xmm0
124b304 vmovapd 0x60(%rsp),%ymm9
124b30a vmovapd 0x400(%rsp),%ymm0
124b313 vmovapd %ymm0,%ymm13
124b317 vmovapd 0x2e0(%rsp),%ymm12
124b320 jbe    124b38d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x71d>
124b322 mov    0x0(%r13),%rax
124b326 vmovupd (%rax),%ymm0
124b32a vmovupd 0x20(%rax),%ymm1
124b32f vmovupd 0x40(%rax),%ymm2
124b334 vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b33a vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b340 vblendpd $0xa,%ymm4,%ymm3,%ymm3
124b346 vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b34c vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b352 vblendpd $0xa,%ymm1,%ymm4,%ymm2
124b358 vmovapd 0x480(%rsp),%ymm4
124b361 vsubpd %ymm3,%ymm4,%ymm12
124b365 vshufpd $0x5,%ymm1,%ymm0,%ymm0
124b36a vmovapd 0x440(%rsp),%ymm1
124b373 vsubpd %ymm0,%ymm1,%ymm13
124b377 vmovapd 0x400(%rsp),%ymm0
124b380 vmovapd 0x460(%rsp),%ymm1
124b389 vsubpd %ymm2,%ymm1,%ymm9
124b38d test   %r14b,%r14b
124b390 jne    124b69d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa2d>
124b396 cmpb   $0x0,0x3(%r15)
124b39b je     124b568 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x8f8>
124b3a1 lea    0x30(%rbp),%rax
124b3a5 mov    (%rax),%rax
124b3a8 vmovupd (%rax),%ymm1
124b3ac jmp    124b59e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x92e>
124b3b1 cmpb   $0x0,0xa0(%rbp)
124b3b8 je     124b1c9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x559>
124b3be vmovapd 0x340(%rsp),%ymm7
124b3c7 vpermpd $0xff,%ymm7,%ymm0
124b3cd vmovapd 0x380(%rsp),%ymm8
124b3d6 vextractf128 $0x1,%ymm8,%xmm3
124b3dc vblendpd $0x1,%ymm0,%ymm3,%ymm0
124b3e2 vmovapd 0x3c0(%rsp),%ymm11
124b3eb vshufpd $0x4,%ymm11,%ymm11,%ymm1
124b3f1 vblendpd $0x4,%ymm1,%ymm0,%ymm0
124b3f7 vpermpd $0xff,%ymm8,%ymm1
124b3fd vmovapd 0x360(%rsp),%ymm9
124b406 vextractf128 $0x1,%ymm9,%xmm4
124b40c vblendpd $0x1,%ymm1,%ymm4,%ymm1
124b412 vmovapd 0x3a0(%rsp),%ymm12
124b41b vshufpd $0x4,%ymm12,%ymm12,%ymm2
124b421 vblendpd $0x4,%ymm2,%ymm1,%ymm1
124b427 vextractf128 $0x1,%ymm7,%xmm2
124b42d vshufpd $0x8,%ymm3,%ymm2,%ymm2
124b432 vblendpd $0x4,%ymm11,%ymm2,%ymm2
124b438 vshufpd $0x8,%ymm4,%ymm3,%ymm3
124b43d vblendpd $0x4,%ymm12,%ymm3,%ymm3
124b443 vshufpd $0x1,%xmm7,%xmm7,%xmm4
124b448 vmovapd %xmm8,%xmm5
124b44c vinsertf128 $0x1,%xmm11,%ymm4,%ymm4
124b452 vshufpd $0xe,%ymm5,%ymm4,%ymm4
124b457 vshufpd $0x1,%xmm8,%xmm8,%xmm5
124b45d vmovapd %xmm9,%xmm6
124b461 vinsertf128 $0x1,%xmm12,%ymm5,%ymm5
124b467 vshufpd $0xe,%ymm6,%ymm5,%ymm5
124b46c vmovddup %xmm8,%xmm6
124b471 vinsertf128 $0x1,%xmm11,%ymm7,%ymm7
124b477 vblendpd $0xa,%ymm6,%ymm7,%ymm6
124b47d vmovddup %xmm9,%xmm7
124b482 vinsertf128 $0x1,%xmm12,%ymm8,%ymm8
124b488 vblendpd $0xa,%ymm7,%ymm8,%ymm7
124b48e vmovddup %xmm12,%xmm8
124b493 vmovapd 0x3e0(%rsp),%ymm10
124b49c vinsertf128 $0x1,%xmm10,%ymm11,%ymm9
124b4a2 vblendpd $0xa,%ymm8,%ymm9,%ymm8
124b4a8 vmovapd %ymm6,(%rbx)
124b4ac vmovapd %ymm7,0x20(%rbx)
124b4b1 vmovapd %ymm8,0x40(%rbx)
124b4b6 vshufpd $0x1,%xmm11,%xmm11,%xmm6
124b4bc vmovapd %xmm12,%xmm7
124b4c0 vinsertf128 $0x1,%xmm10,%ymm6,%ymm6
124b4c6 vshufpd $0xe,%ymm7,%ymm6,%ymm6
124b4cb vmovapd %ymm4,0x60(%rbx)
124b4d0 vmovapd %ymm5,0x80(%rbx)
124b4d8 vmovapd %ymm6,0xa0(%rbx)
124b4e0 vextractf128 $0x1,%ymm11,%xmm4
124b4e6 vextractf128 $0x1,%ymm12,%xmm5
124b4ec vshufpd $0x8,%ymm5,%ymm4,%ymm4
124b4f1 vblendpd $0x4,%ymm10,%ymm4,%ymm4
124b4f7 vmovapd %ymm2,0xc0(%rbx)
124b4ff vmovapd %ymm3,0xe0(%rbx)
124b507 vmovapd %ymm4,0x100(%rbx)
124b50f vpermpd $0xff,%ymm11,%ymm2
124b515 vblendpd $0x1,%ymm2,%ymm5,%ymm2
124b51b vshufpd $0x4,%ymm10,%ymm10,%ymm3
124b521 vblendpd $0x4,%ymm3,%ymm2,%ymm2
124b527 vmovapd %ymm0,0x120(%rbx)
124b52f vmovapd %ymm1,0x140(%rbx)
124b537 vmovapd %ymm2,0x160(%rbx)
124b53f mov    %fs:0x28,%rax
124b548 cmp    0x540(%rsp),%rax
124b550 jne    124c698 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1a28>
124b556 lea    -0x28(%rbp),%rsp
124b55a pop    %rbx
124b55b pop    %r12
124b55d pop    %r13
124b55f pop    %r14
124b561 pop    %r15
124b563 pop    %rbp
124b564 vzeroupper
124b567 ret
124b568 vmulpd 0xc0(%rsp),%ymm0,%ymm0
124b571 vmovapd 0x500(%rsp),%ymm1
124b57a vfmadd132pd 0x2e0(%rsp),%ymm0,%ymm1
124b584 vmovapd 0x20(%rsp),%ymm0
124b58a vfmadd132pd 0x60(%rsp),%ymm1,%ymm0
124b591 vmovapd 0x4e0(%rsp),%ymm1
124b59a vsubpd %ymm0,%ymm1,%ymm1
124b59e vbroadcastsd (%r12),%ymm0
124b5a4 cmpb   $0x0,0x1(%r15)
124b5a9 vmovsd 0x8(%r12),%xmm2
124b5b0 vxorpd %xmm3,%xmm3,%xmm3
124b5b4 je     124b5bd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x94d>
124b5b6 vmovsd 0x18(%r12),%xmm3
124b5bd vaddsd 0x10(%r12),%xmm3,%xmm3
124b5c4 vbroadcastsd 0x8(%r12),%ymm4
124b5cb vxorpd 0x2c0(%rsp),%ymm1,%ymm1
124b5d4 vsubsd %xmm3,%xmm2,%xmm2
124b5d8 vbroadcastsd %xmm2,%ymm2
124b5dd vsubpd %ymm2,%ymm1,%ymm1
124b5e1 vdivpd %ymm4,%ymm1,%ymm2
124b5e5 vmulpd %ymm2,%ymm2,%ymm3
124b5e9 vmulpd %ymm3,%ymm2,%ymm3
124b5ed vxorpd %xmm5,%xmm5,%xmm5
124b5f1 vcmplepd %ymm5,%ymm4,%ymm6
124b5f6 vandpd 0x1e0(%rsp),%ymm1,%ymm7
124b5ff vcmpltpd %ymm7,%ymm4,%ymm7
124b604 vorpd  %ymm6,%ymm7,%ymm6
124b608 vmovapd 0x320(%rsp),%ymm7
124b611 vmovapd 0x4a0(%rsp),%ymm8
124b61a vfmadd213pd %ymm8,%ymm2,%ymm7
124b61f vfmadd231pd 0x1c0(%rsp),%ymm3,%ymm7
124b629 vmulpd %ymm7,%ymm1,%ymm7
124b62d vfmadd231pd 0x200(%rsp),%ymm4,%ymm7
124b637 vfmadd132pd 0x220(%rsp),%ymm8,%ymm2
124b641 vfmadd231pd 0x1a0(%rsp),%ymm3,%ymm2
124b64b vblendvpd %ymm6,%ymm1,%ymm7,%ymm3
124b651 vcmpnltpd %ymm5,%ymm1,%ymm1
124b656 vmovapd 0x80(%rsp),%ymm4
124b65f vandpd %ymm4,%ymm1,%ymm1
124b663 vblendvpd %ymm6,%ymm1,%ymm2,%ymm1
124b669 vmaxpd %ymm3,%ymm5,%ymm2
124b66d vmaxpd %ymm1,%ymm5,%ymm1
124b671 vmovapd 0xa0(%rsp),%ymm3
124b67a vandpd %ymm3,%ymm2,%ymm2
124b67e vmulpd %ymm2,%ymm0,%ymm0
124b682 vminpd %ymm1,%ymm4,%ymm1
124b686 vandpd %ymm3,%ymm1,%ymm1
124b68a vmulpd %ymm1,%ymm0,%ymm0
124b68e vmulpd 0x40(%rsp),%ymm0,%ymm0
124b694 vmovapd %ymm0,0x2a0(%rsp)
124b69d mov    0xbc0074(%rip),%r14        # 1e0b718 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6b0>
124b6a4 movzbl (%r14),%eax
124b6a8 test   %al,%al
124b6aa je     124c3d7 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1767>
124b6b0 mov    0xbc47d1(%rip),%r13        # 1e0fe88 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f38>
124b6b7 cmpb   $0x0,0x0(%r13)
124b6bc vmovsd 0x48(%r12),%xmm0
124b6c3 je     124b827 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xbb7>
124b6c9 vxorpd %xmm2,%xmm2,%xmm2
124b6cd vucomisd %xmm2,%xmm0
124b6d1 jbe    124b827 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xbb7>
124b6d7 vbroadcastsd (%r12),%ymm1
124b6dd cmpb   $0x0,0x1(%r15)
124b6e2 vmovsd 0x8(%r12),%xmm3
124b6e9 je     124b6f2 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa82>
124b6eb vmovsd 0x18(%r12),%xmm2
124b6f2 vaddsd 0x10(%r12),%xmm2,%xmm4
124b6f9 vbroadcastsd 0x8(%r12),%ymm2
124b700 vsubsd %xmm4,%xmm3,%xmm3
124b704 vbroadcastsd %xmm3,%ymm3
124b709 vmovapd 0x420(%rsp),%ymm4
124b712 vsubpd %ymm3,%ymm4,%ymm4
124b716 vdivpd %ymm2,%ymm4,%ymm5
124b71a vmulpd %ymm5,%ymm5,%ymm3
124b71e vmulpd %ymm3,%ymm5,%ymm6
124b722 vmovapd 0x4a0(%rsp),%ymm7
124b72b vmovapd 0x320(%rsp),%ymm10
124b734 vfmadd213pd %ymm7,%ymm5,%ymm10
124b739 vmovapd 0x1c0(%rsp),%ymm8
124b742 vfmadd213pd %ymm10,%ymm6,%ymm8
124b747 vmovapd 0x220(%rsp),%ymm10
124b750 vfmadd213pd %ymm7,%ymm10,%ymm5
124b755 vmovapd 0x1a0(%rsp),%ymm11
124b75e vfmadd213pd %ymm5,%ymm6,%ymm11
124b763 vxorpd %xmm5,%xmm5,%xmm5
124b767 vcmplepd %ymm5,%ymm2,%ymm6
124b76c vandpd 0x1e0(%rsp),%ymm4,%ymm7
124b775 vcmpltpd %ymm7,%ymm2,%ymm7
124b77a vorpd  %ymm6,%ymm7,%ymm6
124b77e vmulpd %ymm4,%ymm8,%ymm7
124b782 vmovapd 0x200(%rsp),%ymm8
124b78b vfmadd213pd %ymm7,%ymm2,%ymm8
124b790 vblendvpd %ymm6,%ymm4,%ymm8,%ymm7
124b796 vbroadcastsd 0x82c0e9(%rip),%ymm8        # 1a77888 <_fini+0xd54>
124b79f vcmpnltpd %ymm5,%ymm4,%ymm4
124b7a4 vandpd %ymm4,%ymm8,%ymm4
124b7a8 vblendvpd %ymm6,%ymm4,%ymm11,%ymm4
124b7ae vmaxpd %ymm4,%ymm5,%ymm4
124b7b2 vminpd %ymm4,%ymm8,%ymm4
124b7b6 vsubpd %ymm3,%ymm8,%ymm3
124b7ba vmulpd %ymm3,%ymm10,%ymm3
124b7be vdivpd %ymm2,%ymm3,%ymm2
124b7c2 vandnpd %ymm2,%ymm6,%ymm2
124b7c6 vmaxpd %ymm7,%ymm5,%ymm3
124b7ca vmaxpd %ymm2,%ymm5,%ymm2
124b7ce vmovapd 0xa0(%rsp),%ymm5
124b7d7 vandpd %ymm5,%ymm3,%ymm3
124b7db vandpd %ymm5,%ymm4,%ymm4
124b7df vandpd %ymm5,%ymm2,%ymm2
124b7e3 vmulpd %ymm2,%ymm3,%ymm2
124b7e7 vmulpd %ymm3,%ymm1,%ymm3
124b7eb vmulpd %ymm4,%ymm3,%ymm3
124b7ef vfmadd231pd %ymm4,%ymm4,%ymm2
124b7f4 vmulpd %ymm1,%ymm2,%ymm1
124b7f8 vmovapd 0x40(%rsp),%ymm2
124b7fe vmulpd %ymm3,%ymm2,%ymm7
124b802 vmulpd %ymm2,%ymm1,%ymm1
124b806 vmovapd %ymm1,0x2e0(%rsp)
124b80f vmovdqu 0x18(%r12),%xmm1
124b816 vpextrb $0x8,%xmm1,%ecx
124b81c movzbl 0x2(%r15),%eax
124b821 test   %cl,%cl
124b823 je     124b84c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xbdc>
124b825 jmp    124b879 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc09>
124b827 movzbl 0x20(%r12),%ecx
124b82d vxorpd %xmm1,%xmm1,%xmm1
124b831 vmovapd %ymm1,0x2e0(%rsp)
124b83a vmovapd 0x2a0(%rsp),%ymm7
124b843 movzbl 0x2(%r15),%eax
124b848 test   %cl,%cl
124b84a jne    124b879 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc09>
124b84c test   %al,%al
124b84e je     124b879 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc09>
124b850 vmovapd 0x2c0(%rsp),%ymm1
124b859 vxorpd 0x120(%rsp),%ymm1,%ymm5
124b862 vxorpd 0x300(%rsp),%ymm1,%ymm4
124b86b vxorpd 0xe0(%rsp),%ymm1,%ymm3
124b874 jmp    124b8fe <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc8e>
124b879 cmpb   $0x0,0xa8(%rbp)
124b880 je     124b89f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc2f>
124b882 vmovapd 0x100(%rsp),%ymm3
124b88b vmovapd 0x260(%rsp),%ymm4
124b894 vmovapd 0x240(%rsp),%ymm5
124b89d jmp    124b8fe <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc8e>
124b89f vmovapd 0x260(%rsp),%ymm4
124b8a8 vmulpd %ymm4,%ymm4,%ymm1
124b8ac vmovapd 0x240(%rsp),%ymm5
124b8b5 vfmadd231pd %ymm5,%ymm5,%ymm1
124b8ba vmovapd 0x100(%rsp),%ymm3
124b8c3 vfmadd231pd %ymm3,%ymm3,%ymm1
124b8c8 vsqrtpd %ymm1,%ymm1
124b8cc vbroadcastsd 0x82bfb3(%rip),%ymm2        # 1a77888 <_fini+0xd54>
124b8d5 vdivpd %ymm1,%ymm2,%ymm2
124b8d9 vmulpd %ymm2,%ymm5,%ymm5
124b8dd vmulpd %ymm4,%ymm2,%ymm4
124b8e1 vmulpd %ymm3,%ymm2,%ymm3
124b8e5 vbroadcastsd 0x82c3e2(%rip),%ymm2        # 1a77cd0 <_fini+0x119c>
124b8ee vcmpltpd %ymm2,%ymm1,%ymm1
124b8f3 vtestpd %ymm1,%ymm1
124b8f8 jne    124c387 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1717>
124b8fe vxorpd %xmm1,%xmm1,%xmm1
124b902 vucomisd %xmm1,%xmm0
124b906 vmulpd %ymm4,%ymm13,%ymm1
124b90a vfmadd231pd %ymm5,%ymm12,%ymm1
124b90f vfmadd231pd %ymm3,%ymm9,%ymm1
124b914 vmovapd %ymm5,0x240(%rsp)
124b91d vmulpd %ymm5,%ymm1,%ymm0
124b921 vmovapd %ymm0,0x220(%rsp)
124b92a vmovapd %ymm4,0x260(%rsp)
124b933 vmovapd %ymm1,0xa0(%rsp)
124b93c vmulpd %ymm4,%ymm1,%ymm0
124b940 vmovapd %ymm0,0x420(%rsp)
124b949 vsubpd %ymm0,%ymm13,%ymm0
124b94d vmovapd %ymm0,0xc0(%rsp)
124b956 vmovapd %ymm3,%ymm0
124b95a vmovapd %ymm3,0x100(%rsp)
124b963 jbe    124b99b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd2b>
124b965 movzbl (%r14),%eax
124b969 test   %al,%al
124b96b je     124c49a <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x182a>
124b971 cmpb   $0x0,0x0(%r13)
124b976 setne  %r14b
124b97a mov    0xbc7467(%rip),%rax        # 1e12de8 <_ZGVZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x36ff0>
124b981 movzbl (%rax),%eax
124b984 test   %al,%al
124b986 je     124c521 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x18b1>
124b98c mov    0xbbc145(%rip),%rax        # 1e07ad8 <_ZZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x422f8>
124b993 cmpb   $0x0,(%rax)
124b996 setne  %al
124b999 jmp    124b9a0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd30>
124b99b xor    %r14d,%r14d
124b99e xor    %eax,%eax
124b9a0 movzbl 0x90(%rbp),%r13d
124b9a8 vmulpd 0xa0(%rsp),%ymm0,%ymm0
124b9b1 vmovapd %ymm0,0x20(%rsp)
124b9b7 vsubpd 0x220(%rsp),%ymm12,%ymm0
124b9c0 vmovapd %ymm0,0x200(%rsp)
124b9c9 vmovapd 0xc0(%rsp),%ymm0
124b9d2 vmulpd %ymm0,%ymm0,%ymm0
124b9d6 test   %r14b,%r14b
124b9d9 jne    124ba11 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xda1>
124b9db vxorpd %xmm1,%xmm1,%xmm1
124b9df vmovapd %ymm1,0x300(%rsp)
124b9e8 vmovaps 0x80(%rsp),%ymm1
124b9f1 vmovaps %ymm1,0x40(%rsp)
124b9f7 vmovapd 0xa0(%rsp),%ymm1
124ba00 vmovapd %ymm1,0x1c0(%rsp)
124ba09 test   %al,%al
124ba0b je     124baa7 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe37>
124ba11 vmovsd 0x48(%r12),%xmm2
124ba18 vxorpd %xmm1,%xmm1,%xmm1
124ba1c vmovapd 0x2a0(%rsp),%ymm3
124ba25 vcmpltpd %ymm3,%ymm1,%ymm4
124ba2a vdivpd %ymm3,%ymm7,%ymm5
124ba2e vbroadcastsd 0x82be51(%rip),%ymm3        # 1a77888 <_fini+0xd54>
124ba37 vblendvpd %ymm4,%ymm5,%ymm3,%ymm4
124ba3d vmovsd 0x18(%rsp),%xmm5
124ba43 vdivsd %xmm2,%xmm5,%xmm5
124ba47 vbroadcastsd %xmm5,%ymm5
124ba4c vmulpd %ymm5,%ymm4,%ymm4
124ba50 test   %r14b,%r14b
124ba53 jne    124ba69 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xdf9>
124ba55 vmovapd 0xa0(%rsp),%ymm5
124ba5e vmovapd %ymm5,0x1c0(%rsp)
124ba67 jmp    124ba7f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe0f>
124ba69 vmovapd 0xa0(%rsp),%ymm5
124ba72 vminpd %ymm4,%ymm5,%ymm6
124ba76 vmovapd %ymm6,0x1c0(%rsp)
124ba7f vcmpltpd %ymm4,%ymm5,%ymm4
124ba84 vmovapd %ymm4,0x300(%rsp)
124ba8d vdivsd 0x18(%rsp),%xmm2,%xmm2
124ba93 vbroadcastsd %xmm2,%ymm2
124ba98 vfnmadd213pd %ymm3,%ymm5,%ymm2
124ba9d vmaxpd %ymm2,%ymm1,%ymm1
124baa1 vmovapd %ymm1,0x40(%rsp)
124baa7 vsubpd 0x20(%rsp),%ymm9,%ymm1
124baad vmovapd %ymm1,0x1e0(%rsp)
124bab6 vmovapd 0x200(%rsp),%ymm1
124babf vfmadd231pd %ymm1,%ymm1,%ymm0
124bac4 test   %al,%al
124bac6 jne    124bad7 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe67>
124bac8 vmovapd 0x80(%rsp),%ymm1
124bad1 vmovapd %ymm1,0x40(%rsp)
124bad7 vmovapd 0x1e0(%rsp),%ymm1
124bae0 vfmadd231pd %ymm1,%ymm1,%ymm0
124bae5 test   %r14b,%r14b
124bae8 je     124bb26 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xeb6>
124baea vmovapd 0x1c0(%rsp),%ymm2
124baf3 vmulpd 0x240(%rsp),%ymm2,%ymm1
124bafc vmovapd %ymm1,0x220(%rsp)
124bb05 vmulpd 0x260(%rsp),%ymm2,%ymm1
124bb0e vmovapd %ymm1,0x420(%rsp)
124bb17 vmulpd 0x100(%rsp),%ymm2,%ymm1
124bb20 vmovapd %ymm1,0x20(%rsp)
124bb26 vsqrtpd %ymm0,%ymm0
124bb2a vmovapd %ymm0,0x1a0(%rsp)
124bb33 vmovapd 0x40(%rsp),%ymm0
124bb39 vmulpd 0x2a0(%rsp),%ymm0,%ymm0
124bb42 vmovapd %ymm0,0x320(%rsp)
124bb4b vmovsd 0x38(%r12),%xmm1
124bb52 vxorpd %xmm0,%xmm0,%xmm0
124bb56 vmovapd %xmm1,0xe0(%rsp)
124bb5f vucomisd %xmm0,%xmm1
124bb63 jbe    124bde8 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1178>
124bb69 mov    0xbba6a8(%rip),%rax        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124bb70 movzbl (%rax),%eax
124bb73 test   %al,%al
124bb75 je     124c5ad <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x193d>
124bb7b mov    0xbc9c9e(%rip),%r13        # 1e15820 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2ead0>
124bb82 vmovsd 0x0(%r13),%xmm0
124bb88 vmovsd 0x18(%rsp),%xmm1
124bb8e vmulsd 0x40(%r12),%xmm1,%xmm1
124bb95 vxorpd %xmm2,%xmm2,%xmm2
124bb99 vcmpltsd %xmm0,%xmm2,%xmm2
124bb9e vblendvpd %xmm2,%xmm0,%xmm1,%xmm0
124bba4 vbroadcastsd %xmm0,%ymm2
124bba9 mov    0x8(%r15),%eax
124bbad test   %eax,%eax
124bbaf je     124c18c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x151c>
124bbb5 vxorpd %xmm0,%xmm0,%xmm0
124bbb9 vxorpd %xmm1,%xmm1,%xmm1
124bbbd vmovapd %ymm1,0x120(%rsp)
124bbc6 cmp    $0x1,%eax
124bbc9 jne    124bc2b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfbb>
124bbcb vbroadcastsd 0x82bd04(%rip),%ymm0        # 1a778d8 <_fini+0xda4>
124bbd4 vmaxpd %ymm0,%ymm2,%ymm2
124bbd8 vmulpd %ymm2,%ymm2,%ymm0
124bbdc vbroadcastsd 0x82be03(%rip),%ymm1        # 1a779e8 <_fini+0xeb4>
124bbe5 vmulpd %ymm1,%ymm0,%ymm3
124bbe9 vmovapd 0x1a0(%rsp),%ymm0
124bbf2 vfmadd213pd %ymm3,%ymm0,%ymm0
124bbf7 vsqrtpd %ymm0,%ymm4
124bbfb vbroadcastsd 0x82bc84(%rip),%ymm0        # 1a77888 <_fini+0xd54>
124bc04 vdivpd %ymm4,%ymm0,%ymm0
124bc08 vbroadcastsd 0x82bcaf(%rip),%ymm1        # 1a778c0 <_fini+0xd8c>
124bc11 vfmadd213pd %ymm4,%ymm2,%ymm1
124bc16 vmulpd %ymm0,%ymm0,%ymm2
124bc1a vmulpd %ymm2,%ymm0,%ymm2
124bc1e vmulpd %ymm2,%ymm3,%ymm2
124bc22 vmovapd %ymm2,0x120(%rsp)
124bc2b cmpb   $0x0,0x90(%rbp)
124bc32 je     124bc51 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfe1>
124bc34 vbroadcastsd 0xe0(%rsp),%ymm2
124bc3e vmulpd %ymm1,%ymm2,%ymm1
124bc42 vmulpd 0x40(%rsp),%ymm1,%ymm1
124bc48 vmovapd %ymm1,0x80(%rsp)
124bc51 cmpb   $0x0,0x98(%rbp)
124bc58 jne    124bc67 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xff7>
124bc5a cmpb   $0x0,0xa0(%rbp)
124bc61 je     124be15 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x11a5>
124bc67 vbroadcastsd 0xe0(%rsp),%ymm1
124bc71 vmulpd 0x320(%rsp),%ymm1,%ymm1
124bc7a vmulpd %ymm0,%ymm1,%ymm2
124bc7e cmpb   $0x0,0x98(%rbp)
124bc85 vmovapd %ymm2,0x60(%rsp)
124bc8b je     124bce1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1071>
124bc8d vmovapd 0x140(%rsp),%ymm0
124bc96 vfnmadd231pd 0x200(%rsp),%ymm2,%ymm0
124bca0 vmovapd %ymm0,0x140(%rsp)
124bca9 vmovapd 0x160(%rsp),%ymm0
124bcb2 vfnmadd231pd 0xc0(%rsp),%ymm2,%ymm0
124bcbc vmovapd %ymm0,0x160(%rsp)
124bcc5 vmovapd 0x180(%rsp),%ymm0
124bcce vfnmadd231pd 0x1e0(%rsp),%ymm2,%ymm0
124bcd8 vmovapd %ymm0,0x180(%rsp)
124bce1 cmpb   $0x0,0xa0(%rbp)
124bce8 je     124be15 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x11a5>
124bcee vmovapd %ymm1,0x440(%rsp)
124bcf7 vmovapd 0x60(%rsp),%ymm0
124bcfd vxorpd 0x2c0(%rsp),%ymm0,%ymm0
124bd06 vmovapd %ymm0,0xe0(%rsp)
124bd0f cmpb   $0x0,0x6(%r15)
124bd14 je     124bd3c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x10cc>
124bd16 mov    0xbba4fb(%rip),%rax        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124bd1d movzbl (%rax),%eax
124bd20 test   %al,%al
124bd22 je     124c62d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x19bd>
124bd28 vmovsd 0x0(%r13),%xmm0
124bd2e vxorpd %xmm1,%xmm1,%xmm1
124bd32 vucomisd %xmm1,%xmm0
124bd36 jbe    124be15 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x11a5>
124bd3c vbroadcastsd 0x82bf93(%rip),%ymm0        # 1a77cd8 <_fini+0x11a4>
124bd45 vbroadcastsd 0x82bb7a(%rip),%ymm1        # 1a778c8 <_fini+0xd94>
124bd4e vmovapd 0x1a0(%rsp),%ymm2
124bd57 vcmpltpd %ymm2,%ymm0,%ymm0
124bd5c vaddpd %ymm1,%ymm2,%ymm1
124bd60 vbroadcastsd 0x82bb1f(%rip),%ymm2        # 1a77888 <_fini+0xd54>
124bd69 vdivpd %ymm1,%ymm2,%ymm1
124bd6d vmulpd 0x200(%rsp),%ymm1,%ymm2
124bd76 vmovapd %ymm2,0x480(%rsp)
124bd7f vmulpd 0xc0(%rsp),%ymm1,%ymm2
124bd88 vmovapd %ymm2,0x400(%rsp)
124bd91 vmulpd 0x1e0(%rsp),%ymm1,%ymm1
124bd9a vmovapd %ymm1,0x460(%rsp)
124bda3 vmovapd 0x120(%rsp),%ymm1
124bdac vmovapd 0x60(%rsp),%ymm2
124bdb2 vfnmadd132pd 0x440(%rsp),%ymm2,%ymm1
124bdbc vandpd %ymm1,%ymm0,%ymm0
124bdc0 vmovapd %ymm0,0x120(%rsp)
124bdc9 movzbl 0x90(%rbp),%r13d
124bdd1 vmovsd 0x30(%r12),%xmm0
124bdd8 vucomisd 0x82bb08(%rip),%xmm0        # 1a778e8 <_fini+0xdb4>
124bde0 jbe    124be8a <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x121a>
124bde6 jmp    124be2e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x11be>
124bde8 vxorpd %xmm0,%xmm0,%xmm0
124bdec vmovapd %ymm0,0x80(%rsp)
124bdf5 vxorps %xmm0,%xmm0,%xmm0
124bdf9 vmovaps %ymm0,0xe0(%rsp)
124be02 vmovsd 0x30(%r12),%xmm0
124be09 vucomisd 0x82bad7(%rip),%xmm0        # 1a778e8 <_fini+0xdb4>
124be11 ja     124be2e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x11be>
124be13 jmp    124be8a <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x121a>
124be15 movzbl 0x90(%rbp),%r13d
124be1d vmovsd 0x30(%r12),%xmm0
124be24 vucomisd 0x82babc(%rip),%xmm0        # 1a778e8 <_fini+0xdb4>
124be2c jbe    124be8a <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x121a>
124be2e vdivsd 0x18(%rsp),%xmm0,%xmm0
124be34 test   %r13b,%r13b
124be37 je     124be70 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1200>
124be39 vmulsd 0x82ba77(%rip),%xmm0,%xmm1        # 1a778b8 <_fini+0xd84>
124be41 vmovapd 0x1a0(%rsp),%ymm2
124be4a vmulpd %ymm2,%ymm2,%ymm2
124be4e vbroadcastsd %xmm1,%ymm1
124be53 vmulpd %ymm1,%ymm2,%ymm1
124be57 vmovapd 0x80(%rsp),%ymm2
124be60 vfmadd231pd 0x40(%rsp),%ymm1,%ymm2
124be67 vmovapd %ymm2,0x80(%rsp)
124be70 cmpb   $0x0,0x98(%rbp)
124be77 jne    124bfcb <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x135b>
124be7d cmpb   $0x0,0xa0(%rbp)
124be84 jne    124bfcb <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x135b>
124be8a vmovsd 0x48(%r12),%xmm1
124be91 vxorpd %xmm0,%xmm0,%xmm0
124be95 vucomisd %xmm0,%xmm1
124be99 jbe    124bfb5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1345>
124be9f vdivsd 0x18(%rsp),%xmm1,%xmm0
124bea5 test   %r13b,%r13b
124bea8 je     124befb <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x128b>
124beaa test   %r14b,%r14b
124bead je     124c344 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x16d4>
124beb3 vmovapd 0x1c0(%rsp),%ymm3
124bebc vmulpd %ymm3,%ymm3,%ymm1
124bec0 vmovapd 0xa0(%rsp),%ymm2
124bec9 vsubpd %ymm3,%ymm2,%ymm2
124becd vmulpd %ymm2,%ymm3,%ymm2
124bed1 vmovapd 0x4a0(%rsp),%ymm3
124beda vfmadd213pd %ymm2,%ymm1,%ymm3
124bedf vbroadcastsd %xmm0,%ymm1
124bee4 vmovapd 0x80(%rsp),%ymm2
124beed vfmadd231pd %ymm1,%ymm3,%ymm2
124bef2 vmovapd %ymm2,0x80(%rsp)
124befb cmpb   $0x0,0x98(%rbp)
124bf02 jne    124bf11 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12a1>
124bf04 cmpb   $0x0,0xa0(%rbp)
124bf0b je     124c307 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1697>
124bf11 vbroadcastsd %xmm0,%ymm0
124bf16 vmulpd 0x2a0(%rsp),%ymm0,%ymm0
124bf1f cmpb   $0x0,0x98(%rbp)
124bf26 je     124bf79 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1309>
124bf28 vmovapd 0x140(%rsp),%ymm1
124bf31 vfnmadd231pd 0x220(%rsp),%ymm0,%ymm1
124bf3b vmovapd %ymm1,0x140(%rsp)
124bf44 vmovapd 0x160(%rsp),%ymm1
124bf4d vfnmadd231pd 0x420(%rsp),%ymm0,%ymm1
124bf57 vmovapd %ymm1,0x160(%rsp)
124bf60 vmovapd 0x180(%rsp),%ymm1
124bf69 vfnmadd231pd 0x20(%rsp),%ymm0,%ymm1
124bf70 vmovapd %ymm1,0x180(%rsp)
124bf79 cmpb   $0x0,0xa0(%rbp)
124bf80 je     124c307 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1697>
124bf86 vxorpd 0x2c0(%rsp),%ymm0,%ymm0
124bf8f test   %r14b,%r14b
124bf92 je     124c072 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1402>
124bf98 vmovapd 0x2e0(%rsp),%ymm1
124bfa1 vmovapd 0x300(%rsp),%ymm2
124bfaa vblendvpd %ymm2,%ymm0,%ymm1,%ymm0
124bfb0 jmp    124c072 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1402>
124bfb5 vxorpd %xmm0,%xmm0,%xmm0
124bfb9 cmpb   $0x0,0xa0(%rbp)
124bfc0 jne    124c072 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1402>
124bfc6 jmp    124c307 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1697>
124bfcb vbroadcastsd %xmm0,%ymm0
124bfd0 vmulpd 0x320(%rsp),%ymm0,%ymm0
124bfd9 cmpb   $0x0,0x98(%rbp)
124bfe0 je     124c036 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x13c6>
124bfe2 vmovapd 0x140(%rsp),%ymm1
124bfeb vfnmadd231pd 0x200(%rsp),%ymm0,%ymm1
124bff5 vmovapd %ymm1,0x140(%rsp)
124bffe vmovapd 0x160(%rsp),%ymm1
124c007 vfnmadd231pd 0xc0(%rsp),%ymm0,%ymm1
124c011 vmovapd %ymm1,0x160(%rsp)
124c01a vmovapd 0x180(%rsp),%ymm1
124c023 vfnmadd231pd 0x1e0(%rsp),%ymm0,%ymm1
124c02d vmovapd %ymm1,0x180(%rsp)
124c036 cmpb   $0x0,0xa0(%rbp)
124c03d je     124c2f2 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1682>
124c043 vmovapd 0xe0(%rsp),%ymm1
124c04c vsubpd %ymm0,%ymm1,%ymm1
124c050 vmovapd %ymm1,0xe0(%rsp)
124c059 vmovsd 0x48(%r12),%xmm1
124c060 vxorpd %xmm0,%xmm0,%xmm0
124c064 vxorpd %xmm2,%xmm2,%xmm2
124c068 vucomisd %xmm2,%xmm1
124c06c ja     124be9f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x122f>
124c072 vmovapd 0xe0(%rsp),%ymm7
124c07b vsubpd %ymm7,%ymm0,%ymm0
124c07f vmovapd 0x240(%rsp),%ymm4
124c088 vmulpd %ymm4,%ymm0,%ymm1
124c08c vmovapd 0x260(%rsp),%ymm6
124c095 vmulpd %ymm6,%ymm0,%ymm2
124c099 vmovapd 0x100(%rsp),%ymm5
124c0a2 vmulpd %ymm5,%ymm0,%ymm0
124c0a6 vfmadd213pd %ymm7,%ymm1,%ymm4
124c0ab vmovapd 0x340(%rsp),%ymm3
124c0b4 vaddpd %ymm4,%ymm3,%ymm3
124c0b8 vmovapd %ymm3,0x340(%rsp)
124c0c1 vmovapd %ymm6,%ymm3
124c0c5 vfmadd213pd %ymm7,%ymm2,%ymm3
124c0ca vmovapd 0x360(%rsp),%ymm4
124c0d3 vaddpd %ymm3,%ymm4,%ymm4
124c0d7 vmovapd %ymm4,0x360(%rsp)
124c0e0 vfmadd213pd %ymm7,%ymm5,%ymm0
124c0e5 vmovapd 0x3e0(%rsp),%ymm3
124c0ee vaddpd %ymm0,%ymm3,%ymm3
124c0f2 vmovapd %ymm3,0x3e0(%rsp)
124c0fb vmovapd 0x380(%rsp),%ymm0
124c104 vfmadd231pd %ymm6,%ymm1,%ymm0
124c109 vmovapd %ymm0,0x380(%rsp)
124c112 vmovapd 0x3c0(%rsp),%ymm0
124c11b vfmadd231pd %ymm1,%ymm5,%ymm0
124c120 vmovapd %ymm0,0x3c0(%rsp)
124c129 vmovapd 0x3a0(%rsp),%ymm0
124c132 vfmadd231pd %ymm5,%ymm2,%ymm0
124c137 vmovapd %ymm0,0x3a0(%rsp)
124c140 cmpb   $0x0,0x6(%r15)
124c145 je     124c221 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x15b1>
124c14b mov    0xbba0c6(%rip),%rax        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124c152 movzbl (%rax),%eax
124c155 test   %al,%al
124c157 je     124c5ed <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x197d>
124c15d mov    0xbc96bc(%rip),%rax        # 1e15820 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2ead0>
124c164 vmovsd (%rax),%xmm1
124c168 vxorpd %xmm0,%xmm0,%xmm0
124c16c vucomisd %xmm0,%xmm1
124c170 jbe    124c307 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1697>
124c176 vmovsd 0x38(%r12),%xmm1
124c17d vucomisd %xmm0,%xmm1
124c181 ja     124c236 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x15c6>
124c187 jmp    124c307 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1697>
124c18c vmovapd 0x1a0(%rsp),%ymm8
124c195 vdivpd %ymm2,%ymm8,%ymm0
124c199 vcmplepd %ymm8,%ymm2,%ymm3
124c19f vbroadcastsd 0x82b810(%rip),%ymm1        # 1a779b8 <_fini+0xe84>
124c1a8 vmovapd %ymm1,%ymm4
124c1ac vfnmadd213pd %ymm8,%ymm2,%ymm4
124c1b1 vmulpd %ymm0,%ymm8,%ymm5
124c1b5 vbroadcastsd 0x82b6ca(%rip),%ymm6        # 1a77888 <_fini+0xd54>
124c1be vfnmadd213pd %ymm6,%ymm0,%ymm1
124c1c3 vmulpd %ymm1,%ymm5,%ymm1
124c1c7 vblendvpd %ymm3,%ymm4,%ymm1,%ymm1
124c1cd vxorpd %xmm4,%xmm4,%xmm4
124c1d1 vsubpd %ymm0,%ymm6,%ymm5
124c1d5 vbroadcastsd 0x82b76a(%rip),%ymm7        # 1a77948 <_fini+0xe14>
124c1de vaddpd %ymm5,%ymm5,%ymm5
124c1e2 vdivpd %ymm2,%ymm5,%ymm5
124c1e6 vandnpd %ymm5,%ymm3,%ymm5
124c1ea vmovapd %ymm5,0x120(%rsp)
124c1f3 vdivpd %ymm8,%ymm6,%ymm5
124c1f8 vsubpd %ymm0,%ymm7,%ymm0
124c1fc vdivpd %ymm2,%ymm0,%ymm0
124c200 vcmpneqpd %ymm4,%ymm8,%ymm2
124c205 vandpd %ymm5,%ymm2,%ymm2
124c209 vblendvpd %ymm3,%ymm2,%ymm0,%ymm0
124c20f cmpb   $0x0,0x90(%rbp)
124c216 jne    124bc34 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfc4>
124c21c jmp    124bc51 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfe1>
124c221 vmovsd 0x38(%r12),%xmm0
124c228 vxorpd %xmm1,%xmm1,%xmm1
124c22c vucomisd %xmm1,%xmm0
124c230 jbe    124c307 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1697>
124c236 vmovapd 0x480(%rsp),%ymm5
124c23f vmovapd 0x120(%rsp),%ymm2
124c248 vmulpd %ymm2,%ymm5,%ymm0
124c24c vmovapd 0x400(%rsp),%ymm4
124c255 vmulpd %ymm2,%ymm4,%ymm1
124c259 vmovapd 0x460(%rsp),%ymm6
124c262 vmulpd %ymm2,%ymm6,%ymm2
124c266 vmovapd 0x340(%rsp),%ymm3
124c26f vfmadd231pd %ymm5,%ymm0,%ymm3
124c274 vmovapd %ymm3,0x340(%rsp)
124c27d vmovapd 0x360(%rsp),%ymm3
124c286 vfmadd231pd %ymm1,%ymm4,%ymm3
124c28b vmovapd %ymm3,0x360(%rsp)
124c294 vmovapd 0x3e0(%rsp),%ymm3
124c29d vfmadd231pd %ymm2,%ymm6,%ymm3
124c2a2 vmovapd %ymm3,0x3e0(%rsp)
124c2ab vmovapd 0x380(%rsp),%ymm2
124c2b4 vfmadd231pd %ymm4,%ymm0,%ymm2
124c2b9 vmovapd %ymm2,0x380(%rsp)
124c2c2 vmovapd 0x3c0(%rsp),%ymm2
124c2cb vfmadd231pd %ymm0,%ymm6,%ymm2
124c2d0 vmovapd %ymm2,0x3c0(%rsp)
124c2d9 vmovapd 0x3a0(%rsp),%ymm0
124c2e2 vfmadd231pd %ymm1,%ymm6,%ymm0
124c2e7 vmovapd %ymm0,0x3a0(%rsp)
124c2f0 jmp    124c307 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1697>
124c2f2 vmovsd 0x48(%r12),%xmm1
124c2f9 vxorpd %xmm0,%xmm0,%xmm0
124c2fd vucomisd %xmm0,%xmm1
124c301 ja     124be9f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x122f>
124c307 test   %r13b,%r13b
124c30a jne    124c317 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x16a7>
124c30c vbroadcastsd 0x82b56b(%rip),%ymm0        # 1a77880 <_fini+0xd4c>
124c315 jmp    124c329 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x16b9>
124c317 vmovapd 0x80(%rsp),%ymm0
124c320 vmulpd 0x2a0(%rsp),%ymm0,%ymm0
124c329 vmovapd 0x4c0(%rsp),%ymm1
124c332 vaddpd %ymm0,%ymm1,%ymm0
124c336 test   %r13b,%r13b
124c339 jne    124b146 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4d6>
124c33f jmp    124b152 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4e2>
124c344 vmulsd 0x82b56c(%rip),%xmm0,%xmm1        # 1a778b8 <_fini+0xd84>
124c34c vmovapd 0xa0(%rsp),%ymm2
124c355 vmulpd %ymm2,%ymm2,%ymm2
124c359 vbroadcastsd %xmm1,%ymm1
124c35e vmovapd 0x80(%rsp),%ymm3
124c367 vfmadd231pd %ymm1,%ymm2,%ymm3
124c36c vmovapd %ymm3,0x80(%rsp)
124c375 cmpb   $0x0,0x98(%rbp)
124c37c je     124bf04 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1294>
124c382 jmp    124bf11 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12a1>
124c387 test   %al,%al
124c389 je     124c3c6 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1756>
124c38b vmovapd 0x2c0(%rsp),%ymm6
124c394 vxorpd 0x120(%rsp),%ymm6,%ymm2
124c39d vblendvpd %ymm1,%ymm2,%ymm5,%ymm5
124c3a3 vxorpd 0x300(%rsp),%ymm6,%ymm2
124c3ac vblendvpd %ymm1,%ymm2,%ymm4,%ymm4
124c3b2 vxorpd 0xe0(%rsp),%ymm6,%ymm2
124c3bb vblendvpd %ymm1,%ymm2,%ymm3,%ymm3
124c3c1 jmp    124b8fe <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc8e>
124c3c6 vandnpd %ymm5,%ymm1,%ymm5
124c3ca vandnpd %ymm4,%ymm1,%ymm4
124c3ce vandnpd %ymm3,%ymm1,%ymm3
124c3d2 jmp    124b8fe <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc8e>
124c3d7 mov    0xbbf33a(%rip),%rdi        # 1e0b718 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6b0>
124c3de vmovapd %ymm9,0x20(%rsp)
124c3e4 vmovapd %ymm12,0x60(%rsp)
124c3ea vmovapd %ymm13,0xc0(%rsp)
124c3f3 vzeroupper
124c3f6 call   7b7240 <__cxa_guard_acquire@plt>
124c3fb vmovapd 0xc0(%rsp),%ymm13
124c404 vmovapd 0x60(%rsp),%ymm12
124c40a vmovapd 0x20(%rsp),%ymm9
124c410 test   %eax,%eax
124c412 je     124b6b0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa40>
124c418 lea    0x8473fa(%rip),%rdi        # 1a93819 <_fini+0x1cce5>
124c41f vzeroupper
124c422 call   7c87b0 <getenv@plt>
124c427 test   %rax,%rax
124c42a mov    0xbc3a57(%rip),%rax        # 1e0fe88 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f38>
124c431 setne  (%rax)
124c434 mov    0xbbf2dd(%rip),%rdi        # 1e0b718 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6b0>
124c43b call   7bef10 <__cxa_guard_release@plt>
124c440 vmovapd 0xc0(%rsp),%ymm13
124c449 vmovapd 0x60(%rsp),%ymm12
124c44f vmovapd 0x20(%rsp),%ymm9
124c455 jmp    124b6b0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa40>
124c45a mov    0xbb9db7(%rip),%rdi        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124c461 vzeroupper
124c464 call   7b7240 <__cxa_guard_acquire@plt>
124c469 test   %eax,%eax
124c46b je     124b2f1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x681>
124c471 lea    0x53c(%rsp),%rdi
124c479 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124c47e mov    0xbc939b(%rip),%rax        # 1e15820 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2ead0>
124c485 vmovsd %xmm0,(%rax)
124c489 mov    0xbb9d88(%rip),%rdi        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124c490 call   7bef10 <__cxa_guard_release@plt>
124c495 jmp    124b2f1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x681>
124c49a mov    0xbbf277(%rip),%rdi        # 1e0b718 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6b0>
124c4a1 vmovapd %ymm9,0x20(%rsp)
124c4a7 vmovapd %ymm12,0x60(%rsp)
124c4ad vmovapd %ymm7,0x40(%rsp)
124c4b3 vzeroupper
124c4b6 call   7b7240 <__cxa_guard_acquire@plt>
124c4bb vmovapd 0x40(%rsp),%ymm7
124c4c1 vmovapd 0x60(%rsp),%ymm12
124c4c7 vmovapd 0x20(%rsp),%ymm9
124c4cd vmovapd 0x100(%rsp),%ymm0
124c4d6 test   %eax,%eax
124c4d8 je     124b971 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd01>
124c4de lea    0x847334(%rip),%rdi        # 1a93819 <_fini+0x1cce5>
124c4e5 vzeroupper
124c4e8 call   7c87b0 <getenv@plt>
124c4ed test   %rax,%rax
124c4f0 setne  0x0(%r13)
124c4f5 mov    0xbbf21c(%rip),%rdi        # 1e0b718 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6b0>
124c4fc call   7bef10 <__cxa_guard_release@plt>
124c501 vmovapd 0x40(%rsp),%ymm7
124c507 vmovapd 0x60(%rsp),%ymm12
124c50d vmovapd 0x20(%rsp),%ymm9
124c513 vmovapd 0x100(%rsp),%ymm0
124c51c jmp    124b971 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd01>
124c521 mov    0xbc68c0(%rip),%rdi        # 1e12de8 <_ZGVZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x36ff0>
124c528 vmovapd %ymm9,0x20(%rsp)
124c52e vmovapd %ymm12,0x60(%rsp)
124c534 vmovapd %ymm7,0x40(%rsp)
124c53a vzeroupper
124c53d call   7b7240 <__cxa_guard_acquire@plt>
124c542 vmovapd 0x40(%rsp),%ymm7
124c548 vmovapd 0x60(%rsp),%ymm12
124c54e vmovapd 0x20(%rsp),%ymm9
124c554 vmovapd 0x100(%rsp),%ymm0
124c55d test   %eax,%eax
124c55f je     124b98c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd1c>
124c565 lea    0x8472c9(%rip),%rdi        # 1a93835 <_fini+0x1cd01>
124c56c vzeroupper
124c56f call   7c87b0 <getenv@plt>
124c574 test   %rax,%rax
124c577 mov    0xbbb55a(%rip),%rax        # 1e07ad8 <_ZZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x422f8>
124c57e setne  (%rax)
124c581 mov    0xbc6860(%rip),%rdi        # 1e12de8 <_ZGVZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x36ff0>
124c588 call   7bef10 <__cxa_guard_release@plt>
124c58d vmovapd 0x40(%rsp),%ymm7
124c593 vmovapd 0x60(%rsp),%ymm12
124c599 vmovapd 0x20(%rsp),%ymm9
124c59f vmovapd 0x100(%rsp),%ymm0
124c5a8 jmp    124b98c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd1c>
124c5ad mov    0xbb9c64(%rip),%rdi        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124c5b4 vzeroupper
124c5b7 call   7b7240 <__cxa_guard_acquire@plt>
124c5bc test   %eax,%eax
124c5be je     124bb7b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf0b>
124c5c4 lea    0x53d(%rsp),%rdi
124c5cc call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124c5d1 mov    0xbc9248(%rip),%rax        # 1e15820 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2ead0>
124c5d8 vmovsd %xmm0,(%rax)
124c5dc mov    0xbb9c35(%rip),%rdi        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124c5e3 call   7bef10 <__cxa_guard_release@plt>
124c5e8 jmp    124bb7b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf0b>
124c5ed mov    0xbb9c24(%rip),%rdi        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124c5f4 vzeroupper
124c5f7 call   7b7240 <__cxa_guard_acquire@plt>
124c5fc test   %eax,%eax
124c5fe je     124c15d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x14ed>
124c604 lea    0x53f(%rsp),%rdi
124c60c call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124c611 mov    0xbc9208(%rip),%rax        # 1e15820 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2ead0>
124c618 vmovsd %xmm0,(%rax)
124c61c mov    0xbb9bf5(%rip),%rdi        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124c623 call   7bef10 <__cxa_guard_release@plt>
124c628 jmp    124c15d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x14ed>
124c62d mov    0xbb9be4(%rip),%rdi        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124c634 vzeroupper
124c637 call   7b7240 <__cxa_guard_acquire@plt>
124c63c test   %eax,%eax
124c63e je     124bd28 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x10b8>
124c644 lea    0x53e(%rsp),%rdi
124c64c call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124c651 vmovsd %xmm0,0x0(%r13)
124c657 mov    0xbb9bba(%rip),%rdi        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124c65e call   7bef10 <__cxa_guard_release@plt>
124c663 jmp    124bd28 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x10b8>
124c668 jmp    124c66e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x19fe>
124c66a jmp    124c66e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x19fe>
124c66c jmp    124c66e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x19fe>
124c66e mov    %rax,%rbx
124c671 mov    0xbb9ba0(%rip),%rdi        # 1e06218 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0e0>
124c678 call   7b9b70 <__cxa_guard_abort@plt>
124c67d mov    %fs:0x28,%rax
124c686 cmp    0x540(%rsp),%rax
124c68e jne    124c698 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1a28>
124c690 mov    %rbx,%rdi
124c693 call   7c3330 <_Unwind_Resume@plt>
124c698 vzeroupper
124c69b call   7b4ef0 <__stack_chk_fail@plt>

Disassembly of section .fini:
