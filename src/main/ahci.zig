const std = @import("std");

const FisType = enum(u32) {
    FIS_TYPE_REG_H2D = 0x27, // Register FIS - host to device
    FIS_TYPE_REG_D2H = 0x34, // Register FIS - device to host
    FIS_TYPE_DMA_ACT = 0x39, // DMA activate FIS - device to host
    FIS_TYPE_DMA_SETUP = 0x41, // DMA setup FIS - bidirectional
    FIS_TYPE_DATA = 0x46, // Data FIS - bidirectional
    FIS_TYPE_BIST = 0x58, // BIST activate FIS - bidirectional
    FIS_TYPE_PIO_SETUP = 0x5F, // PIO setup FIS - device to host
    FIS_TYPE_DEV_BITS = 0xA1, // Set device bits FIS - device to host
};

const FISRegHostToDevice = packed struct {
    // DWORD 0
    fis_type: u8, // FIS_TYPE_REG_H2D

    // Bitfields for pmport, rsv0, and c
    pmport: u4, // Port multiplier
    rsv0: u3, // Reserved
    c: u1, // 1: Command, 0: Control

    command: u8, // Command register
    featurel: u8, // Feature register, 7:0

    // DWORD 1
    lba0: u8, // LBA low register, 7:0
    lba1: u8, // LBA mid register, 15:8
    lba2: u8, // LBA high register, 23:16
    device: u8, // Device register

    // DWORD 2
    lba3: u8, // LBA register, 31:24
    lba4: u8, // LBA register, 39:32
    lba5: u8, // LBA register, 47:40
    featureh: u8, // Feature register, 15:8

    // DWORD 3
    countl: u8, // Count register, 7:0
    counth: u8, // Count register, 15:8
    icc: u8, // Isochronous command completion
    control: u8, // Control register

    // DWORD 4
    rsv1: [4]u8, // Reserved
};

const FISRegDeviceToHost = packed struct {
    // DWORD 0
    fis_type: u8, // FIS_TYPE_REG_H2D

    // Bitfields for pmport, rsv0, and c
    pmport: u4, // Port multiplier
    rsv0: u2, // Reserved
    i: u1, // Interrupt bit
    rsv1: u1, // Reserved

    status: u8, // Status register
    err: u8, // Error register, 7:0

    // DWORD 1
    lba0: u8, // LBA low register, 7:0
    lba1: u8, // LBA mid register, 15:8
    lba2: u8, // LBA high register, 23:16
    device: u8, // Device register

    // DWORD 2
    lba3: u8, // LBA register, 31:24
    lba4: u8, // LBA register, 39:32
    lba5: u8, // LBA register, 47:40
    rsv2: u8, // Reserved

    // DWORD 3
    countl: u8, // Count register, 7:0
    counth: u8, // Count register, 15:8
    rsv3: [2]u8, // Reserved

    // DWORD 4
    rsv4: [4]u8, // Reserved
};


const FISData = struct {
    // DWORD 0
    fis_type: u8,	// FIS_TYPE_DATA

    pmport: u4,	// Port multiplier
    rsv0: u4,		// Reserved

    rsv1: u8[2],	// Reserved

    // DWORD 1 ~ N
    data: u32[1],	// Payload
};

const FISProgrammedIOSetup = packed struct {
    // DWORD 0
    fis_type: u8,  // FIS_TYPE_PIO_SETUP

    // Bitfields for pmport, rsv0, d, i, and rsv1
    pmport: u4,   // Port multiplier
    rsv0: u1,     // Reserved
    d: u1,        // Data transfer direction, 1 - device to host
    i: u1,        // Interrupt bit
    rsv1: u1,     // Reserved

    status: u8,   // Status register
    err: u8,    // Error register

    // DWORD 1
    lba0: u8,     // LBA low register, 7:0
    lba1: u8,     // LBA mid register, 15:8
    lba2: u8,     // LBA high register, 23:16
    device: u8,   // Device register

    // DWORD 2
    lba3: u8,     // LBA register, 31:24
    lba4: u8,     // LBA register, 39:32
    lba5: u8,     // LBA register, 47:40
    rsv2: u8,     // Reserved

    // DWORD 3
    countl: u8,   // Count register, 7:0
    counth: u8,   // Count register, 15:8
    rsv3: u8,     // Reserved
    e_status: u8, // New value of status register

    // DWORD 4
    tc: u16,      // Transfer count
    rsv4: [2]u8,  // Reserved
};

const FISDirectMemAccessSetup = packed struct {
    // DWORD 0
    fis_type: u8,  // FIS_TYPE_DMA_SETUP

    // Bitfields for pmport, rsv0, d, i, and a
    pmport: u4,   // Port multiplier
    rsv0: u1,     // Reserved
    d: u1,        // Data transfer direction, 1 - device to host
    i: u1,        // Interrupt bit
    a: u1,        // Auto-activate. Specifies if DMA Activate FIS is needed

    rsved: [2]u8, // Reserved

    // DWORD 1 & 2
    DMAbufferID: u64, // DMA Buffer Identifier

    // DWORD 3
    rsvd: u32,  // More reserved

    // DWORD 4
    DMAbufOffset: u32, // Byte offset into buffer. First 2 bits must be 0

    // DWORD 5
    TransferCount: u32, // Number of bytes to transfer. Bit 0 must be 0

    // DWORD 6
    resvd: u32, // Reserved
};

// TODO get the PCI device and init the SATA controller