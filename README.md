# UART-Verilog
 UART Serial Communication System (Verilog) This repository contains a Verilog-based implementation of a UART (Universal Asynchronous Receiver/Transmitter), including the transmitter, receiver, baud rate generator, and a testbench for simulation.


##  Features

- ✅ Parameterized UART system
- ✅ 16x oversampling UART Receiver
- ✅ Modular, reusable Verilog code
- ✅ Simulation-ready using **Icarus Verilog + GTKWave**
- ✅ Testbenches for individual modules and top-level loopback


## 📁 File Structure

| File Name              | Description                                                    |
|------------------------|----------------------------------------------------------------|
| `Top_tb.v`             | Loopback testbench for end-to-end UART system                 |
| `Topmodule.v`          | Top-level UART module integrating TX, RX, and baud generator   |
| `Transmiiter.v`        | UART transmitter module (**typo**, should be `Transmitter.v`)  |
| `Tx_tb.v`              | Testbench for the transmitter module                          |
| `receiver.v`           | UART receiver with 16x oversampling                           |
| `Rx_tb.v`              | Testbench for the receiver module                             |
| `baudrateGenerator.v`  | Baud rate generator module (1x and 16x ticks)                 |
| `baudrate_tb.v`        | Testbench for baud rate generator                             |
| `uart_top.vcd`         | Waveform output file generated during simulation              |
| `README.md`            | Project overview, instructions, and documentation             |
| `LICENSE`              | Open-source license                                           |


## 📐 Configuration

| Parameter        | Value       |
|------------------|-------------|
| Clock Frequency  | 1.536 MHz   |
| Baud Rate        | 9600        |
| Oversampling     | 16x (Receiver) |

---

## 🧪 Testbenches

| File           | Description                                   |
|----------------|-----------------------------------------------|
| `baudrate_tb.v`| Validates generation of `baud_tick` and `baud_tick_16x` |
| `Tx_tb.v`      | Verifies correct serial transmission of data |
| `Rx_tb.v`      | Tests RX sampling logic and error detection  |
| `Top_tb.v`     | Simulates full UART loopback TX → RX        |

---

## 🧰 How to Run

### 📦 Compile
```bash
iverilog -o uart_test Top_tb.v Topmodule.v Transmiiter.v receiver.v baudrateGenerator.v
