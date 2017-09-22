use core::fmt;
use ::CONTEXT;

#[lang = "panic_fmt"]
#[no_mangle]

pub extern fn rust_begin_panic(msg: fmt::Arguments,
                                file: &'static str,
                                line: u32) -> ! {
        kprintln!(CONTEXT, "ABRAAO PANIC em {}:{}! Mensagem: {}", file, line, msg);
        loop {}
}
