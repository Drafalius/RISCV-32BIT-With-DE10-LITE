@echo off
echo ===================================================
echo   Compiling RISC-V SoC with Icarus Verilog...
echo ===================================================

cd sim
iverilog -o sim.out tb_soc_top.v ^
    ../rtl/soc_top.v ^
    ../rtl/core/riscv_top.v ^
    ../rtl/core/alu.v ^
    ../rtl/core/reg_file.v ^
    ../rtl/core/control_unit.v ^
    ../rtl/core/pc.v ^
    ../rtl/core/imm_gen.v ^
    ../rtl/memory/memory.v ^
    ../rtl/peripherals/hex_decoder.v

if %errorlevel% neq 0 (
    echo [ERROR] Compilation failed!
    pause
    exit /b %errorlevel%
)

echo Running VVP Simulation...
vvp sim.out

echo Opening GTKWave...
gtkwave dump.vcd