# ChimpiNotch 🍎

**ChimpiNotch** é uma barra flutuante para macOS, na região da câmera/notch, com atalhos para **navegadores, Contatos e Câmera**

> Descrição curta para o GitHub: 🍎 Widget flutuante para macOS com navegadores, Contatos e Câmera perto do notch | SwiftUI + AppKit

## Interface

```text
┌──────────────────────────────────────────────────────────────┐
│ 🌐 Chrome / outros navegadores │ 👤 Contatos │ 📷 Câmera │
└──────────────────────────────────────────────────────────────┘
```

## Funcionalidades

- **Navegadores:** oferece Chrome, Safari, Firefox, Edge, Brave, Opera e Arc quando encontrados no Mac
- **Contatos:** abre o aplicativo Contatos
- **Câmera:** abre o Photo Booth (não ativa a webcam em segundo plano)
- **Notch:** painel centralizado perto do topo, abaixo da área protegida pelo recorte quando necessário
- **Menu do macOS:** mostrar/esconder, recentralizar e sair

**Requisitos:** macOS 13 ou posterior, processador Intel ou Apple Silicon

## Abrir no Xcode

1. Abra `ChimpiNotch.xcodeproj`
2. Escolha **My Mac**
3. Clique em ▶ **Run**

## Compilar sem abrir Xcode

Em um Mac com as ferramentas de desenvolvimento da Apple instaladas, abra `compilar.command` ou rode:

```bash
bash scripts/compilar-macos.sh
```

Saídas esperadas: `build/ChimpiNotch.app` e `build/ChimpiNotch-macOS-Universal.zip`

## Compilar no GitHub Actions

1. Abra a aba [Actions](https://github.com/Chimpi-hackintosh/ChimpiNotch/actions)
2. Selecione **Compilar ChimpiNotch para macOS**
3. Clique em **Run workflow** na branch `main`
4. Após a compilação, abra a execução e baixe o artefato **ChimpiNotch-macOS-Universal**
5. Extraia o ZIP do artefato e depois `ChimpiNotch-macOS-Universal.zip` para obter o aplicativo `.app`

O workflow também roda automaticamente quando arquivos relevantes são enviados à branch `main`

## Segurança e funcionamento

O ChimpiNotch é um **app nativo com NSPanel**, não um widget WidgetKit que se desenha por cima da câmera física. A opção **Câmera** abre o Photo Booth. O pacote é assinado de modo ad-hoc e **não é notarizado pela Apple**, então o macOS pode solicitar uma confirmação de segurança ao executar

**O código-fonte não é um executável pronto:** a compilação precisa terminar com sucesso em macOS para produzir o `.app`

Desenvolvido para o projeto **ChimpiNotch**, da conta [Chimpi-hackintosh](https://github.com/Chimpi-hackintosh)
