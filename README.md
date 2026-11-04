<div align="center">

# ⚡ ESC_Brushed

### Firmware de ESC escovado dual para STM32F103C8T6

**iBUS · FlySky · PWM · Ponte H · Servo · DMA · STM32 HAL**

![MCU](https://img.shields.io/badge/MCU-STM32F103C8T6-03234B?style=flat-square&logo=stmicroelectronics&logoColor=white)
![Build](https://img.shields.io/badge/Build-CMake%20%2B%20Ninja-064F8C?style=flat-square&logo=cmake&logoColor=white)
![Editor](https://img.shields.io/badge/Editor-VS%20Code-007ACC?style=flat-square&logo=visualstudiocode&logoColor=white)
![HAL](https://img.shields.io/badge/STM32-HAL-1E90FF?style=flat-square)
![C](https://img.shields.io/badge/C-11-00599C?style=flat-square&logo=c&logoColor=white)
![Protocol](https://img.shields.io/badge/Protocol-iBUS%20%7C%20FlySky-FF6F00?style=flat-square)
![License](https://img.shields.io/badge/License-GPLv3-blue?style=flat-square)
![Status](https://img.shields.io/badge/status-prot%C3%B3tipo%20funcional-yellow?style=flat-square)

> **EN:** A compact, DMA-driven brushed ESC firmware for the STM32F103C8T6 (Blue Pill):
> FlySky iBUS input, dual H-bridge motor control, two servo outputs and a built-in
> fail-safe — all in bare-metal C with STM32 HAL.

**Construído sobre a biblioteca [J3 iBus FlySky](https://github.com/NelsonLima07/iBus_FlySky).**

</div>

<p align="center">
  <img src="Docs/Esquema.png" alt="Esquema elétrico do ESC_Brushed" width="760">
</p>

---

## 🚀 O que é este projeto?

Um firmware enxuto e direto ao ponto que transforma um **STM32F103C8T6 (Blue Pill)** em um
**controlador de ESC escovado duplo**. O receptor FlySky fala **iBUS** pela UART, o STM32
interpreta até **14 canais com checksum**, gera **dois PWM de servo** e comanda **duas pontes H**
para os motores — com **DMA**, **HAL** e **fail-safe** de série.

Sem bibliotecas pesadas, sem RTOS, sem bit-banging: só o essencial, em C, rodando a **72 MHz**.

---

## ✨ Destaques

- ⚡ **Recepção 100% por DMA** — a CPU não fica presa esperando bytes da UART.
- 🧠 **Biblioteca iBUS dedicada** — 14 canais, little-endian, com validação de checksum.
- 🎛️ **PWM em hardware** — TIM2 (servos, 50 Hz) e TIM3 (motores, 1 kHz) sem software timing.
- 🚗 **Duas pontes H** — controle de sentido e velocidade para motores A e B.
- 🛡️ **Fail-safe inteligente** — sem sinal por 5 s, pontes param e servos centralizam.
- 🧩 **Estrutura modular** — aplicação isolada em `firmware/Core/Src/usr`, pronta para o CubeMX.
- 🛠️ **Build moderno** — CMake + Ninja com presets `debug`/`release`, toolchain ARM GNU e VS Code.
- 📦 **Biblioteca via submódulo** — versão reproduzível de [J3 iBus FlySky](https://github.com/NelsonLima07/iBus_FlySky).
- 🪶 **Leve** — ~11 KB de flash e ~1,9 KB de RAM no build Debug.
- 🔌 **Pronto para o Blue Pill** — pinagem documentada e configuração `.ioc` incluída.

---

## 🧠 Arquitetura

```mermaid
flowchart LR
    RX[📡 Receptor FlySky] -- iBUS 115200 --> UART[USART1 + DMA]
    UART --> PARSER[Parser iBUS<br/>14 canais + checksum]
    PARSER --> MAP[🎮 Canais 1..14]
    MAP --> SERVO[Servos S1 / S2]
    MAP --> MOTOR[Motores A / B]
    SERVO --> TIM2[TIM2 · 50 Hz]
    MOTOR --> TIM3[TIM3 · 1 kHz]
    MOTOR --> H[Ponte H<br/>A1/A2 · B1/B2]
    MAP --> FS[🛡️ Fail-safe]
    FS --> STOP[Ponte parada<br/>servos em 1500 µs]
```

O fluxo é simples de propósito: **recebe → valida → mapeia → atua**. Cada quadro iBUS válido
atualiza os canais; o loop principal só aplica os valores nos periféricos.

---

## 🔌 Hardware e pinagem

| Função | Pino | Periférico / Configuração |
|---|---|---|
| iBUS RX | **PB7** | `USART1_RX` remapeado · 115200 8N1 |
| iBUS TX | **PB6** | `USART1_TX` remapeado (não utilizado) |
| Servo S1 | **PA2** | `TIM2_CH3` · 50 Hz · 1000–2000 µs |
| Servo S2 | **PA3** | `TIM2_CH4` · 50 Hz · 1000–2000 µs |
| Motor A (PWM) | **PA6** | `TIM3_CH1` · 1 kHz |
| Motor B (PWM) | **PA7** | `TIM3_CH2` · 1 kHz |
| Ponte A (sentido) | **PC14 / PC15** | `A1 / A2` · GPIO push-pull |
| Ponte B (sentido) | **PA4 / PA5** | `B1 / B2` · GPIO push-pull |
| LED de status | **PC13** | GPIO · pisca a cada 1 s |
| Debug | **PA13 / PA14** | SWD |

> Consulte `Docs/stm32f103c8t6_pinout_voltage01.png` e `Docs/Ponte_H_L298_HW95.jpg` para o
> esquema completo da montagem.

---

## ⏱️ Temporização

| Periférico | Clock | Prescaler | Período | Resultado |
|---|---|---|---|---|
| SYSCLK | 8 MHz × 9 | — | — | **72 MHz** |
| TIM2 (servos) | 72 MHz | 71 | 19999 | **50 Hz** · pulso 1–2 ms |
| TIM3 (motores) | 72 MHz | 71 | 999 | **1 kHz** · duty 0–100% |

---

## 📡 Protocolo iBUS (FlySky)

Cada quadro tem **32 bytes**:

```text
┌──────┬──────┬─────────────────────────────┬──────────────┐
│ 0x20 │ 0x40 │  CH1..CH14  (28 bytes, LE)  │  Checksum    │
└──────┴──────┴─────────────────────────────┴──────────────┘
   len    cmd          1000..2000 µs           0xFFFF - soma
```

O checksum é calculado como `0xFFFF - soma(todos os bytes do pacote)`. Se não bater, o quadro
é descartado e os canais anteriores são preservados — nada de valores corrompidos indo para os
motores.

---

## 🔗 Projetos relacionados

### 📡 J3 iBus FlySky — a biblioteca por trás do receptor

Este firmware nasceu junto com a biblioteca **[J3 iBus FlySky](https://github.com/NelsonLima07/iBus_FlySky)**,
uma implementação em C do protocolo iBUS para STM32 com HAL, DMA e validação de checksum.

| | Este projeto | J3 iBus FlySky |
|---|---|---|
| **Foco** | Aplicação completa de ESC escovado | Biblioteca reutilizável de iBUS |
| **Conteúdo** | Servos, pontes H, fail-safe, LED | Parser, receptor, API e exemplo |
| **Build** | CMake + Ninja (+ `.ioc`) | CMake + Ninja (+ `.ioc`) |
| **Licença** | GPL-3.0 | GPL-3.0 |

> A biblioteca é consumida como **submódulo Git** em `libs_github/iBus_FlySky`, fixada em um
> commit conhecido. Isso mantém uma única fonte de verdade, garante builds reproduzíveis e evita
> duplicar código GPLv3. A aplicação usa a API pública `J3_IBus_*` (inicialização, tarefa,
> leitura de canais e tratamento de callbacks da UART).

<p align="left">
  <a href="https://github.com/NelsonLima07/iBus_FlySky">
    <img src="https://img.shields.io/badge/GitHub-iBus__FlySky-181717?style=flat-square&logo=github&logoColor=white" alt="J3 iBus FlySky">
  </a>
</p>

---

## 🧩 Estrutura do projeto

```text
ESC_Brushed/
├── CMakeLists.txt                # build do firmware (CMake + Ninja)
├── CMakePresets.json             # presets debug / release
├── build.bat                     # atalhos de build no Windows
├── .clangd                       # IntelliSense/clangd via compile_commands.json
├── cmake/
│   └── arm-none-eabi.cmake       # toolchain ARM GNU
├── firmware/                     # projeto STM32 (ex-CubeIDE/J3_ESC_Brushed)
│   ├── Core/
│   │   ├── Inc/usr/              # headers da aplicação
│   │   ├── Src/usr/              # main_ESC_Brushed.c
│   │   ├── Src/                  # main.c · tim.c · usart.c · dma.c · gpio.c ...
│   │   └── Startup/startup_stm32f103c8tx.s
│   ├── Drivers/                  # STM32F1 HAL + CMSIS
│   ├── J3_ESC_Brushed.ioc        # configuração CubeMX
│   └── STM32F103C8TX_FLASH.ld    # linker script
├── libs_github/
│   └── iBus_FlySky/              # submódulo Git (biblioteca iBUS)
├── Docs/
│   ├── Descricao.txt
│   ├── Esquema.png
│   ├── Ponte_H_L298_HW95.jpg
│   ├── stm32f103c8t6_pinout_voltage01.png
│   └── dm00042534-stm32-cross-series-timer-overview.pdf
├── .vscode/                      # settings, tasks, launch e extensões
├── LICENSE
└── README.md
```

---

## 🛠️ Como compilar

### Pré-requisitos

| Ferramenta | Versão sugerida | Instalação (Windows) |
|---|---|---|
| **CMake** | ≥ 3.25 | `winget install --id Kitware.CMake -e` |
| **Ninja** | ≥ 1.11 | `winget install --id Ninja-build.Ninja -e` |
| **ARM GNU Toolchain** | ≥ 12 | `winget install --id Arm.GnuArmEmbeddedToolchain -e` |
| **VS Code** | atual | [code.visualstudio.com](https://code.visualstudio.com/) |

Extensões recomendadas: **CMake Tools**, **C/C++** e **Cortex-Debug** (veja `.vscode/extensions.json`).

### Clone com submódulo

```bash
git clone --recursive https://github.com/NelsonLima07/ESC_Brushed.git
cd ESC_Brushed
```

Se o repositório já foi clonado sem `--recursive`:

```bash
git submodule update --init --recursive
```

### Linha de comando

```bash
cmake --preset debug          # configura
cmake --build --preset debug  # compila

# ou, no Windows:
build.bat                     # debug
build.bat release             # release (-Os)
build.bat all                 # debug + release
build.bat clean               # limpa build/ antes de compilar
```

Artefatos gerados em `build/debug/` e `build/release/`:

```text
J3_ESC_Brushed.elf   # executável com símbolos
J3_ESC_Brushed.hex   # para gravacao
J3_ESC_Brushed.bin   # imagem binaria
J3_ESC_Brushed.map   # mapa de memoria
```

### VS Code

1. Abra a pasta do repositório.
2. Aceite as extensões recomendadas.
3. O CMake Tools detecta os presets automaticamente (`debug`/`release`).
4. `Ctrl+Shift+B` compila o preset **debug**.
5. Para depurar, use a configuração **Debug (OpenOCD / ST-Link)** (requer OpenOCD e ST-Link).

> A gravação/depuração é opcional e depende de ferramentas externas. O build não precisa delas.
> O target `flash` usa `STM32_Programmer_CLI` ou `OpenOCD` quando disponíveis.

### Regeneração pelo CubeMX

O arquivo `firmware/J3_ESC_Brushed.ioc` continua versionado. Ao regenerar o código, mantenha os
blocos `USER CODE` e confira o clock em **72 MHz** e os prescalers dos timers (`71`).

---

## ⚙️ Configuração rápida

| Macro | Padrão | O que faz |
|---|---|---|
| `CH_SERVO_A` | `1` | Canal do rádio para o servo S1 |
| `CH_SERVO_B` | `2` | Canal do rádio para o servo S2 |
| `CH_MOTOR_A` | `3` | Canal do rádio para o motor A |
| `CH_MOTOR_B` | `4` | Canal do rádio para o motor B |
| `RX_VAL_MIN` | `1000` | Pulso mínimo aceito (µs) |
| `RX_VAL_MAX` | `2000` | Pulso máximo aceito (µs) |
| `RX_REVERSE` | `true` | Habilita ré nos motores |
| `REVERSE_OFFSET` | `50` | Zona morta ao redor de 1500 µs |
| `FAIL_OVER_ATIVO` | `true` | Liga o fail-safe |
| `FAIL_OVER_TEMPO` | `5` | Tempo sem sinal até parar (s) |

Ajuste os canais conforme o seu rádio em `firmware/Core/Src/usr/main_ESC_Brushed.c`.

---

## 🛡️ Fail-safe

Se nenhum quadro válido chegar dentro de `FAIL_OVER_TEMPO` segundos:

- as duas pontes H vão para **parado**;
- os servos voltam ao **centro (1500 µs)**;
- o LED continua piscando como sinal de vida.

Quando o sinal volta, o controle é retomado automaticamente no próximo quadro válido.

---

## 🗺️ Roadmap

- [x] Recepção iBUS com DMA
- [x] Dois servos + duas pontes H
- [x] Fail-safe por timeout
- [x] Biblioteca iBUS via submódulo
- [x] Build CMake + Ninja + VS Code
- [ ] Modo de configuração (botão + EEPROM)
- [ ] Mixagem diferencial para tração
- [ ] DMA circular + interrupção de IDLE da UART
- [ ] Telemetria / debug por UART
- [ ] Ferramenta de calibração no PC
- [ ] Testes unitários do parser iBUS

---

## ⚠️ Notas de protótipo

- Este é um projeto em evolução — valide a pinagem e os limites de corrente antes de usar em
  cargas reais.
- Ao regenerar o código pelo CubeMX, revise a configuração de clock e dos prescalers dos timers.

---

## 🤝 Contribuindo

Contribuições são bem-vindas! Abra uma **issue** com sua ideia ou envie um **pull request** com
melhorias de robustez, documentação ou novos recursos.

1. Faça um fork
2. Crie uma branch (`git checkout -b feature/minha-ideia`)
3. Commit (`git commit -m 'feat: minha ideia'`)
4. Push (`git push origin feature/minha-ideia`)
5. Abra o Pull Request

---

## 📄 Licença

Distribuído sob a **GPL-3.0**.

Este projeto utiliza a biblioteca
[J3 iBus FlySky](https://github.com/NelsonLima07/iBus_FlySky), também licenciada sob GPL-3.0.
Veja o arquivo [`LICENSE`](LICENSE) para mais detalhes.

---

## 👤 Autor

**Nelson Lima** · [@NelsonLima07](https://github.com/NelsonLima07)

---

<div align="center">

**STM32** · **STM32F103C8T6** · **Blue Pill** · **ESC escovado** · **Brushed ESC** · **Ponte H** ·
**H-Bridge** · **L298N** · **HW95** · **iBUS** · **FlySky** · **J3 iBus FlySky** · **RC** ·
**Servo** · **PWM** · **DMA** · **UART** · **STM32CubeMX** · **STM32 HAL** · **CMake** · **Ninja** ·
**VS Code** · **Firmware** · **C** · **GPLv3** · **Robótica** · **DIY**

*Feito com ⚡ e alguns fios a mais.*

</div>
