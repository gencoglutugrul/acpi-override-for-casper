/*
 * Intel ACPI Component Architecture
 * AML/ASL+ Disassembler version 20200717 (64-bit version)
 * Copyright (c) 2000 - 2020 Intel Corporation
 * 
 * Disassembling to symbolic ASL+ operators
 *
 * Disassembly of ssdt4.dat, Mon Oct  5 21:31:51 2020
 *
 * Original Table Header:
 *     Signature        "SSDT"
 *     Length           0x00000B27 (2855)
 *     Revision         0x02
 *     Checksum         0x79
 *     OEM ID           "CASPER"
 *     OEM Table ID     "ERA     "
 *     OEM Revision     0x00000000 (0)
 *     Compiler ID      "ACPI"
 *     Compiler Version 0x00040000 (262144)
 */
DefinitionBlock ("", "SSDT", 2, "CASPER", "ERA     ", 0x00000000)
{
    External (_SB_.PCI0.XHC_.RHUB, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS01, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS02, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS03, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS04, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS05, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS06, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS07, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS08, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS09, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.HS10, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS01, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS02, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS03, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS04, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS05, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.SS06, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.USR1, DeviceObj)
    External (_SB_.PCI0.XHC_.RHUB.USR2, DeviceObj)
    External (GPRW, MethodObj)    // 2 Arguments
    External (IVAD, IntObj)
    External (IVPR, IntObj)
    External (IVRS, IntObj)
    External (IVWS, IntObj)
    External (PID0, IntObj)
    External (TCTP, IntObj)

    Scope (\_SB.PCI0.XHC.RHUB)
    {
        Method (GPLD, 2, Serialized)
        {
            Name (PCKG, Package (0x01)
            {
                Buffer (0x10){}
            })
            CreateField (DerefOf (PCKG [Zero]), Zero, 0x07, REV)
            REV = One
            CreateField (DerefOf (PCKG [Zero]), 0x40, One, VISI)
            VISI = Arg0
            CreateField (DerefOf (PCKG [Zero]), 0x57, 0x08, GPOS)
            GPOS = Arg1
            Return (PCKG) /* \_SB_.PCI0.XHC_.RHUB.GPLD.PCKG */
        }

        Method (TPLD, 2, Serialized)
        {
            Name (PCKG, Package (0x01)
            {
                Buffer (0x10){}
            })
            CreateField (DerefOf (PCKG [Zero]), Zero, 0x07, REV)
            REV = One
            CreateField (DerefOf (PCKG [Zero]), 0x40, One, VISI)
            VISI = Arg0
            CreateField (DerefOf (PCKG [Zero]), 0x57, 0x08, GPOS)
            GPOS = Arg1
            CreateField (DerefOf (PCKG [Zero]), 0x4A, 0x04, SHAP)
            SHAP = One
            CreateField (DerefOf (PCKG [Zero]), 0x20, 0x10, WID)
            WID = 0x08
            CreateField (DerefOf (PCKG [Zero]), 0x30, 0x10, HGT)
            HGT = 0x03
            Return (PCKG) /* \_SB_.PCI0.XHC_.RHUB.TPLD.PCKG */
        }

        Method (GUPC, 1, Serialized)
        {
            Name (PCKG, Package (0x04)
            {
                Zero, 
                0xFF, 
                Zero, 
                Zero
            })
            PCKG [Zero] = Arg0
            Return (PCKG) /* \_SB_.PCI0.XHC_.RHUB.GUPC.PCKG */
        }

        Method (CUPC, 1, Serialized)
        {
            Name (CCKG, Package (0x04)
            {
                Zero, 
                0x0A, 
                Zero, 
                Zero
            })
            CCKG [Zero] = Arg0
            Return (CCKG) /* \_SB_.PCI0.XHC_.RHUB.CUPC.CCKG */
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS01)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, One))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS02)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, 0x02))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS03)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, 0x03))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS04)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If ((0x08 == (\PID0 & 0x08)))
            {
                Return (GUPC (One))
            }
            Else
            {
                Return (GUPC (Zero))
            }
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            If ((0x08 == (\PID0 & 0x08)))
            {
                Return (GPLD (One, 0x04))
            }
            Else
            {
                Return (GPLD (Zero, Zero))
            }
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS05)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x05))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS06)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, Zero))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS07)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x07))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS08)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If ((0x08 == (\PID0 & 0x08)))
            {
                Return (CUPC (One))
            }
            Else
            {
                Return (GUPC (Zero))
            }
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            If ((0x08 == (\PID0 & 0x08)))
            {
                Return (GPLD (One, 0x08))
            }
            Else
            {
                Return (GPLD (Zero, Zero))
            }
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS09)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If (((\TCTP == One) || (\TCTP == 0x02)))
            {
                Return (GUPC (One))
            }
            Else
            {
                Return (GUPC (Zero))
            }
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            If (((\TCTP == One) || (\TCTP == 0x02)))
            {
                Return (GPLD (Zero, 0x09))
            }
            Else
            {
                Return (GPLD (Zero, Zero))
            }
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.HS10)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, 0x0A))
        }

        Device (WCAM)
        {
            Name (_ADR, 0x0A)  // _ADR: Address
            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Name (UPCP, Package (0x04)
                {
                    0xFF, 
                    0xFF, 
                    Zero, 
                    Zero
                })
                Return (UPCP) /* \_SB_.PCI0.XHC_.RHUB.HS10.WCAM._UPC.UPCP */
            }

            Method (_PLD, 0, Serialized)  // _PLD: Physical Location of Device
            {
                Name (PLDP, Package (0x01)
                {
                    Buffer (0x14)
                    {
                        /* 0000 */  0x82, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                        /* 0008 */  0x25, 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // %.......
                        /* 0010 */  0xC8, 0x00, 0xA0, 0x00                           // ....
                    }
                })
                Return (PLDP) /* \_SB_.PCI0.XHC_.RHUB.HS10.WCAM._PLD.PLDP */
            }
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.USR1)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, Zero))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.USR2)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, Zero))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS01)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, One))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS02)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (One))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (One, 0x02))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS03)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If ((0x08 == (\PID0 & 0x08)))
            {
                Return (GUPC (One))
            }
            Else
            {
                Return (GUPC (Zero))
            }
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            If ((0x08 == (\PID0 & 0x08)))
            {
                Return (GPLD (One, 0x04))
            }
            Else
            {
                Return (GPLD (Zero, Zero))
            }
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS04)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            If ((0x08 == (\PID0 & 0x08)))
            {
                Return (CUPC (One))
            }
            Else
            {
                Return (GUPC (Zero))
            }
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            If ((0x08 == (\PID0 & 0x08)))
            {
                Return (GPLD (One, 0x08))
            }
            Else
            {
                Return (GPLD (Zero, Zero))
            }
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS05)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, Zero))
        }
    }

    Scope (\_SB.PCI0.XHC.RHUB.SS06)
    {
        Method (_UPC, 0, NotSerialized)  // _UPC: USB Port Capabilities
        {
            Return (GUPC (Zero))
        }

        Method (_PLD, 0, NotSerialized)  // _PLD: Physical Location of Device
        {
            Return (GPLD (Zero, Zero))
        }

        Method (IV01, 1, Serialized)
        {
            Name (UPCP, Package (0x04)
            {
                0xFF, 
                0xFF, 
                Zero, 
                Zero
            })
            Return (UPCP) /* \_SB_.PCI0.XHC_.RHUB.SS06.IV01.UPCP */
        }

        Method (IV02, 1, Serialized)
        {
            Name (PLDP, Package (0x01)
            {
                Buffer (0x14)
                {
                    /* 0000 */  0x82, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,  // ........
                    /* 0008 */  0x24, 0x81, 0x80, 0x03, 0x00, 0x00, 0x00, 0x00,  // $.......
                    /* 0010 */  0xFF, 0xFF, 0xFF, 0xFF                           // ....
                }
            })
            CreateField (DerefOf (PLDP [Zero]), 0x73, 0x04, ROTA)
            CreateField (DerefOf (PLDP [Zero]), 0x80, 0x10, VOFF)
            CreateField (DerefOf (PLDP [Zero]), 0x90, 0x10, HOFF)
            ROTA = \IVRS /* External reference */
            If ((Arg0 == Zero))
            {
                Switch (ToInteger (\IVRS))
                {
                    Case (Zero)
                    {
                        VOFF = 0xC2
                        HOFF = 0x9E
                    }
                    Case (0x02)
                    {
                        VOFF = 0x9E
                        HOFF = 0xC2
                    }
                    Case (0x04)
                    {
                        VOFF = 0xC2
                        HOFF = 0x9E
                    }
                    Case (0x06)
                    {
                        VOFF = 0x9E
                        HOFF = 0xC2
                    }

                }
            }
            ElseIf ((Arg0 == One))
            {
                Switch (ToInteger (\IVRS))
                {
                    Case (Zero)
                    {
                        VOFF = 0xC2
                        HOFF = 0x86
                    }
                    Case (0x02)
                    {
                        VOFF = 0x86
                        HOFF = 0xC2
                    }
                    Case (0x04)
                    {
                        VOFF = 0xC2
                        HOFF = 0x86
                    }
                    Case (0x06)
                    {
                        VOFF = 0x86
                        HOFF = 0xC2
                    }

                }
            }

            Return (PLDP) /* \_SB_.PCI0.XHC_.RHUB.SS06.IV02.PLDP */
        }

        Device (CRGB)
        {
            Method (_STA, 0, Serialized)  // _STA: Status
            {
                Return (\IVPR) /* External reference */
            }

            Method (_ADR, 0, Serialized)  // _ADR: Address
            {
                Return (\IVAD) /* External reference */
            }

            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Return (IV01 (Zero))
            }

            Method (_PLD, 0, Serialized)  // _PLD: Physical Location of Device
            {
                Return (IV02 (Zero))
            }
        }

        Device (CDPT)
        {
            Method (_STA, 0, Serialized)  // _STA: Status
            {
                Return (\IVPR) /* External reference */
            }

            Method (_ADR, 0, Serialized)  // _ADR: Address
            {
                Return ((\IVAD + 0x02))
            }

            Method (_UPC, 0, Serialized)  // _UPC: USB Port Capabilities
            {
                Return (IV01 (One))
            }

            Method (_PLD, 0, Serialized)  // _PLD: Physical Location of Device
            {
                Return (IV02 (One))
            }
        }

        Method (_PRW, 0, Serialized)  // _PRW: Power Resources for Wake
        {
            If ((\IVWS == One))
            {
                Return (GPRW (0x6D, 0x04))
            }
            Else
            {
                Return (Package (0x02)
                {
                    Zero, 
                    Zero
                })
            }
        }

        Method (_S3D, 0, Serialized)  // _S3D: S3 Device State
        {
            If ((\IVWS == One))
            {
                Return (0x02)
            }
            Else
            {
                Return (0x03)
            }
        }

        Method (_S3W, 0, Serialized)  // _S3W: S3 Device Wake State
        {
            If ((\IVWS == One))
            {
                Return (0x02)
            }
            Else
            {
                Return (0x03)
            }
        }

        Method (_S4D, 0, Serialized)  // _S4D: S4 Device State
        {
            If ((\IVWS == One))
            {
                Return (0x02)
            }
            Else
            {
                Return (0x03)
            }
        }

        Method (_S4W, 0, Serialized)  // _S4W: S4 Device Wake State
        {
            If ((\IVWS == One))
            {
                Return (0x02)
            }
            Else
            {
                Return (0x03)
            }
        }
    }
}

