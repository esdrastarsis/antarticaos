use std::process::Command;
use std::env;
use std::path::Path;

fn main() {
    let out_dir = env::var("OUT_DIR").unwrap();

    assert!(Command::new("nasm")
                .args(&["src/asm/boot/x86/boot.asm", "-felf64", "-o"])
                .arg(&format!("{}/boot.o", out_dir))
                .status()
                .expect("Erro na Compilação do boot.asm, PorFavor Instale o Netwide Assembler (nasm)")
                .success(),
            "Falha na Compilação do boot.asm");

    assert!(Command::new("ar")
                .args(&["crus", "libboot.a", "boot.o"])
                .current_dir(&Path::new(&out_dir))
                .status()
                .expect("Falha ao Executar o comando ar")
                .success(),
            "Falha no Comando ar");

    println!("cargo:rustc-link-search=native={}", out_dir);
    println!("cargo:rustc-link-lib=static=boot");
    println!("cargo:rerun-if-changed=/src/asm/boot.asm");
}
