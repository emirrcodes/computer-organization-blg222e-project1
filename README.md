# 🔧 Computer Organization - BLG222E - Project 1

> **Istanbul Technical University**  
> Computer Engineering Department – Spring 2025  
> Course: BLG 222E – Computer Organization  
> Lecturer: Assoc. Prof. Dr. Gökhan İnce  

## 🧠 Overview

This project simulates a **basic computer system** capable of performing arithmetic and logic operations, storing results in memory/registers, and running sequential operations. All modules were developed using **Verilog HDL** and tested with **Vivado Design Suite**.

## 🛠️ Modules Implemented

| Module Name                 | Description                                                                 |
|----------------------------|-----------------------------------------------------------------------------|
| `Register16bit.v`          | 16-bit register with increment, decrement, clear, and load                  |
| `Register32bit.v`          | Extended 32-bit register with partial/full ops                              |
| `DataRegister.v`           | Data storage register with control ops                                      |
| `InstructionRegister.v`    | Holds current instruction, supports reset/load                              |
| `RegisterFile.v`           | General-purpose register set (R1–R4, S1–S4)                                 |
| `AddressRegisterFile.v`    | Holds memory-mapped address registers                                       |
| `ArithmeticLogicUnit.v`    | Performs arithmetic and logical operations based on `FunSel`                |
| `ArithmeticLogicUnitSystem.v` | Top-level unit combining all subcomponents                                |

## 🎮 Control Inputs Used

- `E`: Enable
- `rst`: Reset
- `FunSel`: Function Selector
- `I`: Input Data
- `RegSel`, `ScrSel`, `OutASel`, `OutBSel`: Register selectors

## 👥 Contributors

- **Ahmet Emir Arslan**  
  - Implemented: `AddressRegisterFile`, `ArithmeticLogicUnit`, `ArithmeticLogicUnitSystem`
- **Baran Turhan**  
  - Implemented: `Register16bit`, `Register32bit`, `DataRegister`, `InstructionRegister`, `RegisterFile`
- Both members worked together on **testing and debugging**.

## ✅ Results

- All modules successfully compiled and passed simulation tests in Vivado.
- ALU operations executed correctly.
- All registers and data paths responded properly to control signals.
- No logic or syntax errors detected during simulation.

## 🧠 Key Takeaways

- Learned how to design modular digital systems.
- Gained solid experience in **Verilog** and **Vivado simulation**.
- Understood the value of clean interfaces and teamwork.

## 📁 Project Structure
```
├── AddressRegisterFile.v
├── AddressRegisterFileSimulation.v
├── ArithmeticLogicUnit.v
├── ArithmeticLogicUnitSimulation.v
├── ArithmeticLogicUnitSystem.v
├── ArithmeticLogicUnitSystemSimulation.v
├── DataRegister.v
├── DataRegisterSimulation.v
├── GroupMembers.xlsx
├── Helper.v
├── InstructionRegister.v
├── InstructionRegisterSimulation.v
├── Memory.v
├── RAM.mem
├── Register16bit.v
├── Register16bitSimulation.v
├── Register32bit.v
├── Register32bitSimulation.v
├── RegisterFile.v
├── RegisterFileSimulation.v
├── Report.pdf
└── Run.bat
```
