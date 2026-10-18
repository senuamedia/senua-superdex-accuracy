
lib/v_onlyEigT/libmochi_physics_double.so:     file format elf64-x86-64


Disassembly of section .init:

Disassembly of section .plt:

Disassembly of section .plt.got:

Disassembly of section .text:

000000000124b2d0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_>:
124b2d0 push   %rbp
124b2d1 mov    %rsp,%rbp
124b2d4 push   %r15
124b2d6 push   %r14
124b2d8 push   %r13
124b2da push   %r12
124b2dc push   %rbx
124b2dd and    $0xffffffffffffffe0,%rsp
124b2e1 sub    $0x5c0,%rsp
124b2e8 vmovsd %xmm0,0x18(%rsp)
124b2ee mov    %r8,%rbx
124b2f1 mov    %rdx,0x258(%rsp)
124b2f9 mov    %rdi,0x250(%rsp)
124b301 mov    0x88(%rbp),%r15
124b308 mov    %fs:0x28,%rax
124b311 mov    %rax,0x5a0(%rsp)
124b319 mov    0x20(%rbp),%rax
124b31d vmovupd (%rax),%ymm0
124b321 vmovupd 0x20(%rax),%ymm1
124b326 vmovupd 0x40(%rax),%ymm2
124b32b vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b331 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b337 vblendpd $0xa,%ymm4,%ymm3,%ymm3
124b33d vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b343 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b349 vshufpd $0x5,%ymm1,%ymm0,%ymm2
124b34e cmpb   $0x0,0x3(%r15)
124b353 vblendpd $0xa,%ymm1,%ymm4,%ymm0
124b359 vmovapd %ymm0,0x180(%rsp)
124b362 vmovapd %ymm0,0x60(%rsp)
124b368 vmovapd %ymm2,0x80(%rsp)
124b371 vmovapd %ymm2,0xc0(%rsp)
124b37a vmovapd %ymm3,0x1a0(%rsp)
124b383 vmovapd %ymm3,0xa0(%rsp)
124b38c je     124b3e4 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x114>
124b38e lea    0x40(%rbp),%rax
124b392 mov    (%rax),%rax
124b395 vmovupd (%rax),%ymm0
124b399 vmovupd 0x20(%rax),%ymm1
124b39e vmovupd 0x40(%rax),%ymm2
124b3a3 vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b3a9 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b3af vblendpd $0xa,%ymm4,%ymm3,%ymm3
124b3b5 vmovapd %ymm3,0xa0(%rsp)
124b3be vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b3c4 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b3ca vshufpd $0x5,%ymm1,%ymm0,%ymm0
124b3cf vmovapd %ymm0,0xc0(%rsp)
124b3d8 vblendpd $0xa,%ymm1,%ymm4,%ymm0
124b3de vmovapd %ymm0,0x60(%rsp)
124b3e4 mov    0x80(%rbp),%r12
124b3eb movzbl 0x2(%r15),%eax
124b3f0 test   %al,%al
124b3f2 je     124b469 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x199>
124b3f4 lea    0x50(%rbp),%rcx
124b3f8 mov    (%rcx),%rcx
124b3fb vmovupd (%rcx),%ymm0
124b3ff vmovupd 0x20(%rcx),%ymm1
124b404 vmovupd 0x40(%rcx),%ymm2
124b409 vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b40f vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b415 vblendpd $0xa,%ymm4,%ymm3,%ymm3
124b41b vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b421 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b427 vshufpd $0x5,%ymm1,%ymm0,%ymm0
124b42c vblendpd $0xa,%ymm1,%ymm4,%ymm1
124b432 vmovapd %ymm0,0x260(%rsp)
124b43b vmulpd 0xc0(%rsp),%ymm0,%ymm0
124b444 vmovapd %ymm3,0x4e0(%rsp)
124b44d vfmadd231pd 0xa0(%rsp),%ymm3,%ymm0
124b457 vmovapd %ymm1,0x280(%rsp)
124b460 vfmadd231pd 0x60(%rsp),%ymm1,%ymm0
124b467 jmp    124b472 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1a2>
124b469 vbroadcastsd 0x82e496(%rip),%ymm0        # 1a79908 <_fini+0x10b4>
124b472 vbroadcastsd 0x28(%r12),%ymm1
124b479 vbroadcastsd 0x82e406(%rip),%ymm2        # 1a79888 <_fini+0x1034>
124b482 vmovapd %ymm2,0x100(%rsp)
124b48b test   %al,%al
124b48d je     124b4be <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1ee>
124b48f cmpb   $0x0,0x4(%r15)
124b494 je     124b4be <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1ee>
124b496 vucomisd 0x82e46a(%rip),%xmm1        # 1a79908 <_fini+0x10b4>
124b49e jbe    124b4be <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1ee>
124b4a0 vsubpd %ymm0,%ymm1,%ymm2
124b4a4 vbroadcastsd 0x82e3db(%rip),%ymm3        # 1a79888 <_fini+0x1034>
124b4ad vaddpd %ymm3,%ymm1,%ymm3
124b4b1 vdivpd %ymm3,%ymm2,%ymm2
124b4b5 vmovapd %ymm2,0x100(%rsp)
124b4be mov    0x10(%rbp),%rcx
124b4c2 vmovsd 0x38(%r12),%xmm3
124b4c9 vxorpd %xmm2,%xmm2,%xmm2
124b4cd vucomisd %xmm2,%xmm3
124b4d1 mov    $0x1,%al
124b4d3 ja     124b4f4 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x224>
124b4d5 vmovsd 0x30(%r12),%xmm3
124b4dc vucomisd %xmm2,%xmm3
124b4e0 ja     124b4f4 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x224>
124b4e2 vmovsd 0x48(%r12),%xmm3
124b4e9 vxorpd %xmm4,%xmm4,%xmm4
124b4ed vucomisd %xmm4,%xmm3
124b4f1 seta   %al
124b4f4 movzbl 0x90(%rbp),%r13d
124b4fc vmovups (%rcx),%ymm3
124b500 vmovaps %ymm3,0x2c0(%rsp)
124b509 vcmplepd %ymm1,%ymm0,%ymm0
124b50e vmovapd %ymm0,0x20(%rsp)
124b514 cmpb   $0x0,0x5(%r15)
124b519 setne  %r14b
124b51d cmpb   $0x0,0x1(%r15)
124b522 vmovsd 0x8(%r12),%xmm1
124b529 je     124b532 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x262>
124b52b vmovsd 0x18(%r12),%xmm2
124b532 vaddsd 0x10(%r12),%xmm2,%xmm2
124b539 vbroadcastsd 0x8(%r12),%ymm0
124b540 vbroadcastsd 0x82e337(%rip),%ymm3        # 1a79880 <_fini+0x102c>
124b549 vmovapd %ymm3,0x300(%rsp)
124b552 vxorpd 0x2c0(%rsp),%ymm3,%ymm3
124b55b vsubsd %xmm2,%xmm1,%xmm1
124b55f vbroadcastsd %xmm1,%ymm1
124b564 vmovapd %ymm3,0x440(%rsp)
124b56d vsubpd %ymm1,%ymm3,%ymm5
124b571 vdivpd %ymm0,%ymm5,%ymm4
124b575 vmulpd %ymm4,%ymm4,%ymm2
124b579 vmulpd %ymm2,%ymm4,%ymm6
124b57d vxorpd %xmm1,%xmm1,%xmm1
124b581 vcmplepd %ymm1,%ymm0,%ymm3
124b586 vbroadcastsd 0x82e319(%rip),%ymm7        # 1a798a8 <_fini+0x1054>
124b58f vmovapd %ymm7,0x340(%rsp)
124b598 vandpd %ymm7,%ymm5,%ymm7
124b59c vcmpltpd %ymm7,%ymm0,%ymm7
124b5a1 vbroadcastsd 0x82e706(%rip),%ymm9        # 1a79cb0 <_fini+0x145c>
124b5aa vbroadcastsd 0x82e705(%rip),%ymm10        # 1a79cb8 <_fini+0x1464>
124b5b3 vbroadcastsd 0x82e2fc(%rip),%ymm8        # 1a798b8 <_fini+0x1064>
124b5bc vorpd  %ymm3,%ymm7,%ymm3
124b5c0 vmovapd %ymm10,0x2a0(%rsp)
124b5c9 vmovapd %ymm10,%ymm7
124b5cd vbroadcastsd 0x82e70a(%rip),%ymm10        # 1a79ce0 <_fini+0x148c>
124b5d6 vfmadd213pd %ymm8,%ymm4,%ymm7
124b5db vmovapd %ymm10,0xe0(%rsp)
124b5e4 vfmadd231pd %ymm10,%ymm6,%ymm7
124b5e9 vmulpd %ymm7,%ymm5,%ymm7
124b5ed vmovapd %ymm9,0x360(%rsp)
124b5f6 vfmadd231pd %ymm9,%ymm0,%ymm7
124b5fb vblendvpd %ymm3,%ymm5,%ymm7,%ymm7
124b601 vbroadcastsd 0x82e6be(%rip),%ymm9        # 1a79cc8 <_fini+0x1474>
124b60a vmovapd %ymm8,0x460(%rsp)
124b613 vmovapd %ymm9,0x220(%rsp)
124b61c vfmadd213pd %ymm8,%ymm9,%ymm4
124b621 vbroadcastsd 0x82e6be(%rip),%ymm8        # 1a79ce8 <_fini+0x1494>
124b62a vmovapd %ymm8,0x320(%rsp)
124b633 vfmadd231pd %ymm6,%ymm8,%ymm4
124b638 vcmpnltpd %ymm1,%ymm5,%ymm5
124b63d vbroadcastsd 0x82e242(%rip),%ymm6        # 1a79888 <_fini+0x1034>
124b646 vandpd %ymm6,%ymm5,%ymm5
124b64a vblendvpd %ymm3,%ymm5,%ymm4,%ymm4
124b650 and    %al,%r14b
124b653 vmaxpd %ymm7,%ymm1,%ymm5
124b657 vmaxpd %ymm4,%ymm1,%ymm4
124b65b vmovapd %ymm6,0x40(%rsp)
124b661 vminpd %ymm4,%ymm6,%ymm6
124b665 vandpd 0x20(%rsp),%ymm5,%ymm4
124b66b vbroadcastsd (%r12),%ymm5
124b671 test   %r13b,%r13b
124b674 je     124b694 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x3c4>
124b676 vmulsd 0x82e23a(%rip),%xmm5,%xmm7        # 1a798b8 <_fini+0x1064>
124b67e vmulpd %ymm4,%ymm4,%ymm8
124b682 vbroadcastsd %xmm7,%ymm7
124b687 vmulpd %ymm7,%ymm8,%ymm7
124b68b vmovapd %ymm7,0x500(%rsp)
124b694 vandpd 0x20(%rsp),%ymm6,%ymm6
124b69a mov    %r14d,%ecx
124b69d or     0x98(%rbp),%cl
124b6a3 cmp    $0x1,%cl
124b6a6 jne    124b701 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x431>
124b6a8 vmulpd %ymm4,%ymm5,%ymm7
124b6ac vmulpd %ymm6,%ymm7,%ymm7
124b6b0 cmpb   $0x0,0x98(%rbp)
124b6b7 je     124b6ef <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x41f>
124b6b9 vmulpd 0x1a0(%rsp),%ymm7,%ymm8
124b6c2 vmovapd %ymm8,0x1c0(%rsp)
124b6cb vmulpd 0x80(%rsp),%ymm7,%ymm8
124b6d4 vmovapd %ymm8,0x1e0(%rsp)
124b6dd vmulpd 0x180(%rsp),%ymm7,%ymm8
124b6e6 vmovapd %ymm8,0x200(%rsp)
124b6ef vmulpd 0x100(%rsp),%ymm7,%ymm7
124b6f8 vmovapd %ymm7,0x2e0(%rsp)
124b701 cmpb   $0x0,0xa0(%rbp)
124b708 je     124b873 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x5a3>
124b70e vmovapd 0x40(%rsp),%ymm7
124b714 vsubpd %ymm2,%ymm7,%ymm2
124b718 vmulpd 0x220(%rsp),%ymm2,%ymm2
124b721 vdivpd %ymm0,%ymm2,%ymm0
124b725 vandnpd %ymm0,%ymm3,%ymm0
124b729 vmaxpd %ymm0,%ymm1,%ymm0
124b72d vandpd 0x20(%rsp),%ymm0,%ymm0
124b733 vxorpd 0x300(%rsp),%ymm5,%ymm1
124b73c vmulpd %ymm0,%ymm4,%ymm0
124b740 vfmadd213pd %ymm0,%ymm6,%ymm6
124b745 vmulpd %ymm1,%ymm6,%ymm0
124b749 vmovapd 0x1a0(%rsp),%ymm3
124b752 vmulpd %ymm0,%ymm3,%ymm1
124b756 vmovapd 0x80(%rsp),%ymm5
124b75f vmulpd %ymm0,%ymm5,%ymm2
124b763 vmovapd 0x180(%rsp),%ymm4
124b76c vmulpd %ymm0,%ymm4,%ymm0
124b770 vmulpd %ymm1,%ymm3,%ymm3
124b774 vmovapd %ymm3,0x380(%rsp)
124b77d vmulpd %ymm2,%ymm5,%ymm3
124b781 vmovapd %ymm3,0x3a0(%rsp)
124b78a vmulpd %ymm0,%ymm4,%ymm0
124b78e vmovapd %ymm0,0x420(%rsp)
124b797 vmulpd %ymm1,%ymm5,%ymm0
124b79b vmovapd %ymm0,0x3c0(%rsp)
124b7a4 vmulpd %ymm1,%ymm4,%ymm0
124b7a8 vmovapd %ymm0,0x400(%rsp)
124b7b1 vmulpd %ymm2,%ymm4,%ymm0
124b7b5 vmovapd %ymm0,0x3e0(%rsp)
124b7be test   %al,%al
124b7c0 jne    124b87b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x5ab>
124b7c6 vmovapd 0x500(%rsp),%ymm0
124b7cf test   %r13b,%r13b
124b7d2 je     124b7e0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x510>
124b7d4 mov    0x250(%rsp),%rax
124b7dc vmovupd %ymm0,(%rax)
124b7e0 cmpb   $0x0,0x98(%rbp)
124b7e7 je     124ba77 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x7a7>
124b7ed vmovapd 0x1c0(%rsp),%ymm4
124b7f6 vpermpd $0x6c,%ymm4,%ymm0
124b7fc vmovapd 0x200(%rsp),%ymm2
124b805 vpermpd $0xc6,%ymm2,%ymm1
124b80b vblendpd $0xa,%ymm0,%ymm1,%ymm0
124b811 vmovapd 0x1e0(%rsp),%ymm3
124b81a vunpcklpd %ymm3,%ymm4,%ymm1
124b81e vunpckhpd %ymm2,%ymm3,%ymm2
124b822 vblendpd $0xc,%ymm0,%ymm1,%ymm3
124b828 mov    0x258(%rsp),%rax
124b830 vmovupd %ymm3,(%rax)
124b834 vblendpd $0xc,%ymm1,%ymm2,%ymm1
124b83a vmovupd %ymm1,0x20(%rax)
124b83f vblendpd $0xc,%ymm2,%ymm0,%ymm0
124b845 vmovupd %ymm0,0x40(%rax)
124b84a cmpb   $0x0,0xa0(%rbp)
124b851 jne    124ba84 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x7b4>
124b857 mov    %fs:0x28,%rax
124b860 cmp    0x5a0(%rsp),%rax
124b868 je     124bc1c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x94c>
124b86e jmp    124ceef <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1c1f>
124b873 test   %al,%al
124b875 je     124b7c6 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x4f6>
124b87b lea    0xb0(%rbp),%r13
124b882 lea    0x70(%rbp),%rax
124b886 lea    0x60(%rbp),%rcx
124b88a mov    (%rcx),%rcx
124b88d vmovupd (%rcx),%ymm0
124b891 vmovupd 0x20(%rcx),%ymm1
124b896 vmovupd 0x40(%rcx),%ymm2
124b89b vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b8a1 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b8a7 vblendpd $0xa,%ymm4,%ymm3,%ymm6
124b8ad vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b8b3 vblendpd $0x4,%ymm2,%ymm0,%ymm0
124b8b9 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b8bf vblendpd $0xa,%ymm1,%ymm4,%ymm7
124b8c5 mov    (%rax),%rax
124b8c8 vmovupd (%rax),%ymm1
124b8cc vmovupd 0x20(%rax),%ymm2
124b8d1 vmovupd 0x40(%rax),%ymm3
124b8d6 vblendpd $0x4,%ymm2,%ymm1,%ymm4
124b8dc vperm2f128 $0x21,%ymm3,%ymm1,%ymm5
124b8e2 vblendpd $0xa,%ymm5,%ymm4,%ymm4
124b8e8 vblendpd $0x2,%ymm1,%ymm2,%ymm1
124b8ee vblendpd $0xc,%ymm3,%ymm2,%ymm2
124b8f4 vblendpd $0xa,%ymm2,%ymm5,%ymm3
124b8fa vmovapd %ymm6,0x560(%rsp)
124b903 vsubpd %ymm4,%ymm6,%ymm4
124b907 vshufpd $0x5,%ymm2,%ymm1,%ymm1
124b90c vshufpd $0x5,%ymm0,%ymm0,%ymm0
124b911 vmovapd %ymm0,0x520(%rsp)
124b91a vsubpd %ymm1,%ymm0,%ymm1
124b91e cmpq   $0x4,0x8(%r13)
124b923 vmovapd %ymm7,0x540(%rsp)
124b92c vsubpd %ymm3,%ymm7,%ymm0
124b930 vmovapd %ymm0,0x4a0(%rsp)
124b939 vmovapd %ymm0,0x160(%rsp)
124b942 vmovapd %ymm1,0x120(%rsp)
124b94b vmovapd %ymm4,0x4c0(%rsp)
124b954 vmovapd %ymm4,0x140(%rsp)
124b95d jne    124ba53 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x783>
124b963 vmovapd %ymm1,0x480(%rsp)
124b96c mov    0xbbc895(%rip),%rax        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124b973 movzbl (%rax),%eax
124b976 test   %al,%al
124b978 je     124cce5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1a15>
124b97e mov    0xbcbe8b(%rip),%rax        # 1e17810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124b985 vmovsd (%rax),%xmm0
124b989 vxorpd %xmm1,%xmm1,%xmm1
124b98d vucomisd %xmm1,%xmm0
124b991 vmovaps 0x4a0(%rsp),%ymm0
124b99a vmovaps %ymm0,0x160(%rsp)
124b9a3 vmovapd 0x480(%rsp),%ymm1
124b9ac vmovapd %ymm1,0x120(%rsp)
124b9b5 vmovapd 0x4c0(%rsp),%ymm0
124b9be vmovapd %ymm0,0x140(%rsp)
124b9c7 jbe    124ba53 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x783>
124b9cd mov    0x0(%r13),%rax
124b9d1 vmovupd (%rax),%ymm0
124b9d5 vmovupd 0x20(%rax),%ymm1
124b9da vmovupd 0x40(%rax),%ymm2
124b9df vblendpd $0x4,%ymm1,%ymm0,%ymm3
124b9e5 vperm2f128 $0x21,%ymm2,%ymm0,%ymm4
124b9eb vblendpd $0xa,%ymm4,%ymm3,%ymm3
124b9f1 vblendpd $0x2,%ymm0,%ymm1,%ymm0
124b9f7 vblendpd $0xc,%ymm2,%ymm1,%ymm1
124b9fd vblendpd $0xa,%ymm1,%ymm4,%ymm2
124ba03 vmovapd 0x560(%rsp),%ymm4
124ba0c vsubpd %ymm3,%ymm4,%ymm3
124ba10 vmovapd %ymm3,0x140(%rsp)
124ba19 vshufpd $0x5,%ymm1,%ymm0,%ymm0
124ba1e vmovapd 0x480(%rsp),%ymm1
124ba27 vmovapd 0x520(%rsp),%ymm3
124ba30 vsubpd %ymm0,%ymm3,%ymm0
124ba34 vmovapd %ymm0,0x120(%rsp)
124ba3d vmovapd 0x540(%rsp),%ymm0
124ba46 vsubpd %ymm2,%ymm0,%ymm0
124ba4a vmovapd %ymm0,0x160(%rsp)
124ba53 test   %r14b,%r14b
124ba56 jne    124bd66 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xa96>
124ba5c cmpb   $0x0,0x3(%r15)
124ba61 je     124bc2e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x95e>
124ba67 lea    0x30(%rbp),%rax
124ba6b mov    (%rax),%rax
124ba6e vmovupd (%rax),%ymm1
124ba72 jmp    124bc6a <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x99a>
124ba77 cmpb   $0x0,0xa0(%rbp)
124ba7e je     124b857 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x587>
124ba84 vmovapd 0x380(%rsp),%ymm7
124ba8d vpermpd $0xff,%ymm7,%ymm0
124ba93 vmovapd 0x3c0(%rsp),%ymm8
124ba9c vextractf128 $0x1,%ymm8,%xmm3
124baa2 vblendpd $0x1,%ymm0,%ymm3,%ymm0
124baa8 vmovapd 0x400(%rsp),%ymm11
124bab1 vshufpd $0x4,%ymm11,%ymm11,%ymm1
124bab7 vblendpd $0x4,%ymm1,%ymm0,%ymm0
124babd vpermpd $0xff,%ymm8,%ymm1
124bac3 vmovapd 0x3a0(%rsp),%ymm9
124bacc vextractf128 $0x1,%ymm9,%xmm4
124bad2 vblendpd $0x1,%ymm1,%ymm4,%ymm1
124bad8 vmovapd 0x3e0(%rsp),%ymm12
124bae1 vshufpd $0x4,%ymm12,%ymm12,%ymm2
124bae7 vblendpd $0x4,%ymm2,%ymm1,%ymm1
124baed vextractf128 $0x1,%ymm7,%xmm2
124baf3 vshufpd $0x8,%ymm3,%ymm2,%ymm2
124baf8 vblendpd $0x4,%ymm11,%ymm2,%ymm2
124bafe vshufpd $0x8,%ymm4,%ymm3,%ymm3
124bb03 vblendpd $0x4,%ymm12,%ymm3,%ymm3
124bb09 vshufpd $0x1,%xmm7,%xmm7,%xmm4
124bb0e vmovapd %xmm8,%xmm5
124bb12 vinsertf128 $0x1,%xmm11,%ymm4,%ymm4
124bb18 vshufpd $0xe,%ymm5,%ymm4,%ymm4
124bb1d vshufpd $0x1,%xmm8,%xmm8,%xmm5
124bb23 vmovapd %xmm9,%xmm6
124bb27 vinsertf128 $0x1,%xmm12,%ymm5,%ymm5
124bb2d vshufpd $0xe,%ymm6,%ymm5,%ymm5
124bb32 vmovddup %xmm8,%xmm6
124bb37 vinsertf128 $0x1,%xmm11,%ymm7,%ymm7
124bb3d vblendpd $0xa,%ymm6,%ymm7,%ymm6
124bb43 vmovddup %xmm9,%xmm7
124bb48 vinsertf128 $0x1,%xmm12,%ymm8,%ymm8
124bb4e vblendpd $0xa,%ymm7,%ymm8,%ymm7
124bb54 vmovddup %xmm12,%xmm8
124bb59 vmovapd 0x420(%rsp),%ymm10
124bb62 vinsertf128 $0x1,%xmm10,%ymm11,%ymm9
124bb68 vblendpd $0xa,%ymm8,%ymm9,%ymm8
124bb6e vmovapd %ymm6,(%rbx)
124bb72 vmovapd %ymm7,0x20(%rbx)
124bb77 vmovapd %ymm8,0x40(%rbx)
124bb7c vshufpd $0x1,%xmm11,%xmm11,%xmm6
124bb82 vmovapd %xmm12,%xmm7
124bb86 vinsertf128 $0x1,%xmm10,%ymm6,%ymm6
124bb8c vshufpd $0xe,%ymm7,%ymm6,%ymm6
124bb91 vmovapd %ymm4,0x60(%rbx)
124bb96 vmovapd %ymm5,0x80(%rbx)
124bb9e vmovapd %ymm6,0xa0(%rbx)
124bba6 vextractf128 $0x1,%ymm11,%xmm4
124bbac vextractf128 $0x1,%ymm12,%xmm5
124bbb2 vshufpd $0x8,%ymm5,%ymm4,%ymm4
124bbb7 vblendpd $0x4,%ymm10,%ymm4,%ymm4
124bbbd vmovapd %ymm2,0xc0(%rbx)
124bbc5 vmovapd %ymm3,0xe0(%rbx)
124bbcd vmovapd %ymm4,0x100(%rbx)
124bbd5 vpermpd $0xff,%ymm11,%ymm2
124bbdb vblendpd $0x1,%ymm2,%ymm5,%ymm2
124bbe1 vshufpd $0x4,%ymm10,%ymm10,%ymm3
124bbe7 vblendpd $0x4,%ymm3,%ymm2,%ymm2
124bbed vmovapd %ymm0,0x120(%rbx)
124bbf5 vmovapd %ymm1,0x140(%rbx)
124bbfd vmovapd %ymm2,0x160(%rbx)
124bc05 mov    %fs:0x28,%rax
124bc0e cmp    0x5a0(%rsp),%rax
124bc16 jne    124ceef <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1c1f>
124bc1c lea    -0x28(%rbp),%rsp
124bc20 pop    %rbx
124bc21 pop    %r12
124bc23 pop    %r13
124bc25 pop    %r14
124bc27 pop    %r15
124bc29 pop    %rbp
124bc2a vzeroupper
124bc2d ret
124bc2e vmulpd 0x80(%rsp),%ymm1,%ymm0
124bc37 vmovapd 0x1a0(%rsp),%ymm1
124bc40 vfmadd132pd 0x4c0(%rsp),%ymm0,%ymm1
124bc4a vmovapd 0x180(%rsp),%ymm0
124bc53 vfmadd132pd 0x4a0(%rsp),%ymm1,%ymm0
124bc5d vmovapd 0x2c0(%rsp),%ymm1
124bc66 vsubpd %ymm0,%ymm1,%ymm1
124bc6a vbroadcastsd (%r12),%ymm0
124bc70 cmpb   $0x0,0x1(%r15)
124bc75 vmovsd 0x8(%r12),%xmm2
124bc7c vxorpd %xmm3,%xmm3,%xmm3
124bc80 je     124bc89 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x9b9>
124bc82 vmovsd 0x18(%r12),%xmm3
124bc89 vaddsd 0x10(%r12),%xmm3,%xmm3
124bc90 vbroadcastsd 0x8(%r12),%ymm4
124bc97 vxorpd 0x300(%rsp),%ymm1,%ymm1
124bca0 vsubsd %xmm3,%xmm2,%xmm2
124bca4 vbroadcastsd %xmm2,%ymm2
124bca9 vsubpd %ymm2,%ymm1,%ymm1
124bcad vdivpd %ymm4,%ymm1,%ymm2
124bcb1 vmulpd %ymm2,%ymm2,%ymm3
124bcb5 vmulpd %ymm3,%ymm2,%ymm3
124bcb9 vxorpd %xmm5,%xmm5,%xmm5
124bcbd vcmplepd %ymm5,%ymm4,%ymm6
124bcc2 vandpd 0x340(%rsp),%ymm1,%ymm7
124bccb vcmpltpd %ymm7,%ymm4,%ymm7
124bcd0 vorpd  %ymm6,%ymm7,%ymm6
124bcd4 vmovapd 0x2a0(%rsp),%ymm7
124bcdd vmovapd 0x460(%rsp),%ymm8
124bce6 vfmadd213pd %ymm8,%ymm2,%ymm7
124bceb vfmadd231pd 0xe0(%rsp),%ymm3,%ymm7
124bcf5 vmulpd %ymm7,%ymm1,%ymm7
124bcf9 vfmadd231pd 0x360(%rsp),%ymm4,%ymm7
124bd03 vfmadd132pd 0x220(%rsp),%ymm8,%ymm2
124bd0d vfmadd231pd 0x320(%rsp),%ymm3,%ymm2
124bd17 vblendvpd %ymm6,%ymm1,%ymm7,%ymm3
124bd1d vcmpnltpd %ymm5,%ymm1,%ymm1
124bd22 vmovapd 0x40(%rsp),%ymm4
124bd28 vandpd %ymm4,%ymm1,%ymm1
124bd2c vblendvpd %ymm6,%ymm1,%ymm2,%ymm1
124bd32 vmaxpd %ymm3,%ymm5,%ymm2
124bd36 vmaxpd %ymm1,%ymm5,%ymm1
124bd3a vmovapd 0x20(%rsp),%ymm3
124bd40 vandpd %ymm3,%ymm2,%ymm2
124bd44 vmulpd %ymm2,%ymm0,%ymm0
124bd48 vminpd %ymm1,%ymm4,%ymm1
124bd4c vandpd %ymm3,%ymm1,%ymm1
124bd50 vmulpd %ymm1,%ymm0,%ymm0
124bd54 vmulpd 0x100(%rsp),%ymm0,%ymm0
124bd5d vmovapd %ymm0,0x2e0(%rsp)
124bd66 mov    0xbc199b(%rip),%r15        # 1e0d708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124bd6d movzbl (%r15),%eax
124bd71 test   %al,%al
124bd73 je     124cc23 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1953>
124bd79 mov    0xbc60f8(%rip),%rax        # 1e11e78 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f48>
124bd80 cmpb   $0x0,(%rax)
124bd83 je     124bf03 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc33>
124bd89 vmovsd 0x48(%r12),%xmm0
124bd90 vxorpd %xmm1,%xmm1,%xmm1
124bd94 vucomisd %xmm1,%xmm0
124bd98 jbe    124bf03 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc33>
124bd9e vbroadcastsd (%r12),%ymm0
124bda4 mov    0x88(%rbp),%rax
124bdab cmpb   $0x0,0x1(%rax)
124bdaf vmovsd 0x8(%r12),%xmm2
124bdb6 je     124bdbf <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xaef>
124bdb8 vmovsd 0x18(%r12),%xmm1
124bdbf vaddsd 0x10(%r12),%xmm1,%xmm3
124bdc6 vbroadcastsd 0x8(%r12),%ymm1
124bdcd vsubsd %xmm3,%xmm2,%xmm2
124bdd1 vbroadcastsd %xmm2,%ymm2
124bdd6 vmovapd 0x440(%rsp),%ymm3
124bddf vsubpd %ymm2,%ymm3,%ymm3
124bde3 vdivpd %ymm1,%ymm3,%ymm4
124bde7 vmulpd %ymm4,%ymm4,%ymm2
124bdeb vmulpd %ymm2,%ymm4,%ymm5
124bdef vmovapd 0x460(%rsp),%ymm6
124bdf8 vmovapd 0x2a0(%rsp),%ymm8
124be01 vfmadd213pd %ymm6,%ymm4,%ymm8
124be06 vmovapd 0xe0(%rsp),%ymm7
124be0f vfmadd213pd %ymm8,%ymm5,%ymm7
124be14 vmovapd 0x220(%rsp),%ymm8
124be1d vfmadd213pd %ymm6,%ymm8,%ymm4
124be22 vmovapd 0x320(%rsp),%ymm9
124be2b vfmadd213pd %ymm4,%ymm5,%ymm9
124be30 vxorpd %xmm4,%xmm4,%xmm4
124be34 vcmplepd %ymm4,%ymm1,%ymm5
124be39 vandpd 0x340(%rsp),%ymm3,%ymm6
124be42 vcmpltpd %ymm6,%ymm1,%ymm6
124be47 vorpd  %ymm5,%ymm6,%ymm5
124be4b vmulpd %ymm7,%ymm3,%ymm6
124be4f vmovapd 0x360(%rsp),%ymm7
124be58 vfmadd213pd %ymm6,%ymm1,%ymm7
124be5d vblendvpd %ymm5,%ymm3,%ymm7,%ymm6
124be63 vbroadcastsd 0x82da1c(%rip),%ymm7        # 1a79888 <_fini+0x1034>
124be6c vcmpnltpd %ymm4,%ymm3,%ymm3
124be71 vandpd %ymm7,%ymm3,%ymm3
124be75 vblendvpd %ymm5,%ymm3,%ymm9,%ymm3
124be7b vmaxpd %ymm3,%ymm4,%ymm3
124be7f vminpd %ymm3,%ymm7,%ymm3
124be83 vsubpd %ymm2,%ymm7,%ymm2
124be87 vmulpd %ymm2,%ymm8,%ymm2
124be8b vdivpd %ymm1,%ymm2,%ymm1
124be8f vandnpd %ymm1,%ymm5,%ymm1
124be93 vmaxpd %ymm6,%ymm4,%ymm2
124be97 vmaxpd %ymm1,%ymm4,%ymm1
124be9b vmovapd 0x20(%rsp),%ymm4
124bea1 vandpd %ymm4,%ymm2,%ymm2
124bea5 vandpd %ymm4,%ymm3,%ymm3
124bea9 vandpd %ymm4,%ymm1,%ymm1
124bead vmulpd %ymm1,%ymm2,%ymm1
124beb1 vmulpd %ymm2,%ymm0,%ymm2
124beb5 vmulpd %ymm3,%ymm2,%ymm2
124beb9 vfmadd231pd %ymm3,%ymm3,%ymm1
124bebe vmulpd %ymm0,%ymm1,%ymm0
124bec2 vmovapd 0x100(%rsp),%ymm1
124becb vmulpd %ymm2,%ymm1,%ymm2
124becf vmovapd %ymm2,0x80(%rsp)
124bed8 vmulpd %ymm1,%ymm0,%ymm0
124bedc vmovapd %ymm0,0x440(%rsp)
124bee5 vmovdqu 0x18(%r12),%xmm0
124beec vpextrb $0x8,%xmm0,%ecx
124bef2 mov    0x88(%rbp),%rax
124bef9 movzbl 0x2(%rax),%eax
124befd test   %cl,%cl
124beff je     124bf37 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xc67>
124bf01 jmp    124bf79 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xca9>
124bf03 movzbl 0x20(%r12),%ecx
124bf09 vxorpd %xmm0,%xmm0,%xmm0
124bf0d vmovapd %ymm0,0x440(%rsp)
124bf16 vmovdqa 0x2e0(%rsp),%ymm0
124bf1f vmovdqa %ymm0,0x80(%rsp)
124bf28 mov    0x88(%rbp),%rax
124bf2f movzbl 0x2(%rax),%eax
124bf33 test   %cl,%cl
124bf35 jne    124bf79 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xca9>
124bf37 test   %al,%al
124bf39 je     124bf79 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xca9>
124bf3b vmovapd 0x300(%rsp),%ymm1
124bf44 vxorpd 0x4e0(%rsp),%ymm1,%ymm0
124bf4d vmovapd %ymm0,0xa0(%rsp)
124bf56 vxorpd 0x260(%rsp),%ymm1,%ymm0
124bf5f vmovapd %ymm0,0xc0(%rsp)
124bf68 vxorpd 0x280(%rsp),%ymm1,%ymm0
124bf71 vmovapd %ymm0,0x60(%rsp)
124bf77 jmp    124bff6 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd26>
124bf79 cmpb   $0x0,0xa8(%rbp)
124bf80 jne    124bff6 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd26>
124bf82 vmovapd 0xc0(%rsp),%ymm3
124bf8b vmulpd %ymm3,%ymm3,%ymm0
124bf8f vmovapd 0xa0(%rsp),%ymm4
124bf98 vfmadd231pd %ymm4,%ymm4,%ymm0
124bf9d vmovapd 0x60(%rsp),%ymm2
124bfa3 vfmadd231pd %ymm2,%ymm2,%ymm0
124bfa8 vsqrtpd %ymm0,%ymm0
124bfac vbroadcastsd 0x82d8d3(%rip),%ymm1        # 1a79888 <_fini+0x1034>
124bfb5 vdivpd %ymm0,%ymm1,%ymm1
124bfb9 vmulpd %ymm1,%ymm4,%ymm4
124bfbd vmovapd %ymm4,0xa0(%rsp)
124bfc6 vmulpd %ymm3,%ymm1,%ymm3
124bfca vmovapd %ymm3,0xc0(%rsp)
124bfd3 vmulpd %ymm2,%ymm1,%ymm2
124bfd7 vmovapd %ymm2,0x60(%rsp)
124bfdd vbroadcastsd 0x82dcea(%rip),%ymm1        # 1a79cd0 <_fini+0x147c>
124bfe6 vcmpltpd %ymm1,%ymm0,%ymm0
124bfeb vtestpd %ymm0,%ymm0
124bff0 jne    124cb73 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x18a3>
124bff6 vmovsd 0x18(%rsp),%xmm0
124bffc vmulsd 0x40(%r12),%xmm0,%xmm0
124c003 vmovsd %xmm0,0x20(%rsp)
124c009 mov    0xbcba68(%rip),%rax        # 1e17a78 <_ZGVZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x34370>
124c010 movzbl (%rax),%eax
124c013 test   %al,%al
124c015 je     124cc64 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1994>
124c01b mov    0xbcda2e(%rip),%rax        # 1e19a50 <_ZZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x32390>
124c022 cmpb   $0x0,(%rax)
124c025 vxorpd %xmm1,%xmm1,%xmm1
124c029 je     124c07d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xdad>
124c02b mov    0xbbc1d6(%rip),%r14        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124c032 movzbl (%r14),%eax
124c036 test   %al,%al
124c038 je     124cca5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x19d5>
124c03e mov    0xbcb7cb(%rip),%r13        # 1e17810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124c045 vmovsd 0x0(%r13),%xmm0
124c04b vxorpd %xmm1,%xmm1,%xmm1
124c04f vucomisd %xmm1,%xmm0
124c053 jbe    124c07d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xdad>
124c055 vxorpd %xmm0,%xmm0,%xmm0
124c059 vmovsd 0x20(%rsp),%xmm2
124c05f vucomisd %xmm0,%xmm2
124c063 jbe    124c07d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xdad>
124c065 movzbl (%r14),%eax
124c069 test   %al,%al
124c06b je     124ce05 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1b35>
124c071 vmovsd 0x0(%r13),%xmm0
124c077 vdivsd 0x20(%rsp),%xmm0,%xmm1
124c07d vmovsd %xmm1,0x2a0(%rsp)
124c086 vmovapd 0xc0(%rsp),%ymm0
124c08f vmovapd 0x120(%rsp),%ymm4
124c098 vmulpd %ymm0,%ymm4,%ymm2
124c09c vmovapd 0xa0(%rsp),%ymm1
124c0a5 vfmadd231pd 0x140(%rsp),%ymm1,%ymm2
124c0af vmovapd 0x160(%rsp),%ymm3
124c0b8 vfmadd231pd 0x60(%rsp),%ymm3,%ymm2
124c0bf vmulpd %ymm0,%ymm2,%ymm0
124c0c3 vmovapd %ymm2,0x20(%rsp)
124c0c9 vmulpd %ymm1,%ymm2,%ymm1
124c0cd vmovapd %ymm1,0x2c0(%rsp)
124c0d6 vmovapd %ymm0,0x360(%rsp)
124c0df vsubpd %ymm0,%ymm4,%ymm0
124c0e3 vmovapd %ymm0,0x1a0(%rsp)
124c0ec vmovsd 0x48(%r12),%xmm0
124c0f3 vucomisd 0x82d7ed(%rip),%xmm0        # 1a798e8 <_fini+0x1094>
124c0fb jbe    124c14d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe7d>
124c0fd movzbl (%r15),%eax
124c101 test   %al,%al
124c103 movzbl 0x90(%rbp),%r13d
124c10b vmovapd 0x20(%rsp),%ymm0
124c111 je     124cd25 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1a55>
124c117 mov    0xbc5d5a(%rip),%rax        # 1e11e78 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f48>
124c11e cmpb   $0x0,(%rax)
124c121 setne  %r14b
124c125 mov    0xbc8cac(%rip),%rax        # 1e14dd8 <_ZGVZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x37000>
124c12c movzbl (%rax),%eax
124c12f test   %al,%al
124c131 mov    0x88(%rbp),%r15
124c138 je     124cd75 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1aa5>
124c13e mov    0xbbd983(%rip),%rax        # 1e09ac8 <_ZZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x42308>
124c145 cmpb   $0x0,(%rax)
124c148 setne  %al
124c14b jmp    124c167 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe97>
124c14d xor    %r14d,%r14d
124c150 xor    %eax,%eax
124c152 movzbl 0x90(%rbp),%r13d
124c15a vmovapd 0x20(%rsp),%ymm0
124c160 mov    0x88(%rbp),%r15
124c167 vmulpd 0x60(%rsp),%ymm0,%ymm0
124c16d vmovapd %ymm0,0x220(%rsp)
124c176 vmovapd 0x140(%rsp),%ymm0
124c17f vsubpd 0x2c0(%rsp),%ymm0,%ymm0
124c188 vmovapd %ymm0,0x140(%rsp)
124c191 vmovapd 0x1a0(%rsp),%ymm0
124c19a vmulpd %ymm0,%ymm0,%ymm0
124c19e test   %r14b,%r14b
124c1a1 jne    124c1d6 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf06>
124c1a3 vxorpd %xmm1,%xmm1,%xmm1
124c1a7 vmovapd %ymm1,0x320(%rsp)
124c1b0 vmovaps 0x40(%rsp),%ymm1
124c1b6 vmovaps %ymm1,0x100(%rsp)
124c1bf vmovapd 0x20(%rsp),%ymm1
124c1c5 vmovapd %ymm1,0x180(%rsp)
124c1ce test   %al,%al
124c1d0 je     124c272 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfa2>
124c1d6 vmovsd 0x48(%r12),%xmm2
124c1dd vxorpd %xmm1,%xmm1,%xmm1
124c1e1 vmovapd 0x2e0(%rsp),%ymm3
124c1ea vcmpltpd %ymm3,%ymm1,%ymm4
124c1ef vmovapd 0x80(%rsp),%ymm5
124c1f8 vdivpd %ymm3,%ymm5,%ymm5
124c1fc vbroadcastsd 0x82d683(%rip),%ymm3        # 1a79888 <_fini+0x1034>
124c205 vblendvpd %ymm4,%ymm5,%ymm3,%ymm4
124c20b vmovsd 0x18(%rsp),%xmm5
124c211 vdivsd %xmm2,%xmm5,%xmm5
124c215 vbroadcastsd %xmm5,%ymm5
124c21a vmulpd %ymm5,%ymm4,%ymm4
124c21e test   %r14b,%r14b
124c221 jne    124c234 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf64>
124c223 vmovapd 0x20(%rsp),%ymm5
124c229 vmovapd %ymm5,0x180(%rsp)
124c232 jmp    124c247 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xf77>
124c234 vmovapd 0x20(%rsp),%ymm5
124c23a vminpd %ymm4,%ymm5,%ymm6
124c23e vmovapd %ymm6,0x180(%rsp)
124c247 vcmpltpd %ymm4,%ymm5,%ymm4
124c24c vmovapd %ymm4,0x320(%rsp)
124c255 vdivsd 0x18(%rsp),%xmm2,%xmm2
124c25b vbroadcastsd %xmm2,%ymm2
124c260 vfnmadd213pd %ymm3,%ymm5,%ymm2
124c265 vmaxpd %ymm2,%ymm1,%ymm1
124c269 vmovapd %ymm1,0x100(%rsp)
124c272 vmovapd 0x160(%rsp),%ymm1
124c27b vsubpd 0x220(%rsp),%ymm1,%ymm1
124c284 vmovapd %ymm1,0x160(%rsp)
124c28d vmovapd 0x140(%rsp),%ymm1
124c296 vfmadd231pd %ymm1,%ymm1,%ymm0
124c29b test   %al,%al
124c29d jne    124c2ae <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xfde>
124c29f vmovapd 0x40(%rsp),%ymm1
124c2a5 vmovapd %ymm1,0x100(%rsp)
124c2ae vmovapd 0x160(%rsp),%ymm1
124c2b7 vfmadd231pd %ymm1,%ymm1,%ymm0
124c2bc test   %r14b,%r14b
124c2bf je     124c2fd <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x102d>
124c2c1 vmovapd 0x180(%rsp),%ymm2
124c2ca vmulpd 0xa0(%rsp),%ymm2,%ymm1
124c2d3 vmovapd %ymm1,0x2c0(%rsp)
124c2dc vmulpd 0xc0(%rsp),%ymm2,%ymm1
124c2e5 vmovapd %ymm1,0x360(%rsp)
124c2ee vmulpd 0x60(%rsp),%ymm2,%ymm1
124c2f4 vmovapd %ymm1,0x220(%rsp)
124c2fd vsqrtpd %ymm0,%ymm0
124c301 vmovapd %ymm0,0x80(%rsp)
124c30a vmovapd 0x100(%rsp),%ymm0
124c313 vmulpd 0x2e0(%rsp),%ymm0,%ymm0
124c31c vmovapd %ymm0,0x340(%rsp)
124c325 vmovsd 0x38(%r12),%xmm1
124c32c vxorpd %xmm0,%xmm0,%xmm0
124c330 vmovapd %xmm1,0xe0(%rsp)
124c339 vucomisd %xmm0,%xmm1
124c33d jbe    124c55d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x128d>
124c343 mov    0xbbbebe(%rip),%rax        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124c34a movzbl (%rax),%eax
124c34d test   %al,%al
124c34f je     124cdc5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1af5>
124c355 mov    0xbcb4b4(%rip),%r13        # 1e17810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124c35c vmovsd 0x0(%r13),%xmm0
124c362 vmovsd 0x18(%rsp),%xmm1
124c368 vmulsd 0x40(%r12),%xmm1,%xmm1
124c36f vxorpd %xmm2,%xmm2,%xmm2
124c373 vcmpltsd %xmm0,%xmm2,%xmm2
124c378 vblendvpd %xmm2,%xmm0,%xmm1,%xmm0
124c37e vbroadcastsd %xmm0,%ymm2
124c383 mov    0x8(%r15),%eax
124c387 test   %eax,%eax
124c389 je     124c8f2 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1622>
124c38f vxorpd %xmm0,%xmm0,%xmm0
124c393 vxorpd %xmm1,%xmm1,%xmm1
124c397 vmovapd %ymm1,0x120(%rsp)
124c3a0 cmp    $0x1,%eax
124c3a3 jne    124c405 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1135>
124c3a5 vbroadcastsd 0x82d52a(%rip),%ymm0        # 1a798d8 <_fini+0x1084>
124c3ae vmaxpd %ymm0,%ymm2,%ymm2
124c3b2 vmulpd %ymm2,%ymm2,%ymm0
124c3b6 vbroadcastsd 0x82d629(%rip),%ymm1        # 1a799e8 <_fini+0x1194>
124c3bf vmulpd %ymm1,%ymm0,%ymm3
124c3c3 vmovapd 0x80(%rsp),%ymm0
124c3cc vfmadd213pd %ymm3,%ymm0,%ymm0
124c3d1 vsqrtpd %ymm0,%ymm4
124c3d5 vbroadcastsd 0x82d4aa(%rip),%ymm0        # 1a79888 <_fini+0x1034>
124c3de vdivpd %ymm4,%ymm0,%ymm0
124c3e2 vbroadcastsd 0x82d4d5(%rip),%ymm1        # 1a798c0 <_fini+0x106c>
124c3eb vfmadd213pd %ymm4,%ymm2,%ymm1
124c3f0 vmulpd %ymm0,%ymm0,%ymm2
124c3f4 vmulpd %ymm2,%ymm0,%ymm2
124c3f8 vmulpd %ymm2,%ymm3,%ymm2
124c3fc vmovapd %ymm2,0x120(%rsp)
124c405 cmpb   $0x0,0x90(%rbp)
124c40c je     124c42b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x115b>
124c40e vbroadcastsd 0xe0(%rsp),%ymm2
124c418 vmulpd %ymm1,%ymm2,%ymm1
124c41c vmulpd 0x100(%rsp),%ymm1,%ymm1
124c425 vmovapd %ymm1,0x40(%rsp)
124c42b cmpb   $0x0,0x98(%rbp)
124c432 jne    124c441 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1171>
124c434 cmpb   $0x0,0xa0(%rbp)
124c43b je     124c587 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12b7>
124c441 vbroadcastsd 0xe0(%rsp),%ymm1
124c44b vmulpd 0x340(%rsp),%ymm1,%ymm1
124c454 vmovapd %ymm1,0x280(%rsp)
124c45d vmulpd %ymm0,%ymm1,%ymm1
124c461 cmpb   $0x0,0x98(%rbp)
124c468 je     124c4be <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x11ee>
124c46a vmovapd 0x1c0(%rsp),%ymm0
124c473 vfnmadd231pd 0x140(%rsp),%ymm1,%ymm0
124c47d vmovapd %ymm0,0x1c0(%rsp)
124c486 vmovapd 0x1e0(%rsp),%ymm0
124c48f vfnmadd231pd 0x1a0(%rsp),%ymm1,%ymm0
124c499 vmovapd %ymm0,0x1e0(%rsp)
124c4a2 vmovapd 0x200(%rsp),%ymm0
124c4ab vfnmadd231pd 0x160(%rsp),%ymm1,%ymm0
124c4b5 vmovapd %ymm0,0x200(%rsp)
124c4be cmpb   $0x0,0xa0(%rbp)
124c4c5 je     124c587 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12b7>
124c4cb vmovapd %ymm1,0x260(%rsp)
124c4d4 vxorpd 0x300(%rsp),%ymm1,%ymm0
124c4dd vmovapd %ymm0,0xe0(%rsp)
124c4e6 cmpb   $0x0,0x6(%r15)
124c4eb je     124c50f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x123f>
124c4ed mov    0xbbbd14(%rip),%rax        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124c4f4 movzbl (%rax),%eax
124c4f7 test   %al,%al
124c4f9 je     124ce80 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1bb0>
124c4ff vmovsd 0x0(%r13),%xmm0
124c505 vxorpd %xmm1,%xmm1,%xmm1
124c509 vucomisd %xmm1,%xmm0
124c50d jbe    124c587 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12b7>
124c50f vbroadcastsd 0x82d7c0(%rip),%ymm0        # 1a79cd8 <_fini+0x1484>
124c518 vcmpltpd 0x80(%rsp),%ymm0,%ymm0
124c522 vmovapd 0x280(%rsp),%ymm1
124c52b vmulpd 0x120(%rsp),%ymm1,%ymm1
124c534 vxorpd %xmm2,%xmm2,%xmm2
124c538 vmovsd 0x2a0(%rsp),%xmm3
124c541 vucomisd %xmm2,%xmm3
124c545 vbroadcastsd 0x82d33a(%rip),%ymm2        # 1a79888 <_fini+0x1034>
124c54e ja     124cae1 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1811>
124c554 vmovapd %ymm2,%ymm3
124c558 jmp    124caee <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x181e>
124c55d vxorpd %xmm0,%xmm0,%xmm0
124c561 vmovapd %ymm0,0x40(%rsp)
124c567 vxorps %xmm0,%xmm0,%xmm0
124c56b vmovaps %ymm0,0xe0(%rsp)
124c574 vmovsd 0x30(%r12),%xmm0
124c57b vucomisd 0x82d365(%rip),%xmm0        # 1a798e8 <_fini+0x1094>
124c583 jbe    124c5f9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1329>
124c585 jmp    124c5a0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12d0>
124c587 movzbl 0x90(%rbp),%r13d
124c58f vmovsd 0x30(%r12),%xmm0
124c596 vucomisd 0x82d34a(%rip),%xmm0        # 1a798e8 <_fini+0x1094>
124c59e jbe    124c5f9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1329>
124c5a0 vdivsd 0x18(%rsp),%xmm0,%xmm0
124c5a6 test   %r13b,%r13b
124c5a9 je     124c5df <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x130f>
124c5ab vmulsd 0x82d305(%rip),%xmm0,%xmm1        # 1a798b8 <_fini+0x1064>
124c5b3 vmovapd 0x80(%rsp),%ymm2
124c5bc vmulpd %ymm2,%ymm2,%ymm2
124c5c0 vbroadcastsd %xmm1,%ymm1
124c5c5 vmulpd %ymm1,%ymm2,%ymm1
124c5c9 vmovapd 0x40(%rsp),%ymm2
124c5cf vfmadd231pd 0x100(%rsp),%ymm1,%ymm2
124c5d9 vmovapd %ymm2,0x40(%rsp)
124c5df cmpb   $0x0,0x98(%rbp)
124c5e6 jne    124c734 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1464>
124c5ec cmpb   $0x0,0xa0(%rbp)
124c5f3 jne    124c734 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1464>
124c5f9 vmovsd 0x48(%r12),%xmm1
124c600 vxorpd %xmm0,%xmm0,%xmm0
124c604 vucomisd %xmm0,%xmm1
124c608 jbe    124c71e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x144e>
124c60e vdivsd 0x18(%rsp),%xmm1,%xmm0
124c614 test   %r13b,%r13b
124c617 je     124c661 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1391>
124c619 test   %r14b,%r14b
124c61c je     124caa7 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17d7>
124c622 vmovapd 0x180(%rsp),%ymm3
124c62b vmulpd %ymm3,%ymm3,%ymm1
124c62f vmovapd 0x20(%rsp),%ymm2
124c635 vsubpd %ymm3,%ymm2,%ymm2
124c639 vmulpd %ymm2,%ymm3,%ymm2
124c63d vmovapd 0x460(%rsp),%ymm3
124c646 vfmadd213pd %ymm2,%ymm1,%ymm3
124c64b vbroadcastsd %xmm0,%ymm1
124c650 vmovapd 0x40(%rsp),%ymm2
124c656 vfmadd231pd %ymm1,%ymm3,%ymm2
124c65b vmovapd %ymm2,0x40(%rsp)
124c661 cmpb   $0x0,0x98(%rbp)
124c668 jne    124c677 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x13a7>
124c66a cmpb   $0x0,0xa0(%rbp)
124c671 je     124ca6d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x179d>
124c677 vbroadcastsd %xmm0,%ymm0
124c67c vmulpd 0x2e0(%rsp),%ymm0,%ymm0
124c685 cmpb   $0x0,0x98(%rbp)
124c68c je     124c6e2 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1412>
124c68e vmovapd 0x1c0(%rsp),%ymm1
124c697 vfnmadd231pd 0x2c0(%rsp),%ymm0,%ymm1
124c6a1 vmovapd %ymm1,0x1c0(%rsp)
124c6aa vmovapd 0x1e0(%rsp),%ymm1
124c6b3 vfnmadd231pd 0x360(%rsp),%ymm0,%ymm1
124c6bd vmovapd %ymm1,0x1e0(%rsp)
124c6c6 vmovapd 0x200(%rsp),%ymm1
124c6cf vfnmadd231pd 0x220(%rsp),%ymm0,%ymm1
124c6d9 vmovapd %ymm1,0x200(%rsp)
124c6e2 cmpb   $0x0,0xa0(%rbp)
124c6e9 je     124ca6d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x179d>
124c6ef vxorpd 0x300(%rsp),%ymm0,%ymm0
124c6f8 test   %r14b,%r14b
124c6fb je     124c7db <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x150b>
124c701 vmovapd 0x440(%rsp),%ymm1
124c70a vmovapd 0x320(%rsp),%ymm2
124c713 vblendvpd %ymm2,%ymm0,%ymm1,%ymm0
124c719 jmp    124c7db <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x150b>
124c71e vxorpd %xmm0,%xmm0,%xmm0
124c722 cmpb   $0x0,0xa0(%rbp)
124c729 jne    124c7db <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x150b>
124c72f jmp    124ca6d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x179d>
124c734 vbroadcastsd %xmm0,%ymm0
124c739 vmulpd 0x340(%rsp),%ymm0,%ymm0
124c742 cmpb   $0x0,0x98(%rbp)
124c749 je     124c79f <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x14cf>
124c74b vmovapd 0x1c0(%rsp),%ymm1
124c754 vfnmadd231pd 0x140(%rsp),%ymm0,%ymm1
124c75e vmovapd %ymm1,0x1c0(%rsp)
124c767 vmovapd 0x1e0(%rsp),%ymm1
124c770 vfnmadd231pd 0x1a0(%rsp),%ymm0,%ymm1
124c77a vmovapd %ymm1,0x1e0(%rsp)
124c783 vmovapd 0x200(%rsp),%ymm1
124c78c vfnmadd231pd 0x160(%rsp),%ymm0,%ymm1
124c796 vmovapd %ymm1,0x200(%rsp)
124c79f cmpb   $0x0,0xa0(%rbp)
124c7a6 je     124ca58 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1788>
124c7ac vmovapd 0xe0(%rsp),%ymm1
124c7b5 vsubpd %ymm0,%ymm1,%ymm1
124c7b9 vmovapd %ymm1,0xe0(%rsp)
124c7c2 vmovsd 0x48(%r12),%xmm1
124c7c9 vxorpd %xmm0,%xmm0,%xmm0
124c7cd vxorpd %xmm2,%xmm2,%xmm2
124c7d1 vucomisd %xmm2,%xmm1
124c7d5 ja     124c60e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x133e>
124c7db vmovapd 0xe0(%rsp),%ymm7
124c7e4 vsubpd %ymm7,%ymm0,%ymm0
124c7e8 vmovapd 0xa0(%rsp),%ymm4
124c7f1 vmulpd %ymm4,%ymm0,%ymm1
124c7f5 vmovapd 0xc0(%rsp),%ymm6
124c7fe vmulpd %ymm6,%ymm0,%ymm2
124c802 vmovapd 0x60(%rsp),%ymm5
124c808 vmulpd %ymm5,%ymm0,%ymm0
124c80c vfmadd213pd %ymm7,%ymm1,%ymm4
124c811 vmovapd 0x380(%rsp),%ymm3
124c81a vaddpd %ymm4,%ymm3,%ymm3
124c81e vmovapd %ymm3,0x380(%rsp)
124c827 vmovapd %ymm6,%ymm3
124c82b vfmadd213pd %ymm7,%ymm2,%ymm3
124c830 vmovapd 0x3a0(%rsp),%ymm4
124c839 vaddpd %ymm3,%ymm4,%ymm4
124c83d vmovapd %ymm4,0x3a0(%rsp)
124c846 vfmadd213pd %ymm7,%ymm5,%ymm0
124c84b vmovapd 0x420(%rsp),%ymm3
124c854 vaddpd %ymm0,%ymm3,%ymm3
124c858 vmovapd %ymm3,0x420(%rsp)
124c861 vmovapd 0x3c0(%rsp),%ymm0
124c86a vfmadd231pd %ymm6,%ymm1,%ymm0
124c86f vmovapd %ymm0,0x3c0(%rsp)
124c878 vmovapd 0x400(%rsp),%ymm0
124c881 vfmadd231pd %ymm1,%ymm5,%ymm0
124c886 vmovapd %ymm0,0x400(%rsp)
124c88f vmovapd 0x3e0(%rsp),%ymm0
124c898 vfmadd231pd %ymm5,%ymm2,%ymm0
124c89d vmovapd %ymm0,0x3e0(%rsp)
124c8a6 cmpb   $0x0,0x6(%r15)
124c8ab je     124c987 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x16b7>
124c8b1 mov    0xbbb950(%rip),%rax        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124c8b8 movzbl (%rax),%eax
124c8bb test   %al,%al
124c8bd je     124ce40 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1b70>
124c8c3 mov    0xbcaf46(%rip),%rax        # 1e17810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124c8ca vmovsd (%rax),%xmm1
124c8ce vxorpd %xmm0,%xmm0,%xmm0
124c8d2 vucomisd %xmm0,%xmm1
124c8d6 jbe    124ca6d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x179d>
124c8dc vmovsd 0x38(%r12),%xmm1
124c8e3 vucomisd %xmm0,%xmm1
124c8e7 ja     124c99c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x16cc>
124c8ed jmp    124ca6d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x179d>
124c8f2 vmovapd 0x80(%rsp),%ymm8
124c8fb vdivpd %ymm2,%ymm8,%ymm0
124c8ff vcmplepd %ymm8,%ymm2,%ymm3
124c905 vbroadcastsd 0x82d0aa(%rip),%ymm1        # 1a799b8 <_fini+0x1164>
124c90e vmovapd %ymm1,%ymm4
124c912 vfnmadd213pd %ymm8,%ymm2,%ymm4
124c917 vmulpd %ymm0,%ymm8,%ymm5
124c91b vbroadcastsd 0x82cf64(%rip),%ymm6        # 1a79888 <_fini+0x1034>
124c924 vfnmadd213pd %ymm6,%ymm0,%ymm1
124c929 vmulpd %ymm1,%ymm5,%ymm1
124c92d vblendvpd %ymm3,%ymm4,%ymm1,%ymm1
124c933 vxorpd %xmm4,%xmm4,%xmm4
124c937 vsubpd %ymm0,%ymm6,%ymm5
124c93b vbroadcastsd 0x82d004(%rip),%ymm7        # 1a79948 <_fini+0x10f4>
124c944 vaddpd %ymm5,%ymm5,%ymm5
124c948 vdivpd %ymm2,%ymm5,%ymm5
124c94c vandnpd %ymm5,%ymm3,%ymm5
124c950 vmovapd %ymm5,0x120(%rsp)
124c959 vdivpd %ymm8,%ymm6,%ymm5
124c95e vsubpd %ymm0,%ymm7,%ymm0
124c962 vdivpd %ymm2,%ymm0,%ymm0
124c966 vcmpneqpd %ymm4,%ymm8,%ymm2
124c96b vandpd %ymm5,%ymm2,%ymm2
124c96f vblendvpd %ymm3,%ymm2,%ymm0,%ymm0
124c975 cmpb   $0x0,0x90(%rbp)
124c97c jne    124c40e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x113e>
124c982 jmp    124c42b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x115b>
124c987 vmovsd 0x38(%r12),%xmm0
124c98e vxorpd %xmm1,%xmm1,%xmm1
124c992 vucomisd %xmm1,%xmm0
124c996 jbe    124ca6d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x179d>
124c99c vmovapd 0x120(%rsp),%ymm5
124c9a5 vmovapd 0x260(%rsp),%ymm2
124c9ae vmulpd %ymm2,%ymm5,%ymm0
124c9b2 vmovapd 0x2a0(%rsp),%ymm4
124c9bb vmulpd %ymm2,%ymm4,%ymm1
124c9bf vmovapd 0x280(%rsp),%ymm6
124c9c8 vmulpd %ymm2,%ymm6,%ymm2
124c9cc vmovapd 0x380(%rsp),%ymm3
124c9d5 vfmadd231pd %ymm5,%ymm0,%ymm3
124c9da vmovapd %ymm3,0x380(%rsp)
124c9e3 vmovapd 0x3a0(%rsp),%ymm3
124c9ec vfmadd231pd %ymm1,%ymm4,%ymm3
124c9f1 vmovapd %ymm3,0x3a0(%rsp)
124c9fa vmovapd 0x420(%rsp),%ymm3
124ca03 vfmadd231pd %ymm2,%ymm6,%ymm3
124ca08 vmovapd %ymm3,0x420(%rsp)
124ca11 vmovapd 0x3c0(%rsp),%ymm2
124ca1a vfmadd231pd %ymm4,%ymm0,%ymm2
124ca1f vmovapd %ymm2,0x3c0(%rsp)
124ca28 vmovapd 0x400(%rsp),%ymm2
124ca31 vfmadd231pd %ymm0,%ymm6,%ymm2
124ca36 vmovapd %ymm2,0x400(%rsp)
124ca3f vmovapd 0x3e0(%rsp),%ymm0
124ca48 vfmadd231pd %ymm1,%ymm6,%ymm0
124ca4d vmovapd %ymm0,0x3e0(%rsp)
124ca56 jmp    124ca6d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x179d>
124ca58 vmovsd 0x48(%r12),%xmm1
124ca5f vxorpd %xmm0,%xmm0,%xmm0
124ca63 vucomisd %xmm0,%xmm1
124ca67 ja     124c60e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x133e>
124ca6d test   %r13b,%r13b
124ca70 jne    124ca7d <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17ad>
124ca72 vbroadcastsd 0x82ce05(%rip),%ymm0        # 1a79880 <_fini+0x102c>
124ca7b jmp    124ca8c <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x17bc>
124ca7d vmovapd 0x40(%rsp),%ymm0
124ca83 vmulpd 0x2e0(%rsp),%ymm0,%ymm0
124ca8c vmovapd 0x500(%rsp),%ymm1
124ca95 vaddpd %ymm0,%ymm1,%ymm0
124ca99 test   %r13b,%r13b
124ca9c jne    124b7d4 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x504>
124caa2 jmp    124b7e0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x510>
124caa7 vmulsd 0x82ce09(%rip),%xmm0,%xmm1        # 1a798b8 <_fini+0x1064>
124caaf vmovapd 0x20(%rsp),%ymm2
124cab5 vmulpd %ymm2,%ymm2,%ymm2
124cab9 vbroadcastsd %xmm1,%ymm1
124cabe vmovapd 0x40(%rsp),%ymm3
124cac4 vfmadd231pd %ymm1,%ymm2,%ymm3
124cac9 vmovapd %ymm3,0x40(%rsp)
124cacf cmpb   $0x0,0x98(%rbp)
124cad6 je     124c66a <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x139a>
124cadc jmp    124c677 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x13a7>
124cae1 vaddsd 0x82cd9f(%rip),%xmm3,%xmm3        # 1a79888 <_fini+0x1034>
124cae9 vbroadcastsd %xmm3,%ymm3
124caee movzbl 0x90(%rbp),%r13d
124caf6 vbroadcastsd 0x82cdc9(%rip),%ymm4        # 1a798c8 <_fini+0x1074>
124caff vaddpd 0x80(%rsp),%ymm4,%ymm4
124cb08 vdivpd %ymm4,%ymm2,%ymm2
124cb0c vmulpd 0x140(%rsp),%ymm2,%ymm4
124cb15 vmovapd %ymm4,0x120(%rsp)
124cb1e vmulpd 0x1a0(%rsp),%ymm2,%ymm4
124cb27 vmovapd %ymm4,0x2a0(%rsp)
124cb30 vmulpd 0x160(%rsp),%ymm2,%ymm2
124cb39 vmovapd %ymm2,0x280(%rsp)
124cb42 vfnmadd213pd 0x260(%rsp),%ymm3,%ymm1
124cb4c vandpd %ymm1,%ymm0,%ymm0
124cb50 vmovapd %ymm0,0x260(%rsp)
124cb59 vmovsd 0x30(%r12),%xmm0
124cb60 vucomisd 0x82cd80(%rip),%xmm0        # 1a798e8 <_fini+0x1094>
124cb68 jbe    124c5f9 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1329>
124cb6e jmp    124c5a0 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x12d0>
124cb73 test   %al,%al
124cb75 je     124cbe2 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1912>
124cb77 vmovapd 0x300(%rsp),%ymm3
124cb80 vxorpd 0x4e0(%rsp),%ymm3,%ymm1
124cb89 vmovapd 0xa0(%rsp),%ymm2
124cb92 vblendvpd %ymm0,%ymm1,%ymm2,%ymm2
124cb98 vmovapd %ymm2,0xa0(%rsp)
124cba1 vxorpd 0x260(%rsp),%ymm3,%ymm1
124cbaa vmovapd 0xc0(%rsp),%ymm2
124cbb3 vblendvpd %ymm0,%ymm1,%ymm2,%ymm2
124cbb9 vmovapd %ymm2,0xc0(%rsp)
124cbc2 vxorpd 0x280(%rsp),%ymm3,%ymm1
124cbcb vmovapd 0x60(%rsp),%ymm2
124cbd1 vblendvpd %ymm0,%ymm1,%ymm2,%ymm2
124cbd7 vmovapd %ymm2,0x60(%rsp)
124cbdd jmp    124bff6 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd26>
124cbe2 vmovapd 0xa0(%rsp),%ymm1
124cbeb vandnpd %ymm1,%ymm0,%ymm1
124cbef vmovapd %ymm1,0xa0(%rsp)
124cbf8 vmovapd 0xc0(%rsp),%ymm1
124cc01 vandnpd %ymm1,%ymm0,%ymm1
124cc05 vmovapd %ymm1,0xc0(%rsp)
124cc0e vmovapd 0x60(%rsp),%ymm1
124cc14 vandnpd %ymm1,%ymm0,%ymm1
124cc18 vmovapd %ymm1,0x60(%rsp)
124cc1e jmp    124bff6 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd26>
124cc23 mov    0xbc0ade(%rip),%rdi        # 1e0d708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124cc2a vzeroupper
124cc2d call   7b7240 <__cxa_guard_acquire@plt>
124cc32 test   %eax,%eax
124cc34 je     124bd79 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xaa9>
124cc3a lea    0x848bd8(%rip),%rdi        # 1a95819 <_fini+0x1cfc5>
124cc41 call   7c87b0 <getenv@plt>
124cc46 test   %rax,%rax
124cc49 mov    0xbc5228(%rip),%rax        # 1e11e78 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f48>
124cc50 setne  (%rax)
124cc53 mov    0xbc0aae(%rip),%rdi        # 1e0d708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124cc5a call   7bef10 <__cxa_guard_release@plt>
124cc5f jmp    124bd79 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xaa9>
124cc64 mov    0xbcae0d(%rip),%rdi        # 1e17a78 <_ZGVZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x34370>
124cc6b vzeroupper
124cc6e call   7b7240 <__cxa_guard_acquire@plt>
124cc73 test   %eax,%eax
124cc75 je     124c01b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd4b>
124cc7b lea    0x848bd1(%rip),%rdi        # 1a95853 <_fini+0x1cfff>
124cc82 call   7c87b0 <getenv@plt>
124cc87 test   %rax,%rax
124cc8a mov    0xbccdbf(%rip),%rax        # 1e19a50 <_ZZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x32390>
124cc91 setne  (%rax)
124cc94 mov    0xbcaddd(%rip),%rdi        # 1e17a78 <_ZGVZN5mochi19FrictionStickDampedEvE3kOn@@Base-0x34370>
124cc9b call   7bef10 <__cxa_guard_release@plt>
124cca0 jmp    124c01b <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd4b>
124cca5 mov    0xbbb55c(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124ccac vzeroupper
124ccaf call   7b7240 <__cxa_guard_acquire@plt>
124ccb4 test   %eax,%eax
124ccb6 je     124c03e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd6e>
124ccbc lea    0x59b(%rsp),%rdi
124ccc4 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124ccc9 mov    0xbcab40(%rip),%rax        # 1e17810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124ccd0 vmovsd %xmm0,(%rax)
124ccd4 mov    0xbbb52d(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124ccdb call   7bef10 <__cxa_guard_release@plt>
124cce0 jmp    124c03e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xd6e>
124cce5 mov    0xbbb51c(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124ccec vzeroupper
124ccef call   7b7240 <__cxa_guard_acquire@plt>
124ccf4 test   %eax,%eax
124ccf6 je     124b97e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x6ae>
124ccfc lea    0x59a(%rsp),%rdi
124cd04 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124cd09 mov    0xbcab00(%rip),%rax        # 1e17810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124cd10 vmovsd %xmm0,(%rax)
124cd14 mov    0xbbb4ed(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124cd1b call   7bef10 <__cxa_guard_release@plt>
124cd20 jmp    124b97e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x6ae>
124cd25 mov    0xbc09dc(%rip),%rdi        # 1e0d708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124cd2c vzeroupper
124cd2f call   7b7240 <__cxa_guard_acquire@plt>
124cd34 vmovapd 0x20(%rsp),%ymm0
124cd3a test   %eax,%eax
124cd3c je     124c117 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe47>
124cd42 lea    0x848ad0(%rip),%rdi        # 1a95819 <_fini+0x1cfc5>
124cd49 vzeroupper
124cd4c call   7c87b0 <getenv@plt>
124cd51 test   %rax,%rax
124cd54 mov    0xbc511d(%rip),%rax        # 1e11e78 <_ZZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x39f48>
124cd5b setne  (%rax)
124cd5e mov    0xbc09a3(%rip),%rdi        # 1e0d708 <_ZGVZN5mochi24ContactDampingUnilateralEvE3kOn@@Base-0x3e6c0>
124cd65 call   7bef10 <__cxa_guard_release@plt>
124cd6a vmovapd 0x20(%rsp),%ymm0
124cd70 jmp    124c117 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe47>
124cd75 mov    0xbc805c(%rip),%rdi        # 1e14dd8 <_ZGVZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x37000>
124cd7c vzeroupper
124cd7f call   7b7240 <__cxa_guard_acquire@plt>
124cd84 vmovapd 0x20(%rsp),%ymm0
124cd8a test   %eax,%eax
124cd8c je     124c13e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe6e>
124cd92 lea    0x848a9c(%rip),%rdi        # 1a95835 <_fini+0x1cfe1>
124cd99 vzeroupper
124cd9c call   7c87b0 <getenv@plt>
124cda1 test   %rax,%rax
124cda4 mov    0xbbcd1d(%rip),%rax        # 1e09ac8 <_ZZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x42308>
124cdab setne  (%rax)
124cdae mov    0xbc8023(%rip),%rdi        # 1e14dd8 <_ZGVZN5mochi25FrictionOnFullNormalForceEvE3kOn@@Base-0x37000>
124cdb5 call   7bef10 <__cxa_guard_release@plt>
124cdba vmovapd 0x20(%rsp),%ymm0
124cdc0 jmp    124c13e <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xe6e>
124cdc5 mov    0xbbb43c(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124cdcc vzeroupper
124cdcf call   7b7240 <__cxa_guard_acquire@plt>
124cdd4 test   %eax,%eax
124cdd6 je     124c355 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1085>
124cddc lea    0x59d(%rsp),%rdi
124cde4 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124cde9 mov    0xbcaa20(%rip),%rax        # 1e17810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124cdf0 vmovsd %xmm0,(%rax)
124cdf4 mov    0xbbb40d(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124cdfb call   7bef10 <__cxa_guard_release@plt>
124ce00 jmp    124c355 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1085>
124ce05 mov    0xbbb3fc(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124ce0c vzeroupper
124ce0f call   7b7240 <__cxa_guard_acquire@plt>
124ce14 test   %eax,%eax
124ce16 je     124c071 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xda1>
124ce1c lea    0x59c(%rsp),%rdi
124ce24 call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124ce29 vmovsd %xmm0,0x0(%r13)
124ce2f mov    0xbbb3d2(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124ce36 call   7bef10 <__cxa_guard_release@plt>
124ce3b jmp    124c071 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0xda1>
124ce40 mov    0xbbb3c1(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124ce47 vzeroupper
124ce4a call   7b7240 <__cxa_guard_acquire@plt>
124ce4f test   %eax,%eax
124ce51 je     124c8c3 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x15f3>
124ce57 lea    0x59f(%rsp),%rdi
124ce5f call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124ce64 mov    0xbca9a5(%rip),%rax        # 1e17810 <_ZZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x2eae0>
124ce6b vmovsd %xmm0,(%rax)
124ce6f mov    0xbbb392(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124ce76 call   7bef10 <__cxa_guard_release@plt>
124ce7b jmp    124c8c3 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x15f3>
124ce80 mov    0xbbb381(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124ce87 vzeroupper
124ce8a call   7b7240 <__cxa_guard_acquire@plt>
124ce8f test   %eax,%eax
124ce91 je     124c4ff <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x122f>
124ce97 lea    0x59e(%rsp),%rdi
124ce9f call   7bba10 <_ZZN5mochi21FrictionStickDistanceEvENKUlvE_clEv@plt>
124cea4 vmovsd %xmm0,0x0(%r13)
124ceaa mov    0xbbb357(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124ceb1 call   7bef10 <__cxa_guard_release@plt>
124ceb6 jmp    124c4ff <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x122f>
124cebb jmp    124cec5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1bf5>
124cebd jmp    124cec5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1bf5>
124cebf jmp    124cec5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1bf5>
124cec1 jmp    124cec5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1bf5>
124cec3 jmp    124cec5 <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1bf5>
124cec5 mov    %rax,%rbx
124cec8 mov    0xbbb339(%rip),%rdi        # 1e08208 <_ZGVZN5mochi21FrictionStickDistanceEvE6kStick@@Base-0x3e0f0>
124cecf call   7b9b70 <__cxa_guard_abort@plt>
124ced4 mov    %fs:0x28,%rax
124cedd cmp    0x5a0(%rsp),%rax
124cee5 jne    124ceef <_ZN5mochi37ComputeBatchCollisionForceDForceSenuaILi4ELNS_10GradTargetE0EEEvNS_4SpanIdmEENS2_INS_7NdArrayIdLm3EJEEEmEENS2_INS4_INS_4SimdIdLi4ENS_11SimdConceptEEELm3EJEEEmEENS2_IKdmEENS2_IKS5_mEESD_SF_SF_SF_SF_RKNS_13ContactParamsERKNS_17ContactEvalConfigEdbbbbSF_+0x1c1f>
124cee7 mov    %rbx,%rdi
124ceea call   7c3330 <_Unwind_Resume@plt>
124ceef vzeroupper
124cef2 call   7b4ef0 <__stack_chk_fail@plt>

Disassembly of section .fini:
