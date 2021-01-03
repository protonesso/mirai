#![no_std]
#![no_main]
#![feature(global_asm)]
#![feature(lang_items)]

use core::panic::PanicInfo;

#[cfg(target_arch = "x86_64")]
global_asm!(include_str!("arch/x86_64/boot.s"));

#[cfg(target_arch = "x86")]
global_asm!(include_str!("arch/x86/boot.s"));

pub fn welcome() {
	static HELLO: &[u8] = b"Welcome to mirai!";
	let vga_buf = 0xb8000 as *mut u8;

	for (i, &byte) in HELLO.iter().enumerate() {
		unsafe {
			*vga_buf.offset(i as isize * 2) = byte;
			*vga_buf.offset(i as isize * 2 + 1) = 0xf;
		}
	}
}

#[no_mangle]
pub extern "C" fn kmain() -> ! {
	welcome();
	loop {}
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
	loop {}
}

#[lang = "eh_personality"]
#[no_mangle]
pub extern "C" fn eh_personality() {
	loop {}
}

#[no_mangle]
pub extern "C" fn _Unwind_Resume() {
	loop {}
}
