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

### Como baixar o app pronto

1. Abra [**Actions**](https://github.com/Chimpi-hackintosh/ChimpiNotch/actions)
2. Selecione **Compilar ChimpiNotch para macOS**
3. Logado como **Chimpi-hackintosh**, escolha a branch `main` e clique em **Run workflow** → **Run workflow**
4. Abra a execução concluída com sucesso ✅
5. Na seção **Artifacts**, baixe **ChimpiNotch-macOS-Universal**
6. Extraia o ZIP baixado e depois o `ChimpiNotch-macOS-Universal.zip` que está dentro para obter o `ChimpiNotch.app`
7. No Mac, mova o aplicativo para **Aplicativos**

Somente a conta `Chimpi-hackintosh` pode executar a etapa que gera o aplicativo. Depois que a execução terminar com sucesso, o ZIP fica disponível em **Artifacts**

> **Importante:** o `.app` só fica disponível **depois que o workflow terminar com sucesso**. O GitHub Actions não disponibiliza automaticamente esse arquivo em *Releases*

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
