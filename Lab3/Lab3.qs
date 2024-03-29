// Quantum Software Development
// Lab 3: Multi-Qubit Gates
// Copyright 2023 The MITRE Corporation. All Rights Reserved.
//
// Due 2/6 at 6:00PM ET:
//  - Completed exercises and evidence of unit tests passing uploaded to GitHub.
//
// Note this assignment contains extra credit problems.

namespace Lab3 {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Diagnostics;

    /// # Summary
    /// In this exercise, you are given two qubits. Both qubits are in
    /// arbitrary, unknown states:
    ///
    ///     |qubitA> = a|0> + b|1>
    ///     |qubitB> = c|0> + d|1>
    ///
    /// Use the two-qubit gates in Q# to switch their amplitudes, so
    /// this is the end result:
    ///
    ///     |qubitA> = c|0> + d|1>
    ///     |qubitB> = a|0> + b|1>
    ///
    /// # Input
    /// ## qubitA
    /// The first qubit, which starts in the state a|0> + b|1>.
    ///
    /// ## qubitB
    /// The second qubit, which starts in the state c|0> + d|1>.
    ///
    /// # Remarks
    /// This investigates how to apply quantum gates that take more than one
    /// qubit.
    operation Exercise1 (qubitA : Qubit, qubitB : Qubit) : Unit {
        // Hint: you can do this with a single statement, using one gate.

        SWAP(qubitA, qubitB);
    }


    /// # Summary
    /// In this exercise, you're given a register of qubits with unknown
    /// length. Each qubit is in an arbitrary, unknown state. Your goal
    /// is to reverse the register, so the order of qubits is reversed.
    ///
    /// For example, if the register had 3 qubits where:
    ///
    ///     |register[0]> = a|0> + b|1>
    ///     |register[1]> = c|0> + d|1>
    ///     |register[2]> = e|0> + f|1>
    ///
    /// Your goal would be to modify the qubits in the register so that
    /// the qubit's states are reversed:
    ///
    ///     |register[0]> = e|0> + f|1>
    ///     |register[1]> = c|0> + d|1>
    ///     |register[2]> = a|0> + b|1>
    ///
    /// Note that the register itself is immutable, so you can't just reorder
    /// the elements like you would in a classical array. For instance, you
    /// can't change the contents of register[0], you can only modify the state
    /// of the qubit at register[0] using quantum gates. In other words, you
    /// must reverse the register by reversing the states of the qubits
    /// themselves, without changing the actual order of the qubits in the
    /// register.
    ///
    /// # Input
    /// ## register
    /// The qubit register that you need to reverse.
    ///
    /// # Remarks
    /// This investigates the combination of arrays and multi-qubit gates.
    operation Exercise2 (register : Qubit[]) : Unit {
        
        
        let n = Length(register);

        Message($"Swapping {n} qubits.");

        for outer in 1 .. n-1 {
            for inner in outer .. -1 .. 1{
                SWAP(register[inner], register[inner-1]);
            }
        }
        // //n = 3

        //0-3
            // 3
                //swap 4 , 3
                //swap 3, 2
                //swap 2, 1
                //swap 1, 0
            //3
                //swap 3, 2
                //swap 2,1
                //swap 1,0
            //2
                //swap 2, 1
                //swap 1, 0
            //1 
                //swap 1, 0

        //swap 4,3 3,2 2,1 1,0
        //swap 4,3 3,2 2,1
        //swap 4,3 3,2
        //swap 4,3
    }


    /// # Summary
    /// In this exercise, you are given an array of qubit registers. There are
    /// four registers in the array, and each register contains two qubits. All
    /// eight qubits will be in the |0> state, so each register is in the state
    /// |00>.
    ///
    /// Your goal is to put the four registers into these four states:
    ///
    ///     |registers[0]> = 1/√2(|00> + |11>)
    ///     |registers[1]> = 1/√2(|00> - |11>)
    ///     |registers[2]> = 1/√2(|01> + |10>)
    ///     |registers[3]> = 1/√2(|01> - |10>)
    ///
    /// These four states are known as the Bell States. They are the simplest
    /// examples of full entanglement between two qubits.
    ///
    /// # Input
    /// ## registers
    /// An array of four two-qubit registers. All of the qubits are in the |0>
    /// state.
    ///
    /// # Remarks
    /// This investigates how to prepare the Bell states.
    operation Exercise3 (registers : Qubit[][]) : Unit {
        // Hint: you can start by putting all four registers into the state
        // 1/√2(|00> + |11>), then build the final state for each register 
        // from there.

        for register in registers{
            H(register[0]);
            CNOT(register[0], register[1]);
        }

        //First register is just raw Hadamard result of first bit CNOTTED with second qubit
       DumpRegister("qbit0.txt", registers[0]);

        //Second register has a qubit phase delayed
        Z(registers[1][1]);
        DumpRegister("qbit1.txt", registers[1]);

        //Third register has a qubit time reversed
        X(registers[2][0]);
        DumpRegister("qbit2.txt", registers[2]);

        //Fourth register has first qubit phase delayed and time reversed
        Z(registers[3][0]);
        X(registers[3][0]);
        DumpRegister("qbit3.txt", registers[3]);
    }


    /// # Summary
    /// In this exercise, you are given a qubit register of unknown length. All
    /// of the qubits in it are in the |0> state, so the whole register is in
    /// the state |0...0>.
    ///
    /// Your task is to transform this register into this state:
    ///
    ///     |register> = 1/√2(|0...0> + |1...1>)
    ///
    /// For example, if the register had 5 qubits, you would need to put it in
    /// the state 1/√2(|00000> + |11111>). These states are called the GHZ
    /// states.
    ///
    /// # Input
    /// ## register
    /// The qubit register. It is in the state |0...0>.
    ///
    /// # Remarks
    /// This will investigate how to prepare maximally entangled states for an
    /// arbitrary number of qubits.
    operation Exercise4 (register : Qubit[]) : Unit {
        let n = Length(register)-1;

        H(register[0]);
        for i in 1 .. n {
            CNOT(register[i-1], register[i]);
        }
        
        DumpRegister("Exercise4.txt", register);
    }


    /// # Summary
    /// In this exercise, you are given a qubit register of length four. All of
    /// its qubits are in the |0> state initially, so the whole register is in
    /// the state |0000>.
    /// Your goal is to put it into the following state:
    ///
    ///     |register> = 1/√2(|0101> - |0110>)
    ///
    /// # Input
    /// ## register
    /// The qubit register. It is in the state |0000>.
    ///
    /// # Remarks
    /// You will need to use the H, X, Z, and CNOT gates to achieve this.
    operation Exercise5 (register : Qubit[]) : Unit {
       
       H(register[3]);
       X(register[2]);
       CNOT(register[3], register[2]);
       Z(register[2]);
       X(register[1]);
       DumpRegister("Exercise5.txt", register);
    }


    /// # Summary
    /// In this exercise, you are given a register with two qubits in the |00>
    /// state. Your goal is to put it in this non-uniform superposition:
    ///
    ///     |register> = 1/√2*|00> + 1/2(|10> + |11>)
    ///
    /// Note that this state will have a 50% chance of being measured as |00>,
    /// a 25% chance of being measured as |10>, and a 25% chance of being
    /// measured as |11>.
    ///
    /// # Input
    /// ## register
    /// A register with two qubits in the |00> state.
    ///
    /// # Remarks
    /// This investigates applying controlled operations besides CNOT.
    operation Exercise6 (register : Qubit[]) : Unit {

        H(register[0]);
        Controlled H([register[0]], register[1]);

        DumpRegister("Exercise6.txt", register);
    }


    /// # Summary
    /// In this exercise, you are given a three-qubit register and an extra
    /// "target" qubit. All of the qubits are in the |0> state. Your goal is to
    /// put the register into a uniform superposition and then entangle it with
    /// the target qubit such that the target is a |1> when the register is
    /// |001>. To be more specific, you must prepare this state:
    ///
    ///     |register,target> = 1/√8(|000,0> + |001,1> + |010,0> + |011,0>
    ///                            + |100,0> + |101,0> + |110,0> + |111,0>)
    ///
    /// # Input
    /// ## register
    /// A register of three qubits, in the |000> state.
    ///
    /// ## target
    /// A qubit in the |0> state. It should be |1> when the register is |001>.
    ///
    /// # Remarks
    /// This investigates how to implement zero-controlled (a.k.a. anti-
    /// controlled) gates in Q#.
    operation Exercise7 (register : Qubit[], target: Qubit) : Unit {
        let n = Length(register)-1;

        for i in 0 .. n {
            H(register[i]);
        }
        
        Controlled X(register[0..n], target);
        X(register[0]);
        X(register[1]);

        DumpRegister("Exercise7.txt", [register[0],register[1],register[2], target]);
        
    }


    /// # Summary
    /// In this exercise, you are given a three-qubit register in the |000>
    /// state. Your goal is to transform it into this uneven superposition:
    ///
    ///     |register> = 1/√2*|000> + 1/2(|111> - |100>)
    ///
    /// # Input
    /// ## register
    /// A register with three qubits in the |000> state.
    ///
    /// # Remarks
    /// This is a challenging problem that combines all the concepts covered
    /// so far:
    ///  - Quantum superposition
    ///  - Quantum entanglement
    ///  - Qubit registers
    ///  - Single- and multi-qubit gates
    ///  - Phase
    operation Exercise8 (register : Qubit[]) : Unit {
        
        H(register[0]);
        Controlled X([register[0]], register[1]);
        Controlled Z([register[0]], register[1]);
        Controlled H([register[0]], register[1]);
        CNOT(register[1], register[2]);
        
        DumpRegister("Exercise8.txt", register);
    }


    //////////////////////////////////
    /// === CHALLENGE PROBLEMS === ///
    //////////////////////////////////

    // The problems below are especially challening. 5% extra credit is awarded
    // for each problem attempted, and 10% for each implemented correctly.


    /// # Summary
    /// In this problem, you are given a two-qubit register in the |00> state.
    /// Your goal is to put it into this superposition:
    ///
    ///     |register> = 1/√3(|00> + |01> + |10>)
    ///
    /// Note that all three states have equal amplitude.
    ///
    /// # Input
    /// ## register
    /// A two-qubit register in the |00> state.
    operation Challenge1 (register : Qubit[]) : Unit {

        use scratch = Qubit();
        mutable measurement = Zero;
        repeat{
            Reset(scratch);
            ResetAll(register);
            H(register[0]);
            H(register[1]);
            CCNOT(register[0], register[1], scratch);
            set measurement = M(scratch);
        }
        until measurement == Zero
        fixup{}

        DumpRegister("Challenge1.txt", [register[0], register[1]]);
    }


    /// # Summary
    /// In this problem, you are given a three-qubit register in the |000>
    /// state. Your goal is to put it into this superposition:
    ///
    ///     |register> = 1/√3(|100> + |010> + |001>)
    ///
    /// Note that all states have equal amplitude. This is known as the
    /// three-qubit "W State".
    ///
    /// # Input
    /// ## register
    /// A three-qubit register in the |000> state.
    operation Challenge2 (register : Qubit[]) : Unit {
        use scratch1 = Qubit();
        use scratch2 = Qubit();
        use scratch3 = Qubit();
        use scratch4 = Qubit();
        use scratch5 = Qubit();
        mutable m1 = Zero;
        mutable m2 = Zero;
        mutable m3 = Zero;
        mutable m4 = Zero;
        mutable m5 = Zero;
        repeat{
            ResetAll([scratch1, scratch2, scratch3]);
            ResetAll(register);
            H(register[0]);
            H(register[1]);
            H(register[2]);

            //all zero?
            Controlled X(register[0..2], scratch5);
            X(register[0]);
            X(register[1]);
            X(register[2]);

            // all one?
            Controlled X(register[0..2], scratch1);

            //two ones?
            Controlled X(register[0..1], scratch2);
            Controlled X(register[1..2], scratch3);
            Controlled X([register[0], register[2]], scratch4);


            set m1 = M(scratch1);
            set m2 = M(scratch2);
            set m3 = M(scratch3);
            set m4 = M(scratch4);
            set m5 = M(scratch5);
        }
        until m1 == Zero and m2 == Zero and m3 == Zero and m4 == Zero and m5 == Zero
        fixup{}

        DumpRegister("Challenge2.txt", register);
    }


    /// # Summary
    /// In this problem, you are given a three-qubit register in the |000>
    /// state. Your goal is to encode 8 samples of a sine wave into its
    /// amplitude. The samples should be evenly spaced in π/4 increments,
    /// starting with 0 and ending with 7π/4. The sine wave samples are laid
    /// out in the table below:
    ///
    ///  Index  |  Value
    /// ------- | -------
    ///    0    |    0
    ///    1    |   1/√2
    ///    2    |    1
    ///    3    |   1/√2
    ///    4    |    0
    ///    5    |  -1/√2
    ///    6    |   -1
    ///    7    |  -1/√2
    ///
    /// Note that these samples are not normalized; if they were used as state
    /// amplitudes, they would result in a total probability greater than 1.
    ///
    /// Your first task is to normalize the sine wave samples so they can be
    /// used as state amplitudes. Your second task is to encode these 8
    /// normalized values as the amplitudes of the three-qubit register.
    ///
    /// # Input
    /// ## register
    /// A three-qubit register in the |000> state.
    ///
    /// # Remarks
    /// This kind of challenge is common in quantum computing. Essentially, you
    /// need to construct an efficient circuit that will take real data and
    /// encode it into the superposition of a qubit register. Normally, it
    /// would take 8 doubles to store these values in conventional memory - a
    /// total of 512 classical bits. You're going to encode the exact same data
    /// in 3 qubits. We'll talk more about how quantum computers do things
    /// faster than classical computers once we get to quantum algorithms, but
    /// this is a good first hint.
    operation Challenge3 (register : Qubit[]) : Unit {
        // TODO
        fail "Not implemented.";
    }


    /// # Summary
    /// This problem is the same as Challenge 3, but now you must construct a
    /// superposition using 8 samples of a cosine wave instead of a sine wave.
    /// For your convenience, the cosine samples are listed in this table:
    ///
    ///  Index  |  Value
    /// ------- | -------
    ///    0    |    1
    ///    1    |   1/√2
    ///    2    |    0
    ///    3    |  -1/√2
    ///    4    |   -1
    ///    5    |  -1/√2
    ///    6    |    0
    ///    7    |   1/√2
    ///
    /// Once again, these values aren't normalized, so you will have to
    /// normalize them before using them as state amplitudes.
    ///
    /// # Input
    /// ## register
    /// A three-qubit register in the |000> state.
    operation Challenge4 (register : Qubit[]) : Unit {
        // TODO
        fail "Not implemented.";
    }
}
