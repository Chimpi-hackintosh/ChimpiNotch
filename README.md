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

## 🚀 Compilação manual pelo GitHub Actions

**Só o proprietário `Chimpi-hackintosh` inicia a compilação quando quiser** pela aba Actions. Não existe compilação automática por push, commit ou atualização de arquivos. O GitHub Actions usa uma máquina macOS na nuvem, então você não precisa de um Mac nem do Xcode instalado no seu computador

### Como baixar o app pronto

1. Abra [**Actions**](https://github.com/Chimpi-hackintosh/ChimpiNotch/actions)
2. Selecione **Compilar ChimpiNotch para macOS**
3. Logado como **Chimpi-hackintosh**, escolha a branch `main` e clique em **Run workflow** → **Run workflow**
4. Abra a execução concluída com sucesso ✅
5. Na seção **Artifacts**, baixe **ChimpiNotch-macOS-Universal**
6. Extraia o ZIP baixado e depois o `ChimpiNotch-macOS-Universal.zip` que está dentro para obter o `ChimpiNotch.app`
7. No Mac, mova o aplicativo para **Aplicativos**

**A execução é exclusivamente manual** (`workflow_dispatch`). O workflow também verifica o nome de usuário de quem o acionou: se não for `Chimpi-hackintosh`, os passos de compilação serão ignorados. Após uma execução bem-sucedida, o ZIP aparece como artefato no GitHub Actions

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
- `.github/workflows/compilar-macos.yml`: workflow de execução **manual** pelo proprietário no **GitHub Actions**

Feito por **Chimpi-hackintosh** 🍎
