.PHONY: cargo test iso run

cargo:
	@RUST_TARGET_PATH=$(shell pwd) xargo build --release --target x86_64-antarticaos

update:
	@rustup update nightly
	@rustup component add rust-src

test:
	@cd console && cargo test
	@cd interrupts && cargo test
	@cd keyboard && cargo test
	@cd pic && cargo test

iso: cargo grub.cfg
	@mkdir -p target/isofiles/boot/grub
	@cp grub.cfg target/isofiles/boot/grub
	@cp target/x86_64-antarticaos/release/antarticaos target/isofiles/boot/
	@grub-mkrescue -o target/AntarticaOS-x86_64.iso target/isofiles

run: iso
	@qemu-system-x86_64 -cdrom target/AntarticaOS-x86_64.iso

clean:
	@cargo clean
