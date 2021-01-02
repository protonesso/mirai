#![no_std]
#![no_main]
#![feature(global_asm)]
#![feature(lang_items)]

use core::panic::PanicInfo;

#[cfg(target_arch = "x86_64")]
global_asm!(include_str!("arch/x86_64/start.s"));

#[no_mangle]
pub extern "C" fn kmain() -> ! {
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
