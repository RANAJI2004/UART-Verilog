# UART-Verilog
 UART Serial Communication System (Verilog) This repository contains a Verilog-based implementation of a UART (Universal Asynchronous Receiver/Transmitter), including the transmitter, receiver, baud rate generator, and a testbench for simulation.


##  Features

- ✅ Parameterized UART system
- ✅ 16x oversampling UART Receiver
- ✅ Modular, reusable Verilog code
- ✅ Simulation-ready using **Icarus Verilog + GTKWave**
- ✅ Testbenches for individual modules and top-level loopback

#  Verilog UART Core

This project implements a complete **UART (Universal Asynchronous Receiver/Transmitter)** system in Verilog, including:
- a **transmitter**
- a **receiver with 16x oversampling**
- a **baud rate generator**, and
- a **loopback testbench**

It is designed to simulate a real UART communication system and verify data integrity using a self-checking testbench.

---

## 📌 Overview

UART is a serial communication protocol that uses only two wires (TX and RX). It is widely used for low-speed, short-distance communication between microcontrollers, sensors, or PCs. This project replicates UART behavior in hardware using Verilog.

---

## 🔍 Project Modules

| Module                 | Description |
|------------------------|-------------|
| `Transmiiter.v`        | UART Transmitter — sends start bit, 8 data bits (LSB first), and stop bit. Triggers `tx_done` when complete. (**Fix filename typo: should be `Transmitter.v`**) |
| `receiver.v`           | UART Receiver — synchronizes incoming serial data using 3-stage flip-flops, then samples each bit using 16x oversampling. Detects framing errors and raises `rx_ready` when data is valid. |
| `baudrateGenerator.v`  | Baud Rate Generator — produces two clocks: `baud_tick` for TX (1x baud) and `baud_tick_16x` for RX (oversampling) based on the system clock. |
| `Topmodule.v`          | Combines TX, RX, and Baud Generator into one unified UART system. Takes in byte-level TX input and outputs received byte and flags. |

---

## 🧪 Testbenches

| Testbench File         | Purpose |
|------------------------|---------|
| `Tx_tb.v`              | Sends predefined bytes, verifies TX output serial stream (visually in waveform) |
| `Rx_tb.v`              | Simulates serial input bit stream and checks receiver output (`rx_data`, `rx_ready`) |
| `baudrate_tb.v`        | Validates accuracy of `baud_tick` and `baud_tick_16x` outputs at expected timing |
| `Top_tb.v`             | Full system test with TX and RX connected in loopback. Verifies end-to-end transmission, compares received and transmitted data, and prints success/failure |

---


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

## 🧰 How to Run

### 📦 Compile
```bash
iverilog -o uart_test Top_tb.v Topmodule.v Transmiiter.v receiver.v baudrateGenerator.v
