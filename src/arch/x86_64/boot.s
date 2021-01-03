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
	mov $stack_top, %esp

	/* Jump in Rust code */
	call kmain

	/* Halt the system */
	cli
1:	hlt
	jmp 1b

.size start, . - start
