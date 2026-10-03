# RV32I RISC-V System-on-Chip (SoC) on Terasic DE10-Lite

![RISC-V](https://img.shields.io/badge/ISA-RISC--V%20RV32I-blue)
![FPGA](https://img.shields.io/badge/FPGA-Intel%20MAX%2010-orange)
![Toolchain](https://img.shields.io/badge/Tools-Quartus%20Prime%20%7C%20Icarus%20Verilog%20%7C%20GTKWave-brightgreen)

An end-to-end implementation of a 32-bit RISC-V System-on-Chip (SoC) synthesized on the Intel MAX 10 FPGA (Terasic DE10-Lite). The core implements the base unprivileged RV32I Instruction Set Architecture (ISA) with custom Memory-Mapped I/O (MMIO) driving on-board peripherals.

---

## 🌟 Key Features

- **CPU Core**: Single-cycle RV32I RISC-V architecture.
- **On-Chip Memory**: 4 KB Block RAM initialized with custom firmware.
- **MMIO Bus Interconnect**: Interfaced peripherals accessible via specific memory-mapped registers.
- **Hardware Peripherals**:
  - 10-bit LED status output.
  - Dual 7-segment display decoder (hexadecimal format).
  - 10-bit DIP switch input controller.
- **Verification & Synthesis**: Verified via Icarus Verilog testbenches and GTKWave before full hardware physical synthesis on Quartus Prime.

---

## 📐 Memory & MMIO Map

| Address Space | Target Module | Description / Access |
| :--- | :--- | :--- |
| `0x0000_0000 - 0x0000_0FFF` | **Block RAM (4KB)** | Instruction & Data Memory Space |
| `0x8000_0000` | **LED Register (`LEDR`)** | Write-only (Bits `[9:0]`) |
| `0x8000_0004` | **HEX Display (`HEX0-1`)** | Write-only (Hexadecimal decode) |
| `0x8000_0008` | **Slide Switches (`SW`)** | Read-only (Bits `[9:0]`) |

---

## 📂 Project Structure

```text
├── firmware/         # Firmware source code and compiled .hex binaries
│   └── program.hex
├── quartus/          # Intel Quartus Prime synthesis project & pin assignments
│   ├── DE10_Lite_SoC.qpf
│   └── DE10_Lite_SoC.qsf
├── rtl/              # Verilog Hardware Description Source Code
│   ├── core/         # RV32I Processor Pipeline Logic (ALU, RegFile, PC, Decoder)
│   ├── memory/       # Block RAM logic
│   ├── peripherals/  # 7-Segment Decoder and MMIO interfaces
│   └── soc_top.v     # Top-level SoC integration
├── sim/              # Simulation Testbenches and GTKWave dump configurations
│   ├── tb_soc_top.v
│   └── run_sim.bat
└── README.md