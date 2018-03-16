## O Antartica OS é um Sistema Operacional (Hobby OS) Open Source, criado por Esdras Tarsis, com o propósito de aprendizado de implementação de Sistemas Operacionais

Para compilar é necessário ter os seguintes pacotes instalados no seu sistema (GNU/Linux):

### Debian e Derivados:

    $ sudo apt-get install nasm xorriso qemu build-essential

### Arch Linux e Derivados:

    $ sudo pacman -S --needed binutils grub mtools libisoburn nasm qemu

### Fedora:

    $ sudo dnf install nasm xorriso qemu

Para instalar a Linguagem rust execute o seguinte comando:

    $ curl https://sh.rustup.rs -sSf | sh

Para instalar o xargo execute o seguinte comando:

    $ cargo install xargo

(o cargo já vem com a linguagem rust)

Para instalar o toolchain usado pelo projeto (especificado no arquivo
`rust-toolchain`), execute:

    $ rustup install nightly-2018-03-15
	$ rustup component add rust-src

Para compilar o projeto execute o seguinte comando:

    $ make iso

Se você tiver o qemu, você pode compilar e rodar em seguida:

    $ make run
