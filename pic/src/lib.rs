#![feature(asm)]
#![no_std]

extern crate x86;
use x86::shared::io::{inb, outb};

const PIC1_CMD_IO_PORT: u16 = 0x0020;
const PIC2_CMD_IO_PORT:u16 = 0x00A0;
const PIC1_DATA_IO_PORT: u16 = 0x0021;
const PIC2_DATA_IO_PORT: u16 = 0x00A1;

const ICW1: u8 = 0x11;
const ICW4: u8 = 0x1;

const PIC1_VECTOR_OFFSET: u8 = 0x20;
const PIC2_VECTOR_OFFSET: u8 = 0x28;


pub fn remap() {
    unsafe {
        let pic1_mask = inb(PIC1_DATA_IO_PORT);
        let pic2_mask = inb(PIC2_DATA_IO_PORT);

        outb(PIC1_CMD_IO_PORT, ICW1);
        outb(PIC2_CMD_IO_PORT, ICW1);

        outb(PIC1_DATA_IO_PORT, PIC1_VECTOR_OFFSET);
        outb(PIC2_DATA_IO_PORT, PIC2_VECTOR_OFFSET);

        outb(PIC1_DATA_IO_PORT, 4);

        outb(PIC2_DATA_IO_PORT, 2);

        outb(PIC1_DATA_IO_PORT, ICW4);
        outb(PIC2_DATA_IO_PORT, ICW4);

        outb(PIC1_DATA_IO_PORT, pic1_mask);
        outb(PIC2_DATA_IO_PORT, pic2_mask);
    }
}

pub fn eoi_for(interrupt_number: isize) {
    unsafe {
        match interrupt_number {
            i if i >= 40 => {
                outb(0xA0, 0x20);
                outb(0x20, 0x20);
            },
            32...40 => outb(0x20, 0x20),
            _ => {},
        }
    }
}
