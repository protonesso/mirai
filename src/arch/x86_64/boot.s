/* Declare Multiboot header */
.set ALIGN,	1<<0			/* Align loaded modules on page boundaries */
.set MEMINFO,	1<<1			/* Provide memory mapping information */
.set MAGIC,	0x1BADB002		/* Multiboot's magic number */
.set FLAGS,	ALIGN | MEMINFO		/* Declare Multiboot 'flag' field */
.set CHECKSUM,	-(MAGIC + FLAGS)	/* Checksum of MAGIC and FLAGS */

/* Declare Multiboot section */
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

/* Declare the BSS section */
.section .bss
.align 16
pml4:
.skip 4096
pml3:
.skip 4096
pml2:
.skip 4096
pml1_a:
.skip 4096
pml1_b:
.skip 4096
stack_bottom:
.skip 16386 /* Define stack size is 16KB */
stack_top:

/* Declare the text section and `start` function */
.section .text
.global start
.type start, @function
.code32
start:
	/* Initialize stack */
	movl $stack_top, %esp

	/* Initialize 64-bit PAE */
	movl %cr4, %eax
	btsl $(5), %eax
	movl %eax, %cr4

	/* Load the physical pointer to the top level page table */
	movl $pml4, %edi
	movl %edi, %cr3

	/* Page-Map Level 4 */
	movl $(pml3 + 0x207), pml4 + 0 * 8

	/* Page Directory Pointer Table */
	movl $(pml2 + 0x207), pml3 + 0 * 8

	/* Page Directory (no user-space access here) */
	movl $(pml1_a + 0x003), pml2 + 0 * 8
	movl $(pml1_b + 0x003), pml2 + 1 * 8

	movl $(pml1_a + 8), %edi
	movl $0x1003, %esi
	movl $1023, %ecx

	/* Initialize Long Mode */
	movl $0xc0000080, %ecx
	rdmsr
	orl $0x900, %eax
	wrmsr

	/* Jump in Rust code */
	call kmain

	/* Halt the system */
	cli
1:	hlt
	jmp 1b

.size start, . - start
