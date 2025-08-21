# Single-Cycle RISC-V RV32I CPU

## Repository Structure
- src/ -- contains entities
- tb/ -- contains test benches

## Top-Level Entity ([`cpu.vhd`](src/cpu.vhd))
### Datapath Blocks
- instruction_mem: fetches 32-bit instruction at pc
- register_file: 32 registers, 2 read + 1 write ports
- control_unit: decodes instructions & generates control signals
- sign_extender: decodes/extends immediates
- alu: computes arithmetic/logic
- data_memory: load/store support 
- write_back_mux: selects write back for register file
- program_counter: updates pc (jump + branch support)

## ISA supported
### ALU Operations
- **R-type:** ADD, SUB, SLL, SLT, SLTU, XOR, SRL, SRA, OR, AND
- **I-type:** ADDI, SLLI, SLTI, SLTIU, XORI, SRLI, SRAI, ORI, ANDI

### Loads / Stores
- **Load (I-type):** LW
- **Store (S-type):** SW

### Control Flow
- **Jump (J-type):** JAL
- **Branch (B-type):** BEQ  

