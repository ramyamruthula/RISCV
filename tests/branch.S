#include "riscv_test.h"
#include "test_macros.h"

RVTEST_RV64U
RVTEST_CODE_BEGIN

    # Read mcycle and minstret before execution
    csrr t0, mcycle
    csrr t1, minstret
    sd t0, cycle_before
    sd t1, instret_before

branch_test:

    # Load addresses of data
    la x21, _data1
    la x22, _data2
    la x23, _data3

    # Load data from memory addresses
    lw a0, 0(x21)
    lw a1, 0(x22)
    lw a2, 0(x23)

    # Add the two loaded values
    add x5, a0, a1

    # Check if the sum is equal to the third value
    bne a2, x5, fail

    # Read mcycle and minstret after execution
    csrr t2, mcycle
    csrr t3, minstret
    sd t2, cycle_after
    sd t3, instret_after

    RVTEST_PASS

fail:
    RVTEST_FAIL

RVTEST_CODE_END

.data
_data1:
    .word 0x5
_data2:
    .word 0x7
_data3:
    .word 0xC

RVTEST_DATA_BEGIN
    .align 3

result:
    .dword -1

# CSR result placeholders
cycle_before:
    .dword 0
instret_before:
    .dword 0
cycle_after:
    .dword 0
instret_after:
    .dword 0

RVTEST_DATA_END

