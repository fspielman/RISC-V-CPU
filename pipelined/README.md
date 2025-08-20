# Pipelined RISC-V RV32I CPU

**5-Stage Pipeline** of the RISC-V RV32I CPU with hazard control
Extension to the **[`Single-Cycle CPU`](../single_cycle/)**

## Features 
- **Pipeline Stages:** Instruction Fetch(IF) | Instruction Decode(ID) | Execute(EX) | Memory(MEM) | Write Back(WB)
- **Hazard Handling**
  - **Forwarding:** forwarding from EX/MEM and MEM/WB to ALU inputs when following instruction depends on ALU result 
  - **Load-use Stalls:** stalls PC + IF/ID & flushes ID/EX if lw doesn't reach MEM (lw hasn't read yet)
  - **Branch Flushing:** predicts branch not taken & flushes IF/ID + ID/EX if branch is taken

## Repository Structure
- src/ -- contains entities
- tb/ -- contains testbenches

## Top-Level Entity (src/cpu.vhd)
### Datapath Blocks 
- Pipeline registers: registers to store signals from stages
  - if_id_register
  - id_ex_register
  - ex_mem_register
  - mem_wb_register
- hazard_unit: handles hazards (selects for forward handling muxes & pipeline register flushing/stalling for load-use stalls and branch flushing)
- mux3to1: for write back mux & forward hazard handling
- Shared with Single-Cycle
  - instruction_mem: fetches 32-bit instruction at pc
  - register_file: 32 registers, 2 read + 1 write ports
  - control_unit: decodes instructions & generates control signals
  - sign_extender: decodes/extends immediates
  - alu: computes arithmetic/logic
  - data_memory: load/store support 
  - write_back_mux: selects write back for register file
  - program_counter: updates pc (jump + branch support)
  
## ISA Supported (Same as Single-Cycle)
### ALU Operations
- **R-type:** ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
- **I-type:** ADDI, SLLI, SLTI, SLTIU, XORI, SRLI, SRAI, ORI, ANDI

### Loads / Stores
- **Load (I-type):** LW
- **Store (S-type):** SW

### Control Flow
- **Jump (J-type):** JAL
- **Branch (B-type):** BEQ 
