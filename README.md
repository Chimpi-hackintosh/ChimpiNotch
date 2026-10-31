# 🍎 ChimpiNotch

Widget flutuante para **macOS 13+**, perto da câmera/notch do MacBook, com três atalhos:

```text
[ 🌐 Chrome / Outros navegadores | 👤 Contatos | 📷 Câmera ]
```

- **Navegadores:** escolha Chrome, Safari, Firefox, Edge e outros que estiverem instalados
- **Contatos:** abre o aplicativo Contatos do macOS
- **Câmera:** abre o Photo Booth
- **Barra de menus:** permite mostrar, esconder e centralizar o painel

Funciona em **Intel (x86_64)** e **Apple Silicon (arm64)**

## 🚀 Baixar o ChimpiNotch

O aplicativo é gerado pelo GitHub Actions em uma máquina macOS na nuvem, sem exigir que você instale o Xcode no seu computador

### Como gerar uma versão

1. Abra [**Actions**](https://github.com/Chimpi-hackintosh/ChimpiNotch/actions)
2. Selecione **Compilar ChimpiNotch para macOS**
3. Na conta **Chimpi-hackintosh**, escolha a branch `main` e clique em **Run workflow**
4. Aguarde a execução terminar com sucesso ✅

Quando a compilação concluir, **o próprio GitHub Actions criará uma versão em [Releases](https://github.com/Chimpi-hackintosh/ChimpiNotch/releases)**, com o arquivo `ChimpiNotch-macOS-Universal.zip` para baixar

A numeração é gerada por execução, como `v1.0.3`, e o ZIP inclui o `ChimpiNotch.app` para **Intel e Apple Silicon**

**Somente a conta `Chimpi-hackintosh` está autorizada a executar o job** e o workflow não inicia automaticamente ao receber novos commits

> O release só é criado **depois que a compilação terminar sem erros**. Não há nenhuma versão compilada garantida antes disso


## Como funciona

O ChimpiNotch é um app nativo em **SwiftUI + AppKit**, com painel flutuante (NSPanel). A barra é posicionada na parte superior da tela, logo abaixo da área segura da câmera/notch. Não ocupa fisicamente o recorte da câmera e não grava áudio ou vídeo

## Segurança

- Não precisa de senha nem chave de API
- O build é assinado **ad-hoc**, sem certificado Apple Developer
- O `.app` **não está notarizado** pela Apple, portanto o macOS pode pedir confirmação ao abrir
- Código-fonte e workflow de compilação ficam visíveis neste repositório

### Código

- `Sources/ChimpiNotch.swift`: interface e atalhos
- `Config/Info.plist`: metadados do app
- `scripts/compilar-macos.sh`: compila Intel + Apple Silicon, assina e gera ZIP
- `.github/workflows/compilar-macos.yml`: gera o aplicativo no **GitHub Actions**

Feito por **Chimpi-hackintosh** 🍎
