namespace Simons {

    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Arithmetic;
    open Microsoft.Quantum.Preparation;
    open Microsoft.Quantum.Measurement;

    // given a mystery circuit, learn something about the function that is being implemented
    // given a quantum circuit given f, find secret properties that f has by looking at superpositons.
    // now we dont need to look at up to half the values of x, since we are looking at a single superposition.
    // F -> Qf 
    // F : {0, 1}^n  -> {0, 1}^m (imagine this as mapping vowels a color map)

    // n = 3
    // x | F(x)
    // 000 | Red
    // 001 | yellow
    // 010 | blue
    // 011 | green
    // 100 | yellow
    // 101 | red
    // 110 | green
    // 111 | blue

    //L = 101 
    // 001 (yellow) + 101 (L) = 100 (yellow)
    // F(x+L) = F(x)
    // F(x+L + L) = F(x+L) = F(x)
    // F gives same color value to all x and x+L pairs.
    
    // 001 is highest repition rate, highest frequency
    // 111 is lowest repition rate, lowest frequency

    // L-periodic F uses exactly 2^n/2 = N/2 colors.
    // 2^3/2 = 4 colors.

    // Imagine L is chosen random, and F is random subject to L periodicity.
    // 1/sqrt(8) * [
    // |000> |red> + 
    // |001> |yellow> + 
    // |010> |blue> + 
    // |011> |green> + 
    // |100> |yellow> + 
    // |101> |red> + 
    // |110> |green> + 
    // |111> |blue>]

    // 001 + 101 = 100 (L = 101)

    //Special Property - Periodicity
    // F assumed to be "L-periodic" for some "secret" string L: {0, 1}^n
    
    // F is "L-periodic" for L =/= 00..0
    // F(x+L) = F(x)
    //L = 101

    //returns the mod-2 dot product of the value and the secret string L
    operation quantum_simons_algorithm (
        op: ((Qubit[], Qubit[]) => Unit),
        input_size : Int
    ) : Result[] {
        use input_qubits = Qubit[input_size];
        use output_qubits = Qubit[input_size];

        ApplyToEach(H, input_qubits);
        op(input_qubits, output_qubits);
        ApplyToEach(H, input_qubits);

        let results = MultiM(input_qubits);
        ResetAll(input_qubits);
        ResetAll(output_qubits);
        return results;
    }

    //If we draw same color in a row every time we have the highest frequency
    //This should be equal to L = 001 
    // So if red was first draw   
    // |000> |red> + 
    // |001> |red> + 
    // |010> |blue> + 
    // |011> |blue> + 
    // |100> |green> + 
    // |101> |green> + 
    // |110> |yellow> + 
    // |111> |yellow>]

    // This is equal to
    // CNOTT(0 0 target:1)

    operation high_freq_draw(input : Qubit[], output : Qubit[]) : Unit
    {
            CNOT(input[0], output[0]);
    }



    // L = 111
    // If L is 111 and red is first draw then 
    // |000> |red> + 
    // |001> |blue> + 
    // |010> |green> + 
    // |011> |yellow> + 
    // |100> |yellow> + 
    // |101> |green> + 
    // |110> |blue> + 
    // |111> |red>]
    operation low_freq_draw (input : Qubit[], output : Qubit[]) : Unit
    {
        for i in 0 .. Length(input) - 1 {
            CNOT(input[i], output[i]);
        }
    }


    // L = 001
    // If L is 001 and red is first draw then 
    // |000> |red> + 
    // |001> |red> + 
    // |010> |green> + 
    // |011> |green> + 
    // |100> |blue> + 
    // |101> |blue> + 
    // |110> |yellow> + 
    // |111> |yellow>]
    operation LeftShiftBy1 (input : Qubit[], output : Qubit[]) : Unit {
        // Start at input[1]
        for inputIndex in 1 .. Length(input) - 1 {
            // Copy input[i] to output[i-1]
            let outputIndex = inputIndex - 1;
            CNOT(input[inputIndex], output[outputIndex]);
        }
    }
}