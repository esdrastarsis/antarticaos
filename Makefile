.PHONY: cargo test iso run

cargo:
	xargo build --release --target x86_64-antarticaos

test:
	cd console && cargo test
	cd interrupts && cargo test
	cd keyboard && cargo test
	cd pic && cargo test

iso: cargo grub.cfg
	mkdir -p target/isofiles/boot/grub
	cp grub.cfg target/isofiles/boot/grub
	cp target/x86_64-antarticaos/release/antarticaos target/isofiles/boot/
	grub-mkrescue -o target/AntarticaOS-0.1.2-x86_64.iso target/isofiles

run: iso
	qemu-system-x86_64 -cdrom target/AntarticaOS-0.1.2-x86_64.iso

clean:
	cargo clean
