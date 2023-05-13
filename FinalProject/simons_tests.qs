namespace Simons {

    open Microsoft.Quantum.Core;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Random;
    open Microsoft.Quantum.Arrays;
    open Microsoft.Quantum.Math;

    operation example_oracle (input : Qubit[], output : Qubit[]) : Unit
    {
        for i in 0 .. Length(input) - 1 {
            CNOT(input[i], output[i]);
        }
    }

    // Function to check if a matrix has linearly independent rows
    function IsLinearlyIndependent(matrix : Int[][]) : Bool {
        let numRows = Length(matrix);
        let numCols = Length(matrix[0]);

        // Gaussian elimination
        mutable col = 0;
        mutable pivotFound = false;
        mutable current_matrix = matrix;
        repeat {
            set pivotFound = false;
            for row in col..numRows - 1 {
                if (matrix[row][col] == 1) {
                    set pivotFound = true;
                    // Swap rows if necessary
                    if (row != col) {
                        set current_matrix = SwapRows(matrix, col, row);
                    }

                    // Make sure all other rows have a 0 in the pivot column
                    for otherRow in 0..numRows - 1 {
                        if (otherRow != col and matrix[otherRow][col] == 1) {
                            set current_matrix w/=otherRow <- AddVectors(matrix[otherRow], matrix[col]);
                        }
                    }
                }
            }
            set col = col + 1;
        }
        until (pivotFound or col >= numCols);

        return col == numCols;
    }


    // Function to add two binary vectors
    function AddVectors(a : Int[], b : Int[]) : Int[] {
        return Mapped(Mod2Add, Zip(a, b));
    }

    // Function to perform modulo 2 addition
    function Mod2Add(pair : (Int, Int)) : Int {
        let (a,b) = pair;
        return (a+b) % 2;
    }

    // Function to swap two rows in a matrix
    function SwapRows(matrix : Int[][], row1 : Int, row2 : Int) : Int[][] {
        mutable newMatrix = matrix;
        set newMatrix w/= row1 <- matrix[row2];
        set newMatrix w/= row2 <- matrix[row1];
        return newMatrix;
    }

    function ResultAsInt(result : Result): Int{
        let int_result = result == One ? 1 | 0;
        return int_result;
    }

    // Function to convert an array of Results to an array of integers
    function ResultArrayAsInts(results : Result[]) : Int[] {
        return Mapped(ResultAsInt, results);
    }

    function EqualArrays(arr1 : Int[], arr2 : Int[]) : Bool {
        if (Length(arr1) != Length(arr2)) {
            return false;
        }
        for (i in 0..Length(arr1) - 1) {
            if (arr1[i] != arr2[i]) {
                return false;
            }
        }
        return true;
    }

    // Function to check if a matrix contains an array of integers
    function ContainsArray(matrix : Int[][], array : Int[]) : Bool {
        return Any(EqualArrays(_, array), matrix);
    }

    function CountOccurrences(s: Int[], arr: Int[][]) : Int {
        return Length(Filtered(EqualArrays(s, _), arr));
    }

    function IndexOfMax(arr: Int[]) : Int {
        mutable maxIndex = 0;
        mutable maxValue = arr[0];
        for (i in 1..Length(arr) - 1) {
            if (arr[i] > maxValue) {
                set maxIndex = i;
                set maxValue = arr[i];
            }
        }
        return maxIndex;
    }

    // Main operation of simon's algorithm
    operation SimonsAlgorithm(
        op: ((Qubit[], Qubit[]) => Unit),
        n : Int,
        numRuns : Int
    ) : Int[] {
        mutable secretStrings = new Int[][0];
        for _ in 1..numRuns {
            mutable results = new Int[][0];

            repeat {
                let result = quantum_simons_algorithm(op, n);
                let resultAsInts = ResultArrayAsInts(result);
                if (not ContainsArray(results, resultAsInts)) {
                    let tempResults = results + [resultAsInts];
                    if (IsLinearlyIndependent(tempResults)) {
                        set results = tempResults;
                    }
                }
            }
            until (Length(results) == n - 1);

            // Perform Gaussian elimination to find s
            let s = AddVectors(results[0], results[1]);
            set secretStrings = secretStrings + [s];
        }

        // Find the most frequently occurring secret string
    // Find the most frequently occurring secret string
        mutable maxCount = 0;
        mutable mostFrequentSecretString = secretStrings[0];
        for s in secretStrings {
            let count = CountOccurrences(s, secretStrings);
            if (count > maxCount) {
                set maxCount = count;
                set mostFrequentSecretString = s;
            }
        }

        return mostFrequentSecretString;
    }

    @Test("QuantumSimulator")
    operation TestSimonsAlgorithm() : Unit {
        let expected_s = [0, 0, 1];
        let n = 3;
        let numRuns = 16;
        let s = SimonsAlgorithm(LeftShiftBy1, n, numRuns);

        AllEqualityFactI(s, expected_s, $"String {s} doesn't match expected {expected_s}");

        
        Message("Strings match");
    }
}
