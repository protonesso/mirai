ENTRY(start)
SECTIONS {
	. = 1M;

	/* Put multiboot header */
	.text :
	{
		*(.multiboot)
		*(.text)
	}

	/* Read-only data. */
	.rodata :
	{
		*(.rodata)
	}

	/* Read-write data (initialized) */
	.data :
	{
		*(.data)
	}

	/* gcc's eh */
	.eh_frame :
	{
		*(.eh_frame)
	}

	/* Read-write data (uninitialized) and stack */
	.bss :
	{
		*(COMMON)
		*(.bss)
	}
}
