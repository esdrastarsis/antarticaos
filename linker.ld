ENTRY(start)

MAGIC_NUMBER = 0xe85250d6;

SECTIONS {
  . = 1M;

  .boot :
  {
    header_start = .;

    /* Numero Magico */
    LONG(MAGIC_NUMBER)

    LONG(0)

    LONG(header_end - header_start)

    LONG(0x100000000 - (MAGIC_NUMBER + (header_end - header_start)))

    SHORT(0)

    SHORT(0)

    LONG(8)

    header_end = .;
  }

  .text :
  {
    KEEP(*(.text.start))
    *(.text.*)
  }

  /DISCARD/ :
  {
    *(.note.gnu.*)
  }
}
